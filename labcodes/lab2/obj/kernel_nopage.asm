
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 cd 5b 00 00       	call   105c23 <memset>

    cons_init();                // init the console
  100056:	e8 71 15 00 00       	call   1015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 c0 5d 10 00 	movl   $0x105dc0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 dc 5d 10 00 	movl   $0x105ddc,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 4a 42 00 00       	call   1042ce <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 ac 16 00 00       	call   101735 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 fe 17 00 00       	call   10188c <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 ef 0c 00 00       	call   100d82 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 0b 16 00 00       	call   1016a3 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 f8 0b 00 00       	call   100cb4 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 e1 5d 10 00 	movl   $0x105de1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 ef 5d 10 00 	movl   $0x105def,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 fd 5d 10 00 	movl   $0x105dfd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 0b 5e 10 00 	movl   $0x105e0b,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 19 5e 10 00 	movl   $0x105e19,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 28 5e 10 00 	movl   $0x105e28,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 48 5e 10 00 	movl   $0x105e48,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 67 5e 10 00 	movl   $0x105e67,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 fe 12 00 00       	call   1015f8 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 05 51 00 00       	call   10543c <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 85 12 00 00       	call   1015f8 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 65 12 00 00       	call   101634 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 6c 5e 10 00    	movl   $0x105e6c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 6c 5e 10 00 	movl   $0x105e6c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 a8 70 10 00 	movl   $0x1070a8,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 70 1a 11 00 	movl   $0x111a70,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 71 1a 11 00 	movl   $0x111a71,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 b8 44 11 00 	movl   $0x1144b8,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 ab 53 00 00       	call   105a97 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 76 5e 10 00 	movl   $0x105e76,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 8f 5e 10 00 	movl   $0x105e8f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 ac 5d 10 	movl   $0x105dac,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 a7 5e 10 00 	movl   $0x105ea7,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 bf 5e 10 00 	movl   $0x105ebf,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 d7 5e 10 00 	movl   $0x105ed7,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 f0 5e 10 00 	movl   $0x105ef0,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 1a 5f 10 00 	movl   $0x105f1a,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 36 5f 10 00 	movl   $0x105f36,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// 循环打印，直到 STACKFRAME_DEPTH 栈的深度已经最大，并且还要满足ebp ！= 0
	int i;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	e9 88 00 00 00       	jmp    100a67 <print_stackframe+0xad>
		cprintf("ebp: 0x%08x eip: 0x%08x args: ", ebp, eip);
  1009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ed:	c7 04 24 48 5f 10 00 	movl   $0x105f48,(%esp)
  1009f4:	e8 43 f9 ff ff       	call   10033c <cprintf>

		// ebp + 2才是第一个参数的地址，具体可以看笔记
		uint32_t *args = (uint32_t *)ebp + 2;
  1009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fc:	83 c0 08             	add    $0x8,%eax
  1009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		// 循环打印4个args
		int j;
		for (j = 0; j < 4; j++) {
  100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a09:	eb 25                	jmp    100a30 <print_stackframe+0x76>
			cprintf("0x%08x ", args[j]);
  100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a18:	01 d0                	add    %edx,%eax
  100a1a:	8b 00                	mov    (%eax),%eax
  100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a20:	c7 04 24 67 5f 10 00 	movl   $0x105f67,(%esp)
  100a27:	e8 10 f9 ff ff       	call   10033c <cprintf>
		// ebp + 2才是第一个参数的地址，具体可以看笔记
		uint32_t *args = (uint32_t *)ebp + 2;

		// 循环打印4个args
		int j;
		for (j = 0; j < 4; j++) {
  100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a34:	7e d5                	jle    100a0b <print_stackframe+0x51>
			cprintf("0x%08x ", args[j]);
		}
		cprintf("\n");
  100a36:	c7 04 24 6f 5f 10 00 	movl   $0x105f6f,(%esp)
  100a3d:	e8 fa f8 ff ff       	call   10033c <cprintf>

		// 打印 kern/debug/kdebug.c:305: print_stackframe+22 类似这行的东西，应该是调试信息
		print_debuginfo(eip-1);
  100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a45:	83 e8 01             	sub    $0x1,%eax
  100a48:	89 04 24             	mov    %eax,(%esp)
  100a4b:	e8 b6 fe ff ff       	call   100906 <print_debuginfo>

		// 先把eip指向ebp+1的位置，即函数的返回地址（Return Address）
		eip = *((uint32_t *)ebp + 1);
  100a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a53:	83 c0 04             	add    $0x4,%eax
  100a56:	8b 00                	mov    (%eax),%eax
  100a58:	89 45 f0             	mov    %eax,-0x10(%ebp)

		// ebp的内容给ebp回到上层调用函数
		ebp = *((uint32_t *)ebp);
  100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5e:	8b 00                	mov    (%eax),%eax
  100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();

	// 循环打印，直到 STACKFRAME_DEPTH 栈的深度已经最大，并且还要满足ebp ！= 0
	int i;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
  100a63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a67:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a6b:	7f 0a                	jg     100a77 <print_stackframe+0xbd>
  100a6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a71:	0f 85 68 ff ff ff    	jne    1009df <print_stackframe+0x25>
		eip = *((uint32_t *)ebp + 1);

		// ebp的内容给ebp回到上层调用函数
		ebp = *((uint32_t *)ebp);
	}
}
  100a77:	c9                   	leave  
  100a78:	c3                   	ret    

00100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a79:	55                   	push   %ebp
  100a7a:	89 e5                	mov    %esp,%ebp
  100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a86:	eb 0c                	jmp    100a94 <parse+0x1b>
            *buf ++ = '\0';
  100a88:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8b:	8d 50 01             	lea    0x1(%eax),%edx
  100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a91:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a94:	8b 45 08             	mov    0x8(%ebp),%eax
  100a97:	0f b6 00             	movzbl (%eax),%eax
  100a9a:	84 c0                	test   %al,%al
  100a9c:	74 1d                	je     100abb <parse+0x42>
  100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa1:	0f b6 00             	movzbl (%eax),%eax
  100aa4:	0f be c0             	movsbl %al,%eax
  100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aab:	c7 04 24 f4 5f 10 00 	movl   $0x105ff4,(%esp)
  100ab2:	e8 ad 4f 00 00       	call   105a64 <strchr>
  100ab7:	85 c0                	test   %eax,%eax
  100ab9:	75 cd                	jne    100a88 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100abb:	8b 45 08             	mov    0x8(%ebp),%eax
  100abe:	0f b6 00             	movzbl (%eax),%eax
  100ac1:	84 c0                	test   %al,%al
  100ac3:	75 02                	jne    100ac7 <parse+0x4e>
            break;
  100ac5:	eb 67                	jmp    100b2e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ac7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100acb:	75 14                	jne    100ae1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100acd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad4:	00 
  100ad5:	c7 04 24 f9 5f 10 00 	movl   $0x105ff9,(%esp)
  100adc:	e8 5b f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae4:	8d 50 01             	lea    0x1(%eax),%edx
  100ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100af4:	01 c2                	add    %eax,%edx
  100af6:	8b 45 08             	mov    0x8(%ebp),%eax
  100af9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100afb:	eb 04                	jmp    100b01 <parse+0x88>
            buf ++;
  100afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b01:	8b 45 08             	mov    0x8(%ebp),%eax
  100b04:	0f b6 00             	movzbl (%eax),%eax
  100b07:	84 c0                	test   %al,%al
  100b09:	74 1d                	je     100b28 <parse+0xaf>
  100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0e:	0f b6 00             	movzbl (%eax),%eax
  100b11:	0f be c0             	movsbl %al,%eax
  100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b18:	c7 04 24 f4 5f 10 00 	movl   $0x105ff4,(%esp)
  100b1f:	e8 40 4f 00 00       	call   105a64 <strchr>
  100b24:	85 c0                	test   %eax,%eax
  100b26:	74 d5                	je     100afd <parse+0x84>
            buf ++;
        }
    }
  100b28:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b29:	e9 66 ff ff ff       	jmp    100a94 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b31:	c9                   	leave  
  100b32:	c3                   	ret    

00100b33 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b33:	55                   	push   %ebp
  100b34:	89 e5                	mov    %esp,%ebp
  100b36:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b39:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b40:	8b 45 08             	mov    0x8(%ebp),%eax
  100b43:	89 04 24             	mov    %eax,(%esp)
  100b46:	e8 2e ff ff ff       	call   100a79 <parse>
  100b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b52:	75 0a                	jne    100b5e <runcmd+0x2b>
        return 0;
  100b54:	b8 00 00 00 00       	mov    $0x0,%eax
  100b59:	e9 85 00 00 00       	jmp    100be3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b65:	eb 5c                	jmp    100bc3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b67:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b6d:	89 d0                	mov    %edx,%eax
  100b6f:	01 c0                	add    %eax,%eax
  100b71:	01 d0                	add    %edx,%eax
  100b73:	c1 e0 02             	shl    $0x2,%eax
  100b76:	05 20 70 11 00       	add    $0x117020,%eax
  100b7b:	8b 00                	mov    (%eax),%eax
  100b7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b81:	89 04 24             	mov    %eax,(%esp)
  100b84:	e8 3c 4e 00 00       	call   1059c5 <strcmp>
  100b89:	85 c0                	test   %eax,%eax
  100b8b:	75 32                	jne    100bbf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b90:	89 d0                	mov    %edx,%eax
  100b92:	01 c0                	add    %eax,%eax
  100b94:	01 d0                	add    %edx,%eax
  100b96:	c1 e0 02             	shl    $0x2,%eax
  100b99:	05 20 70 11 00       	add    $0x117020,%eax
  100b9e:	8b 40 08             	mov    0x8(%eax),%eax
  100ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ba4:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  100baa:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bae:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb1:	83 c2 04             	add    $0x4,%edx
  100bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bb8:	89 0c 24             	mov    %ecx,(%esp)
  100bbb:	ff d0                	call   *%eax
  100bbd:	eb 24                	jmp    100be3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc6:	83 f8 02             	cmp    $0x2,%eax
  100bc9:	76 9c                	jbe    100b67 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd2:	c7 04 24 17 60 10 00 	movl   $0x106017,(%esp)
  100bd9:	e8 5e f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be3:	c9                   	leave  
  100be4:	c3                   	ret    

00100be5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100be5:	55                   	push   %ebp
  100be6:	89 e5                	mov    %esp,%ebp
  100be8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100beb:	c7 04 24 30 60 10 00 	movl   $0x106030,(%esp)
  100bf2:	e8 45 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bf7:	c7 04 24 58 60 10 00 	movl   $0x106058,(%esp)
  100bfe:	e8 39 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c07:	74 0b                	je     100c14 <kmonitor+0x2f>
        print_trapframe(tf);
  100c09:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0c:	89 04 24             	mov    %eax,(%esp)
  100c0f:	e8 30 0e 00 00       	call   101a44 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c14:	c7 04 24 7d 60 10 00 	movl   $0x10607d,(%esp)
  100c1b:	e8 13 f6 ff ff       	call   100233 <readline>
  100c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c27:	74 18                	je     100c41 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c29:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c33:	89 04 24             	mov    %eax,(%esp)
  100c36:	e8 f8 fe ff ff       	call   100b33 <runcmd>
  100c3b:	85 c0                	test   %eax,%eax
  100c3d:	79 02                	jns    100c41 <kmonitor+0x5c>
                break;
  100c3f:	eb 02                	jmp    100c43 <kmonitor+0x5e>
            }
        }
    }
  100c41:	eb d1                	jmp    100c14 <kmonitor+0x2f>
}
  100c43:	c9                   	leave  
  100c44:	c3                   	ret    

00100c45 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c45:	55                   	push   %ebp
  100c46:	89 e5                	mov    %esp,%ebp
  100c48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c52:	eb 3f                	jmp    100c93 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c57:	89 d0                	mov    %edx,%eax
  100c59:	01 c0                	add    %eax,%eax
  100c5b:	01 d0                	add    %edx,%eax
  100c5d:	c1 e0 02             	shl    $0x2,%eax
  100c60:	05 20 70 11 00       	add    $0x117020,%eax
  100c65:	8b 48 04             	mov    0x4(%eax),%ecx
  100c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c6b:	89 d0                	mov    %edx,%eax
  100c6d:	01 c0                	add    %eax,%eax
  100c6f:	01 d0                	add    %edx,%eax
  100c71:	c1 e0 02             	shl    $0x2,%eax
  100c74:	05 20 70 11 00       	add    $0x117020,%eax
  100c79:	8b 00                	mov    (%eax),%eax
  100c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c83:	c7 04 24 81 60 10 00 	movl   $0x106081,(%esp)
  100c8a:	e8 ad f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c96:	83 f8 02             	cmp    $0x2,%eax
  100c99:	76 b9                	jbe    100c54 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca0:	c9                   	leave  
  100ca1:	c3                   	ret    

00100ca2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca2:	55                   	push   %ebp
  100ca3:	89 e5                	mov    %esp,%ebp
  100ca5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ca8:	e8 c3 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb2:	c9                   	leave  
  100cb3:	c3                   	ret    

00100cb4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cb4:	55                   	push   %ebp
  100cb5:	89 e5                	mov    %esp,%ebp
  100cb7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cba:	e8 fb fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc4:	c9                   	leave  
  100cc5:	c3                   	ret    

00100cc6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc6:	55                   	push   %ebp
  100cc7:	89 e5                	mov    %esp,%ebp
  100cc9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ccc:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd1:	85 c0                	test   %eax,%eax
  100cd3:	74 02                	je     100cd7 <__panic+0x11>
        goto panic_dead;
  100cd5:	eb 48                	jmp    100d1f <__panic+0x59>
    }
    is_panic = 1;
  100cd7:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cde:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce1:	8d 45 14             	lea    0x14(%ebp),%eax
  100ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cea:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cee:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf5:	c7 04 24 8a 60 10 00 	movl   $0x10608a,(%esp)
  100cfc:	e8 3b f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d08:	8b 45 10             	mov    0x10(%ebp),%eax
  100d0b:	89 04 24             	mov    %eax,(%esp)
  100d0e:	e8 f6 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d13:	c7 04 24 a6 60 10 00 	movl   $0x1060a6,(%esp)
  100d1a:	e8 1d f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d1f:	e8 85 09 00 00       	call   1016a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d2b:	e8 b5 fe ff ff       	call   100be5 <kmonitor>
    }
  100d30:	eb f2                	jmp    100d24 <__panic+0x5e>

00100d32 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d32:	55                   	push   %ebp
  100d33:	89 e5                	mov    %esp,%ebp
  100d35:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d38:	8d 45 14             	lea    0x14(%ebp),%eax
  100d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d41:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d45:	8b 45 08             	mov    0x8(%ebp),%eax
  100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4c:	c7 04 24 a8 60 10 00 	movl   $0x1060a8,(%esp)
  100d53:	e8 e4 f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d62:	89 04 24             	mov    %eax,(%esp)
  100d65:	e8 9f f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d6a:	c7 04 24 a6 60 10 00 	movl   $0x1060a6,(%esp)
  100d71:	e8 c6 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d76:	c9                   	leave  
  100d77:	c3                   	ret    

00100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d78:	55                   	push   %ebp
  100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d7b:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d80:	5d                   	pop    %ebp
  100d81:	c3                   	ret    

00100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d82:	55                   	push   %ebp
  100d83:	89 e5                	mov    %esp,%ebp
  100d85:	83 ec 28             	sub    $0x28,%esp
  100d88:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d8e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d9a:	ee                   	out    %al,(%dx)
  100d9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da1:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100da5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dad:	ee                   	out    %al,(%dx)
  100dae:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100db4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100db8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc1:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dc8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dcb:	c7 04 24 c6 60 10 00 	movl   $0x1060c6,(%esp)
  100dd2:	e8 65 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dde:	e8 24 09 00 00       	call   101707 <pic_enable>
}
  100de3:	c9                   	leave  
  100de4:	c3                   	ret    

00100de5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100de5:	55                   	push   %ebp
  100de6:	89 e5                	mov    %esp,%ebp
  100de8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100deb:	9c                   	pushf  
  100dec:	58                   	pop    %eax
  100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df3:	25 00 02 00 00       	and    $0x200,%eax
  100df8:	85 c0                	test   %eax,%eax
  100dfa:	74 0c                	je     100e08 <__intr_save+0x23>
        intr_disable();
  100dfc:	e8 a8 08 00 00       	call   1016a9 <intr_disable>
        return 1;
  100e01:	b8 01 00 00 00       	mov    $0x1,%eax
  100e06:	eb 05                	jmp    100e0d <__intr_save+0x28>
    }
    return 0;
  100e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e0d:	c9                   	leave  
  100e0e:	c3                   	ret    

00100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e0f:	55                   	push   %ebp
  100e10:	89 e5                	mov    %esp,%ebp
  100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e19:	74 05                	je     100e20 <__intr_restore+0x11>
        intr_enable();
  100e1b:	e8 83 08 00 00       	call   1016a3 <intr_enable>
    }
}
  100e20:	c9                   	leave  
  100e21:	c3                   	ret    

00100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e22:	55                   	push   %ebp
  100e23:	89 e5                	mov    %esp,%ebp
  100e25:	83 ec 10             	sub    $0x10,%esp
  100e28:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e32:	89 c2                	mov    %eax,%edx
  100e34:	ec                   	in     (%dx),%al
  100e35:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e42:	89 c2                	mov    %eax,%edx
  100e44:	ec                   	in     (%dx),%al
  100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e48:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e52:	89 c2                	mov    %eax,%edx
  100e54:	ec                   	in     (%dx),%al
  100e55:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e58:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e62:	89 c2                	mov    %eax,%edx
  100e64:	ec                   	in     (%dx),%al
  100e65:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e68:	c9                   	leave  
  100e69:	c3                   	ret    

00100e6a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e6a:	55                   	push   %ebp
  100e6b:	89 e5                	mov    %esp,%ebp
  100e6d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e70:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7a:	0f b7 00             	movzwl (%eax),%eax
  100e7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e84:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8c:	0f b7 00             	movzwl (%eax),%eax
  100e8f:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e93:	74 12                	je     100ea7 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e95:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e9c:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ea3:	b4 03 
  100ea5:	eb 13                	jmp    100eba <cga_init+0x50>
    } else {
        *cp = was;
  100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eae:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb1:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100eb8:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eba:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec1:	0f b7 c0             	movzwl %ax,%eax
  100ec4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ec8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ecc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ed4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ed5:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100edc:	83 c0 01             	add    $0x1,%eax
  100edf:	0f b7 c0             	movzwl %ax,%eax
  100ee2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ee6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eea:	89 c2                	mov    %eax,%edx
  100eec:	ec                   	in     (%dx),%al
  100eed:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ef4:	0f b6 c0             	movzbl %al,%eax
  100ef7:	c1 e0 08             	shl    $0x8,%eax
  100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100efd:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f04:	0f b7 c0             	movzwl %ax,%eax
  100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f0b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f0f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f13:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f17:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f18:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f1f:	83 c0 01             	add    $0x1,%eax
  100f22:	0f b7 c0             	movzwl %ax,%eax
  100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f29:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f2d:	89 c2                	mov    %eax,%edx
  100f2f:	ec                   	in     (%dx),%al
  100f30:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f33:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f37:	0f b6 c0             	movzbl %al,%eax
  100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f40:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f48:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f4e:	c9                   	leave  
  100f4f:	c3                   	ret    

00100f50 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f50:	55                   	push   %ebp
  100f51:	89 e5                	mov    %esp,%ebp
  100f53:	83 ec 48             	sub    $0x48,%esp
  100f56:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f5c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f60:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f68:	ee                   	out    %al,(%dx)
  100f69:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f6f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f73:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f77:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f7b:	ee                   	out    %al,(%dx)
  100f7c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f82:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f8e:	ee                   	out    %al,(%dx)
  100f8f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f99:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f9d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa1:	ee                   	out    %al,(%dx)
  100fa2:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fa8:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb4:	ee                   	out    %al,(%dx)
  100fb5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fbb:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fc7:	ee                   	out    %al,(%dx)
  100fc8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fce:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fd6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fda:	ee                   	out    %al,(%dx)
  100fdb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fe5:	89 c2                	mov    %eax,%edx
  100fe7:	ec                   	in     (%dx),%al
  100fe8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100feb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fef:	3c ff                	cmp    $0xff,%al
  100ff1:	0f 95 c0             	setne  %al
  100ff4:	0f b6 c0             	movzbl %al,%eax
  100ff7:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100ffc:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101002:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101006:	89 c2                	mov    %eax,%edx
  101008:	ec                   	in     (%dx),%al
  101009:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10100c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101012:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101016:	89 c2                	mov    %eax,%edx
  101018:	ec                   	in     (%dx),%al
  101019:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10101c:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101021:	85 c0                	test   %eax,%eax
  101023:	74 0c                	je     101031 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10102c:	e8 d6 06 00 00       	call   101707 <pic_enable>
    }
}
  101031:	c9                   	leave  
  101032:	c3                   	ret    

00101033 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101033:	55                   	push   %ebp
  101034:	89 e5                	mov    %esp,%ebp
  101036:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101040:	eb 09                	jmp    10104b <lpt_putc_sub+0x18>
        delay();
  101042:	e8 db fd ff ff       	call   100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101047:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10104b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101051:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101055:	89 c2                	mov    %eax,%edx
  101057:	ec                   	in     (%dx),%al
  101058:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10105b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10105f:	84 c0                	test   %al,%al
  101061:	78 09                	js     10106c <lpt_putc_sub+0x39>
  101063:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10106a:	7e d6                	jle    101042 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10106c:	8b 45 08             	mov    0x8(%ebp),%eax
  10106f:	0f b6 c0             	movzbl %al,%eax
  101072:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101078:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101083:	ee                   	out    %al,(%dx)
  101084:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10108a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10108e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101092:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101096:	ee                   	out    %al,(%dx)
  101097:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10109d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010aa:	c9                   	leave  
  1010ab:	c3                   	ret    

001010ac <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010ac:	55                   	push   %ebp
  1010ad:	89 e5                	mov    %esp,%ebp
  1010af:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010b6:	74 0d                	je     1010c5 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bb:	89 04 24             	mov    %eax,(%esp)
  1010be:	e8 70 ff ff ff       	call   101033 <lpt_putc_sub>
  1010c3:	eb 24                	jmp    1010e9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010cc:	e8 62 ff ff ff       	call   101033 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010d8:	e8 56 ff ff ff       	call   101033 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e4:	e8 4a ff ff ff       	call   101033 <lpt_putc_sub>
    }
}
  1010e9:	c9                   	leave  
  1010ea:	c3                   	ret    

001010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010eb:	55                   	push   %ebp
  1010ec:	89 e5                	mov    %esp,%ebp
  1010ee:	53                   	push   %ebx
  1010ef:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f5:	b0 00                	mov    $0x0,%al
  1010f7:	85 c0                	test   %eax,%eax
  1010f9:	75 07                	jne    101102 <cga_putc+0x17>
        c |= 0x0700;
  1010fb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101102:	8b 45 08             	mov    0x8(%ebp),%eax
  101105:	0f b6 c0             	movzbl %al,%eax
  101108:	83 f8 0a             	cmp    $0xa,%eax
  10110b:	74 4c                	je     101159 <cga_putc+0x6e>
  10110d:	83 f8 0d             	cmp    $0xd,%eax
  101110:	74 57                	je     101169 <cga_putc+0x7e>
  101112:	83 f8 08             	cmp    $0x8,%eax
  101115:	0f 85 88 00 00 00    	jne    1011a3 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10111b:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101122:	66 85 c0             	test   %ax,%ax
  101125:	74 30                	je     101157 <cga_putc+0x6c>
            crt_pos --;
  101127:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10112e:	83 e8 01             	sub    $0x1,%eax
  101131:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101137:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10113c:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101143:	0f b7 d2             	movzwl %dx,%edx
  101146:	01 d2                	add    %edx,%edx
  101148:	01 c2                	add    %eax,%edx
  10114a:	8b 45 08             	mov    0x8(%ebp),%eax
  10114d:	b0 00                	mov    $0x0,%al
  10114f:	83 c8 20             	or     $0x20,%eax
  101152:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101155:	eb 72                	jmp    1011c9 <cga_putc+0xde>
  101157:	eb 70                	jmp    1011c9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101159:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101160:	83 c0 50             	add    $0x50,%eax
  101163:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101169:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101170:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101177:	0f b7 c1             	movzwl %cx,%eax
  10117a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101180:	c1 e8 10             	shr    $0x10,%eax
  101183:	89 c2                	mov    %eax,%edx
  101185:	66 c1 ea 06          	shr    $0x6,%dx
  101189:	89 d0                	mov    %edx,%eax
  10118b:	c1 e0 02             	shl    $0x2,%eax
  10118e:	01 d0                	add    %edx,%eax
  101190:	c1 e0 04             	shl    $0x4,%eax
  101193:	29 c1                	sub    %eax,%ecx
  101195:	89 ca                	mov    %ecx,%edx
  101197:	89 d8                	mov    %ebx,%eax
  101199:	29 d0                	sub    %edx,%eax
  10119b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a1:	eb 26                	jmp    1011c9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a3:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011a9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b0:	8d 50 01             	lea    0x1(%eax),%edx
  1011b3:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011ba:	0f b7 c0             	movzwl %ax,%eax
  1011bd:	01 c0                	add    %eax,%eax
  1011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c5:	66 89 02             	mov    %ax,(%edx)
        break;
  1011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011c9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d0:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011d4:	76 5b                	jbe    101231 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d6:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e1:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011ed:	00 
  1011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f2:	89 04 24             	mov    %eax,(%esp)
  1011f5:	e8 68 4a 00 00       	call   105c62 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011fa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101201:	eb 15                	jmp    101218 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101203:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10120b:	01 d2                	add    %edx,%edx
  10120d:	01 d0                	add    %edx,%eax
  10120f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101218:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10121f:	7e e2                	jle    101203 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101221:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101228:	83 e8 50             	sub    $0x50,%eax
  10122b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101231:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101238:	0f b7 c0             	movzwl %ax,%eax
  10123b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10123f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101243:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101247:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10124c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101253:	66 c1 e8 08          	shr    $0x8,%ax
  101257:	0f b6 c0             	movzbl %al,%eax
  10125a:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101261:	83 c2 01             	add    $0x1,%edx
  101264:	0f b7 d2             	movzwl %dx,%edx
  101267:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10126b:	88 45 ed             	mov    %al,-0x13(%ebp)
  10126e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101272:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101276:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101277:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10127e:	0f b7 c0             	movzwl %ax,%eax
  101281:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101285:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101289:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10128d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101291:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101292:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101299:	0f b6 c0             	movzbl %al,%eax
  10129c:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012a3:	83 c2 01             	add    $0x1,%edx
  1012a6:	0f b7 d2             	movzwl %dx,%edx
  1012a9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012ad:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012b8:	ee                   	out    %al,(%dx)
}
  1012b9:	83 c4 34             	add    $0x34,%esp
  1012bc:	5b                   	pop    %ebx
  1012bd:	5d                   	pop    %ebp
  1012be:	c3                   	ret    

001012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012bf:	55                   	push   %ebp
  1012c0:	89 e5                	mov    %esp,%ebp
  1012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012cc:	eb 09                	jmp    1012d7 <serial_putc_sub+0x18>
        delay();
  1012ce:	e8 4f fb ff ff       	call   100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e1:	89 c2                	mov    %eax,%edx
  1012e3:	ec                   	in     (%dx),%al
  1012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012eb:	0f b6 c0             	movzbl %al,%eax
  1012ee:	83 e0 20             	and    $0x20,%eax
  1012f1:	85 c0                	test   %eax,%eax
  1012f3:	75 09                	jne    1012fe <serial_putc_sub+0x3f>
  1012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012fc:	7e d0                	jle    1012ce <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101301:	0f b6 c0             	movzbl %al,%eax
  101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130a:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101315:	ee                   	out    %al,(%dx)
}
  101316:	c9                   	leave  
  101317:	c3                   	ret    

00101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101318:	55                   	push   %ebp
  101319:	89 e5                	mov    %esp,%ebp
  10131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101322:	74 0d                	je     101331 <serial_putc+0x19>
        serial_putc_sub(c);
  101324:	8b 45 08             	mov    0x8(%ebp),%eax
  101327:	89 04 24             	mov    %eax,(%esp)
  10132a:	e8 90 ff ff ff       	call   1012bf <serial_putc_sub>
  10132f:	eb 24                	jmp    101355 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101338:	e8 82 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub(' ');
  10133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101344:	e8 76 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub('\b');
  101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101350:	e8 6a ff ff ff       	call   1012bf <serial_putc_sub>
    }
}
  101355:	c9                   	leave  
  101356:	c3                   	ret    

00101357 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101357:	55                   	push   %ebp
  101358:	89 e5                	mov    %esp,%ebp
  10135a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10135d:	eb 33                	jmp    101392 <cons_intr+0x3b>
        if (c != 0) {
  10135f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101363:	74 2d                	je     101392 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101365:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10136a:	8d 50 01             	lea    0x1(%eax),%edx
  10136d:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101376:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10137c:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101381:	3d 00 02 00 00       	cmp    $0x200,%eax
  101386:	75 0a                	jne    101392 <cons_intr+0x3b>
                cons.wpos = 0;
  101388:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  10138f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101392:	8b 45 08             	mov    0x8(%ebp),%eax
  101395:	ff d0                	call   *%eax
  101397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10139a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10139e:	75 bf                	jne    10135f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a0:	c9                   	leave  
  1013a1:	c3                   	ret    

001013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a2:	55                   	push   %ebp
  1013a3:	89 e5                	mov    %esp,%ebp
  1013a5:	83 ec 10             	sub    $0x10,%esp
  1013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b2:	89 c2                	mov    %eax,%edx
  1013b4:	ec                   	in     (%dx),%al
  1013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013bc:	0f b6 c0             	movzbl %al,%eax
  1013bf:	83 e0 01             	and    $0x1,%eax
  1013c2:	85 c0                	test   %eax,%eax
  1013c4:	75 07                	jne    1013cd <serial_proc_data+0x2b>
        return -1;
  1013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013cb:	eb 2a                	jmp    1013f7 <serial_proc_data+0x55>
  1013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013d7:	89 c2                	mov    %eax,%edx
  1013d9:	ec                   	in     (%dx),%al
  1013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e1:	0f b6 c0             	movzbl %al,%eax
  1013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013eb:	75 07                	jne    1013f4 <serial_proc_data+0x52>
        c = '\b';
  1013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013f7:	c9                   	leave  
  1013f8:	c3                   	ret    

001013f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013f9:	55                   	push   %ebp
  1013fa:	89 e5                	mov    %esp,%ebp
  1013fc:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013ff:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101404:	85 c0                	test   %eax,%eax
  101406:	74 0c                	je     101414 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101408:	c7 04 24 a2 13 10 00 	movl   $0x1013a2,(%esp)
  10140f:	e8 43 ff ff ff       	call   101357 <cons_intr>
    }
}
  101414:	c9                   	leave  
  101415:	c3                   	ret    

00101416 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101416:	55                   	push   %ebp
  101417:	89 e5                	mov    %esp,%ebp
  101419:	83 ec 38             	sub    $0x38,%esp
  10141c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101422:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101426:	89 c2                	mov    %eax,%edx
  101428:	ec                   	in     (%dx),%al
  101429:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10142c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101430:	0f b6 c0             	movzbl %al,%eax
  101433:	83 e0 01             	and    $0x1,%eax
  101436:	85 c0                	test   %eax,%eax
  101438:	75 0a                	jne    101444 <kbd_proc_data+0x2e>
        return -1;
  10143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10143f:	e9 59 01 00 00       	jmp    10159d <kbd_proc_data+0x187>
  101444:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10144e:	89 c2                	mov    %eax,%edx
  101450:	ec                   	in     (%dx),%al
  101451:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101454:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101458:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10145b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10145f:	75 17                	jne    101478 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101461:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101466:	83 c8 40             	or     $0x40,%eax
  101469:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10146e:	b8 00 00 00 00       	mov    $0x0,%eax
  101473:	e9 25 01 00 00       	jmp    10159d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147c:	84 c0                	test   %al,%al
  10147e:	79 47                	jns    1014c7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101480:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101485:	83 e0 40             	and    $0x40,%eax
  101488:	85 c0                	test   %eax,%eax
  10148a:	75 09                	jne    101495 <kbd_proc_data+0x7f>
  10148c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101490:	83 e0 7f             	and    $0x7f,%eax
  101493:	eb 04                	jmp    101499 <kbd_proc_data+0x83>
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014a7:	83 c8 40             	or     $0x40,%eax
  1014aa:	0f b6 c0             	movzbl %al,%eax
  1014ad:	f7 d0                	not    %eax
  1014af:	89 c2                	mov    %eax,%edx
  1014b1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b6:	21 d0                	and    %edx,%eax
  1014b8:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c2:	e9 d6 00 00 00       	jmp    10159d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014c7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014cc:	83 e0 40             	and    $0x40,%eax
  1014cf:	85 c0                	test   %eax,%eax
  1014d1:	74 11                	je     1014e4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014dc:	83 e0 bf             	and    $0xffffffbf,%eax
  1014df:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e8:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ef:	0f b6 d0             	movzbl %al,%edx
  1014f2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f7:	09 d0                	or     %edx,%eax
  1014f9:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101502:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101509:	0f b6 d0             	movzbl %al,%edx
  10150c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101511:	31 d0                	xor    %edx,%eax
  101513:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101518:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10151d:	83 e0 03             	and    $0x3,%eax
  101520:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152b:	01 d0                	add    %edx,%eax
  10152d:	0f b6 00             	movzbl (%eax),%eax
  101530:	0f b6 c0             	movzbl %al,%eax
  101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101536:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10153b:	83 e0 08             	and    $0x8,%eax
  10153e:	85 c0                	test   %eax,%eax
  101540:	74 22                	je     101564 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101546:	7e 0c                	jle    101554 <kbd_proc_data+0x13e>
  101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154c:	7f 06                	jg     101554 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101552:	eb 10                	jmp    101564 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101558:	7e 0a                	jle    101564 <kbd_proc_data+0x14e>
  10155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10155e:	7f 04                	jg     101564 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101564:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101569:	f7 d0                	not    %eax
  10156b:	83 e0 06             	and    $0x6,%eax
  10156e:	85 c0                	test   %eax,%eax
  101570:	75 28                	jne    10159a <kbd_proc_data+0x184>
  101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101579:	75 1f                	jne    10159a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10157b:	c7 04 24 e1 60 10 00 	movl   $0x1060e1,(%esp)
  101582:	e8 b5 ed ff ff       	call   10033c <cprintf>
  101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101595:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101599:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10159d:	c9                   	leave  
  10159e:	c3                   	ret    

0010159f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10159f:	55                   	push   %ebp
  1015a0:	89 e5                	mov    %esp,%ebp
  1015a2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a5:	c7 04 24 16 14 10 00 	movl   $0x101416,(%esp)
  1015ac:	e8 a6 fd ff ff       	call   101357 <cons_intr>
}
  1015b1:	c9                   	leave  
  1015b2:	c3                   	ret    

001015b3 <kbd_init>:

static void
kbd_init(void) {
  1015b3:	55                   	push   %ebp
  1015b4:	89 e5                	mov    %esp,%ebp
  1015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015b9:	e8 e1 ff ff ff       	call   10159f <kbd_intr>
    pic_enable(IRQ_KBD);
  1015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015c5:	e8 3d 01 00 00       	call   101707 <pic_enable>
}
  1015ca:	c9                   	leave  
  1015cb:	c3                   	ret    

001015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015cc:	55                   	push   %ebp
  1015cd:	89 e5                	mov    %esp,%ebp
  1015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d2:	e8 93 f8 ff ff       	call   100e6a <cga_init>
    serial_init();
  1015d7:	e8 74 f9 ff ff       	call   100f50 <serial_init>
    kbd_init();
  1015dc:	e8 d2 ff ff ff       	call   1015b3 <kbd_init>
    if (!serial_exists) {
  1015e1:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015e6:	85 c0                	test   %eax,%eax
  1015e8:	75 0c                	jne    1015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ea:	c7 04 24 ed 60 10 00 	movl   $0x1060ed,(%esp)
  1015f1:	e8 46 ed ff ff       	call   10033c <cprintf>
    }
}
  1015f6:	c9                   	leave  
  1015f7:	c3                   	ret    

001015f8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015f8:	55                   	push   %ebp
  1015f9:	89 e5                	mov    %esp,%ebp
  1015fb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015fe:	e8 e2 f7 ff ff       	call   100de5 <__intr_save>
  101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101606:	8b 45 08             	mov    0x8(%ebp),%eax
  101609:	89 04 24             	mov    %eax,(%esp)
  10160c:	e8 9b fa ff ff       	call   1010ac <lpt_putc>
        cga_putc(c);
  101611:	8b 45 08             	mov    0x8(%ebp),%eax
  101614:	89 04 24             	mov    %eax,(%esp)
  101617:	e8 cf fa ff ff       	call   1010eb <cga_putc>
        serial_putc(c);
  10161c:	8b 45 08             	mov    0x8(%ebp),%eax
  10161f:	89 04 24             	mov    %eax,(%esp)
  101622:	e8 f1 fc ff ff       	call   101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162a:	89 04 24             	mov    %eax,(%esp)
  10162d:	e8 dd f7 ff ff       	call   100e0f <__intr_restore>
}
  101632:	c9                   	leave  
  101633:	c3                   	ret    

00101634 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101634:	55                   	push   %ebp
  101635:	89 e5                	mov    %esp,%ebp
  101637:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101641:	e8 9f f7 ff ff       	call   100de5 <__intr_save>
  101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101649:	e8 ab fd ff ff       	call   1013f9 <serial_intr>
        kbd_intr();
  10164e:	e8 4c ff ff ff       	call   10159f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101653:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101659:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10165e:	39 c2                	cmp    %eax,%edx
  101660:	74 31                	je     101693 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101662:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101667:	8d 50 01             	lea    0x1(%eax),%edx
  10166a:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101670:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101677:	0f b6 c0             	movzbl %al,%eax
  10167a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10167d:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101682:	3d 00 02 00 00       	cmp    $0x200,%eax
  101687:	75 0a                	jne    101693 <cons_getc+0x5f>
                cons.rpos = 0;
  101689:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101690:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101696:	89 04 24             	mov    %eax,(%esp)
  101699:	e8 71 f7 ff ff       	call   100e0f <__intr_restore>
    return c;
  10169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a1:	c9                   	leave  
  1016a2:	c3                   	ret    

001016a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016a3:	55                   	push   %ebp
  1016a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016a6:	fb                   	sti    
    sti();
}
  1016a7:	5d                   	pop    %ebp
  1016a8:	c3                   	ret    

001016a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016a9:	55                   	push   %ebp
  1016aa:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016ac:	fa                   	cli    
    cli();
}
  1016ad:	5d                   	pop    %ebp
  1016ae:	c3                   	ret    

001016af <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016af:	55                   	push   %ebp
  1016b0:	89 e5                	mov    %esp,%ebp
  1016b2:	83 ec 14             	sub    $0x14,%esp
  1016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c0:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016c6:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016cb:	85 c0                	test   %eax,%eax
  1016cd:	74 36                	je     101705 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d3:	0f b6 c0             	movzbl %al,%eax
  1016d6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016dc:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ec:	66 c1 e8 08          	shr    $0x8,%ax
  1016f0:	0f b6 c0             	movzbl %al,%eax
  1016f3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f9:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101700:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101704:	ee                   	out    %al,(%dx)
    }
}
  101705:	c9                   	leave  
  101706:	c3                   	ret    

00101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101707:	55                   	push   %ebp
  101708:	89 e5                	mov    %esp,%ebp
  10170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10170d:	8b 45 08             	mov    0x8(%ebp),%eax
  101710:	ba 01 00 00 00       	mov    $0x1,%edx
  101715:	89 c1                	mov    %eax,%ecx
  101717:	d3 e2                	shl    %cl,%edx
  101719:	89 d0                	mov    %edx,%eax
  10171b:	f7 d0                	not    %eax
  10171d:	89 c2                	mov    %eax,%edx
  10171f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101726:	21 d0                	and    %edx,%eax
  101728:	0f b7 c0             	movzwl %ax,%eax
  10172b:	89 04 24             	mov    %eax,(%esp)
  10172e:	e8 7c ff ff ff       	call   1016af <pic_setmask>
}
  101733:	c9                   	leave  
  101734:	c3                   	ret    

00101735 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101735:	55                   	push   %ebp
  101736:	89 e5                	mov    %esp,%ebp
  101738:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10173b:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101742:	00 00 00 
  101745:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10174b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10174f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101753:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101757:	ee                   	out    %al,(%dx)
  101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10175e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101762:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10176a:	ee                   	out    %al,(%dx)
  10176b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101771:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101775:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101779:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10177d:	ee                   	out    %al,(%dx)
  10177e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101784:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101788:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10178c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101790:	ee                   	out    %al,(%dx)
  101791:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101797:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10179b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10179f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a3:	ee                   	out    %al,(%dx)
  1017a4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017aa:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017b6:	ee                   	out    %al,(%dx)
  1017b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017bd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017c9:	ee                   	out    %al,(%dx)
  1017ca:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017d4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017dc:	ee                   	out    %al,(%dx)
  1017dd:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017e7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017eb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017ef:	ee                   	out    %al,(%dx)
  1017f0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017f6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017fe:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101802:	ee                   	out    %al,(%dx)
  101803:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101809:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10180d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101811:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101815:	ee                   	out    %al,(%dx)
  101816:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10181c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101820:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101824:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101828:	ee                   	out    %al,(%dx)
  101829:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10182f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101833:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101837:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10183b:	ee                   	out    %al,(%dx)
  10183c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101842:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101846:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10184a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10184e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10184f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101856:	66 83 f8 ff          	cmp    $0xffff,%ax
  10185a:	74 12                	je     10186e <pic_init+0x139>
        pic_setmask(irq_mask);
  10185c:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101863:	0f b7 c0             	movzwl %ax,%eax
  101866:	89 04 24             	mov    %eax,(%esp)
  101869:	e8 41 fe ff ff       	call   1016af <pic_setmask>
    }
}
  10186e:	c9                   	leave  
  10186f:	c3                   	ret    

00101870 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101870:	55                   	push   %ebp
  101871:	89 e5                	mov    %esp,%ebp
  101873:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101876:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10187d:	00 
  10187e:	c7 04 24 20 61 10 00 	movl   $0x106120,(%esp)
  101885:	e8 b2 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10188a:	c9                   	leave  
  10188b:	c3                   	ret    

0010188c <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10188c:	55                   	push   %ebp
  10188d:	89 e5                	mov    %esp,%ebp
  10188f:	83 ec 10             	sub    $0x10,%esp
      */
	extern uintptr_t __vectors[];

	// 计算出有多少个IDT，依次遍历他们
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
  101892:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101899:	e9 c3 00 00 00       	jmp    101961 <idt_init+0xd5>

		// 初始化若干IDT
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10189e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a1:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018a8:	89 c2                	mov    %eax,%edx
  1018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ad:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018b4:	00 
  1018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b8:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018bf:	00 08 00 
  1018c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c5:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018cc:	00 
  1018cd:	83 e2 e0             	and    $0xffffffe0,%edx
  1018d0:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018da:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018e1:	00 
  1018e2:	83 e2 1f             	and    $0x1f,%edx
  1018e5:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ef:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1018f6:	00 
  1018f7:	83 e2 f0             	and    $0xfffffff0,%edx
  1018fa:	83 ca 0e             	or     $0xe,%edx
  1018fd:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101907:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10190e:	00 
  10190f:	83 e2 ef             	and    $0xffffffef,%edx
  101912:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191c:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101923:	00 
  101924:	83 e2 9f             	and    $0xffffff9f,%edx
  101927:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101931:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101938:	00 
  101939:	83 ca 80             	or     $0xffffff80,%edx
  10193c:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101946:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10194d:	c1 e8 10             	shr    $0x10,%eax
  101950:	89 c2                	mov    %eax,%edx
  101952:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101955:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  10195c:	00 
      */
	extern uintptr_t __vectors[];

	// 计算出有多少个IDT，依次遍历他们
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
  10195d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101961:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101964:	3d ff 00 00 00       	cmp    $0xff,%eax
  101969:	0f 86 2f ff ff ff    	jbe    10189e <idt_init+0x12>
		// 初始化若干IDT
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	}

	// T_SWITCH_TOK 的发生时机是在用户空间的，所以对应的dpl需要修改为DPL_USER。
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10196f:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101974:	66 a3 88 84 11 00    	mov    %ax,0x118488
  10197a:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  101981:	08 00 
  101983:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  10198a:	83 e0 e0             	and    $0xffffffe0,%eax
  10198d:	a2 8c 84 11 00       	mov    %al,0x11848c
  101992:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101999:	83 e0 1f             	and    $0x1f,%eax
  10199c:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019a1:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019a8:	83 e0 f0             	and    $0xfffffff0,%eax
  1019ab:	83 c8 0e             	or     $0xe,%eax
  1019ae:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019b3:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019ba:	83 e0 ef             	and    $0xffffffef,%eax
  1019bd:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019c2:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019c9:	83 c8 60             	or     $0x60,%eax
  1019cc:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019d1:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019d8:	83 c8 80             	or     $0xffffff80,%eax
  1019db:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019e0:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019e5:	c1 e8 10             	shr    $0x10,%eax
  1019e8:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  1019ee:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019f8:	0f 01 18             	lidtl  (%eax)

	// 加载IDT，只有特权级为0才允许执行
	lidt(&idt_pd);
}
  1019fb:	c9                   	leave  
  1019fc:	c3                   	ret    

001019fd <trapname>:

static const char *
trapname(int trapno) {
  1019fd:	55                   	push   %ebp
  1019fe:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a00:	8b 45 08             	mov    0x8(%ebp),%eax
  101a03:	83 f8 13             	cmp    $0x13,%eax
  101a06:	77 0c                	ja     101a14 <trapname+0x17>
        return excnames[trapno];
  101a08:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0b:	8b 04 85 80 64 10 00 	mov    0x106480(,%eax,4),%eax
  101a12:	eb 18                	jmp    101a2c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a14:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a18:	7e 0d                	jle    101a27 <trapname+0x2a>
  101a1a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a1e:	7f 07                	jg     101a27 <trapname+0x2a>
        return "Hardware Interrupt";
  101a20:	b8 2a 61 10 00       	mov    $0x10612a,%eax
  101a25:	eb 05                	jmp    101a2c <trapname+0x2f>
    }
    return "(unknown trap)";
  101a27:	b8 3d 61 10 00       	mov    $0x10613d,%eax
}
  101a2c:	5d                   	pop    %ebp
  101a2d:	c3                   	ret    

00101a2e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a2e:	55                   	push   %ebp
  101a2f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a31:	8b 45 08             	mov    0x8(%ebp),%eax
  101a34:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a38:	66 83 f8 08          	cmp    $0x8,%ax
  101a3c:	0f 94 c0             	sete   %al
  101a3f:	0f b6 c0             	movzbl %al,%eax
}
  101a42:	5d                   	pop    %ebp
  101a43:	c3                   	ret    

00101a44 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a44:	55                   	push   %ebp
  101a45:	89 e5                	mov    %esp,%ebp
  101a47:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a51:	c7 04 24 7e 61 10 00 	movl   $0x10617e,(%esp)
  101a58:	e8 df e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a60:	89 04 24             	mov    %eax,(%esp)
  101a63:	e8 a1 01 00 00       	call   101c09 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a68:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a6f:	0f b7 c0             	movzwl %ax,%eax
  101a72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a76:	c7 04 24 8f 61 10 00 	movl   $0x10618f,(%esp)
  101a7d:	e8 ba e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a82:	8b 45 08             	mov    0x8(%ebp),%eax
  101a85:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a89:	0f b7 c0             	movzwl %ax,%eax
  101a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a90:	c7 04 24 a2 61 10 00 	movl   $0x1061a2,(%esp)
  101a97:	e8 a0 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aa3:	0f b7 c0             	movzwl %ax,%eax
  101aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aaa:	c7 04 24 b5 61 10 00 	movl   $0x1061b5,(%esp)
  101ab1:	e8 86 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab9:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101abd:	0f b7 c0             	movzwl %ax,%eax
  101ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac4:	c7 04 24 c8 61 10 00 	movl   $0x1061c8,(%esp)
  101acb:	e8 6c e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad3:	8b 40 30             	mov    0x30(%eax),%eax
  101ad6:	89 04 24             	mov    %eax,(%esp)
  101ad9:	e8 1f ff ff ff       	call   1019fd <trapname>
  101ade:	8b 55 08             	mov    0x8(%ebp),%edx
  101ae1:	8b 52 30             	mov    0x30(%edx),%edx
  101ae4:	89 44 24 08          	mov    %eax,0x8(%esp)
  101ae8:	89 54 24 04          	mov    %edx,0x4(%esp)
  101aec:	c7 04 24 db 61 10 00 	movl   $0x1061db,(%esp)
  101af3:	e8 44 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101af8:	8b 45 08             	mov    0x8(%ebp),%eax
  101afb:	8b 40 34             	mov    0x34(%eax),%eax
  101afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b02:	c7 04 24 ed 61 10 00 	movl   $0x1061ed,(%esp)
  101b09:	e8 2e e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b11:	8b 40 38             	mov    0x38(%eax),%eax
  101b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b18:	c7 04 24 fc 61 10 00 	movl   $0x1061fc,(%esp)
  101b1f:	e8 18 e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b24:	8b 45 08             	mov    0x8(%ebp),%eax
  101b27:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b2b:	0f b7 c0             	movzwl %ax,%eax
  101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b32:	c7 04 24 0b 62 10 00 	movl   $0x10620b,(%esp)
  101b39:	e8 fe e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b41:	8b 40 40             	mov    0x40(%eax),%eax
  101b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b48:	c7 04 24 1e 62 10 00 	movl   $0x10621e,(%esp)
  101b4f:	e8 e8 e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b5b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b62:	eb 3e                	jmp    101ba2 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b64:	8b 45 08             	mov    0x8(%ebp),%eax
  101b67:	8b 50 40             	mov    0x40(%eax),%edx
  101b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b6d:	21 d0                	and    %edx,%eax
  101b6f:	85 c0                	test   %eax,%eax
  101b71:	74 28                	je     101b9b <print_trapframe+0x157>
  101b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b76:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b7d:	85 c0                	test   %eax,%eax
  101b7f:	74 1a                	je     101b9b <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b84:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8f:	c7 04 24 2d 62 10 00 	movl   $0x10622d,(%esp)
  101b96:	e8 a1 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b9f:	d1 65 f0             	shll   -0x10(%ebp)
  101ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba5:	83 f8 17             	cmp    $0x17,%eax
  101ba8:	76 ba                	jbe    101b64 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101baa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bad:	8b 40 40             	mov    0x40(%eax),%eax
  101bb0:	25 00 30 00 00       	and    $0x3000,%eax
  101bb5:	c1 e8 0c             	shr    $0xc,%eax
  101bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbc:	c7 04 24 31 62 10 00 	movl   $0x106231,(%esp)
  101bc3:	e8 74 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcb:	89 04 24             	mov    %eax,(%esp)
  101bce:	e8 5b fe ff ff       	call   101a2e <trap_in_kernel>
  101bd3:	85 c0                	test   %eax,%eax
  101bd5:	75 30                	jne    101c07 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bda:	8b 40 44             	mov    0x44(%eax),%eax
  101bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be1:	c7 04 24 3a 62 10 00 	movl   $0x10623a,(%esp)
  101be8:	e8 4f e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bed:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf0:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bf4:	0f b7 c0             	movzwl %ax,%eax
  101bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfb:	c7 04 24 49 62 10 00 	movl   $0x106249,(%esp)
  101c02:	e8 35 e7 ff ff       	call   10033c <cprintf>
    }
}
  101c07:	c9                   	leave  
  101c08:	c3                   	ret    

00101c09 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c09:	55                   	push   %ebp
  101c0a:	89 e5                	mov    %esp,%ebp
  101c0c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c12:	8b 00                	mov    (%eax),%eax
  101c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c18:	c7 04 24 5c 62 10 00 	movl   $0x10625c,(%esp)
  101c1f:	e8 18 e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c24:	8b 45 08             	mov    0x8(%ebp),%eax
  101c27:	8b 40 04             	mov    0x4(%eax),%eax
  101c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2e:	c7 04 24 6b 62 10 00 	movl   $0x10626b,(%esp)
  101c35:	e8 02 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3d:	8b 40 08             	mov    0x8(%eax),%eax
  101c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c44:	c7 04 24 7a 62 10 00 	movl   $0x10627a,(%esp)
  101c4b:	e8 ec e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c50:	8b 45 08             	mov    0x8(%ebp),%eax
  101c53:	8b 40 0c             	mov    0xc(%eax),%eax
  101c56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5a:	c7 04 24 89 62 10 00 	movl   $0x106289,(%esp)
  101c61:	e8 d6 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c66:	8b 45 08             	mov    0x8(%ebp),%eax
  101c69:	8b 40 10             	mov    0x10(%eax),%eax
  101c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c70:	c7 04 24 98 62 10 00 	movl   $0x106298,(%esp)
  101c77:	e8 c0 e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7f:	8b 40 14             	mov    0x14(%eax),%eax
  101c82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c86:	c7 04 24 a7 62 10 00 	movl   $0x1062a7,(%esp)
  101c8d:	e8 aa e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c92:	8b 45 08             	mov    0x8(%ebp),%eax
  101c95:	8b 40 18             	mov    0x18(%eax),%eax
  101c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9c:	c7 04 24 b6 62 10 00 	movl   $0x1062b6,(%esp)
  101ca3:	e8 94 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cab:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cae:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb2:	c7 04 24 c5 62 10 00 	movl   $0x1062c5,(%esp)
  101cb9:	e8 7e e6 ff ff       	call   10033c <cprintf>
}
  101cbe:	c9                   	leave  
  101cbf:	c3                   	ret    

00101cc0 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cc0:	55                   	push   %ebp
  101cc1:	89 e5                	mov    %esp,%ebp
  101cc3:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc9:	8b 40 30             	mov    0x30(%eax),%eax
  101ccc:	83 f8 2f             	cmp    $0x2f,%eax
  101ccf:	77 21                	ja     101cf2 <trap_dispatch+0x32>
  101cd1:	83 f8 2e             	cmp    $0x2e,%eax
  101cd4:	0f 83 04 01 00 00    	jae    101dde <trap_dispatch+0x11e>
  101cda:	83 f8 21             	cmp    $0x21,%eax
  101cdd:	0f 84 81 00 00 00    	je     101d64 <trap_dispatch+0xa4>
  101ce3:	83 f8 24             	cmp    $0x24,%eax
  101ce6:	74 56                	je     101d3e <trap_dispatch+0x7e>
  101ce8:	83 f8 20             	cmp    $0x20,%eax
  101ceb:	74 16                	je     101d03 <trap_dispatch+0x43>
  101ced:	e9 b4 00 00 00       	jmp    101da6 <trap_dispatch+0xe6>
  101cf2:	83 e8 78             	sub    $0x78,%eax
  101cf5:	83 f8 01             	cmp    $0x1,%eax
  101cf8:	0f 87 a8 00 00 00    	ja     101da6 <trap_dispatch+0xe6>
  101cfe:	e9 87 00 00 00       	jmp    101d8a <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    ticks++;
  101d03:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d08:	83 c0 01             	add    $0x1,%eax
  101d0b:	a3 4c 89 11 00       	mov    %eax,0x11894c
    if (ticks % TICK_NUM == 0) {
  101d10:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d16:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d1b:	89 c8                	mov    %ecx,%eax
  101d1d:	f7 e2                	mul    %edx
  101d1f:	89 d0                	mov    %edx,%eax
  101d21:	c1 e8 05             	shr    $0x5,%eax
  101d24:	6b c0 64             	imul   $0x64,%eax,%eax
  101d27:	29 c1                	sub    %eax,%ecx
  101d29:	89 c8                	mov    %ecx,%eax
  101d2b:	85 c0                	test   %eax,%eax
  101d2d:	75 0a                	jne    101d39 <trap_dispatch+0x79>
    	print_ticks();
  101d2f:	e8 3c fb ff ff       	call   101870 <print_ticks>
    }
        break;
  101d34:	e9 a6 00 00 00       	jmp    101ddf <trap_dispatch+0x11f>
  101d39:	e9 a1 00 00 00       	jmp    101ddf <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d3e:	e8 f1 f8 ff ff       	call   101634 <cons_getc>
  101d43:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d46:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d4a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d4e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d52:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d56:	c7 04 24 d4 62 10 00 	movl   $0x1062d4,(%esp)
  101d5d:	e8 da e5 ff ff       	call   10033c <cprintf>
        break;
  101d62:	eb 7b                	jmp    101ddf <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d64:	e8 cb f8 ff ff       	call   101634 <cons_getc>
  101d69:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d6c:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d70:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d74:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d78:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7c:	c7 04 24 e6 62 10 00 	movl   $0x1062e6,(%esp)
  101d83:	e8 b4 e5 ff ff       	call   10033c <cprintf>
        break;
  101d88:	eb 55                	jmp    101ddf <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d8a:	c7 44 24 08 f5 62 10 	movl   $0x1062f5,0x8(%esp)
  101d91:	00 
  101d92:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  101d99:	00 
  101d9a:	c7 04 24 05 63 10 00 	movl   $0x106305,(%esp)
  101da1:	e8 20 ef ff ff       	call   100cc6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101da6:	8b 45 08             	mov    0x8(%ebp),%eax
  101da9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dad:	0f b7 c0             	movzwl %ax,%eax
  101db0:	83 e0 03             	and    $0x3,%eax
  101db3:	85 c0                	test   %eax,%eax
  101db5:	75 28                	jne    101ddf <trap_dispatch+0x11f>
            print_trapframe(tf);
  101db7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dba:	89 04 24             	mov    %eax,(%esp)
  101dbd:	e8 82 fc ff ff       	call   101a44 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101dc2:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  101dc9:	00 
  101dca:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  101dd1:	00 
  101dd2:	c7 04 24 05 63 10 00 	movl   $0x106305,(%esp)
  101dd9:	e8 e8 ee ff ff       	call   100cc6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101dde:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101ddf:	c9                   	leave  
  101de0:	c3                   	ret    

00101de1 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101de1:	55                   	push   %ebp
  101de2:	89 e5                	mov    %esp,%ebp
  101de4:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101de7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dea:	89 04 24             	mov    %eax,(%esp)
  101ded:	e8 ce fe ff ff       	call   101cc0 <trap_dispatch>
}
  101df2:	c9                   	leave  
  101df3:	c3                   	ret    

00101df4 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101df4:	1e                   	push   %ds
    pushl %es
  101df5:	06                   	push   %es
    pushl %fs
  101df6:	0f a0                	push   %fs
    pushl %gs
  101df8:	0f a8                	push   %gs
    pushal
  101dfa:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101dfb:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e00:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e02:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e04:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e05:	e8 d7 ff ff ff       	call   101de1 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e0a:	5c                   	pop    %esp

00101e0b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e0b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e0c:	0f a9                	pop    %gs
    popl %fs
  101e0e:	0f a1                	pop    %fs
    popl %es
  101e10:	07                   	pop    %es
    popl %ds
  101e11:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e12:	83 c4 08             	add    $0x8,%esp
    iret
  101e15:	cf                   	iret   

00101e16 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e16:	6a 00                	push   $0x0
  pushl $0
  101e18:	6a 00                	push   $0x0
  jmp __alltraps
  101e1a:	e9 d5 ff ff ff       	jmp    101df4 <__alltraps>

00101e1f <vector1>:
.globl vector1
vector1:
  pushl $0
  101e1f:	6a 00                	push   $0x0
  pushl $1
  101e21:	6a 01                	push   $0x1
  jmp __alltraps
  101e23:	e9 cc ff ff ff       	jmp    101df4 <__alltraps>

00101e28 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e28:	6a 00                	push   $0x0
  pushl $2
  101e2a:	6a 02                	push   $0x2
  jmp __alltraps
  101e2c:	e9 c3 ff ff ff       	jmp    101df4 <__alltraps>

00101e31 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e31:	6a 00                	push   $0x0
  pushl $3
  101e33:	6a 03                	push   $0x3
  jmp __alltraps
  101e35:	e9 ba ff ff ff       	jmp    101df4 <__alltraps>

00101e3a <vector4>:
.globl vector4
vector4:
  pushl $0
  101e3a:	6a 00                	push   $0x0
  pushl $4
  101e3c:	6a 04                	push   $0x4
  jmp __alltraps
  101e3e:	e9 b1 ff ff ff       	jmp    101df4 <__alltraps>

00101e43 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e43:	6a 00                	push   $0x0
  pushl $5
  101e45:	6a 05                	push   $0x5
  jmp __alltraps
  101e47:	e9 a8 ff ff ff       	jmp    101df4 <__alltraps>

00101e4c <vector6>:
.globl vector6
vector6:
  pushl $0
  101e4c:	6a 00                	push   $0x0
  pushl $6
  101e4e:	6a 06                	push   $0x6
  jmp __alltraps
  101e50:	e9 9f ff ff ff       	jmp    101df4 <__alltraps>

00101e55 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e55:	6a 00                	push   $0x0
  pushl $7
  101e57:	6a 07                	push   $0x7
  jmp __alltraps
  101e59:	e9 96 ff ff ff       	jmp    101df4 <__alltraps>

00101e5e <vector8>:
.globl vector8
vector8:
  pushl $8
  101e5e:	6a 08                	push   $0x8
  jmp __alltraps
  101e60:	e9 8f ff ff ff       	jmp    101df4 <__alltraps>

00101e65 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e65:	6a 09                	push   $0x9
  jmp __alltraps
  101e67:	e9 88 ff ff ff       	jmp    101df4 <__alltraps>

00101e6c <vector10>:
.globl vector10
vector10:
  pushl $10
  101e6c:	6a 0a                	push   $0xa
  jmp __alltraps
  101e6e:	e9 81 ff ff ff       	jmp    101df4 <__alltraps>

00101e73 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e73:	6a 0b                	push   $0xb
  jmp __alltraps
  101e75:	e9 7a ff ff ff       	jmp    101df4 <__alltraps>

00101e7a <vector12>:
.globl vector12
vector12:
  pushl $12
  101e7a:	6a 0c                	push   $0xc
  jmp __alltraps
  101e7c:	e9 73 ff ff ff       	jmp    101df4 <__alltraps>

00101e81 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e81:	6a 0d                	push   $0xd
  jmp __alltraps
  101e83:	e9 6c ff ff ff       	jmp    101df4 <__alltraps>

00101e88 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e88:	6a 0e                	push   $0xe
  jmp __alltraps
  101e8a:	e9 65 ff ff ff       	jmp    101df4 <__alltraps>

00101e8f <vector15>:
.globl vector15
vector15:
  pushl $0
  101e8f:	6a 00                	push   $0x0
  pushl $15
  101e91:	6a 0f                	push   $0xf
  jmp __alltraps
  101e93:	e9 5c ff ff ff       	jmp    101df4 <__alltraps>

00101e98 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e98:	6a 00                	push   $0x0
  pushl $16
  101e9a:	6a 10                	push   $0x10
  jmp __alltraps
  101e9c:	e9 53 ff ff ff       	jmp    101df4 <__alltraps>

00101ea1 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ea1:	6a 11                	push   $0x11
  jmp __alltraps
  101ea3:	e9 4c ff ff ff       	jmp    101df4 <__alltraps>

00101ea8 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $18
  101eaa:	6a 12                	push   $0x12
  jmp __alltraps
  101eac:	e9 43 ff ff ff       	jmp    101df4 <__alltraps>

00101eb1 <vector19>:
.globl vector19
vector19:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $19
  101eb3:	6a 13                	push   $0x13
  jmp __alltraps
  101eb5:	e9 3a ff ff ff       	jmp    101df4 <__alltraps>

00101eba <vector20>:
.globl vector20
vector20:
  pushl $0
  101eba:	6a 00                	push   $0x0
  pushl $20
  101ebc:	6a 14                	push   $0x14
  jmp __alltraps
  101ebe:	e9 31 ff ff ff       	jmp    101df4 <__alltraps>

00101ec3 <vector21>:
.globl vector21
vector21:
  pushl $0
  101ec3:	6a 00                	push   $0x0
  pushl $21
  101ec5:	6a 15                	push   $0x15
  jmp __alltraps
  101ec7:	e9 28 ff ff ff       	jmp    101df4 <__alltraps>

00101ecc <vector22>:
.globl vector22
vector22:
  pushl $0
  101ecc:	6a 00                	push   $0x0
  pushl $22
  101ece:	6a 16                	push   $0x16
  jmp __alltraps
  101ed0:	e9 1f ff ff ff       	jmp    101df4 <__alltraps>

00101ed5 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ed5:	6a 00                	push   $0x0
  pushl $23
  101ed7:	6a 17                	push   $0x17
  jmp __alltraps
  101ed9:	e9 16 ff ff ff       	jmp    101df4 <__alltraps>

00101ede <vector24>:
.globl vector24
vector24:
  pushl $0
  101ede:	6a 00                	push   $0x0
  pushl $24
  101ee0:	6a 18                	push   $0x18
  jmp __alltraps
  101ee2:	e9 0d ff ff ff       	jmp    101df4 <__alltraps>

00101ee7 <vector25>:
.globl vector25
vector25:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $25
  101ee9:	6a 19                	push   $0x19
  jmp __alltraps
  101eeb:	e9 04 ff ff ff       	jmp    101df4 <__alltraps>

00101ef0 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $26
  101ef2:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ef4:	e9 fb fe ff ff       	jmp    101df4 <__alltraps>

00101ef9 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ef9:	6a 00                	push   $0x0
  pushl $27
  101efb:	6a 1b                	push   $0x1b
  jmp __alltraps
  101efd:	e9 f2 fe ff ff       	jmp    101df4 <__alltraps>

00101f02 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f02:	6a 00                	push   $0x0
  pushl $28
  101f04:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f06:	e9 e9 fe ff ff       	jmp    101df4 <__alltraps>

00101f0b <vector29>:
.globl vector29
vector29:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $29
  101f0d:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f0f:	e9 e0 fe ff ff       	jmp    101df4 <__alltraps>

00101f14 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $30
  101f16:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f18:	e9 d7 fe ff ff       	jmp    101df4 <__alltraps>

00101f1d <vector31>:
.globl vector31
vector31:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $31
  101f1f:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f21:	e9 ce fe ff ff       	jmp    101df4 <__alltraps>

00101f26 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f26:	6a 00                	push   $0x0
  pushl $32
  101f28:	6a 20                	push   $0x20
  jmp __alltraps
  101f2a:	e9 c5 fe ff ff       	jmp    101df4 <__alltraps>

00101f2f <vector33>:
.globl vector33
vector33:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $33
  101f31:	6a 21                	push   $0x21
  jmp __alltraps
  101f33:	e9 bc fe ff ff       	jmp    101df4 <__alltraps>

00101f38 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $34
  101f3a:	6a 22                	push   $0x22
  jmp __alltraps
  101f3c:	e9 b3 fe ff ff       	jmp    101df4 <__alltraps>

00101f41 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $35
  101f43:	6a 23                	push   $0x23
  jmp __alltraps
  101f45:	e9 aa fe ff ff       	jmp    101df4 <__alltraps>

00101f4a <vector36>:
.globl vector36
vector36:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $36
  101f4c:	6a 24                	push   $0x24
  jmp __alltraps
  101f4e:	e9 a1 fe ff ff       	jmp    101df4 <__alltraps>

00101f53 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $37
  101f55:	6a 25                	push   $0x25
  jmp __alltraps
  101f57:	e9 98 fe ff ff       	jmp    101df4 <__alltraps>

00101f5c <vector38>:
.globl vector38
vector38:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $38
  101f5e:	6a 26                	push   $0x26
  jmp __alltraps
  101f60:	e9 8f fe ff ff       	jmp    101df4 <__alltraps>

00101f65 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $39
  101f67:	6a 27                	push   $0x27
  jmp __alltraps
  101f69:	e9 86 fe ff ff       	jmp    101df4 <__alltraps>

00101f6e <vector40>:
.globl vector40
vector40:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $40
  101f70:	6a 28                	push   $0x28
  jmp __alltraps
  101f72:	e9 7d fe ff ff       	jmp    101df4 <__alltraps>

00101f77 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $41
  101f79:	6a 29                	push   $0x29
  jmp __alltraps
  101f7b:	e9 74 fe ff ff       	jmp    101df4 <__alltraps>

00101f80 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $42
  101f82:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f84:	e9 6b fe ff ff       	jmp    101df4 <__alltraps>

00101f89 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $43
  101f8b:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f8d:	e9 62 fe ff ff       	jmp    101df4 <__alltraps>

00101f92 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $44
  101f94:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f96:	e9 59 fe ff ff       	jmp    101df4 <__alltraps>

00101f9b <vector45>:
.globl vector45
vector45:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $45
  101f9d:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f9f:	e9 50 fe ff ff       	jmp    101df4 <__alltraps>

00101fa4 <vector46>:
.globl vector46
vector46:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $46
  101fa6:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fa8:	e9 47 fe ff ff       	jmp    101df4 <__alltraps>

00101fad <vector47>:
.globl vector47
vector47:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $47
  101faf:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fb1:	e9 3e fe ff ff       	jmp    101df4 <__alltraps>

00101fb6 <vector48>:
.globl vector48
vector48:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $48
  101fb8:	6a 30                	push   $0x30
  jmp __alltraps
  101fba:	e9 35 fe ff ff       	jmp    101df4 <__alltraps>

00101fbf <vector49>:
.globl vector49
vector49:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $49
  101fc1:	6a 31                	push   $0x31
  jmp __alltraps
  101fc3:	e9 2c fe ff ff       	jmp    101df4 <__alltraps>

00101fc8 <vector50>:
.globl vector50
vector50:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $50
  101fca:	6a 32                	push   $0x32
  jmp __alltraps
  101fcc:	e9 23 fe ff ff       	jmp    101df4 <__alltraps>

00101fd1 <vector51>:
.globl vector51
vector51:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $51
  101fd3:	6a 33                	push   $0x33
  jmp __alltraps
  101fd5:	e9 1a fe ff ff       	jmp    101df4 <__alltraps>

00101fda <vector52>:
.globl vector52
vector52:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $52
  101fdc:	6a 34                	push   $0x34
  jmp __alltraps
  101fde:	e9 11 fe ff ff       	jmp    101df4 <__alltraps>

00101fe3 <vector53>:
.globl vector53
vector53:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $53
  101fe5:	6a 35                	push   $0x35
  jmp __alltraps
  101fe7:	e9 08 fe ff ff       	jmp    101df4 <__alltraps>

00101fec <vector54>:
.globl vector54
vector54:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $54
  101fee:	6a 36                	push   $0x36
  jmp __alltraps
  101ff0:	e9 ff fd ff ff       	jmp    101df4 <__alltraps>

00101ff5 <vector55>:
.globl vector55
vector55:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $55
  101ff7:	6a 37                	push   $0x37
  jmp __alltraps
  101ff9:	e9 f6 fd ff ff       	jmp    101df4 <__alltraps>

00101ffe <vector56>:
.globl vector56
vector56:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $56
  102000:	6a 38                	push   $0x38
  jmp __alltraps
  102002:	e9 ed fd ff ff       	jmp    101df4 <__alltraps>

00102007 <vector57>:
.globl vector57
vector57:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $57
  102009:	6a 39                	push   $0x39
  jmp __alltraps
  10200b:	e9 e4 fd ff ff       	jmp    101df4 <__alltraps>

00102010 <vector58>:
.globl vector58
vector58:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $58
  102012:	6a 3a                	push   $0x3a
  jmp __alltraps
  102014:	e9 db fd ff ff       	jmp    101df4 <__alltraps>

00102019 <vector59>:
.globl vector59
vector59:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $59
  10201b:	6a 3b                	push   $0x3b
  jmp __alltraps
  10201d:	e9 d2 fd ff ff       	jmp    101df4 <__alltraps>

00102022 <vector60>:
.globl vector60
vector60:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $60
  102024:	6a 3c                	push   $0x3c
  jmp __alltraps
  102026:	e9 c9 fd ff ff       	jmp    101df4 <__alltraps>

0010202b <vector61>:
.globl vector61
vector61:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $61
  10202d:	6a 3d                	push   $0x3d
  jmp __alltraps
  10202f:	e9 c0 fd ff ff       	jmp    101df4 <__alltraps>

00102034 <vector62>:
.globl vector62
vector62:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $62
  102036:	6a 3e                	push   $0x3e
  jmp __alltraps
  102038:	e9 b7 fd ff ff       	jmp    101df4 <__alltraps>

0010203d <vector63>:
.globl vector63
vector63:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $63
  10203f:	6a 3f                	push   $0x3f
  jmp __alltraps
  102041:	e9 ae fd ff ff       	jmp    101df4 <__alltraps>

00102046 <vector64>:
.globl vector64
vector64:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $64
  102048:	6a 40                	push   $0x40
  jmp __alltraps
  10204a:	e9 a5 fd ff ff       	jmp    101df4 <__alltraps>

0010204f <vector65>:
.globl vector65
vector65:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $65
  102051:	6a 41                	push   $0x41
  jmp __alltraps
  102053:	e9 9c fd ff ff       	jmp    101df4 <__alltraps>

00102058 <vector66>:
.globl vector66
vector66:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $66
  10205a:	6a 42                	push   $0x42
  jmp __alltraps
  10205c:	e9 93 fd ff ff       	jmp    101df4 <__alltraps>

00102061 <vector67>:
.globl vector67
vector67:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $67
  102063:	6a 43                	push   $0x43
  jmp __alltraps
  102065:	e9 8a fd ff ff       	jmp    101df4 <__alltraps>

0010206a <vector68>:
.globl vector68
vector68:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $68
  10206c:	6a 44                	push   $0x44
  jmp __alltraps
  10206e:	e9 81 fd ff ff       	jmp    101df4 <__alltraps>

00102073 <vector69>:
.globl vector69
vector69:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $69
  102075:	6a 45                	push   $0x45
  jmp __alltraps
  102077:	e9 78 fd ff ff       	jmp    101df4 <__alltraps>

0010207c <vector70>:
.globl vector70
vector70:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $70
  10207e:	6a 46                	push   $0x46
  jmp __alltraps
  102080:	e9 6f fd ff ff       	jmp    101df4 <__alltraps>

00102085 <vector71>:
.globl vector71
vector71:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $71
  102087:	6a 47                	push   $0x47
  jmp __alltraps
  102089:	e9 66 fd ff ff       	jmp    101df4 <__alltraps>

0010208e <vector72>:
.globl vector72
vector72:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $72
  102090:	6a 48                	push   $0x48
  jmp __alltraps
  102092:	e9 5d fd ff ff       	jmp    101df4 <__alltraps>

00102097 <vector73>:
.globl vector73
vector73:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $73
  102099:	6a 49                	push   $0x49
  jmp __alltraps
  10209b:	e9 54 fd ff ff       	jmp    101df4 <__alltraps>

001020a0 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $74
  1020a2:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020a4:	e9 4b fd ff ff       	jmp    101df4 <__alltraps>

001020a9 <vector75>:
.globl vector75
vector75:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $75
  1020ab:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020ad:	e9 42 fd ff ff       	jmp    101df4 <__alltraps>

001020b2 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $76
  1020b4:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020b6:	e9 39 fd ff ff       	jmp    101df4 <__alltraps>

001020bb <vector77>:
.globl vector77
vector77:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $77
  1020bd:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020bf:	e9 30 fd ff ff       	jmp    101df4 <__alltraps>

001020c4 <vector78>:
.globl vector78
vector78:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $78
  1020c6:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020c8:	e9 27 fd ff ff       	jmp    101df4 <__alltraps>

001020cd <vector79>:
.globl vector79
vector79:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $79
  1020cf:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020d1:	e9 1e fd ff ff       	jmp    101df4 <__alltraps>

001020d6 <vector80>:
.globl vector80
vector80:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $80
  1020d8:	6a 50                	push   $0x50
  jmp __alltraps
  1020da:	e9 15 fd ff ff       	jmp    101df4 <__alltraps>

001020df <vector81>:
.globl vector81
vector81:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $81
  1020e1:	6a 51                	push   $0x51
  jmp __alltraps
  1020e3:	e9 0c fd ff ff       	jmp    101df4 <__alltraps>

001020e8 <vector82>:
.globl vector82
vector82:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $82
  1020ea:	6a 52                	push   $0x52
  jmp __alltraps
  1020ec:	e9 03 fd ff ff       	jmp    101df4 <__alltraps>

001020f1 <vector83>:
.globl vector83
vector83:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $83
  1020f3:	6a 53                	push   $0x53
  jmp __alltraps
  1020f5:	e9 fa fc ff ff       	jmp    101df4 <__alltraps>

001020fa <vector84>:
.globl vector84
vector84:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $84
  1020fc:	6a 54                	push   $0x54
  jmp __alltraps
  1020fe:	e9 f1 fc ff ff       	jmp    101df4 <__alltraps>

00102103 <vector85>:
.globl vector85
vector85:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $85
  102105:	6a 55                	push   $0x55
  jmp __alltraps
  102107:	e9 e8 fc ff ff       	jmp    101df4 <__alltraps>

0010210c <vector86>:
.globl vector86
vector86:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $86
  10210e:	6a 56                	push   $0x56
  jmp __alltraps
  102110:	e9 df fc ff ff       	jmp    101df4 <__alltraps>

00102115 <vector87>:
.globl vector87
vector87:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $87
  102117:	6a 57                	push   $0x57
  jmp __alltraps
  102119:	e9 d6 fc ff ff       	jmp    101df4 <__alltraps>

0010211e <vector88>:
.globl vector88
vector88:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $88
  102120:	6a 58                	push   $0x58
  jmp __alltraps
  102122:	e9 cd fc ff ff       	jmp    101df4 <__alltraps>

00102127 <vector89>:
.globl vector89
vector89:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $89
  102129:	6a 59                	push   $0x59
  jmp __alltraps
  10212b:	e9 c4 fc ff ff       	jmp    101df4 <__alltraps>

00102130 <vector90>:
.globl vector90
vector90:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $90
  102132:	6a 5a                	push   $0x5a
  jmp __alltraps
  102134:	e9 bb fc ff ff       	jmp    101df4 <__alltraps>

00102139 <vector91>:
.globl vector91
vector91:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $91
  10213b:	6a 5b                	push   $0x5b
  jmp __alltraps
  10213d:	e9 b2 fc ff ff       	jmp    101df4 <__alltraps>

00102142 <vector92>:
.globl vector92
vector92:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $92
  102144:	6a 5c                	push   $0x5c
  jmp __alltraps
  102146:	e9 a9 fc ff ff       	jmp    101df4 <__alltraps>

0010214b <vector93>:
.globl vector93
vector93:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $93
  10214d:	6a 5d                	push   $0x5d
  jmp __alltraps
  10214f:	e9 a0 fc ff ff       	jmp    101df4 <__alltraps>

00102154 <vector94>:
.globl vector94
vector94:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $94
  102156:	6a 5e                	push   $0x5e
  jmp __alltraps
  102158:	e9 97 fc ff ff       	jmp    101df4 <__alltraps>

0010215d <vector95>:
.globl vector95
vector95:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $95
  10215f:	6a 5f                	push   $0x5f
  jmp __alltraps
  102161:	e9 8e fc ff ff       	jmp    101df4 <__alltraps>

00102166 <vector96>:
.globl vector96
vector96:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $96
  102168:	6a 60                	push   $0x60
  jmp __alltraps
  10216a:	e9 85 fc ff ff       	jmp    101df4 <__alltraps>

0010216f <vector97>:
.globl vector97
vector97:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $97
  102171:	6a 61                	push   $0x61
  jmp __alltraps
  102173:	e9 7c fc ff ff       	jmp    101df4 <__alltraps>

00102178 <vector98>:
.globl vector98
vector98:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $98
  10217a:	6a 62                	push   $0x62
  jmp __alltraps
  10217c:	e9 73 fc ff ff       	jmp    101df4 <__alltraps>

00102181 <vector99>:
.globl vector99
vector99:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $99
  102183:	6a 63                	push   $0x63
  jmp __alltraps
  102185:	e9 6a fc ff ff       	jmp    101df4 <__alltraps>

0010218a <vector100>:
.globl vector100
vector100:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $100
  10218c:	6a 64                	push   $0x64
  jmp __alltraps
  10218e:	e9 61 fc ff ff       	jmp    101df4 <__alltraps>

00102193 <vector101>:
.globl vector101
vector101:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $101
  102195:	6a 65                	push   $0x65
  jmp __alltraps
  102197:	e9 58 fc ff ff       	jmp    101df4 <__alltraps>

0010219c <vector102>:
.globl vector102
vector102:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $102
  10219e:	6a 66                	push   $0x66
  jmp __alltraps
  1021a0:	e9 4f fc ff ff       	jmp    101df4 <__alltraps>

001021a5 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $103
  1021a7:	6a 67                	push   $0x67
  jmp __alltraps
  1021a9:	e9 46 fc ff ff       	jmp    101df4 <__alltraps>

001021ae <vector104>:
.globl vector104
vector104:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $104
  1021b0:	6a 68                	push   $0x68
  jmp __alltraps
  1021b2:	e9 3d fc ff ff       	jmp    101df4 <__alltraps>

001021b7 <vector105>:
.globl vector105
vector105:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $105
  1021b9:	6a 69                	push   $0x69
  jmp __alltraps
  1021bb:	e9 34 fc ff ff       	jmp    101df4 <__alltraps>

001021c0 <vector106>:
.globl vector106
vector106:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $106
  1021c2:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021c4:	e9 2b fc ff ff       	jmp    101df4 <__alltraps>

001021c9 <vector107>:
.globl vector107
vector107:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $107
  1021cb:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021cd:	e9 22 fc ff ff       	jmp    101df4 <__alltraps>

001021d2 <vector108>:
.globl vector108
vector108:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $108
  1021d4:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021d6:	e9 19 fc ff ff       	jmp    101df4 <__alltraps>

001021db <vector109>:
.globl vector109
vector109:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $109
  1021dd:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021df:	e9 10 fc ff ff       	jmp    101df4 <__alltraps>

001021e4 <vector110>:
.globl vector110
vector110:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $110
  1021e6:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021e8:	e9 07 fc ff ff       	jmp    101df4 <__alltraps>

001021ed <vector111>:
.globl vector111
vector111:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $111
  1021ef:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021f1:	e9 fe fb ff ff       	jmp    101df4 <__alltraps>

001021f6 <vector112>:
.globl vector112
vector112:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $112
  1021f8:	6a 70                	push   $0x70
  jmp __alltraps
  1021fa:	e9 f5 fb ff ff       	jmp    101df4 <__alltraps>

001021ff <vector113>:
.globl vector113
vector113:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $113
  102201:	6a 71                	push   $0x71
  jmp __alltraps
  102203:	e9 ec fb ff ff       	jmp    101df4 <__alltraps>

00102208 <vector114>:
.globl vector114
vector114:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $114
  10220a:	6a 72                	push   $0x72
  jmp __alltraps
  10220c:	e9 e3 fb ff ff       	jmp    101df4 <__alltraps>

00102211 <vector115>:
.globl vector115
vector115:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $115
  102213:	6a 73                	push   $0x73
  jmp __alltraps
  102215:	e9 da fb ff ff       	jmp    101df4 <__alltraps>

0010221a <vector116>:
.globl vector116
vector116:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $116
  10221c:	6a 74                	push   $0x74
  jmp __alltraps
  10221e:	e9 d1 fb ff ff       	jmp    101df4 <__alltraps>

00102223 <vector117>:
.globl vector117
vector117:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $117
  102225:	6a 75                	push   $0x75
  jmp __alltraps
  102227:	e9 c8 fb ff ff       	jmp    101df4 <__alltraps>

0010222c <vector118>:
.globl vector118
vector118:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $118
  10222e:	6a 76                	push   $0x76
  jmp __alltraps
  102230:	e9 bf fb ff ff       	jmp    101df4 <__alltraps>

00102235 <vector119>:
.globl vector119
vector119:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $119
  102237:	6a 77                	push   $0x77
  jmp __alltraps
  102239:	e9 b6 fb ff ff       	jmp    101df4 <__alltraps>

0010223e <vector120>:
.globl vector120
vector120:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $120
  102240:	6a 78                	push   $0x78
  jmp __alltraps
  102242:	e9 ad fb ff ff       	jmp    101df4 <__alltraps>

00102247 <vector121>:
.globl vector121
vector121:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $121
  102249:	6a 79                	push   $0x79
  jmp __alltraps
  10224b:	e9 a4 fb ff ff       	jmp    101df4 <__alltraps>

00102250 <vector122>:
.globl vector122
vector122:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $122
  102252:	6a 7a                	push   $0x7a
  jmp __alltraps
  102254:	e9 9b fb ff ff       	jmp    101df4 <__alltraps>

00102259 <vector123>:
.globl vector123
vector123:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $123
  10225b:	6a 7b                	push   $0x7b
  jmp __alltraps
  10225d:	e9 92 fb ff ff       	jmp    101df4 <__alltraps>

00102262 <vector124>:
.globl vector124
vector124:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $124
  102264:	6a 7c                	push   $0x7c
  jmp __alltraps
  102266:	e9 89 fb ff ff       	jmp    101df4 <__alltraps>

0010226b <vector125>:
.globl vector125
vector125:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $125
  10226d:	6a 7d                	push   $0x7d
  jmp __alltraps
  10226f:	e9 80 fb ff ff       	jmp    101df4 <__alltraps>

00102274 <vector126>:
.globl vector126
vector126:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $126
  102276:	6a 7e                	push   $0x7e
  jmp __alltraps
  102278:	e9 77 fb ff ff       	jmp    101df4 <__alltraps>

0010227d <vector127>:
.globl vector127
vector127:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $127
  10227f:	6a 7f                	push   $0x7f
  jmp __alltraps
  102281:	e9 6e fb ff ff       	jmp    101df4 <__alltraps>

00102286 <vector128>:
.globl vector128
vector128:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $128
  102288:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10228d:	e9 62 fb ff ff       	jmp    101df4 <__alltraps>

00102292 <vector129>:
.globl vector129
vector129:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $129
  102294:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102299:	e9 56 fb ff ff       	jmp    101df4 <__alltraps>

0010229e <vector130>:
.globl vector130
vector130:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $130
  1022a0:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022a5:	e9 4a fb ff ff       	jmp    101df4 <__alltraps>

001022aa <vector131>:
.globl vector131
vector131:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $131
  1022ac:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022b1:	e9 3e fb ff ff       	jmp    101df4 <__alltraps>

001022b6 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $132
  1022b8:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022bd:	e9 32 fb ff ff       	jmp    101df4 <__alltraps>

001022c2 <vector133>:
.globl vector133
vector133:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $133
  1022c4:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022c9:	e9 26 fb ff ff       	jmp    101df4 <__alltraps>

001022ce <vector134>:
.globl vector134
vector134:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $134
  1022d0:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022d5:	e9 1a fb ff ff       	jmp    101df4 <__alltraps>

001022da <vector135>:
.globl vector135
vector135:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $135
  1022dc:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022e1:	e9 0e fb ff ff       	jmp    101df4 <__alltraps>

001022e6 <vector136>:
.globl vector136
vector136:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $136
  1022e8:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022ed:	e9 02 fb ff ff       	jmp    101df4 <__alltraps>

001022f2 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $137
  1022f4:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022f9:	e9 f6 fa ff ff       	jmp    101df4 <__alltraps>

001022fe <vector138>:
.globl vector138
vector138:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $138
  102300:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102305:	e9 ea fa ff ff       	jmp    101df4 <__alltraps>

0010230a <vector139>:
.globl vector139
vector139:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $139
  10230c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102311:	e9 de fa ff ff       	jmp    101df4 <__alltraps>

00102316 <vector140>:
.globl vector140
vector140:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $140
  102318:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10231d:	e9 d2 fa ff ff       	jmp    101df4 <__alltraps>

00102322 <vector141>:
.globl vector141
vector141:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $141
  102324:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102329:	e9 c6 fa ff ff       	jmp    101df4 <__alltraps>

0010232e <vector142>:
.globl vector142
vector142:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $142
  102330:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102335:	e9 ba fa ff ff       	jmp    101df4 <__alltraps>

0010233a <vector143>:
.globl vector143
vector143:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $143
  10233c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102341:	e9 ae fa ff ff       	jmp    101df4 <__alltraps>

00102346 <vector144>:
.globl vector144
vector144:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $144
  102348:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10234d:	e9 a2 fa ff ff       	jmp    101df4 <__alltraps>

00102352 <vector145>:
.globl vector145
vector145:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $145
  102354:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102359:	e9 96 fa ff ff       	jmp    101df4 <__alltraps>

0010235e <vector146>:
.globl vector146
vector146:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $146
  102360:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102365:	e9 8a fa ff ff       	jmp    101df4 <__alltraps>

0010236a <vector147>:
.globl vector147
vector147:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $147
  10236c:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102371:	e9 7e fa ff ff       	jmp    101df4 <__alltraps>

00102376 <vector148>:
.globl vector148
vector148:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $148
  102378:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10237d:	e9 72 fa ff ff       	jmp    101df4 <__alltraps>

00102382 <vector149>:
.globl vector149
vector149:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $149
  102384:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102389:	e9 66 fa ff ff       	jmp    101df4 <__alltraps>

0010238e <vector150>:
.globl vector150
vector150:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $150
  102390:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102395:	e9 5a fa ff ff       	jmp    101df4 <__alltraps>

0010239a <vector151>:
.globl vector151
vector151:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $151
  10239c:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023a1:	e9 4e fa ff ff       	jmp    101df4 <__alltraps>

001023a6 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $152
  1023a8:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023ad:	e9 42 fa ff ff       	jmp    101df4 <__alltraps>

001023b2 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $153
  1023b4:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023b9:	e9 36 fa ff ff       	jmp    101df4 <__alltraps>

001023be <vector154>:
.globl vector154
vector154:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $154
  1023c0:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023c5:	e9 2a fa ff ff       	jmp    101df4 <__alltraps>

001023ca <vector155>:
.globl vector155
vector155:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $155
  1023cc:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023d1:	e9 1e fa ff ff       	jmp    101df4 <__alltraps>

001023d6 <vector156>:
.globl vector156
vector156:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $156
  1023d8:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023dd:	e9 12 fa ff ff       	jmp    101df4 <__alltraps>

001023e2 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $157
  1023e4:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023e9:	e9 06 fa ff ff       	jmp    101df4 <__alltraps>

001023ee <vector158>:
.globl vector158
vector158:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $158
  1023f0:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023f5:	e9 fa f9 ff ff       	jmp    101df4 <__alltraps>

001023fa <vector159>:
.globl vector159
vector159:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $159
  1023fc:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102401:	e9 ee f9 ff ff       	jmp    101df4 <__alltraps>

00102406 <vector160>:
.globl vector160
vector160:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $160
  102408:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10240d:	e9 e2 f9 ff ff       	jmp    101df4 <__alltraps>

00102412 <vector161>:
.globl vector161
vector161:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $161
  102414:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102419:	e9 d6 f9 ff ff       	jmp    101df4 <__alltraps>

0010241e <vector162>:
.globl vector162
vector162:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $162
  102420:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102425:	e9 ca f9 ff ff       	jmp    101df4 <__alltraps>

0010242a <vector163>:
.globl vector163
vector163:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $163
  10242c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102431:	e9 be f9 ff ff       	jmp    101df4 <__alltraps>

00102436 <vector164>:
.globl vector164
vector164:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $164
  102438:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10243d:	e9 b2 f9 ff ff       	jmp    101df4 <__alltraps>

00102442 <vector165>:
.globl vector165
vector165:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $165
  102444:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102449:	e9 a6 f9 ff ff       	jmp    101df4 <__alltraps>

0010244e <vector166>:
.globl vector166
vector166:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $166
  102450:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102455:	e9 9a f9 ff ff       	jmp    101df4 <__alltraps>

0010245a <vector167>:
.globl vector167
vector167:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $167
  10245c:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102461:	e9 8e f9 ff ff       	jmp    101df4 <__alltraps>

00102466 <vector168>:
.globl vector168
vector168:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $168
  102468:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10246d:	e9 82 f9 ff ff       	jmp    101df4 <__alltraps>

00102472 <vector169>:
.globl vector169
vector169:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $169
  102474:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102479:	e9 76 f9 ff ff       	jmp    101df4 <__alltraps>

0010247e <vector170>:
.globl vector170
vector170:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $170
  102480:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102485:	e9 6a f9 ff ff       	jmp    101df4 <__alltraps>

0010248a <vector171>:
.globl vector171
vector171:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $171
  10248c:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102491:	e9 5e f9 ff ff       	jmp    101df4 <__alltraps>

00102496 <vector172>:
.globl vector172
vector172:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $172
  102498:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10249d:	e9 52 f9 ff ff       	jmp    101df4 <__alltraps>

001024a2 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $173
  1024a4:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024a9:	e9 46 f9 ff ff       	jmp    101df4 <__alltraps>

001024ae <vector174>:
.globl vector174
vector174:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $174
  1024b0:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024b5:	e9 3a f9 ff ff       	jmp    101df4 <__alltraps>

001024ba <vector175>:
.globl vector175
vector175:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $175
  1024bc:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024c1:	e9 2e f9 ff ff       	jmp    101df4 <__alltraps>

001024c6 <vector176>:
.globl vector176
vector176:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $176
  1024c8:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024cd:	e9 22 f9 ff ff       	jmp    101df4 <__alltraps>

001024d2 <vector177>:
.globl vector177
vector177:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $177
  1024d4:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024d9:	e9 16 f9 ff ff       	jmp    101df4 <__alltraps>

001024de <vector178>:
.globl vector178
vector178:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $178
  1024e0:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024e5:	e9 0a f9 ff ff       	jmp    101df4 <__alltraps>

001024ea <vector179>:
.globl vector179
vector179:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $179
  1024ec:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024f1:	e9 fe f8 ff ff       	jmp    101df4 <__alltraps>

001024f6 <vector180>:
.globl vector180
vector180:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $180
  1024f8:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024fd:	e9 f2 f8 ff ff       	jmp    101df4 <__alltraps>

00102502 <vector181>:
.globl vector181
vector181:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $181
  102504:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102509:	e9 e6 f8 ff ff       	jmp    101df4 <__alltraps>

0010250e <vector182>:
.globl vector182
vector182:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $182
  102510:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102515:	e9 da f8 ff ff       	jmp    101df4 <__alltraps>

0010251a <vector183>:
.globl vector183
vector183:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $183
  10251c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102521:	e9 ce f8 ff ff       	jmp    101df4 <__alltraps>

00102526 <vector184>:
.globl vector184
vector184:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $184
  102528:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10252d:	e9 c2 f8 ff ff       	jmp    101df4 <__alltraps>

00102532 <vector185>:
.globl vector185
vector185:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $185
  102534:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102539:	e9 b6 f8 ff ff       	jmp    101df4 <__alltraps>

0010253e <vector186>:
.globl vector186
vector186:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $186
  102540:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102545:	e9 aa f8 ff ff       	jmp    101df4 <__alltraps>

0010254a <vector187>:
.globl vector187
vector187:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $187
  10254c:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102551:	e9 9e f8 ff ff       	jmp    101df4 <__alltraps>

00102556 <vector188>:
.globl vector188
vector188:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $188
  102558:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10255d:	e9 92 f8 ff ff       	jmp    101df4 <__alltraps>

00102562 <vector189>:
.globl vector189
vector189:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $189
  102564:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102569:	e9 86 f8 ff ff       	jmp    101df4 <__alltraps>

0010256e <vector190>:
.globl vector190
vector190:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $190
  102570:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102575:	e9 7a f8 ff ff       	jmp    101df4 <__alltraps>

0010257a <vector191>:
.globl vector191
vector191:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $191
  10257c:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102581:	e9 6e f8 ff ff       	jmp    101df4 <__alltraps>

00102586 <vector192>:
.globl vector192
vector192:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $192
  102588:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10258d:	e9 62 f8 ff ff       	jmp    101df4 <__alltraps>

00102592 <vector193>:
.globl vector193
vector193:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $193
  102594:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102599:	e9 56 f8 ff ff       	jmp    101df4 <__alltraps>

0010259e <vector194>:
.globl vector194
vector194:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $194
  1025a0:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025a5:	e9 4a f8 ff ff       	jmp    101df4 <__alltraps>

001025aa <vector195>:
.globl vector195
vector195:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $195
  1025ac:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025b1:	e9 3e f8 ff ff       	jmp    101df4 <__alltraps>

001025b6 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $196
  1025b8:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025bd:	e9 32 f8 ff ff       	jmp    101df4 <__alltraps>

001025c2 <vector197>:
.globl vector197
vector197:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $197
  1025c4:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025c9:	e9 26 f8 ff ff       	jmp    101df4 <__alltraps>

001025ce <vector198>:
.globl vector198
vector198:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $198
  1025d0:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025d5:	e9 1a f8 ff ff       	jmp    101df4 <__alltraps>

001025da <vector199>:
.globl vector199
vector199:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $199
  1025dc:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025e1:	e9 0e f8 ff ff       	jmp    101df4 <__alltraps>

001025e6 <vector200>:
.globl vector200
vector200:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $200
  1025e8:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025ed:	e9 02 f8 ff ff       	jmp    101df4 <__alltraps>

001025f2 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $201
  1025f4:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025f9:	e9 f6 f7 ff ff       	jmp    101df4 <__alltraps>

001025fe <vector202>:
.globl vector202
vector202:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $202
  102600:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102605:	e9 ea f7 ff ff       	jmp    101df4 <__alltraps>

0010260a <vector203>:
.globl vector203
vector203:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $203
  10260c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102611:	e9 de f7 ff ff       	jmp    101df4 <__alltraps>

00102616 <vector204>:
.globl vector204
vector204:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $204
  102618:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10261d:	e9 d2 f7 ff ff       	jmp    101df4 <__alltraps>

00102622 <vector205>:
.globl vector205
vector205:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $205
  102624:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102629:	e9 c6 f7 ff ff       	jmp    101df4 <__alltraps>

0010262e <vector206>:
.globl vector206
vector206:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $206
  102630:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102635:	e9 ba f7 ff ff       	jmp    101df4 <__alltraps>

0010263a <vector207>:
.globl vector207
vector207:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $207
  10263c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102641:	e9 ae f7 ff ff       	jmp    101df4 <__alltraps>

00102646 <vector208>:
.globl vector208
vector208:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $208
  102648:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10264d:	e9 a2 f7 ff ff       	jmp    101df4 <__alltraps>

00102652 <vector209>:
.globl vector209
vector209:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $209
  102654:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102659:	e9 96 f7 ff ff       	jmp    101df4 <__alltraps>

0010265e <vector210>:
.globl vector210
vector210:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $210
  102660:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102665:	e9 8a f7 ff ff       	jmp    101df4 <__alltraps>

0010266a <vector211>:
.globl vector211
vector211:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $211
  10266c:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102671:	e9 7e f7 ff ff       	jmp    101df4 <__alltraps>

00102676 <vector212>:
.globl vector212
vector212:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $212
  102678:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10267d:	e9 72 f7 ff ff       	jmp    101df4 <__alltraps>

00102682 <vector213>:
.globl vector213
vector213:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $213
  102684:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102689:	e9 66 f7 ff ff       	jmp    101df4 <__alltraps>

0010268e <vector214>:
.globl vector214
vector214:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $214
  102690:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102695:	e9 5a f7 ff ff       	jmp    101df4 <__alltraps>

0010269a <vector215>:
.globl vector215
vector215:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $215
  10269c:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026a1:	e9 4e f7 ff ff       	jmp    101df4 <__alltraps>

001026a6 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $216
  1026a8:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026ad:	e9 42 f7 ff ff       	jmp    101df4 <__alltraps>

001026b2 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $217
  1026b4:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026b9:	e9 36 f7 ff ff       	jmp    101df4 <__alltraps>

001026be <vector218>:
.globl vector218
vector218:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $218
  1026c0:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026c5:	e9 2a f7 ff ff       	jmp    101df4 <__alltraps>

001026ca <vector219>:
.globl vector219
vector219:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $219
  1026cc:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026d1:	e9 1e f7 ff ff       	jmp    101df4 <__alltraps>

001026d6 <vector220>:
.globl vector220
vector220:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $220
  1026d8:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026dd:	e9 12 f7 ff ff       	jmp    101df4 <__alltraps>

001026e2 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $221
  1026e4:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026e9:	e9 06 f7 ff ff       	jmp    101df4 <__alltraps>

001026ee <vector222>:
.globl vector222
vector222:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $222
  1026f0:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026f5:	e9 fa f6 ff ff       	jmp    101df4 <__alltraps>

001026fa <vector223>:
.globl vector223
vector223:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $223
  1026fc:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102701:	e9 ee f6 ff ff       	jmp    101df4 <__alltraps>

00102706 <vector224>:
.globl vector224
vector224:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $224
  102708:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10270d:	e9 e2 f6 ff ff       	jmp    101df4 <__alltraps>

00102712 <vector225>:
.globl vector225
vector225:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $225
  102714:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102719:	e9 d6 f6 ff ff       	jmp    101df4 <__alltraps>

0010271e <vector226>:
.globl vector226
vector226:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $226
  102720:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102725:	e9 ca f6 ff ff       	jmp    101df4 <__alltraps>

0010272a <vector227>:
.globl vector227
vector227:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $227
  10272c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102731:	e9 be f6 ff ff       	jmp    101df4 <__alltraps>

00102736 <vector228>:
.globl vector228
vector228:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $228
  102738:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10273d:	e9 b2 f6 ff ff       	jmp    101df4 <__alltraps>

00102742 <vector229>:
.globl vector229
vector229:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $229
  102744:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102749:	e9 a6 f6 ff ff       	jmp    101df4 <__alltraps>

0010274e <vector230>:
.globl vector230
vector230:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $230
  102750:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102755:	e9 9a f6 ff ff       	jmp    101df4 <__alltraps>

0010275a <vector231>:
.globl vector231
vector231:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $231
  10275c:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102761:	e9 8e f6 ff ff       	jmp    101df4 <__alltraps>

00102766 <vector232>:
.globl vector232
vector232:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $232
  102768:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10276d:	e9 82 f6 ff ff       	jmp    101df4 <__alltraps>

00102772 <vector233>:
.globl vector233
vector233:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $233
  102774:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102779:	e9 76 f6 ff ff       	jmp    101df4 <__alltraps>

0010277e <vector234>:
.globl vector234
vector234:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $234
  102780:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102785:	e9 6a f6 ff ff       	jmp    101df4 <__alltraps>

0010278a <vector235>:
.globl vector235
vector235:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $235
  10278c:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102791:	e9 5e f6 ff ff       	jmp    101df4 <__alltraps>

00102796 <vector236>:
.globl vector236
vector236:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $236
  102798:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10279d:	e9 52 f6 ff ff       	jmp    101df4 <__alltraps>

001027a2 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $237
  1027a4:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027a9:	e9 46 f6 ff ff       	jmp    101df4 <__alltraps>

001027ae <vector238>:
.globl vector238
vector238:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $238
  1027b0:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027b5:	e9 3a f6 ff ff       	jmp    101df4 <__alltraps>

001027ba <vector239>:
.globl vector239
vector239:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $239
  1027bc:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027c1:	e9 2e f6 ff ff       	jmp    101df4 <__alltraps>

001027c6 <vector240>:
.globl vector240
vector240:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $240
  1027c8:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027cd:	e9 22 f6 ff ff       	jmp    101df4 <__alltraps>

001027d2 <vector241>:
.globl vector241
vector241:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $241
  1027d4:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027d9:	e9 16 f6 ff ff       	jmp    101df4 <__alltraps>

001027de <vector242>:
.globl vector242
vector242:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $242
  1027e0:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027e5:	e9 0a f6 ff ff       	jmp    101df4 <__alltraps>

001027ea <vector243>:
.globl vector243
vector243:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $243
  1027ec:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027f1:	e9 fe f5 ff ff       	jmp    101df4 <__alltraps>

001027f6 <vector244>:
.globl vector244
vector244:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $244
  1027f8:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027fd:	e9 f2 f5 ff ff       	jmp    101df4 <__alltraps>

00102802 <vector245>:
.globl vector245
vector245:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $245
  102804:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102809:	e9 e6 f5 ff ff       	jmp    101df4 <__alltraps>

0010280e <vector246>:
.globl vector246
vector246:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $246
  102810:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102815:	e9 da f5 ff ff       	jmp    101df4 <__alltraps>

0010281a <vector247>:
.globl vector247
vector247:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $247
  10281c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102821:	e9 ce f5 ff ff       	jmp    101df4 <__alltraps>

00102826 <vector248>:
.globl vector248
vector248:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $248
  102828:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10282d:	e9 c2 f5 ff ff       	jmp    101df4 <__alltraps>

00102832 <vector249>:
.globl vector249
vector249:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $249
  102834:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102839:	e9 b6 f5 ff ff       	jmp    101df4 <__alltraps>

0010283e <vector250>:
.globl vector250
vector250:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $250
  102840:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102845:	e9 aa f5 ff ff       	jmp    101df4 <__alltraps>

0010284a <vector251>:
.globl vector251
vector251:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $251
  10284c:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102851:	e9 9e f5 ff ff       	jmp    101df4 <__alltraps>

00102856 <vector252>:
.globl vector252
vector252:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $252
  102858:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10285d:	e9 92 f5 ff ff       	jmp    101df4 <__alltraps>

00102862 <vector253>:
.globl vector253
vector253:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $253
  102864:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102869:	e9 86 f5 ff ff       	jmp    101df4 <__alltraps>

0010286e <vector254>:
.globl vector254
vector254:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $254
  102870:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102875:	e9 7a f5 ff ff       	jmp    101df4 <__alltraps>

0010287a <vector255>:
.globl vector255
vector255:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $255
  10287c:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102881:	e9 6e f5 ff ff       	jmp    101df4 <__alltraps>

00102886 <list_next>:
/* *
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
  102886:	55                   	push   %ebp
  102887:	89 e5                	mov    %esp,%ebp
    return listelm->next;
  102889:	8b 45 08             	mov    0x8(%ebp),%eax
  10288c:	8b 40 04             	mov    0x4(%eax),%eax
}
  10288f:	5d                   	pop    %ebp
  102890:	c3                   	ret    

00102891 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102891:	55                   	push   %ebp
  102892:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102894:	8b 55 08             	mov    0x8(%ebp),%edx
  102897:	a1 64 89 11 00       	mov    0x118964,%eax
  10289c:	29 c2                	sub    %eax,%edx
  10289e:	89 d0                	mov    %edx,%eax
  1028a0:	c1 f8 02             	sar    $0x2,%eax
  1028a3:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028a9:	5d                   	pop    %ebp
  1028aa:	c3                   	ret    

001028ab <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028ab:	55                   	push   %ebp
  1028ac:	89 e5                	mov    %esp,%ebp
  1028ae:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1028b4:	89 04 24             	mov    %eax,(%esp)
  1028b7:	e8 d5 ff ff ff       	call   102891 <page2ppn>
  1028bc:	c1 e0 0c             	shl    $0xc,%eax
}
  1028bf:	c9                   	leave  
  1028c0:	c3                   	ret    

001028c1 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1028c1:	55                   	push   %ebp
  1028c2:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1028c7:	8b 00                	mov    (%eax),%eax
}
  1028c9:	5d                   	pop    %ebp
  1028ca:	c3                   	ret    

001028cb <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1028cb:	55                   	push   %ebp
  1028cc:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1028d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1028d4:	89 10                	mov    %edx,(%eax)
}
  1028d6:	5d                   	pop    %ebp
  1028d7:	c3                   	ret    

001028d8 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1028d8:	55                   	push   %ebp
  1028d9:	89 e5                	mov    %esp,%ebp
  1028db:	83 ec 10             	sub    $0x10,%esp
  1028de:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1028e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1028eb:	89 50 04             	mov    %edx,0x4(%eax)
  1028ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028f1:	8b 50 04             	mov    0x4(%eax),%edx
  1028f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028f7:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1028f9:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  102900:	00 00 00 
}
  102903:	c9                   	leave  
  102904:	c3                   	ret    

00102905 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102905:	55                   	push   %ebp
  102906:	89 e5                	mov    %esp,%ebp
  102908:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  10290b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10290f:	75 24                	jne    102935 <default_init_memmap+0x30>
  102911:	c7 44 24 0c d0 64 10 	movl   $0x1064d0,0xc(%esp)
  102918:	00 
  102919:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  102920:	00 
  102921:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  102928:	00 
  102929:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  102930:	e8 91 e3 ff ff       	call   100cc6 <__panic>
    struct Page *p = base;
  102935:	8b 45 08             	mov    0x8(%ebp),%eax
  102938:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10293b:	e9 de 00 00 00       	jmp    102a1e <default_init_memmap+0x119>
        assert(PageReserved(p));
  102940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102943:	83 c0 04             	add    $0x4,%eax
  102946:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10294d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102953:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102956:	0f a3 10             	bt     %edx,(%eax)
  102959:	19 c0                	sbb    %eax,%eax
  10295b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10295e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102962:	0f 95 c0             	setne  %al
  102965:	0f b6 c0             	movzbl %al,%eax
  102968:	85 c0                	test   %eax,%eax
  10296a:	75 24                	jne    102990 <default_init_memmap+0x8b>
  10296c:	c7 44 24 0c 01 65 10 	movl   $0x106501,0xc(%esp)
  102973:	00 
  102974:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  10297b:	00 
  10297c:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  102983:	00 
  102984:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  10298b:	e8 36 e3 ff ff       	call   100cc6 <__panic>
        p->flags = p->property = 0;
  102990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102993:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  10299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10299d:	8b 50 08             	mov    0x8(%eax),%edx
  1029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029a3:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1029a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029ad:	00 
  1029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029b1:	89 04 24             	mov    %eax,(%esp)
  1029b4:	e8 12 ff ff ff       	call   1028cb <set_page_ref>
        SetPageProperty(p);
  1029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029bc:	83 c0 04             	add    $0x4,%eax
  1029bf:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1029c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1029c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029cf:	0f ab 10             	bts    %edx,(%eax)
        list_add_before(&free_list, &(base->page_link));
  1029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d5:	83 c0 0c             	add    $0xc,%eax
  1029d8:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  1029df:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  1029e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029e5:	8b 00                	mov    (%eax),%eax
  1029e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1029ea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1029ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1029f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1029f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1029f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1029fc:	89 10                	mov    %edx,(%eax)
  1029fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a01:	8b 10                	mov    (%eax),%edx
  102a03:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a06:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a0c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a0f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a15:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a18:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102a1a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a21:	89 d0                	mov    %edx,%eax
  102a23:	c1 e0 02             	shl    $0x2,%eax
  102a26:	01 d0                	add    %edx,%eax
  102a28:	c1 e0 02             	shl    $0x2,%eax
  102a2b:	89 c2                	mov    %eax,%edx
  102a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a30:	01 d0                	add    %edx,%eax
  102a32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a35:	0f 85 05 ff ff ff    	jne    102940 <default_init_memmap+0x3b>
        p->flags = p->property = 0;
        set_page_ref(p, 0);
        SetPageProperty(p);
        list_add_before(&free_list, &(base->page_link));
    }
    base->property = n;
  102a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a41:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  102a44:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a4d:	01 d0                	add    %edx,%eax
  102a4f:	a3 58 89 11 00       	mov    %eax,0x118958
}
  102a54:	c9                   	leave  
  102a55:	c3                   	ret    

00102a56 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a56:	55                   	push   %ebp
  102a57:	89 e5                	mov    %esp,%ebp
  102a59:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102a5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a60:	75 24                	jne    102a86 <default_alloc_pages+0x30>
  102a62:	c7 44 24 0c d0 64 10 	movl   $0x1064d0,0xc(%esp)
  102a69:	00 
  102a6a:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  102a71:	00 
  102a72:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  102a79:	00 
  102a7a:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  102a81:	e8 40 e2 ff ff       	call   100cc6 <__panic>
    if (n > nr_free) {
  102a86:	a1 58 89 11 00       	mov    0x118958,%eax
  102a8b:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a8e:	73 0a                	jae    102a9a <default_alloc_pages+0x44>
        return NULL;
  102a90:	b8 00 00 00 00       	mov    $0x0,%eax
  102a95:	e9 25 01 00 00       	jmp    102bbf <default_alloc_pages+0x169>
    }
    struct Page *page = NULL;
  102a9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102aa1:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102aa8:	e9 ad 00 00 00       	jmp    102b5a <default_alloc_pages+0x104>
        struct Page *p = le2page(le, page_link);
  102aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ab0:	83 e8 0c             	sub    $0xc,%eax
  102ab3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n) {
  102ab6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ab9:	8b 40 08             	mov    0x8(%eax),%eax
  102abc:	3b 45 08             	cmp    0x8(%ebp),%eax
  102abf:	0f 82 95 00 00 00    	jb     102b5a <default_alloc_pages+0x104>
            page = p;
  102ac5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)

            struct Page *pp = NULL;
  102acb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            list_entry_t *temp_le = &free_list;
  102ad2:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
            // 分配页数
            int i;
            for (i = 0; i < n; i++) {
  102ad9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  102ae0:	eb 6e                	jmp    102b50 <default_alloc_pages+0xfa>
            	// 每一页的标志位改写
            	// 被内核所保留
            	SetPageReserved(pp);
  102ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ae5:	83 c0 04             	add    $0x4,%eax
  102ae8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  102aef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102af2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102af5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102af8:	0f ab 10             	bts    %edx,(%eax)
            	// 不是头页
            	ClearPageProperty(pp);
  102afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102afe:	83 c0 04             	add    $0x4,%eax
  102b01:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102b08:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b0e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b11:	0f b3 10             	btr    %edx,(%eax)
  102b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b17:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b1a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b1d:	8b 40 04             	mov    0x4(%eax),%eax
  102b20:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102b23:	8b 12                	mov    (%edx),%edx
  102b25:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102b28:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b2b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b2e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102b31:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b34:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b37:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b3a:	89 10                	mov    %edx,(%eax)
  102b3c:	c7 45 bc 86 28 10 00 	movl   $0x102886,-0x44(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b43:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b46:	8b 40 04             	mov    0x4(%eax),%eax
            	// 既然分配好了，下一步就将其从freelist中删除
            	list_del(temp_le);
            	temp_le = list_next(list_next);
  102b49:	89 45 ec             	mov    %eax,-0x14(%ebp)

            struct Page *pp = NULL;
            list_entry_t *temp_le = &free_list;
            // 分配页数
            int i;
            for (i = 0; i < n; i++) {
  102b4c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  102b50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b53:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b56:	72 8a                	jb     102ae2 <default_alloc_pages+0x8c>
            	ClearPageProperty(pp);
            	// 既然分配好了，下一步就将其从freelist中删除
            	list_del(temp_le);
            	temp_le = list_next(list_next);
            }
            break;
  102b58:	eb 1c                	jmp    102b76 <default_alloc_pages+0x120>
  102b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b5d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102b63:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b69:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102b70:	0f 85 37 ff ff ff    	jne    102aad <default_alloc_pages+0x57>
            }
            break;
        }
    }
    // 对头页的标志位进行修改
    if (page != NULL) {
  102b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102b7a:	74 40                	je     102bbc <default_alloc_pages+0x166>
        if (page->property > n) {
  102b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b7f:	8b 40 08             	mov    0x8(%eax),%eax
  102b82:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b85:	76 28                	jbe    102baf <default_alloc_pages+0x159>
        	// p指针移动到顶部（这里好象是反着的，其实到了头页）
        	// 修改头页的标志位，可参考高书8.3.2
            struct Page *p = page + n;
  102b87:	8b 55 08             	mov    0x8(%ebp),%edx
  102b8a:	89 d0                	mov    %edx,%eax
  102b8c:	c1 e0 02             	shl    $0x2,%eax
  102b8f:	01 d0                	add    %edx,%eax
  102b91:	c1 e0 02             	shl    $0x2,%eax
  102b94:	89 c2                	mov    %eax,%edx
  102b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b99:	01 d0                	add    %edx,%eax
  102b9b:	89 45 dc             	mov    %eax,-0x24(%ebp)
            p->property = page->property - n;
  102b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ba1:	8b 40 08             	mov    0x8(%eax),%eax
  102ba4:	2b 45 08             	sub    0x8(%ebp),%eax
  102ba7:	89 c2                	mov    %eax,%edx
  102ba9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bac:	89 50 08             	mov    %edx,0x8(%eax)
    }
        nr_free -= n;
  102baf:	a1 58 89 11 00       	mov    0x118958,%eax
  102bb4:	2b 45 08             	sub    0x8(%ebp),%eax
  102bb7:	a3 58 89 11 00       	mov    %eax,0x118958
    }
    return page;
  102bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102bbf:	c9                   	leave  
  102bc0:	c3                   	ret    

00102bc1 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102bc1:	55                   	push   %ebp
  102bc2:	89 e5                	mov    %esp,%ebp
  102bc4:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102bc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bcb:	75 24                	jne    102bf1 <default_free_pages+0x30>
  102bcd:	c7 44 24 0c d0 64 10 	movl   $0x1064d0,0xc(%esp)
  102bd4:	00 
  102bd5:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  102bdc:	00 
  102bdd:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  102be4:	00 
  102be5:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  102bec:	e8 d5 e0 ff ff       	call   100cc6 <__panic>
    // 断言是被内核保留页
    // 这里我不明白为什么申请和释放都标记为“内核保留”？？？
    assert(PageReserved(base));
  102bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf4:	83 c0 04             	add    $0x4,%eax
  102bf7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102bfe:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c07:	0f a3 10             	bt     %edx,(%eax)
  102c0a:	19 c0                	sbb    %eax,%eax
  102c0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102c0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c13:	0f 95 c0             	setne  %al
  102c16:	0f b6 c0             	movzbl %al,%eax
  102c19:	85 c0                	test   %eax,%eax
  102c1b:	75 24                	jne    102c41 <default_free_pages+0x80>
  102c1d:	c7 44 24 0c 11 65 10 	movl   $0x106511,0xc(%esp)
  102c24:	00 
  102c25:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  102c2c:	00 
  102c2d:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
  102c34:	00 
  102c35:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  102c3c:	e8 85 e0 ff ff       	call   100cc6 <__panic>
    struct Page *p = NULL;
  102c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102c48:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102c4f:	eb 13                	jmp    102c64 <default_free_pages+0xa3>
    	p = le2page(le, page_link);
  102c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c54:	83 e8 0c             	sub    $0xc,%eax
  102c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (p>base) {
  102c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c60:	76 02                	jbe    102c64 <default_free_pages+0xa3>
			break;
  102c62:	eb 18                	jmp    102c7c <default_free_pages+0xbb>
  102c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c67:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c6d:	8b 40 04             	mov    0x4(%eax),%eax
    // 断言是被内核保留页
    // 这里我不明白为什么申请和释放都标记为“内核保留”？？？
    assert(PageReserved(base));
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c73:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102c7a:	75 d5                	jne    102c51 <default_free_pages+0x90>
    	p = le2page(le, page_link);
		if (p>base) {
			break;
		}
    }
    for (; p != base + n; p ++) {
  102c7c:	eb 68                	jmp    102ce6 <default_free_pages+0x125>
    	// 因为被释放了，所以重新加回到freelist中
    	list_add_before(le, &(p->page_link));
  102c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c81:	8d 50 0c             	lea    0xc(%eax),%edx
  102c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c87:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102c8a:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102c8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c90:	8b 00                	mov    (%eax),%eax
  102c92:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102c95:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102c98:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c9e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ca1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102ca4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ca7:	89 10                	mov    %edx,(%eax)
  102ca9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cac:	8b 10                	mov    (%eax),%edx
  102cae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cb1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102cb4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102cb7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102cba:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102cbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102cc0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102cc3:	89 10                	mov    %edx,(%eax)
    	// 每一页的标志位不用改了，改下头页就行了
        p->flags = 0;
  102cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102ccf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102cd6:	00 
  102cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cda:	89 04 24             	mov    %eax,(%esp)
  102cdd:	e8 e9 fb ff ff       	call   1028cb <set_page_ref>
    	p = le2page(le, page_link);
		if (p>base) {
			break;
		}
    }
    for (; p != base + n; p ++) {
  102ce2:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ce9:	89 d0                	mov    %edx,%eax
  102ceb:	c1 e0 02             	shl    $0x2,%eax
  102cee:	01 d0                	add    %edx,%eax
  102cf0:	c1 e0 02             	shl    $0x2,%eax
  102cf3:	89 c2                	mov    %eax,%edx
  102cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf8:	01 d0                	add    %edx,%eax
  102cfa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102cfd:	0f 85 7b ff ff ff    	jne    102c7e <default_free_pages+0xbd>
    	// 每一页的标志位不用改了，改下头页就行了
        p->flags = 0;
        set_page_ref(p, 0);
    }
    // 记录空闲页的数目n
    base->property = n;
  102d03:	8b 45 08             	mov    0x8(%ebp),%eax
  102d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d09:	89 50 08             	mov    %edx,0x8(%eax)
    // 声明是头页
    SetPageProperty(base);
  102d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0f:	83 c0 04             	add    $0x4,%eax
  102d12:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102d19:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d1f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102d22:	0f ab 10             	bts    %edx,(%eax)
    base->flags = base->property = 0;
  102d25:	8b 45 08             	mov    0x8(%ebp),%eax
  102d28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d32:	8b 50 08             	mov    0x8(%eax),%edx
  102d35:	8b 45 08             	mov    0x8(%ebp),%eax
  102d38:	89 50 04             	mov    %edx,0x4(%eax)
    set_page_ref(p, 0);
  102d3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102d42:	00 
  102d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d46:	89 04 24             	mov    %eax,(%esp)
  102d49:	e8 7d fb ff ff       	call   1028cb <set_page_ref>

    // 向高位合并
    p = le2page(le, page_link);
  102d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d51:	83 e8 0c             	sub    $0xc,%eax
  102d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // p在高地址，base在低地址
    if (p == base + n) {
  102d57:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d5a:	89 d0                	mov    %edx,%eax
  102d5c:	c1 e0 02             	shl    $0x2,%eax
  102d5f:	01 d0                	add    %edx,%eax
  102d61:	c1 e0 02             	shl    $0x2,%eax
  102d64:	89 c2                	mov    %eax,%edx
  102d66:	8b 45 08             	mov    0x8(%ebp),%eax
  102d69:	01 d0                	add    %edx,%eax
  102d6b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d6e:	75 1e                	jne    102d8e <default_free_pages+0x1cd>
    	// 下面的base的property改下
    	base->property = base->property + p->property;
  102d70:	8b 45 08             	mov    0x8(%ebp),%eax
  102d73:	8b 50 08             	mov    0x8(%eax),%edx
  102d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d79:	8b 40 08             	mov    0x8(%eax),%eax
  102d7c:	01 c2                	add    %eax,%edx
  102d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d81:	89 50 08             	mov    %edx,0x8(%eax)
    	// 中间那层打掉了，参考高书图8-5
    	p->property = 0;
  102d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d87:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d91:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102d94:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d97:	8b 00                	mov    (%eax),%eax
    }

    // 向低位合并，参考高书图8-6
    // 现在是在空闲结点（高书中间下面的那个），指针先往前移一个结点，就是高书图8-6(a)最中间的结点（p指向的那个）
    le = list_prev(le);
  102d99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(le, page_link);
  102d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d9f:	83 e8 0c             	sub    $0xc,%eax
  102da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // p指向中间上面结点的头页，base指向中间下面的结点的头页
    if (le != &free_list && p == base - 1) {
  102da5:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102dac:	74 57                	je     102e05 <default_free_pages+0x244>
  102dae:	8b 45 08             	mov    0x8(%ebp),%eax
  102db1:	83 e8 14             	sub    $0x14,%eax
  102db4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102db7:	75 4c                	jne    102e05 <default_free_pages+0x244>
    	// 直到找到右边的空闲页
    	while (le != &free_list) {
  102db9:	eb 41                	jmp    102dfc <default_free_pages+0x23b>
    		// 中间上面的结点非空
    		if (p->property > 0) {
  102dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dbe:	8b 40 08             	mov    0x8(%eax),%eax
  102dc1:	85 c0                	test   %eax,%eax
  102dc3:	74 20                	je     102de5 <default_free_pages+0x224>
    			p->property = base->property + p->property;
  102dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc8:	8b 50 08             	mov    0x8(%eax),%edx
  102dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dce:	8b 40 08             	mov    0x8(%eax),%eax
  102dd1:	01 c2                	add    %eax,%edx
  102dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dd6:	89 50 08             	mov    %edx,0x8(%eax)
    			base->property = 0;
  102dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  102ddc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    			break;
  102de3:	eb 20                	jmp    102e05 <default_free_pages+0x244>
    		}
    		// 那没找到右边空间页，就往前走
    		p = le2page(le, page_link);
  102de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de8:	83 e8 0c             	sub    $0xc,%eax
  102deb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102df1:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102df4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102df7:	8b 00                	mov    (%eax),%eax
    		le = list_prev(le);
  102df9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    le = list_prev(le);
    p = le2page(le, page_link);
    // p指向中间上面结点的头页，base指向中间下面的结点的头页
    if (le != &free_list && p == base - 1) {
    	// 直到找到右边的空闲页
    	while (le != &free_list) {
  102dfc:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102e03:	75 b6                	jne    102dbb <default_free_pages+0x1fa>
    		// 那没找到右边空间页，就往前走
    		p = le2page(le, page_link);
    		le = list_prev(le);
    	}
    }
    nr_free += n;
  102e05:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e0e:	01 d0                	add    %edx,%eax
  102e10:	a3 58 89 11 00       	mov    %eax,0x118958
}
  102e15:	c9                   	leave  
  102e16:	c3                   	ret    

00102e17 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e17:	55                   	push   %ebp
  102e18:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e1a:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102e1f:	5d                   	pop    %ebp
  102e20:	c3                   	ret    

00102e21 <basic_check>:

static void
basic_check(void) {
  102e21:	55                   	push   %ebp
  102e22:	89 e5                	mov    %esp,%ebp
  102e24:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e37:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e3a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e41:	e8 78 0e 00 00       	call   103cbe <alloc_pages>
  102e46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e49:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e4d:	75 24                	jne    102e73 <basic_check+0x52>
  102e4f:	c7 44 24 0c 24 65 10 	movl   $0x106524,0xc(%esp)
  102e56:	00 
  102e57:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  102e5e:	00 
  102e5f:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  102e66:	00 
  102e67:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  102e6e:	e8 53 de ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102e73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e7a:	e8 3f 0e 00 00       	call   103cbe <alloc_pages>
  102e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e86:	75 24                	jne    102eac <basic_check+0x8b>
  102e88:	c7 44 24 0c 40 65 10 	movl   $0x106540,0xc(%esp)
  102e8f:	00 
  102e90:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  102e97:	00 
  102e98:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  102e9f:	00 
  102ea0:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  102ea7:	e8 1a de ff ff       	call   100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102eac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102eb3:	e8 06 0e 00 00       	call   103cbe <alloc_pages>
  102eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102ebf:	75 24                	jne    102ee5 <basic_check+0xc4>
  102ec1:	c7 44 24 0c 5c 65 10 	movl   $0x10655c,0xc(%esp)
  102ec8:	00 
  102ec9:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  102ed0:	00 
  102ed1:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  102ed8:	00 
  102ed9:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  102ee0:	e8 e1 dd ff ff       	call   100cc6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ee8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102eeb:	74 10                	je     102efd <basic_check+0xdc>
  102eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ef0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ef3:	74 08                	je     102efd <basic_check+0xdc>
  102ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ef8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102efb:	75 24                	jne    102f21 <basic_check+0x100>
  102efd:	c7 44 24 0c 78 65 10 	movl   $0x106578,0xc(%esp)
  102f04:	00 
  102f05:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  102f0c:	00 
  102f0d:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  102f14:	00 
  102f15:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  102f1c:	e8 a5 dd ff ff       	call   100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f24:	89 04 24             	mov    %eax,(%esp)
  102f27:	e8 95 f9 ff ff       	call   1028c1 <page_ref>
  102f2c:	85 c0                	test   %eax,%eax
  102f2e:	75 1e                	jne    102f4e <basic_check+0x12d>
  102f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f33:	89 04 24             	mov    %eax,(%esp)
  102f36:	e8 86 f9 ff ff       	call   1028c1 <page_ref>
  102f3b:	85 c0                	test   %eax,%eax
  102f3d:	75 0f                	jne    102f4e <basic_check+0x12d>
  102f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f42:	89 04 24             	mov    %eax,(%esp)
  102f45:	e8 77 f9 ff ff       	call   1028c1 <page_ref>
  102f4a:	85 c0                	test   %eax,%eax
  102f4c:	74 24                	je     102f72 <basic_check+0x151>
  102f4e:	c7 44 24 0c 9c 65 10 	movl   $0x10659c,0xc(%esp)
  102f55:	00 
  102f56:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  102f5d:	00 
  102f5e:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  102f65:	00 
  102f66:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  102f6d:	e8 54 dd ff ff       	call   100cc6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f75:	89 04 24             	mov    %eax,(%esp)
  102f78:	e8 2e f9 ff ff       	call   1028ab <page2pa>
  102f7d:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f83:	c1 e2 0c             	shl    $0xc,%edx
  102f86:	39 d0                	cmp    %edx,%eax
  102f88:	72 24                	jb     102fae <basic_check+0x18d>
  102f8a:	c7 44 24 0c d8 65 10 	movl   $0x1065d8,0xc(%esp)
  102f91:	00 
  102f92:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  102f99:	00 
  102f9a:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  102fa1:	00 
  102fa2:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  102fa9:	e8 18 dd ff ff       	call   100cc6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb1:	89 04 24             	mov    %eax,(%esp)
  102fb4:	e8 f2 f8 ff ff       	call   1028ab <page2pa>
  102fb9:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fbf:	c1 e2 0c             	shl    $0xc,%edx
  102fc2:	39 d0                	cmp    %edx,%eax
  102fc4:	72 24                	jb     102fea <basic_check+0x1c9>
  102fc6:	c7 44 24 0c f5 65 10 	movl   $0x1065f5,0xc(%esp)
  102fcd:	00 
  102fce:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  102fd5:	00 
  102fd6:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  102fdd:	00 
  102fde:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  102fe5:	e8 dc dc ff ff       	call   100cc6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fed:	89 04 24             	mov    %eax,(%esp)
  102ff0:	e8 b6 f8 ff ff       	call   1028ab <page2pa>
  102ff5:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102ffb:	c1 e2 0c             	shl    $0xc,%edx
  102ffe:	39 d0                	cmp    %edx,%eax
  103000:	72 24                	jb     103026 <basic_check+0x205>
  103002:	c7 44 24 0c 12 66 10 	movl   $0x106612,0xc(%esp)
  103009:	00 
  10300a:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103011:	00 
  103012:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  103019:	00 
  10301a:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103021:	e8 a0 dc ff ff       	call   100cc6 <__panic>

    list_entry_t free_list_store = free_list;
  103026:	a1 50 89 11 00       	mov    0x118950,%eax
  10302b:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103031:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103034:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103037:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10303e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103041:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103044:	89 50 04             	mov    %edx,0x4(%eax)
  103047:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10304a:	8b 50 04             	mov    0x4(%eax),%edx
  10304d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103050:	89 10                	mov    %edx,(%eax)
  103052:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103059:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10305c:	8b 40 04             	mov    0x4(%eax),%eax
  10305f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103062:	0f 94 c0             	sete   %al
  103065:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103068:	85 c0                	test   %eax,%eax
  10306a:	75 24                	jne    103090 <basic_check+0x26f>
  10306c:	c7 44 24 0c 2f 66 10 	movl   $0x10662f,0xc(%esp)
  103073:	00 
  103074:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  10307b:	00 
  10307c:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  103083:	00 
  103084:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  10308b:	e8 36 dc ff ff       	call   100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
  103090:	a1 58 89 11 00       	mov    0x118958,%eax
  103095:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103098:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  10309f:	00 00 00 

    assert(alloc_page() == NULL);
  1030a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030a9:	e8 10 0c 00 00       	call   103cbe <alloc_pages>
  1030ae:	85 c0                	test   %eax,%eax
  1030b0:	74 24                	je     1030d6 <basic_check+0x2b5>
  1030b2:	c7 44 24 0c 46 66 10 	movl   $0x106646,0xc(%esp)
  1030b9:	00 
  1030ba:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  1030c1:	00 
  1030c2:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  1030c9:	00 
  1030ca:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1030d1:	e8 f0 db ff ff       	call   100cc6 <__panic>

    free_page(p0);
  1030d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030dd:	00 
  1030de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030e1:	89 04 24             	mov    %eax,(%esp)
  1030e4:	e8 0d 0c 00 00       	call   103cf6 <free_pages>
    free_page(p1);
  1030e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030f0:	00 
  1030f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030f4:	89 04 24             	mov    %eax,(%esp)
  1030f7:	e8 fa 0b 00 00       	call   103cf6 <free_pages>
    free_page(p2);
  1030fc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103103:	00 
  103104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103107:	89 04 24             	mov    %eax,(%esp)
  10310a:	e8 e7 0b 00 00       	call   103cf6 <free_pages>
    assert(nr_free == 3);
  10310f:	a1 58 89 11 00       	mov    0x118958,%eax
  103114:	83 f8 03             	cmp    $0x3,%eax
  103117:	74 24                	je     10313d <basic_check+0x31c>
  103119:	c7 44 24 0c 5b 66 10 	movl   $0x10665b,0xc(%esp)
  103120:	00 
  103121:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103128:	00 
  103129:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  103130:	00 
  103131:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103138:	e8 89 db ff ff       	call   100cc6 <__panic>

    assert((p0 = alloc_page()) != NULL);
  10313d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103144:	e8 75 0b 00 00       	call   103cbe <alloc_pages>
  103149:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10314c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103150:	75 24                	jne    103176 <basic_check+0x355>
  103152:	c7 44 24 0c 24 65 10 	movl   $0x106524,0xc(%esp)
  103159:	00 
  10315a:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103161:	00 
  103162:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  103169:	00 
  10316a:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103171:	e8 50 db ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103176:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10317d:	e8 3c 0b 00 00       	call   103cbe <alloc_pages>
  103182:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103185:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103189:	75 24                	jne    1031af <basic_check+0x38e>
  10318b:	c7 44 24 0c 40 65 10 	movl   $0x106540,0xc(%esp)
  103192:	00 
  103193:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  10319a:	00 
  10319b:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  1031a2:	00 
  1031a3:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1031aa:	e8 17 db ff ff       	call   100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1031af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031b6:	e8 03 0b 00 00       	call   103cbe <alloc_pages>
  1031bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031c2:	75 24                	jne    1031e8 <basic_check+0x3c7>
  1031c4:	c7 44 24 0c 5c 65 10 	movl   $0x10655c,0xc(%esp)
  1031cb:	00 
  1031cc:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  1031d3:	00 
  1031d4:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  1031db:	00 
  1031dc:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1031e3:	e8 de da ff ff       	call   100cc6 <__panic>

    assert(alloc_page() == NULL);
  1031e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031ef:	e8 ca 0a 00 00       	call   103cbe <alloc_pages>
  1031f4:	85 c0                	test   %eax,%eax
  1031f6:	74 24                	je     10321c <basic_check+0x3fb>
  1031f8:	c7 44 24 0c 46 66 10 	movl   $0x106646,0xc(%esp)
  1031ff:	00 
  103200:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103207:	00 
  103208:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  10320f:	00 
  103210:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103217:	e8 aa da ff ff       	call   100cc6 <__panic>

    free_page(p0);
  10321c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103223:	00 
  103224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103227:	89 04 24             	mov    %eax,(%esp)
  10322a:	e8 c7 0a 00 00       	call   103cf6 <free_pages>
  10322f:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  103236:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103239:	8b 40 04             	mov    0x4(%eax),%eax
  10323c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10323f:	0f 94 c0             	sete   %al
  103242:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103245:	85 c0                	test   %eax,%eax
  103247:	74 24                	je     10326d <basic_check+0x44c>
  103249:	c7 44 24 0c 68 66 10 	movl   $0x106668,0xc(%esp)
  103250:	00 
  103251:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103258:	00 
  103259:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  103260:	00 
  103261:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103268:	e8 59 da ff ff       	call   100cc6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10326d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103274:	e8 45 0a 00 00       	call   103cbe <alloc_pages>
  103279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10327c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10327f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103282:	74 24                	je     1032a8 <basic_check+0x487>
  103284:	c7 44 24 0c 80 66 10 	movl   $0x106680,0xc(%esp)
  10328b:	00 
  10328c:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103293:	00 
  103294:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  10329b:	00 
  10329c:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1032a3:	e8 1e da ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  1032a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032af:	e8 0a 0a 00 00       	call   103cbe <alloc_pages>
  1032b4:	85 c0                	test   %eax,%eax
  1032b6:	74 24                	je     1032dc <basic_check+0x4bb>
  1032b8:	c7 44 24 0c 46 66 10 	movl   $0x106646,0xc(%esp)
  1032bf:	00 
  1032c0:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  1032c7:	00 
  1032c8:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  1032cf:	00 
  1032d0:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1032d7:	e8 ea d9 ff ff       	call   100cc6 <__panic>

    assert(nr_free == 0);
  1032dc:	a1 58 89 11 00       	mov    0x118958,%eax
  1032e1:	85 c0                	test   %eax,%eax
  1032e3:	74 24                	je     103309 <basic_check+0x4e8>
  1032e5:	c7 44 24 0c 99 66 10 	movl   $0x106699,0xc(%esp)
  1032ec:	00 
  1032ed:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  1032f4:	00 
  1032f5:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  1032fc:	00 
  1032fd:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103304:	e8 bd d9 ff ff       	call   100cc6 <__panic>
    free_list = free_list_store;
  103309:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10330c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10330f:	a3 50 89 11 00       	mov    %eax,0x118950
  103314:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  10331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10331d:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  103322:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103329:	00 
  10332a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10332d:	89 04 24             	mov    %eax,(%esp)
  103330:	e8 c1 09 00 00       	call   103cf6 <free_pages>
    free_page(p1);
  103335:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10333c:	00 
  10333d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103340:	89 04 24             	mov    %eax,(%esp)
  103343:	e8 ae 09 00 00       	call   103cf6 <free_pages>
    free_page(p2);
  103348:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10334f:	00 
  103350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103353:	89 04 24             	mov    %eax,(%esp)
  103356:	e8 9b 09 00 00       	call   103cf6 <free_pages>
}
  10335b:	c9                   	leave  
  10335c:	c3                   	ret    

0010335d <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10335d:	55                   	push   %ebp
  10335e:	89 e5                	mov    %esp,%ebp
  103360:	53                   	push   %ebx
  103361:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103367:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10336e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103375:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10337c:	eb 6b                	jmp    1033e9 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  10337e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103381:	83 e8 0c             	sub    $0xc,%eax
  103384:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103387:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10338a:	83 c0 04             	add    $0x4,%eax
  10338d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103394:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103397:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10339a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10339d:	0f a3 10             	bt     %edx,(%eax)
  1033a0:	19 c0                	sbb    %eax,%eax
  1033a2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1033a5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1033a9:	0f 95 c0             	setne  %al
  1033ac:	0f b6 c0             	movzbl %al,%eax
  1033af:	85 c0                	test   %eax,%eax
  1033b1:	75 24                	jne    1033d7 <default_check+0x7a>
  1033b3:	c7 44 24 0c a6 66 10 	movl   $0x1066a6,0xc(%esp)
  1033ba:	00 
  1033bb:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  1033c2:	00 
  1033c3:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1033ca:	00 
  1033cb:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1033d2:	e8 ef d8 ff ff       	call   100cc6 <__panic>
        count ++, total += p->property;
  1033d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1033db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033de:	8b 50 08             	mov    0x8(%eax),%edx
  1033e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033e4:	01 d0                	add    %edx,%eax
  1033e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1033ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1033f2:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1033f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033f8:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1033ff:	0f 85 79 ff ff ff    	jne    10337e <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  103405:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103408:	e8 1b 09 00 00       	call   103d28 <nr_free_pages>
  10340d:	39 c3                	cmp    %eax,%ebx
  10340f:	74 24                	je     103435 <default_check+0xd8>
  103411:	c7 44 24 0c b6 66 10 	movl   $0x1066b6,0xc(%esp)
  103418:	00 
  103419:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103420:	00 
  103421:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  103428:	00 
  103429:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103430:	e8 91 d8 ff ff       	call   100cc6 <__panic>

    basic_check();
  103435:	e8 e7 f9 ff ff       	call   102e21 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10343a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103441:	e8 78 08 00 00       	call   103cbe <alloc_pages>
  103446:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103449:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10344d:	75 24                	jne    103473 <default_check+0x116>
  10344f:	c7 44 24 0c cf 66 10 	movl   $0x1066cf,0xc(%esp)
  103456:	00 
  103457:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  10345e:	00 
  10345f:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  103466:	00 
  103467:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  10346e:	e8 53 d8 ff ff       	call   100cc6 <__panic>
    assert(!PageProperty(p0));
  103473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103476:	83 c0 04             	add    $0x4,%eax
  103479:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103480:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103483:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103486:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103489:	0f a3 10             	bt     %edx,(%eax)
  10348c:	19 c0                	sbb    %eax,%eax
  10348e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103491:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103495:	0f 95 c0             	setne  %al
  103498:	0f b6 c0             	movzbl %al,%eax
  10349b:	85 c0                	test   %eax,%eax
  10349d:	74 24                	je     1034c3 <default_check+0x166>
  10349f:	c7 44 24 0c da 66 10 	movl   $0x1066da,0xc(%esp)
  1034a6:	00 
  1034a7:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  1034ae:	00 
  1034af:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  1034b6:	00 
  1034b7:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1034be:	e8 03 d8 ff ff       	call   100cc6 <__panic>

    list_entry_t free_list_store = free_list;
  1034c3:	a1 50 89 11 00       	mov    0x118950,%eax
  1034c8:	8b 15 54 89 11 00    	mov    0x118954,%edx
  1034ce:	89 45 80             	mov    %eax,-0x80(%ebp)
  1034d1:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1034d4:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1034db:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034de:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1034e1:	89 50 04             	mov    %edx,0x4(%eax)
  1034e4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034e7:	8b 50 04             	mov    0x4(%eax),%edx
  1034ea:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034ed:	89 10                	mov    %edx,(%eax)
  1034ef:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1034f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1034f9:	8b 40 04             	mov    0x4(%eax),%eax
  1034fc:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1034ff:	0f 94 c0             	sete   %al
  103502:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103505:	85 c0                	test   %eax,%eax
  103507:	75 24                	jne    10352d <default_check+0x1d0>
  103509:	c7 44 24 0c 2f 66 10 	movl   $0x10662f,0xc(%esp)
  103510:	00 
  103511:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103518:	00 
  103519:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  103520:	00 
  103521:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103528:	e8 99 d7 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  10352d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103534:	e8 85 07 00 00       	call   103cbe <alloc_pages>
  103539:	85 c0                	test   %eax,%eax
  10353b:	74 24                	je     103561 <default_check+0x204>
  10353d:	c7 44 24 0c 46 66 10 	movl   $0x106646,0xc(%esp)
  103544:	00 
  103545:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  10354c:	00 
  10354d:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  103554:	00 
  103555:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  10355c:	e8 65 d7 ff ff       	call   100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
  103561:	a1 58 89 11 00       	mov    0x118958,%eax
  103566:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  103569:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103570:	00 00 00 

    free_pages(p0 + 2, 3);
  103573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103576:	83 c0 28             	add    $0x28,%eax
  103579:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103580:	00 
  103581:	89 04 24             	mov    %eax,(%esp)
  103584:	e8 6d 07 00 00       	call   103cf6 <free_pages>
    assert(alloc_pages(4) == NULL);
  103589:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103590:	e8 29 07 00 00       	call   103cbe <alloc_pages>
  103595:	85 c0                	test   %eax,%eax
  103597:	74 24                	je     1035bd <default_check+0x260>
  103599:	c7 44 24 0c ec 66 10 	movl   $0x1066ec,0xc(%esp)
  1035a0:	00 
  1035a1:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  1035a8:	00 
  1035a9:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  1035b0:	00 
  1035b1:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1035b8:	e8 09 d7 ff ff       	call   100cc6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1035bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035c0:	83 c0 28             	add    $0x28,%eax
  1035c3:	83 c0 04             	add    $0x4,%eax
  1035c6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1035cd:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035d0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1035d3:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1035d6:	0f a3 10             	bt     %edx,(%eax)
  1035d9:	19 c0                	sbb    %eax,%eax
  1035db:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1035de:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1035e2:	0f 95 c0             	setne  %al
  1035e5:	0f b6 c0             	movzbl %al,%eax
  1035e8:	85 c0                	test   %eax,%eax
  1035ea:	74 0e                	je     1035fa <default_check+0x29d>
  1035ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035ef:	83 c0 28             	add    $0x28,%eax
  1035f2:	8b 40 08             	mov    0x8(%eax),%eax
  1035f5:	83 f8 03             	cmp    $0x3,%eax
  1035f8:	74 24                	je     10361e <default_check+0x2c1>
  1035fa:	c7 44 24 0c 04 67 10 	movl   $0x106704,0xc(%esp)
  103601:	00 
  103602:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103609:	00 
  10360a:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  103611:	00 
  103612:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103619:	e8 a8 d6 ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10361e:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103625:	e8 94 06 00 00       	call   103cbe <alloc_pages>
  10362a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10362d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103631:	75 24                	jne    103657 <default_check+0x2fa>
  103633:	c7 44 24 0c 30 67 10 	movl   $0x106730,0xc(%esp)
  10363a:	00 
  10363b:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103642:	00 
  103643:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  10364a:	00 
  10364b:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103652:	e8 6f d6 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  103657:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10365e:	e8 5b 06 00 00       	call   103cbe <alloc_pages>
  103663:	85 c0                	test   %eax,%eax
  103665:	74 24                	je     10368b <default_check+0x32e>
  103667:	c7 44 24 0c 46 66 10 	movl   $0x106646,0xc(%esp)
  10366e:	00 
  10366f:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103676:	00 
  103677:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
  10367e:	00 
  10367f:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103686:	e8 3b d6 ff ff       	call   100cc6 <__panic>
    assert(p0 + 2 == p1);
  10368b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10368e:	83 c0 28             	add    $0x28,%eax
  103691:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103694:	74 24                	je     1036ba <default_check+0x35d>
  103696:	c7 44 24 0c 4e 67 10 	movl   $0x10674e,0xc(%esp)
  10369d:	00 
  10369e:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  1036a5:	00 
  1036a6:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  1036ad:	00 
  1036ae:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1036b5:	e8 0c d6 ff ff       	call   100cc6 <__panic>

    p2 = p0 + 1;
  1036ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036bd:	83 c0 14             	add    $0x14,%eax
  1036c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1036c3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036ca:	00 
  1036cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036ce:	89 04 24             	mov    %eax,(%esp)
  1036d1:	e8 20 06 00 00       	call   103cf6 <free_pages>
    free_pages(p1, 3);
  1036d6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1036dd:	00 
  1036de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036e1:	89 04 24             	mov    %eax,(%esp)
  1036e4:	e8 0d 06 00 00       	call   103cf6 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1036e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036ec:	83 c0 04             	add    $0x4,%eax
  1036ef:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1036f6:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036f9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1036fc:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1036ff:	0f a3 10             	bt     %edx,(%eax)
  103702:	19 c0                	sbb    %eax,%eax
  103704:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103707:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10370b:	0f 95 c0             	setne  %al
  10370e:	0f b6 c0             	movzbl %al,%eax
  103711:	85 c0                	test   %eax,%eax
  103713:	74 0b                	je     103720 <default_check+0x3c3>
  103715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103718:	8b 40 08             	mov    0x8(%eax),%eax
  10371b:	83 f8 01             	cmp    $0x1,%eax
  10371e:	74 24                	je     103744 <default_check+0x3e7>
  103720:	c7 44 24 0c 5c 67 10 	movl   $0x10675c,0xc(%esp)
  103727:	00 
  103728:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  10372f:	00 
  103730:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  103737:	00 
  103738:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  10373f:	e8 82 d5 ff ff       	call   100cc6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103744:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103747:	83 c0 04             	add    $0x4,%eax
  10374a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103751:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103754:	8b 45 90             	mov    -0x70(%ebp),%eax
  103757:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10375a:	0f a3 10             	bt     %edx,(%eax)
  10375d:	19 c0                	sbb    %eax,%eax
  10375f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103762:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103766:	0f 95 c0             	setne  %al
  103769:	0f b6 c0             	movzbl %al,%eax
  10376c:	85 c0                	test   %eax,%eax
  10376e:	74 0b                	je     10377b <default_check+0x41e>
  103770:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103773:	8b 40 08             	mov    0x8(%eax),%eax
  103776:	83 f8 03             	cmp    $0x3,%eax
  103779:	74 24                	je     10379f <default_check+0x442>
  10377b:	c7 44 24 0c 84 67 10 	movl   $0x106784,0xc(%esp)
  103782:	00 
  103783:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  10378a:	00 
  10378b:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  103792:	00 
  103793:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  10379a:	e8 27 d5 ff ff       	call   100cc6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  10379f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037a6:	e8 13 05 00 00       	call   103cbe <alloc_pages>
  1037ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037b1:	83 e8 14             	sub    $0x14,%eax
  1037b4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037b7:	74 24                	je     1037dd <default_check+0x480>
  1037b9:	c7 44 24 0c aa 67 10 	movl   $0x1067aa,0xc(%esp)
  1037c0:	00 
  1037c1:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  1037c8:	00 
  1037c9:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  1037d0:	00 
  1037d1:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1037d8:	e8 e9 d4 ff ff       	call   100cc6 <__panic>
    free_page(p0);
  1037dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037e4:	00 
  1037e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037e8:	89 04 24             	mov    %eax,(%esp)
  1037eb:	e8 06 05 00 00       	call   103cf6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1037f0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1037f7:	e8 c2 04 00 00       	call   103cbe <alloc_pages>
  1037fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103802:	83 c0 14             	add    $0x14,%eax
  103805:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103808:	74 24                	je     10382e <default_check+0x4d1>
  10380a:	c7 44 24 0c c8 67 10 	movl   $0x1067c8,0xc(%esp)
  103811:	00 
  103812:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103819:	00 
  10381a:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  103821:	00 
  103822:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103829:	e8 98 d4 ff ff       	call   100cc6 <__panic>

    free_pages(p0, 2);
  10382e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103835:	00 
  103836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103839:	89 04 24             	mov    %eax,(%esp)
  10383c:	e8 b5 04 00 00       	call   103cf6 <free_pages>
    free_page(p2);
  103841:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103848:	00 
  103849:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10384c:	89 04 24             	mov    %eax,(%esp)
  10384f:	e8 a2 04 00 00       	call   103cf6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103854:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10385b:	e8 5e 04 00 00       	call   103cbe <alloc_pages>
  103860:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103863:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103867:	75 24                	jne    10388d <default_check+0x530>
  103869:	c7 44 24 0c e8 67 10 	movl   $0x1067e8,0xc(%esp)
  103870:	00 
  103871:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103878:	00 
  103879:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  103880:	00 
  103881:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  103888:	e8 39 d4 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  10388d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103894:	e8 25 04 00 00       	call   103cbe <alloc_pages>
  103899:	85 c0                	test   %eax,%eax
  10389b:	74 24                	je     1038c1 <default_check+0x564>
  10389d:	c7 44 24 0c 46 66 10 	movl   $0x106646,0xc(%esp)
  1038a4:	00 
  1038a5:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  1038ac:	00 
  1038ad:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  1038b4:	00 
  1038b5:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1038bc:	e8 05 d4 ff ff       	call   100cc6 <__panic>

    assert(nr_free == 0);
  1038c1:	a1 58 89 11 00       	mov    0x118958,%eax
  1038c6:	85 c0                	test   %eax,%eax
  1038c8:	74 24                	je     1038ee <default_check+0x591>
  1038ca:	c7 44 24 0c 99 66 10 	movl   $0x106699,0xc(%esp)
  1038d1:	00 
  1038d2:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  1038d9:	00 
  1038da:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  1038e1:	00 
  1038e2:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1038e9:	e8 d8 d3 ff ff       	call   100cc6 <__panic>
    nr_free = nr_free_store;
  1038ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038f1:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  1038f6:	8b 45 80             	mov    -0x80(%ebp),%eax
  1038f9:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1038fc:	a3 50 89 11 00       	mov    %eax,0x118950
  103901:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  103907:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  10390e:	00 
  10390f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103912:	89 04 24             	mov    %eax,(%esp)
  103915:	e8 dc 03 00 00       	call   103cf6 <free_pages>

    le = &free_list;
  10391a:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103921:	eb 1d                	jmp    103940 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103926:	83 e8 0c             	sub    $0xc,%eax
  103929:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  10392c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103930:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103933:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103936:	8b 40 08             	mov    0x8(%eax),%eax
  103939:	29 c2                	sub    %eax,%edx
  10393b:	89 d0                	mov    %edx,%eax
  10393d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103940:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103943:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103946:	8b 45 88             	mov    -0x78(%ebp),%eax
  103949:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10394c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10394f:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103956:	75 cb                	jne    103923 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10395c:	74 24                	je     103982 <default_check+0x625>
  10395e:	c7 44 24 0c 06 68 10 	movl   $0x106806,0xc(%esp)
  103965:	00 
  103966:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  10396d:	00 
  10396e:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  103975:	00 
  103976:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  10397d:	e8 44 d3 ff ff       	call   100cc6 <__panic>
    assert(total == 0);
  103982:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103986:	74 24                	je     1039ac <default_check+0x64f>
  103988:	c7 44 24 0c 11 68 10 	movl   $0x106811,0xc(%esp)
  10398f:	00 
  103990:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  103997:	00 
  103998:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  10399f:	00 
  1039a0:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  1039a7:	e8 1a d3 ff ff       	call   100cc6 <__panic>
}
  1039ac:	81 c4 94 00 00 00    	add    $0x94,%esp
  1039b2:	5b                   	pop    %ebx
  1039b3:	5d                   	pop    %ebp
  1039b4:	c3                   	ret    

001039b5 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1039b5:	55                   	push   %ebp
  1039b6:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1039b8:	8b 55 08             	mov    0x8(%ebp),%edx
  1039bb:	a1 64 89 11 00       	mov    0x118964,%eax
  1039c0:	29 c2                	sub    %eax,%edx
  1039c2:	89 d0                	mov    %edx,%eax
  1039c4:	c1 f8 02             	sar    $0x2,%eax
  1039c7:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1039cd:	5d                   	pop    %ebp
  1039ce:	c3                   	ret    

001039cf <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1039cf:	55                   	push   %ebp
  1039d0:	89 e5                	mov    %esp,%ebp
  1039d2:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1039d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1039d8:	89 04 24             	mov    %eax,(%esp)
  1039db:	e8 d5 ff ff ff       	call   1039b5 <page2ppn>
  1039e0:	c1 e0 0c             	shl    $0xc,%eax
}
  1039e3:	c9                   	leave  
  1039e4:	c3                   	ret    

001039e5 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1039e5:	55                   	push   %ebp
  1039e6:	89 e5                	mov    %esp,%ebp
  1039e8:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  1039eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1039ee:	c1 e8 0c             	shr    $0xc,%eax
  1039f1:	89 c2                	mov    %eax,%edx
  1039f3:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1039f8:	39 c2                	cmp    %eax,%edx
  1039fa:	72 1c                	jb     103a18 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  1039fc:	c7 44 24 08 4c 68 10 	movl   $0x10684c,0x8(%esp)
  103a03:	00 
  103a04:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103a0b:	00 
  103a0c:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103a13:	e8 ae d2 ff ff       	call   100cc6 <__panic>
    }
    return &pages[PPN(pa)];
  103a18:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  103a21:	c1 e8 0c             	shr    $0xc,%eax
  103a24:	89 c2                	mov    %eax,%edx
  103a26:	89 d0                	mov    %edx,%eax
  103a28:	c1 e0 02             	shl    $0x2,%eax
  103a2b:	01 d0                	add    %edx,%eax
  103a2d:	c1 e0 02             	shl    $0x2,%eax
  103a30:	01 c8                	add    %ecx,%eax
}
  103a32:	c9                   	leave  
  103a33:	c3                   	ret    

00103a34 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a34:	55                   	push   %ebp
  103a35:	89 e5                	mov    %esp,%ebp
  103a37:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  103a3d:	89 04 24             	mov    %eax,(%esp)
  103a40:	e8 8a ff ff ff       	call   1039cf <page2pa>
  103a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a4b:	c1 e8 0c             	shr    $0xc,%eax
  103a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a51:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a56:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a59:	72 23                	jb     103a7e <page2kva+0x4a>
  103a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103a62:	c7 44 24 08 7c 68 10 	movl   $0x10687c,0x8(%esp)
  103a69:	00 
  103a6a:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103a71:	00 
  103a72:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103a79:	e8 48 d2 ff ff       	call   100cc6 <__panic>
  103a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a81:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103a86:	c9                   	leave  
  103a87:	c3                   	ret    

00103a88 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103a88:	55                   	push   %ebp
  103a89:	89 e5                	mov    %esp,%ebp
  103a8b:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  103a91:	83 e0 01             	and    $0x1,%eax
  103a94:	85 c0                	test   %eax,%eax
  103a96:	75 1c                	jne    103ab4 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103a98:	c7 44 24 08 a0 68 10 	movl   $0x1068a0,0x8(%esp)
  103a9f:	00 
  103aa0:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103aa7:	00 
  103aa8:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103aaf:	e8 12 d2 ff ff       	call   100cc6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  103ab7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103abc:	89 04 24             	mov    %eax,(%esp)
  103abf:	e8 21 ff ff ff       	call   1039e5 <pa2page>
}
  103ac4:	c9                   	leave  
  103ac5:	c3                   	ret    

00103ac6 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103ac6:	55                   	push   %ebp
  103ac7:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  103acc:	8b 00                	mov    (%eax),%eax
}
  103ace:	5d                   	pop    %ebp
  103acf:	c3                   	ret    

00103ad0 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  103ad0:	55                   	push   %ebp
  103ad1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad6:	8b 00                	mov    (%eax),%eax
  103ad8:	8d 50 01             	lea    0x1(%eax),%edx
  103adb:	8b 45 08             	mov    0x8(%ebp),%eax
  103ade:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  103ae3:	8b 00                	mov    (%eax),%eax
}
  103ae5:	5d                   	pop    %ebp
  103ae6:	c3                   	ret    

00103ae7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103ae7:	55                   	push   %ebp
  103ae8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103aea:	8b 45 08             	mov    0x8(%ebp),%eax
  103aed:	8b 00                	mov    (%eax),%eax
  103aef:	8d 50 ff             	lea    -0x1(%eax),%edx
  103af2:	8b 45 08             	mov    0x8(%ebp),%eax
  103af5:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103af7:	8b 45 08             	mov    0x8(%ebp),%eax
  103afa:	8b 00                	mov    (%eax),%eax
}
  103afc:	5d                   	pop    %ebp
  103afd:	c3                   	ret    

00103afe <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103afe:	55                   	push   %ebp
  103aff:	89 e5                	mov    %esp,%ebp
  103b01:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b04:	9c                   	pushf  
  103b05:	58                   	pop    %eax
  103b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b0c:	25 00 02 00 00       	and    $0x200,%eax
  103b11:	85 c0                	test   %eax,%eax
  103b13:	74 0c                	je     103b21 <__intr_save+0x23>
        intr_disable();
  103b15:	e8 8f db ff ff       	call   1016a9 <intr_disable>
        return 1;
  103b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  103b1f:	eb 05                	jmp    103b26 <__intr_save+0x28>
    }
    return 0;
  103b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b26:	c9                   	leave  
  103b27:	c3                   	ret    

00103b28 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b28:	55                   	push   %ebp
  103b29:	89 e5                	mov    %esp,%ebp
  103b2b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b32:	74 05                	je     103b39 <__intr_restore+0x11>
        intr_enable();
  103b34:	e8 6a db ff ff       	call   1016a3 <intr_enable>
    }
}
  103b39:	c9                   	leave  
  103b3a:	c3                   	ret    

00103b3b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103b3b:	55                   	push   %ebp
  103b3c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  103b41:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103b44:	b8 23 00 00 00       	mov    $0x23,%eax
  103b49:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103b4b:	b8 23 00 00 00       	mov    $0x23,%eax
  103b50:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103b52:	b8 10 00 00 00       	mov    $0x10,%eax
  103b57:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103b59:	b8 10 00 00 00       	mov    $0x10,%eax
  103b5e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103b60:	b8 10 00 00 00       	mov    $0x10,%eax
  103b65:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103b67:	ea 6e 3b 10 00 08 00 	ljmp   $0x8,$0x103b6e
}
  103b6e:	5d                   	pop    %ebp
  103b6f:	c3                   	ret    

00103b70 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103b70:	55                   	push   %ebp
  103b71:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103b73:	8b 45 08             	mov    0x8(%ebp),%eax
  103b76:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103b7b:	5d                   	pop    %ebp
  103b7c:	c3                   	ret    

00103b7d <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103b7d:	55                   	push   %ebp
  103b7e:	89 e5                	mov    %esp,%ebp
  103b80:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103b83:	b8 00 70 11 00       	mov    $0x117000,%eax
  103b88:	89 04 24             	mov    %eax,(%esp)
  103b8b:	e8 e0 ff ff ff       	call   103b70 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103b90:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103b97:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103b99:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103ba0:	68 00 
  103ba2:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103ba7:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103bad:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103bb2:	c1 e8 10             	shr    $0x10,%eax
  103bb5:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103bba:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bc1:	83 e0 f0             	and    $0xfffffff0,%eax
  103bc4:	83 c8 09             	or     $0x9,%eax
  103bc7:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bcc:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bd3:	83 e0 ef             	and    $0xffffffef,%eax
  103bd6:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bdb:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103be2:	83 e0 9f             	and    $0xffffff9f,%eax
  103be5:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bea:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bf1:	83 c8 80             	or     $0xffffff80,%eax
  103bf4:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bf9:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c00:	83 e0 f0             	and    $0xfffffff0,%eax
  103c03:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c08:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c0f:	83 e0 ef             	and    $0xffffffef,%eax
  103c12:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c17:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c1e:	83 e0 df             	and    $0xffffffdf,%eax
  103c21:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c26:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c2d:	83 c8 40             	or     $0x40,%eax
  103c30:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c35:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c3c:	83 e0 7f             	and    $0x7f,%eax
  103c3f:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c44:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c49:	c1 e8 18             	shr    $0x18,%eax
  103c4c:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103c51:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103c58:	e8 de fe ff ff       	call   103b3b <lgdt>
  103c5d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103c63:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103c67:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103c6a:	c9                   	leave  
  103c6b:	c3                   	ret    

00103c6c <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103c6c:	55                   	push   %ebp
  103c6d:	89 e5                	mov    %esp,%ebp
  103c6f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103c72:	c7 05 5c 89 11 00 30 	movl   $0x106830,0x11895c
  103c79:	68 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103c7c:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c81:	8b 00                	mov    (%eax),%eax
  103c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  103c87:	c7 04 24 cc 68 10 00 	movl   $0x1068cc,(%esp)
  103c8e:	e8 a9 c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103c93:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c98:	8b 40 04             	mov    0x4(%eax),%eax
  103c9b:	ff d0                	call   *%eax
}
  103c9d:	c9                   	leave  
  103c9e:	c3                   	ret    

00103c9f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103c9f:	55                   	push   %ebp
  103ca0:	89 e5                	mov    %esp,%ebp
  103ca2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103ca5:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103caa:	8b 40 08             	mov    0x8(%eax),%eax
  103cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  103cb0:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  103cb7:	89 14 24             	mov    %edx,(%esp)
  103cba:	ff d0                	call   *%eax
}
  103cbc:	c9                   	leave  
  103cbd:	c3                   	ret    

00103cbe <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103cbe:	55                   	push   %ebp
  103cbf:	89 e5                	mov    %esp,%ebp
  103cc1:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103cc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103ccb:	e8 2e fe ff ff       	call   103afe <__intr_save>
  103cd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103cd3:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cd8:	8b 40 0c             	mov    0xc(%eax),%eax
  103cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  103cde:	89 14 24             	mov    %edx,(%esp)
  103ce1:	ff d0                	call   *%eax
  103ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ce9:	89 04 24             	mov    %eax,(%esp)
  103cec:	e8 37 fe ff ff       	call   103b28 <__intr_restore>
    return page;
  103cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103cf4:	c9                   	leave  
  103cf5:	c3                   	ret    

00103cf6 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103cf6:	55                   	push   %ebp
  103cf7:	89 e5                	mov    %esp,%ebp
  103cf9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103cfc:	e8 fd fd ff ff       	call   103afe <__intr_save>
  103d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d04:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d09:	8b 40 10             	mov    0x10(%eax),%eax
  103d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d0f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d13:	8b 55 08             	mov    0x8(%ebp),%edx
  103d16:	89 14 24             	mov    %edx,(%esp)
  103d19:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d1e:	89 04 24             	mov    %eax,(%esp)
  103d21:	e8 02 fe ff ff       	call   103b28 <__intr_restore>
}
  103d26:	c9                   	leave  
  103d27:	c3                   	ret    

00103d28 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d28:	55                   	push   %ebp
  103d29:	89 e5                	mov    %esp,%ebp
  103d2b:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d2e:	e8 cb fd ff ff       	call   103afe <__intr_save>
  103d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103d36:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d3b:	8b 40 14             	mov    0x14(%eax),%eax
  103d3e:	ff d0                	call   *%eax
  103d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d46:	89 04 24             	mov    %eax,(%esp)
  103d49:	e8 da fd ff ff       	call   103b28 <__intr_restore>
    return ret;
  103d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103d51:	c9                   	leave  
  103d52:	c3                   	ret    

00103d53 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103d53:	55                   	push   %ebp
  103d54:	89 e5                	mov    %esp,%ebp
  103d56:	57                   	push   %edi
  103d57:	56                   	push   %esi
  103d58:	53                   	push   %ebx
  103d59:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103d5f:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103d66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103d6d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103d74:	c7 04 24 e3 68 10 00 	movl   $0x1068e3,(%esp)
  103d7b:	e8 bc c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103d80:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103d87:	e9 15 01 00 00       	jmp    103ea1 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103d8c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d92:	89 d0                	mov    %edx,%eax
  103d94:	c1 e0 02             	shl    $0x2,%eax
  103d97:	01 d0                	add    %edx,%eax
  103d99:	c1 e0 02             	shl    $0x2,%eax
  103d9c:	01 c8                	add    %ecx,%eax
  103d9e:	8b 50 08             	mov    0x8(%eax),%edx
  103da1:	8b 40 04             	mov    0x4(%eax),%eax
  103da4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103da7:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103daa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103db0:	89 d0                	mov    %edx,%eax
  103db2:	c1 e0 02             	shl    $0x2,%eax
  103db5:	01 d0                	add    %edx,%eax
  103db7:	c1 e0 02             	shl    $0x2,%eax
  103dba:	01 c8                	add    %ecx,%eax
  103dbc:	8b 48 0c             	mov    0xc(%eax),%ecx
  103dbf:	8b 58 10             	mov    0x10(%eax),%ebx
  103dc2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103dc5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103dc8:	01 c8                	add    %ecx,%eax
  103dca:	11 da                	adc    %ebx,%edx
  103dcc:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103dcf:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103dd2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dd5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dd8:	89 d0                	mov    %edx,%eax
  103dda:	c1 e0 02             	shl    $0x2,%eax
  103ddd:	01 d0                	add    %edx,%eax
  103ddf:	c1 e0 02             	shl    $0x2,%eax
  103de2:	01 c8                	add    %ecx,%eax
  103de4:	83 c0 14             	add    $0x14,%eax
  103de7:	8b 00                	mov    (%eax),%eax
  103de9:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103def:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103df2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103df5:	83 c0 ff             	add    $0xffffffff,%eax
  103df8:	83 d2 ff             	adc    $0xffffffff,%edx
  103dfb:	89 c6                	mov    %eax,%esi
  103dfd:	89 d7                	mov    %edx,%edi
  103dff:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e02:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e05:	89 d0                	mov    %edx,%eax
  103e07:	c1 e0 02             	shl    $0x2,%eax
  103e0a:	01 d0                	add    %edx,%eax
  103e0c:	c1 e0 02             	shl    $0x2,%eax
  103e0f:	01 c8                	add    %ecx,%eax
  103e11:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e14:	8b 58 10             	mov    0x10(%eax),%ebx
  103e17:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e1d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e21:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e25:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e29:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e2c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e33:	89 54 24 10          	mov    %edx,0x10(%esp)
  103e37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e3f:	c7 04 24 f0 68 10 00 	movl   $0x1068f0,(%esp)
  103e46:	e8 f1 c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103e4b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e51:	89 d0                	mov    %edx,%eax
  103e53:	c1 e0 02             	shl    $0x2,%eax
  103e56:	01 d0                	add    %edx,%eax
  103e58:	c1 e0 02             	shl    $0x2,%eax
  103e5b:	01 c8                	add    %ecx,%eax
  103e5d:	83 c0 14             	add    $0x14,%eax
  103e60:	8b 00                	mov    (%eax),%eax
  103e62:	83 f8 01             	cmp    $0x1,%eax
  103e65:	75 36                	jne    103e9d <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103e67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e6d:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e70:	77 2b                	ja     103e9d <page_init+0x14a>
  103e72:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e75:	72 05                	jb     103e7c <page_init+0x129>
  103e77:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103e7a:	73 21                	jae    103e9d <page_init+0x14a>
  103e7c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e80:	77 1b                	ja     103e9d <page_init+0x14a>
  103e82:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e86:	72 09                	jb     103e91 <page_init+0x13e>
  103e88:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103e8f:	77 0c                	ja     103e9d <page_init+0x14a>
                maxpa = end;
  103e91:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e94:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e97:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103e9a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e9d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103ea1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103ea4:	8b 00                	mov    (%eax),%eax
  103ea6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103ea9:	0f 8f dd fe ff ff    	jg     103d8c <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103eaf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103eb3:	72 1d                	jb     103ed2 <page_init+0x17f>
  103eb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103eb9:	77 09                	ja     103ec4 <page_init+0x171>
  103ebb:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103ec2:	76 0e                	jbe    103ed2 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103ec4:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103ecb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103ed2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ed5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ed8:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103edc:	c1 ea 0c             	shr    $0xc,%edx
  103edf:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103ee4:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103eeb:	b8 68 89 11 00       	mov    $0x118968,%eax
  103ef0:	8d 50 ff             	lea    -0x1(%eax),%edx
  103ef3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103ef6:	01 d0                	add    %edx,%eax
  103ef8:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103efb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103efe:	ba 00 00 00 00       	mov    $0x0,%edx
  103f03:	f7 75 ac             	divl   -0x54(%ebp)
  103f06:	89 d0                	mov    %edx,%eax
  103f08:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f0b:	29 c2                	sub    %eax,%edx
  103f0d:	89 d0                	mov    %edx,%eax
  103f0f:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103f14:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f1b:	eb 2f                	jmp    103f4c <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f1d:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103f23:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f26:	89 d0                	mov    %edx,%eax
  103f28:	c1 e0 02             	shl    $0x2,%eax
  103f2b:	01 d0                	add    %edx,%eax
  103f2d:	c1 e0 02             	shl    $0x2,%eax
  103f30:	01 c8                	add    %ecx,%eax
  103f32:	83 c0 04             	add    $0x4,%eax
  103f35:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103f3c:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f3f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103f42:	8b 55 90             	mov    -0x70(%ebp),%edx
  103f45:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103f48:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f4f:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103f54:	39 c2                	cmp    %eax,%edx
  103f56:	72 c5                	jb     103f1d <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103f58:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103f5e:	89 d0                	mov    %edx,%eax
  103f60:	c1 e0 02             	shl    $0x2,%eax
  103f63:	01 d0                	add    %edx,%eax
  103f65:	c1 e0 02             	shl    $0x2,%eax
  103f68:	89 c2                	mov    %eax,%edx
  103f6a:	a1 64 89 11 00       	mov    0x118964,%eax
  103f6f:	01 d0                	add    %edx,%eax
  103f71:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103f74:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103f7b:	77 23                	ja     103fa0 <page_init+0x24d>
  103f7d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f80:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f84:	c7 44 24 08 20 69 10 	movl   $0x106920,0x8(%esp)
  103f8b:	00 
  103f8c:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103f93:	00 
  103f94:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  103f9b:	e8 26 cd ff ff       	call   100cc6 <__panic>
  103fa0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fa3:	05 00 00 00 40       	add    $0x40000000,%eax
  103fa8:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103fab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fb2:	e9 74 01 00 00       	jmp    10412b <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103fb7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fbd:	89 d0                	mov    %edx,%eax
  103fbf:	c1 e0 02             	shl    $0x2,%eax
  103fc2:	01 d0                	add    %edx,%eax
  103fc4:	c1 e0 02             	shl    $0x2,%eax
  103fc7:	01 c8                	add    %ecx,%eax
  103fc9:	8b 50 08             	mov    0x8(%eax),%edx
  103fcc:	8b 40 04             	mov    0x4(%eax),%eax
  103fcf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103fd2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103fd5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fd8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fdb:	89 d0                	mov    %edx,%eax
  103fdd:	c1 e0 02             	shl    $0x2,%eax
  103fe0:	01 d0                	add    %edx,%eax
  103fe2:	c1 e0 02             	shl    $0x2,%eax
  103fe5:	01 c8                	add    %ecx,%eax
  103fe7:	8b 48 0c             	mov    0xc(%eax),%ecx
  103fea:	8b 58 10             	mov    0x10(%eax),%ebx
  103fed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103ff0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103ff3:	01 c8                	add    %ecx,%eax
  103ff5:	11 da                	adc    %ebx,%edx
  103ff7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103ffa:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103ffd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104000:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104003:	89 d0                	mov    %edx,%eax
  104005:	c1 e0 02             	shl    $0x2,%eax
  104008:	01 d0                	add    %edx,%eax
  10400a:	c1 e0 02             	shl    $0x2,%eax
  10400d:	01 c8                	add    %ecx,%eax
  10400f:	83 c0 14             	add    $0x14,%eax
  104012:	8b 00                	mov    (%eax),%eax
  104014:	83 f8 01             	cmp    $0x1,%eax
  104017:	0f 85 0a 01 00 00    	jne    104127 <page_init+0x3d4>
            if (begin < freemem) {
  10401d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104020:	ba 00 00 00 00       	mov    $0x0,%edx
  104025:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104028:	72 17                	jb     104041 <page_init+0x2ee>
  10402a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10402d:	77 05                	ja     104034 <page_init+0x2e1>
  10402f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104032:	76 0d                	jbe    104041 <page_init+0x2ee>
                begin = freemem;
  104034:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104037:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10403a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104041:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104045:	72 1d                	jb     104064 <page_init+0x311>
  104047:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10404b:	77 09                	ja     104056 <page_init+0x303>
  10404d:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  104054:	76 0e                	jbe    104064 <page_init+0x311>
                end = KMEMSIZE;
  104056:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  10405d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  104064:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104067:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10406a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10406d:	0f 87 b4 00 00 00    	ja     104127 <page_init+0x3d4>
  104073:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104076:	72 09                	jb     104081 <page_init+0x32e>
  104078:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10407b:	0f 83 a6 00 00 00    	jae    104127 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104081:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104088:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10408b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10408e:	01 d0                	add    %edx,%eax
  104090:	83 e8 01             	sub    $0x1,%eax
  104093:	89 45 98             	mov    %eax,-0x68(%ebp)
  104096:	8b 45 98             	mov    -0x68(%ebp),%eax
  104099:	ba 00 00 00 00       	mov    $0x0,%edx
  10409e:	f7 75 9c             	divl   -0x64(%ebp)
  1040a1:	89 d0                	mov    %edx,%eax
  1040a3:	8b 55 98             	mov    -0x68(%ebp),%edx
  1040a6:	29 c2                	sub    %eax,%edx
  1040a8:	89 d0                	mov    %edx,%eax
  1040aa:	ba 00 00 00 00       	mov    $0x0,%edx
  1040af:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1040b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040b8:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1040bb:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1040be:	ba 00 00 00 00       	mov    $0x0,%edx
  1040c3:	89 c7                	mov    %eax,%edi
  1040c5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1040cb:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1040ce:	89 d0                	mov    %edx,%eax
  1040d0:	83 e0 00             	and    $0x0,%eax
  1040d3:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1040d6:	8b 45 80             	mov    -0x80(%ebp),%eax
  1040d9:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1040dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1040df:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1040e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040e8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040eb:	77 3a                	ja     104127 <page_init+0x3d4>
  1040ed:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040f0:	72 05                	jb     1040f7 <page_init+0x3a4>
  1040f2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1040f5:	73 30                	jae    104127 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1040f7:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1040fa:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1040fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104100:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104103:	29 c8                	sub    %ecx,%eax
  104105:	19 da                	sbb    %ebx,%edx
  104107:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10410b:	c1 ea 0c             	shr    $0xc,%edx
  10410e:	89 c3                	mov    %eax,%ebx
  104110:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104113:	89 04 24             	mov    %eax,(%esp)
  104116:	e8 ca f8 ff ff       	call   1039e5 <pa2page>
  10411b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10411f:	89 04 24             	mov    %eax,(%esp)
  104122:	e8 78 fb ff ff       	call   103c9f <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  104127:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10412b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10412e:	8b 00                	mov    (%eax),%eax
  104130:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104133:	0f 8f 7e fe ff ff    	jg     103fb7 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104139:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  10413f:	5b                   	pop    %ebx
  104140:	5e                   	pop    %esi
  104141:	5f                   	pop    %edi
  104142:	5d                   	pop    %ebp
  104143:	c3                   	ret    

00104144 <enable_paging>:

static void
enable_paging(void) {
  104144:	55                   	push   %ebp
  104145:	89 e5                	mov    %esp,%ebp
  104147:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  10414a:	a1 60 89 11 00       	mov    0x118960,%eax
  10414f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104152:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104155:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  104158:	0f 20 c0             	mov    %cr0,%eax
  10415b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  10415e:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  104161:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  104164:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  10416b:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  10416f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104172:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  104175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104178:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  10417b:	c9                   	leave  
  10417c:	c3                   	ret    

0010417d <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10417d:	55                   	push   %ebp
  10417e:	89 e5                	mov    %esp,%ebp
  104180:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104183:	8b 45 14             	mov    0x14(%ebp),%eax
  104186:	8b 55 0c             	mov    0xc(%ebp),%edx
  104189:	31 d0                	xor    %edx,%eax
  10418b:	25 ff 0f 00 00       	and    $0xfff,%eax
  104190:	85 c0                	test   %eax,%eax
  104192:	74 24                	je     1041b8 <boot_map_segment+0x3b>
  104194:	c7 44 24 0c 52 69 10 	movl   $0x106952,0xc(%esp)
  10419b:	00 
  10419c:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  1041a3:	00 
  1041a4:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1041ab:	00 
  1041ac:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  1041b3:	e8 0e cb ff ff       	call   100cc6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1041b8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1041bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041c2:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041c7:	89 c2                	mov    %eax,%edx
  1041c9:	8b 45 10             	mov    0x10(%ebp),%eax
  1041cc:	01 c2                	add    %eax,%edx
  1041ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041d1:	01 d0                	add    %edx,%eax
  1041d3:	83 e8 01             	sub    $0x1,%eax
  1041d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1041d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041dc:	ba 00 00 00 00       	mov    $0x0,%edx
  1041e1:	f7 75 f0             	divl   -0x10(%ebp)
  1041e4:	89 d0                	mov    %edx,%eax
  1041e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1041e9:	29 c2                	sub    %eax,%edx
  1041eb:	89 d0                	mov    %edx,%eax
  1041ed:	c1 e8 0c             	shr    $0xc,%eax
  1041f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1041f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1041f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1041fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104201:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104204:	8b 45 14             	mov    0x14(%ebp),%eax
  104207:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10420a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10420d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104212:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104215:	eb 6b                	jmp    104282 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104217:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10421e:	00 
  10421f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104222:	89 44 24 04          	mov    %eax,0x4(%esp)
  104226:	8b 45 08             	mov    0x8(%ebp),%eax
  104229:	89 04 24             	mov    %eax,(%esp)
  10422c:	e8 cc 01 00 00       	call   1043fd <get_pte>
  104231:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104234:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104238:	75 24                	jne    10425e <boot_map_segment+0xe1>
  10423a:	c7 44 24 0c 7e 69 10 	movl   $0x10697e,0xc(%esp)
  104241:	00 
  104242:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104249:	00 
  10424a:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104251:	00 
  104252:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104259:	e8 68 ca ff ff       	call   100cc6 <__panic>
        *ptep = pa | PTE_P | perm;
  10425e:	8b 45 18             	mov    0x18(%ebp),%eax
  104261:	8b 55 14             	mov    0x14(%ebp),%edx
  104264:	09 d0                	or     %edx,%eax
  104266:	83 c8 01             	or     $0x1,%eax
  104269:	89 c2                	mov    %eax,%edx
  10426b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10426e:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104270:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104274:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10427b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104286:	75 8f                	jne    104217 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104288:	c9                   	leave  
  104289:	c3                   	ret    

0010428a <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10428a:	55                   	push   %ebp
  10428b:	89 e5                	mov    %esp,%ebp
  10428d:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104297:	e8 22 fa ff ff       	call   103cbe <alloc_pages>
  10429c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10429f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042a3:	75 1c                	jne    1042c1 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1042a5:	c7 44 24 08 8b 69 10 	movl   $0x10698b,0x8(%esp)
  1042ac:	00 
  1042ad:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1042b4:	00 
  1042b5:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  1042bc:	e8 05 ca ff ff       	call   100cc6 <__panic>
    }
    return page2kva(p);
  1042c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042c4:	89 04 24             	mov    %eax,(%esp)
  1042c7:	e8 68 f7 ff ff       	call   103a34 <page2kva>
}
  1042cc:	c9                   	leave  
  1042cd:	c3                   	ret    

001042ce <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1042ce:	55                   	push   %ebp
  1042cf:	89 e5                	mov    %esp,%ebp
  1042d1:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1042d4:	e8 93 f9 ff ff       	call   103c6c <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1042d9:	e8 75 fa ff ff       	call   103d53 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1042de:	e8 d7 02 00 00       	call   1045ba <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1042e3:	e8 a2 ff ff ff       	call   10428a <boot_alloc_page>
  1042e8:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  1042ed:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042f2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1042f9:	00 
  1042fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104301:	00 
  104302:	89 04 24             	mov    %eax,(%esp)
  104305:	e8 19 19 00 00       	call   105c23 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  10430a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10430f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104312:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104319:	77 23                	ja     10433e <pmm_init+0x70>
  10431b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10431e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104322:	c7 44 24 08 20 69 10 	movl   $0x106920,0x8(%esp)
  104329:	00 
  10432a:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104331:	00 
  104332:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104339:	e8 88 c9 ff ff       	call   100cc6 <__panic>
  10433e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104341:	05 00 00 00 40       	add    $0x40000000,%eax
  104346:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  10434b:	e8 88 02 00 00       	call   1045d8 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104350:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104355:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  10435b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104360:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104363:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10436a:	77 23                	ja     10438f <pmm_init+0xc1>
  10436c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10436f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104373:	c7 44 24 08 20 69 10 	movl   $0x106920,0x8(%esp)
  10437a:	00 
  10437b:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104382:	00 
  104383:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  10438a:	e8 37 c9 ff ff       	call   100cc6 <__panic>
  10438f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104392:	05 00 00 00 40       	add    $0x40000000,%eax
  104397:	83 c8 03             	or     $0x3,%eax
  10439a:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10439c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043a1:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1043a8:	00 
  1043a9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1043b0:	00 
  1043b1:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1043b8:	38 
  1043b9:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1043c0:	c0 
  1043c1:	89 04 24             	mov    %eax,(%esp)
  1043c4:	e8 b4 fd ff ff       	call   10417d <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1043c9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043ce:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  1043d4:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1043da:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1043dc:	e8 63 fd ff ff       	call   104144 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1043e1:	e8 97 f7 ff ff       	call   103b7d <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1043e6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1043f1:	e8 7d 08 00 00       	call   104c73 <check_boot_pgdir>

    print_pgdir();
  1043f6:	e8 0a 0d 00 00       	call   105105 <print_pgdir>

}
  1043fb:	c9                   	leave  
  1043fc:	c3                   	ret    

001043fd <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1043fd:	55                   	push   %ebp
  1043fe:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  104400:	5d                   	pop    %ebp
  104401:	c3                   	ret    

00104402 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104402:	55                   	push   %ebp
  104403:	89 e5                	mov    %esp,%ebp
  104405:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104408:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10440f:	00 
  104410:	8b 45 0c             	mov    0xc(%ebp),%eax
  104413:	89 44 24 04          	mov    %eax,0x4(%esp)
  104417:	8b 45 08             	mov    0x8(%ebp),%eax
  10441a:	89 04 24             	mov    %eax,(%esp)
  10441d:	e8 db ff ff ff       	call   1043fd <get_pte>
  104422:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104425:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104429:	74 08                	je     104433 <get_page+0x31>
        *ptep_store = ptep;
  10442b:	8b 45 10             	mov    0x10(%ebp),%eax
  10442e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104431:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104433:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104437:	74 1b                	je     104454 <get_page+0x52>
  104439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10443c:	8b 00                	mov    (%eax),%eax
  10443e:	83 e0 01             	and    $0x1,%eax
  104441:	85 c0                	test   %eax,%eax
  104443:	74 0f                	je     104454 <get_page+0x52>
        return pa2page(*ptep);
  104445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104448:	8b 00                	mov    (%eax),%eax
  10444a:	89 04 24             	mov    %eax,(%esp)
  10444d:	e8 93 f5 ff ff       	call   1039e5 <pa2page>
  104452:	eb 05                	jmp    104459 <get_page+0x57>
    }
    return NULL;
  104454:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104459:	c9                   	leave  
  10445a:	c3                   	ret    

0010445b <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10445b:	55                   	push   %ebp
  10445c:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  10445e:	5d                   	pop    %ebp
  10445f:	c3                   	ret    

00104460 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104460:	55                   	push   %ebp
  104461:	89 e5                	mov    %esp,%ebp
  104463:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104466:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10446d:	00 
  10446e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104471:	89 44 24 04          	mov    %eax,0x4(%esp)
  104475:	8b 45 08             	mov    0x8(%ebp),%eax
  104478:	89 04 24             	mov    %eax,(%esp)
  10447b:	e8 7d ff ff ff       	call   1043fd <get_pte>
  104480:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  104483:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  104487:	74 19                	je     1044a2 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104489:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10448c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104490:	8b 45 0c             	mov    0xc(%ebp),%eax
  104493:	89 44 24 04          	mov    %eax,0x4(%esp)
  104497:	8b 45 08             	mov    0x8(%ebp),%eax
  10449a:	89 04 24             	mov    %eax,(%esp)
  10449d:	e8 b9 ff ff ff       	call   10445b <page_remove_pte>
    }
}
  1044a2:	c9                   	leave  
  1044a3:	c3                   	ret    

001044a4 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1044a4:	55                   	push   %ebp
  1044a5:	89 e5                	mov    %esp,%ebp
  1044a7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1044aa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1044b1:	00 
  1044b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1044b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1044bc:	89 04 24             	mov    %eax,(%esp)
  1044bf:	e8 39 ff ff ff       	call   1043fd <get_pte>
  1044c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1044c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044cb:	75 0a                	jne    1044d7 <page_insert+0x33>
        return -E_NO_MEM;
  1044cd:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1044d2:	e9 84 00 00 00       	jmp    10455b <page_insert+0xb7>
    }
    page_ref_inc(page);
  1044d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044da:	89 04 24             	mov    %eax,(%esp)
  1044dd:	e8 ee f5 ff ff       	call   103ad0 <page_ref_inc>
    if (*ptep & PTE_P) {
  1044e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044e5:	8b 00                	mov    (%eax),%eax
  1044e7:	83 e0 01             	and    $0x1,%eax
  1044ea:	85 c0                	test   %eax,%eax
  1044ec:	74 3e                	je     10452c <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1044ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044f1:	8b 00                	mov    (%eax),%eax
  1044f3:	89 04 24             	mov    %eax,(%esp)
  1044f6:	e8 8d f5 ff ff       	call   103a88 <pte2page>
  1044fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1044fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104501:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104504:	75 0d                	jne    104513 <page_insert+0x6f>
            page_ref_dec(page);
  104506:	8b 45 0c             	mov    0xc(%ebp),%eax
  104509:	89 04 24             	mov    %eax,(%esp)
  10450c:	e8 d6 f5 ff ff       	call   103ae7 <page_ref_dec>
  104511:	eb 19                	jmp    10452c <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104516:	89 44 24 08          	mov    %eax,0x8(%esp)
  10451a:	8b 45 10             	mov    0x10(%ebp),%eax
  10451d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104521:	8b 45 08             	mov    0x8(%ebp),%eax
  104524:	89 04 24             	mov    %eax,(%esp)
  104527:	e8 2f ff ff ff       	call   10445b <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10452c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10452f:	89 04 24             	mov    %eax,(%esp)
  104532:	e8 98 f4 ff ff       	call   1039cf <page2pa>
  104537:	0b 45 14             	or     0x14(%ebp),%eax
  10453a:	83 c8 01             	or     $0x1,%eax
  10453d:	89 c2                	mov    %eax,%edx
  10453f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104542:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104544:	8b 45 10             	mov    0x10(%ebp),%eax
  104547:	89 44 24 04          	mov    %eax,0x4(%esp)
  10454b:	8b 45 08             	mov    0x8(%ebp),%eax
  10454e:	89 04 24             	mov    %eax,(%esp)
  104551:	e8 07 00 00 00       	call   10455d <tlb_invalidate>
    return 0;
  104556:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10455b:	c9                   	leave  
  10455c:	c3                   	ret    

0010455d <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10455d:	55                   	push   %ebp
  10455e:	89 e5                	mov    %esp,%ebp
  104560:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104563:	0f 20 d8             	mov    %cr3,%eax
  104566:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104569:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  10456c:	89 c2                	mov    %eax,%edx
  10456e:	8b 45 08             	mov    0x8(%ebp),%eax
  104571:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104574:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10457b:	77 23                	ja     1045a0 <tlb_invalidate+0x43>
  10457d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104580:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104584:	c7 44 24 08 20 69 10 	movl   $0x106920,0x8(%esp)
  10458b:	00 
  10458c:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
  104593:	00 
  104594:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  10459b:	e8 26 c7 ff ff       	call   100cc6 <__panic>
  1045a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045a3:	05 00 00 00 40       	add    $0x40000000,%eax
  1045a8:	39 c2                	cmp    %eax,%edx
  1045aa:	75 0c                	jne    1045b8 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  1045ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045af:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1045b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045b5:	0f 01 38             	invlpg (%eax)
    }
}
  1045b8:	c9                   	leave  
  1045b9:	c3                   	ret    

001045ba <check_alloc_page>:

static void
check_alloc_page(void) {
  1045ba:	55                   	push   %ebp
  1045bb:	89 e5                	mov    %esp,%ebp
  1045bd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1045c0:	a1 5c 89 11 00       	mov    0x11895c,%eax
  1045c5:	8b 40 18             	mov    0x18(%eax),%eax
  1045c8:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1045ca:	c7 04 24 a4 69 10 00 	movl   $0x1069a4,(%esp)
  1045d1:	e8 66 bd ff ff       	call   10033c <cprintf>
}
  1045d6:	c9                   	leave  
  1045d7:	c3                   	ret    

001045d8 <check_pgdir>:

static void
check_pgdir(void) {
  1045d8:	55                   	push   %ebp
  1045d9:	89 e5                	mov    %esp,%ebp
  1045db:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1045de:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1045e3:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1045e8:	76 24                	jbe    10460e <check_pgdir+0x36>
  1045ea:	c7 44 24 0c c3 69 10 	movl   $0x1069c3,0xc(%esp)
  1045f1:	00 
  1045f2:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  1045f9:	00 
  1045fa:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  104601:	00 
  104602:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104609:	e8 b8 c6 ff ff       	call   100cc6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10460e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104613:	85 c0                	test   %eax,%eax
  104615:	74 0e                	je     104625 <check_pgdir+0x4d>
  104617:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10461c:	25 ff 0f 00 00       	and    $0xfff,%eax
  104621:	85 c0                	test   %eax,%eax
  104623:	74 24                	je     104649 <check_pgdir+0x71>
  104625:	c7 44 24 0c e0 69 10 	movl   $0x1069e0,0xc(%esp)
  10462c:	00 
  10462d:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104634:	00 
  104635:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  10463c:	00 
  10463d:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104644:	e8 7d c6 ff ff       	call   100cc6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104649:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10464e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104655:	00 
  104656:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10465d:	00 
  10465e:	89 04 24             	mov    %eax,(%esp)
  104661:	e8 9c fd ff ff       	call   104402 <get_page>
  104666:	85 c0                	test   %eax,%eax
  104668:	74 24                	je     10468e <check_pgdir+0xb6>
  10466a:	c7 44 24 0c 18 6a 10 	movl   $0x106a18,0xc(%esp)
  104671:	00 
  104672:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104679:	00 
  10467a:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  104681:	00 
  104682:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104689:	e8 38 c6 ff ff       	call   100cc6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10468e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104695:	e8 24 f6 ff ff       	call   103cbe <alloc_pages>
  10469a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10469d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1046a2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1046a9:	00 
  1046aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1046b1:	00 
  1046b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1046b5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1046b9:	89 04 24             	mov    %eax,(%esp)
  1046bc:	e8 e3 fd ff ff       	call   1044a4 <page_insert>
  1046c1:	85 c0                	test   %eax,%eax
  1046c3:	74 24                	je     1046e9 <check_pgdir+0x111>
  1046c5:	c7 44 24 0c 40 6a 10 	movl   $0x106a40,0xc(%esp)
  1046cc:	00 
  1046cd:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  1046d4:	00 
  1046d5:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  1046dc:	00 
  1046dd:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  1046e4:	e8 dd c5 ff ff       	call   100cc6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1046e9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1046ee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1046f5:	00 
  1046f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046fd:	00 
  1046fe:	89 04 24             	mov    %eax,(%esp)
  104701:	e8 f7 fc ff ff       	call   1043fd <get_pte>
  104706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104709:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10470d:	75 24                	jne    104733 <check_pgdir+0x15b>
  10470f:	c7 44 24 0c 6c 6a 10 	movl   $0x106a6c,0xc(%esp)
  104716:	00 
  104717:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  10471e:	00 
  10471f:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  104726:	00 
  104727:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  10472e:	e8 93 c5 ff ff       	call   100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
  104733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104736:	8b 00                	mov    (%eax),%eax
  104738:	89 04 24             	mov    %eax,(%esp)
  10473b:	e8 a5 f2 ff ff       	call   1039e5 <pa2page>
  104740:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104743:	74 24                	je     104769 <check_pgdir+0x191>
  104745:	c7 44 24 0c 99 6a 10 	movl   $0x106a99,0xc(%esp)
  10474c:	00 
  10474d:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104754:	00 
  104755:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  10475c:	00 
  10475d:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104764:	e8 5d c5 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p1) == 1);
  104769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10476c:	89 04 24             	mov    %eax,(%esp)
  10476f:	e8 52 f3 ff ff       	call   103ac6 <page_ref>
  104774:	83 f8 01             	cmp    $0x1,%eax
  104777:	74 24                	je     10479d <check_pgdir+0x1c5>
  104779:	c7 44 24 0c ae 6a 10 	movl   $0x106aae,0xc(%esp)
  104780:	00 
  104781:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104788:	00 
  104789:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  104790:	00 
  104791:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104798:	e8 29 c5 ff ff       	call   100cc6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10479d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047a2:	8b 00                	mov    (%eax),%eax
  1047a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1047a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1047ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047af:	c1 e8 0c             	shr    $0xc,%eax
  1047b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1047b5:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1047ba:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1047bd:	72 23                	jb     1047e2 <check_pgdir+0x20a>
  1047bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1047c6:	c7 44 24 08 7c 68 10 	movl   $0x10687c,0x8(%esp)
  1047cd:	00 
  1047ce:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  1047d5:	00 
  1047d6:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  1047dd:	e8 e4 c4 ff ff       	call   100cc6 <__panic>
  1047e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047e5:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1047ea:	83 c0 04             	add    $0x4,%eax
  1047ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1047f0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047f5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047fc:	00 
  1047fd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104804:	00 
  104805:	89 04 24             	mov    %eax,(%esp)
  104808:	e8 f0 fb ff ff       	call   1043fd <get_pte>
  10480d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104810:	74 24                	je     104836 <check_pgdir+0x25e>
  104812:	c7 44 24 0c c0 6a 10 	movl   $0x106ac0,0xc(%esp)
  104819:	00 
  10481a:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104821:	00 
  104822:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  104829:	00 
  10482a:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104831:	e8 90 c4 ff ff       	call   100cc6 <__panic>

    p2 = alloc_page();
  104836:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10483d:	e8 7c f4 ff ff       	call   103cbe <alloc_pages>
  104842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104845:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10484a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104851:	00 
  104852:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104859:	00 
  10485a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10485d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104861:	89 04 24             	mov    %eax,(%esp)
  104864:	e8 3b fc ff ff       	call   1044a4 <page_insert>
  104869:	85 c0                	test   %eax,%eax
  10486b:	74 24                	je     104891 <check_pgdir+0x2b9>
  10486d:	c7 44 24 0c e8 6a 10 	movl   $0x106ae8,0xc(%esp)
  104874:	00 
  104875:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  10487c:	00 
  10487d:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  104884:	00 
  104885:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  10488c:	e8 35 c4 ff ff       	call   100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104891:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104896:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10489d:	00 
  10489e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1048a5:	00 
  1048a6:	89 04 24             	mov    %eax,(%esp)
  1048a9:	e8 4f fb ff ff       	call   1043fd <get_pte>
  1048ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048b5:	75 24                	jne    1048db <check_pgdir+0x303>
  1048b7:	c7 44 24 0c 20 6b 10 	movl   $0x106b20,0xc(%esp)
  1048be:	00 
  1048bf:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  1048c6:	00 
  1048c7:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  1048ce:	00 
  1048cf:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  1048d6:	e8 eb c3 ff ff       	call   100cc6 <__panic>
    assert(*ptep & PTE_U);
  1048db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048de:	8b 00                	mov    (%eax),%eax
  1048e0:	83 e0 04             	and    $0x4,%eax
  1048e3:	85 c0                	test   %eax,%eax
  1048e5:	75 24                	jne    10490b <check_pgdir+0x333>
  1048e7:	c7 44 24 0c 50 6b 10 	movl   $0x106b50,0xc(%esp)
  1048ee:	00 
  1048ef:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  1048f6:	00 
  1048f7:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  1048fe:	00 
  1048ff:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104906:	e8 bb c3 ff ff       	call   100cc6 <__panic>
    assert(*ptep & PTE_W);
  10490b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10490e:	8b 00                	mov    (%eax),%eax
  104910:	83 e0 02             	and    $0x2,%eax
  104913:	85 c0                	test   %eax,%eax
  104915:	75 24                	jne    10493b <check_pgdir+0x363>
  104917:	c7 44 24 0c 5e 6b 10 	movl   $0x106b5e,0xc(%esp)
  10491e:	00 
  10491f:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104926:	00 
  104927:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  10492e:	00 
  10492f:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104936:	e8 8b c3 ff ff       	call   100cc6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  10493b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104940:	8b 00                	mov    (%eax),%eax
  104942:	83 e0 04             	and    $0x4,%eax
  104945:	85 c0                	test   %eax,%eax
  104947:	75 24                	jne    10496d <check_pgdir+0x395>
  104949:	c7 44 24 0c 6c 6b 10 	movl   $0x106b6c,0xc(%esp)
  104950:	00 
  104951:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104958:	00 
  104959:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  104960:	00 
  104961:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104968:	e8 59 c3 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 1);
  10496d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104970:	89 04 24             	mov    %eax,(%esp)
  104973:	e8 4e f1 ff ff       	call   103ac6 <page_ref>
  104978:	83 f8 01             	cmp    $0x1,%eax
  10497b:	74 24                	je     1049a1 <check_pgdir+0x3c9>
  10497d:	c7 44 24 0c 82 6b 10 	movl   $0x106b82,0xc(%esp)
  104984:	00 
  104985:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  10498c:	00 
  10498d:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  104994:	00 
  104995:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  10499c:	e8 25 c3 ff ff       	call   100cc6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  1049a1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049a6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1049ad:	00 
  1049ae:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1049b5:	00 
  1049b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1049b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1049bd:	89 04 24             	mov    %eax,(%esp)
  1049c0:	e8 df fa ff ff       	call   1044a4 <page_insert>
  1049c5:	85 c0                	test   %eax,%eax
  1049c7:	74 24                	je     1049ed <check_pgdir+0x415>
  1049c9:	c7 44 24 0c 94 6b 10 	movl   $0x106b94,0xc(%esp)
  1049d0:	00 
  1049d1:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  1049d8:	00 
  1049d9:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  1049e0:	00 
  1049e1:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  1049e8:	e8 d9 c2 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p1) == 2);
  1049ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049f0:	89 04 24             	mov    %eax,(%esp)
  1049f3:	e8 ce f0 ff ff       	call   103ac6 <page_ref>
  1049f8:	83 f8 02             	cmp    $0x2,%eax
  1049fb:	74 24                	je     104a21 <check_pgdir+0x449>
  1049fd:	c7 44 24 0c c0 6b 10 	movl   $0x106bc0,0xc(%esp)
  104a04:	00 
  104a05:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104a0c:	00 
  104a0d:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  104a14:	00 
  104a15:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104a1c:	e8 a5 c2 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a24:	89 04 24             	mov    %eax,(%esp)
  104a27:	e8 9a f0 ff ff       	call   103ac6 <page_ref>
  104a2c:	85 c0                	test   %eax,%eax
  104a2e:	74 24                	je     104a54 <check_pgdir+0x47c>
  104a30:	c7 44 24 0c d2 6b 10 	movl   $0x106bd2,0xc(%esp)
  104a37:	00 
  104a38:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104a3f:	00 
  104a40:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104a47:	00 
  104a48:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104a4f:	e8 72 c2 ff ff       	call   100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a54:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a59:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a60:	00 
  104a61:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a68:	00 
  104a69:	89 04 24             	mov    %eax,(%esp)
  104a6c:	e8 8c f9 ff ff       	call   1043fd <get_pte>
  104a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a78:	75 24                	jne    104a9e <check_pgdir+0x4c6>
  104a7a:	c7 44 24 0c 20 6b 10 	movl   $0x106b20,0xc(%esp)
  104a81:	00 
  104a82:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104a89:	00 
  104a8a:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104a91:	00 
  104a92:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104a99:	e8 28 c2 ff ff       	call   100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
  104a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104aa1:	8b 00                	mov    (%eax),%eax
  104aa3:	89 04 24             	mov    %eax,(%esp)
  104aa6:	e8 3a ef ff ff       	call   1039e5 <pa2page>
  104aab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104aae:	74 24                	je     104ad4 <check_pgdir+0x4fc>
  104ab0:	c7 44 24 0c 99 6a 10 	movl   $0x106a99,0xc(%esp)
  104ab7:	00 
  104ab8:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104abf:	00 
  104ac0:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  104ac7:	00 
  104ac8:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104acf:	e8 f2 c1 ff ff       	call   100cc6 <__panic>
    assert((*ptep & PTE_U) == 0);
  104ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ad7:	8b 00                	mov    (%eax),%eax
  104ad9:	83 e0 04             	and    $0x4,%eax
  104adc:	85 c0                	test   %eax,%eax
  104ade:	74 24                	je     104b04 <check_pgdir+0x52c>
  104ae0:	c7 44 24 0c e4 6b 10 	movl   $0x106be4,0xc(%esp)
  104ae7:	00 
  104ae8:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104aef:	00 
  104af0:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  104af7:	00 
  104af8:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104aff:	e8 c2 c1 ff ff       	call   100cc6 <__panic>

    page_remove(boot_pgdir, 0x0);
  104b04:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b09:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104b10:	00 
  104b11:	89 04 24             	mov    %eax,(%esp)
  104b14:	e8 47 f9 ff ff       	call   104460 <page_remove>
    assert(page_ref(p1) == 1);
  104b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b1c:	89 04 24             	mov    %eax,(%esp)
  104b1f:	e8 a2 ef ff ff       	call   103ac6 <page_ref>
  104b24:	83 f8 01             	cmp    $0x1,%eax
  104b27:	74 24                	je     104b4d <check_pgdir+0x575>
  104b29:	c7 44 24 0c ae 6a 10 	movl   $0x106aae,0xc(%esp)
  104b30:	00 
  104b31:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104b38:	00 
  104b39:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104b40:	00 
  104b41:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104b48:	e8 79 c1 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b50:	89 04 24             	mov    %eax,(%esp)
  104b53:	e8 6e ef ff ff       	call   103ac6 <page_ref>
  104b58:	85 c0                	test   %eax,%eax
  104b5a:	74 24                	je     104b80 <check_pgdir+0x5a8>
  104b5c:	c7 44 24 0c d2 6b 10 	movl   $0x106bd2,0xc(%esp)
  104b63:	00 
  104b64:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104b6b:	00 
  104b6c:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104b73:	00 
  104b74:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104b7b:	e8 46 c1 ff ff       	call   100cc6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104b80:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b85:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b8c:	00 
  104b8d:	89 04 24             	mov    %eax,(%esp)
  104b90:	e8 cb f8 ff ff       	call   104460 <page_remove>
    assert(page_ref(p1) == 0);
  104b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b98:	89 04 24             	mov    %eax,(%esp)
  104b9b:	e8 26 ef ff ff       	call   103ac6 <page_ref>
  104ba0:	85 c0                	test   %eax,%eax
  104ba2:	74 24                	je     104bc8 <check_pgdir+0x5f0>
  104ba4:	c7 44 24 0c f9 6b 10 	movl   $0x106bf9,0xc(%esp)
  104bab:	00 
  104bac:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104bb3:	00 
  104bb4:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104bbb:	00 
  104bbc:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104bc3:	e8 fe c0 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104bc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bcb:	89 04 24             	mov    %eax,(%esp)
  104bce:	e8 f3 ee ff ff       	call   103ac6 <page_ref>
  104bd3:	85 c0                	test   %eax,%eax
  104bd5:	74 24                	je     104bfb <check_pgdir+0x623>
  104bd7:	c7 44 24 0c d2 6b 10 	movl   $0x106bd2,0xc(%esp)
  104bde:	00 
  104bdf:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104be6:	00 
  104be7:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104bee:	00 
  104bef:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104bf6:	e8 cb c0 ff ff       	call   100cc6 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104bfb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c00:	8b 00                	mov    (%eax),%eax
  104c02:	89 04 24             	mov    %eax,(%esp)
  104c05:	e8 db ed ff ff       	call   1039e5 <pa2page>
  104c0a:	89 04 24             	mov    %eax,(%esp)
  104c0d:	e8 b4 ee ff ff       	call   103ac6 <page_ref>
  104c12:	83 f8 01             	cmp    $0x1,%eax
  104c15:	74 24                	je     104c3b <check_pgdir+0x663>
  104c17:	c7 44 24 0c 0c 6c 10 	movl   $0x106c0c,0xc(%esp)
  104c1e:	00 
  104c1f:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104c26:	00 
  104c27:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104c2e:	00 
  104c2f:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104c36:	e8 8b c0 ff ff       	call   100cc6 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104c3b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c40:	8b 00                	mov    (%eax),%eax
  104c42:	89 04 24             	mov    %eax,(%esp)
  104c45:	e8 9b ed ff ff       	call   1039e5 <pa2page>
  104c4a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104c51:	00 
  104c52:	89 04 24             	mov    %eax,(%esp)
  104c55:	e8 9c f0 ff ff       	call   103cf6 <free_pages>
    boot_pgdir[0] = 0;
  104c5a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104c65:	c7 04 24 32 6c 10 00 	movl   $0x106c32,(%esp)
  104c6c:	e8 cb b6 ff ff       	call   10033c <cprintf>
}
  104c71:	c9                   	leave  
  104c72:	c3                   	ret    

00104c73 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104c73:	55                   	push   %ebp
  104c74:	89 e5                	mov    %esp,%ebp
  104c76:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104c79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104c80:	e9 ca 00 00 00       	jmp    104d4f <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c8e:	c1 e8 0c             	shr    $0xc,%eax
  104c91:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104c94:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104c99:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104c9c:	72 23                	jb     104cc1 <check_boot_pgdir+0x4e>
  104c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ca1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104ca5:	c7 44 24 08 7c 68 10 	movl   $0x10687c,0x8(%esp)
  104cac:	00 
  104cad:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104cb4:	00 
  104cb5:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104cbc:	e8 05 c0 ff ff       	call   100cc6 <__panic>
  104cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cc4:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104cc9:	89 c2                	mov    %eax,%edx
  104ccb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cd0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104cd7:	00 
  104cd8:	89 54 24 04          	mov    %edx,0x4(%esp)
  104cdc:	89 04 24             	mov    %eax,(%esp)
  104cdf:	e8 19 f7 ff ff       	call   1043fd <get_pte>
  104ce4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104ce7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104ceb:	75 24                	jne    104d11 <check_boot_pgdir+0x9e>
  104ced:	c7 44 24 0c 4c 6c 10 	movl   $0x106c4c,0xc(%esp)
  104cf4:	00 
  104cf5:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104cfc:	00 
  104cfd:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104d04:	00 
  104d05:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104d0c:	e8 b5 bf ff ff       	call   100cc6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104d11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104d14:	8b 00                	mov    (%eax),%eax
  104d16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104d1b:	89 c2                	mov    %eax,%edx
  104d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d20:	39 c2                	cmp    %eax,%edx
  104d22:	74 24                	je     104d48 <check_boot_pgdir+0xd5>
  104d24:	c7 44 24 0c 89 6c 10 	movl   $0x106c89,0xc(%esp)
  104d2b:	00 
  104d2c:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104d33:	00 
  104d34:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104d3b:	00 
  104d3c:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104d43:	e8 7e bf ff ff       	call   100cc6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104d48:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104d4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104d52:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104d57:	39 c2                	cmp    %eax,%edx
  104d59:	0f 82 26 ff ff ff    	jb     104c85 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104d5f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d64:	05 ac 0f 00 00       	add    $0xfac,%eax
  104d69:	8b 00                	mov    (%eax),%eax
  104d6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104d70:	89 c2                	mov    %eax,%edx
  104d72:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104d7a:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104d81:	77 23                	ja     104da6 <check_boot_pgdir+0x133>
  104d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d86:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104d8a:	c7 44 24 08 20 69 10 	movl   $0x106920,0x8(%esp)
  104d91:	00 
  104d92:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104d99:	00 
  104d9a:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104da1:	e8 20 bf ff ff       	call   100cc6 <__panic>
  104da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104da9:	05 00 00 00 40       	add    $0x40000000,%eax
  104dae:	39 c2                	cmp    %eax,%edx
  104db0:	74 24                	je     104dd6 <check_boot_pgdir+0x163>
  104db2:	c7 44 24 0c a0 6c 10 	movl   $0x106ca0,0xc(%esp)
  104db9:	00 
  104dba:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104dc1:	00 
  104dc2:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104dc9:	00 
  104dca:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104dd1:	e8 f0 be ff ff       	call   100cc6 <__panic>

    assert(boot_pgdir[0] == 0);
  104dd6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ddb:	8b 00                	mov    (%eax),%eax
  104ddd:	85 c0                	test   %eax,%eax
  104ddf:	74 24                	je     104e05 <check_boot_pgdir+0x192>
  104de1:	c7 44 24 0c d4 6c 10 	movl   $0x106cd4,0xc(%esp)
  104de8:	00 
  104de9:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104df0:	00 
  104df1:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104df8:	00 
  104df9:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104e00:	e8 c1 be ff ff       	call   100cc6 <__panic>

    struct Page *p;
    p = alloc_page();
  104e05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e0c:	e8 ad ee ff ff       	call   103cbe <alloc_pages>
  104e11:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104e14:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e19:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104e20:	00 
  104e21:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104e28:	00 
  104e29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104e2c:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e30:	89 04 24             	mov    %eax,(%esp)
  104e33:	e8 6c f6 ff ff       	call   1044a4 <page_insert>
  104e38:	85 c0                	test   %eax,%eax
  104e3a:	74 24                	je     104e60 <check_boot_pgdir+0x1ed>
  104e3c:	c7 44 24 0c e8 6c 10 	movl   $0x106ce8,0xc(%esp)
  104e43:	00 
  104e44:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104e4b:	00 
  104e4c:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104e53:	00 
  104e54:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104e5b:	e8 66 be ff ff       	call   100cc6 <__panic>
    assert(page_ref(p) == 1);
  104e60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104e63:	89 04 24             	mov    %eax,(%esp)
  104e66:	e8 5b ec ff ff       	call   103ac6 <page_ref>
  104e6b:	83 f8 01             	cmp    $0x1,%eax
  104e6e:	74 24                	je     104e94 <check_boot_pgdir+0x221>
  104e70:	c7 44 24 0c 16 6d 10 	movl   $0x106d16,0xc(%esp)
  104e77:	00 
  104e78:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104e7f:	00 
  104e80:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104e87:	00 
  104e88:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104e8f:	e8 32 be ff ff       	call   100cc6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104e94:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e99:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104ea0:	00 
  104ea1:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104ea8:	00 
  104ea9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104eac:	89 54 24 04          	mov    %edx,0x4(%esp)
  104eb0:	89 04 24             	mov    %eax,(%esp)
  104eb3:	e8 ec f5 ff ff       	call   1044a4 <page_insert>
  104eb8:	85 c0                	test   %eax,%eax
  104eba:	74 24                	je     104ee0 <check_boot_pgdir+0x26d>
  104ebc:	c7 44 24 0c 28 6d 10 	movl   $0x106d28,0xc(%esp)
  104ec3:	00 
  104ec4:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104ecb:	00 
  104ecc:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104ed3:	00 
  104ed4:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104edb:	e8 e6 bd ff ff       	call   100cc6 <__panic>
    assert(page_ref(p) == 2);
  104ee0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ee3:	89 04 24             	mov    %eax,(%esp)
  104ee6:	e8 db eb ff ff       	call   103ac6 <page_ref>
  104eeb:	83 f8 02             	cmp    $0x2,%eax
  104eee:	74 24                	je     104f14 <check_boot_pgdir+0x2a1>
  104ef0:	c7 44 24 0c 5f 6d 10 	movl   $0x106d5f,0xc(%esp)
  104ef7:	00 
  104ef8:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104eff:	00 
  104f00:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104f07:	00 
  104f08:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104f0f:	e8 b2 bd ff ff       	call   100cc6 <__panic>

    const char *str = "ucore: Hello world!!";
  104f14:	c7 45 dc 70 6d 10 00 	movl   $0x106d70,-0x24(%ebp)
    strcpy((void *)0x100, str);
  104f1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f22:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f29:	e8 1e 0a 00 00       	call   10594c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104f2e:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104f35:	00 
  104f36:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f3d:	e8 83 0a 00 00       	call   1059c5 <strcmp>
  104f42:	85 c0                	test   %eax,%eax
  104f44:	74 24                	je     104f6a <check_boot_pgdir+0x2f7>
  104f46:	c7 44 24 0c 88 6d 10 	movl   $0x106d88,0xc(%esp)
  104f4d:	00 
  104f4e:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104f55:	00 
  104f56:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  104f5d:	00 
  104f5e:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104f65:	e8 5c bd ff ff       	call   100cc6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104f6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f6d:	89 04 24             	mov    %eax,(%esp)
  104f70:	e8 bf ea ff ff       	call   103a34 <page2kva>
  104f75:	05 00 01 00 00       	add    $0x100,%eax
  104f7a:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104f7d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f84:	e8 6b 09 00 00       	call   1058f4 <strlen>
  104f89:	85 c0                	test   %eax,%eax
  104f8b:	74 24                	je     104fb1 <check_boot_pgdir+0x33e>
  104f8d:	c7 44 24 0c c0 6d 10 	movl   $0x106dc0,0xc(%esp)
  104f94:	00 
  104f95:	c7 44 24 08 69 69 10 	movl   $0x106969,0x8(%esp)
  104f9c:	00 
  104f9d:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104fa4:	00 
  104fa5:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  104fac:	e8 15 bd ff ff       	call   100cc6 <__panic>

    free_page(p);
  104fb1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fb8:	00 
  104fb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104fbc:	89 04 24             	mov    %eax,(%esp)
  104fbf:	e8 32 ed ff ff       	call   103cf6 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  104fc4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fc9:	8b 00                	mov    (%eax),%eax
  104fcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104fd0:	89 04 24             	mov    %eax,(%esp)
  104fd3:	e8 0d ea ff ff       	call   1039e5 <pa2page>
  104fd8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fdf:	00 
  104fe0:	89 04 24             	mov    %eax,(%esp)
  104fe3:	e8 0e ed ff ff       	call   103cf6 <free_pages>
    boot_pgdir[0] = 0;
  104fe8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104ff3:	c7 04 24 e4 6d 10 00 	movl   $0x106de4,(%esp)
  104ffa:	e8 3d b3 ff ff       	call   10033c <cprintf>
}
  104fff:	c9                   	leave  
  105000:	c3                   	ret    

00105001 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105001:	55                   	push   %ebp
  105002:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105004:	8b 45 08             	mov    0x8(%ebp),%eax
  105007:	83 e0 04             	and    $0x4,%eax
  10500a:	85 c0                	test   %eax,%eax
  10500c:	74 07                	je     105015 <perm2str+0x14>
  10500e:	b8 75 00 00 00       	mov    $0x75,%eax
  105013:	eb 05                	jmp    10501a <perm2str+0x19>
  105015:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10501a:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  10501f:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105026:	8b 45 08             	mov    0x8(%ebp),%eax
  105029:	83 e0 02             	and    $0x2,%eax
  10502c:	85 c0                	test   %eax,%eax
  10502e:	74 07                	je     105037 <perm2str+0x36>
  105030:	b8 77 00 00 00       	mov    $0x77,%eax
  105035:	eb 05                	jmp    10503c <perm2str+0x3b>
  105037:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10503c:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  105041:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  105048:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  10504d:	5d                   	pop    %ebp
  10504e:	c3                   	ret    

0010504f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10504f:	55                   	push   %ebp
  105050:	89 e5                	mov    %esp,%ebp
  105052:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105055:	8b 45 10             	mov    0x10(%ebp),%eax
  105058:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10505b:	72 0a                	jb     105067 <get_pgtable_items+0x18>
        return 0;
  10505d:	b8 00 00 00 00       	mov    $0x0,%eax
  105062:	e9 9c 00 00 00       	jmp    105103 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105067:	eb 04                	jmp    10506d <get_pgtable_items+0x1e>
        start ++;
  105069:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  10506d:	8b 45 10             	mov    0x10(%ebp),%eax
  105070:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105073:	73 18                	jae    10508d <get_pgtable_items+0x3e>
  105075:	8b 45 10             	mov    0x10(%ebp),%eax
  105078:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10507f:	8b 45 14             	mov    0x14(%ebp),%eax
  105082:	01 d0                	add    %edx,%eax
  105084:	8b 00                	mov    (%eax),%eax
  105086:	83 e0 01             	and    $0x1,%eax
  105089:	85 c0                	test   %eax,%eax
  10508b:	74 dc                	je     105069 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  10508d:	8b 45 10             	mov    0x10(%ebp),%eax
  105090:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105093:	73 69                	jae    1050fe <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105095:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105099:	74 08                	je     1050a3 <get_pgtable_items+0x54>
            *left_store = start;
  10509b:	8b 45 18             	mov    0x18(%ebp),%eax
  10509e:	8b 55 10             	mov    0x10(%ebp),%edx
  1050a1:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1050a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1050a6:	8d 50 01             	lea    0x1(%eax),%edx
  1050a9:	89 55 10             	mov    %edx,0x10(%ebp)
  1050ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1050b3:	8b 45 14             	mov    0x14(%ebp),%eax
  1050b6:	01 d0                	add    %edx,%eax
  1050b8:	8b 00                	mov    (%eax),%eax
  1050ba:	83 e0 07             	and    $0x7,%eax
  1050bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1050c0:	eb 04                	jmp    1050c6 <get_pgtable_items+0x77>
            start ++;
  1050c2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1050c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1050c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050cc:	73 1d                	jae    1050eb <get_pgtable_items+0x9c>
  1050ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1050d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1050d8:	8b 45 14             	mov    0x14(%ebp),%eax
  1050db:	01 d0                	add    %edx,%eax
  1050dd:	8b 00                	mov    (%eax),%eax
  1050df:	83 e0 07             	and    $0x7,%eax
  1050e2:	89 c2                	mov    %eax,%edx
  1050e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1050e7:	39 c2                	cmp    %eax,%edx
  1050e9:	74 d7                	je     1050c2 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1050eb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1050ef:	74 08                	je     1050f9 <get_pgtable_items+0xaa>
            *right_store = start;
  1050f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1050f4:	8b 55 10             	mov    0x10(%ebp),%edx
  1050f7:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1050f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1050fc:	eb 05                	jmp    105103 <get_pgtable_items+0xb4>
    }
    return 0;
  1050fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105103:	c9                   	leave  
  105104:	c3                   	ret    

00105105 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105105:	55                   	push   %ebp
  105106:	89 e5                	mov    %esp,%ebp
  105108:	57                   	push   %edi
  105109:	56                   	push   %esi
  10510a:	53                   	push   %ebx
  10510b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10510e:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  105115:	e8 22 b2 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  10511a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105121:	e9 fa 00 00 00       	jmp    105220 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105129:	89 04 24             	mov    %eax,(%esp)
  10512c:	e8 d0 fe ff ff       	call   105001 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105131:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105134:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105137:	29 d1                	sub    %edx,%ecx
  105139:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10513b:	89 d6                	mov    %edx,%esi
  10513d:	c1 e6 16             	shl    $0x16,%esi
  105140:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105143:	89 d3                	mov    %edx,%ebx
  105145:	c1 e3 16             	shl    $0x16,%ebx
  105148:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10514b:	89 d1                	mov    %edx,%ecx
  10514d:	c1 e1 16             	shl    $0x16,%ecx
  105150:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105153:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105156:	29 d7                	sub    %edx,%edi
  105158:	89 fa                	mov    %edi,%edx
  10515a:	89 44 24 14          	mov    %eax,0x14(%esp)
  10515e:	89 74 24 10          	mov    %esi,0x10(%esp)
  105162:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105166:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10516a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10516e:	c7 04 24 35 6e 10 00 	movl   $0x106e35,(%esp)
  105175:	e8 c2 b1 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  10517a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10517d:	c1 e0 0a             	shl    $0xa,%eax
  105180:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105183:	eb 54                	jmp    1051d9 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105188:	89 04 24             	mov    %eax,(%esp)
  10518b:	e8 71 fe ff ff       	call   105001 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105190:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105193:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105196:	29 d1                	sub    %edx,%ecx
  105198:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10519a:	89 d6                	mov    %edx,%esi
  10519c:	c1 e6 0c             	shl    $0xc,%esi
  10519f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1051a2:	89 d3                	mov    %edx,%ebx
  1051a4:	c1 e3 0c             	shl    $0xc,%ebx
  1051a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1051aa:	c1 e2 0c             	shl    $0xc,%edx
  1051ad:	89 d1                	mov    %edx,%ecx
  1051af:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1051b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1051b5:	29 d7                	sub    %edx,%edi
  1051b7:	89 fa                	mov    %edi,%edx
  1051b9:	89 44 24 14          	mov    %eax,0x14(%esp)
  1051bd:	89 74 24 10          	mov    %esi,0x10(%esp)
  1051c1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1051c5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1051c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1051cd:	c7 04 24 54 6e 10 00 	movl   $0x106e54,(%esp)
  1051d4:	e8 63 b1 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1051d9:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1051de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1051e1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1051e4:	89 ce                	mov    %ecx,%esi
  1051e6:	c1 e6 0a             	shl    $0xa,%esi
  1051e9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1051ec:	89 cb                	mov    %ecx,%ebx
  1051ee:	c1 e3 0a             	shl    $0xa,%ebx
  1051f1:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1051f4:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1051f8:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1051fb:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1051ff:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105203:	89 44 24 08          	mov    %eax,0x8(%esp)
  105207:	89 74 24 04          	mov    %esi,0x4(%esp)
  10520b:	89 1c 24             	mov    %ebx,(%esp)
  10520e:	e8 3c fe ff ff       	call   10504f <get_pgtable_items>
  105213:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105216:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10521a:	0f 85 65 ff ff ff    	jne    105185 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105220:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  105225:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105228:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10522b:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10522f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105232:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105236:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10523a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10523e:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105245:	00 
  105246:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10524d:	e8 fd fd ff ff       	call   10504f <get_pgtable_items>
  105252:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105255:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105259:	0f 85 c7 fe ff ff    	jne    105126 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10525f:	c7 04 24 78 6e 10 00 	movl   $0x106e78,(%esp)
  105266:	e8 d1 b0 ff ff       	call   10033c <cprintf>
}
  10526b:	83 c4 4c             	add    $0x4c,%esp
  10526e:	5b                   	pop    %ebx
  10526f:	5e                   	pop    %esi
  105270:	5f                   	pop    %edi
  105271:	5d                   	pop    %ebp
  105272:	c3                   	ret    

00105273 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105273:	55                   	push   %ebp
  105274:	89 e5                	mov    %esp,%ebp
  105276:	83 ec 58             	sub    $0x58,%esp
  105279:	8b 45 10             	mov    0x10(%ebp),%eax
  10527c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10527f:	8b 45 14             	mov    0x14(%ebp),%eax
  105282:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105285:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105288:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10528b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10528e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105291:	8b 45 18             	mov    0x18(%ebp),%eax
  105294:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105297:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10529a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10529d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1052a0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1052a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1052a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1052ad:	74 1c                	je     1052cb <printnum+0x58>
  1052af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052b2:	ba 00 00 00 00       	mov    $0x0,%edx
  1052b7:	f7 75 e4             	divl   -0x1c(%ebp)
  1052ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1052bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052c0:	ba 00 00 00 00       	mov    $0x0,%edx
  1052c5:	f7 75 e4             	divl   -0x1c(%ebp)
  1052c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1052cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1052d1:	f7 75 e4             	divl   -0x1c(%ebp)
  1052d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1052d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1052da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1052e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1052e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1052e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1052e9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1052ec:	8b 45 18             	mov    0x18(%ebp),%eax
  1052ef:	ba 00 00 00 00       	mov    $0x0,%edx
  1052f4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1052f7:	77 56                	ja     10534f <printnum+0xdc>
  1052f9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1052fc:	72 05                	jb     105303 <printnum+0x90>
  1052fe:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105301:	77 4c                	ja     10534f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105303:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105306:	8d 50 ff             	lea    -0x1(%eax),%edx
  105309:	8b 45 20             	mov    0x20(%ebp),%eax
  10530c:	89 44 24 18          	mov    %eax,0x18(%esp)
  105310:	89 54 24 14          	mov    %edx,0x14(%esp)
  105314:	8b 45 18             	mov    0x18(%ebp),%eax
  105317:	89 44 24 10          	mov    %eax,0x10(%esp)
  10531b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10531e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105321:	89 44 24 08          	mov    %eax,0x8(%esp)
  105325:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105329:	8b 45 0c             	mov    0xc(%ebp),%eax
  10532c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105330:	8b 45 08             	mov    0x8(%ebp),%eax
  105333:	89 04 24             	mov    %eax,(%esp)
  105336:	e8 38 ff ff ff       	call   105273 <printnum>
  10533b:	eb 1c                	jmp    105359 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10533d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105340:	89 44 24 04          	mov    %eax,0x4(%esp)
  105344:	8b 45 20             	mov    0x20(%ebp),%eax
  105347:	89 04 24             	mov    %eax,(%esp)
  10534a:	8b 45 08             	mov    0x8(%ebp),%eax
  10534d:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10534f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105353:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105357:	7f e4                	jg     10533d <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105359:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10535c:	05 2c 6f 10 00       	add    $0x106f2c,%eax
  105361:	0f b6 00             	movzbl (%eax),%eax
  105364:	0f be c0             	movsbl %al,%eax
  105367:	8b 55 0c             	mov    0xc(%ebp),%edx
  10536a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10536e:	89 04 24             	mov    %eax,(%esp)
  105371:	8b 45 08             	mov    0x8(%ebp),%eax
  105374:	ff d0                	call   *%eax
}
  105376:	c9                   	leave  
  105377:	c3                   	ret    

00105378 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105378:	55                   	push   %ebp
  105379:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10537b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10537f:	7e 14                	jle    105395 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105381:	8b 45 08             	mov    0x8(%ebp),%eax
  105384:	8b 00                	mov    (%eax),%eax
  105386:	8d 48 08             	lea    0x8(%eax),%ecx
  105389:	8b 55 08             	mov    0x8(%ebp),%edx
  10538c:	89 0a                	mov    %ecx,(%edx)
  10538e:	8b 50 04             	mov    0x4(%eax),%edx
  105391:	8b 00                	mov    (%eax),%eax
  105393:	eb 30                	jmp    1053c5 <getuint+0x4d>
    }
    else if (lflag) {
  105395:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105399:	74 16                	je     1053b1 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10539b:	8b 45 08             	mov    0x8(%ebp),%eax
  10539e:	8b 00                	mov    (%eax),%eax
  1053a0:	8d 48 04             	lea    0x4(%eax),%ecx
  1053a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1053a6:	89 0a                	mov    %ecx,(%edx)
  1053a8:	8b 00                	mov    (%eax),%eax
  1053aa:	ba 00 00 00 00       	mov    $0x0,%edx
  1053af:	eb 14                	jmp    1053c5 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1053b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1053b4:	8b 00                	mov    (%eax),%eax
  1053b6:	8d 48 04             	lea    0x4(%eax),%ecx
  1053b9:	8b 55 08             	mov    0x8(%ebp),%edx
  1053bc:	89 0a                	mov    %ecx,(%edx)
  1053be:	8b 00                	mov    (%eax),%eax
  1053c0:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1053c5:	5d                   	pop    %ebp
  1053c6:	c3                   	ret    

001053c7 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1053c7:	55                   	push   %ebp
  1053c8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1053ca:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1053ce:	7e 14                	jle    1053e4 <getint+0x1d>
        return va_arg(*ap, long long);
  1053d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1053d3:	8b 00                	mov    (%eax),%eax
  1053d5:	8d 48 08             	lea    0x8(%eax),%ecx
  1053d8:	8b 55 08             	mov    0x8(%ebp),%edx
  1053db:	89 0a                	mov    %ecx,(%edx)
  1053dd:	8b 50 04             	mov    0x4(%eax),%edx
  1053e0:	8b 00                	mov    (%eax),%eax
  1053e2:	eb 28                	jmp    10540c <getint+0x45>
    }
    else if (lflag) {
  1053e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1053e8:	74 12                	je     1053fc <getint+0x35>
        return va_arg(*ap, long);
  1053ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1053ed:	8b 00                	mov    (%eax),%eax
  1053ef:	8d 48 04             	lea    0x4(%eax),%ecx
  1053f2:	8b 55 08             	mov    0x8(%ebp),%edx
  1053f5:	89 0a                	mov    %ecx,(%edx)
  1053f7:	8b 00                	mov    (%eax),%eax
  1053f9:	99                   	cltd   
  1053fa:	eb 10                	jmp    10540c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1053fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1053ff:	8b 00                	mov    (%eax),%eax
  105401:	8d 48 04             	lea    0x4(%eax),%ecx
  105404:	8b 55 08             	mov    0x8(%ebp),%edx
  105407:	89 0a                	mov    %ecx,(%edx)
  105409:	8b 00                	mov    (%eax),%eax
  10540b:	99                   	cltd   
    }
}
  10540c:	5d                   	pop    %ebp
  10540d:	c3                   	ret    

0010540e <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10540e:	55                   	push   %ebp
  10540f:	89 e5                	mov    %esp,%ebp
  105411:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105414:	8d 45 14             	lea    0x14(%ebp),%eax
  105417:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10541a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10541d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105421:	8b 45 10             	mov    0x10(%ebp),%eax
  105424:	89 44 24 08          	mov    %eax,0x8(%esp)
  105428:	8b 45 0c             	mov    0xc(%ebp),%eax
  10542b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10542f:	8b 45 08             	mov    0x8(%ebp),%eax
  105432:	89 04 24             	mov    %eax,(%esp)
  105435:	e8 02 00 00 00       	call   10543c <vprintfmt>
    va_end(ap);
}
  10543a:	c9                   	leave  
  10543b:	c3                   	ret    

0010543c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10543c:	55                   	push   %ebp
  10543d:	89 e5                	mov    %esp,%ebp
  10543f:	56                   	push   %esi
  105440:	53                   	push   %ebx
  105441:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105444:	eb 18                	jmp    10545e <vprintfmt+0x22>
            if (ch == '\0') {
  105446:	85 db                	test   %ebx,%ebx
  105448:	75 05                	jne    10544f <vprintfmt+0x13>
                return;
  10544a:	e9 d1 03 00 00       	jmp    105820 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  10544f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105452:	89 44 24 04          	mov    %eax,0x4(%esp)
  105456:	89 1c 24             	mov    %ebx,(%esp)
  105459:	8b 45 08             	mov    0x8(%ebp),%eax
  10545c:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10545e:	8b 45 10             	mov    0x10(%ebp),%eax
  105461:	8d 50 01             	lea    0x1(%eax),%edx
  105464:	89 55 10             	mov    %edx,0x10(%ebp)
  105467:	0f b6 00             	movzbl (%eax),%eax
  10546a:	0f b6 d8             	movzbl %al,%ebx
  10546d:	83 fb 25             	cmp    $0x25,%ebx
  105470:	75 d4                	jne    105446 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105472:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105476:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10547d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105480:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105483:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10548a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10548d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105490:	8b 45 10             	mov    0x10(%ebp),%eax
  105493:	8d 50 01             	lea    0x1(%eax),%edx
  105496:	89 55 10             	mov    %edx,0x10(%ebp)
  105499:	0f b6 00             	movzbl (%eax),%eax
  10549c:	0f b6 d8             	movzbl %al,%ebx
  10549f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1054a2:	83 f8 55             	cmp    $0x55,%eax
  1054a5:	0f 87 44 03 00 00    	ja     1057ef <vprintfmt+0x3b3>
  1054ab:	8b 04 85 50 6f 10 00 	mov    0x106f50(,%eax,4),%eax
  1054b2:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1054b4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1054b8:	eb d6                	jmp    105490 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1054ba:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1054be:	eb d0                	jmp    105490 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1054c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1054c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1054ca:	89 d0                	mov    %edx,%eax
  1054cc:	c1 e0 02             	shl    $0x2,%eax
  1054cf:	01 d0                	add    %edx,%eax
  1054d1:	01 c0                	add    %eax,%eax
  1054d3:	01 d8                	add    %ebx,%eax
  1054d5:	83 e8 30             	sub    $0x30,%eax
  1054d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1054db:	8b 45 10             	mov    0x10(%ebp),%eax
  1054de:	0f b6 00             	movzbl (%eax),%eax
  1054e1:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1054e4:	83 fb 2f             	cmp    $0x2f,%ebx
  1054e7:	7e 0b                	jle    1054f4 <vprintfmt+0xb8>
  1054e9:	83 fb 39             	cmp    $0x39,%ebx
  1054ec:	7f 06                	jg     1054f4 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1054ee:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1054f2:	eb d3                	jmp    1054c7 <vprintfmt+0x8b>
            goto process_precision;
  1054f4:	eb 33                	jmp    105529 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1054f6:	8b 45 14             	mov    0x14(%ebp),%eax
  1054f9:	8d 50 04             	lea    0x4(%eax),%edx
  1054fc:	89 55 14             	mov    %edx,0x14(%ebp)
  1054ff:	8b 00                	mov    (%eax),%eax
  105501:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105504:	eb 23                	jmp    105529 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  105506:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10550a:	79 0c                	jns    105518 <vprintfmt+0xdc>
                width = 0;
  10550c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105513:	e9 78 ff ff ff       	jmp    105490 <vprintfmt+0x54>
  105518:	e9 73 ff ff ff       	jmp    105490 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  10551d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105524:	e9 67 ff ff ff       	jmp    105490 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105529:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10552d:	79 12                	jns    105541 <vprintfmt+0x105>
                width = precision, precision = -1;
  10552f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105532:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105535:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10553c:	e9 4f ff ff ff       	jmp    105490 <vprintfmt+0x54>
  105541:	e9 4a ff ff ff       	jmp    105490 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105546:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10554a:	e9 41 ff ff ff       	jmp    105490 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10554f:	8b 45 14             	mov    0x14(%ebp),%eax
  105552:	8d 50 04             	lea    0x4(%eax),%edx
  105555:	89 55 14             	mov    %edx,0x14(%ebp)
  105558:	8b 00                	mov    (%eax),%eax
  10555a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10555d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105561:	89 04 24             	mov    %eax,(%esp)
  105564:	8b 45 08             	mov    0x8(%ebp),%eax
  105567:	ff d0                	call   *%eax
            break;
  105569:	e9 ac 02 00 00       	jmp    10581a <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10556e:	8b 45 14             	mov    0x14(%ebp),%eax
  105571:	8d 50 04             	lea    0x4(%eax),%edx
  105574:	89 55 14             	mov    %edx,0x14(%ebp)
  105577:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105579:	85 db                	test   %ebx,%ebx
  10557b:	79 02                	jns    10557f <vprintfmt+0x143>
                err = -err;
  10557d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10557f:	83 fb 06             	cmp    $0x6,%ebx
  105582:	7f 0b                	jg     10558f <vprintfmt+0x153>
  105584:	8b 34 9d 10 6f 10 00 	mov    0x106f10(,%ebx,4),%esi
  10558b:	85 f6                	test   %esi,%esi
  10558d:	75 23                	jne    1055b2 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  10558f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105593:	c7 44 24 08 3d 6f 10 	movl   $0x106f3d,0x8(%esp)
  10559a:	00 
  10559b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10559e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a5:	89 04 24             	mov    %eax,(%esp)
  1055a8:	e8 61 fe ff ff       	call   10540e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1055ad:	e9 68 02 00 00       	jmp    10581a <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1055b2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1055b6:	c7 44 24 08 46 6f 10 	movl   $0x106f46,0x8(%esp)
  1055bd:	00 
  1055be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c8:	89 04 24             	mov    %eax,(%esp)
  1055cb:	e8 3e fe ff ff       	call   10540e <printfmt>
            }
            break;
  1055d0:	e9 45 02 00 00       	jmp    10581a <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1055d5:	8b 45 14             	mov    0x14(%ebp),%eax
  1055d8:	8d 50 04             	lea    0x4(%eax),%edx
  1055db:	89 55 14             	mov    %edx,0x14(%ebp)
  1055de:	8b 30                	mov    (%eax),%esi
  1055e0:	85 f6                	test   %esi,%esi
  1055e2:	75 05                	jne    1055e9 <vprintfmt+0x1ad>
                p = "(null)";
  1055e4:	be 49 6f 10 00       	mov    $0x106f49,%esi
            }
            if (width > 0 && padc != '-') {
  1055e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1055ed:	7e 3e                	jle    10562d <vprintfmt+0x1f1>
  1055ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1055f3:	74 38                	je     10562d <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1055f5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1055f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055ff:	89 34 24             	mov    %esi,(%esp)
  105602:	e8 15 03 00 00       	call   10591c <strnlen>
  105607:	29 c3                	sub    %eax,%ebx
  105609:	89 d8                	mov    %ebx,%eax
  10560b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10560e:	eb 17                	jmp    105627 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105610:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105614:	8b 55 0c             	mov    0xc(%ebp),%edx
  105617:	89 54 24 04          	mov    %edx,0x4(%esp)
  10561b:	89 04 24             	mov    %eax,(%esp)
  10561e:	8b 45 08             	mov    0x8(%ebp),%eax
  105621:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105623:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105627:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10562b:	7f e3                	jg     105610 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10562d:	eb 38                	jmp    105667 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  10562f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105633:	74 1f                	je     105654 <vprintfmt+0x218>
  105635:	83 fb 1f             	cmp    $0x1f,%ebx
  105638:	7e 05                	jle    10563f <vprintfmt+0x203>
  10563a:	83 fb 7e             	cmp    $0x7e,%ebx
  10563d:	7e 15                	jle    105654 <vprintfmt+0x218>
                    putch('?', putdat);
  10563f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105642:	89 44 24 04          	mov    %eax,0x4(%esp)
  105646:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10564d:	8b 45 08             	mov    0x8(%ebp),%eax
  105650:	ff d0                	call   *%eax
  105652:	eb 0f                	jmp    105663 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105654:	8b 45 0c             	mov    0xc(%ebp),%eax
  105657:	89 44 24 04          	mov    %eax,0x4(%esp)
  10565b:	89 1c 24             	mov    %ebx,(%esp)
  10565e:	8b 45 08             	mov    0x8(%ebp),%eax
  105661:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105663:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105667:	89 f0                	mov    %esi,%eax
  105669:	8d 70 01             	lea    0x1(%eax),%esi
  10566c:	0f b6 00             	movzbl (%eax),%eax
  10566f:	0f be d8             	movsbl %al,%ebx
  105672:	85 db                	test   %ebx,%ebx
  105674:	74 10                	je     105686 <vprintfmt+0x24a>
  105676:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10567a:	78 b3                	js     10562f <vprintfmt+0x1f3>
  10567c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105680:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105684:	79 a9                	jns    10562f <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105686:	eb 17                	jmp    10569f <vprintfmt+0x263>
                putch(' ', putdat);
  105688:	8b 45 0c             	mov    0xc(%ebp),%eax
  10568b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10568f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105696:	8b 45 08             	mov    0x8(%ebp),%eax
  105699:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10569b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10569f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056a3:	7f e3                	jg     105688 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  1056a5:	e9 70 01 00 00       	jmp    10581a <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1056aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1056ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056b1:	8d 45 14             	lea    0x14(%ebp),%eax
  1056b4:	89 04 24             	mov    %eax,(%esp)
  1056b7:	e8 0b fd ff ff       	call   1053c7 <getint>
  1056bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1056c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056c8:	85 d2                	test   %edx,%edx
  1056ca:	79 26                	jns    1056f2 <vprintfmt+0x2b6>
                putch('-', putdat);
  1056cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056d3:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1056da:	8b 45 08             	mov    0x8(%ebp),%eax
  1056dd:	ff d0                	call   *%eax
                num = -(long long)num;
  1056df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056e5:	f7 d8                	neg    %eax
  1056e7:	83 d2 00             	adc    $0x0,%edx
  1056ea:	f7 da                	neg    %edx
  1056ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1056f2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1056f9:	e9 a8 00 00 00       	jmp    1057a6 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1056fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105701:	89 44 24 04          	mov    %eax,0x4(%esp)
  105705:	8d 45 14             	lea    0x14(%ebp),%eax
  105708:	89 04 24             	mov    %eax,(%esp)
  10570b:	e8 68 fc ff ff       	call   105378 <getuint>
  105710:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105713:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105716:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10571d:	e9 84 00 00 00       	jmp    1057a6 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105725:	89 44 24 04          	mov    %eax,0x4(%esp)
  105729:	8d 45 14             	lea    0x14(%ebp),%eax
  10572c:	89 04 24             	mov    %eax,(%esp)
  10572f:	e8 44 fc ff ff       	call   105378 <getuint>
  105734:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105737:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10573a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105741:	eb 63                	jmp    1057a6 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105743:	8b 45 0c             	mov    0xc(%ebp),%eax
  105746:	89 44 24 04          	mov    %eax,0x4(%esp)
  10574a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105751:	8b 45 08             	mov    0x8(%ebp),%eax
  105754:	ff d0                	call   *%eax
            putch('x', putdat);
  105756:	8b 45 0c             	mov    0xc(%ebp),%eax
  105759:	89 44 24 04          	mov    %eax,0x4(%esp)
  10575d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105764:	8b 45 08             	mov    0x8(%ebp),%eax
  105767:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105769:	8b 45 14             	mov    0x14(%ebp),%eax
  10576c:	8d 50 04             	lea    0x4(%eax),%edx
  10576f:	89 55 14             	mov    %edx,0x14(%ebp)
  105772:	8b 00                	mov    (%eax),%eax
  105774:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10577e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105785:	eb 1f                	jmp    1057a6 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105787:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10578a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10578e:	8d 45 14             	lea    0x14(%ebp),%eax
  105791:	89 04 24             	mov    %eax,(%esp)
  105794:	e8 df fb ff ff       	call   105378 <getuint>
  105799:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10579c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10579f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1057a6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1057aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057ad:	89 54 24 18          	mov    %edx,0x18(%esp)
  1057b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1057b4:	89 54 24 14          	mov    %edx,0x14(%esp)
  1057b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1057bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1057c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1057ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d4:	89 04 24             	mov    %eax,(%esp)
  1057d7:	e8 97 fa ff ff       	call   105273 <printnum>
            break;
  1057dc:	eb 3c                	jmp    10581a <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1057de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057e5:	89 1c 24             	mov    %ebx,(%esp)
  1057e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1057eb:	ff d0                	call   *%eax
            break;
  1057ed:	eb 2b                	jmp    10581a <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1057ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057f6:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1057fd:	8b 45 08             	mov    0x8(%ebp),%eax
  105800:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105802:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105806:	eb 04                	jmp    10580c <vprintfmt+0x3d0>
  105808:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10580c:	8b 45 10             	mov    0x10(%ebp),%eax
  10580f:	83 e8 01             	sub    $0x1,%eax
  105812:	0f b6 00             	movzbl (%eax),%eax
  105815:	3c 25                	cmp    $0x25,%al
  105817:	75 ef                	jne    105808 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105819:	90                   	nop
        }
    }
  10581a:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10581b:	e9 3e fc ff ff       	jmp    10545e <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105820:	83 c4 40             	add    $0x40,%esp
  105823:	5b                   	pop    %ebx
  105824:	5e                   	pop    %esi
  105825:	5d                   	pop    %ebp
  105826:	c3                   	ret    

00105827 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105827:	55                   	push   %ebp
  105828:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10582a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10582d:	8b 40 08             	mov    0x8(%eax),%eax
  105830:	8d 50 01             	lea    0x1(%eax),%edx
  105833:	8b 45 0c             	mov    0xc(%ebp),%eax
  105836:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105839:	8b 45 0c             	mov    0xc(%ebp),%eax
  10583c:	8b 10                	mov    (%eax),%edx
  10583e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105841:	8b 40 04             	mov    0x4(%eax),%eax
  105844:	39 c2                	cmp    %eax,%edx
  105846:	73 12                	jae    10585a <sprintputch+0x33>
        *b->buf ++ = ch;
  105848:	8b 45 0c             	mov    0xc(%ebp),%eax
  10584b:	8b 00                	mov    (%eax),%eax
  10584d:	8d 48 01             	lea    0x1(%eax),%ecx
  105850:	8b 55 0c             	mov    0xc(%ebp),%edx
  105853:	89 0a                	mov    %ecx,(%edx)
  105855:	8b 55 08             	mov    0x8(%ebp),%edx
  105858:	88 10                	mov    %dl,(%eax)
    }
}
  10585a:	5d                   	pop    %ebp
  10585b:	c3                   	ret    

0010585c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10585c:	55                   	push   %ebp
  10585d:	89 e5                	mov    %esp,%ebp
  10585f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105862:	8d 45 14             	lea    0x14(%ebp),%eax
  105865:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10586b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10586f:	8b 45 10             	mov    0x10(%ebp),%eax
  105872:	89 44 24 08          	mov    %eax,0x8(%esp)
  105876:	8b 45 0c             	mov    0xc(%ebp),%eax
  105879:	89 44 24 04          	mov    %eax,0x4(%esp)
  10587d:	8b 45 08             	mov    0x8(%ebp),%eax
  105880:	89 04 24             	mov    %eax,(%esp)
  105883:	e8 08 00 00 00       	call   105890 <vsnprintf>
  105888:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10588b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10588e:	c9                   	leave  
  10588f:	c3                   	ret    

00105890 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105890:	55                   	push   %ebp
  105891:	89 e5                	mov    %esp,%ebp
  105893:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105896:	8b 45 08             	mov    0x8(%ebp),%eax
  105899:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10589c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10589f:	8d 50 ff             	lea    -0x1(%eax),%edx
  1058a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1058a5:	01 d0                	add    %edx,%eax
  1058a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1058b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1058b5:	74 0a                	je     1058c1 <vsnprintf+0x31>
  1058b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1058ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058bd:	39 c2                	cmp    %eax,%edx
  1058bf:	76 07                	jbe    1058c8 <vsnprintf+0x38>
        return -E_INVAL;
  1058c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1058c6:	eb 2a                	jmp    1058f2 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1058c8:	8b 45 14             	mov    0x14(%ebp),%eax
  1058cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1058cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1058d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1058d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1058d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058dd:	c7 04 24 27 58 10 00 	movl   $0x105827,(%esp)
  1058e4:	e8 53 fb ff ff       	call   10543c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1058e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058ec:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1058ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1058f2:	c9                   	leave  
  1058f3:	c3                   	ret    

001058f4 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1058f4:	55                   	push   %ebp
  1058f5:	89 e5                	mov    %esp,%ebp
  1058f7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1058fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105901:	eb 04                	jmp    105907 <strlen+0x13>
        cnt ++;
  105903:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105907:	8b 45 08             	mov    0x8(%ebp),%eax
  10590a:	8d 50 01             	lea    0x1(%eax),%edx
  10590d:	89 55 08             	mov    %edx,0x8(%ebp)
  105910:	0f b6 00             	movzbl (%eax),%eax
  105913:	84 c0                	test   %al,%al
  105915:	75 ec                	jne    105903 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105917:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10591a:	c9                   	leave  
  10591b:	c3                   	ret    

0010591c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10591c:	55                   	push   %ebp
  10591d:	89 e5                	mov    %esp,%ebp
  10591f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105922:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105929:	eb 04                	jmp    10592f <strnlen+0x13>
        cnt ++;
  10592b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10592f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105932:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105935:	73 10                	jae    105947 <strnlen+0x2b>
  105937:	8b 45 08             	mov    0x8(%ebp),%eax
  10593a:	8d 50 01             	lea    0x1(%eax),%edx
  10593d:	89 55 08             	mov    %edx,0x8(%ebp)
  105940:	0f b6 00             	movzbl (%eax),%eax
  105943:	84 c0                	test   %al,%al
  105945:	75 e4                	jne    10592b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105947:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10594a:	c9                   	leave  
  10594b:	c3                   	ret    

0010594c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10594c:	55                   	push   %ebp
  10594d:	89 e5                	mov    %esp,%ebp
  10594f:	57                   	push   %edi
  105950:	56                   	push   %esi
  105951:	83 ec 20             	sub    $0x20,%esp
  105954:	8b 45 08             	mov    0x8(%ebp),%eax
  105957:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10595a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10595d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105960:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105966:	89 d1                	mov    %edx,%ecx
  105968:	89 c2                	mov    %eax,%edx
  10596a:	89 ce                	mov    %ecx,%esi
  10596c:	89 d7                	mov    %edx,%edi
  10596e:	ac                   	lods   %ds:(%esi),%al
  10596f:	aa                   	stos   %al,%es:(%edi)
  105970:	84 c0                	test   %al,%al
  105972:	75 fa                	jne    10596e <strcpy+0x22>
  105974:	89 fa                	mov    %edi,%edx
  105976:	89 f1                	mov    %esi,%ecx
  105978:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10597b:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10597e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105981:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105984:	83 c4 20             	add    $0x20,%esp
  105987:	5e                   	pop    %esi
  105988:	5f                   	pop    %edi
  105989:	5d                   	pop    %ebp
  10598a:	c3                   	ret    

0010598b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10598b:	55                   	push   %ebp
  10598c:	89 e5                	mov    %esp,%ebp
  10598e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105991:	8b 45 08             	mov    0x8(%ebp),%eax
  105994:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105997:	eb 21                	jmp    1059ba <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105999:	8b 45 0c             	mov    0xc(%ebp),%eax
  10599c:	0f b6 10             	movzbl (%eax),%edx
  10599f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1059a2:	88 10                	mov    %dl,(%eax)
  1059a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1059a7:	0f b6 00             	movzbl (%eax),%eax
  1059aa:	84 c0                	test   %al,%al
  1059ac:	74 04                	je     1059b2 <strncpy+0x27>
            src ++;
  1059ae:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1059b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1059b6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1059ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1059be:	75 d9                	jne    105999 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1059c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1059c3:	c9                   	leave  
  1059c4:	c3                   	ret    

001059c5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1059c5:	55                   	push   %ebp
  1059c6:	89 e5                	mov    %esp,%ebp
  1059c8:	57                   	push   %edi
  1059c9:	56                   	push   %esi
  1059ca:	83 ec 20             	sub    $0x20,%esp
  1059cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1059d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1059d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059df:	89 d1                	mov    %edx,%ecx
  1059e1:	89 c2                	mov    %eax,%edx
  1059e3:	89 ce                	mov    %ecx,%esi
  1059e5:	89 d7                	mov    %edx,%edi
  1059e7:	ac                   	lods   %ds:(%esi),%al
  1059e8:	ae                   	scas   %es:(%edi),%al
  1059e9:	75 08                	jne    1059f3 <strcmp+0x2e>
  1059eb:	84 c0                	test   %al,%al
  1059ed:	75 f8                	jne    1059e7 <strcmp+0x22>
  1059ef:	31 c0                	xor    %eax,%eax
  1059f1:	eb 04                	jmp    1059f7 <strcmp+0x32>
  1059f3:	19 c0                	sbb    %eax,%eax
  1059f5:	0c 01                	or     $0x1,%al
  1059f7:	89 fa                	mov    %edi,%edx
  1059f9:	89 f1                	mov    %esi,%ecx
  1059fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1059fe:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105a01:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105a07:	83 c4 20             	add    $0x20,%esp
  105a0a:	5e                   	pop    %esi
  105a0b:	5f                   	pop    %edi
  105a0c:	5d                   	pop    %ebp
  105a0d:	c3                   	ret    

00105a0e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105a0e:	55                   	push   %ebp
  105a0f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105a11:	eb 0c                	jmp    105a1f <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105a13:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105a17:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105a1b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105a1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a23:	74 1a                	je     105a3f <strncmp+0x31>
  105a25:	8b 45 08             	mov    0x8(%ebp),%eax
  105a28:	0f b6 00             	movzbl (%eax),%eax
  105a2b:	84 c0                	test   %al,%al
  105a2d:	74 10                	je     105a3f <strncmp+0x31>
  105a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a32:	0f b6 10             	movzbl (%eax),%edx
  105a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a38:	0f b6 00             	movzbl (%eax),%eax
  105a3b:	38 c2                	cmp    %al,%dl
  105a3d:	74 d4                	je     105a13 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105a3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a43:	74 18                	je     105a5d <strncmp+0x4f>
  105a45:	8b 45 08             	mov    0x8(%ebp),%eax
  105a48:	0f b6 00             	movzbl (%eax),%eax
  105a4b:	0f b6 d0             	movzbl %al,%edx
  105a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a51:	0f b6 00             	movzbl (%eax),%eax
  105a54:	0f b6 c0             	movzbl %al,%eax
  105a57:	29 c2                	sub    %eax,%edx
  105a59:	89 d0                	mov    %edx,%eax
  105a5b:	eb 05                	jmp    105a62 <strncmp+0x54>
  105a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105a62:	5d                   	pop    %ebp
  105a63:	c3                   	ret    

00105a64 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105a64:	55                   	push   %ebp
  105a65:	89 e5                	mov    %esp,%ebp
  105a67:	83 ec 04             	sub    $0x4,%esp
  105a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a6d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105a70:	eb 14                	jmp    105a86 <strchr+0x22>
        if (*s == c) {
  105a72:	8b 45 08             	mov    0x8(%ebp),%eax
  105a75:	0f b6 00             	movzbl (%eax),%eax
  105a78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105a7b:	75 05                	jne    105a82 <strchr+0x1e>
            return (char *)s;
  105a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a80:	eb 13                	jmp    105a95 <strchr+0x31>
        }
        s ++;
  105a82:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105a86:	8b 45 08             	mov    0x8(%ebp),%eax
  105a89:	0f b6 00             	movzbl (%eax),%eax
  105a8c:	84 c0                	test   %al,%al
  105a8e:	75 e2                	jne    105a72 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105a90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105a95:	c9                   	leave  
  105a96:	c3                   	ret    

00105a97 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105a97:	55                   	push   %ebp
  105a98:	89 e5                	mov    %esp,%ebp
  105a9a:	83 ec 04             	sub    $0x4,%esp
  105a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105aa3:	eb 11                	jmp    105ab6 <strfind+0x1f>
        if (*s == c) {
  105aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa8:	0f b6 00             	movzbl (%eax),%eax
  105aab:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105aae:	75 02                	jne    105ab2 <strfind+0x1b>
            break;
  105ab0:	eb 0e                	jmp    105ac0 <strfind+0x29>
        }
        s ++;
  105ab2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab9:	0f b6 00             	movzbl (%eax),%eax
  105abc:	84 c0                	test   %al,%al
  105abe:	75 e5                	jne    105aa5 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105ac0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105ac3:	c9                   	leave  
  105ac4:	c3                   	ret    

00105ac5 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105ac5:	55                   	push   %ebp
  105ac6:	89 e5                	mov    %esp,%ebp
  105ac8:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105acb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105ad2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105ad9:	eb 04                	jmp    105adf <strtol+0x1a>
        s ++;
  105adb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105adf:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae2:	0f b6 00             	movzbl (%eax),%eax
  105ae5:	3c 20                	cmp    $0x20,%al
  105ae7:	74 f2                	je     105adb <strtol+0x16>
  105ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  105aec:	0f b6 00             	movzbl (%eax),%eax
  105aef:	3c 09                	cmp    $0x9,%al
  105af1:	74 e8                	je     105adb <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105af3:	8b 45 08             	mov    0x8(%ebp),%eax
  105af6:	0f b6 00             	movzbl (%eax),%eax
  105af9:	3c 2b                	cmp    $0x2b,%al
  105afb:	75 06                	jne    105b03 <strtol+0x3e>
        s ++;
  105afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b01:	eb 15                	jmp    105b18 <strtol+0x53>
    }
    else if (*s == '-') {
  105b03:	8b 45 08             	mov    0x8(%ebp),%eax
  105b06:	0f b6 00             	movzbl (%eax),%eax
  105b09:	3c 2d                	cmp    $0x2d,%al
  105b0b:	75 0b                	jne    105b18 <strtol+0x53>
        s ++, neg = 1;
  105b0d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b11:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105b18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b1c:	74 06                	je     105b24 <strtol+0x5f>
  105b1e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105b22:	75 24                	jne    105b48 <strtol+0x83>
  105b24:	8b 45 08             	mov    0x8(%ebp),%eax
  105b27:	0f b6 00             	movzbl (%eax),%eax
  105b2a:	3c 30                	cmp    $0x30,%al
  105b2c:	75 1a                	jne    105b48 <strtol+0x83>
  105b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b31:	83 c0 01             	add    $0x1,%eax
  105b34:	0f b6 00             	movzbl (%eax),%eax
  105b37:	3c 78                	cmp    $0x78,%al
  105b39:	75 0d                	jne    105b48 <strtol+0x83>
        s += 2, base = 16;
  105b3b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105b3f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105b46:	eb 2a                	jmp    105b72 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105b48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b4c:	75 17                	jne    105b65 <strtol+0xa0>
  105b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b51:	0f b6 00             	movzbl (%eax),%eax
  105b54:	3c 30                	cmp    $0x30,%al
  105b56:	75 0d                	jne    105b65 <strtol+0xa0>
        s ++, base = 8;
  105b58:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b5c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105b63:	eb 0d                	jmp    105b72 <strtol+0xad>
    }
    else if (base == 0) {
  105b65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b69:	75 07                	jne    105b72 <strtol+0xad>
        base = 10;
  105b6b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105b72:	8b 45 08             	mov    0x8(%ebp),%eax
  105b75:	0f b6 00             	movzbl (%eax),%eax
  105b78:	3c 2f                	cmp    $0x2f,%al
  105b7a:	7e 1b                	jle    105b97 <strtol+0xd2>
  105b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b7f:	0f b6 00             	movzbl (%eax),%eax
  105b82:	3c 39                	cmp    $0x39,%al
  105b84:	7f 11                	jg     105b97 <strtol+0xd2>
            dig = *s - '0';
  105b86:	8b 45 08             	mov    0x8(%ebp),%eax
  105b89:	0f b6 00             	movzbl (%eax),%eax
  105b8c:	0f be c0             	movsbl %al,%eax
  105b8f:	83 e8 30             	sub    $0x30,%eax
  105b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b95:	eb 48                	jmp    105bdf <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105b97:	8b 45 08             	mov    0x8(%ebp),%eax
  105b9a:	0f b6 00             	movzbl (%eax),%eax
  105b9d:	3c 60                	cmp    $0x60,%al
  105b9f:	7e 1b                	jle    105bbc <strtol+0xf7>
  105ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba4:	0f b6 00             	movzbl (%eax),%eax
  105ba7:	3c 7a                	cmp    $0x7a,%al
  105ba9:	7f 11                	jg     105bbc <strtol+0xf7>
            dig = *s - 'a' + 10;
  105bab:	8b 45 08             	mov    0x8(%ebp),%eax
  105bae:	0f b6 00             	movzbl (%eax),%eax
  105bb1:	0f be c0             	movsbl %al,%eax
  105bb4:	83 e8 57             	sub    $0x57,%eax
  105bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bba:	eb 23                	jmp    105bdf <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbf:	0f b6 00             	movzbl (%eax),%eax
  105bc2:	3c 40                	cmp    $0x40,%al
  105bc4:	7e 3d                	jle    105c03 <strtol+0x13e>
  105bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc9:	0f b6 00             	movzbl (%eax),%eax
  105bcc:	3c 5a                	cmp    $0x5a,%al
  105bce:	7f 33                	jg     105c03 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd3:	0f b6 00             	movzbl (%eax),%eax
  105bd6:	0f be c0             	movsbl %al,%eax
  105bd9:	83 e8 37             	sub    $0x37,%eax
  105bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105be2:	3b 45 10             	cmp    0x10(%ebp),%eax
  105be5:	7c 02                	jl     105be9 <strtol+0x124>
            break;
  105be7:	eb 1a                	jmp    105c03 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105be9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105bf0:	0f af 45 10          	imul   0x10(%ebp),%eax
  105bf4:	89 c2                	mov    %eax,%edx
  105bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bf9:	01 d0                	add    %edx,%eax
  105bfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105bfe:	e9 6f ff ff ff       	jmp    105b72 <strtol+0xad>

    if (endptr) {
  105c03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105c07:	74 08                	je     105c11 <strtol+0x14c>
        *endptr = (char *) s;
  105c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  105c0f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105c11:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105c15:	74 07                	je     105c1e <strtol+0x159>
  105c17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c1a:	f7 d8                	neg    %eax
  105c1c:	eb 03                	jmp    105c21 <strtol+0x15c>
  105c1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105c21:	c9                   	leave  
  105c22:	c3                   	ret    

00105c23 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105c23:	55                   	push   %ebp
  105c24:	89 e5                	mov    %esp,%ebp
  105c26:	57                   	push   %edi
  105c27:	83 ec 24             	sub    $0x24,%esp
  105c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c2d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105c30:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105c34:	8b 55 08             	mov    0x8(%ebp),%edx
  105c37:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105c3a:	88 45 f7             	mov    %al,-0x9(%ebp)
  105c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  105c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105c43:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105c46:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105c4a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105c4d:	89 d7                	mov    %edx,%edi
  105c4f:	f3 aa                	rep stos %al,%es:(%edi)
  105c51:	89 fa                	mov    %edi,%edx
  105c53:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105c56:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105c59:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105c5c:	83 c4 24             	add    $0x24,%esp
  105c5f:	5f                   	pop    %edi
  105c60:	5d                   	pop    %ebp
  105c61:	c3                   	ret    

00105c62 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105c62:	55                   	push   %ebp
  105c63:	89 e5                	mov    %esp,%ebp
  105c65:	57                   	push   %edi
  105c66:	56                   	push   %esi
  105c67:	53                   	push   %ebx
  105c68:	83 ec 30             	sub    $0x30,%esp
  105c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c77:	8b 45 10             	mov    0x10(%ebp),%eax
  105c7a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c80:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105c83:	73 42                	jae    105cc7 <memmove+0x65>
  105c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105c91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105c94:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105c97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105c9a:	c1 e8 02             	shr    $0x2,%eax
  105c9d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105c9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ca2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ca5:	89 d7                	mov    %edx,%edi
  105ca7:	89 c6                	mov    %eax,%esi
  105ca9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105cab:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105cae:	83 e1 03             	and    $0x3,%ecx
  105cb1:	74 02                	je     105cb5 <memmove+0x53>
  105cb3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105cb5:	89 f0                	mov    %esi,%eax
  105cb7:	89 fa                	mov    %edi,%edx
  105cb9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105cbc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105cbf:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105cc5:	eb 36                	jmp    105cfd <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105cc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cca:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105cd0:	01 c2                	add    %eax,%edx
  105cd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cd5:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cdb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ce1:	89 c1                	mov    %eax,%ecx
  105ce3:	89 d8                	mov    %ebx,%eax
  105ce5:	89 d6                	mov    %edx,%esi
  105ce7:	89 c7                	mov    %eax,%edi
  105ce9:	fd                   	std    
  105cea:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105cec:	fc                   	cld    
  105ced:	89 f8                	mov    %edi,%eax
  105cef:	89 f2                	mov    %esi,%edx
  105cf1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105cf4:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105cf7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105cfd:	83 c4 30             	add    $0x30,%esp
  105d00:	5b                   	pop    %ebx
  105d01:	5e                   	pop    %esi
  105d02:	5f                   	pop    %edi
  105d03:	5d                   	pop    %ebp
  105d04:	c3                   	ret    

00105d05 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105d05:	55                   	push   %ebp
  105d06:	89 e5                	mov    %esp,%ebp
  105d08:	57                   	push   %edi
  105d09:	56                   	push   %esi
  105d0a:	83 ec 20             	sub    $0x20,%esp
  105d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d19:	8b 45 10             	mov    0x10(%ebp),%eax
  105d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d22:	c1 e8 02             	shr    $0x2,%eax
  105d25:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105d27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d2d:	89 d7                	mov    %edx,%edi
  105d2f:	89 c6                	mov    %eax,%esi
  105d31:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105d33:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105d36:	83 e1 03             	and    $0x3,%ecx
  105d39:	74 02                	je     105d3d <memcpy+0x38>
  105d3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d3d:	89 f0                	mov    %esi,%eax
  105d3f:	89 fa                	mov    %edi,%edx
  105d41:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105d44:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105d47:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105d4d:	83 c4 20             	add    $0x20,%esp
  105d50:	5e                   	pop    %esi
  105d51:	5f                   	pop    %edi
  105d52:	5d                   	pop    %ebp
  105d53:	c3                   	ret    

00105d54 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105d54:	55                   	push   %ebp
  105d55:	89 e5                	mov    %esp,%ebp
  105d57:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d63:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105d66:	eb 30                	jmp    105d98 <memcmp+0x44>
        if (*s1 != *s2) {
  105d68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d6b:	0f b6 10             	movzbl (%eax),%edx
  105d6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d71:	0f b6 00             	movzbl (%eax),%eax
  105d74:	38 c2                	cmp    %al,%dl
  105d76:	74 18                	je     105d90 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105d78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d7b:	0f b6 00             	movzbl (%eax),%eax
  105d7e:	0f b6 d0             	movzbl %al,%edx
  105d81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d84:	0f b6 00             	movzbl (%eax),%eax
  105d87:	0f b6 c0             	movzbl %al,%eax
  105d8a:	29 c2                	sub    %eax,%edx
  105d8c:	89 d0                	mov    %edx,%eax
  105d8e:	eb 1a                	jmp    105daa <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105d90:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105d94:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105d98:	8b 45 10             	mov    0x10(%ebp),%eax
  105d9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  105d9e:	89 55 10             	mov    %edx,0x10(%ebp)
  105da1:	85 c0                	test   %eax,%eax
  105da3:	75 c3                	jne    105d68 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105da5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105daa:	c9                   	leave  
  105dab:	c3                   	ret    
