
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 cd 5b 00 00       	call   c0105c23 <memset>

    cons_init();                // init the console
c0100056:	e8 71 15 00 00       	call   c01015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 c0 5d 10 c0 	movl   $0xc0105dc0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 dc 5d 10 c0 	movl   $0xc0105ddc,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 4a 42 00 00       	call   c01042ce <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 ac 16 00 00       	call   c0101735 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 fe 17 00 00       	call   c010188c <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 ef 0c 00 00       	call   c0100d82 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 0b 16 00 00       	call   c01016a3 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 f8 0b 00 00       	call   c0100cb4 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 e1 5d 10 c0 	movl   $0xc0105de1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 ef 5d 10 c0 	movl   $0xc0105def,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 fd 5d 10 c0 	movl   $0xc0105dfd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 0b 5e 10 c0 	movl   $0xc0105e0b,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 19 5e 10 c0 	movl   $0xc0105e19,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 28 5e 10 c0 	movl   $0xc0105e28,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 48 5e 10 c0 	movl   $0xc0105e48,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 67 5e 10 c0 	movl   $0xc0105e67,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 fe 12 00 00       	call   c01015f8 <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 05 51 00 00       	call   c010543c <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 85 12 00 00       	call   c01015f8 <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 65 12 00 00       	call   c0101634 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 6c 5e 10 c0    	movl   $0xc0105e6c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 6c 5e 10 c0 	movl   $0xc0105e6c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 a8 70 10 c0 	movl   $0xc01070a8,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 70 1a 11 c0 	movl   $0xc0111a70,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 71 1a 11 c0 	movl   $0xc0111a71,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 b8 44 11 c0 	movl   $0xc01144b8,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 ab 53 00 00       	call   c0105a97 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 76 5e 10 c0 	movl   $0xc0105e76,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 8f 5e 10 c0 	movl   $0xc0105e8f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 ac 5d 10 	movl   $0xc0105dac,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 a7 5e 10 c0 	movl   $0xc0105ea7,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 bf 5e 10 c0 	movl   $0xc0105ebf,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 d7 5e 10 c0 	movl   $0xc0105ed7,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 f0 5e 10 c0 	movl   $0xc0105ef0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 1a 5f 10 c0 	movl   $0xc0105f1a,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 36 5f 10 c0 	movl   $0xc0105f36,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// 循环打印，直到 STACKFRAME_DEPTH 栈的深度已经最大，并且还要满足ebp ！= 0
	int i;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 88 00 00 00       	jmp    c0100a67 <print_stackframe+0xad>
		cprintf("ebp: 0x%08x eip: 0x%08x args: ", ebp, eip);
c01009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ed:	c7 04 24 48 5f 10 c0 	movl   $0xc0105f48,(%esp)
c01009f4:	e8 43 f9 ff ff       	call   c010033c <cprintf>

		// ebp + 2才是第一个参数的地址，具体可以看笔记
		uint32_t *args = (uint32_t *)ebp + 2;
c01009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fc:	83 c0 08             	add    $0x8,%eax
c01009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		// 循环打印4个args
		int j;
		for (j = 0; j < 4; j++) {
c0100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a09:	eb 25                	jmp    c0100a30 <print_stackframe+0x76>
			cprintf("0x%08x ", args[j]);
c0100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a18:	01 d0                	add    %edx,%eax
c0100a1a:	8b 00                	mov    (%eax),%eax
c0100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a20:	c7 04 24 67 5f 10 c0 	movl   $0xc0105f67,(%esp)
c0100a27:	e8 10 f9 ff ff       	call   c010033c <cprintf>
		// ebp + 2才是第一个参数的地址，具体可以看笔记
		uint32_t *args = (uint32_t *)ebp + 2;

		// 循环打印4个args
		int j;
		for (j = 0; j < 4; j++) {
c0100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a34:	7e d5                	jle    c0100a0b <print_stackframe+0x51>
			cprintf("0x%08x ", args[j]);
		}
		cprintf("\n");
c0100a36:	c7 04 24 6f 5f 10 c0 	movl   $0xc0105f6f,(%esp)
c0100a3d:	e8 fa f8 ff ff       	call   c010033c <cprintf>

		// 打印 kern/debug/kdebug.c:305: print_stackframe+22 类似这行的东西，应该是调试信息
		print_debuginfo(eip-1);
c0100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a45:	83 e8 01             	sub    $0x1,%eax
c0100a48:	89 04 24             	mov    %eax,(%esp)
c0100a4b:	e8 b6 fe ff ff       	call   c0100906 <print_debuginfo>

		// 先把eip指向ebp+1的位置，即函数的返回地址（Return Address）
		eip = *((uint32_t *)ebp + 1);
c0100a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a53:	83 c0 04             	add    $0x4,%eax
c0100a56:	8b 00                	mov    (%eax),%eax
c0100a58:	89 45 f0             	mov    %eax,-0x10(%ebp)

		// ebp的内容给ebp回到上层调用函数
		ebp = *((uint32_t *)ebp);
c0100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5e:	8b 00                	mov    (%eax),%eax
c0100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();

	// 循环打印，直到 STACKFRAME_DEPTH 栈的深度已经最大，并且还要满足ebp ！= 0
	int i;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
c0100a63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a67:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a6b:	7f 0a                	jg     c0100a77 <print_stackframe+0xbd>
c0100a6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a71:	0f 85 68 ff ff ff    	jne    c01009df <print_stackframe+0x25>
		eip = *((uint32_t *)ebp + 1);

		// ebp的内容给ebp回到上层调用函数
		ebp = *((uint32_t *)ebp);
	}
}
c0100a77:	c9                   	leave  
c0100a78:	c3                   	ret    

c0100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a79:	55                   	push   %ebp
c0100a7a:	89 e5                	mov    %esp,%ebp
c0100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a86:	eb 0c                	jmp    c0100a94 <parse+0x1b>
            *buf ++ = '\0';
c0100a88:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a8b:	8d 50 01             	lea    0x1(%eax),%edx
c0100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a91:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a97:	0f b6 00             	movzbl (%eax),%eax
c0100a9a:	84 c0                	test   %al,%al
c0100a9c:	74 1d                	je     c0100abb <parse+0x42>
c0100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa1:	0f b6 00             	movzbl (%eax),%eax
c0100aa4:	0f be c0             	movsbl %al,%eax
c0100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aab:	c7 04 24 f4 5f 10 c0 	movl   $0xc0105ff4,(%esp)
c0100ab2:	e8 ad 4f 00 00       	call   c0105a64 <strchr>
c0100ab7:	85 c0                	test   %eax,%eax
c0100ab9:	75 cd                	jne    c0100a88 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abe:	0f b6 00             	movzbl (%eax),%eax
c0100ac1:	84 c0                	test   %al,%al
c0100ac3:	75 02                	jne    c0100ac7 <parse+0x4e>
            break;
c0100ac5:	eb 67                	jmp    c0100b2e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ac7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100acb:	75 14                	jne    c0100ae1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100acd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad4:	00 
c0100ad5:	c7 04 24 f9 5f 10 c0 	movl   $0xc0105ff9,(%esp)
c0100adc:	e8 5b f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae4:	8d 50 01             	lea    0x1(%eax),%edx
c0100ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af4:	01 c2                	add    %eax,%edx
c0100af6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100afb:	eb 04                	jmp    c0100b01 <parse+0x88>
            buf ++;
c0100afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b01:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b04:	0f b6 00             	movzbl (%eax),%eax
c0100b07:	84 c0                	test   %al,%al
c0100b09:	74 1d                	je     c0100b28 <parse+0xaf>
c0100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0e:	0f b6 00             	movzbl (%eax),%eax
c0100b11:	0f be c0             	movsbl %al,%eax
c0100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b18:	c7 04 24 f4 5f 10 c0 	movl   $0xc0105ff4,(%esp)
c0100b1f:	e8 40 4f 00 00       	call   c0105a64 <strchr>
c0100b24:	85 c0                	test   %eax,%eax
c0100b26:	74 d5                	je     c0100afd <parse+0x84>
            buf ++;
        }
    }
c0100b28:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b29:	e9 66 ff ff ff       	jmp    c0100a94 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b31:	c9                   	leave  
c0100b32:	c3                   	ret    

c0100b33 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b33:	55                   	push   %ebp
c0100b34:	89 e5                	mov    %esp,%ebp
c0100b36:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b39:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b40:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b43:	89 04 24             	mov    %eax,(%esp)
c0100b46:	e8 2e ff ff ff       	call   c0100a79 <parse>
c0100b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b52:	75 0a                	jne    c0100b5e <runcmd+0x2b>
        return 0;
c0100b54:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b59:	e9 85 00 00 00       	jmp    c0100be3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b65:	eb 5c                	jmp    c0100bc3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b67:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b6d:	89 d0                	mov    %edx,%eax
c0100b6f:	01 c0                	add    %eax,%eax
c0100b71:	01 d0                	add    %edx,%eax
c0100b73:	c1 e0 02             	shl    $0x2,%eax
c0100b76:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b7b:	8b 00                	mov    (%eax),%eax
c0100b7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b81:	89 04 24             	mov    %eax,(%esp)
c0100b84:	e8 3c 4e 00 00       	call   c01059c5 <strcmp>
c0100b89:	85 c0                	test   %eax,%eax
c0100b8b:	75 32                	jne    c0100bbf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b90:	89 d0                	mov    %edx,%eax
c0100b92:	01 c0                	add    %eax,%eax
c0100b94:	01 d0                	add    %edx,%eax
c0100b96:	c1 e0 02             	shl    $0x2,%eax
c0100b99:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b9e:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100ba4:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100baa:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bae:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb1:	83 c2 04             	add    $0x4,%edx
c0100bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bb8:	89 0c 24             	mov    %ecx,(%esp)
c0100bbb:	ff d0                	call   *%eax
c0100bbd:	eb 24                	jmp    c0100be3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc6:	83 f8 02             	cmp    $0x2,%eax
c0100bc9:	76 9c                	jbe    c0100b67 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd2:	c7 04 24 17 60 10 c0 	movl   $0xc0106017,(%esp)
c0100bd9:	e8 5e f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be3:	c9                   	leave  
c0100be4:	c3                   	ret    

c0100be5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100be5:	55                   	push   %ebp
c0100be6:	89 e5                	mov    %esp,%ebp
c0100be8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100beb:	c7 04 24 30 60 10 c0 	movl   $0xc0106030,(%esp)
c0100bf2:	e8 45 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bf7:	c7 04 24 58 60 10 c0 	movl   $0xc0106058,(%esp)
c0100bfe:	e8 39 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c07:	74 0b                	je     c0100c14 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0c:	89 04 24             	mov    %eax,(%esp)
c0100c0f:	e8 30 0e 00 00       	call   c0101a44 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c14:	c7 04 24 7d 60 10 c0 	movl   $0xc010607d,(%esp)
c0100c1b:	e8 13 f6 ff ff       	call   c0100233 <readline>
c0100c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c27:	74 18                	je     c0100c41 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c33:	89 04 24             	mov    %eax,(%esp)
c0100c36:	e8 f8 fe ff ff       	call   c0100b33 <runcmd>
c0100c3b:	85 c0                	test   %eax,%eax
c0100c3d:	79 02                	jns    c0100c41 <kmonitor+0x5c>
                break;
c0100c3f:	eb 02                	jmp    c0100c43 <kmonitor+0x5e>
            }
        }
    }
c0100c41:	eb d1                	jmp    c0100c14 <kmonitor+0x2f>
}
c0100c43:	c9                   	leave  
c0100c44:	c3                   	ret    

c0100c45 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c45:	55                   	push   %ebp
c0100c46:	89 e5                	mov    %esp,%ebp
c0100c48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c52:	eb 3f                	jmp    c0100c93 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c57:	89 d0                	mov    %edx,%eax
c0100c59:	01 c0                	add    %eax,%eax
c0100c5b:	01 d0                	add    %edx,%eax
c0100c5d:	c1 e0 02             	shl    $0x2,%eax
c0100c60:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c65:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6b:	89 d0                	mov    %edx,%eax
c0100c6d:	01 c0                	add    %eax,%eax
c0100c6f:	01 d0                	add    %edx,%eax
c0100c71:	c1 e0 02             	shl    $0x2,%eax
c0100c74:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c79:	8b 00                	mov    (%eax),%eax
c0100c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c83:	c7 04 24 81 60 10 c0 	movl   $0xc0106081,(%esp)
c0100c8a:	e8 ad f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c96:	83 f8 02             	cmp    $0x2,%eax
c0100c99:	76 b9                	jbe    c0100c54 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca0:	c9                   	leave  
c0100ca1:	c3                   	ret    

c0100ca2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca2:	55                   	push   %ebp
c0100ca3:	89 e5                	mov    %esp,%ebp
c0100ca5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ca8:	e8 c3 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb2:	c9                   	leave  
c0100cb3:	c3                   	ret    

c0100cb4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cb4:	55                   	push   %ebp
c0100cb5:	89 e5                	mov    %esp,%ebp
c0100cb7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cba:	e8 fb fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc4:	c9                   	leave  
c0100cc5:	c3                   	ret    

c0100cc6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cc6:	55                   	push   %ebp
c0100cc7:	89 e5                	mov    %esp,%ebp
c0100cc9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ccc:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cd1:	85 c0                	test   %eax,%eax
c0100cd3:	74 02                	je     c0100cd7 <__panic+0x11>
        goto panic_dead;
c0100cd5:	eb 48                	jmp    c0100d1f <__panic+0x59>
    }
    is_panic = 1;
c0100cd7:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cde:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce1:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cea:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf5:	c7 04 24 8a 60 10 c0 	movl   $0xc010608a,(%esp)
c0100cfc:	e8 3b f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d08:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d0b:	89 04 24             	mov    %eax,(%esp)
c0100d0e:	e8 f6 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d13:	c7 04 24 a6 60 10 c0 	movl   $0xc01060a6,(%esp)
c0100d1a:	e8 1d f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d1f:	e8 85 09 00 00       	call   c01016a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d2b:	e8 b5 fe ff ff       	call   c0100be5 <kmonitor>
    }
c0100d30:	eb f2                	jmp    c0100d24 <__panic+0x5e>

c0100d32 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d32:	55                   	push   %ebp
c0100d33:	89 e5                	mov    %esp,%ebp
c0100d35:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d38:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d41:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d45:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d4c:	c7 04 24 a8 60 10 c0 	movl   $0xc01060a8,(%esp)
c0100d53:	e8 e4 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d62:	89 04 24             	mov    %eax,(%esp)
c0100d65:	e8 9f f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d6a:	c7 04 24 a6 60 10 c0 	movl   $0xc01060a6,(%esp)
c0100d71:	e8 c6 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d76:	c9                   	leave  
c0100d77:	c3                   	ret    

c0100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d78:	55                   	push   %ebp
c0100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d7b:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d80:	5d                   	pop    %ebp
c0100d81:	c3                   	ret    

c0100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d82:	55                   	push   %ebp
c0100d83:	89 e5                	mov    %esp,%ebp
c0100d85:	83 ec 28             	sub    $0x28,%esp
c0100d88:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d8e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d9a:	ee                   	out    %al,(%dx)
c0100d9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da1:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100da5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100da9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dad:	ee                   	out    %al,(%dx)
c0100dae:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100db8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc1:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dc8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dcb:	c7 04 24 c6 60 10 c0 	movl   $0xc01060c6,(%esp)
c0100dd2:	e8 65 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dde:	e8 24 09 00 00       	call   c0101707 <pic_enable>
}
c0100de3:	c9                   	leave  
c0100de4:	c3                   	ret    

c0100de5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100de5:	55                   	push   %ebp
c0100de6:	89 e5                	mov    %esp,%ebp
c0100de8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100deb:	9c                   	pushf  
c0100dec:	58                   	pop    %eax
c0100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df3:	25 00 02 00 00       	and    $0x200,%eax
c0100df8:	85 c0                	test   %eax,%eax
c0100dfa:	74 0c                	je     c0100e08 <__intr_save+0x23>
        intr_disable();
c0100dfc:	e8 a8 08 00 00       	call   c01016a9 <intr_disable>
        return 1;
c0100e01:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e06:	eb 05                	jmp    c0100e0d <__intr_save+0x28>
    }
    return 0;
c0100e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e0d:	c9                   	leave  
c0100e0e:	c3                   	ret    

c0100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e0f:	55                   	push   %ebp
c0100e10:	89 e5                	mov    %esp,%ebp
c0100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e19:	74 05                	je     c0100e20 <__intr_restore+0x11>
        intr_enable();
c0100e1b:	e8 83 08 00 00       	call   c01016a3 <intr_enable>
    }
}
c0100e20:	c9                   	leave  
c0100e21:	c3                   	ret    

c0100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e22:	55                   	push   %ebp
c0100e23:	89 e5                	mov    %esp,%ebp
c0100e25:	83 ec 10             	sub    $0x10,%esp
c0100e28:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e32:	89 c2                	mov    %eax,%edx
c0100e34:	ec                   	in     (%dx),%al
c0100e35:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e42:	89 c2                	mov    %eax,%edx
c0100e44:	ec                   	in     (%dx),%al
c0100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e48:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e52:	89 c2                	mov    %eax,%edx
c0100e54:	ec                   	in     (%dx),%al
c0100e55:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e58:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e62:	89 c2                	mov    %eax,%edx
c0100e64:	ec                   	in     (%dx),%al
c0100e65:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e68:	c9                   	leave  
c0100e69:	c3                   	ret    

c0100e6a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e6a:	55                   	push   %ebp
c0100e6b:	89 e5                	mov    %esp,%ebp
c0100e6d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e70:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7a:	0f b7 00             	movzwl (%eax),%eax
c0100e7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e84:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8c:	0f b7 00             	movzwl (%eax),%eax
c0100e8f:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e93:	74 12                	je     c0100ea7 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e95:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e9c:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100ea3:	b4 03 
c0100ea5:	eb 13                	jmp    c0100eba <cga_init+0x50>
    } else {
        *cp = was;
c0100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eaa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eae:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb1:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100eb8:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eba:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec1:	0f b7 c0             	movzwl %ax,%eax
c0100ec4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ec8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ecc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ed5:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100edc:	83 c0 01             	add    $0x1,%eax
c0100edf:	0f b7 c0             	movzwl %ax,%eax
c0100ee2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100eea:	89 c2                	mov    %eax,%edx
c0100eec:	ec                   	in     (%dx),%al
c0100eed:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ef4:	0f b6 c0             	movzbl %al,%eax
c0100ef7:	c1 e0 08             	shl    $0x8,%eax
c0100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100efd:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f04:	0f b7 c0             	movzwl %ax,%eax
c0100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f0b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f0f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f13:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f17:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f18:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f1f:	83 c0 01             	add    $0x1,%eax
c0100f22:	0f b7 c0             	movzwl %ax,%eax
c0100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f29:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f2d:	89 c2                	mov    %eax,%edx
c0100f2f:	ec                   	in     (%dx),%al
c0100f30:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f33:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f37:	0f b6 c0             	movzbl %al,%eax
c0100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f40:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f48:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f4e:	c9                   	leave  
c0100f4f:	c3                   	ret    

c0100f50 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f50:	55                   	push   %ebp
c0100f51:	89 e5                	mov    %esp,%ebp
c0100f53:	83 ec 48             	sub    $0x48,%esp
c0100f56:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f5c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f60:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f68:	ee                   	out    %al,(%dx)
c0100f69:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f6f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f73:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f77:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f7b:	ee                   	out    %al,(%dx)
c0100f7c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f82:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8e:	ee                   	out    %al,(%dx)
c0100f8f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f99:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f9d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa1:	ee                   	out    %al,(%dx)
c0100fa2:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fa8:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fb4:	ee                   	out    %al,(%dx)
c0100fb5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fbb:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fc7:	ee                   	out    %al,(%dx)
c0100fc8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fce:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fd6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fda:	ee                   	out    %al,(%dx)
c0100fdb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fe5:	89 c2                	mov    %eax,%edx
c0100fe7:	ec                   	in     (%dx),%al
c0100fe8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100feb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fef:	3c ff                	cmp    $0xff,%al
c0100ff1:	0f 95 c0             	setne  %al
c0100ff4:	0f b6 c0             	movzbl %al,%eax
c0100ff7:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100ffc:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101002:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101006:	89 c2                	mov    %eax,%edx
c0101008:	ec                   	in     (%dx),%al
c0101009:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010100c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101012:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101016:	89 c2                	mov    %eax,%edx
c0101018:	ec                   	in     (%dx),%al
c0101019:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010101c:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101021:	85 c0                	test   %eax,%eax
c0101023:	74 0c                	je     c0101031 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010102c:	e8 d6 06 00 00       	call   c0101707 <pic_enable>
    }
}
c0101031:	c9                   	leave  
c0101032:	c3                   	ret    

c0101033 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101033:	55                   	push   %ebp
c0101034:	89 e5                	mov    %esp,%ebp
c0101036:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101040:	eb 09                	jmp    c010104b <lpt_putc_sub+0x18>
        delay();
c0101042:	e8 db fd ff ff       	call   c0100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101047:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010104b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101051:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101055:	89 c2                	mov    %eax,%edx
c0101057:	ec                   	in     (%dx),%al
c0101058:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010105b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010105f:	84 c0                	test   %al,%al
c0101061:	78 09                	js     c010106c <lpt_putc_sub+0x39>
c0101063:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010106a:	7e d6                	jle    c0101042 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010106c:	8b 45 08             	mov    0x8(%ebp),%eax
c010106f:	0f b6 c0             	movzbl %al,%eax
c0101072:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101078:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101083:	ee                   	out    %al,(%dx)
c0101084:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010108a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010108e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101092:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101096:	ee                   	out    %al,(%dx)
c0101097:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c010109d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010a9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010aa:	c9                   	leave  
c01010ab:	c3                   	ret    

c01010ac <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010ac:	55                   	push   %ebp
c01010ad:	89 e5                	mov    %esp,%ebp
c01010af:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b6:	74 0d                	je     c01010c5 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01010bb:	89 04 24             	mov    %eax,(%esp)
c01010be:	e8 70 ff ff ff       	call   c0101033 <lpt_putc_sub>
c01010c3:	eb 24                	jmp    c01010e9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010cc:	e8 62 ff ff ff       	call   c0101033 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010d8:	e8 56 ff ff ff       	call   c0101033 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e4:	e8 4a ff ff ff       	call   c0101033 <lpt_putc_sub>
    }
}
c01010e9:	c9                   	leave  
c01010ea:	c3                   	ret    

c01010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010eb:	55                   	push   %ebp
c01010ec:	89 e5                	mov    %esp,%ebp
c01010ee:	53                   	push   %ebx
c01010ef:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f5:	b0 00                	mov    $0x0,%al
c01010f7:	85 c0                	test   %eax,%eax
c01010f9:	75 07                	jne    c0101102 <cga_putc+0x17>
        c |= 0x0700;
c01010fb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101102:	8b 45 08             	mov    0x8(%ebp),%eax
c0101105:	0f b6 c0             	movzbl %al,%eax
c0101108:	83 f8 0a             	cmp    $0xa,%eax
c010110b:	74 4c                	je     c0101159 <cga_putc+0x6e>
c010110d:	83 f8 0d             	cmp    $0xd,%eax
c0101110:	74 57                	je     c0101169 <cga_putc+0x7e>
c0101112:	83 f8 08             	cmp    $0x8,%eax
c0101115:	0f 85 88 00 00 00    	jne    c01011a3 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010111b:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101122:	66 85 c0             	test   %ax,%ax
c0101125:	74 30                	je     c0101157 <cga_putc+0x6c>
            crt_pos --;
c0101127:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010112e:	83 e8 01             	sub    $0x1,%eax
c0101131:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101137:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010113c:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101143:	0f b7 d2             	movzwl %dx,%edx
c0101146:	01 d2                	add    %edx,%edx
c0101148:	01 c2                	add    %eax,%edx
c010114a:	8b 45 08             	mov    0x8(%ebp),%eax
c010114d:	b0 00                	mov    $0x0,%al
c010114f:	83 c8 20             	or     $0x20,%eax
c0101152:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101155:	eb 72                	jmp    c01011c9 <cga_putc+0xde>
c0101157:	eb 70                	jmp    c01011c9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101159:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101160:	83 c0 50             	add    $0x50,%eax
c0101163:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101169:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101170:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101177:	0f b7 c1             	movzwl %cx,%eax
c010117a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101180:	c1 e8 10             	shr    $0x10,%eax
c0101183:	89 c2                	mov    %eax,%edx
c0101185:	66 c1 ea 06          	shr    $0x6,%dx
c0101189:	89 d0                	mov    %edx,%eax
c010118b:	c1 e0 02             	shl    $0x2,%eax
c010118e:	01 d0                	add    %edx,%eax
c0101190:	c1 e0 04             	shl    $0x4,%eax
c0101193:	29 c1                	sub    %eax,%ecx
c0101195:	89 ca                	mov    %ecx,%edx
c0101197:	89 d8                	mov    %ebx,%eax
c0101199:	29 d0                	sub    %edx,%eax
c010119b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011a1:	eb 26                	jmp    c01011c9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a3:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011a9:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b0:	8d 50 01             	lea    0x1(%eax),%edx
c01011b3:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011ba:	0f b7 c0             	movzwl %ax,%eax
c01011bd:	01 c0                	add    %eax,%eax
c01011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c5:	66 89 02             	mov    %ax,(%edx)
        break;
c01011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011c9:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011d0:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d4:	76 5b                	jbe    c0101231 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011d6:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e1:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011ed:	00 
c01011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f2:	89 04 24             	mov    %eax,(%esp)
c01011f5:	e8 68 4a 00 00       	call   c0105c62 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011fa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101201:	eb 15                	jmp    c0101218 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101203:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101208:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010120b:	01 d2                	add    %edx,%edx
c010120d:	01 d0                	add    %edx,%eax
c010120f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101218:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010121f:	7e e2                	jle    c0101203 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101221:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101228:	83 e8 50             	sub    $0x50,%eax
c010122b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101231:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101238:	0f b7 c0             	movzwl %ax,%eax
c010123b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010123f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101243:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101247:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010124c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101253:	66 c1 e8 08          	shr    $0x8,%ax
c0101257:	0f b6 c0             	movzbl %al,%eax
c010125a:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101261:	83 c2 01             	add    $0x1,%edx
c0101264:	0f b7 d2             	movzwl %dx,%edx
c0101267:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010126b:	88 45 ed             	mov    %al,-0x13(%ebp)
c010126e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101272:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101276:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101277:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010127e:	0f b7 c0             	movzwl %ax,%eax
c0101281:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101285:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101289:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010128d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101291:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101292:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101299:	0f b6 c0             	movzbl %al,%eax
c010129c:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012a3:	83 c2 01             	add    $0x1,%edx
c01012a6:	0f b7 d2             	movzwl %dx,%edx
c01012a9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ad:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012b8:	ee                   	out    %al,(%dx)
}
c01012b9:	83 c4 34             	add    $0x34,%esp
c01012bc:	5b                   	pop    %ebx
c01012bd:	5d                   	pop    %ebp
c01012be:	c3                   	ret    

c01012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012bf:	55                   	push   %ebp
c01012c0:	89 e5                	mov    %esp,%ebp
c01012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012cc:	eb 09                	jmp    c01012d7 <serial_putc_sub+0x18>
        delay();
c01012ce:	e8 4f fb ff ff       	call   c0100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e1:	89 c2                	mov    %eax,%edx
c01012e3:	ec                   	in     (%dx),%al
c01012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012eb:	0f b6 c0             	movzbl %al,%eax
c01012ee:	83 e0 20             	and    $0x20,%eax
c01012f1:	85 c0                	test   %eax,%eax
c01012f3:	75 09                	jne    c01012fe <serial_putc_sub+0x3f>
c01012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012fc:	7e d0                	jle    c01012ce <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101301:	0f b6 c0             	movzbl %al,%eax
c0101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010130a:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101315:	ee                   	out    %al,(%dx)
}
c0101316:	c9                   	leave  
c0101317:	c3                   	ret    

c0101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101318:	55                   	push   %ebp
c0101319:	89 e5                	mov    %esp,%ebp
c010131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101322:	74 0d                	je     c0101331 <serial_putc+0x19>
        serial_putc_sub(c);
c0101324:	8b 45 08             	mov    0x8(%ebp),%eax
c0101327:	89 04 24             	mov    %eax,(%esp)
c010132a:	e8 90 ff ff ff       	call   c01012bf <serial_putc_sub>
c010132f:	eb 24                	jmp    c0101355 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101338:	e8 82 ff ff ff       	call   c01012bf <serial_putc_sub>
        serial_putc_sub(' ');
c010133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101344:	e8 76 ff ff ff       	call   c01012bf <serial_putc_sub>
        serial_putc_sub('\b');
c0101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101350:	e8 6a ff ff ff       	call   c01012bf <serial_putc_sub>
    }
}
c0101355:	c9                   	leave  
c0101356:	c3                   	ret    

c0101357 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101357:	55                   	push   %ebp
c0101358:	89 e5                	mov    %esp,%ebp
c010135a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010135d:	eb 33                	jmp    c0101392 <cons_intr+0x3b>
        if (c != 0) {
c010135f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101363:	74 2d                	je     c0101392 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101365:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010136a:	8d 50 01             	lea    0x1(%eax),%edx
c010136d:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101373:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101376:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010137c:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101381:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101386:	75 0a                	jne    c0101392 <cons_intr+0x3b>
                cons.wpos = 0;
c0101388:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c010138f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101392:	8b 45 08             	mov    0x8(%ebp),%eax
c0101395:	ff d0                	call   *%eax
c0101397:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010139a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010139e:	75 bf                	jne    c010135f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a0:	c9                   	leave  
c01013a1:	c3                   	ret    

c01013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a2:	55                   	push   %ebp
c01013a3:	89 e5                	mov    %esp,%ebp
c01013a5:	83 ec 10             	sub    $0x10,%esp
c01013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b2:	89 c2                	mov    %eax,%edx
c01013b4:	ec                   	in     (%dx),%al
c01013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013bc:	0f b6 c0             	movzbl %al,%eax
c01013bf:	83 e0 01             	and    $0x1,%eax
c01013c2:	85 c0                	test   %eax,%eax
c01013c4:	75 07                	jne    c01013cd <serial_proc_data+0x2b>
        return -1;
c01013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013cb:	eb 2a                	jmp    c01013f7 <serial_proc_data+0x55>
c01013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013d7:	89 c2                	mov    %eax,%edx
c01013d9:	ec                   	in     (%dx),%al
c01013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e1:	0f b6 c0             	movzbl %al,%eax
c01013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013eb:	75 07                	jne    c01013f4 <serial_proc_data+0x52>
        c = '\b';
c01013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013f7:	c9                   	leave  
c01013f8:	c3                   	ret    

c01013f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013f9:	55                   	push   %ebp
c01013fa:	89 e5                	mov    %esp,%ebp
c01013fc:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013ff:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101404:	85 c0                	test   %eax,%eax
c0101406:	74 0c                	je     c0101414 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101408:	c7 04 24 a2 13 10 c0 	movl   $0xc01013a2,(%esp)
c010140f:	e8 43 ff ff ff       	call   c0101357 <cons_intr>
    }
}
c0101414:	c9                   	leave  
c0101415:	c3                   	ret    

c0101416 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101416:	55                   	push   %ebp
c0101417:	89 e5                	mov    %esp,%ebp
c0101419:	83 ec 38             	sub    $0x38,%esp
c010141c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101422:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101426:	89 c2                	mov    %eax,%edx
c0101428:	ec                   	in     (%dx),%al
c0101429:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010142c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101430:	0f b6 c0             	movzbl %al,%eax
c0101433:	83 e0 01             	and    $0x1,%eax
c0101436:	85 c0                	test   %eax,%eax
c0101438:	75 0a                	jne    c0101444 <kbd_proc_data+0x2e>
        return -1;
c010143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010143f:	e9 59 01 00 00       	jmp    c010159d <kbd_proc_data+0x187>
c0101444:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010144e:	89 c2                	mov    %eax,%edx
c0101450:	ec                   	in     (%dx),%al
c0101451:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101454:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101458:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010145b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010145f:	75 17                	jne    c0101478 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101461:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101466:	83 c8 40             	or     $0x40,%eax
c0101469:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010146e:	b8 00 00 00 00       	mov    $0x0,%eax
c0101473:	e9 25 01 00 00       	jmp    c010159d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147c:	84 c0                	test   %al,%al
c010147e:	79 47                	jns    c01014c7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101480:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101485:	83 e0 40             	and    $0x40,%eax
c0101488:	85 c0                	test   %eax,%eax
c010148a:	75 09                	jne    c0101495 <kbd_proc_data+0x7f>
c010148c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101490:	83 e0 7f             	and    $0x7f,%eax
c0101493:	eb 04                	jmp    c0101499 <kbd_proc_data+0x83>
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a0:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014a7:	83 c8 40             	or     $0x40,%eax
c01014aa:	0f b6 c0             	movzbl %al,%eax
c01014ad:	f7 d0                	not    %eax
c01014af:	89 c2                	mov    %eax,%edx
c01014b1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b6:	21 d0                	and    %edx,%eax
c01014b8:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014bd:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c2:	e9 d6 00 00 00       	jmp    c010159d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014c7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014cc:	83 e0 40             	and    $0x40,%eax
c01014cf:	85 c0                	test   %eax,%eax
c01014d1:	74 11                	je     c01014e4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014d7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014dc:	83 e0 bf             	and    $0xffffffbf,%eax
c01014df:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e8:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ef:	0f b6 d0             	movzbl %al,%edx
c01014f2:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014f7:	09 d0                	or     %edx,%eax
c01014f9:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101502:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101509:	0f b6 d0             	movzbl %al,%edx
c010150c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101511:	31 d0                	xor    %edx,%eax
c0101513:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101518:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010151d:	83 e0 03             	and    $0x3,%eax
c0101520:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152b:	01 d0                	add    %edx,%eax
c010152d:	0f b6 00             	movzbl (%eax),%eax
c0101530:	0f b6 c0             	movzbl %al,%eax
c0101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101536:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010153b:	83 e0 08             	and    $0x8,%eax
c010153e:	85 c0                	test   %eax,%eax
c0101540:	74 22                	je     c0101564 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101546:	7e 0c                	jle    c0101554 <kbd_proc_data+0x13e>
c0101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010154c:	7f 06                	jg     c0101554 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101552:	eb 10                	jmp    c0101564 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101558:	7e 0a                	jle    c0101564 <kbd_proc_data+0x14e>
c010155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010155e:	7f 04                	jg     c0101564 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101564:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101569:	f7 d0                	not    %eax
c010156b:	83 e0 06             	and    $0x6,%eax
c010156e:	85 c0                	test   %eax,%eax
c0101570:	75 28                	jne    c010159a <kbd_proc_data+0x184>
c0101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101579:	75 1f                	jne    c010159a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010157b:	c7 04 24 e1 60 10 c0 	movl   $0xc01060e1,(%esp)
c0101582:	e8 b5 ed ff ff       	call   c010033c <cprintf>
c0101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101595:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101599:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010159d:	c9                   	leave  
c010159e:	c3                   	ret    

c010159f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010159f:	55                   	push   %ebp
c01015a0:	89 e5                	mov    %esp,%ebp
c01015a2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015a5:	c7 04 24 16 14 10 c0 	movl   $0xc0101416,(%esp)
c01015ac:	e8 a6 fd ff ff       	call   c0101357 <cons_intr>
}
c01015b1:	c9                   	leave  
c01015b2:	c3                   	ret    

c01015b3 <kbd_init>:

static void
kbd_init(void) {
c01015b3:	55                   	push   %ebp
c01015b4:	89 e5                	mov    %esp,%ebp
c01015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015b9:	e8 e1 ff ff ff       	call   c010159f <kbd_intr>
    pic_enable(IRQ_KBD);
c01015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015c5:	e8 3d 01 00 00       	call   c0101707 <pic_enable>
}
c01015ca:	c9                   	leave  
c01015cb:	c3                   	ret    

c01015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015cc:	55                   	push   %ebp
c01015cd:	89 e5                	mov    %esp,%ebp
c01015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d2:	e8 93 f8 ff ff       	call   c0100e6a <cga_init>
    serial_init();
c01015d7:	e8 74 f9 ff ff       	call   c0100f50 <serial_init>
    kbd_init();
c01015dc:	e8 d2 ff ff ff       	call   c01015b3 <kbd_init>
    if (!serial_exists) {
c01015e1:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015e6:	85 c0                	test   %eax,%eax
c01015e8:	75 0c                	jne    c01015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015ea:	c7 04 24 ed 60 10 c0 	movl   $0xc01060ed,(%esp)
c01015f1:	e8 46 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015f6:	c9                   	leave  
c01015f7:	c3                   	ret    

c01015f8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015f8:	55                   	push   %ebp
c01015f9:	89 e5                	mov    %esp,%ebp
c01015fb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015fe:	e8 e2 f7 ff ff       	call   c0100de5 <__intr_save>
c0101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101606:	8b 45 08             	mov    0x8(%ebp),%eax
c0101609:	89 04 24             	mov    %eax,(%esp)
c010160c:	e8 9b fa ff ff       	call   c01010ac <lpt_putc>
        cga_putc(c);
c0101611:	8b 45 08             	mov    0x8(%ebp),%eax
c0101614:	89 04 24             	mov    %eax,(%esp)
c0101617:	e8 cf fa ff ff       	call   c01010eb <cga_putc>
        serial_putc(c);
c010161c:	8b 45 08             	mov    0x8(%ebp),%eax
c010161f:	89 04 24             	mov    %eax,(%esp)
c0101622:	e8 f1 fc ff ff       	call   c0101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101627:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010162a:	89 04 24             	mov    %eax,(%esp)
c010162d:	e8 dd f7 ff ff       	call   c0100e0f <__intr_restore>
}
c0101632:	c9                   	leave  
c0101633:	c3                   	ret    

c0101634 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101634:	55                   	push   %ebp
c0101635:	89 e5                	mov    %esp,%ebp
c0101637:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101641:	e8 9f f7 ff ff       	call   c0100de5 <__intr_save>
c0101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101649:	e8 ab fd ff ff       	call   c01013f9 <serial_intr>
        kbd_intr();
c010164e:	e8 4c ff ff ff       	call   c010159f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101653:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101659:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010165e:	39 c2                	cmp    %eax,%edx
c0101660:	74 31                	je     c0101693 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101662:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101667:	8d 50 01             	lea    0x1(%eax),%edx
c010166a:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101670:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101677:	0f b6 c0             	movzbl %al,%eax
c010167a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010167d:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101682:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101687:	75 0a                	jne    c0101693 <cons_getc+0x5f>
                cons.rpos = 0;
c0101689:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101690:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101693:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101696:	89 04 24             	mov    %eax,(%esp)
c0101699:	e8 71 f7 ff ff       	call   c0100e0f <__intr_restore>
    return c;
c010169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a1:	c9                   	leave  
c01016a2:	c3                   	ret    

c01016a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016a3:	55                   	push   %ebp
c01016a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016a6:	fb                   	sti    
    sti();
}
c01016a7:	5d                   	pop    %ebp
c01016a8:	c3                   	ret    

c01016a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016a9:	55                   	push   %ebp
c01016aa:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016ac:	fa                   	cli    
    cli();
}
c01016ad:	5d                   	pop    %ebp
c01016ae:	c3                   	ret    

c01016af <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016af:	55                   	push   %ebp
c01016b0:	89 e5                	mov    %esp,%ebp
c01016b2:	83 ec 14             	sub    $0x14,%esp
c01016b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c0:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016c6:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016cb:	85 c0                	test   %eax,%eax
c01016cd:	74 36                	je     c0101705 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d3:	0f b6 c0             	movzbl %al,%eax
c01016d6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016dc:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016e7:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ec:	66 c1 e8 08          	shr    $0x8,%ax
c01016f0:	0f b6 c0             	movzbl %al,%eax
c01016f3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016f9:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101700:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101704:	ee                   	out    %al,(%dx)
    }
}
c0101705:	c9                   	leave  
c0101706:	c3                   	ret    

c0101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101707:	55                   	push   %ebp
c0101708:	89 e5                	mov    %esp,%ebp
c010170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010170d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101710:	ba 01 00 00 00       	mov    $0x1,%edx
c0101715:	89 c1                	mov    %eax,%ecx
c0101717:	d3 e2                	shl    %cl,%edx
c0101719:	89 d0                	mov    %edx,%eax
c010171b:	f7 d0                	not    %eax
c010171d:	89 c2                	mov    %eax,%edx
c010171f:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101726:	21 d0                	and    %edx,%eax
c0101728:	0f b7 c0             	movzwl %ax,%eax
c010172b:	89 04 24             	mov    %eax,(%esp)
c010172e:	e8 7c ff ff ff       	call   c01016af <pic_setmask>
}
c0101733:	c9                   	leave  
c0101734:	c3                   	ret    

c0101735 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101735:	55                   	push   %ebp
c0101736:	89 e5                	mov    %esp,%ebp
c0101738:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010173b:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101742:	00 00 00 
c0101745:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010174b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010174f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101753:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101757:	ee                   	out    %al,(%dx)
c0101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010175e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101762:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010176a:	ee                   	out    %al,(%dx)
c010176b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101771:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101775:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101779:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010177d:	ee                   	out    %al,(%dx)
c010177e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101784:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101788:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010178c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101790:	ee                   	out    %al,(%dx)
c0101791:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101797:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010179b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010179f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a3:	ee                   	out    %al,(%dx)
c01017a4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017aa:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017b6:	ee                   	out    %al,(%dx)
c01017b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017bd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017c9:	ee                   	out    %al,(%dx)
c01017ca:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017d4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017d8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017dc:	ee                   	out    %al,(%dx)
c01017dd:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017e7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017eb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017ef:	ee                   	out    %al,(%dx)
c01017f0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017f6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017fe:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101802:	ee                   	out    %al,(%dx)
c0101803:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101809:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010180d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101811:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101815:	ee                   	out    %al,(%dx)
c0101816:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010181c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101820:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101824:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101828:	ee                   	out    %al,(%dx)
c0101829:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010182f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101833:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101837:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010183b:	ee                   	out    %al,(%dx)
c010183c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101842:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101846:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010184a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010184e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010184f:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101856:	66 83 f8 ff          	cmp    $0xffff,%ax
c010185a:	74 12                	je     c010186e <pic_init+0x139>
        pic_setmask(irq_mask);
c010185c:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101863:	0f b7 c0             	movzwl %ax,%eax
c0101866:	89 04 24             	mov    %eax,(%esp)
c0101869:	e8 41 fe ff ff       	call   c01016af <pic_setmask>
    }
}
c010186e:	c9                   	leave  
c010186f:	c3                   	ret    

c0101870 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101870:	55                   	push   %ebp
c0101871:	89 e5                	mov    %esp,%ebp
c0101873:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101876:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010187d:	00 
c010187e:	c7 04 24 20 61 10 c0 	movl   $0xc0106120,(%esp)
c0101885:	e8 b2 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010188a:	c9                   	leave  
c010188b:	c3                   	ret    

c010188c <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010188c:	55                   	push   %ebp
c010188d:	89 e5                	mov    %esp,%ebp
c010188f:	83 ec 10             	sub    $0x10,%esp
      */
	extern uintptr_t __vectors[];

	// 计算出有多少个IDT，依次遍历他们
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
c0101892:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101899:	e9 c3 00 00 00       	jmp    c0101961 <idt_init+0xd5>

		// 初始化若干IDT
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010189e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a1:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018a8:	89 c2                	mov    %eax,%edx
c01018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ad:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018b4:	c0 
c01018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b8:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018bf:	c0 08 00 
c01018c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c5:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018cc:	c0 
c01018cd:	83 e2 e0             	and    $0xffffffe0,%edx
c01018d0:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018da:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018e1:	c0 
c01018e2:	83 e2 1f             	and    $0x1f,%edx
c01018e5:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ef:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01018f6:	c0 
c01018f7:	83 e2 f0             	and    $0xfffffff0,%edx
c01018fa:	83 ca 0e             	or     $0xe,%edx
c01018fd:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101907:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010190e:	c0 
c010190f:	83 e2 ef             	and    $0xffffffef,%edx
c0101912:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191c:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101923:	c0 
c0101924:	83 e2 9f             	and    $0xffffff9f,%edx
c0101927:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101931:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101938:	c0 
c0101939:	83 ca 80             	or     $0xffffff80,%edx
c010193c:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101946:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010194d:	c1 e8 10             	shr    $0x10,%eax
c0101950:	89 c2                	mov    %eax,%edx
c0101952:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101955:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c010195c:	c0 
      */
	extern uintptr_t __vectors[];

	// 计算出有多少个IDT，依次遍历他们
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
c010195d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101961:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101964:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101969:	0f 86 2f ff ff ff    	jbe    c010189e <idt_init+0x12>
		// 初始化若干IDT
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	}

	// T_SWITCH_TOK 的发生时机是在用户空间的，所以对应的dpl需要修改为DPL_USER。
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c010196f:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101974:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c010197a:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c0101981:	08 00 
c0101983:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c010198a:	83 e0 e0             	and    $0xffffffe0,%eax
c010198d:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c0101992:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101999:	83 e0 1f             	and    $0x1f,%eax
c010199c:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019a1:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019a8:	83 e0 f0             	and    $0xfffffff0,%eax
c01019ab:	83 c8 0e             	or     $0xe,%eax
c01019ae:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019b3:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019ba:	83 e0 ef             	and    $0xffffffef,%eax
c01019bd:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019c2:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019c9:	83 c8 60             	or     $0x60,%eax
c01019cc:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019d1:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019d8:	83 c8 80             	or     $0xffffff80,%eax
c01019db:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019e0:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019e5:	c1 e8 10             	shr    $0x10,%eax
c01019e8:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c01019ee:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019f8:	0f 01 18             	lidtl  (%eax)

	// 加载IDT，只有特权级为0才允许执行
	lidt(&idt_pd);
}
c01019fb:	c9                   	leave  
c01019fc:	c3                   	ret    

c01019fd <trapname>:

static const char *
trapname(int trapno) {
c01019fd:	55                   	push   %ebp
c01019fe:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a03:	83 f8 13             	cmp    $0x13,%eax
c0101a06:	77 0c                	ja     c0101a14 <trapname+0x17>
        return excnames[trapno];
c0101a08:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a0b:	8b 04 85 80 64 10 c0 	mov    -0x3fef9b80(,%eax,4),%eax
c0101a12:	eb 18                	jmp    c0101a2c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a14:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a18:	7e 0d                	jle    c0101a27 <trapname+0x2a>
c0101a1a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a1e:	7f 07                	jg     c0101a27 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a20:	b8 2a 61 10 c0       	mov    $0xc010612a,%eax
c0101a25:	eb 05                	jmp    c0101a2c <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a27:	b8 3d 61 10 c0       	mov    $0xc010613d,%eax
}
c0101a2c:	5d                   	pop    %ebp
c0101a2d:	c3                   	ret    

c0101a2e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a2e:	55                   	push   %ebp
c0101a2f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a31:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a34:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a38:	66 83 f8 08          	cmp    $0x8,%ax
c0101a3c:	0f 94 c0             	sete   %al
c0101a3f:	0f b6 c0             	movzbl %al,%eax
}
c0101a42:	5d                   	pop    %ebp
c0101a43:	c3                   	ret    

c0101a44 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a44:	55                   	push   %ebp
c0101a45:	89 e5                	mov    %esp,%ebp
c0101a47:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a51:	c7 04 24 7e 61 10 c0 	movl   $0xc010617e,(%esp)
c0101a58:	e8 df e8 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a60:	89 04 24             	mov    %eax,(%esp)
c0101a63:	e8 a1 01 00 00       	call   c0101c09 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a6f:	0f b7 c0             	movzwl %ax,%eax
c0101a72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a76:	c7 04 24 8f 61 10 c0 	movl   $0xc010618f,(%esp)
c0101a7d:	e8 ba e8 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a85:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a89:	0f b7 c0             	movzwl %ax,%eax
c0101a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a90:	c7 04 24 a2 61 10 c0 	movl   $0xc01061a2,(%esp)
c0101a97:	e8 a0 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aa3:	0f b7 c0             	movzwl %ax,%eax
c0101aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aaa:	c7 04 24 b5 61 10 c0 	movl   $0xc01061b5,(%esp)
c0101ab1:	e8 86 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab9:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101abd:	0f b7 c0             	movzwl %ax,%eax
c0101ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac4:	c7 04 24 c8 61 10 c0 	movl   $0xc01061c8,(%esp)
c0101acb:	e8 6c e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad3:	8b 40 30             	mov    0x30(%eax),%eax
c0101ad6:	89 04 24             	mov    %eax,(%esp)
c0101ad9:	e8 1f ff ff ff       	call   c01019fd <trapname>
c0101ade:	8b 55 08             	mov    0x8(%ebp),%edx
c0101ae1:	8b 52 30             	mov    0x30(%edx),%edx
c0101ae4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101ae8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101aec:	c7 04 24 db 61 10 c0 	movl   $0xc01061db,(%esp)
c0101af3:	e8 44 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101afb:	8b 40 34             	mov    0x34(%eax),%eax
c0101afe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b02:	c7 04 24 ed 61 10 c0 	movl   $0xc01061ed,(%esp)
c0101b09:	e8 2e e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b11:	8b 40 38             	mov    0x38(%eax),%eax
c0101b14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b18:	c7 04 24 fc 61 10 c0 	movl   $0xc01061fc,(%esp)
c0101b1f:	e8 18 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b27:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b2b:	0f b7 c0             	movzwl %ax,%eax
c0101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b32:	c7 04 24 0b 62 10 c0 	movl   $0xc010620b,(%esp)
c0101b39:	e8 fe e7 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b41:	8b 40 40             	mov    0x40(%eax),%eax
c0101b44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b48:	c7 04 24 1e 62 10 c0 	movl   $0xc010621e,(%esp)
c0101b4f:	e8 e8 e7 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b5b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b62:	eb 3e                	jmp    c0101ba2 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b67:	8b 50 40             	mov    0x40(%eax),%edx
c0101b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b6d:	21 d0                	and    %edx,%eax
c0101b6f:	85 c0                	test   %eax,%eax
c0101b71:	74 28                	je     c0101b9b <print_trapframe+0x157>
c0101b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b76:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b7d:	85 c0                	test   %eax,%eax
c0101b7f:	74 1a                	je     c0101b9b <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b84:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b8f:	c7 04 24 2d 62 10 c0 	movl   $0xc010622d,(%esp)
c0101b96:	e8 a1 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b9f:	d1 65 f0             	shll   -0x10(%ebp)
c0101ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba5:	83 f8 17             	cmp    $0x17,%eax
c0101ba8:	76 ba                	jbe    c0101b64 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101baa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bad:	8b 40 40             	mov    0x40(%eax),%eax
c0101bb0:	25 00 30 00 00       	and    $0x3000,%eax
c0101bb5:	c1 e8 0c             	shr    $0xc,%eax
c0101bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bbc:	c7 04 24 31 62 10 c0 	movl   $0xc0106231,(%esp)
c0101bc3:	e8 74 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bcb:	89 04 24             	mov    %eax,(%esp)
c0101bce:	e8 5b fe ff ff       	call   c0101a2e <trap_in_kernel>
c0101bd3:	85 c0                	test   %eax,%eax
c0101bd5:	75 30                	jne    c0101c07 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bda:	8b 40 44             	mov    0x44(%eax),%eax
c0101bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be1:	c7 04 24 3a 62 10 c0 	movl   $0xc010623a,(%esp)
c0101be8:	e8 4f e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf0:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101bf4:	0f b7 c0             	movzwl %ax,%eax
c0101bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bfb:	c7 04 24 49 62 10 c0 	movl   $0xc0106249,(%esp)
c0101c02:	e8 35 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101c07:	c9                   	leave  
c0101c08:	c3                   	ret    

c0101c09 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c09:	55                   	push   %ebp
c0101c0a:	89 e5                	mov    %esp,%ebp
c0101c0c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c12:	8b 00                	mov    (%eax),%eax
c0101c14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c18:	c7 04 24 5c 62 10 c0 	movl   $0xc010625c,(%esp)
c0101c1f:	e8 18 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c27:	8b 40 04             	mov    0x4(%eax),%eax
c0101c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2e:	c7 04 24 6b 62 10 c0 	movl   $0xc010626b,(%esp)
c0101c35:	e8 02 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3d:	8b 40 08             	mov    0x8(%eax),%eax
c0101c40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c44:	c7 04 24 7a 62 10 c0 	movl   $0xc010627a,(%esp)
c0101c4b:	e8 ec e6 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c53:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5a:	c7 04 24 89 62 10 c0 	movl   $0xc0106289,(%esp)
c0101c61:	e8 d6 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c69:	8b 40 10             	mov    0x10(%eax),%eax
c0101c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c70:	c7 04 24 98 62 10 c0 	movl   $0xc0106298,(%esp)
c0101c77:	e8 c0 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7f:	8b 40 14             	mov    0x14(%eax),%eax
c0101c82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c86:	c7 04 24 a7 62 10 c0 	movl   $0xc01062a7,(%esp)
c0101c8d:	e8 aa e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c92:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c95:	8b 40 18             	mov    0x18(%eax),%eax
c0101c98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9c:	c7 04 24 b6 62 10 c0 	movl   $0xc01062b6,(%esp)
c0101ca3:	e8 94 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cab:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb2:	c7 04 24 c5 62 10 c0 	movl   $0xc01062c5,(%esp)
c0101cb9:	e8 7e e6 ff ff       	call   c010033c <cprintf>
}
c0101cbe:	c9                   	leave  
c0101cbf:	c3                   	ret    

c0101cc0 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cc0:	55                   	push   %ebp
c0101cc1:	89 e5                	mov    %esp,%ebp
c0101cc3:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc9:	8b 40 30             	mov    0x30(%eax),%eax
c0101ccc:	83 f8 2f             	cmp    $0x2f,%eax
c0101ccf:	77 21                	ja     c0101cf2 <trap_dispatch+0x32>
c0101cd1:	83 f8 2e             	cmp    $0x2e,%eax
c0101cd4:	0f 83 04 01 00 00    	jae    c0101dde <trap_dispatch+0x11e>
c0101cda:	83 f8 21             	cmp    $0x21,%eax
c0101cdd:	0f 84 81 00 00 00    	je     c0101d64 <trap_dispatch+0xa4>
c0101ce3:	83 f8 24             	cmp    $0x24,%eax
c0101ce6:	74 56                	je     c0101d3e <trap_dispatch+0x7e>
c0101ce8:	83 f8 20             	cmp    $0x20,%eax
c0101ceb:	74 16                	je     c0101d03 <trap_dispatch+0x43>
c0101ced:	e9 b4 00 00 00       	jmp    c0101da6 <trap_dispatch+0xe6>
c0101cf2:	83 e8 78             	sub    $0x78,%eax
c0101cf5:	83 f8 01             	cmp    $0x1,%eax
c0101cf8:	0f 87 a8 00 00 00    	ja     c0101da6 <trap_dispatch+0xe6>
c0101cfe:	e9 87 00 00 00       	jmp    c0101d8a <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    ticks++;
c0101d03:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d08:	83 c0 01             	add    $0x1,%eax
c0101d0b:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
    if (ticks % TICK_NUM == 0) {
c0101d10:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d16:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d1b:	89 c8                	mov    %ecx,%eax
c0101d1d:	f7 e2                	mul    %edx
c0101d1f:	89 d0                	mov    %edx,%eax
c0101d21:	c1 e8 05             	shr    $0x5,%eax
c0101d24:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d27:	29 c1                	sub    %eax,%ecx
c0101d29:	89 c8                	mov    %ecx,%eax
c0101d2b:	85 c0                	test   %eax,%eax
c0101d2d:	75 0a                	jne    c0101d39 <trap_dispatch+0x79>
    	print_ticks();
c0101d2f:	e8 3c fb ff ff       	call   c0101870 <print_ticks>
    }
        break;
c0101d34:	e9 a6 00 00 00       	jmp    c0101ddf <trap_dispatch+0x11f>
c0101d39:	e9 a1 00 00 00       	jmp    c0101ddf <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d3e:	e8 f1 f8 ff ff       	call   c0101634 <cons_getc>
c0101d43:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d46:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d4a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d4e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d56:	c7 04 24 d4 62 10 c0 	movl   $0xc01062d4,(%esp)
c0101d5d:	e8 da e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d62:	eb 7b                	jmp    c0101ddf <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d64:	e8 cb f8 ff ff       	call   c0101634 <cons_getc>
c0101d69:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d6c:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d70:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d74:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d7c:	c7 04 24 e6 62 10 c0 	movl   $0xc01062e6,(%esp)
c0101d83:	e8 b4 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d88:	eb 55                	jmp    c0101ddf <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d8a:	c7 44 24 08 f5 62 10 	movl   $0xc01062f5,0x8(%esp)
c0101d91:	c0 
c0101d92:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0101d99:	00 
c0101d9a:	c7 04 24 05 63 10 c0 	movl   $0xc0106305,(%esp)
c0101da1:	e8 20 ef ff ff       	call   c0100cc6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101da6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dad:	0f b7 c0             	movzwl %ax,%eax
c0101db0:	83 e0 03             	and    $0x3,%eax
c0101db3:	85 c0                	test   %eax,%eax
c0101db5:	75 28                	jne    c0101ddf <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101db7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dba:	89 04 24             	mov    %eax,(%esp)
c0101dbd:	e8 82 fc ff ff       	call   c0101a44 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101dc2:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0101dc9:	c0 
c0101dca:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0101dd1:	00 
c0101dd2:	c7 04 24 05 63 10 c0 	movl   $0xc0106305,(%esp)
c0101dd9:	e8 e8 ee ff ff       	call   c0100cc6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101dde:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101ddf:	c9                   	leave  
c0101de0:	c3                   	ret    

c0101de1 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101de1:	55                   	push   %ebp
c0101de2:	89 e5                	mov    %esp,%ebp
c0101de4:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101de7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dea:	89 04 24             	mov    %eax,(%esp)
c0101ded:	e8 ce fe ff ff       	call   c0101cc0 <trap_dispatch>
}
c0101df2:	c9                   	leave  
c0101df3:	c3                   	ret    

c0101df4 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101df4:	1e                   	push   %ds
    pushl %es
c0101df5:	06                   	push   %es
    pushl %fs
c0101df6:	0f a0                	push   %fs
    pushl %gs
c0101df8:	0f a8                	push   %gs
    pushal
c0101dfa:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101dfb:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e00:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e02:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e04:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e05:	e8 d7 ff ff ff       	call   c0101de1 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e0a:	5c                   	pop    %esp

c0101e0b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e0b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e0c:	0f a9                	pop    %gs
    popl %fs
c0101e0e:	0f a1                	pop    %fs
    popl %es
c0101e10:	07                   	pop    %es
    popl %ds
c0101e11:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e12:	83 c4 08             	add    $0x8,%esp
    iret
c0101e15:	cf                   	iret   

c0101e16 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e16:	6a 00                	push   $0x0
  pushl $0
c0101e18:	6a 00                	push   $0x0
  jmp __alltraps
c0101e1a:	e9 d5 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e1f <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e1f:	6a 00                	push   $0x0
  pushl $1
c0101e21:	6a 01                	push   $0x1
  jmp __alltraps
c0101e23:	e9 cc ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e28 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e28:	6a 00                	push   $0x0
  pushl $2
c0101e2a:	6a 02                	push   $0x2
  jmp __alltraps
c0101e2c:	e9 c3 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e31 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e31:	6a 00                	push   $0x0
  pushl $3
c0101e33:	6a 03                	push   $0x3
  jmp __alltraps
c0101e35:	e9 ba ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e3a <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e3a:	6a 00                	push   $0x0
  pushl $4
c0101e3c:	6a 04                	push   $0x4
  jmp __alltraps
c0101e3e:	e9 b1 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e43 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e43:	6a 00                	push   $0x0
  pushl $5
c0101e45:	6a 05                	push   $0x5
  jmp __alltraps
c0101e47:	e9 a8 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e4c <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e4c:	6a 00                	push   $0x0
  pushl $6
c0101e4e:	6a 06                	push   $0x6
  jmp __alltraps
c0101e50:	e9 9f ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e55 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e55:	6a 00                	push   $0x0
  pushl $7
c0101e57:	6a 07                	push   $0x7
  jmp __alltraps
c0101e59:	e9 96 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e5e <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e5e:	6a 08                	push   $0x8
  jmp __alltraps
c0101e60:	e9 8f ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e65 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e65:	6a 09                	push   $0x9
  jmp __alltraps
c0101e67:	e9 88 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e6c <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e6c:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e6e:	e9 81 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e73 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e73:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e75:	e9 7a ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e7a <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e7a:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e7c:	e9 73 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e81 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e81:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e83:	e9 6c ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e88 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e88:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e8a:	e9 65 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e8f <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e8f:	6a 00                	push   $0x0
  pushl $15
c0101e91:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e93:	e9 5c ff ff ff       	jmp    c0101df4 <__alltraps>

c0101e98 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e98:	6a 00                	push   $0x0
  pushl $16
c0101e9a:	6a 10                	push   $0x10
  jmp __alltraps
c0101e9c:	e9 53 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101ea1 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ea1:	6a 11                	push   $0x11
  jmp __alltraps
c0101ea3:	e9 4c ff ff ff       	jmp    c0101df4 <__alltraps>

c0101ea8 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101ea8:	6a 00                	push   $0x0
  pushl $18
c0101eaa:	6a 12                	push   $0x12
  jmp __alltraps
c0101eac:	e9 43 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101eb1 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101eb1:	6a 00                	push   $0x0
  pushl $19
c0101eb3:	6a 13                	push   $0x13
  jmp __alltraps
c0101eb5:	e9 3a ff ff ff       	jmp    c0101df4 <__alltraps>

c0101eba <vector20>:
.globl vector20
vector20:
  pushl $0
c0101eba:	6a 00                	push   $0x0
  pushl $20
c0101ebc:	6a 14                	push   $0x14
  jmp __alltraps
c0101ebe:	e9 31 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101ec3 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101ec3:	6a 00                	push   $0x0
  pushl $21
c0101ec5:	6a 15                	push   $0x15
  jmp __alltraps
c0101ec7:	e9 28 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101ecc <vector22>:
.globl vector22
vector22:
  pushl $0
c0101ecc:	6a 00                	push   $0x0
  pushl $22
c0101ece:	6a 16                	push   $0x16
  jmp __alltraps
c0101ed0:	e9 1f ff ff ff       	jmp    c0101df4 <__alltraps>

c0101ed5 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101ed5:	6a 00                	push   $0x0
  pushl $23
c0101ed7:	6a 17                	push   $0x17
  jmp __alltraps
c0101ed9:	e9 16 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101ede <vector24>:
.globl vector24
vector24:
  pushl $0
c0101ede:	6a 00                	push   $0x0
  pushl $24
c0101ee0:	6a 18                	push   $0x18
  jmp __alltraps
c0101ee2:	e9 0d ff ff ff       	jmp    c0101df4 <__alltraps>

c0101ee7 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101ee7:	6a 00                	push   $0x0
  pushl $25
c0101ee9:	6a 19                	push   $0x19
  jmp __alltraps
c0101eeb:	e9 04 ff ff ff       	jmp    c0101df4 <__alltraps>

c0101ef0 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101ef0:	6a 00                	push   $0x0
  pushl $26
c0101ef2:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101ef4:	e9 fb fe ff ff       	jmp    c0101df4 <__alltraps>

c0101ef9 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ef9:	6a 00                	push   $0x0
  pushl $27
c0101efb:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101efd:	e9 f2 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f02 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f02:	6a 00                	push   $0x0
  pushl $28
c0101f04:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f06:	e9 e9 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f0b <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f0b:	6a 00                	push   $0x0
  pushl $29
c0101f0d:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f0f:	e9 e0 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f14 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f14:	6a 00                	push   $0x0
  pushl $30
c0101f16:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f18:	e9 d7 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f1d <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f1d:	6a 00                	push   $0x0
  pushl $31
c0101f1f:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f21:	e9 ce fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f26 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f26:	6a 00                	push   $0x0
  pushl $32
c0101f28:	6a 20                	push   $0x20
  jmp __alltraps
c0101f2a:	e9 c5 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f2f <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f2f:	6a 00                	push   $0x0
  pushl $33
c0101f31:	6a 21                	push   $0x21
  jmp __alltraps
c0101f33:	e9 bc fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f38 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f38:	6a 00                	push   $0x0
  pushl $34
c0101f3a:	6a 22                	push   $0x22
  jmp __alltraps
c0101f3c:	e9 b3 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f41 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f41:	6a 00                	push   $0x0
  pushl $35
c0101f43:	6a 23                	push   $0x23
  jmp __alltraps
c0101f45:	e9 aa fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f4a <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f4a:	6a 00                	push   $0x0
  pushl $36
c0101f4c:	6a 24                	push   $0x24
  jmp __alltraps
c0101f4e:	e9 a1 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f53 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f53:	6a 00                	push   $0x0
  pushl $37
c0101f55:	6a 25                	push   $0x25
  jmp __alltraps
c0101f57:	e9 98 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f5c <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f5c:	6a 00                	push   $0x0
  pushl $38
c0101f5e:	6a 26                	push   $0x26
  jmp __alltraps
c0101f60:	e9 8f fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f65 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f65:	6a 00                	push   $0x0
  pushl $39
c0101f67:	6a 27                	push   $0x27
  jmp __alltraps
c0101f69:	e9 86 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f6e <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f6e:	6a 00                	push   $0x0
  pushl $40
c0101f70:	6a 28                	push   $0x28
  jmp __alltraps
c0101f72:	e9 7d fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f77 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f77:	6a 00                	push   $0x0
  pushl $41
c0101f79:	6a 29                	push   $0x29
  jmp __alltraps
c0101f7b:	e9 74 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f80 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f80:	6a 00                	push   $0x0
  pushl $42
c0101f82:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f84:	e9 6b fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f89 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f89:	6a 00                	push   $0x0
  pushl $43
c0101f8b:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f8d:	e9 62 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f92 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f92:	6a 00                	push   $0x0
  pushl $44
c0101f94:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f96:	e9 59 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101f9b <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f9b:	6a 00                	push   $0x0
  pushl $45
c0101f9d:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f9f:	e9 50 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101fa4 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101fa4:	6a 00                	push   $0x0
  pushl $46
c0101fa6:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101fa8:	e9 47 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101fad <vector47>:
.globl vector47
vector47:
  pushl $0
c0101fad:	6a 00                	push   $0x0
  pushl $47
c0101faf:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101fb1:	e9 3e fe ff ff       	jmp    c0101df4 <__alltraps>

c0101fb6 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101fb6:	6a 00                	push   $0x0
  pushl $48
c0101fb8:	6a 30                	push   $0x30
  jmp __alltraps
c0101fba:	e9 35 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101fbf <vector49>:
.globl vector49
vector49:
  pushl $0
c0101fbf:	6a 00                	push   $0x0
  pushl $49
c0101fc1:	6a 31                	push   $0x31
  jmp __alltraps
c0101fc3:	e9 2c fe ff ff       	jmp    c0101df4 <__alltraps>

c0101fc8 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101fc8:	6a 00                	push   $0x0
  pushl $50
c0101fca:	6a 32                	push   $0x32
  jmp __alltraps
c0101fcc:	e9 23 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101fd1 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101fd1:	6a 00                	push   $0x0
  pushl $51
c0101fd3:	6a 33                	push   $0x33
  jmp __alltraps
c0101fd5:	e9 1a fe ff ff       	jmp    c0101df4 <__alltraps>

c0101fda <vector52>:
.globl vector52
vector52:
  pushl $0
c0101fda:	6a 00                	push   $0x0
  pushl $52
c0101fdc:	6a 34                	push   $0x34
  jmp __alltraps
c0101fde:	e9 11 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101fe3 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101fe3:	6a 00                	push   $0x0
  pushl $53
c0101fe5:	6a 35                	push   $0x35
  jmp __alltraps
c0101fe7:	e9 08 fe ff ff       	jmp    c0101df4 <__alltraps>

c0101fec <vector54>:
.globl vector54
vector54:
  pushl $0
c0101fec:	6a 00                	push   $0x0
  pushl $54
c0101fee:	6a 36                	push   $0x36
  jmp __alltraps
c0101ff0:	e9 ff fd ff ff       	jmp    c0101df4 <__alltraps>

c0101ff5 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101ff5:	6a 00                	push   $0x0
  pushl $55
c0101ff7:	6a 37                	push   $0x37
  jmp __alltraps
c0101ff9:	e9 f6 fd ff ff       	jmp    c0101df4 <__alltraps>

c0101ffe <vector56>:
.globl vector56
vector56:
  pushl $0
c0101ffe:	6a 00                	push   $0x0
  pushl $56
c0102000:	6a 38                	push   $0x38
  jmp __alltraps
c0102002:	e9 ed fd ff ff       	jmp    c0101df4 <__alltraps>

c0102007 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102007:	6a 00                	push   $0x0
  pushl $57
c0102009:	6a 39                	push   $0x39
  jmp __alltraps
c010200b:	e9 e4 fd ff ff       	jmp    c0101df4 <__alltraps>

c0102010 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102010:	6a 00                	push   $0x0
  pushl $58
c0102012:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102014:	e9 db fd ff ff       	jmp    c0101df4 <__alltraps>

c0102019 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102019:	6a 00                	push   $0x0
  pushl $59
c010201b:	6a 3b                	push   $0x3b
  jmp __alltraps
c010201d:	e9 d2 fd ff ff       	jmp    c0101df4 <__alltraps>

c0102022 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102022:	6a 00                	push   $0x0
  pushl $60
c0102024:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102026:	e9 c9 fd ff ff       	jmp    c0101df4 <__alltraps>

c010202b <vector61>:
.globl vector61
vector61:
  pushl $0
c010202b:	6a 00                	push   $0x0
  pushl $61
c010202d:	6a 3d                	push   $0x3d
  jmp __alltraps
c010202f:	e9 c0 fd ff ff       	jmp    c0101df4 <__alltraps>

c0102034 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102034:	6a 00                	push   $0x0
  pushl $62
c0102036:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102038:	e9 b7 fd ff ff       	jmp    c0101df4 <__alltraps>

c010203d <vector63>:
.globl vector63
vector63:
  pushl $0
c010203d:	6a 00                	push   $0x0
  pushl $63
c010203f:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102041:	e9 ae fd ff ff       	jmp    c0101df4 <__alltraps>

c0102046 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102046:	6a 00                	push   $0x0
  pushl $64
c0102048:	6a 40                	push   $0x40
  jmp __alltraps
c010204a:	e9 a5 fd ff ff       	jmp    c0101df4 <__alltraps>

c010204f <vector65>:
.globl vector65
vector65:
  pushl $0
c010204f:	6a 00                	push   $0x0
  pushl $65
c0102051:	6a 41                	push   $0x41
  jmp __alltraps
c0102053:	e9 9c fd ff ff       	jmp    c0101df4 <__alltraps>

c0102058 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102058:	6a 00                	push   $0x0
  pushl $66
c010205a:	6a 42                	push   $0x42
  jmp __alltraps
c010205c:	e9 93 fd ff ff       	jmp    c0101df4 <__alltraps>

c0102061 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102061:	6a 00                	push   $0x0
  pushl $67
c0102063:	6a 43                	push   $0x43
  jmp __alltraps
c0102065:	e9 8a fd ff ff       	jmp    c0101df4 <__alltraps>

c010206a <vector68>:
.globl vector68
vector68:
  pushl $0
c010206a:	6a 00                	push   $0x0
  pushl $68
c010206c:	6a 44                	push   $0x44
  jmp __alltraps
c010206e:	e9 81 fd ff ff       	jmp    c0101df4 <__alltraps>

c0102073 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102073:	6a 00                	push   $0x0
  pushl $69
c0102075:	6a 45                	push   $0x45
  jmp __alltraps
c0102077:	e9 78 fd ff ff       	jmp    c0101df4 <__alltraps>

c010207c <vector70>:
.globl vector70
vector70:
  pushl $0
c010207c:	6a 00                	push   $0x0
  pushl $70
c010207e:	6a 46                	push   $0x46
  jmp __alltraps
c0102080:	e9 6f fd ff ff       	jmp    c0101df4 <__alltraps>

c0102085 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102085:	6a 00                	push   $0x0
  pushl $71
c0102087:	6a 47                	push   $0x47
  jmp __alltraps
c0102089:	e9 66 fd ff ff       	jmp    c0101df4 <__alltraps>

c010208e <vector72>:
.globl vector72
vector72:
  pushl $0
c010208e:	6a 00                	push   $0x0
  pushl $72
c0102090:	6a 48                	push   $0x48
  jmp __alltraps
c0102092:	e9 5d fd ff ff       	jmp    c0101df4 <__alltraps>

c0102097 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102097:	6a 00                	push   $0x0
  pushl $73
c0102099:	6a 49                	push   $0x49
  jmp __alltraps
c010209b:	e9 54 fd ff ff       	jmp    c0101df4 <__alltraps>

c01020a0 <vector74>:
.globl vector74
vector74:
  pushl $0
c01020a0:	6a 00                	push   $0x0
  pushl $74
c01020a2:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020a4:	e9 4b fd ff ff       	jmp    c0101df4 <__alltraps>

c01020a9 <vector75>:
.globl vector75
vector75:
  pushl $0
c01020a9:	6a 00                	push   $0x0
  pushl $75
c01020ab:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020ad:	e9 42 fd ff ff       	jmp    c0101df4 <__alltraps>

c01020b2 <vector76>:
.globl vector76
vector76:
  pushl $0
c01020b2:	6a 00                	push   $0x0
  pushl $76
c01020b4:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020b6:	e9 39 fd ff ff       	jmp    c0101df4 <__alltraps>

c01020bb <vector77>:
.globl vector77
vector77:
  pushl $0
c01020bb:	6a 00                	push   $0x0
  pushl $77
c01020bd:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020bf:	e9 30 fd ff ff       	jmp    c0101df4 <__alltraps>

c01020c4 <vector78>:
.globl vector78
vector78:
  pushl $0
c01020c4:	6a 00                	push   $0x0
  pushl $78
c01020c6:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020c8:	e9 27 fd ff ff       	jmp    c0101df4 <__alltraps>

c01020cd <vector79>:
.globl vector79
vector79:
  pushl $0
c01020cd:	6a 00                	push   $0x0
  pushl $79
c01020cf:	6a 4f                	push   $0x4f
  jmp __alltraps
c01020d1:	e9 1e fd ff ff       	jmp    c0101df4 <__alltraps>

c01020d6 <vector80>:
.globl vector80
vector80:
  pushl $0
c01020d6:	6a 00                	push   $0x0
  pushl $80
c01020d8:	6a 50                	push   $0x50
  jmp __alltraps
c01020da:	e9 15 fd ff ff       	jmp    c0101df4 <__alltraps>

c01020df <vector81>:
.globl vector81
vector81:
  pushl $0
c01020df:	6a 00                	push   $0x0
  pushl $81
c01020e1:	6a 51                	push   $0x51
  jmp __alltraps
c01020e3:	e9 0c fd ff ff       	jmp    c0101df4 <__alltraps>

c01020e8 <vector82>:
.globl vector82
vector82:
  pushl $0
c01020e8:	6a 00                	push   $0x0
  pushl $82
c01020ea:	6a 52                	push   $0x52
  jmp __alltraps
c01020ec:	e9 03 fd ff ff       	jmp    c0101df4 <__alltraps>

c01020f1 <vector83>:
.globl vector83
vector83:
  pushl $0
c01020f1:	6a 00                	push   $0x0
  pushl $83
c01020f3:	6a 53                	push   $0x53
  jmp __alltraps
c01020f5:	e9 fa fc ff ff       	jmp    c0101df4 <__alltraps>

c01020fa <vector84>:
.globl vector84
vector84:
  pushl $0
c01020fa:	6a 00                	push   $0x0
  pushl $84
c01020fc:	6a 54                	push   $0x54
  jmp __alltraps
c01020fe:	e9 f1 fc ff ff       	jmp    c0101df4 <__alltraps>

c0102103 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102103:	6a 00                	push   $0x0
  pushl $85
c0102105:	6a 55                	push   $0x55
  jmp __alltraps
c0102107:	e9 e8 fc ff ff       	jmp    c0101df4 <__alltraps>

c010210c <vector86>:
.globl vector86
vector86:
  pushl $0
c010210c:	6a 00                	push   $0x0
  pushl $86
c010210e:	6a 56                	push   $0x56
  jmp __alltraps
c0102110:	e9 df fc ff ff       	jmp    c0101df4 <__alltraps>

c0102115 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102115:	6a 00                	push   $0x0
  pushl $87
c0102117:	6a 57                	push   $0x57
  jmp __alltraps
c0102119:	e9 d6 fc ff ff       	jmp    c0101df4 <__alltraps>

c010211e <vector88>:
.globl vector88
vector88:
  pushl $0
c010211e:	6a 00                	push   $0x0
  pushl $88
c0102120:	6a 58                	push   $0x58
  jmp __alltraps
c0102122:	e9 cd fc ff ff       	jmp    c0101df4 <__alltraps>

c0102127 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102127:	6a 00                	push   $0x0
  pushl $89
c0102129:	6a 59                	push   $0x59
  jmp __alltraps
c010212b:	e9 c4 fc ff ff       	jmp    c0101df4 <__alltraps>

c0102130 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102130:	6a 00                	push   $0x0
  pushl $90
c0102132:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102134:	e9 bb fc ff ff       	jmp    c0101df4 <__alltraps>

c0102139 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102139:	6a 00                	push   $0x0
  pushl $91
c010213b:	6a 5b                	push   $0x5b
  jmp __alltraps
c010213d:	e9 b2 fc ff ff       	jmp    c0101df4 <__alltraps>

c0102142 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102142:	6a 00                	push   $0x0
  pushl $92
c0102144:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102146:	e9 a9 fc ff ff       	jmp    c0101df4 <__alltraps>

c010214b <vector93>:
.globl vector93
vector93:
  pushl $0
c010214b:	6a 00                	push   $0x0
  pushl $93
c010214d:	6a 5d                	push   $0x5d
  jmp __alltraps
c010214f:	e9 a0 fc ff ff       	jmp    c0101df4 <__alltraps>

c0102154 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102154:	6a 00                	push   $0x0
  pushl $94
c0102156:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102158:	e9 97 fc ff ff       	jmp    c0101df4 <__alltraps>

c010215d <vector95>:
.globl vector95
vector95:
  pushl $0
c010215d:	6a 00                	push   $0x0
  pushl $95
c010215f:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102161:	e9 8e fc ff ff       	jmp    c0101df4 <__alltraps>

c0102166 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102166:	6a 00                	push   $0x0
  pushl $96
c0102168:	6a 60                	push   $0x60
  jmp __alltraps
c010216a:	e9 85 fc ff ff       	jmp    c0101df4 <__alltraps>

c010216f <vector97>:
.globl vector97
vector97:
  pushl $0
c010216f:	6a 00                	push   $0x0
  pushl $97
c0102171:	6a 61                	push   $0x61
  jmp __alltraps
c0102173:	e9 7c fc ff ff       	jmp    c0101df4 <__alltraps>

c0102178 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102178:	6a 00                	push   $0x0
  pushl $98
c010217a:	6a 62                	push   $0x62
  jmp __alltraps
c010217c:	e9 73 fc ff ff       	jmp    c0101df4 <__alltraps>

c0102181 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102181:	6a 00                	push   $0x0
  pushl $99
c0102183:	6a 63                	push   $0x63
  jmp __alltraps
c0102185:	e9 6a fc ff ff       	jmp    c0101df4 <__alltraps>

c010218a <vector100>:
.globl vector100
vector100:
  pushl $0
c010218a:	6a 00                	push   $0x0
  pushl $100
c010218c:	6a 64                	push   $0x64
  jmp __alltraps
c010218e:	e9 61 fc ff ff       	jmp    c0101df4 <__alltraps>

c0102193 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102193:	6a 00                	push   $0x0
  pushl $101
c0102195:	6a 65                	push   $0x65
  jmp __alltraps
c0102197:	e9 58 fc ff ff       	jmp    c0101df4 <__alltraps>

c010219c <vector102>:
.globl vector102
vector102:
  pushl $0
c010219c:	6a 00                	push   $0x0
  pushl $102
c010219e:	6a 66                	push   $0x66
  jmp __alltraps
c01021a0:	e9 4f fc ff ff       	jmp    c0101df4 <__alltraps>

c01021a5 <vector103>:
.globl vector103
vector103:
  pushl $0
c01021a5:	6a 00                	push   $0x0
  pushl $103
c01021a7:	6a 67                	push   $0x67
  jmp __alltraps
c01021a9:	e9 46 fc ff ff       	jmp    c0101df4 <__alltraps>

c01021ae <vector104>:
.globl vector104
vector104:
  pushl $0
c01021ae:	6a 00                	push   $0x0
  pushl $104
c01021b0:	6a 68                	push   $0x68
  jmp __alltraps
c01021b2:	e9 3d fc ff ff       	jmp    c0101df4 <__alltraps>

c01021b7 <vector105>:
.globl vector105
vector105:
  pushl $0
c01021b7:	6a 00                	push   $0x0
  pushl $105
c01021b9:	6a 69                	push   $0x69
  jmp __alltraps
c01021bb:	e9 34 fc ff ff       	jmp    c0101df4 <__alltraps>

c01021c0 <vector106>:
.globl vector106
vector106:
  pushl $0
c01021c0:	6a 00                	push   $0x0
  pushl $106
c01021c2:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021c4:	e9 2b fc ff ff       	jmp    c0101df4 <__alltraps>

c01021c9 <vector107>:
.globl vector107
vector107:
  pushl $0
c01021c9:	6a 00                	push   $0x0
  pushl $107
c01021cb:	6a 6b                	push   $0x6b
  jmp __alltraps
c01021cd:	e9 22 fc ff ff       	jmp    c0101df4 <__alltraps>

c01021d2 <vector108>:
.globl vector108
vector108:
  pushl $0
c01021d2:	6a 00                	push   $0x0
  pushl $108
c01021d4:	6a 6c                	push   $0x6c
  jmp __alltraps
c01021d6:	e9 19 fc ff ff       	jmp    c0101df4 <__alltraps>

c01021db <vector109>:
.globl vector109
vector109:
  pushl $0
c01021db:	6a 00                	push   $0x0
  pushl $109
c01021dd:	6a 6d                	push   $0x6d
  jmp __alltraps
c01021df:	e9 10 fc ff ff       	jmp    c0101df4 <__alltraps>

c01021e4 <vector110>:
.globl vector110
vector110:
  pushl $0
c01021e4:	6a 00                	push   $0x0
  pushl $110
c01021e6:	6a 6e                	push   $0x6e
  jmp __alltraps
c01021e8:	e9 07 fc ff ff       	jmp    c0101df4 <__alltraps>

c01021ed <vector111>:
.globl vector111
vector111:
  pushl $0
c01021ed:	6a 00                	push   $0x0
  pushl $111
c01021ef:	6a 6f                	push   $0x6f
  jmp __alltraps
c01021f1:	e9 fe fb ff ff       	jmp    c0101df4 <__alltraps>

c01021f6 <vector112>:
.globl vector112
vector112:
  pushl $0
c01021f6:	6a 00                	push   $0x0
  pushl $112
c01021f8:	6a 70                	push   $0x70
  jmp __alltraps
c01021fa:	e9 f5 fb ff ff       	jmp    c0101df4 <__alltraps>

c01021ff <vector113>:
.globl vector113
vector113:
  pushl $0
c01021ff:	6a 00                	push   $0x0
  pushl $113
c0102201:	6a 71                	push   $0x71
  jmp __alltraps
c0102203:	e9 ec fb ff ff       	jmp    c0101df4 <__alltraps>

c0102208 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102208:	6a 00                	push   $0x0
  pushl $114
c010220a:	6a 72                	push   $0x72
  jmp __alltraps
c010220c:	e9 e3 fb ff ff       	jmp    c0101df4 <__alltraps>

c0102211 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102211:	6a 00                	push   $0x0
  pushl $115
c0102213:	6a 73                	push   $0x73
  jmp __alltraps
c0102215:	e9 da fb ff ff       	jmp    c0101df4 <__alltraps>

c010221a <vector116>:
.globl vector116
vector116:
  pushl $0
c010221a:	6a 00                	push   $0x0
  pushl $116
c010221c:	6a 74                	push   $0x74
  jmp __alltraps
c010221e:	e9 d1 fb ff ff       	jmp    c0101df4 <__alltraps>

c0102223 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102223:	6a 00                	push   $0x0
  pushl $117
c0102225:	6a 75                	push   $0x75
  jmp __alltraps
c0102227:	e9 c8 fb ff ff       	jmp    c0101df4 <__alltraps>

c010222c <vector118>:
.globl vector118
vector118:
  pushl $0
c010222c:	6a 00                	push   $0x0
  pushl $118
c010222e:	6a 76                	push   $0x76
  jmp __alltraps
c0102230:	e9 bf fb ff ff       	jmp    c0101df4 <__alltraps>

c0102235 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102235:	6a 00                	push   $0x0
  pushl $119
c0102237:	6a 77                	push   $0x77
  jmp __alltraps
c0102239:	e9 b6 fb ff ff       	jmp    c0101df4 <__alltraps>

c010223e <vector120>:
.globl vector120
vector120:
  pushl $0
c010223e:	6a 00                	push   $0x0
  pushl $120
c0102240:	6a 78                	push   $0x78
  jmp __alltraps
c0102242:	e9 ad fb ff ff       	jmp    c0101df4 <__alltraps>

c0102247 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102247:	6a 00                	push   $0x0
  pushl $121
c0102249:	6a 79                	push   $0x79
  jmp __alltraps
c010224b:	e9 a4 fb ff ff       	jmp    c0101df4 <__alltraps>

c0102250 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102250:	6a 00                	push   $0x0
  pushl $122
c0102252:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102254:	e9 9b fb ff ff       	jmp    c0101df4 <__alltraps>

c0102259 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102259:	6a 00                	push   $0x0
  pushl $123
c010225b:	6a 7b                	push   $0x7b
  jmp __alltraps
c010225d:	e9 92 fb ff ff       	jmp    c0101df4 <__alltraps>

c0102262 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102262:	6a 00                	push   $0x0
  pushl $124
c0102264:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102266:	e9 89 fb ff ff       	jmp    c0101df4 <__alltraps>

c010226b <vector125>:
.globl vector125
vector125:
  pushl $0
c010226b:	6a 00                	push   $0x0
  pushl $125
c010226d:	6a 7d                	push   $0x7d
  jmp __alltraps
c010226f:	e9 80 fb ff ff       	jmp    c0101df4 <__alltraps>

c0102274 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102274:	6a 00                	push   $0x0
  pushl $126
c0102276:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102278:	e9 77 fb ff ff       	jmp    c0101df4 <__alltraps>

c010227d <vector127>:
.globl vector127
vector127:
  pushl $0
c010227d:	6a 00                	push   $0x0
  pushl $127
c010227f:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102281:	e9 6e fb ff ff       	jmp    c0101df4 <__alltraps>

c0102286 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102286:	6a 00                	push   $0x0
  pushl $128
c0102288:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010228d:	e9 62 fb ff ff       	jmp    c0101df4 <__alltraps>

c0102292 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102292:	6a 00                	push   $0x0
  pushl $129
c0102294:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102299:	e9 56 fb ff ff       	jmp    c0101df4 <__alltraps>

c010229e <vector130>:
.globl vector130
vector130:
  pushl $0
c010229e:	6a 00                	push   $0x0
  pushl $130
c01022a0:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022a5:	e9 4a fb ff ff       	jmp    c0101df4 <__alltraps>

c01022aa <vector131>:
.globl vector131
vector131:
  pushl $0
c01022aa:	6a 00                	push   $0x0
  pushl $131
c01022ac:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022b1:	e9 3e fb ff ff       	jmp    c0101df4 <__alltraps>

c01022b6 <vector132>:
.globl vector132
vector132:
  pushl $0
c01022b6:	6a 00                	push   $0x0
  pushl $132
c01022b8:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022bd:	e9 32 fb ff ff       	jmp    c0101df4 <__alltraps>

c01022c2 <vector133>:
.globl vector133
vector133:
  pushl $0
c01022c2:	6a 00                	push   $0x0
  pushl $133
c01022c4:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022c9:	e9 26 fb ff ff       	jmp    c0101df4 <__alltraps>

c01022ce <vector134>:
.globl vector134
vector134:
  pushl $0
c01022ce:	6a 00                	push   $0x0
  pushl $134
c01022d0:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01022d5:	e9 1a fb ff ff       	jmp    c0101df4 <__alltraps>

c01022da <vector135>:
.globl vector135
vector135:
  pushl $0
c01022da:	6a 00                	push   $0x0
  pushl $135
c01022dc:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01022e1:	e9 0e fb ff ff       	jmp    c0101df4 <__alltraps>

c01022e6 <vector136>:
.globl vector136
vector136:
  pushl $0
c01022e6:	6a 00                	push   $0x0
  pushl $136
c01022e8:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01022ed:	e9 02 fb ff ff       	jmp    c0101df4 <__alltraps>

c01022f2 <vector137>:
.globl vector137
vector137:
  pushl $0
c01022f2:	6a 00                	push   $0x0
  pushl $137
c01022f4:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022f9:	e9 f6 fa ff ff       	jmp    c0101df4 <__alltraps>

c01022fe <vector138>:
.globl vector138
vector138:
  pushl $0
c01022fe:	6a 00                	push   $0x0
  pushl $138
c0102300:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102305:	e9 ea fa ff ff       	jmp    c0101df4 <__alltraps>

c010230a <vector139>:
.globl vector139
vector139:
  pushl $0
c010230a:	6a 00                	push   $0x0
  pushl $139
c010230c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102311:	e9 de fa ff ff       	jmp    c0101df4 <__alltraps>

c0102316 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102316:	6a 00                	push   $0x0
  pushl $140
c0102318:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010231d:	e9 d2 fa ff ff       	jmp    c0101df4 <__alltraps>

c0102322 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102322:	6a 00                	push   $0x0
  pushl $141
c0102324:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102329:	e9 c6 fa ff ff       	jmp    c0101df4 <__alltraps>

c010232e <vector142>:
.globl vector142
vector142:
  pushl $0
c010232e:	6a 00                	push   $0x0
  pushl $142
c0102330:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102335:	e9 ba fa ff ff       	jmp    c0101df4 <__alltraps>

c010233a <vector143>:
.globl vector143
vector143:
  pushl $0
c010233a:	6a 00                	push   $0x0
  pushl $143
c010233c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102341:	e9 ae fa ff ff       	jmp    c0101df4 <__alltraps>

c0102346 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102346:	6a 00                	push   $0x0
  pushl $144
c0102348:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010234d:	e9 a2 fa ff ff       	jmp    c0101df4 <__alltraps>

c0102352 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102352:	6a 00                	push   $0x0
  pushl $145
c0102354:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102359:	e9 96 fa ff ff       	jmp    c0101df4 <__alltraps>

c010235e <vector146>:
.globl vector146
vector146:
  pushl $0
c010235e:	6a 00                	push   $0x0
  pushl $146
c0102360:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102365:	e9 8a fa ff ff       	jmp    c0101df4 <__alltraps>

c010236a <vector147>:
.globl vector147
vector147:
  pushl $0
c010236a:	6a 00                	push   $0x0
  pushl $147
c010236c:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102371:	e9 7e fa ff ff       	jmp    c0101df4 <__alltraps>

c0102376 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102376:	6a 00                	push   $0x0
  pushl $148
c0102378:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010237d:	e9 72 fa ff ff       	jmp    c0101df4 <__alltraps>

c0102382 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102382:	6a 00                	push   $0x0
  pushl $149
c0102384:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102389:	e9 66 fa ff ff       	jmp    c0101df4 <__alltraps>

c010238e <vector150>:
.globl vector150
vector150:
  pushl $0
c010238e:	6a 00                	push   $0x0
  pushl $150
c0102390:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102395:	e9 5a fa ff ff       	jmp    c0101df4 <__alltraps>

c010239a <vector151>:
.globl vector151
vector151:
  pushl $0
c010239a:	6a 00                	push   $0x0
  pushl $151
c010239c:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023a1:	e9 4e fa ff ff       	jmp    c0101df4 <__alltraps>

c01023a6 <vector152>:
.globl vector152
vector152:
  pushl $0
c01023a6:	6a 00                	push   $0x0
  pushl $152
c01023a8:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023ad:	e9 42 fa ff ff       	jmp    c0101df4 <__alltraps>

c01023b2 <vector153>:
.globl vector153
vector153:
  pushl $0
c01023b2:	6a 00                	push   $0x0
  pushl $153
c01023b4:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023b9:	e9 36 fa ff ff       	jmp    c0101df4 <__alltraps>

c01023be <vector154>:
.globl vector154
vector154:
  pushl $0
c01023be:	6a 00                	push   $0x0
  pushl $154
c01023c0:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023c5:	e9 2a fa ff ff       	jmp    c0101df4 <__alltraps>

c01023ca <vector155>:
.globl vector155
vector155:
  pushl $0
c01023ca:	6a 00                	push   $0x0
  pushl $155
c01023cc:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01023d1:	e9 1e fa ff ff       	jmp    c0101df4 <__alltraps>

c01023d6 <vector156>:
.globl vector156
vector156:
  pushl $0
c01023d6:	6a 00                	push   $0x0
  pushl $156
c01023d8:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01023dd:	e9 12 fa ff ff       	jmp    c0101df4 <__alltraps>

c01023e2 <vector157>:
.globl vector157
vector157:
  pushl $0
c01023e2:	6a 00                	push   $0x0
  pushl $157
c01023e4:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01023e9:	e9 06 fa ff ff       	jmp    c0101df4 <__alltraps>

c01023ee <vector158>:
.globl vector158
vector158:
  pushl $0
c01023ee:	6a 00                	push   $0x0
  pushl $158
c01023f0:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023f5:	e9 fa f9 ff ff       	jmp    c0101df4 <__alltraps>

c01023fa <vector159>:
.globl vector159
vector159:
  pushl $0
c01023fa:	6a 00                	push   $0x0
  pushl $159
c01023fc:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102401:	e9 ee f9 ff ff       	jmp    c0101df4 <__alltraps>

c0102406 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102406:	6a 00                	push   $0x0
  pushl $160
c0102408:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010240d:	e9 e2 f9 ff ff       	jmp    c0101df4 <__alltraps>

c0102412 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102412:	6a 00                	push   $0x0
  pushl $161
c0102414:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102419:	e9 d6 f9 ff ff       	jmp    c0101df4 <__alltraps>

c010241e <vector162>:
.globl vector162
vector162:
  pushl $0
c010241e:	6a 00                	push   $0x0
  pushl $162
c0102420:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102425:	e9 ca f9 ff ff       	jmp    c0101df4 <__alltraps>

c010242a <vector163>:
.globl vector163
vector163:
  pushl $0
c010242a:	6a 00                	push   $0x0
  pushl $163
c010242c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102431:	e9 be f9 ff ff       	jmp    c0101df4 <__alltraps>

c0102436 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102436:	6a 00                	push   $0x0
  pushl $164
c0102438:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010243d:	e9 b2 f9 ff ff       	jmp    c0101df4 <__alltraps>

c0102442 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102442:	6a 00                	push   $0x0
  pushl $165
c0102444:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102449:	e9 a6 f9 ff ff       	jmp    c0101df4 <__alltraps>

c010244e <vector166>:
.globl vector166
vector166:
  pushl $0
c010244e:	6a 00                	push   $0x0
  pushl $166
c0102450:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102455:	e9 9a f9 ff ff       	jmp    c0101df4 <__alltraps>

c010245a <vector167>:
.globl vector167
vector167:
  pushl $0
c010245a:	6a 00                	push   $0x0
  pushl $167
c010245c:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102461:	e9 8e f9 ff ff       	jmp    c0101df4 <__alltraps>

c0102466 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102466:	6a 00                	push   $0x0
  pushl $168
c0102468:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010246d:	e9 82 f9 ff ff       	jmp    c0101df4 <__alltraps>

c0102472 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102472:	6a 00                	push   $0x0
  pushl $169
c0102474:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102479:	e9 76 f9 ff ff       	jmp    c0101df4 <__alltraps>

c010247e <vector170>:
.globl vector170
vector170:
  pushl $0
c010247e:	6a 00                	push   $0x0
  pushl $170
c0102480:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102485:	e9 6a f9 ff ff       	jmp    c0101df4 <__alltraps>

c010248a <vector171>:
.globl vector171
vector171:
  pushl $0
c010248a:	6a 00                	push   $0x0
  pushl $171
c010248c:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102491:	e9 5e f9 ff ff       	jmp    c0101df4 <__alltraps>

c0102496 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102496:	6a 00                	push   $0x0
  pushl $172
c0102498:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010249d:	e9 52 f9 ff ff       	jmp    c0101df4 <__alltraps>

c01024a2 <vector173>:
.globl vector173
vector173:
  pushl $0
c01024a2:	6a 00                	push   $0x0
  pushl $173
c01024a4:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024a9:	e9 46 f9 ff ff       	jmp    c0101df4 <__alltraps>

c01024ae <vector174>:
.globl vector174
vector174:
  pushl $0
c01024ae:	6a 00                	push   $0x0
  pushl $174
c01024b0:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024b5:	e9 3a f9 ff ff       	jmp    c0101df4 <__alltraps>

c01024ba <vector175>:
.globl vector175
vector175:
  pushl $0
c01024ba:	6a 00                	push   $0x0
  pushl $175
c01024bc:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024c1:	e9 2e f9 ff ff       	jmp    c0101df4 <__alltraps>

c01024c6 <vector176>:
.globl vector176
vector176:
  pushl $0
c01024c6:	6a 00                	push   $0x0
  pushl $176
c01024c8:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01024cd:	e9 22 f9 ff ff       	jmp    c0101df4 <__alltraps>

c01024d2 <vector177>:
.globl vector177
vector177:
  pushl $0
c01024d2:	6a 00                	push   $0x0
  pushl $177
c01024d4:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01024d9:	e9 16 f9 ff ff       	jmp    c0101df4 <__alltraps>

c01024de <vector178>:
.globl vector178
vector178:
  pushl $0
c01024de:	6a 00                	push   $0x0
  pushl $178
c01024e0:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01024e5:	e9 0a f9 ff ff       	jmp    c0101df4 <__alltraps>

c01024ea <vector179>:
.globl vector179
vector179:
  pushl $0
c01024ea:	6a 00                	push   $0x0
  pushl $179
c01024ec:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01024f1:	e9 fe f8 ff ff       	jmp    c0101df4 <__alltraps>

c01024f6 <vector180>:
.globl vector180
vector180:
  pushl $0
c01024f6:	6a 00                	push   $0x0
  pushl $180
c01024f8:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024fd:	e9 f2 f8 ff ff       	jmp    c0101df4 <__alltraps>

c0102502 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102502:	6a 00                	push   $0x0
  pushl $181
c0102504:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102509:	e9 e6 f8 ff ff       	jmp    c0101df4 <__alltraps>

c010250e <vector182>:
.globl vector182
vector182:
  pushl $0
c010250e:	6a 00                	push   $0x0
  pushl $182
c0102510:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102515:	e9 da f8 ff ff       	jmp    c0101df4 <__alltraps>

c010251a <vector183>:
.globl vector183
vector183:
  pushl $0
c010251a:	6a 00                	push   $0x0
  pushl $183
c010251c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102521:	e9 ce f8 ff ff       	jmp    c0101df4 <__alltraps>

c0102526 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102526:	6a 00                	push   $0x0
  pushl $184
c0102528:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010252d:	e9 c2 f8 ff ff       	jmp    c0101df4 <__alltraps>

c0102532 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102532:	6a 00                	push   $0x0
  pushl $185
c0102534:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102539:	e9 b6 f8 ff ff       	jmp    c0101df4 <__alltraps>

c010253e <vector186>:
.globl vector186
vector186:
  pushl $0
c010253e:	6a 00                	push   $0x0
  pushl $186
c0102540:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102545:	e9 aa f8 ff ff       	jmp    c0101df4 <__alltraps>

c010254a <vector187>:
.globl vector187
vector187:
  pushl $0
c010254a:	6a 00                	push   $0x0
  pushl $187
c010254c:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102551:	e9 9e f8 ff ff       	jmp    c0101df4 <__alltraps>

c0102556 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102556:	6a 00                	push   $0x0
  pushl $188
c0102558:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010255d:	e9 92 f8 ff ff       	jmp    c0101df4 <__alltraps>

c0102562 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102562:	6a 00                	push   $0x0
  pushl $189
c0102564:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102569:	e9 86 f8 ff ff       	jmp    c0101df4 <__alltraps>

c010256e <vector190>:
.globl vector190
vector190:
  pushl $0
c010256e:	6a 00                	push   $0x0
  pushl $190
c0102570:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102575:	e9 7a f8 ff ff       	jmp    c0101df4 <__alltraps>

c010257a <vector191>:
.globl vector191
vector191:
  pushl $0
c010257a:	6a 00                	push   $0x0
  pushl $191
c010257c:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102581:	e9 6e f8 ff ff       	jmp    c0101df4 <__alltraps>

c0102586 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102586:	6a 00                	push   $0x0
  pushl $192
c0102588:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010258d:	e9 62 f8 ff ff       	jmp    c0101df4 <__alltraps>

c0102592 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102592:	6a 00                	push   $0x0
  pushl $193
c0102594:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102599:	e9 56 f8 ff ff       	jmp    c0101df4 <__alltraps>

c010259e <vector194>:
.globl vector194
vector194:
  pushl $0
c010259e:	6a 00                	push   $0x0
  pushl $194
c01025a0:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025a5:	e9 4a f8 ff ff       	jmp    c0101df4 <__alltraps>

c01025aa <vector195>:
.globl vector195
vector195:
  pushl $0
c01025aa:	6a 00                	push   $0x0
  pushl $195
c01025ac:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025b1:	e9 3e f8 ff ff       	jmp    c0101df4 <__alltraps>

c01025b6 <vector196>:
.globl vector196
vector196:
  pushl $0
c01025b6:	6a 00                	push   $0x0
  pushl $196
c01025b8:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025bd:	e9 32 f8 ff ff       	jmp    c0101df4 <__alltraps>

c01025c2 <vector197>:
.globl vector197
vector197:
  pushl $0
c01025c2:	6a 00                	push   $0x0
  pushl $197
c01025c4:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025c9:	e9 26 f8 ff ff       	jmp    c0101df4 <__alltraps>

c01025ce <vector198>:
.globl vector198
vector198:
  pushl $0
c01025ce:	6a 00                	push   $0x0
  pushl $198
c01025d0:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01025d5:	e9 1a f8 ff ff       	jmp    c0101df4 <__alltraps>

c01025da <vector199>:
.globl vector199
vector199:
  pushl $0
c01025da:	6a 00                	push   $0x0
  pushl $199
c01025dc:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01025e1:	e9 0e f8 ff ff       	jmp    c0101df4 <__alltraps>

c01025e6 <vector200>:
.globl vector200
vector200:
  pushl $0
c01025e6:	6a 00                	push   $0x0
  pushl $200
c01025e8:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01025ed:	e9 02 f8 ff ff       	jmp    c0101df4 <__alltraps>

c01025f2 <vector201>:
.globl vector201
vector201:
  pushl $0
c01025f2:	6a 00                	push   $0x0
  pushl $201
c01025f4:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025f9:	e9 f6 f7 ff ff       	jmp    c0101df4 <__alltraps>

c01025fe <vector202>:
.globl vector202
vector202:
  pushl $0
c01025fe:	6a 00                	push   $0x0
  pushl $202
c0102600:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102605:	e9 ea f7 ff ff       	jmp    c0101df4 <__alltraps>

c010260a <vector203>:
.globl vector203
vector203:
  pushl $0
c010260a:	6a 00                	push   $0x0
  pushl $203
c010260c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102611:	e9 de f7 ff ff       	jmp    c0101df4 <__alltraps>

c0102616 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102616:	6a 00                	push   $0x0
  pushl $204
c0102618:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010261d:	e9 d2 f7 ff ff       	jmp    c0101df4 <__alltraps>

c0102622 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102622:	6a 00                	push   $0x0
  pushl $205
c0102624:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102629:	e9 c6 f7 ff ff       	jmp    c0101df4 <__alltraps>

c010262e <vector206>:
.globl vector206
vector206:
  pushl $0
c010262e:	6a 00                	push   $0x0
  pushl $206
c0102630:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102635:	e9 ba f7 ff ff       	jmp    c0101df4 <__alltraps>

c010263a <vector207>:
.globl vector207
vector207:
  pushl $0
c010263a:	6a 00                	push   $0x0
  pushl $207
c010263c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102641:	e9 ae f7 ff ff       	jmp    c0101df4 <__alltraps>

c0102646 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102646:	6a 00                	push   $0x0
  pushl $208
c0102648:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010264d:	e9 a2 f7 ff ff       	jmp    c0101df4 <__alltraps>

c0102652 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102652:	6a 00                	push   $0x0
  pushl $209
c0102654:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102659:	e9 96 f7 ff ff       	jmp    c0101df4 <__alltraps>

c010265e <vector210>:
.globl vector210
vector210:
  pushl $0
c010265e:	6a 00                	push   $0x0
  pushl $210
c0102660:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102665:	e9 8a f7 ff ff       	jmp    c0101df4 <__alltraps>

c010266a <vector211>:
.globl vector211
vector211:
  pushl $0
c010266a:	6a 00                	push   $0x0
  pushl $211
c010266c:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102671:	e9 7e f7 ff ff       	jmp    c0101df4 <__alltraps>

c0102676 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102676:	6a 00                	push   $0x0
  pushl $212
c0102678:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010267d:	e9 72 f7 ff ff       	jmp    c0101df4 <__alltraps>

c0102682 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102682:	6a 00                	push   $0x0
  pushl $213
c0102684:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102689:	e9 66 f7 ff ff       	jmp    c0101df4 <__alltraps>

c010268e <vector214>:
.globl vector214
vector214:
  pushl $0
c010268e:	6a 00                	push   $0x0
  pushl $214
c0102690:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102695:	e9 5a f7 ff ff       	jmp    c0101df4 <__alltraps>

c010269a <vector215>:
.globl vector215
vector215:
  pushl $0
c010269a:	6a 00                	push   $0x0
  pushl $215
c010269c:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026a1:	e9 4e f7 ff ff       	jmp    c0101df4 <__alltraps>

c01026a6 <vector216>:
.globl vector216
vector216:
  pushl $0
c01026a6:	6a 00                	push   $0x0
  pushl $216
c01026a8:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026ad:	e9 42 f7 ff ff       	jmp    c0101df4 <__alltraps>

c01026b2 <vector217>:
.globl vector217
vector217:
  pushl $0
c01026b2:	6a 00                	push   $0x0
  pushl $217
c01026b4:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026b9:	e9 36 f7 ff ff       	jmp    c0101df4 <__alltraps>

c01026be <vector218>:
.globl vector218
vector218:
  pushl $0
c01026be:	6a 00                	push   $0x0
  pushl $218
c01026c0:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026c5:	e9 2a f7 ff ff       	jmp    c0101df4 <__alltraps>

c01026ca <vector219>:
.globl vector219
vector219:
  pushl $0
c01026ca:	6a 00                	push   $0x0
  pushl $219
c01026cc:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01026d1:	e9 1e f7 ff ff       	jmp    c0101df4 <__alltraps>

c01026d6 <vector220>:
.globl vector220
vector220:
  pushl $0
c01026d6:	6a 00                	push   $0x0
  pushl $220
c01026d8:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01026dd:	e9 12 f7 ff ff       	jmp    c0101df4 <__alltraps>

c01026e2 <vector221>:
.globl vector221
vector221:
  pushl $0
c01026e2:	6a 00                	push   $0x0
  pushl $221
c01026e4:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01026e9:	e9 06 f7 ff ff       	jmp    c0101df4 <__alltraps>

c01026ee <vector222>:
.globl vector222
vector222:
  pushl $0
c01026ee:	6a 00                	push   $0x0
  pushl $222
c01026f0:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026f5:	e9 fa f6 ff ff       	jmp    c0101df4 <__alltraps>

c01026fa <vector223>:
.globl vector223
vector223:
  pushl $0
c01026fa:	6a 00                	push   $0x0
  pushl $223
c01026fc:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102701:	e9 ee f6 ff ff       	jmp    c0101df4 <__alltraps>

c0102706 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102706:	6a 00                	push   $0x0
  pushl $224
c0102708:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010270d:	e9 e2 f6 ff ff       	jmp    c0101df4 <__alltraps>

c0102712 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102712:	6a 00                	push   $0x0
  pushl $225
c0102714:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102719:	e9 d6 f6 ff ff       	jmp    c0101df4 <__alltraps>

c010271e <vector226>:
.globl vector226
vector226:
  pushl $0
c010271e:	6a 00                	push   $0x0
  pushl $226
c0102720:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102725:	e9 ca f6 ff ff       	jmp    c0101df4 <__alltraps>

c010272a <vector227>:
.globl vector227
vector227:
  pushl $0
c010272a:	6a 00                	push   $0x0
  pushl $227
c010272c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102731:	e9 be f6 ff ff       	jmp    c0101df4 <__alltraps>

c0102736 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102736:	6a 00                	push   $0x0
  pushl $228
c0102738:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010273d:	e9 b2 f6 ff ff       	jmp    c0101df4 <__alltraps>

c0102742 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102742:	6a 00                	push   $0x0
  pushl $229
c0102744:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102749:	e9 a6 f6 ff ff       	jmp    c0101df4 <__alltraps>

c010274e <vector230>:
.globl vector230
vector230:
  pushl $0
c010274e:	6a 00                	push   $0x0
  pushl $230
c0102750:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102755:	e9 9a f6 ff ff       	jmp    c0101df4 <__alltraps>

c010275a <vector231>:
.globl vector231
vector231:
  pushl $0
c010275a:	6a 00                	push   $0x0
  pushl $231
c010275c:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102761:	e9 8e f6 ff ff       	jmp    c0101df4 <__alltraps>

c0102766 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102766:	6a 00                	push   $0x0
  pushl $232
c0102768:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010276d:	e9 82 f6 ff ff       	jmp    c0101df4 <__alltraps>

c0102772 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102772:	6a 00                	push   $0x0
  pushl $233
c0102774:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102779:	e9 76 f6 ff ff       	jmp    c0101df4 <__alltraps>

c010277e <vector234>:
.globl vector234
vector234:
  pushl $0
c010277e:	6a 00                	push   $0x0
  pushl $234
c0102780:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102785:	e9 6a f6 ff ff       	jmp    c0101df4 <__alltraps>

c010278a <vector235>:
.globl vector235
vector235:
  pushl $0
c010278a:	6a 00                	push   $0x0
  pushl $235
c010278c:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102791:	e9 5e f6 ff ff       	jmp    c0101df4 <__alltraps>

c0102796 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102796:	6a 00                	push   $0x0
  pushl $236
c0102798:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010279d:	e9 52 f6 ff ff       	jmp    c0101df4 <__alltraps>

c01027a2 <vector237>:
.globl vector237
vector237:
  pushl $0
c01027a2:	6a 00                	push   $0x0
  pushl $237
c01027a4:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027a9:	e9 46 f6 ff ff       	jmp    c0101df4 <__alltraps>

c01027ae <vector238>:
.globl vector238
vector238:
  pushl $0
c01027ae:	6a 00                	push   $0x0
  pushl $238
c01027b0:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027b5:	e9 3a f6 ff ff       	jmp    c0101df4 <__alltraps>

c01027ba <vector239>:
.globl vector239
vector239:
  pushl $0
c01027ba:	6a 00                	push   $0x0
  pushl $239
c01027bc:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027c1:	e9 2e f6 ff ff       	jmp    c0101df4 <__alltraps>

c01027c6 <vector240>:
.globl vector240
vector240:
  pushl $0
c01027c6:	6a 00                	push   $0x0
  pushl $240
c01027c8:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01027cd:	e9 22 f6 ff ff       	jmp    c0101df4 <__alltraps>

c01027d2 <vector241>:
.globl vector241
vector241:
  pushl $0
c01027d2:	6a 00                	push   $0x0
  pushl $241
c01027d4:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01027d9:	e9 16 f6 ff ff       	jmp    c0101df4 <__alltraps>

c01027de <vector242>:
.globl vector242
vector242:
  pushl $0
c01027de:	6a 00                	push   $0x0
  pushl $242
c01027e0:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01027e5:	e9 0a f6 ff ff       	jmp    c0101df4 <__alltraps>

c01027ea <vector243>:
.globl vector243
vector243:
  pushl $0
c01027ea:	6a 00                	push   $0x0
  pushl $243
c01027ec:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01027f1:	e9 fe f5 ff ff       	jmp    c0101df4 <__alltraps>

c01027f6 <vector244>:
.globl vector244
vector244:
  pushl $0
c01027f6:	6a 00                	push   $0x0
  pushl $244
c01027f8:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027fd:	e9 f2 f5 ff ff       	jmp    c0101df4 <__alltraps>

c0102802 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102802:	6a 00                	push   $0x0
  pushl $245
c0102804:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102809:	e9 e6 f5 ff ff       	jmp    c0101df4 <__alltraps>

c010280e <vector246>:
.globl vector246
vector246:
  pushl $0
c010280e:	6a 00                	push   $0x0
  pushl $246
c0102810:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102815:	e9 da f5 ff ff       	jmp    c0101df4 <__alltraps>

c010281a <vector247>:
.globl vector247
vector247:
  pushl $0
c010281a:	6a 00                	push   $0x0
  pushl $247
c010281c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102821:	e9 ce f5 ff ff       	jmp    c0101df4 <__alltraps>

c0102826 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $248
c0102828:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010282d:	e9 c2 f5 ff ff       	jmp    c0101df4 <__alltraps>

c0102832 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102832:	6a 00                	push   $0x0
  pushl $249
c0102834:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102839:	e9 b6 f5 ff ff       	jmp    c0101df4 <__alltraps>

c010283e <vector250>:
.globl vector250
vector250:
  pushl $0
c010283e:	6a 00                	push   $0x0
  pushl $250
c0102840:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102845:	e9 aa f5 ff ff       	jmp    c0101df4 <__alltraps>

c010284a <vector251>:
.globl vector251
vector251:
  pushl $0
c010284a:	6a 00                	push   $0x0
  pushl $251
c010284c:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102851:	e9 9e f5 ff ff       	jmp    c0101df4 <__alltraps>

c0102856 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102856:	6a 00                	push   $0x0
  pushl $252
c0102858:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010285d:	e9 92 f5 ff ff       	jmp    c0101df4 <__alltraps>

c0102862 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102862:	6a 00                	push   $0x0
  pushl $253
c0102864:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102869:	e9 86 f5 ff ff       	jmp    c0101df4 <__alltraps>

c010286e <vector254>:
.globl vector254
vector254:
  pushl $0
c010286e:	6a 00                	push   $0x0
  pushl $254
c0102870:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102875:	e9 7a f5 ff ff       	jmp    c0101df4 <__alltraps>

c010287a <vector255>:
.globl vector255
vector255:
  pushl $0
c010287a:	6a 00                	push   $0x0
  pushl $255
c010287c:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102881:	e9 6e f5 ff ff       	jmp    c0101df4 <__alltraps>

c0102886 <list_next>:
/* *
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
c0102886:	55                   	push   %ebp
c0102887:	89 e5                	mov    %esp,%ebp
    return listelm->next;
c0102889:	8b 45 08             	mov    0x8(%ebp),%eax
c010288c:	8b 40 04             	mov    0x4(%eax),%eax
}
c010288f:	5d                   	pop    %ebp
c0102890:	c3                   	ret    

c0102891 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102891:	55                   	push   %ebp
c0102892:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102894:	8b 55 08             	mov    0x8(%ebp),%edx
c0102897:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010289c:	29 c2                	sub    %eax,%edx
c010289e:	89 d0                	mov    %edx,%eax
c01028a0:	c1 f8 02             	sar    $0x2,%eax
c01028a3:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028a9:	5d                   	pop    %ebp
c01028aa:	c3                   	ret    

c01028ab <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028ab:	55                   	push   %ebp
c01028ac:	89 e5                	mov    %esp,%ebp
c01028ae:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01028b4:	89 04 24             	mov    %eax,(%esp)
c01028b7:	e8 d5 ff ff ff       	call   c0102891 <page2ppn>
c01028bc:	c1 e0 0c             	shl    $0xc,%eax
}
c01028bf:	c9                   	leave  
c01028c0:	c3                   	ret    

c01028c1 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01028c1:	55                   	push   %ebp
c01028c2:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01028c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01028c7:	8b 00                	mov    (%eax),%eax
}
c01028c9:	5d                   	pop    %ebp
c01028ca:	c3                   	ret    

c01028cb <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01028cb:	55                   	push   %ebp
c01028cc:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01028ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01028d1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01028d4:	89 10                	mov    %edx,(%eax)
}
c01028d6:	5d                   	pop    %ebp
c01028d7:	c3                   	ret    

c01028d8 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01028d8:	55                   	push   %ebp
c01028d9:	89 e5                	mov    %esp,%ebp
c01028db:	83 ec 10             	sub    $0x10,%esp
c01028de:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01028e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01028eb:	89 50 04             	mov    %edx,0x4(%eax)
c01028ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028f1:	8b 50 04             	mov    0x4(%eax),%edx
c01028f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028f7:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01028f9:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102900:	00 00 00 
}
c0102903:	c9                   	leave  
c0102904:	c3                   	ret    

c0102905 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102905:	55                   	push   %ebp
c0102906:	89 e5                	mov    %esp,%ebp
c0102908:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c010290b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010290f:	75 24                	jne    c0102935 <default_init_memmap+0x30>
c0102911:	c7 44 24 0c d0 64 10 	movl   $0xc01064d0,0xc(%esp)
c0102918:	c0 
c0102919:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0102920:	c0 
c0102921:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0102928:	00 
c0102929:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0102930:	e8 91 e3 ff ff       	call   c0100cc6 <__panic>
    struct Page *p = base;
c0102935:	8b 45 08             	mov    0x8(%ebp),%eax
c0102938:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010293b:	e9 de 00 00 00       	jmp    c0102a1e <default_init_memmap+0x119>
        assert(PageReserved(p));
c0102940:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102943:	83 c0 04             	add    $0x4,%eax
c0102946:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010294d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102950:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102953:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102956:	0f a3 10             	bt     %edx,(%eax)
c0102959:	19 c0                	sbb    %eax,%eax
c010295b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010295e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102962:	0f 95 c0             	setne  %al
c0102965:	0f b6 c0             	movzbl %al,%eax
c0102968:	85 c0                	test   %eax,%eax
c010296a:	75 24                	jne    c0102990 <default_init_memmap+0x8b>
c010296c:	c7 44 24 0c 01 65 10 	movl   $0xc0106501,0xc(%esp)
c0102973:	c0 
c0102974:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c010297b:	c0 
c010297c:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0102983:	00 
c0102984:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c010298b:	e8 36 e3 ff ff       	call   c0100cc6 <__panic>
        p->flags = p->property = 0;
c0102990:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102993:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010299d:	8b 50 08             	mov    0x8(%eax),%edx
c01029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029a3:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01029a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029ad:	00 
c01029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029b1:	89 04 24             	mov    %eax,(%esp)
c01029b4:	e8 12 ff ff ff       	call   c01028cb <set_page_ref>
        SetPageProperty(p);
c01029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029bc:	83 c0 04             	add    $0x4,%eax
c01029bf:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01029c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01029cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029cf:	0f ab 10             	bts    %edx,(%eax)
        list_add_before(&free_list, &(base->page_link));
c01029d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01029d5:	83 c0 0c             	add    $0xc,%eax
c01029d8:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c01029df:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01029e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029e5:	8b 00                	mov    (%eax),%eax
c01029e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01029ea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01029ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01029f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01029f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01029fc:	89 10                	mov    %edx,(%eax)
c01029fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a01:	8b 10                	mov    (%eax),%edx
c0102a03:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a06:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a0c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a0f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a15:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a18:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102a1a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a21:	89 d0                	mov    %edx,%eax
c0102a23:	c1 e0 02             	shl    $0x2,%eax
c0102a26:	01 d0                	add    %edx,%eax
c0102a28:	c1 e0 02             	shl    $0x2,%eax
c0102a2b:	89 c2                	mov    %eax,%edx
c0102a2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a30:	01 d0                	add    %edx,%eax
c0102a32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a35:	0f 85 05 ff ff ff    	jne    c0102940 <default_init_memmap+0x3b>
        p->flags = p->property = 0;
        set_page_ref(p, 0);
        SetPageProperty(p);
        list_add_before(&free_list, &(base->page_link));
    }
    base->property = n;
c0102a3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a41:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0102a44:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a4d:	01 d0                	add    %edx,%eax
c0102a4f:	a3 58 89 11 c0       	mov    %eax,0xc0118958
}
c0102a54:	c9                   	leave  
c0102a55:	c3                   	ret    

c0102a56 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a56:	55                   	push   %ebp
c0102a57:	89 e5                	mov    %esp,%ebp
c0102a59:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102a5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a60:	75 24                	jne    c0102a86 <default_alloc_pages+0x30>
c0102a62:	c7 44 24 0c d0 64 10 	movl   $0xc01064d0,0xc(%esp)
c0102a69:	c0 
c0102a6a:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0102a71:	c0 
c0102a72:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0102a79:	00 
c0102a7a:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0102a81:	e8 40 e2 ff ff       	call   c0100cc6 <__panic>
    if (n > nr_free) {
c0102a86:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102a8b:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a8e:	73 0a                	jae    c0102a9a <default_alloc_pages+0x44>
        return NULL;
c0102a90:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a95:	e9 25 01 00 00       	jmp    c0102bbf <default_alloc_pages+0x169>
    }
    struct Page *page = NULL;
c0102a9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102aa1:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102aa8:	e9 ad 00 00 00       	jmp    c0102b5a <default_alloc_pages+0x104>
        struct Page *p = le2page(le, page_link);
c0102aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ab0:	83 e8 0c             	sub    $0xc,%eax
c0102ab3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n) {
c0102ab6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ab9:	8b 40 08             	mov    0x8(%eax),%eax
c0102abc:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102abf:	0f 82 95 00 00 00    	jb     c0102b5a <default_alloc_pages+0x104>
            page = p;
c0102ac5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)

            struct Page *pp = NULL;
c0102acb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            list_entry_t *temp_le = &free_list;
c0102ad2:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
            // 分配页数
            int i;
            for (i = 0; i < n; i++) {
c0102ad9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0102ae0:	eb 6e                	jmp    c0102b50 <default_alloc_pages+0xfa>
            	// 每一页的标志位改写
            	// 被内核所保留
            	SetPageReserved(pp);
c0102ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ae5:	83 c0 04             	add    $0x4,%eax
c0102ae8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c0102aef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102af2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102af5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102af8:	0f ab 10             	bts    %edx,(%eax)
            	// 不是头页
            	ClearPageProperty(pp);
c0102afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102afe:	83 c0 04             	add    $0x4,%eax
c0102b01:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102b08:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b0e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b11:	0f b3 10             	btr    %edx,(%eax)
c0102b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b17:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b1a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b1d:	8b 40 04             	mov    0x4(%eax),%eax
c0102b20:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b23:	8b 12                	mov    (%edx),%edx
c0102b25:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102b28:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b2b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b2e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b31:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b34:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b37:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b3a:	89 10                	mov    %edx,(%eax)
c0102b3c:	c7 45 bc 86 28 10 c0 	movl   $0xc0102886,-0x44(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b43:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b46:	8b 40 04             	mov    0x4(%eax),%eax
            	// 既然分配好了，下一步就将其从freelist中删除
            	list_del(temp_le);
            	temp_le = list_next(list_next);
c0102b49:	89 45 ec             	mov    %eax,-0x14(%ebp)

            struct Page *pp = NULL;
            list_entry_t *temp_le = &free_list;
            // 分配页数
            int i;
            for (i = 0; i < n; i++) {
c0102b4c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0102b50:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b53:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b56:	72 8a                	jb     c0102ae2 <default_alloc_pages+0x8c>
            	ClearPageProperty(pp);
            	// 既然分配好了，下一步就将其从freelist中删除
            	list_del(temp_le);
            	temp_le = list_next(list_next);
            }
            break;
c0102b58:	eb 1c                	jmp    c0102b76 <default_alloc_pages+0x120>
c0102b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b5d:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b63:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b69:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102b70:	0f 85 37 ff ff ff    	jne    c0102aad <default_alloc_pages+0x57>
            }
            break;
        }
    }
    // 对头页的标志位进行修改
    if (page != NULL) {
c0102b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102b7a:	74 40                	je     c0102bbc <default_alloc_pages+0x166>
        if (page->property > n) {
c0102b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b7f:	8b 40 08             	mov    0x8(%eax),%eax
c0102b82:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b85:	76 28                	jbe    c0102baf <default_alloc_pages+0x159>
        	// p指针移动到顶部（这里好象是反着的，其实到了头页）
        	// 修改头页的标志位，可参考高书8.3.2
            struct Page *p = page + n;
c0102b87:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b8a:	89 d0                	mov    %edx,%eax
c0102b8c:	c1 e0 02             	shl    $0x2,%eax
c0102b8f:	01 d0                	add    %edx,%eax
c0102b91:	c1 e0 02             	shl    $0x2,%eax
c0102b94:	89 c2                	mov    %eax,%edx
c0102b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b99:	01 d0                	add    %edx,%eax
c0102b9b:	89 45 dc             	mov    %eax,-0x24(%ebp)
            p->property = page->property - n;
c0102b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ba1:	8b 40 08             	mov    0x8(%eax),%eax
c0102ba4:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ba7:	89 c2                	mov    %eax,%edx
c0102ba9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bac:	89 50 08             	mov    %edx,0x8(%eax)
    }
        nr_free -= n;
c0102baf:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102bb4:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bb7:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    }
    return page;
c0102bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102bbf:	c9                   	leave  
c0102bc0:	c3                   	ret    

c0102bc1 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102bc1:	55                   	push   %ebp
c0102bc2:	89 e5                	mov    %esp,%ebp
c0102bc4:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102bc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102bcb:	75 24                	jne    c0102bf1 <default_free_pages+0x30>
c0102bcd:	c7 44 24 0c d0 64 10 	movl   $0xc01064d0,0xc(%esp)
c0102bd4:	c0 
c0102bd5:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0102bdc:	c0 
c0102bdd:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
c0102be4:	00 
c0102be5:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0102bec:	e8 d5 e0 ff ff       	call   c0100cc6 <__panic>
    // 断言是被内核保留页
    // 这里我不明白为什么申请和释放都标记为“内核保留”？？？
    assert(PageReserved(base));
c0102bf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bf4:	83 c0 04             	add    $0x4,%eax
c0102bf7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102bfe:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c04:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c07:	0f a3 10             	bt     %edx,(%eax)
c0102c0a:	19 c0                	sbb    %eax,%eax
c0102c0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102c0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c13:	0f 95 c0             	setne  %al
c0102c16:	0f b6 c0             	movzbl %al,%eax
c0102c19:	85 c0                	test   %eax,%eax
c0102c1b:	75 24                	jne    c0102c41 <default_free_pages+0x80>
c0102c1d:	c7 44 24 0c 11 65 10 	movl   $0xc0106511,0xc(%esp)
c0102c24:	c0 
c0102c25:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0102c2c:	c0 
c0102c2d:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c0102c34:	00 
c0102c35:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0102c3c:	e8 85 e0 ff ff       	call   c0100cc6 <__panic>
    struct Page *p = NULL;
c0102c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102c48:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102c4f:	eb 13                	jmp    c0102c64 <default_free_pages+0xa3>
    	p = le2page(le, page_link);
c0102c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c54:	83 e8 0c             	sub    $0xc,%eax
c0102c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (p>base) {
c0102c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c5d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102c60:	76 02                	jbe    c0102c64 <default_free_pages+0xa3>
			break;
c0102c62:	eb 18                	jmp    c0102c7c <default_free_pages+0xbb>
c0102c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c67:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102c6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102c6d:	8b 40 04             	mov    0x4(%eax),%eax
    // 断言是被内核保留页
    // 这里我不明白为什么申请和释放都标记为“内核保留”？？？
    assert(PageReserved(base));
    struct Page *p = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c73:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102c7a:	75 d5                	jne    c0102c51 <default_free_pages+0x90>
    	p = le2page(le, page_link);
		if (p>base) {
			break;
		}
    }
    for (; p != base + n; p ++) {
c0102c7c:	eb 68                	jmp    c0102ce6 <default_free_pages+0x125>
    	// 因为被释放了，所以重新加回到freelist中
    	list_add_before(le, &(p->page_link));
c0102c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c81:	8d 50 0c             	lea    0xc(%eax),%edx
c0102c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c87:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102c8a:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102c8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c90:	8b 00                	mov    (%eax),%eax
c0102c92:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102c95:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102c98:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102c9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c9e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ca1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102ca4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ca7:	89 10                	mov    %edx,(%eax)
c0102ca9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cac:	8b 10                	mov    (%eax),%edx
c0102cae:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102cb1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102cb4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102cb7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102cba:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102cbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102cc0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102cc3:	89 10                	mov    %edx,(%eax)
    	// 每一页的标志位不用改了，改下头页就行了
        p->flags = 0;
c0102cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102ccf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102cd6:	00 
c0102cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cda:	89 04 24             	mov    %eax,(%esp)
c0102cdd:	e8 e9 fb ff ff       	call   c01028cb <set_page_ref>
    	p = le2page(le, page_link);
		if (p>base) {
			break;
		}
    }
    for (; p != base + n; p ++) {
c0102ce2:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ce9:	89 d0                	mov    %edx,%eax
c0102ceb:	c1 e0 02             	shl    $0x2,%eax
c0102cee:	01 d0                	add    %edx,%eax
c0102cf0:	c1 e0 02             	shl    $0x2,%eax
c0102cf3:	89 c2                	mov    %eax,%edx
c0102cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf8:	01 d0                	add    %edx,%eax
c0102cfa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cfd:	0f 85 7b ff ff ff    	jne    c0102c7e <default_free_pages+0xbd>
    	// 每一页的标志位不用改了，改下头页就行了
        p->flags = 0;
        set_page_ref(p, 0);
    }
    // 记录空闲页的数目n
    base->property = n;
c0102d03:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d06:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d09:	89 50 08             	mov    %edx,0x8(%eax)
    // 声明是头页
    SetPageProperty(base);
c0102d0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d0f:	83 c0 04             	add    $0x4,%eax
c0102d12:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102d19:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d1f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102d22:	0f ab 10             	bts    %edx,(%eax)
    base->flags = base->property = 0;
c0102d25:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102d2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d32:	8b 50 08             	mov    0x8(%eax),%edx
c0102d35:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d38:	89 50 04             	mov    %edx,0x4(%eax)
    set_page_ref(p, 0);
c0102d3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d42:	00 
c0102d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d46:	89 04 24             	mov    %eax,(%esp)
c0102d49:	e8 7d fb ff ff       	call   c01028cb <set_page_ref>

    // 向高位合并
    p = le2page(le, page_link);
c0102d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d51:	83 e8 0c             	sub    $0xc,%eax
c0102d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // p在高地址，base在低地址
    if (p == base + n) {
c0102d57:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d5a:	89 d0                	mov    %edx,%eax
c0102d5c:	c1 e0 02             	shl    $0x2,%eax
c0102d5f:	01 d0                	add    %edx,%eax
c0102d61:	c1 e0 02             	shl    $0x2,%eax
c0102d64:	89 c2                	mov    %eax,%edx
c0102d66:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d69:	01 d0                	add    %edx,%eax
c0102d6b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d6e:	75 1e                	jne    c0102d8e <default_free_pages+0x1cd>
    	// 下面的base的property改下
    	base->property = base->property + p->property;
c0102d70:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d73:	8b 50 08             	mov    0x8(%eax),%edx
c0102d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d79:	8b 40 08             	mov    0x8(%eax),%eax
c0102d7c:	01 c2                	add    %eax,%edx
c0102d7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d81:	89 50 08             	mov    %edx,0x8(%eax)
    	// 中间那层打掉了，参考高书图8-5
    	p->property = 0;
c0102d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d87:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d91:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102d94:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d97:	8b 00                	mov    (%eax),%eax
    }

    // 向低位合并，参考高书图8-6
    // 现在是在空闲结点（高书中间下面的那个），指针先往前移一个结点，就是高书图8-6(a)最中间的结点（p指向的那个）
    le = list_prev(le);
c0102d99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(le, page_link);
c0102d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d9f:	83 e8 0c             	sub    $0xc,%eax
c0102da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // p指向中间上面结点的头页，base指向中间下面的结点的头页
    if (le != &free_list && p == base - 1) {
c0102da5:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102dac:	74 57                	je     c0102e05 <default_free_pages+0x244>
c0102dae:	8b 45 08             	mov    0x8(%ebp),%eax
c0102db1:	83 e8 14             	sub    $0x14,%eax
c0102db4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102db7:	75 4c                	jne    c0102e05 <default_free_pages+0x244>
    	// 直到找到右边的空闲页
    	while (le != &free_list) {
c0102db9:	eb 41                	jmp    c0102dfc <default_free_pages+0x23b>
    		// 中间上面的结点非空
    		if (p->property > 0) {
c0102dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dbe:	8b 40 08             	mov    0x8(%eax),%eax
c0102dc1:	85 c0                	test   %eax,%eax
c0102dc3:	74 20                	je     c0102de5 <default_free_pages+0x224>
    			p->property = base->property + p->property;
c0102dc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc8:	8b 50 08             	mov    0x8(%eax),%edx
c0102dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dce:	8b 40 08             	mov    0x8(%eax),%eax
c0102dd1:	01 c2                	add    %eax,%edx
c0102dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dd6:	89 50 08             	mov    %edx,0x8(%eax)
    			base->property = 0;
c0102dd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ddc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    			break;
c0102de3:	eb 20                	jmp    c0102e05 <default_free_pages+0x244>
    		}
    		// 那没找到右边空间页，就往前走
    		p = le2page(le, page_link);
c0102de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102de8:	83 e8 0c             	sub    $0xc,%eax
c0102deb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102df1:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102df4:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102df7:	8b 00                	mov    (%eax),%eax
    		le = list_prev(le);
c0102df9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    le = list_prev(le);
    p = le2page(le, page_link);
    // p指向中间上面结点的头页，base指向中间下面的结点的头页
    if (le != &free_list && p == base - 1) {
    	// 直到找到右边的空闲页
    	while (le != &free_list) {
c0102dfc:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102e03:	75 b6                	jne    c0102dbb <default_free_pages+0x1fa>
    		// 那没找到右边空间页，就往前走
    		p = le2page(le, page_link);
    		le = list_prev(le);
    	}
    }
    nr_free += n;
c0102e05:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e0e:	01 d0                	add    %edx,%eax
c0102e10:	a3 58 89 11 c0       	mov    %eax,0xc0118958
}
c0102e15:	c9                   	leave  
c0102e16:	c3                   	ret    

c0102e17 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e17:	55                   	push   %ebp
c0102e18:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e1a:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102e1f:	5d                   	pop    %ebp
c0102e20:	c3                   	ret    

c0102e21 <basic_check>:

static void
basic_check(void) {
c0102e21:	55                   	push   %ebp
c0102e22:	89 e5                	mov    %esp,%ebp
c0102e24:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e31:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e37:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e3a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e41:	e8 78 0e 00 00       	call   c0103cbe <alloc_pages>
c0102e46:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e49:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e4d:	75 24                	jne    c0102e73 <basic_check+0x52>
c0102e4f:	c7 44 24 0c 24 65 10 	movl   $0xc0106524,0xc(%esp)
c0102e56:	c0 
c0102e57:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0102e5e:	c0 
c0102e5f:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0102e66:	00 
c0102e67:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0102e6e:	e8 53 de ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102e73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e7a:	e8 3f 0e 00 00       	call   c0103cbe <alloc_pages>
c0102e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102e86:	75 24                	jne    c0102eac <basic_check+0x8b>
c0102e88:	c7 44 24 0c 40 65 10 	movl   $0xc0106540,0xc(%esp)
c0102e8f:	c0 
c0102e90:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0102e97:	c0 
c0102e98:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0102e9f:	00 
c0102ea0:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0102ea7:	e8 1a de ff ff       	call   c0100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102eac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102eb3:	e8 06 0e 00 00       	call   c0103cbe <alloc_pages>
c0102eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102ebf:	75 24                	jne    c0102ee5 <basic_check+0xc4>
c0102ec1:	c7 44 24 0c 5c 65 10 	movl   $0xc010655c,0xc(%esp)
c0102ec8:	c0 
c0102ec9:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0102ed0:	c0 
c0102ed1:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0102ed8:	00 
c0102ed9:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0102ee0:	e8 e1 dd ff ff       	call   c0100cc6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ee8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102eeb:	74 10                	je     c0102efd <basic_check+0xdc>
c0102eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ef0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ef3:	74 08                	je     c0102efd <basic_check+0xdc>
c0102ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ef8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102efb:	75 24                	jne    c0102f21 <basic_check+0x100>
c0102efd:	c7 44 24 0c 78 65 10 	movl   $0xc0106578,0xc(%esp)
c0102f04:	c0 
c0102f05:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0102f0c:	c0 
c0102f0d:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0102f14:	00 
c0102f15:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0102f1c:	e8 a5 dd ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f24:	89 04 24             	mov    %eax,(%esp)
c0102f27:	e8 95 f9 ff ff       	call   c01028c1 <page_ref>
c0102f2c:	85 c0                	test   %eax,%eax
c0102f2e:	75 1e                	jne    c0102f4e <basic_check+0x12d>
c0102f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f33:	89 04 24             	mov    %eax,(%esp)
c0102f36:	e8 86 f9 ff ff       	call   c01028c1 <page_ref>
c0102f3b:	85 c0                	test   %eax,%eax
c0102f3d:	75 0f                	jne    c0102f4e <basic_check+0x12d>
c0102f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f42:	89 04 24             	mov    %eax,(%esp)
c0102f45:	e8 77 f9 ff ff       	call   c01028c1 <page_ref>
c0102f4a:	85 c0                	test   %eax,%eax
c0102f4c:	74 24                	je     c0102f72 <basic_check+0x151>
c0102f4e:	c7 44 24 0c 9c 65 10 	movl   $0xc010659c,0xc(%esp)
c0102f55:	c0 
c0102f56:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0102f5d:	c0 
c0102f5e:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0102f65:	00 
c0102f66:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0102f6d:	e8 54 dd ff ff       	call   c0100cc6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f75:	89 04 24             	mov    %eax,(%esp)
c0102f78:	e8 2e f9 ff ff       	call   c01028ab <page2pa>
c0102f7d:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f83:	c1 e2 0c             	shl    $0xc,%edx
c0102f86:	39 d0                	cmp    %edx,%eax
c0102f88:	72 24                	jb     c0102fae <basic_check+0x18d>
c0102f8a:	c7 44 24 0c d8 65 10 	movl   $0xc01065d8,0xc(%esp)
c0102f91:	c0 
c0102f92:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0102f99:	c0 
c0102f9a:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0102fa1:	00 
c0102fa2:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0102fa9:	e8 18 dd ff ff       	call   c0100cc6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fb1:	89 04 24             	mov    %eax,(%esp)
c0102fb4:	e8 f2 f8 ff ff       	call   c01028ab <page2pa>
c0102fb9:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fbf:	c1 e2 0c             	shl    $0xc,%edx
c0102fc2:	39 d0                	cmp    %edx,%eax
c0102fc4:	72 24                	jb     c0102fea <basic_check+0x1c9>
c0102fc6:	c7 44 24 0c f5 65 10 	movl   $0xc01065f5,0xc(%esp)
c0102fcd:	c0 
c0102fce:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0102fd5:	c0 
c0102fd6:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0102fdd:	00 
c0102fde:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0102fe5:	e8 dc dc ff ff       	call   c0100cc6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fed:	89 04 24             	mov    %eax,(%esp)
c0102ff0:	e8 b6 f8 ff ff       	call   c01028ab <page2pa>
c0102ff5:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102ffb:	c1 e2 0c             	shl    $0xc,%edx
c0102ffe:	39 d0                	cmp    %edx,%eax
c0103000:	72 24                	jb     c0103026 <basic_check+0x205>
c0103002:	c7 44 24 0c 12 66 10 	movl   $0xc0106612,0xc(%esp)
c0103009:	c0 
c010300a:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103011:	c0 
c0103012:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0103019:	00 
c010301a:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103021:	e8 a0 dc ff ff       	call   c0100cc6 <__panic>

    list_entry_t free_list_store = free_list;
c0103026:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010302b:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103031:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103034:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103037:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010303e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103041:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103044:	89 50 04             	mov    %edx,0x4(%eax)
c0103047:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010304a:	8b 50 04             	mov    0x4(%eax),%edx
c010304d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103050:	89 10                	mov    %edx,(%eax)
c0103052:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103059:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010305c:	8b 40 04             	mov    0x4(%eax),%eax
c010305f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103062:	0f 94 c0             	sete   %al
c0103065:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103068:	85 c0                	test   %eax,%eax
c010306a:	75 24                	jne    c0103090 <basic_check+0x26f>
c010306c:	c7 44 24 0c 2f 66 10 	movl   $0xc010662f,0xc(%esp)
c0103073:	c0 
c0103074:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c010307b:	c0 
c010307c:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103083:	00 
c0103084:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c010308b:	e8 36 dc ff ff       	call   c0100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
c0103090:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103095:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103098:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c010309f:	00 00 00 

    assert(alloc_page() == NULL);
c01030a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030a9:	e8 10 0c 00 00       	call   c0103cbe <alloc_pages>
c01030ae:	85 c0                	test   %eax,%eax
c01030b0:	74 24                	je     c01030d6 <basic_check+0x2b5>
c01030b2:	c7 44 24 0c 46 66 10 	movl   $0xc0106646,0xc(%esp)
c01030b9:	c0 
c01030ba:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c01030c1:	c0 
c01030c2:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c01030c9:	00 
c01030ca:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01030d1:	e8 f0 db ff ff       	call   c0100cc6 <__panic>

    free_page(p0);
c01030d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030dd:	00 
c01030de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030e1:	89 04 24             	mov    %eax,(%esp)
c01030e4:	e8 0d 0c 00 00       	call   c0103cf6 <free_pages>
    free_page(p1);
c01030e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030f0:	00 
c01030f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030f4:	89 04 24             	mov    %eax,(%esp)
c01030f7:	e8 fa 0b 00 00       	call   c0103cf6 <free_pages>
    free_page(p2);
c01030fc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103103:	00 
c0103104:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103107:	89 04 24             	mov    %eax,(%esp)
c010310a:	e8 e7 0b 00 00       	call   c0103cf6 <free_pages>
    assert(nr_free == 3);
c010310f:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103114:	83 f8 03             	cmp    $0x3,%eax
c0103117:	74 24                	je     c010313d <basic_check+0x31c>
c0103119:	c7 44 24 0c 5b 66 10 	movl   $0xc010665b,0xc(%esp)
c0103120:	c0 
c0103121:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103128:	c0 
c0103129:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0103130:	00 
c0103131:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103138:	e8 89 db ff ff       	call   c0100cc6 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010313d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103144:	e8 75 0b 00 00       	call   c0103cbe <alloc_pages>
c0103149:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010314c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103150:	75 24                	jne    c0103176 <basic_check+0x355>
c0103152:	c7 44 24 0c 24 65 10 	movl   $0xc0106524,0xc(%esp)
c0103159:	c0 
c010315a:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103161:	c0 
c0103162:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103169:	00 
c010316a:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103171:	e8 50 db ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103176:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010317d:	e8 3c 0b 00 00       	call   c0103cbe <alloc_pages>
c0103182:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103185:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103189:	75 24                	jne    c01031af <basic_check+0x38e>
c010318b:	c7 44 24 0c 40 65 10 	movl   $0xc0106540,0xc(%esp)
c0103192:	c0 
c0103193:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c010319a:	c0 
c010319b:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c01031a2:	00 
c01031a3:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01031aa:	e8 17 db ff ff       	call   c0100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01031af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031b6:	e8 03 0b 00 00       	call   c0103cbe <alloc_pages>
c01031bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031c2:	75 24                	jne    c01031e8 <basic_check+0x3c7>
c01031c4:	c7 44 24 0c 5c 65 10 	movl   $0xc010655c,0xc(%esp)
c01031cb:	c0 
c01031cc:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c01031d3:	c0 
c01031d4:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01031db:	00 
c01031dc:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01031e3:	e8 de da ff ff       	call   c0100cc6 <__panic>

    assert(alloc_page() == NULL);
c01031e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031ef:	e8 ca 0a 00 00       	call   c0103cbe <alloc_pages>
c01031f4:	85 c0                	test   %eax,%eax
c01031f6:	74 24                	je     c010321c <basic_check+0x3fb>
c01031f8:	c7 44 24 0c 46 66 10 	movl   $0xc0106646,0xc(%esp)
c01031ff:	c0 
c0103200:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103207:	c0 
c0103208:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c010320f:	00 
c0103210:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103217:	e8 aa da ff ff       	call   c0100cc6 <__panic>

    free_page(p0);
c010321c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103223:	00 
c0103224:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103227:	89 04 24             	mov    %eax,(%esp)
c010322a:	e8 c7 0a 00 00       	call   c0103cf6 <free_pages>
c010322f:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c0103236:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103239:	8b 40 04             	mov    0x4(%eax),%eax
c010323c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010323f:	0f 94 c0             	sete   %al
c0103242:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103245:	85 c0                	test   %eax,%eax
c0103247:	74 24                	je     c010326d <basic_check+0x44c>
c0103249:	c7 44 24 0c 68 66 10 	movl   $0xc0106668,0xc(%esp)
c0103250:	c0 
c0103251:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103258:	c0 
c0103259:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0103260:	00 
c0103261:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103268:	e8 59 da ff ff       	call   c0100cc6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010326d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103274:	e8 45 0a 00 00       	call   c0103cbe <alloc_pages>
c0103279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010327c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010327f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103282:	74 24                	je     c01032a8 <basic_check+0x487>
c0103284:	c7 44 24 0c 80 66 10 	movl   $0xc0106680,0xc(%esp)
c010328b:	c0 
c010328c:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103293:	c0 
c0103294:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010329b:	00 
c010329c:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01032a3:	e8 1e da ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c01032a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032af:	e8 0a 0a 00 00       	call   c0103cbe <alloc_pages>
c01032b4:	85 c0                	test   %eax,%eax
c01032b6:	74 24                	je     c01032dc <basic_check+0x4bb>
c01032b8:	c7 44 24 0c 46 66 10 	movl   $0xc0106646,0xc(%esp)
c01032bf:	c0 
c01032c0:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c01032c7:	c0 
c01032c8:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01032cf:	00 
c01032d0:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01032d7:	e8 ea d9 ff ff       	call   c0100cc6 <__panic>

    assert(nr_free == 0);
c01032dc:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01032e1:	85 c0                	test   %eax,%eax
c01032e3:	74 24                	je     c0103309 <basic_check+0x4e8>
c01032e5:	c7 44 24 0c 99 66 10 	movl   $0xc0106699,0xc(%esp)
c01032ec:	c0 
c01032ed:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c01032f4:	c0 
c01032f5:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01032fc:	00 
c01032fd:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103304:	e8 bd d9 ff ff       	call   c0100cc6 <__panic>
    free_list = free_list_store;
c0103309:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010330c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010330f:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103314:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c010331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010331d:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c0103322:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103329:	00 
c010332a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010332d:	89 04 24             	mov    %eax,(%esp)
c0103330:	e8 c1 09 00 00       	call   c0103cf6 <free_pages>
    free_page(p1);
c0103335:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010333c:	00 
c010333d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103340:	89 04 24             	mov    %eax,(%esp)
c0103343:	e8 ae 09 00 00       	call   c0103cf6 <free_pages>
    free_page(p2);
c0103348:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010334f:	00 
c0103350:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103353:	89 04 24             	mov    %eax,(%esp)
c0103356:	e8 9b 09 00 00       	call   c0103cf6 <free_pages>
}
c010335b:	c9                   	leave  
c010335c:	c3                   	ret    

c010335d <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010335d:	55                   	push   %ebp
c010335e:	89 e5                	mov    %esp,%ebp
c0103360:	53                   	push   %ebx
c0103361:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103367:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010336e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103375:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010337c:	eb 6b                	jmp    c01033e9 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c010337e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103381:	83 e8 0c             	sub    $0xc,%eax
c0103384:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103387:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010338a:	83 c0 04             	add    $0x4,%eax
c010338d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103394:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103397:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010339a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010339d:	0f a3 10             	bt     %edx,(%eax)
c01033a0:	19 c0                	sbb    %eax,%eax
c01033a2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01033a5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01033a9:	0f 95 c0             	setne  %al
c01033ac:	0f b6 c0             	movzbl %al,%eax
c01033af:	85 c0                	test   %eax,%eax
c01033b1:	75 24                	jne    c01033d7 <default_check+0x7a>
c01033b3:	c7 44 24 0c a6 66 10 	movl   $0xc01066a6,0xc(%esp)
c01033ba:	c0 
c01033bb:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c01033c2:	c0 
c01033c3:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01033ca:	00 
c01033cb:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01033d2:	e8 ef d8 ff ff       	call   c0100cc6 <__panic>
        count ++, total += p->property;
c01033d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01033db:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033de:	8b 50 08             	mov    0x8(%eax),%edx
c01033e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033e4:	01 d0                	add    %edx,%eax
c01033e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033f2:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01033f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033f8:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01033ff:	0f 85 79 ff ff ff    	jne    c010337e <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103405:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103408:	e8 1b 09 00 00       	call   c0103d28 <nr_free_pages>
c010340d:	39 c3                	cmp    %eax,%ebx
c010340f:	74 24                	je     c0103435 <default_check+0xd8>
c0103411:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c0103418:	c0 
c0103419:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103420:	c0 
c0103421:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103428:	00 
c0103429:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103430:	e8 91 d8 ff ff       	call   c0100cc6 <__panic>

    basic_check();
c0103435:	e8 e7 f9 ff ff       	call   c0102e21 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010343a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103441:	e8 78 08 00 00       	call   c0103cbe <alloc_pages>
c0103446:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103449:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010344d:	75 24                	jne    c0103473 <default_check+0x116>
c010344f:	c7 44 24 0c cf 66 10 	movl   $0xc01066cf,0xc(%esp)
c0103456:	c0 
c0103457:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c010345e:	c0 
c010345f:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103466:	00 
c0103467:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c010346e:	e8 53 d8 ff ff       	call   c0100cc6 <__panic>
    assert(!PageProperty(p0));
c0103473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103476:	83 c0 04             	add    $0x4,%eax
c0103479:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103480:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103483:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103486:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103489:	0f a3 10             	bt     %edx,(%eax)
c010348c:	19 c0                	sbb    %eax,%eax
c010348e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103491:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103495:	0f 95 c0             	setne  %al
c0103498:	0f b6 c0             	movzbl %al,%eax
c010349b:	85 c0                	test   %eax,%eax
c010349d:	74 24                	je     c01034c3 <default_check+0x166>
c010349f:	c7 44 24 0c da 66 10 	movl   $0xc01066da,0xc(%esp)
c01034a6:	c0 
c01034a7:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c01034ae:	c0 
c01034af:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c01034b6:	00 
c01034b7:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01034be:	e8 03 d8 ff ff       	call   c0100cc6 <__panic>

    list_entry_t free_list_store = free_list;
c01034c3:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01034c8:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c01034ce:	89 45 80             	mov    %eax,-0x80(%ebp)
c01034d1:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01034d4:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01034db:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034de:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01034e1:	89 50 04             	mov    %edx,0x4(%eax)
c01034e4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034e7:	8b 50 04             	mov    0x4(%eax),%edx
c01034ea:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034ed:	89 10                	mov    %edx,(%eax)
c01034ef:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01034f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01034f9:	8b 40 04             	mov    0x4(%eax),%eax
c01034fc:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01034ff:	0f 94 c0             	sete   %al
c0103502:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103505:	85 c0                	test   %eax,%eax
c0103507:	75 24                	jne    c010352d <default_check+0x1d0>
c0103509:	c7 44 24 0c 2f 66 10 	movl   $0xc010662f,0xc(%esp)
c0103510:	c0 
c0103511:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103518:	c0 
c0103519:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0103520:	00 
c0103521:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103528:	e8 99 d7 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c010352d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103534:	e8 85 07 00 00       	call   c0103cbe <alloc_pages>
c0103539:	85 c0                	test   %eax,%eax
c010353b:	74 24                	je     c0103561 <default_check+0x204>
c010353d:	c7 44 24 0c 46 66 10 	movl   $0xc0106646,0xc(%esp)
c0103544:	c0 
c0103545:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c010354c:	c0 
c010354d:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0103554:	00 
c0103555:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c010355c:	e8 65 d7 ff ff       	call   c0100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
c0103561:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103566:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103569:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103570:	00 00 00 

    free_pages(p0 + 2, 3);
c0103573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103576:	83 c0 28             	add    $0x28,%eax
c0103579:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103580:	00 
c0103581:	89 04 24             	mov    %eax,(%esp)
c0103584:	e8 6d 07 00 00       	call   c0103cf6 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103589:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103590:	e8 29 07 00 00       	call   c0103cbe <alloc_pages>
c0103595:	85 c0                	test   %eax,%eax
c0103597:	74 24                	je     c01035bd <default_check+0x260>
c0103599:	c7 44 24 0c ec 66 10 	movl   $0xc01066ec,0xc(%esp)
c01035a0:	c0 
c01035a1:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c01035a8:	c0 
c01035a9:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01035b0:	00 
c01035b1:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01035b8:	e8 09 d7 ff ff       	call   c0100cc6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01035bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035c0:	83 c0 28             	add    $0x28,%eax
c01035c3:	83 c0 04             	add    $0x4,%eax
c01035c6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01035cd:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035d0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01035d3:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01035d6:	0f a3 10             	bt     %edx,(%eax)
c01035d9:	19 c0                	sbb    %eax,%eax
c01035db:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01035de:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01035e2:	0f 95 c0             	setne  %al
c01035e5:	0f b6 c0             	movzbl %al,%eax
c01035e8:	85 c0                	test   %eax,%eax
c01035ea:	74 0e                	je     c01035fa <default_check+0x29d>
c01035ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035ef:	83 c0 28             	add    $0x28,%eax
c01035f2:	8b 40 08             	mov    0x8(%eax),%eax
c01035f5:	83 f8 03             	cmp    $0x3,%eax
c01035f8:	74 24                	je     c010361e <default_check+0x2c1>
c01035fa:	c7 44 24 0c 04 67 10 	movl   $0xc0106704,0xc(%esp)
c0103601:	c0 
c0103602:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103609:	c0 
c010360a:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0103611:	00 
c0103612:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103619:	e8 a8 d6 ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010361e:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103625:	e8 94 06 00 00       	call   c0103cbe <alloc_pages>
c010362a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010362d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103631:	75 24                	jne    c0103657 <default_check+0x2fa>
c0103633:	c7 44 24 0c 30 67 10 	movl   $0xc0106730,0xc(%esp)
c010363a:	c0 
c010363b:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103642:	c0 
c0103643:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c010364a:	00 
c010364b:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103652:	e8 6f d6 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c0103657:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010365e:	e8 5b 06 00 00       	call   c0103cbe <alloc_pages>
c0103663:	85 c0                	test   %eax,%eax
c0103665:	74 24                	je     c010368b <default_check+0x32e>
c0103667:	c7 44 24 0c 46 66 10 	movl   $0xc0106646,0xc(%esp)
c010366e:	c0 
c010366f:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103676:	c0 
c0103677:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c010367e:	00 
c010367f:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103686:	e8 3b d6 ff ff       	call   c0100cc6 <__panic>
    assert(p0 + 2 == p1);
c010368b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010368e:	83 c0 28             	add    $0x28,%eax
c0103691:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103694:	74 24                	je     c01036ba <default_check+0x35d>
c0103696:	c7 44 24 0c 4e 67 10 	movl   $0xc010674e,0xc(%esp)
c010369d:	c0 
c010369e:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c01036a5:	c0 
c01036a6:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c01036ad:	00 
c01036ae:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01036b5:	e8 0c d6 ff ff       	call   c0100cc6 <__panic>

    p2 = p0 + 1;
c01036ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036bd:	83 c0 14             	add    $0x14,%eax
c01036c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01036c3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036ca:	00 
c01036cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036ce:	89 04 24             	mov    %eax,(%esp)
c01036d1:	e8 20 06 00 00       	call   c0103cf6 <free_pages>
    free_pages(p1, 3);
c01036d6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01036dd:	00 
c01036de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036e1:	89 04 24             	mov    %eax,(%esp)
c01036e4:	e8 0d 06 00 00       	call   c0103cf6 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01036e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036ec:	83 c0 04             	add    $0x4,%eax
c01036ef:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01036f6:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036f9:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01036fc:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01036ff:	0f a3 10             	bt     %edx,(%eax)
c0103702:	19 c0                	sbb    %eax,%eax
c0103704:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103707:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010370b:	0f 95 c0             	setne  %al
c010370e:	0f b6 c0             	movzbl %al,%eax
c0103711:	85 c0                	test   %eax,%eax
c0103713:	74 0b                	je     c0103720 <default_check+0x3c3>
c0103715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103718:	8b 40 08             	mov    0x8(%eax),%eax
c010371b:	83 f8 01             	cmp    $0x1,%eax
c010371e:	74 24                	je     c0103744 <default_check+0x3e7>
c0103720:	c7 44 24 0c 5c 67 10 	movl   $0xc010675c,0xc(%esp)
c0103727:	c0 
c0103728:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c010372f:	c0 
c0103730:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0103737:	00 
c0103738:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c010373f:	e8 82 d5 ff ff       	call   c0100cc6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103744:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103747:	83 c0 04             	add    $0x4,%eax
c010374a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103751:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103754:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103757:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010375a:	0f a3 10             	bt     %edx,(%eax)
c010375d:	19 c0                	sbb    %eax,%eax
c010375f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103762:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103766:	0f 95 c0             	setne  %al
c0103769:	0f b6 c0             	movzbl %al,%eax
c010376c:	85 c0                	test   %eax,%eax
c010376e:	74 0b                	je     c010377b <default_check+0x41e>
c0103770:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103773:	8b 40 08             	mov    0x8(%eax),%eax
c0103776:	83 f8 03             	cmp    $0x3,%eax
c0103779:	74 24                	je     c010379f <default_check+0x442>
c010377b:	c7 44 24 0c 84 67 10 	movl   $0xc0106784,0xc(%esp)
c0103782:	c0 
c0103783:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c010378a:	c0 
c010378b:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0103792:	00 
c0103793:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c010379a:	e8 27 d5 ff ff       	call   c0100cc6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010379f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037a6:	e8 13 05 00 00       	call   c0103cbe <alloc_pages>
c01037ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037b1:	83 e8 14             	sub    $0x14,%eax
c01037b4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037b7:	74 24                	je     c01037dd <default_check+0x480>
c01037b9:	c7 44 24 0c aa 67 10 	movl   $0xc01067aa,0xc(%esp)
c01037c0:	c0 
c01037c1:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c01037c8:	c0 
c01037c9:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01037d0:	00 
c01037d1:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01037d8:	e8 e9 d4 ff ff       	call   c0100cc6 <__panic>
    free_page(p0);
c01037dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037e4:	00 
c01037e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037e8:	89 04 24             	mov    %eax,(%esp)
c01037eb:	e8 06 05 00 00       	call   c0103cf6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01037f0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01037f7:	e8 c2 04 00 00       	call   c0103cbe <alloc_pages>
c01037fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103802:	83 c0 14             	add    $0x14,%eax
c0103805:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103808:	74 24                	je     c010382e <default_check+0x4d1>
c010380a:	c7 44 24 0c c8 67 10 	movl   $0xc01067c8,0xc(%esp)
c0103811:	c0 
c0103812:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103819:	c0 
c010381a:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0103821:	00 
c0103822:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103829:	e8 98 d4 ff ff       	call   c0100cc6 <__panic>

    free_pages(p0, 2);
c010382e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103835:	00 
c0103836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103839:	89 04 24             	mov    %eax,(%esp)
c010383c:	e8 b5 04 00 00       	call   c0103cf6 <free_pages>
    free_page(p2);
c0103841:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103848:	00 
c0103849:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010384c:	89 04 24             	mov    %eax,(%esp)
c010384f:	e8 a2 04 00 00       	call   c0103cf6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103854:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010385b:	e8 5e 04 00 00       	call   c0103cbe <alloc_pages>
c0103860:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103863:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103867:	75 24                	jne    c010388d <default_check+0x530>
c0103869:	c7 44 24 0c e8 67 10 	movl   $0xc01067e8,0xc(%esp)
c0103870:	c0 
c0103871:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103878:	c0 
c0103879:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0103880:	00 
c0103881:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0103888:	e8 39 d4 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c010388d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103894:	e8 25 04 00 00       	call   c0103cbe <alloc_pages>
c0103899:	85 c0                	test   %eax,%eax
c010389b:	74 24                	je     c01038c1 <default_check+0x564>
c010389d:	c7 44 24 0c 46 66 10 	movl   $0xc0106646,0xc(%esp)
c01038a4:	c0 
c01038a5:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c01038ac:	c0 
c01038ad:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c01038b4:	00 
c01038b5:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01038bc:	e8 05 d4 ff ff       	call   c0100cc6 <__panic>

    assert(nr_free == 0);
c01038c1:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01038c6:	85 c0                	test   %eax,%eax
c01038c8:	74 24                	je     c01038ee <default_check+0x591>
c01038ca:	c7 44 24 0c 99 66 10 	movl   $0xc0106699,0xc(%esp)
c01038d1:	c0 
c01038d2:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c01038d9:	c0 
c01038da:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01038e1:	00 
c01038e2:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01038e9:	e8 d8 d3 ff ff       	call   c0100cc6 <__panic>
    nr_free = nr_free_store;
c01038ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038f1:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c01038f6:	8b 45 80             	mov    -0x80(%ebp),%eax
c01038f9:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01038fc:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103901:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c0103907:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010390e:	00 
c010390f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103912:	89 04 24             	mov    %eax,(%esp)
c0103915:	e8 dc 03 00 00       	call   c0103cf6 <free_pages>

    le = &free_list;
c010391a:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103921:	eb 1d                	jmp    c0103940 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103923:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103926:	83 e8 0c             	sub    $0xc,%eax
c0103929:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c010392c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103930:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103933:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103936:	8b 40 08             	mov    0x8(%eax),%eax
c0103939:	29 c2                	sub    %eax,%edx
c010393b:	89 d0                	mov    %edx,%eax
c010393d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103940:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103943:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103946:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103949:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010394c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010394f:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103956:	75 cb                	jne    c0103923 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010395c:	74 24                	je     c0103982 <default_check+0x625>
c010395e:	c7 44 24 0c 06 68 10 	movl   $0xc0106806,0xc(%esp)
c0103965:	c0 
c0103966:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c010396d:	c0 
c010396e:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c0103975:	00 
c0103976:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c010397d:	e8 44 d3 ff ff       	call   c0100cc6 <__panic>
    assert(total == 0);
c0103982:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103986:	74 24                	je     c01039ac <default_check+0x64f>
c0103988:	c7 44 24 0c 11 68 10 	movl   $0xc0106811,0xc(%esp)
c010398f:	c0 
c0103990:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0103997:	c0 
c0103998:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c010399f:	00 
c01039a0:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c01039a7:	e8 1a d3 ff ff       	call   c0100cc6 <__panic>
}
c01039ac:	81 c4 94 00 00 00    	add    $0x94,%esp
c01039b2:	5b                   	pop    %ebx
c01039b3:	5d                   	pop    %ebp
c01039b4:	c3                   	ret    

c01039b5 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01039b5:	55                   	push   %ebp
c01039b6:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01039b8:	8b 55 08             	mov    0x8(%ebp),%edx
c01039bb:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01039c0:	29 c2                	sub    %eax,%edx
c01039c2:	89 d0                	mov    %edx,%eax
c01039c4:	c1 f8 02             	sar    $0x2,%eax
c01039c7:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01039cd:	5d                   	pop    %ebp
c01039ce:	c3                   	ret    

c01039cf <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01039cf:	55                   	push   %ebp
c01039d0:	89 e5                	mov    %esp,%ebp
c01039d2:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01039d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01039d8:	89 04 24             	mov    %eax,(%esp)
c01039db:	e8 d5 ff ff ff       	call   c01039b5 <page2ppn>
c01039e0:	c1 e0 0c             	shl    $0xc,%eax
}
c01039e3:	c9                   	leave  
c01039e4:	c3                   	ret    

c01039e5 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01039e5:	55                   	push   %ebp
c01039e6:	89 e5                	mov    %esp,%ebp
c01039e8:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01039eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01039ee:	c1 e8 0c             	shr    $0xc,%eax
c01039f1:	89 c2                	mov    %eax,%edx
c01039f3:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01039f8:	39 c2                	cmp    %eax,%edx
c01039fa:	72 1c                	jb     c0103a18 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01039fc:	c7 44 24 08 4c 68 10 	movl   $0xc010684c,0x8(%esp)
c0103a03:	c0 
c0103a04:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103a0b:	00 
c0103a0c:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103a13:	e8 ae d2 ff ff       	call   c0100cc6 <__panic>
    }
    return &pages[PPN(pa)];
c0103a18:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103a1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a21:	c1 e8 0c             	shr    $0xc,%eax
c0103a24:	89 c2                	mov    %eax,%edx
c0103a26:	89 d0                	mov    %edx,%eax
c0103a28:	c1 e0 02             	shl    $0x2,%eax
c0103a2b:	01 d0                	add    %edx,%eax
c0103a2d:	c1 e0 02             	shl    $0x2,%eax
c0103a30:	01 c8                	add    %ecx,%eax
}
c0103a32:	c9                   	leave  
c0103a33:	c3                   	ret    

c0103a34 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a34:	55                   	push   %ebp
c0103a35:	89 e5                	mov    %esp,%ebp
c0103a37:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a3d:	89 04 24             	mov    %eax,(%esp)
c0103a40:	e8 8a ff ff ff       	call   c01039cf <page2pa>
c0103a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a4b:	c1 e8 0c             	shr    $0xc,%eax
c0103a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a51:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a56:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103a59:	72 23                	jb     c0103a7e <page2kva+0x4a>
c0103a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103a62:	c7 44 24 08 7c 68 10 	movl   $0xc010687c,0x8(%esp)
c0103a69:	c0 
c0103a6a:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103a71:	00 
c0103a72:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103a79:	e8 48 d2 ff ff       	call   c0100cc6 <__panic>
c0103a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a81:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103a86:	c9                   	leave  
c0103a87:	c3                   	ret    

c0103a88 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103a88:	55                   	push   %ebp
c0103a89:	89 e5                	mov    %esp,%ebp
c0103a8b:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a91:	83 e0 01             	and    $0x1,%eax
c0103a94:	85 c0                	test   %eax,%eax
c0103a96:	75 1c                	jne    c0103ab4 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103a98:	c7 44 24 08 a0 68 10 	movl   $0xc01068a0,0x8(%esp)
c0103a9f:	c0 
c0103aa0:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103aa7:	00 
c0103aa8:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103aaf:	e8 12 d2 ff ff       	call   c0100cc6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103ab4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ab7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103abc:	89 04 24             	mov    %eax,(%esp)
c0103abf:	e8 21 ff ff ff       	call   c01039e5 <pa2page>
}
c0103ac4:	c9                   	leave  
c0103ac5:	c3                   	ret    

c0103ac6 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103ac6:	55                   	push   %ebp
c0103ac7:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103ac9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103acc:	8b 00                	mov    (%eax),%eax
}
c0103ace:	5d                   	pop    %ebp
c0103acf:	c3                   	ret    

c0103ad0 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0103ad0:	55                   	push   %ebp
c0103ad1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103ad3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad6:	8b 00                	mov    (%eax),%eax
c0103ad8:	8d 50 01             	lea    0x1(%eax),%edx
c0103adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ade:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ae0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae3:	8b 00                	mov    (%eax),%eax
}
c0103ae5:	5d                   	pop    %ebp
c0103ae6:	c3                   	ret    

c0103ae7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103ae7:	55                   	push   %ebp
c0103ae8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aed:	8b 00                	mov    (%eax),%eax
c0103aef:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103af2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af5:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103af7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103afa:	8b 00                	mov    (%eax),%eax
}
c0103afc:	5d                   	pop    %ebp
c0103afd:	c3                   	ret    

c0103afe <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103afe:	55                   	push   %ebp
c0103aff:	89 e5                	mov    %esp,%ebp
c0103b01:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b04:	9c                   	pushf  
c0103b05:	58                   	pop    %eax
c0103b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b0c:	25 00 02 00 00       	and    $0x200,%eax
c0103b11:	85 c0                	test   %eax,%eax
c0103b13:	74 0c                	je     c0103b21 <__intr_save+0x23>
        intr_disable();
c0103b15:	e8 8f db ff ff       	call   c01016a9 <intr_disable>
        return 1;
c0103b1a:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b1f:	eb 05                	jmp    c0103b26 <__intr_save+0x28>
    }
    return 0;
c0103b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b26:	c9                   	leave  
c0103b27:	c3                   	ret    

c0103b28 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b28:	55                   	push   %ebp
c0103b29:	89 e5                	mov    %esp,%ebp
c0103b2b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b32:	74 05                	je     c0103b39 <__intr_restore+0x11>
        intr_enable();
c0103b34:	e8 6a db ff ff       	call   c01016a3 <intr_enable>
    }
}
c0103b39:	c9                   	leave  
c0103b3a:	c3                   	ret    

c0103b3b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103b3b:	55                   	push   %ebp
c0103b3c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b41:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103b44:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b49:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103b4b:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b50:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103b52:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b57:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103b59:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b5e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103b60:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b65:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103b67:	ea 6e 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103b6e
}
c0103b6e:	5d                   	pop    %ebp
c0103b6f:	c3                   	ret    

c0103b70 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103b70:	55                   	push   %ebp
c0103b71:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b76:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103b7b:	5d                   	pop    %ebp
c0103b7c:	c3                   	ret    

c0103b7d <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103b7d:	55                   	push   %ebp
c0103b7e:	89 e5                	mov    %esp,%ebp
c0103b80:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103b83:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103b88:	89 04 24             	mov    %eax,(%esp)
c0103b8b:	e8 e0 ff ff ff       	call   c0103b70 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103b90:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103b97:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103b99:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103ba0:	68 00 
c0103ba2:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103ba7:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103bad:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103bb2:	c1 e8 10             	shr    $0x10,%eax
c0103bb5:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103bba:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bc1:	83 e0 f0             	and    $0xfffffff0,%eax
c0103bc4:	83 c8 09             	or     $0x9,%eax
c0103bc7:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bcc:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bd3:	83 e0 ef             	and    $0xffffffef,%eax
c0103bd6:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bdb:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103be2:	83 e0 9f             	and    $0xffffff9f,%eax
c0103be5:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bea:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bf1:	83 c8 80             	or     $0xffffff80,%eax
c0103bf4:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bf9:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c00:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c03:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c08:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c0f:	83 e0 ef             	and    $0xffffffef,%eax
c0103c12:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c17:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c1e:	83 e0 df             	and    $0xffffffdf,%eax
c0103c21:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c26:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c2d:	83 c8 40             	or     $0x40,%eax
c0103c30:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c35:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c3c:	83 e0 7f             	and    $0x7f,%eax
c0103c3f:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c44:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c49:	c1 e8 18             	shr    $0x18,%eax
c0103c4c:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103c51:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103c58:	e8 de fe ff ff       	call   c0103b3b <lgdt>
c0103c5d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103c63:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103c67:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103c6a:	c9                   	leave  
c0103c6b:	c3                   	ret    

c0103c6c <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103c6c:	55                   	push   %ebp
c0103c6d:	89 e5                	mov    %esp,%ebp
c0103c6f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103c72:	c7 05 5c 89 11 c0 30 	movl   $0xc0106830,0xc011895c
c0103c79:	68 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103c7c:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c81:	8b 00                	mov    (%eax),%eax
c0103c83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c87:	c7 04 24 cc 68 10 c0 	movl   $0xc01068cc,(%esp)
c0103c8e:	e8 a9 c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103c93:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c98:	8b 40 04             	mov    0x4(%eax),%eax
c0103c9b:	ff d0                	call   *%eax
}
c0103c9d:	c9                   	leave  
c0103c9e:	c3                   	ret    

c0103c9f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103c9f:	55                   	push   %ebp
c0103ca0:	89 e5                	mov    %esp,%ebp
c0103ca2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103ca5:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103caa:	8b 40 08             	mov    0x8(%eax),%eax
c0103cad:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103cb0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cb4:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cb7:	89 14 24             	mov    %edx,(%esp)
c0103cba:	ff d0                	call   *%eax
}
c0103cbc:	c9                   	leave  
c0103cbd:	c3                   	ret    

c0103cbe <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103cbe:	55                   	push   %ebp
c0103cbf:	89 e5                	mov    %esp,%ebp
c0103cc1:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103cc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103ccb:	e8 2e fe ff ff       	call   c0103afe <__intr_save>
c0103cd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103cd3:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cd8:	8b 40 0c             	mov    0xc(%eax),%eax
c0103cdb:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cde:	89 14 24             	mov    %edx,(%esp)
c0103ce1:	ff d0                	call   *%eax
c0103ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ce9:	89 04 24             	mov    %eax,(%esp)
c0103cec:	e8 37 fe ff ff       	call   c0103b28 <__intr_restore>
    return page;
c0103cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103cf4:	c9                   	leave  
c0103cf5:	c3                   	ret    

c0103cf6 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103cf6:	55                   	push   %ebp
c0103cf7:	89 e5                	mov    %esp,%ebp
c0103cf9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103cfc:	e8 fd fd ff ff       	call   c0103afe <__intr_save>
c0103d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d04:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d09:	8b 40 10             	mov    0x10(%eax),%eax
c0103d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d0f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d13:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d16:	89 14 24             	mov    %edx,(%esp)
c0103d19:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d1e:	89 04 24             	mov    %eax,(%esp)
c0103d21:	e8 02 fe ff ff       	call   c0103b28 <__intr_restore>
}
c0103d26:	c9                   	leave  
c0103d27:	c3                   	ret    

c0103d28 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d28:	55                   	push   %ebp
c0103d29:	89 e5                	mov    %esp,%ebp
c0103d2b:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d2e:	e8 cb fd ff ff       	call   c0103afe <__intr_save>
c0103d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103d36:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d3b:	8b 40 14             	mov    0x14(%eax),%eax
c0103d3e:	ff d0                	call   *%eax
c0103d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d46:	89 04 24             	mov    %eax,(%esp)
c0103d49:	e8 da fd ff ff       	call   c0103b28 <__intr_restore>
    return ret;
c0103d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103d51:	c9                   	leave  
c0103d52:	c3                   	ret    

c0103d53 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103d53:	55                   	push   %ebp
c0103d54:	89 e5                	mov    %esp,%ebp
c0103d56:	57                   	push   %edi
c0103d57:	56                   	push   %esi
c0103d58:	53                   	push   %ebx
c0103d59:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103d5f:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103d66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103d6d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103d74:	c7 04 24 e3 68 10 c0 	movl   $0xc01068e3,(%esp)
c0103d7b:	e8 bc c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103d80:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103d87:	e9 15 01 00 00       	jmp    c0103ea1 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103d8c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d92:	89 d0                	mov    %edx,%eax
c0103d94:	c1 e0 02             	shl    $0x2,%eax
c0103d97:	01 d0                	add    %edx,%eax
c0103d99:	c1 e0 02             	shl    $0x2,%eax
c0103d9c:	01 c8                	add    %ecx,%eax
c0103d9e:	8b 50 08             	mov    0x8(%eax),%edx
c0103da1:	8b 40 04             	mov    0x4(%eax),%eax
c0103da4:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103da7:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103daa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dad:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103db0:	89 d0                	mov    %edx,%eax
c0103db2:	c1 e0 02             	shl    $0x2,%eax
c0103db5:	01 d0                	add    %edx,%eax
c0103db7:	c1 e0 02             	shl    $0x2,%eax
c0103dba:	01 c8                	add    %ecx,%eax
c0103dbc:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103dbf:	8b 58 10             	mov    0x10(%eax),%ebx
c0103dc2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103dc5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103dc8:	01 c8                	add    %ecx,%eax
c0103dca:	11 da                	adc    %ebx,%edx
c0103dcc:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103dcf:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103dd2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dd5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dd8:	89 d0                	mov    %edx,%eax
c0103dda:	c1 e0 02             	shl    $0x2,%eax
c0103ddd:	01 d0                	add    %edx,%eax
c0103ddf:	c1 e0 02             	shl    $0x2,%eax
c0103de2:	01 c8                	add    %ecx,%eax
c0103de4:	83 c0 14             	add    $0x14,%eax
c0103de7:	8b 00                	mov    (%eax),%eax
c0103de9:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103def:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103df2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103df5:	83 c0 ff             	add    $0xffffffff,%eax
c0103df8:	83 d2 ff             	adc    $0xffffffff,%edx
c0103dfb:	89 c6                	mov    %eax,%esi
c0103dfd:	89 d7                	mov    %edx,%edi
c0103dff:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e02:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e05:	89 d0                	mov    %edx,%eax
c0103e07:	c1 e0 02             	shl    $0x2,%eax
c0103e0a:	01 d0                	add    %edx,%eax
c0103e0c:	c1 e0 02             	shl    $0x2,%eax
c0103e0f:	01 c8                	add    %ecx,%eax
c0103e11:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e14:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e17:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e1d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e21:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e25:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e29:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e2c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e33:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103e37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103e3f:	c7 04 24 f0 68 10 c0 	movl   $0xc01068f0,(%esp)
c0103e46:	e8 f1 c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103e4b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e51:	89 d0                	mov    %edx,%eax
c0103e53:	c1 e0 02             	shl    $0x2,%eax
c0103e56:	01 d0                	add    %edx,%eax
c0103e58:	c1 e0 02             	shl    $0x2,%eax
c0103e5b:	01 c8                	add    %ecx,%eax
c0103e5d:	83 c0 14             	add    $0x14,%eax
c0103e60:	8b 00                	mov    (%eax),%eax
c0103e62:	83 f8 01             	cmp    $0x1,%eax
c0103e65:	75 36                	jne    c0103e9d <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103e67:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e6d:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e70:	77 2b                	ja     c0103e9d <page_init+0x14a>
c0103e72:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e75:	72 05                	jb     c0103e7c <page_init+0x129>
c0103e77:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103e7a:	73 21                	jae    c0103e9d <page_init+0x14a>
c0103e7c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e80:	77 1b                	ja     c0103e9d <page_init+0x14a>
c0103e82:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e86:	72 09                	jb     c0103e91 <page_init+0x13e>
c0103e88:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103e8f:	77 0c                	ja     c0103e9d <page_init+0x14a>
                maxpa = end;
c0103e91:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e94:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e97:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103e9a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e9d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103ea1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103ea4:	8b 00                	mov    (%eax),%eax
c0103ea6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103ea9:	0f 8f dd fe ff ff    	jg     c0103d8c <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103eaf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103eb3:	72 1d                	jb     c0103ed2 <page_init+0x17f>
c0103eb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103eb9:	77 09                	ja     c0103ec4 <page_init+0x171>
c0103ebb:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103ec2:	76 0e                	jbe    c0103ed2 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103ec4:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103ecb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103ed2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ed5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ed8:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103edc:	c1 ea 0c             	shr    $0xc,%edx
c0103edf:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103ee4:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103eeb:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103ef0:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103ef3:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103ef6:	01 d0                	add    %edx,%eax
c0103ef8:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103efb:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103efe:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f03:	f7 75 ac             	divl   -0x54(%ebp)
c0103f06:	89 d0                	mov    %edx,%eax
c0103f08:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f0b:	29 c2                	sub    %eax,%edx
c0103f0d:	89 d0                	mov    %edx,%eax
c0103f0f:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103f14:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f1b:	eb 2f                	jmp    c0103f4c <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f1d:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103f23:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f26:	89 d0                	mov    %edx,%eax
c0103f28:	c1 e0 02             	shl    $0x2,%eax
c0103f2b:	01 d0                	add    %edx,%eax
c0103f2d:	c1 e0 02             	shl    $0x2,%eax
c0103f30:	01 c8                	add    %ecx,%eax
c0103f32:	83 c0 04             	add    $0x4,%eax
c0103f35:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103f3c:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103f3f:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103f42:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103f45:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103f48:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f4f:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103f54:	39 c2                	cmp    %eax,%edx
c0103f56:	72 c5                	jb     c0103f1d <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103f58:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103f5e:	89 d0                	mov    %edx,%eax
c0103f60:	c1 e0 02             	shl    $0x2,%eax
c0103f63:	01 d0                	add    %edx,%eax
c0103f65:	c1 e0 02             	shl    $0x2,%eax
c0103f68:	89 c2                	mov    %eax,%edx
c0103f6a:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103f6f:	01 d0                	add    %edx,%eax
c0103f71:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103f74:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103f7b:	77 23                	ja     c0103fa0 <page_init+0x24d>
c0103f7d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f80:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f84:	c7 44 24 08 20 69 10 	movl   $0xc0106920,0x8(%esp)
c0103f8b:	c0 
c0103f8c:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103f93:	00 
c0103f94:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0103f9b:	e8 26 cd ff ff       	call   c0100cc6 <__panic>
c0103fa0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fa3:	05 00 00 00 40       	add    $0x40000000,%eax
c0103fa8:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103fab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fb2:	e9 74 01 00 00       	jmp    c010412b <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103fb7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fba:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fbd:	89 d0                	mov    %edx,%eax
c0103fbf:	c1 e0 02             	shl    $0x2,%eax
c0103fc2:	01 d0                	add    %edx,%eax
c0103fc4:	c1 e0 02             	shl    $0x2,%eax
c0103fc7:	01 c8                	add    %ecx,%eax
c0103fc9:	8b 50 08             	mov    0x8(%eax),%edx
c0103fcc:	8b 40 04             	mov    0x4(%eax),%eax
c0103fcf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103fd2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103fd5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fd8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fdb:	89 d0                	mov    %edx,%eax
c0103fdd:	c1 e0 02             	shl    $0x2,%eax
c0103fe0:	01 d0                	add    %edx,%eax
c0103fe2:	c1 e0 02             	shl    $0x2,%eax
c0103fe5:	01 c8                	add    %ecx,%eax
c0103fe7:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103fea:	8b 58 10             	mov    0x10(%eax),%ebx
c0103fed:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103ff0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103ff3:	01 c8                	add    %ecx,%eax
c0103ff5:	11 da                	adc    %ebx,%edx
c0103ff7:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103ffa:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103ffd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104000:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104003:	89 d0                	mov    %edx,%eax
c0104005:	c1 e0 02             	shl    $0x2,%eax
c0104008:	01 d0                	add    %edx,%eax
c010400a:	c1 e0 02             	shl    $0x2,%eax
c010400d:	01 c8                	add    %ecx,%eax
c010400f:	83 c0 14             	add    $0x14,%eax
c0104012:	8b 00                	mov    (%eax),%eax
c0104014:	83 f8 01             	cmp    $0x1,%eax
c0104017:	0f 85 0a 01 00 00    	jne    c0104127 <page_init+0x3d4>
            if (begin < freemem) {
c010401d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104020:	ba 00 00 00 00       	mov    $0x0,%edx
c0104025:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104028:	72 17                	jb     c0104041 <page_init+0x2ee>
c010402a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010402d:	77 05                	ja     c0104034 <page_init+0x2e1>
c010402f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104032:	76 0d                	jbe    c0104041 <page_init+0x2ee>
                begin = freemem;
c0104034:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104037:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010403a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104041:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104045:	72 1d                	jb     c0104064 <page_init+0x311>
c0104047:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010404b:	77 09                	ja     c0104056 <page_init+0x303>
c010404d:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104054:	76 0e                	jbe    c0104064 <page_init+0x311>
                end = KMEMSIZE;
c0104056:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010405d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104064:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104067:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010406a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010406d:	0f 87 b4 00 00 00    	ja     c0104127 <page_init+0x3d4>
c0104073:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104076:	72 09                	jb     c0104081 <page_init+0x32e>
c0104078:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010407b:	0f 83 a6 00 00 00    	jae    c0104127 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104081:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104088:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010408b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010408e:	01 d0                	add    %edx,%eax
c0104090:	83 e8 01             	sub    $0x1,%eax
c0104093:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104096:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104099:	ba 00 00 00 00       	mov    $0x0,%edx
c010409e:	f7 75 9c             	divl   -0x64(%ebp)
c01040a1:	89 d0                	mov    %edx,%eax
c01040a3:	8b 55 98             	mov    -0x68(%ebp),%edx
c01040a6:	29 c2                	sub    %eax,%edx
c01040a8:	89 d0                	mov    %edx,%eax
c01040aa:	ba 00 00 00 00       	mov    $0x0,%edx
c01040af:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01040b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040b8:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01040bb:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01040be:	ba 00 00 00 00       	mov    $0x0,%edx
c01040c3:	89 c7                	mov    %eax,%edi
c01040c5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01040cb:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01040ce:	89 d0                	mov    %edx,%eax
c01040d0:	83 e0 00             	and    $0x0,%eax
c01040d3:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01040d6:	8b 45 80             	mov    -0x80(%ebp),%eax
c01040d9:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01040dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01040df:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01040e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040e8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040eb:	77 3a                	ja     c0104127 <page_init+0x3d4>
c01040ed:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040f0:	72 05                	jb     c01040f7 <page_init+0x3a4>
c01040f2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040f5:	73 30                	jae    c0104127 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01040f7:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01040fa:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01040fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104100:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104103:	29 c8                	sub    %ecx,%eax
c0104105:	19 da                	sbb    %ebx,%edx
c0104107:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010410b:	c1 ea 0c             	shr    $0xc,%edx
c010410e:	89 c3                	mov    %eax,%ebx
c0104110:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104113:	89 04 24             	mov    %eax,(%esp)
c0104116:	e8 ca f8 ff ff       	call   c01039e5 <pa2page>
c010411b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010411f:	89 04 24             	mov    %eax,(%esp)
c0104122:	e8 78 fb ff ff       	call   c0103c9f <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104127:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010412b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010412e:	8b 00                	mov    (%eax),%eax
c0104130:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104133:	0f 8f 7e fe ff ff    	jg     c0103fb7 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104139:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010413f:	5b                   	pop    %ebx
c0104140:	5e                   	pop    %esi
c0104141:	5f                   	pop    %edi
c0104142:	5d                   	pop    %ebp
c0104143:	c3                   	ret    

c0104144 <enable_paging>:

static void
enable_paging(void) {
c0104144:	55                   	push   %ebp
c0104145:	89 e5                	mov    %esp,%ebp
c0104147:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010414a:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c010414f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104152:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104155:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104158:	0f 20 c0             	mov    %cr0,%eax
c010415b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c010415e:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104161:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104164:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010416b:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c010416f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104172:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104175:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104178:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010417b:	c9                   	leave  
c010417c:	c3                   	ret    

c010417d <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010417d:	55                   	push   %ebp
c010417e:	89 e5                	mov    %esp,%ebp
c0104180:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104183:	8b 45 14             	mov    0x14(%ebp),%eax
c0104186:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104189:	31 d0                	xor    %edx,%eax
c010418b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104190:	85 c0                	test   %eax,%eax
c0104192:	74 24                	je     c01041b8 <boot_map_segment+0x3b>
c0104194:	c7 44 24 0c 52 69 10 	movl   $0xc0106952,0xc(%esp)
c010419b:	c0 
c010419c:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c01041a3:	c0 
c01041a4:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01041ab:	00 
c01041ac:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c01041b3:	e8 0e cb ff ff       	call   c0100cc6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01041b8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01041bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041c2:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041c7:	89 c2                	mov    %eax,%edx
c01041c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01041cc:	01 c2                	add    %eax,%edx
c01041ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041d1:	01 d0                	add    %edx,%eax
c01041d3:	83 e8 01             	sub    $0x1,%eax
c01041d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01041d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041dc:	ba 00 00 00 00       	mov    $0x0,%edx
c01041e1:	f7 75 f0             	divl   -0x10(%ebp)
c01041e4:	89 d0                	mov    %edx,%eax
c01041e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01041e9:	29 c2                	sub    %eax,%edx
c01041eb:	89 d0                	mov    %edx,%eax
c01041ed:	c1 e8 0c             	shr    $0xc,%eax
c01041f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01041f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01041f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104201:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104204:	8b 45 14             	mov    0x14(%ebp),%eax
c0104207:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010420a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010420d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104212:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104215:	eb 6b                	jmp    c0104282 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104217:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010421e:	00 
c010421f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104222:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104226:	8b 45 08             	mov    0x8(%ebp),%eax
c0104229:	89 04 24             	mov    %eax,(%esp)
c010422c:	e8 cc 01 00 00       	call   c01043fd <get_pte>
c0104231:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104234:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104238:	75 24                	jne    c010425e <boot_map_segment+0xe1>
c010423a:	c7 44 24 0c 7e 69 10 	movl   $0xc010697e,0xc(%esp)
c0104241:	c0 
c0104242:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104249:	c0 
c010424a:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104251:	00 
c0104252:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104259:	e8 68 ca ff ff       	call   c0100cc6 <__panic>
        *ptep = pa | PTE_P | perm;
c010425e:	8b 45 18             	mov    0x18(%ebp),%eax
c0104261:	8b 55 14             	mov    0x14(%ebp),%edx
c0104264:	09 d0                	or     %edx,%eax
c0104266:	83 c8 01             	or     $0x1,%eax
c0104269:	89 c2                	mov    %eax,%edx
c010426b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010426e:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104270:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104274:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010427b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104286:	75 8f                	jne    c0104217 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104288:	c9                   	leave  
c0104289:	c3                   	ret    

c010428a <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010428a:	55                   	push   %ebp
c010428b:	89 e5                	mov    %esp,%ebp
c010428d:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104297:	e8 22 fa ff ff       	call   c0103cbe <alloc_pages>
c010429c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010429f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042a3:	75 1c                	jne    c01042c1 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01042a5:	c7 44 24 08 8b 69 10 	movl   $0xc010698b,0x8(%esp)
c01042ac:	c0 
c01042ad:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01042b4:	00 
c01042b5:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c01042bc:	e8 05 ca ff ff       	call   c0100cc6 <__panic>
    }
    return page2kva(p);
c01042c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042c4:	89 04 24             	mov    %eax,(%esp)
c01042c7:	e8 68 f7 ff ff       	call   c0103a34 <page2kva>
}
c01042cc:	c9                   	leave  
c01042cd:	c3                   	ret    

c01042ce <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01042ce:	55                   	push   %ebp
c01042cf:	89 e5                	mov    %esp,%ebp
c01042d1:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01042d4:	e8 93 f9 ff ff       	call   c0103c6c <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01042d9:	e8 75 fa ff ff       	call   c0103d53 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01042de:	e8 d7 02 00 00       	call   c01045ba <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01042e3:	e8 a2 ff ff ff       	call   c010428a <boot_alloc_page>
c01042e8:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c01042ed:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042f2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01042f9:	00 
c01042fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104301:	00 
c0104302:	89 04 24             	mov    %eax,(%esp)
c0104305:	e8 19 19 00 00       	call   c0105c23 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010430a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010430f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104312:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104319:	77 23                	ja     c010433e <pmm_init+0x70>
c010431b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010431e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104322:	c7 44 24 08 20 69 10 	movl   $0xc0106920,0x8(%esp)
c0104329:	c0 
c010432a:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104331:	00 
c0104332:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104339:	e8 88 c9 ff ff       	call   c0100cc6 <__panic>
c010433e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104341:	05 00 00 00 40       	add    $0x40000000,%eax
c0104346:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c010434b:	e8 88 02 00 00       	call   c01045d8 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104350:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104355:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010435b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104360:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104363:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010436a:	77 23                	ja     c010438f <pmm_init+0xc1>
c010436c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010436f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104373:	c7 44 24 08 20 69 10 	movl   $0xc0106920,0x8(%esp)
c010437a:	c0 
c010437b:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104382:	00 
c0104383:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c010438a:	e8 37 c9 ff ff       	call   c0100cc6 <__panic>
c010438f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104392:	05 00 00 00 40       	add    $0x40000000,%eax
c0104397:	83 c8 03             	or     $0x3,%eax
c010439a:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010439c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043a1:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01043a8:	00 
c01043a9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01043b0:	00 
c01043b1:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01043b8:	38 
c01043b9:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01043c0:	c0 
c01043c1:	89 04 24             	mov    %eax,(%esp)
c01043c4:	e8 b4 fd ff ff       	call   c010417d <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01043c9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043ce:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c01043d4:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01043da:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01043dc:	e8 63 fd ff ff       	call   c0104144 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01043e1:	e8 97 f7 ff ff       	call   c0103b7d <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01043e6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01043f1:	e8 7d 08 00 00       	call   c0104c73 <check_boot_pgdir>

    print_pgdir();
c01043f6:	e8 0a 0d 00 00       	call   c0105105 <print_pgdir>

}
c01043fb:	c9                   	leave  
c01043fc:	c3                   	ret    

c01043fd <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01043fd:	55                   	push   %ebp
c01043fe:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c0104400:	5d                   	pop    %ebp
c0104401:	c3                   	ret    

c0104402 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104402:	55                   	push   %ebp
c0104403:	89 e5                	mov    %esp,%ebp
c0104405:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104408:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010440f:	00 
c0104410:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104413:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104417:	8b 45 08             	mov    0x8(%ebp),%eax
c010441a:	89 04 24             	mov    %eax,(%esp)
c010441d:	e8 db ff ff ff       	call   c01043fd <get_pte>
c0104422:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104425:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104429:	74 08                	je     c0104433 <get_page+0x31>
        *ptep_store = ptep;
c010442b:	8b 45 10             	mov    0x10(%ebp),%eax
c010442e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104431:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104433:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104437:	74 1b                	je     c0104454 <get_page+0x52>
c0104439:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010443c:	8b 00                	mov    (%eax),%eax
c010443e:	83 e0 01             	and    $0x1,%eax
c0104441:	85 c0                	test   %eax,%eax
c0104443:	74 0f                	je     c0104454 <get_page+0x52>
        return pa2page(*ptep);
c0104445:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104448:	8b 00                	mov    (%eax),%eax
c010444a:	89 04 24             	mov    %eax,(%esp)
c010444d:	e8 93 f5 ff ff       	call   c01039e5 <pa2page>
c0104452:	eb 05                	jmp    c0104459 <get_page+0x57>
    }
    return NULL;
c0104454:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104459:	c9                   	leave  
c010445a:	c3                   	ret    

c010445b <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010445b:	55                   	push   %ebp
c010445c:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c010445e:	5d                   	pop    %ebp
c010445f:	c3                   	ret    

c0104460 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104460:	55                   	push   %ebp
c0104461:	89 e5                	mov    %esp,%ebp
c0104463:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104466:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010446d:	00 
c010446e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104471:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104475:	8b 45 08             	mov    0x8(%ebp),%eax
c0104478:	89 04 24             	mov    %eax,(%esp)
c010447b:	e8 7d ff ff ff       	call   c01043fd <get_pte>
c0104480:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c0104483:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0104487:	74 19                	je     c01044a2 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104489:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010448c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104490:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104493:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104497:	8b 45 08             	mov    0x8(%ebp),%eax
c010449a:	89 04 24             	mov    %eax,(%esp)
c010449d:	e8 b9 ff ff ff       	call   c010445b <page_remove_pte>
    }
}
c01044a2:	c9                   	leave  
c01044a3:	c3                   	ret    

c01044a4 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01044a4:	55                   	push   %ebp
c01044a5:	89 e5                	mov    %esp,%ebp
c01044a7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01044aa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01044b1:	00 
c01044b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01044b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01044bc:	89 04 24             	mov    %eax,(%esp)
c01044bf:	e8 39 ff ff ff       	call   c01043fd <get_pte>
c01044c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01044c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044cb:	75 0a                	jne    c01044d7 <page_insert+0x33>
        return -E_NO_MEM;
c01044cd:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01044d2:	e9 84 00 00 00       	jmp    c010455b <page_insert+0xb7>
    }
    page_ref_inc(page);
c01044d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044da:	89 04 24             	mov    %eax,(%esp)
c01044dd:	e8 ee f5 ff ff       	call   c0103ad0 <page_ref_inc>
    if (*ptep & PTE_P) {
c01044e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e5:	8b 00                	mov    (%eax),%eax
c01044e7:	83 e0 01             	and    $0x1,%eax
c01044ea:	85 c0                	test   %eax,%eax
c01044ec:	74 3e                	je     c010452c <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01044ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044f1:	8b 00                	mov    (%eax),%eax
c01044f3:	89 04 24             	mov    %eax,(%esp)
c01044f6:	e8 8d f5 ff ff       	call   c0103a88 <pte2page>
c01044fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01044fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104501:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104504:	75 0d                	jne    c0104513 <page_insert+0x6f>
            page_ref_dec(page);
c0104506:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104509:	89 04 24             	mov    %eax,(%esp)
c010450c:	e8 d6 f5 ff ff       	call   c0103ae7 <page_ref_dec>
c0104511:	eb 19                	jmp    c010452c <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104513:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104516:	89 44 24 08          	mov    %eax,0x8(%esp)
c010451a:	8b 45 10             	mov    0x10(%ebp),%eax
c010451d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104521:	8b 45 08             	mov    0x8(%ebp),%eax
c0104524:	89 04 24             	mov    %eax,(%esp)
c0104527:	e8 2f ff ff ff       	call   c010445b <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010452c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010452f:	89 04 24             	mov    %eax,(%esp)
c0104532:	e8 98 f4 ff ff       	call   c01039cf <page2pa>
c0104537:	0b 45 14             	or     0x14(%ebp),%eax
c010453a:	83 c8 01             	or     $0x1,%eax
c010453d:	89 c2                	mov    %eax,%edx
c010453f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104542:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104544:	8b 45 10             	mov    0x10(%ebp),%eax
c0104547:	89 44 24 04          	mov    %eax,0x4(%esp)
c010454b:	8b 45 08             	mov    0x8(%ebp),%eax
c010454e:	89 04 24             	mov    %eax,(%esp)
c0104551:	e8 07 00 00 00       	call   c010455d <tlb_invalidate>
    return 0;
c0104556:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010455b:	c9                   	leave  
c010455c:	c3                   	ret    

c010455d <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010455d:	55                   	push   %ebp
c010455e:	89 e5                	mov    %esp,%ebp
c0104560:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104563:	0f 20 d8             	mov    %cr3,%eax
c0104566:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104569:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c010456c:	89 c2                	mov    %eax,%edx
c010456e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104571:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104574:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010457b:	77 23                	ja     c01045a0 <tlb_invalidate+0x43>
c010457d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104580:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104584:	c7 44 24 08 20 69 10 	movl   $0xc0106920,0x8(%esp)
c010458b:	c0 
c010458c:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
c0104593:	00 
c0104594:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c010459b:	e8 26 c7 ff ff       	call   c0100cc6 <__panic>
c01045a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a3:	05 00 00 00 40       	add    $0x40000000,%eax
c01045a8:	39 c2                	cmp    %eax,%edx
c01045aa:	75 0c                	jne    c01045b8 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01045ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045af:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01045b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045b5:	0f 01 38             	invlpg (%eax)
    }
}
c01045b8:	c9                   	leave  
c01045b9:	c3                   	ret    

c01045ba <check_alloc_page>:

static void
check_alloc_page(void) {
c01045ba:	55                   	push   %ebp
c01045bb:	89 e5                	mov    %esp,%ebp
c01045bd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01045c0:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c01045c5:	8b 40 18             	mov    0x18(%eax),%eax
c01045c8:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01045ca:	c7 04 24 a4 69 10 c0 	movl   $0xc01069a4,(%esp)
c01045d1:	e8 66 bd ff ff       	call   c010033c <cprintf>
}
c01045d6:	c9                   	leave  
c01045d7:	c3                   	ret    

c01045d8 <check_pgdir>:

static void
check_pgdir(void) {
c01045d8:	55                   	push   %ebp
c01045d9:	89 e5                	mov    %esp,%ebp
c01045db:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01045de:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01045e3:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01045e8:	76 24                	jbe    c010460e <check_pgdir+0x36>
c01045ea:	c7 44 24 0c c3 69 10 	movl   $0xc01069c3,0xc(%esp)
c01045f1:	c0 
c01045f2:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c01045f9:	c0 
c01045fa:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0104601:	00 
c0104602:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104609:	e8 b8 c6 ff ff       	call   c0100cc6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010460e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104613:	85 c0                	test   %eax,%eax
c0104615:	74 0e                	je     c0104625 <check_pgdir+0x4d>
c0104617:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010461c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104621:	85 c0                	test   %eax,%eax
c0104623:	74 24                	je     c0104649 <check_pgdir+0x71>
c0104625:	c7 44 24 0c e0 69 10 	movl   $0xc01069e0,0xc(%esp)
c010462c:	c0 
c010462d:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104634:	c0 
c0104635:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c010463c:	00 
c010463d:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104644:	e8 7d c6 ff ff       	call   c0100cc6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104649:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010464e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104655:	00 
c0104656:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010465d:	00 
c010465e:	89 04 24             	mov    %eax,(%esp)
c0104661:	e8 9c fd ff ff       	call   c0104402 <get_page>
c0104666:	85 c0                	test   %eax,%eax
c0104668:	74 24                	je     c010468e <check_pgdir+0xb6>
c010466a:	c7 44 24 0c 18 6a 10 	movl   $0xc0106a18,0xc(%esp)
c0104671:	c0 
c0104672:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104679:	c0 
c010467a:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c0104681:	00 
c0104682:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104689:	e8 38 c6 ff ff       	call   c0100cc6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010468e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104695:	e8 24 f6 ff ff       	call   c0103cbe <alloc_pages>
c010469a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010469d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01046a2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01046a9:	00 
c01046aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046b1:	00 
c01046b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01046b5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01046b9:	89 04 24             	mov    %eax,(%esp)
c01046bc:	e8 e3 fd ff ff       	call   c01044a4 <page_insert>
c01046c1:	85 c0                	test   %eax,%eax
c01046c3:	74 24                	je     c01046e9 <check_pgdir+0x111>
c01046c5:	c7 44 24 0c 40 6a 10 	movl   $0xc0106a40,0xc(%esp)
c01046cc:	c0 
c01046cd:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c01046d4:	c0 
c01046d5:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c01046dc:	00 
c01046dd:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c01046e4:	e8 dd c5 ff ff       	call   c0100cc6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01046e9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01046ee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046f5:	00 
c01046f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046fd:	00 
c01046fe:	89 04 24             	mov    %eax,(%esp)
c0104701:	e8 f7 fc ff ff       	call   c01043fd <get_pte>
c0104706:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104709:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010470d:	75 24                	jne    c0104733 <check_pgdir+0x15b>
c010470f:	c7 44 24 0c 6c 6a 10 	movl   $0xc0106a6c,0xc(%esp)
c0104716:	c0 
c0104717:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c010471e:	c0 
c010471f:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0104726:	00 
c0104727:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c010472e:	e8 93 c5 ff ff       	call   c0100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
c0104733:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104736:	8b 00                	mov    (%eax),%eax
c0104738:	89 04 24             	mov    %eax,(%esp)
c010473b:	e8 a5 f2 ff ff       	call   c01039e5 <pa2page>
c0104740:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104743:	74 24                	je     c0104769 <check_pgdir+0x191>
c0104745:	c7 44 24 0c 99 6a 10 	movl   $0xc0106a99,0xc(%esp)
c010474c:	c0 
c010474d:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104754:	c0 
c0104755:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c010475c:	00 
c010475d:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104764:	e8 5d c5 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p1) == 1);
c0104769:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010476c:	89 04 24             	mov    %eax,(%esp)
c010476f:	e8 52 f3 ff ff       	call   c0103ac6 <page_ref>
c0104774:	83 f8 01             	cmp    $0x1,%eax
c0104777:	74 24                	je     c010479d <check_pgdir+0x1c5>
c0104779:	c7 44 24 0c ae 6a 10 	movl   $0xc0106aae,0xc(%esp)
c0104780:	c0 
c0104781:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104788:	c0 
c0104789:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0104790:	00 
c0104791:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104798:	e8 29 c5 ff ff       	call   c0100cc6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010479d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047a2:	8b 00                	mov    (%eax),%eax
c01047a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01047a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01047ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047af:	c1 e8 0c             	shr    $0xc,%eax
c01047b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01047b5:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01047ba:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01047bd:	72 23                	jb     c01047e2 <check_pgdir+0x20a>
c01047bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047c6:	c7 44 24 08 7c 68 10 	movl   $0xc010687c,0x8(%esp)
c01047cd:	c0 
c01047ce:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c01047d5:	00 
c01047d6:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c01047dd:	e8 e4 c4 ff ff       	call   c0100cc6 <__panic>
c01047e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047e5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01047ea:	83 c0 04             	add    $0x4,%eax
c01047ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01047f0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047f5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047fc:	00 
c01047fd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104804:	00 
c0104805:	89 04 24             	mov    %eax,(%esp)
c0104808:	e8 f0 fb ff ff       	call   c01043fd <get_pte>
c010480d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104810:	74 24                	je     c0104836 <check_pgdir+0x25e>
c0104812:	c7 44 24 0c c0 6a 10 	movl   $0xc0106ac0,0xc(%esp)
c0104819:	c0 
c010481a:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104821:	c0 
c0104822:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0104829:	00 
c010482a:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104831:	e8 90 c4 ff ff       	call   c0100cc6 <__panic>

    p2 = alloc_page();
c0104836:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010483d:	e8 7c f4 ff ff       	call   c0103cbe <alloc_pages>
c0104842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104845:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010484a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104851:	00 
c0104852:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104859:	00 
c010485a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010485d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104861:	89 04 24             	mov    %eax,(%esp)
c0104864:	e8 3b fc ff ff       	call   c01044a4 <page_insert>
c0104869:	85 c0                	test   %eax,%eax
c010486b:	74 24                	je     c0104891 <check_pgdir+0x2b9>
c010486d:	c7 44 24 0c e8 6a 10 	movl   $0xc0106ae8,0xc(%esp)
c0104874:	c0 
c0104875:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c010487c:	c0 
c010487d:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104884:	00 
c0104885:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c010488c:	e8 35 c4 ff ff       	call   c0100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104891:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104896:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010489d:	00 
c010489e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01048a5:	00 
c01048a6:	89 04 24             	mov    %eax,(%esp)
c01048a9:	e8 4f fb ff ff       	call   c01043fd <get_pte>
c01048ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048b5:	75 24                	jne    c01048db <check_pgdir+0x303>
c01048b7:	c7 44 24 0c 20 6b 10 	movl   $0xc0106b20,0xc(%esp)
c01048be:	c0 
c01048bf:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c01048c6:	c0 
c01048c7:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c01048ce:	00 
c01048cf:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c01048d6:	e8 eb c3 ff ff       	call   c0100cc6 <__panic>
    assert(*ptep & PTE_U);
c01048db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048de:	8b 00                	mov    (%eax),%eax
c01048e0:	83 e0 04             	and    $0x4,%eax
c01048e3:	85 c0                	test   %eax,%eax
c01048e5:	75 24                	jne    c010490b <check_pgdir+0x333>
c01048e7:	c7 44 24 0c 50 6b 10 	movl   $0xc0106b50,0xc(%esp)
c01048ee:	c0 
c01048ef:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c01048f6:	c0 
c01048f7:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c01048fe:	00 
c01048ff:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104906:	e8 bb c3 ff ff       	call   c0100cc6 <__panic>
    assert(*ptep & PTE_W);
c010490b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010490e:	8b 00                	mov    (%eax),%eax
c0104910:	83 e0 02             	and    $0x2,%eax
c0104913:	85 c0                	test   %eax,%eax
c0104915:	75 24                	jne    c010493b <check_pgdir+0x363>
c0104917:	c7 44 24 0c 5e 6b 10 	movl   $0xc0106b5e,0xc(%esp)
c010491e:	c0 
c010491f:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104926:	c0 
c0104927:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c010492e:	00 
c010492f:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104936:	e8 8b c3 ff ff       	call   c0100cc6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010493b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104940:	8b 00                	mov    (%eax),%eax
c0104942:	83 e0 04             	and    $0x4,%eax
c0104945:	85 c0                	test   %eax,%eax
c0104947:	75 24                	jne    c010496d <check_pgdir+0x395>
c0104949:	c7 44 24 0c 6c 6b 10 	movl   $0xc0106b6c,0xc(%esp)
c0104950:	c0 
c0104951:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104958:	c0 
c0104959:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0104960:	00 
c0104961:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104968:	e8 59 c3 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 1);
c010496d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104970:	89 04 24             	mov    %eax,(%esp)
c0104973:	e8 4e f1 ff ff       	call   c0103ac6 <page_ref>
c0104978:	83 f8 01             	cmp    $0x1,%eax
c010497b:	74 24                	je     c01049a1 <check_pgdir+0x3c9>
c010497d:	c7 44 24 0c 82 6b 10 	movl   $0xc0106b82,0xc(%esp)
c0104984:	c0 
c0104985:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c010498c:	c0 
c010498d:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0104994:	00 
c0104995:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c010499c:	e8 25 c3 ff ff       	call   c0100cc6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01049a1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049a6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01049ad:	00 
c01049ae:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01049b5:	00 
c01049b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01049b9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01049bd:	89 04 24             	mov    %eax,(%esp)
c01049c0:	e8 df fa ff ff       	call   c01044a4 <page_insert>
c01049c5:	85 c0                	test   %eax,%eax
c01049c7:	74 24                	je     c01049ed <check_pgdir+0x415>
c01049c9:	c7 44 24 0c 94 6b 10 	movl   $0xc0106b94,0xc(%esp)
c01049d0:	c0 
c01049d1:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c01049d8:	c0 
c01049d9:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c01049e0:	00 
c01049e1:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c01049e8:	e8 d9 c2 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p1) == 2);
c01049ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049f0:	89 04 24             	mov    %eax,(%esp)
c01049f3:	e8 ce f0 ff ff       	call   c0103ac6 <page_ref>
c01049f8:	83 f8 02             	cmp    $0x2,%eax
c01049fb:	74 24                	je     c0104a21 <check_pgdir+0x449>
c01049fd:	c7 44 24 0c c0 6b 10 	movl   $0xc0106bc0,0xc(%esp)
c0104a04:	c0 
c0104a05:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104a0c:	c0 
c0104a0d:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104a14:	00 
c0104a15:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104a1c:	e8 a5 c2 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a24:	89 04 24             	mov    %eax,(%esp)
c0104a27:	e8 9a f0 ff ff       	call   c0103ac6 <page_ref>
c0104a2c:	85 c0                	test   %eax,%eax
c0104a2e:	74 24                	je     c0104a54 <check_pgdir+0x47c>
c0104a30:	c7 44 24 0c d2 6b 10 	movl   $0xc0106bd2,0xc(%esp)
c0104a37:	c0 
c0104a38:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104a3f:	c0 
c0104a40:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104a47:	00 
c0104a48:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104a4f:	e8 72 c2 ff ff       	call   c0100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a54:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a59:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a60:	00 
c0104a61:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a68:	00 
c0104a69:	89 04 24             	mov    %eax,(%esp)
c0104a6c:	e8 8c f9 ff ff       	call   c01043fd <get_pte>
c0104a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a78:	75 24                	jne    c0104a9e <check_pgdir+0x4c6>
c0104a7a:	c7 44 24 0c 20 6b 10 	movl   $0xc0106b20,0xc(%esp)
c0104a81:	c0 
c0104a82:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104a89:	c0 
c0104a8a:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104a91:	00 
c0104a92:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104a99:	e8 28 c2 ff ff       	call   c0100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
c0104a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aa1:	8b 00                	mov    (%eax),%eax
c0104aa3:	89 04 24             	mov    %eax,(%esp)
c0104aa6:	e8 3a ef ff ff       	call   c01039e5 <pa2page>
c0104aab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104aae:	74 24                	je     c0104ad4 <check_pgdir+0x4fc>
c0104ab0:	c7 44 24 0c 99 6a 10 	movl   $0xc0106a99,0xc(%esp)
c0104ab7:	c0 
c0104ab8:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104abf:	c0 
c0104ac0:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104ac7:	00 
c0104ac8:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104acf:	e8 f2 c1 ff ff       	call   c0100cc6 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ad7:	8b 00                	mov    (%eax),%eax
c0104ad9:	83 e0 04             	and    $0x4,%eax
c0104adc:	85 c0                	test   %eax,%eax
c0104ade:	74 24                	je     c0104b04 <check_pgdir+0x52c>
c0104ae0:	c7 44 24 0c e4 6b 10 	movl   $0xc0106be4,0xc(%esp)
c0104ae7:	c0 
c0104ae8:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104aef:	c0 
c0104af0:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0104af7:	00 
c0104af8:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104aff:	e8 c2 c1 ff ff       	call   c0100cc6 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104b04:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b09:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b10:	00 
c0104b11:	89 04 24             	mov    %eax,(%esp)
c0104b14:	e8 47 f9 ff ff       	call   c0104460 <page_remove>
    assert(page_ref(p1) == 1);
c0104b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b1c:	89 04 24             	mov    %eax,(%esp)
c0104b1f:	e8 a2 ef ff ff       	call   c0103ac6 <page_ref>
c0104b24:	83 f8 01             	cmp    $0x1,%eax
c0104b27:	74 24                	je     c0104b4d <check_pgdir+0x575>
c0104b29:	c7 44 24 0c ae 6a 10 	movl   $0xc0106aae,0xc(%esp)
c0104b30:	c0 
c0104b31:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104b38:	c0 
c0104b39:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104b40:	00 
c0104b41:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104b48:	e8 79 c1 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b50:	89 04 24             	mov    %eax,(%esp)
c0104b53:	e8 6e ef ff ff       	call   c0103ac6 <page_ref>
c0104b58:	85 c0                	test   %eax,%eax
c0104b5a:	74 24                	je     c0104b80 <check_pgdir+0x5a8>
c0104b5c:	c7 44 24 0c d2 6b 10 	movl   $0xc0106bd2,0xc(%esp)
c0104b63:	c0 
c0104b64:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104b6b:	c0 
c0104b6c:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104b73:	00 
c0104b74:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104b7b:	e8 46 c1 ff ff       	call   c0100cc6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104b80:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b85:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b8c:	00 
c0104b8d:	89 04 24             	mov    %eax,(%esp)
c0104b90:	e8 cb f8 ff ff       	call   c0104460 <page_remove>
    assert(page_ref(p1) == 0);
c0104b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b98:	89 04 24             	mov    %eax,(%esp)
c0104b9b:	e8 26 ef ff ff       	call   c0103ac6 <page_ref>
c0104ba0:	85 c0                	test   %eax,%eax
c0104ba2:	74 24                	je     c0104bc8 <check_pgdir+0x5f0>
c0104ba4:	c7 44 24 0c f9 6b 10 	movl   $0xc0106bf9,0xc(%esp)
c0104bab:	c0 
c0104bac:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104bb3:	c0 
c0104bb4:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104bbb:	00 
c0104bbc:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104bc3:	e8 fe c0 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104bc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bcb:	89 04 24             	mov    %eax,(%esp)
c0104bce:	e8 f3 ee ff ff       	call   c0103ac6 <page_ref>
c0104bd3:	85 c0                	test   %eax,%eax
c0104bd5:	74 24                	je     c0104bfb <check_pgdir+0x623>
c0104bd7:	c7 44 24 0c d2 6b 10 	movl   $0xc0106bd2,0xc(%esp)
c0104bde:	c0 
c0104bdf:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104be6:	c0 
c0104be7:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104bee:	00 
c0104bef:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104bf6:	e8 cb c0 ff ff       	call   c0100cc6 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104bfb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c00:	8b 00                	mov    (%eax),%eax
c0104c02:	89 04 24             	mov    %eax,(%esp)
c0104c05:	e8 db ed ff ff       	call   c01039e5 <pa2page>
c0104c0a:	89 04 24             	mov    %eax,(%esp)
c0104c0d:	e8 b4 ee ff ff       	call   c0103ac6 <page_ref>
c0104c12:	83 f8 01             	cmp    $0x1,%eax
c0104c15:	74 24                	je     c0104c3b <check_pgdir+0x663>
c0104c17:	c7 44 24 0c 0c 6c 10 	movl   $0xc0106c0c,0xc(%esp)
c0104c1e:	c0 
c0104c1f:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104c26:	c0 
c0104c27:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104c2e:	00 
c0104c2f:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104c36:	e8 8b c0 ff ff       	call   c0100cc6 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104c3b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c40:	8b 00                	mov    (%eax),%eax
c0104c42:	89 04 24             	mov    %eax,(%esp)
c0104c45:	e8 9b ed ff ff       	call   c01039e5 <pa2page>
c0104c4a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104c51:	00 
c0104c52:	89 04 24             	mov    %eax,(%esp)
c0104c55:	e8 9c f0 ff ff       	call   c0103cf6 <free_pages>
    boot_pgdir[0] = 0;
c0104c5a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104c65:	c7 04 24 32 6c 10 c0 	movl   $0xc0106c32,(%esp)
c0104c6c:	e8 cb b6 ff ff       	call   c010033c <cprintf>
}
c0104c71:	c9                   	leave  
c0104c72:	c3                   	ret    

c0104c73 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104c73:	55                   	push   %ebp
c0104c74:	89 e5                	mov    %esp,%ebp
c0104c76:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104c79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104c80:	e9 ca 00 00 00       	jmp    c0104d4f <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c8e:	c1 e8 0c             	shr    $0xc,%eax
c0104c91:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c94:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104c99:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104c9c:	72 23                	jb     c0104cc1 <check_boot_pgdir+0x4e>
c0104c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ca1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ca5:	c7 44 24 08 7c 68 10 	movl   $0xc010687c,0x8(%esp)
c0104cac:	c0 
c0104cad:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104cb4:	00 
c0104cb5:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104cbc:	e8 05 c0 ff ff       	call   c0100cc6 <__panic>
c0104cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cc4:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104cc9:	89 c2                	mov    %eax,%edx
c0104ccb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cd0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104cd7:	00 
c0104cd8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104cdc:	89 04 24             	mov    %eax,(%esp)
c0104cdf:	e8 19 f7 ff ff       	call   c01043fd <get_pte>
c0104ce4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ce7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104ceb:	75 24                	jne    c0104d11 <check_boot_pgdir+0x9e>
c0104ced:	c7 44 24 0c 4c 6c 10 	movl   $0xc0106c4c,0xc(%esp)
c0104cf4:	c0 
c0104cf5:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104cfc:	c0 
c0104cfd:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104d04:	00 
c0104d05:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104d0c:	e8 b5 bf ff ff       	call   c0100cc6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104d11:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d14:	8b 00                	mov    (%eax),%eax
c0104d16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d1b:	89 c2                	mov    %eax,%edx
c0104d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d20:	39 c2                	cmp    %eax,%edx
c0104d22:	74 24                	je     c0104d48 <check_boot_pgdir+0xd5>
c0104d24:	c7 44 24 0c 89 6c 10 	movl   $0xc0106c89,0xc(%esp)
c0104d2b:	c0 
c0104d2c:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104d33:	c0 
c0104d34:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104d3b:	00 
c0104d3c:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104d43:	e8 7e bf ff ff       	call   c0100cc6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104d48:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104d4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104d52:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104d57:	39 c2                	cmp    %eax,%edx
c0104d59:	0f 82 26 ff ff ff    	jb     c0104c85 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104d5f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d64:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104d69:	8b 00                	mov    (%eax),%eax
c0104d6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d70:	89 c2                	mov    %eax,%edx
c0104d72:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104d7a:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104d81:	77 23                	ja     c0104da6 <check_boot_pgdir+0x133>
c0104d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d86:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d8a:	c7 44 24 08 20 69 10 	movl   $0xc0106920,0x8(%esp)
c0104d91:	c0 
c0104d92:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104d99:	00 
c0104d9a:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104da1:	e8 20 bf ff ff       	call   c0100cc6 <__panic>
c0104da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104da9:	05 00 00 00 40       	add    $0x40000000,%eax
c0104dae:	39 c2                	cmp    %eax,%edx
c0104db0:	74 24                	je     c0104dd6 <check_boot_pgdir+0x163>
c0104db2:	c7 44 24 0c a0 6c 10 	movl   $0xc0106ca0,0xc(%esp)
c0104db9:	c0 
c0104dba:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104dc1:	c0 
c0104dc2:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104dc9:	00 
c0104dca:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104dd1:	e8 f0 be ff ff       	call   c0100cc6 <__panic>

    assert(boot_pgdir[0] == 0);
c0104dd6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ddb:	8b 00                	mov    (%eax),%eax
c0104ddd:	85 c0                	test   %eax,%eax
c0104ddf:	74 24                	je     c0104e05 <check_boot_pgdir+0x192>
c0104de1:	c7 44 24 0c d4 6c 10 	movl   $0xc0106cd4,0xc(%esp)
c0104de8:	c0 
c0104de9:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104df0:	c0 
c0104df1:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104df8:	00 
c0104df9:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104e00:	e8 c1 be ff ff       	call   c0100cc6 <__panic>

    struct Page *p;
    p = alloc_page();
c0104e05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e0c:	e8 ad ee ff ff       	call   c0103cbe <alloc_pages>
c0104e11:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104e14:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e19:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104e20:	00 
c0104e21:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104e28:	00 
c0104e29:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e2c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e30:	89 04 24             	mov    %eax,(%esp)
c0104e33:	e8 6c f6 ff ff       	call   c01044a4 <page_insert>
c0104e38:	85 c0                	test   %eax,%eax
c0104e3a:	74 24                	je     c0104e60 <check_boot_pgdir+0x1ed>
c0104e3c:	c7 44 24 0c e8 6c 10 	movl   $0xc0106ce8,0xc(%esp)
c0104e43:	c0 
c0104e44:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104e4b:	c0 
c0104e4c:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104e53:	00 
c0104e54:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104e5b:	e8 66 be ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p) == 1);
c0104e60:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e63:	89 04 24             	mov    %eax,(%esp)
c0104e66:	e8 5b ec ff ff       	call   c0103ac6 <page_ref>
c0104e6b:	83 f8 01             	cmp    $0x1,%eax
c0104e6e:	74 24                	je     c0104e94 <check_boot_pgdir+0x221>
c0104e70:	c7 44 24 0c 16 6d 10 	movl   $0xc0106d16,0xc(%esp)
c0104e77:	c0 
c0104e78:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104e7f:	c0 
c0104e80:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104e87:	00 
c0104e88:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104e8f:	e8 32 be ff ff       	call   c0100cc6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104e94:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e99:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104ea0:	00 
c0104ea1:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104ea8:	00 
c0104ea9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104eac:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104eb0:	89 04 24             	mov    %eax,(%esp)
c0104eb3:	e8 ec f5 ff ff       	call   c01044a4 <page_insert>
c0104eb8:	85 c0                	test   %eax,%eax
c0104eba:	74 24                	je     c0104ee0 <check_boot_pgdir+0x26d>
c0104ebc:	c7 44 24 0c 28 6d 10 	movl   $0xc0106d28,0xc(%esp)
c0104ec3:	c0 
c0104ec4:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104ecb:	c0 
c0104ecc:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104ed3:	00 
c0104ed4:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104edb:	e8 e6 bd ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p) == 2);
c0104ee0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ee3:	89 04 24             	mov    %eax,(%esp)
c0104ee6:	e8 db eb ff ff       	call   c0103ac6 <page_ref>
c0104eeb:	83 f8 02             	cmp    $0x2,%eax
c0104eee:	74 24                	je     c0104f14 <check_boot_pgdir+0x2a1>
c0104ef0:	c7 44 24 0c 5f 6d 10 	movl   $0xc0106d5f,0xc(%esp)
c0104ef7:	c0 
c0104ef8:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104eff:	c0 
c0104f00:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0104f07:	00 
c0104f08:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104f0f:	e8 b2 bd ff ff       	call   c0100cc6 <__panic>

    const char *str = "ucore: Hello world!!";
c0104f14:	c7 45 dc 70 6d 10 c0 	movl   $0xc0106d70,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104f1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f22:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f29:	e8 1e 0a 00 00       	call   c010594c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104f2e:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104f35:	00 
c0104f36:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f3d:	e8 83 0a 00 00       	call   c01059c5 <strcmp>
c0104f42:	85 c0                	test   %eax,%eax
c0104f44:	74 24                	je     c0104f6a <check_boot_pgdir+0x2f7>
c0104f46:	c7 44 24 0c 88 6d 10 	movl   $0xc0106d88,0xc(%esp)
c0104f4d:	c0 
c0104f4e:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104f55:	c0 
c0104f56:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0104f5d:	00 
c0104f5e:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104f65:	e8 5c bd ff ff       	call   c0100cc6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104f6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f6d:	89 04 24             	mov    %eax,(%esp)
c0104f70:	e8 bf ea ff ff       	call   c0103a34 <page2kva>
c0104f75:	05 00 01 00 00       	add    $0x100,%eax
c0104f7a:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104f7d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f84:	e8 6b 09 00 00       	call   c01058f4 <strlen>
c0104f89:	85 c0                	test   %eax,%eax
c0104f8b:	74 24                	je     c0104fb1 <check_boot_pgdir+0x33e>
c0104f8d:	c7 44 24 0c c0 6d 10 	movl   $0xc0106dc0,0xc(%esp)
c0104f94:	c0 
c0104f95:	c7 44 24 08 69 69 10 	movl   $0xc0106969,0x8(%esp)
c0104f9c:	c0 
c0104f9d:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104fa4:	00 
c0104fa5:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0104fac:	e8 15 bd ff ff       	call   c0100cc6 <__panic>

    free_page(p);
c0104fb1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fb8:	00 
c0104fb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fbc:	89 04 24             	mov    %eax,(%esp)
c0104fbf:	e8 32 ed ff ff       	call   c0103cf6 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0104fc4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fc9:	8b 00                	mov    (%eax),%eax
c0104fcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104fd0:	89 04 24             	mov    %eax,(%esp)
c0104fd3:	e8 0d ea ff ff       	call   c01039e5 <pa2page>
c0104fd8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fdf:	00 
c0104fe0:	89 04 24             	mov    %eax,(%esp)
c0104fe3:	e8 0e ed ff ff       	call   c0103cf6 <free_pages>
    boot_pgdir[0] = 0;
c0104fe8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104ff3:	c7 04 24 e4 6d 10 c0 	movl   $0xc0106de4,(%esp)
c0104ffa:	e8 3d b3 ff ff       	call   c010033c <cprintf>
}
c0104fff:	c9                   	leave  
c0105000:	c3                   	ret    

c0105001 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105001:	55                   	push   %ebp
c0105002:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105004:	8b 45 08             	mov    0x8(%ebp),%eax
c0105007:	83 e0 04             	and    $0x4,%eax
c010500a:	85 c0                	test   %eax,%eax
c010500c:	74 07                	je     c0105015 <perm2str+0x14>
c010500e:	b8 75 00 00 00       	mov    $0x75,%eax
c0105013:	eb 05                	jmp    c010501a <perm2str+0x19>
c0105015:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010501a:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c010501f:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105026:	8b 45 08             	mov    0x8(%ebp),%eax
c0105029:	83 e0 02             	and    $0x2,%eax
c010502c:	85 c0                	test   %eax,%eax
c010502e:	74 07                	je     c0105037 <perm2str+0x36>
c0105030:	b8 77 00 00 00       	mov    $0x77,%eax
c0105035:	eb 05                	jmp    c010503c <perm2str+0x3b>
c0105037:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010503c:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0105041:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0105048:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c010504d:	5d                   	pop    %ebp
c010504e:	c3                   	ret    

c010504f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010504f:	55                   	push   %ebp
c0105050:	89 e5                	mov    %esp,%ebp
c0105052:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105055:	8b 45 10             	mov    0x10(%ebp),%eax
c0105058:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010505b:	72 0a                	jb     c0105067 <get_pgtable_items+0x18>
        return 0;
c010505d:	b8 00 00 00 00       	mov    $0x0,%eax
c0105062:	e9 9c 00 00 00       	jmp    c0105103 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105067:	eb 04                	jmp    c010506d <get_pgtable_items+0x1e>
        start ++;
c0105069:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010506d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105070:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105073:	73 18                	jae    c010508d <get_pgtable_items+0x3e>
c0105075:	8b 45 10             	mov    0x10(%ebp),%eax
c0105078:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010507f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105082:	01 d0                	add    %edx,%eax
c0105084:	8b 00                	mov    (%eax),%eax
c0105086:	83 e0 01             	and    $0x1,%eax
c0105089:	85 c0                	test   %eax,%eax
c010508b:	74 dc                	je     c0105069 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c010508d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105090:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105093:	73 69                	jae    c01050fe <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105095:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105099:	74 08                	je     c01050a3 <get_pgtable_items+0x54>
            *left_store = start;
c010509b:	8b 45 18             	mov    0x18(%ebp),%eax
c010509e:	8b 55 10             	mov    0x10(%ebp),%edx
c01050a1:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01050a3:	8b 45 10             	mov    0x10(%ebp),%eax
c01050a6:	8d 50 01             	lea    0x1(%eax),%edx
c01050a9:	89 55 10             	mov    %edx,0x10(%ebp)
c01050ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01050b3:	8b 45 14             	mov    0x14(%ebp),%eax
c01050b6:	01 d0                	add    %edx,%eax
c01050b8:	8b 00                	mov    (%eax),%eax
c01050ba:	83 e0 07             	and    $0x7,%eax
c01050bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01050c0:	eb 04                	jmp    c01050c6 <get_pgtable_items+0x77>
            start ++;
c01050c2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01050c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01050c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050cc:	73 1d                	jae    c01050eb <get_pgtable_items+0x9c>
c01050ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01050d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01050d8:	8b 45 14             	mov    0x14(%ebp),%eax
c01050db:	01 d0                	add    %edx,%eax
c01050dd:	8b 00                	mov    (%eax),%eax
c01050df:	83 e0 07             	and    $0x7,%eax
c01050e2:	89 c2                	mov    %eax,%edx
c01050e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01050e7:	39 c2                	cmp    %eax,%edx
c01050e9:	74 d7                	je     c01050c2 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01050eb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01050ef:	74 08                	je     c01050f9 <get_pgtable_items+0xaa>
            *right_store = start;
c01050f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01050f4:	8b 55 10             	mov    0x10(%ebp),%edx
c01050f7:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01050f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01050fc:	eb 05                	jmp    c0105103 <get_pgtable_items+0xb4>
    }
    return 0;
c01050fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105103:	c9                   	leave  
c0105104:	c3                   	ret    

c0105105 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105105:	55                   	push   %ebp
c0105106:	89 e5                	mov    %esp,%ebp
c0105108:	57                   	push   %edi
c0105109:	56                   	push   %esi
c010510a:	53                   	push   %ebx
c010510b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010510e:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0105115:	e8 22 b2 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c010511a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105121:	e9 fa 00 00 00       	jmp    c0105220 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105129:	89 04 24             	mov    %eax,(%esp)
c010512c:	e8 d0 fe ff ff       	call   c0105001 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105131:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105134:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105137:	29 d1                	sub    %edx,%ecx
c0105139:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010513b:	89 d6                	mov    %edx,%esi
c010513d:	c1 e6 16             	shl    $0x16,%esi
c0105140:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105143:	89 d3                	mov    %edx,%ebx
c0105145:	c1 e3 16             	shl    $0x16,%ebx
c0105148:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010514b:	89 d1                	mov    %edx,%ecx
c010514d:	c1 e1 16             	shl    $0x16,%ecx
c0105150:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105153:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105156:	29 d7                	sub    %edx,%edi
c0105158:	89 fa                	mov    %edi,%edx
c010515a:	89 44 24 14          	mov    %eax,0x14(%esp)
c010515e:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105162:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105166:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010516a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010516e:	c7 04 24 35 6e 10 c0 	movl   $0xc0106e35,(%esp)
c0105175:	e8 c2 b1 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010517a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010517d:	c1 e0 0a             	shl    $0xa,%eax
c0105180:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105183:	eb 54                	jmp    c01051d9 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105188:	89 04 24             	mov    %eax,(%esp)
c010518b:	e8 71 fe ff ff       	call   c0105001 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105190:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105193:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105196:	29 d1                	sub    %edx,%ecx
c0105198:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010519a:	89 d6                	mov    %edx,%esi
c010519c:	c1 e6 0c             	shl    $0xc,%esi
c010519f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01051a2:	89 d3                	mov    %edx,%ebx
c01051a4:	c1 e3 0c             	shl    $0xc,%ebx
c01051a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01051aa:	c1 e2 0c             	shl    $0xc,%edx
c01051ad:	89 d1                	mov    %edx,%ecx
c01051af:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01051b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01051b5:	29 d7                	sub    %edx,%edi
c01051b7:	89 fa                	mov    %edi,%edx
c01051b9:	89 44 24 14          	mov    %eax,0x14(%esp)
c01051bd:	89 74 24 10          	mov    %esi,0x10(%esp)
c01051c1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01051c5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01051c9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051cd:	c7 04 24 54 6e 10 c0 	movl   $0xc0106e54,(%esp)
c01051d4:	e8 63 b1 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01051d9:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01051de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01051e1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01051e4:	89 ce                	mov    %ecx,%esi
c01051e6:	c1 e6 0a             	shl    $0xa,%esi
c01051e9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01051ec:	89 cb                	mov    %ecx,%ebx
c01051ee:	c1 e3 0a             	shl    $0xa,%ebx
c01051f1:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01051f4:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01051f8:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01051fb:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01051ff:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105203:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105207:	89 74 24 04          	mov    %esi,0x4(%esp)
c010520b:	89 1c 24             	mov    %ebx,(%esp)
c010520e:	e8 3c fe ff ff       	call   c010504f <get_pgtable_items>
c0105213:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105216:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010521a:	0f 85 65 ff ff ff    	jne    c0105185 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105220:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105225:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105228:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010522b:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010522f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105232:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105236:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010523a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010523e:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105245:	00 
c0105246:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010524d:	e8 fd fd ff ff       	call   c010504f <get_pgtable_items>
c0105252:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105255:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105259:	0f 85 c7 fe ff ff    	jne    c0105126 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010525f:	c7 04 24 78 6e 10 c0 	movl   $0xc0106e78,(%esp)
c0105266:	e8 d1 b0 ff ff       	call   c010033c <cprintf>
}
c010526b:	83 c4 4c             	add    $0x4c,%esp
c010526e:	5b                   	pop    %ebx
c010526f:	5e                   	pop    %esi
c0105270:	5f                   	pop    %edi
c0105271:	5d                   	pop    %ebp
c0105272:	c3                   	ret    

c0105273 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105273:	55                   	push   %ebp
c0105274:	89 e5                	mov    %esp,%ebp
c0105276:	83 ec 58             	sub    $0x58,%esp
c0105279:	8b 45 10             	mov    0x10(%ebp),%eax
c010527c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010527f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105282:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105285:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105288:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010528b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010528e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105291:	8b 45 18             	mov    0x18(%ebp),%eax
c0105294:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105297:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010529a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010529d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01052a0:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01052a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01052a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01052ad:	74 1c                	je     c01052cb <printnum+0x58>
c01052af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052b2:	ba 00 00 00 00       	mov    $0x0,%edx
c01052b7:	f7 75 e4             	divl   -0x1c(%ebp)
c01052ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01052bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052c0:	ba 00 00 00 00       	mov    $0x0,%edx
c01052c5:	f7 75 e4             	divl   -0x1c(%ebp)
c01052c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01052cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01052d1:	f7 75 e4             	divl   -0x1c(%ebp)
c01052d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01052d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01052da:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01052e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01052e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01052e9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01052ec:	8b 45 18             	mov    0x18(%ebp),%eax
c01052ef:	ba 00 00 00 00       	mov    $0x0,%edx
c01052f4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01052f7:	77 56                	ja     c010534f <printnum+0xdc>
c01052f9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01052fc:	72 05                	jb     c0105303 <printnum+0x90>
c01052fe:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105301:	77 4c                	ja     c010534f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105303:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105306:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105309:	8b 45 20             	mov    0x20(%ebp),%eax
c010530c:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105310:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105314:	8b 45 18             	mov    0x18(%ebp),%eax
c0105317:	89 44 24 10          	mov    %eax,0x10(%esp)
c010531b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010531e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105321:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105325:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105329:	8b 45 0c             	mov    0xc(%ebp),%eax
c010532c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105330:	8b 45 08             	mov    0x8(%ebp),%eax
c0105333:	89 04 24             	mov    %eax,(%esp)
c0105336:	e8 38 ff ff ff       	call   c0105273 <printnum>
c010533b:	eb 1c                	jmp    c0105359 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010533d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105340:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105344:	8b 45 20             	mov    0x20(%ebp),%eax
c0105347:	89 04 24             	mov    %eax,(%esp)
c010534a:	8b 45 08             	mov    0x8(%ebp),%eax
c010534d:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010534f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105353:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105357:	7f e4                	jg     c010533d <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105359:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010535c:	05 2c 6f 10 c0       	add    $0xc0106f2c,%eax
c0105361:	0f b6 00             	movzbl (%eax),%eax
c0105364:	0f be c0             	movsbl %al,%eax
c0105367:	8b 55 0c             	mov    0xc(%ebp),%edx
c010536a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010536e:	89 04 24             	mov    %eax,(%esp)
c0105371:	8b 45 08             	mov    0x8(%ebp),%eax
c0105374:	ff d0                	call   *%eax
}
c0105376:	c9                   	leave  
c0105377:	c3                   	ret    

c0105378 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105378:	55                   	push   %ebp
c0105379:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010537b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010537f:	7e 14                	jle    c0105395 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105381:	8b 45 08             	mov    0x8(%ebp),%eax
c0105384:	8b 00                	mov    (%eax),%eax
c0105386:	8d 48 08             	lea    0x8(%eax),%ecx
c0105389:	8b 55 08             	mov    0x8(%ebp),%edx
c010538c:	89 0a                	mov    %ecx,(%edx)
c010538e:	8b 50 04             	mov    0x4(%eax),%edx
c0105391:	8b 00                	mov    (%eax),%eax
c0105393:	eb 30                	jmp    c01053c5 <getuint+0x4d>
    }
    else if (lflag) {
c0105395:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105399:	74 16                	je     c01053b1 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010539b:	8b 45 08             	mov    0x8(%ebp),%eax
c010539e:	8b 00                	mov    (%eax),%eax
c01053a0:	8d 48 04             	lea    0x4(%eax),%ecx
c01053a3:	8b 55 08             	mov    0x8(%ebp),%edx
c01053a6:	89 0a                	mov    %ecx,(%edx)
c01053a8:	8b 00                	mov    (%eax),%eax
c01053aa:	ba 00 00 00 00       	mov    $0x0,%edx
c01053af:	eb 14                	jmp    c01053c5 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01053b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01053b4:	8b 00                	mov    (%eax),%eax
c01053b6:	8d 48 04             	lea    0x4(%eax),%ecx
c01053b9:	8b 55 08             	mov    0x8(%ebp),%edx
c01053bc:	89 0a                	mov    %ecx,(%edx)
c01053be:	8b 00                	mov    (%eax),%eax
c01053c0:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01053c5:	5d                   	pop    %ebp
c01053c6:	c3                   	ret    

c01053c7 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01053c7:	55                   	push   %ebp
c01053c8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01053ca:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01053ce:	7e 14                	jle    c01053e4 <getint+0x1d>
        return va_arg(*ap, long long);
c01053d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01053d3:	8b 00                	mov    (%eax),%eax
c01053d5:	8d 48 08             	lea    0x8(%eax),%ecx
c01053d8:	8b 55 08             	mov    0x8(%ebp),%edx
c01053db:	89 0a                	mov    %ecx,(%edx)
c01053dd:	8b 50 04             	mov    0x4(%eax),%edx
c01053e0:	8b 00                	mov    (%eax),%eax
c01053e2:	eb 28                	jmp    c010540c <getint+0x45>
    }
    else if (lflag) {
c01053e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01053e8:	74 12                	je     c01053fc <getint+0x35>
        return va_arg(*ap, long);
c01053ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ed:	8b 00                	mov    (%eax),%eax
c01053ef:	8d 48 04             	lea    0x4(%eax),%ecx
c01053f2:	8b 55 08             	mov    0x8(%ebp),%edx
c01053f5:	89 0a                	mov    %ecx,(%edx)
c01053f7:	8b 00                	mov    (%eax),%eax
c01053f9:	99                   	cltd   
c01053fa:	eb 10                	jmp    c010540c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01053fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ff:	8b 00                	mov    (%eax),%eax
c0105401:	8d 48 04             	lea    0x4(%eax),%ecx
c0105404:	8b 55 08             	mov    0x8(%ebp),%edx
c0105407:	89 0a                	mov    %ecx,(%edx)
c0105409:	8b 00                	mov    (%eax),%eax
c010540b:	99                   	cltd   
    }
}
c010540c:	5d                   	pop    %ebp
c010540d:	c3                   	ret    

c010540e <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010540e:	55                   	push   %ebp
c010540f:	89 e5                	mov    %esp,%ebp
c0105411:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105414:	8d 45 14             	lea    0x14(%ebp),%eax
c0105417:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010541a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010541d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105421:	8b 45 10             	mov    0x10(%ebp),%eax
c0105424:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105428:	8b 45 0c             	mov    0xc(%ebp),%eax
c010542b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010542f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105432:	89 04 24             	mov    %eax,(%esp)
c0105435:	e8 02 00 00 00       	call   c010543c <vprintfmt>
    va_end(ap);
}
c010543a:	c9                   	leave  
c010543b:	c3                   	ret    

c010543c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010543c:	55                   	push   %ebp
c010543d:	89 e5                	mov    %esp,%ebp
c010543f:	56                   	push   %esi
c0105440:	53                   	push   %ebx
c0105441:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105444:	eb 18                	jmp    c010545e <vprintfmt+0x22>
            if (ch == '\0') {
c0105446:	85 db                	test   %ebx,%ebx
c0105448:	75 05                	jne    c010544f <vprintfmt+0x13>
                return;
c010544a:	e9 d1 03 00 00       	jmp    c0105820 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010544f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105452:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105456:	89 1c 24             	mov    %ebx,(%esp)
c0105459:	8b 45 08             	mov    0x8(%ebp),%eax
c010545c:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010545e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105461:	8d 50 01             	lea    0x1(%eax),%edx
c0105464:	89 55 10             	mov    %edx,0x10(%ebp)
c0105467:	0f b6 00             	movzbl (%eax),%eax
c010546a:	0f b6 d8             	movzbl %al,%ebx
c010546d:	83 fb 25             	cmp    $0x25,%ebx
c0105470:	75 d4                	jne    c0105446 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105472:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105476:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010547d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105480:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105483:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010548a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010548d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105490:	8b 45 10             	mov    0x10(%ebp),%eax
c0105493:	8d 50 01             	lea    0x1(%eax),%edx
c0105496:	89 55 10             	mov    %edx,0x10(%ebp)
c0105499:	0f b6 00             	movzbl (%eax),%eax
c010549c:	0f b6 d8             	movzbl %al,%ebx
c010549f:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01054a2:	83 f8 55             	cmp    $0x55,%eax
c01054a5:	0f 87 44 03 00 00    	ja     c01057ef <vprintfmt+0x3b3>
c01054ab:	8b 04 85 50 6f 10 c0 	mov    -0x3fef90b0(,%eax,4),%eax
c01054b2:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01054b4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01054b8:	eb d6                	jmp    c0105490 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01054ba:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01054be:	eb d0                	jmp    c0105490 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01054c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01054c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054ca:	89 d0                	mov    %edx,%eax
c01054cc:	c1 e0 02             	shl    $0x2,%eax
c01054cf:	01 d0                	add    %edx,%eax
c01054d1:	01 c0                	add    %eax,%eax
c01054d3:	01 d8                	add    %ebx,%eax
c01054d5:	83 e8 30             	sub    $0x30,%eax
c01054d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01054db:	8b 45 10             	mov    0x10(%ebp),%eax
c01054de:	0f b6 00             	movzbl (%eax),%eax
c01054e1:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01054e4:	83 fb 2f             	cmp    $0x2f,%ebx
c01054e7:	7e 0b                	jle    c01054f4 <vprintfmt+0xb8>
c01054e9:	83 fb 39             	cmp    $0x39,%ebx
c01054ec:	7f 06                	jg     c01054f4 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01054ee:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01054f2:	eb d3                	jmp    c01054c7 <vprintfmt+0x8b>
            goto process_precision;
c01054f4:	eb 33                	jmp    c0105529 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01054f6:	8b 45 14             	mov    0x14(%ebp),%eax
c01054f9:	8d 50 04             	lea    0x4(%eax),%edx
c01054fc:	89 55 14             	mov    %edx,0x14(%ebp)
c01054ff:	8b 00                	mov    (%eax),%eax
c0105501:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105504:	eb 23                	jmp    c0105529 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105506:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010550a:	79 0c                	jns    c0105518 <vprintfmt+0xdc>
                width = 0;
c010550c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105513:	e9 78 ff ff ff       	jmp    c0105490 <vprintfmt+0x54>
c0105518:	e9 73 ff ff ff       	jmp    c0105490 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010551d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105524:	e9 67 ff ff ff       	jmp    c0105490 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105529:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010552d:	79 12                	jns    c0105541 <vprintfmt+0x105>
                width = precision, precision = -1;
c010552f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105532:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105535:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010553c:	e9 4f ff ff ff       	jmp    c0105490 <vprintfmt+0x54>
c0105541:	e9 4a ff ff ff       	jmp    c0105490 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105546:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010554a:	e9 41 ff ff ff       	jmp    c0105490 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010554f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105552:	8d 50 04             	lea    0x4(%eax),%edx
c0105555:	89 55 14             	mov    %edx,0x14(%ebp)
c0105558:	8b 00                	mov    (%eax),%eax
c010555a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010555d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105561:	89 04 24             	mov    %eax,(%esp)
c0105564:	8b 45 08             	mov    0x8(%ebp),%eax
c0105567:	ff d0                	call   *%eax
            break;
c0105569:	e9 ac 02 00 00       	jmp    c010581a <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010556e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105571:	8d 50 04             	lea    0x4(%eax),%edx
c0105574:	89 55 14             	mov    %edx,0x14(%ebp)
c0105577:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105579:	85 db                	test   %ebx,%ebx
c010557b:	79 02                	jns    c010557f <vprintfmt+0x143>
                err = -err;
c010557d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010557f:	83 fb 06             	cmp    $0x6,%ebx
c0105582:	7f 0b                	jg     c010558f <vprintfmt+0x153>
c0105584:	8b 34 9d 10 6f 10 c0 	mov    -0x3fef90f0(,%ebx,4),%esi
c010558b:	85 f6                	test   %esi,%esi
c010558d:	75 23                	jne    c01055b2 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010558f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105593:	c7 44 24 08 3d 6f 10 	movl   $0xc0106f3d,0x8(%esp)
c010559a:	c0 
c010559b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010559e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a5:	89 04 24             	mov    %eax,(%esp)
c01055a8:	e8 61 fe ff ff       	call   c010540e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01055ad:	e9 68 02 00 00       	jmp    c010581a <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01055b2:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01055b6:	c7 44 24 08 46 6f 10 	movl   $0xc0106f46,0x8(%esp)
c01055bd:	c0 
c01055be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c8:	89 04 24             	mov    %eax,(%esp)
c01055cb:	e8 3e fe ff ff       	call   c010540e <printfmt>
            }
            break;
c01055d0:	e9 45 02 00 00       	jmp    c010581a <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01055d5:	8b 45 14             	mov    0x14(%ebp),%eax
c01055d8:	8d 50 04             	lea    0x4(%eax),%edx
c01055db:	89 55 14             	mov    %edx,0x14(%ebp)
c01055de:	8b 30                	mov    (%eax),%esi
c01055e0:	85 f6                	test   %esi,%esi
c01055e2:	75 05                	jne    c01055e9 <vprintfmt+0x1ad>
                p = "(null)";
c01055e4:	be 49 6f 10 c0       	mov    $0xc0106f49,%esi
            }
            if (width > 0 && padc != '-') {
c01055e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01055ed:	7e 3e                	jle    c010562d <vprintfmt+0x1f1>
c01055ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01055f3:	74 38                	je     c010562d <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01055f5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01055f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055ff:	89 34 24             	mov    %esi,(%esp)
c0105602:	e8 15 03 00 00       	call   c010591c <strnlen>
c0105607:	29 c3                	sub    %eax,%ebx
c0105609:	89 d8                	mov    %ebx,%eax
c010560b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010560e:	eb 17                	jmp    c0105627 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105610:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105614:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105617:	89 54 24 04          	mov    %edx,0x4(%esp)
c010561b:	89 04 24             	mov    %eax,(%esp)
c010561e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105621:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105623:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105627:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010562b:	7f e3                	jg     c0105610 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010562d:	eb 38                	jmp    c0105667 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010562f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105633:	74 1f                	je     c0105654 <vprintfmt+0x218>
c0105635:	83 fb 1f             	cmp    $0x1f,%ebx
c0105638:	7e 05                	jle    c010563f <vprintfmt+0x203>
c010563a:	83 fb 7e             	cmp    $0x7e,%ebx
c010563d:	7e 15                	jle    c0105654 <vprintfmt+0x218>
                    putch('?', putdat);
c010563f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105642:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105646:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010564d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105650:	ff d0                	call   *%eax
c0105652:	eb 0f                	jmp    c0105663 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105654:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105657:	89 44 24 04          	mov    %eax,0x4(%esp)
c010565b:	89 1c 24             	mov    %ebx,(%esp)
c010565e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105661:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105663:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105667:	89 f0                	mov    %esi,%eax
c0105669:	8d 70 01             	lea    0x1(%eax),%esi
c010566c:	0f b6 00             	movzbl (%eax),%eax
c010566f:	0f be d8             	movsbl %al,%ebx
c0105672:	85 db                	test   %ebx,%ebx
c0105674:	74 10                	je     c0105686 <vprintfmt+0x24a>
c0105676:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010567a:	78 b3                	js     c010562f <vprintfmt+0x1f3>
c010567c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105680:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105684:	79 a9                	jns    c010562f <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105686:	eb 17                	jmp    c010569f <vprintfmt+0x263>
                putch(' ', putdat);
c0105688:	8b 45 0c             	mov    0xc(%ebp),%eax
c010568b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010568f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105696:	8b 45 08             	mov    0x8(%ebp),%eax
c0105699:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010569b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010569f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056a3:	7f e3                	jg     c0105688 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01056a5:	e9 70 01 00 00       	jmp    c010581a <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01056aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056b1:	8d 45 14             	lea    0x14(%ebp),%eax
c01056b4:	89 04 24             	mov    %eax,(%esp)
c01056b7:	e8 0b fd ff ff       	call   c01053c7 <getint>
c01056bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01056c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056c8:	85 d2                	test   %edx,%edx
c01056ca:	79 26                	jns    c01056f2 <vprintfmt+0x2b6>
                putch('-', putdat);
c01056cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056d3:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01056da:	8b 45 08             	mov    0x8(%ebp),%eax
c01056dd:	ff d0                	call   *%eax
                num = -(long long)num;
c01056df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056e5:	f7 d8                	neg    %eax
c01056e7:	83 d2 00             	adc    $0x0,%edx
c01056ea:	f7 da                	neg    %edx
c01056ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01056f2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01056f9:	e9 a8 00 00 00       	jmp    c01057a6 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01056fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105701:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105705:	8d 45 14             	lea    0x14(%ebp),%eax
c0105708:	89 04 24             	mov    %eax,(%esp)
c010570b:	e8 68 fc ff ff       	call   c0105378 <getuint>
c0105710:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105713:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105716:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010571d:	e9 84 00 00 00       	jmp    c01057a6 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105722:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105725:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105729:	8d 45 14             	lea    0x14(%ebp),%eax
c010572c:	89 04 24             	mov    %eax,(%esp)
c010572f:	e8 44 fc ff ff       	call   c0105378 <getuint>
c0105734:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105737:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010573a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105741:	eb 63                	jmp    c01057a6 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105743:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105746:	89 44 24 04          	mov    %eax,0x4(%esp)
c010574a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105751:	8b 45 08             	mov    0x8(%ebp),%eax
c0105754:	ff d0                	call   *%eax
            putch('x', putdat);
c0105756:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105759:	89 44 24 04          	mov    %eax,0x4(%esp)
c010575d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105764:	8b 45 08             	mov    0x8(%ebp),%eax
c0105767:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105769:	8b 45 14             	mov    0x14(%ebp),%eax
c010576c:	8d 50 04             	lea    0x4(%eax),%edx
c010576f:	89 55 14             	mov    %edx,0x14(%ebp)
c0105772:	8b 00                	mov    (%eax),%eax
c0105774:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010577e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105785:	eb 1f                	jmp    c01057a6 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105787:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010578a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010578e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105791:	89 04 24             	mov    %eax,(%esp)
c0105794:	e8 df fb ff ff       	call   c0105378 <getuint>
c0105799:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010579c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010579f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01057a6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01057aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057ad:	89 54 24 18          	mov    %edx,0x18(%esp)
c01057b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01057b4:	89 54 24 14          	mov    %edx,0x14(%esp)
c01057b8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01057bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057c2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01057c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01057ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d4:	89 04 24             	mov    %eax,(%esp)
c01057d7:	e8 97 fa ff ff       	call   c0105273 <printnum>
            break;
c01057dc:	eb 3c                	jmp    c010581a <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01057de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057e5:	89 1c 24             	mov    %ebx,(%esp)
c01057e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01057eb:	ff d0                	call   *%eax
            break;
c01057ed:	eb 2b                	jmp    c010581a <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01057ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057f6:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01057fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105800:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105802:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105806:	eb 04                	jmp    c010580c <vprintfmt+0x3d0>
c0105808:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010580c:	8b 45 10             	mov    0x10(%ebp),%eax
c010580f:	83 e8 01             	sub    $0x1,%eax
c0105812:	0f b6 00             	movzbl (%eax),%eax
c0105815:	3c 25                	cmp    $0x25,%al
c0105817:	75 ef                	jne    c0105808 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105819:	90                   	nop
        }
    }
c010581a:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010581b:	e9 3e fc ff ff       	jmp    c010545e <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105820:	83 c4 40             	add    $0x40,%esp
c0105823:	5b                   	pop    %ebx
c0105824:	5e                   	pop    %esi
c0105825:	5d                   	pop    %ebp
c0105826:	c3                   	ret    

c0105827 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105827:	55                   	push   %ebp
c0105828:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010582a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010582d:	8b 40 08             	mov    0x8(%eax),%eax
c0105830:	8d 50 01             	lea    0x1(%eax),%edx
c0105833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105836:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105839:	8b 45 0c             	mov    0xc(%ebp),%eax
c010583c:	8b 10                	mov    (%eax),%edx
c010583e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105841:	8b 40 04             	mov    0x4(%eax),%eax
c0105844:	39 c2                	cmp    %eax,%edx
c0105846:	73 12                	jae    c010585a <sprintputch+0x33>
        *b->buf ++ = ch;
c0105848:	8b 45 0c             	mov    0xc(%ebp),%eax
c010584b:	8b 00                	mov    (%eax),%eax
c010584d:	8d 48 01             	lea    0x1(%eax),%ecx
c0105850:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105853:	89 0a                	mov    %ecx,(%edx)
c0105855:	8b 55 08             	mov    0x8(%ebp),%edx
c0105858:	88 10                	mov    %dl,(%eax)
    }
}
c010585a:	5d                   	pop    %ebp
c010585b:	c3                   	ret    

c010585c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010585c:	55                   	push   %ebp
c010585d:	89 e5                	mov    %esp,%ebp
c010585f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105862:	8d 45 14             	lea    0x14(%ebp),%eax
c0105865:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105868:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010586b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010586f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105872:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105876:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105879:	89 44 24 04          	mov    %eax,0x4(%esp)
c010587d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105880:	89 04 24             	mov    %eax,(%esp)
c0105883:	e8 08 00 00 00       	call   c0105890 <vsnprintf>
c0105888:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010588b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010588e:	c9                   	leave  
c010588f:	c3                   	ret    

c0105890 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105890:	55                   	push   %ebp
c0105891:	89 e5                	mov    %esp,%ebp
c0105893:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105896:	8b 45 08             	mov    0x8(%ebp),%eax
c0105899:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010589c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010589f:	8d 50 ff             	lea    -0x1(%eax),%edx
c01058a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a5:	01 d0                	add    %edx,%eax
c01058a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01058b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01058b5:	74 0a                	je     c01058c1 <vsnprintf+0x31>
c01058b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01058ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058bd:	39 c2                	cmp    %eax,%edx
c01058bf:	76 07                	jbe    c01058c8 <vsnprintf+0x38>
        return -E_INVAL;
c01058c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01058c6:	eb 2a                	jmp    c01058f2 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01058c8:	8b 45 14             	mov    0x14(%ebp),%eax
c01058cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01058d2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01058d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058dd:	c7 04 24 27 58 10 c0 	movl   $0xc0105827,(%esp)
c01058e4:	e8 53 fb ff ff       	call   c010543c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01058e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058ec:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01058ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01058f2:	c9                   	leave  
c01058f3:	c3                   	ret    

c01058f4 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01058f4:	55                   	push   %ebp
c01058f5:	89 e5                	mov    %esp,%ebp
c01058f7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01058fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105901:	eb 04                	jmp    c0105907 <strlen+0x13>
        cnt ++;
c0105903:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105907:	8b 45 08             	mov    0x8(%ebp),%eax
c010590a:	8d 50 01             	lea    0x1(%eax),%edx
c010590d:	89 55 08             	mov    %edx,0x8(%ebp)
c0105910:	0f b6 00             	movzbl (%eax),%eax
c0105913:	84 c0                	test   %al,%al
c0105915:	75 ec                	jne    c0105903 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105917:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010591a:	c9                   	leave  
c010591b:	c3                   	ret    

c010591c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010591c:	55                   	push   %ebp
c010591d:	89 e5                	mov    %esp,%ebp
c010591f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105922:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105929:	eb 04                	jmp    c010592f <strnlen+0x13>
        cnt ++;
c010592b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010592f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105932:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105935:	73 10                	jae    c0105947 <strnlen+0x2b>
c0105937:	8b 45 08             	mov    0x8(%ebp),%eax
c010593a:	8d 50 01             	lea    0x1(%eax),%edx
c010593d:	89 55 08             	mov    %edx,0x8(%ebp)
c0105940:	0f b6 00             	movzbl (%eax),%eax
c0105943:	84 c0                	test   %al,%al
c0105945:	75 e4                	jne    c010592b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105947:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010594a:	c9                   	leave  
c010594b:	c3                   	ret    

c010594c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010594c:	55                   	push   %ebp
c010594d:	89 e5                	mov    %esp,%ebp
c010594f:	57                   	push   %edi
c0105950:	56                   	push   %esi
c0105951:	83 ec 20             	sub    $0x20,%esp
c0105954:	8b 45 08             	mov    0x8(%ebp),%eax
c0105957:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010595a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010595d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105960:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105963:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105966:	89 d1                	mov    %edx,%ecx
c0105968:	89 c2                	mov    %eax,%edx
c010596a:	89 ce                	mov    %ecx,%esi
c010596c:	89 d7                	mov    %edx,%edi
c010596e:	ac                   	lods   %ds:(%esi),%al
c010596f:	aa                   	stos   %al,%es:(%edi)
c0105970:	84 c0                	test   %al,%al
c0105972:	75 fa                	jne    c010596e <strcpy+0x22>
c0105974:	89 fa                	mov    %edi,%edx
c0105976:	89 f1                	mov    %esi,%ecx
c0105978:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010597b:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010597e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105981:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105984:	83 c4 20             	add    $0x20,%esp
c0105987:	5e                   	pop    %esi
c0105988:	5f                   	pop    %edi
c0105989:	5d                   	pop    %ebp
c010598a:	c3                   	ret    

c010598b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010598b:	55                   	push   %ebp
c010598c:	89 e5                	mov    %esp,%ebp
c010598e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105991:	8b 45 08             	mov    0x8(%ebp),%eax
c0105994:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105997:	eb 21                	jmp    c01059ba <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105999:	8b 45 0c             	mov    0xc(%ebp),%eax
c010599c:	0f b6 10             	movzbl (%eax),%edx
c010599f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059a2:	88 10                	mov    %dl,(%eax)
c01059a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059a7:	0f b6 00             	movzbl (%eax),%eax
c01059aa:	84 c0                	test   %al,%al
c01059ac:	74 04                	je     c01059b2 <strncpy+0x27>
            src ++;
c01059ae:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01059b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01059b6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01059ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01059be:	75 d9                	jne    c0105999 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01059c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01059c3:	c9                   	leave  
c01059c4:	c3                   	ret    

c01059c5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01059c5:	55                   	push   %ebp
c01059c6:	89 e5                	mov    %esp,%ebp
c01059c8:	57                   	push   %edi
c01059c9:	56                   	push   %esi
c01059ca:	83 ec 20             	sub    $0x20,%esp
c01059cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01059d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059df:	89 d1                	mov    %edx,%ecx
c01059e1:	89 c2                	mov    %eax,%edx
c01059e3:	89 ce                	mov    %ecx,%esi
c01059e5:	89 d7                	mov    %edx,%edi
c01059e7:	ac                   	lods   %ds:(%esi),%al
c01059e8:	ae                   	scas   %es:(%edi),%al
c01059e9:	75 08                	jne    c01059f3 <strcmp+0x2e>
c01059eb:	84 c0                	test   %al,%al
c01059ed:	75 f8                	jne    c01059e7 <strcmp+0x22>
c01059ef:	31 c0                	xor    %eax,%eax
c01059f1:	eb 04                	jmp    c01059f7 <strcmp+0x32>
c01059f3:	19 c0                	sbb    %eax,%eax
c01059f5:	0c 01                	or     $0x1,%al
c01059f7:	89 fa                	mov    %edi,%edx
c01059f9:	89 f1                	mov    %esi,%ecx
c01059fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01059fe:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105a01:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105a07:	83 c4 20             	add    $0x20,%esp
c0105a0a:	5e                   	pop    %esi
c0105a0b:	5f                   	pop    %edi
c0105a0c:	5d                   	pop    %ebp
c0105a0d:	c3                   	ret    

c0105a0e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105a0e:	55                   	push   %ebp
c0105a0f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a11:	eb 0c                	jmp    c0105a1f <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105a13:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a17:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105a1b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a23:	74 1a                	je     c0105a3f <strncmp+0x31>
c0105a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a28:	0f b6 00             	movzbl (%eax),%eax
c0105a2b:	84 c0                	test   %al,%al
c0105a2d:	74 10                	je     c0105a3f <strncmp+0x31>
c0105a2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a32:	0f b6 10             	movzbl (%eax),%edx
c0105a35:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a38:	0f b6 00             	movzbl (%eax),%eax
c0105a3b:	38 c2                	cmp    %al,%dl
c0105a3d:	74 d4                	je     c0105a13 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a43:	74 18                	je     c0105a5d <strncmp+0x4f>
c0105a45:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a48:	0f b6 00             	movzbl (%eax),%eax
c0105a4b:	0f b6 d0             	movzbl %al,%edx
c0105a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a51:	0f b6 00             	movzbl (%eax),%eax
c0105a54:	0f b6 c0             	movzbl %al,%eax
c0105a57:	29 c2                	sub    %eax,%edx
c0105a59:	89 d0                	mov    %edx,%eax
c0105a5b:	eb 05                	jmp    c0105a62 <strncmp+0x54>
c0105a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a62:	5d                   	pop    %ebp
c0105a63:	c3                   	ret    

c0105a64 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105a64:	55                   	push   %ebp
c0105a65:	89 e5                	mov    %esp,%ebp
c0105a67:	83 ec 04             	sub    $0x4,%esp
c0105a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a6d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105a70:	eb 14                	jmp    c0105a86 <strchr+0x22>
        if (*s == c) {
c0105a72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a75:	0f b6 00             	movzbl (%eax),%eax
c0105a78:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105a7b:	75 05                	jne    c0105a82 <strchr+0x1e>
            return (char *)s;
c0105a7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a80:	eb 13                	jmp    c0105a95 <strchr+0x31>
        }
        s ++;
c0105a82:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105a86:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a89:	0f b6 00             	movzbl (%eax),%eax
c0105a8c:	84 c0                	test   %al,%al
c0105a8e:	75 e2                	jne    c0105a72 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105a90:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a95:	c9                   	leave  
c0105a96:	c3                   	ret    

c0105a97 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105a97:	55                   	push   %ebp
c0105a98:	89 e5                	mov    %esp,%ebp
c0105a9a:	83 ec 04             	sub    $0x4,%esp
c0105a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105aa3:	eb 11                	jmp    c0105ab6 <strfind+0x1f>
        if (*s == c) {
c0105aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa8:	0f b6 00             	movzbl (%eax),%eax
c0105aab:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105aae:	75 02                	jne    c0105ab2 <strfind+0x1b>
            break;
c0105ab0:	eb 0e                	jmp    c0105ac0 <strfind+0x29>
        }
        s ++;
c0105ab2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab9:	0f b6 00             	movzbl (%eax),%eax
c0105abc:	84 c0                	test   %al,%al
c0105abe:	75 e5                	jne    c0105aa5 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105ac0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ac3:	c9                   	leave  
c0105ac4:	c3                   	ret    

c0105ac5 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105ac5:	55                   	push   %ebp
c0105ac6:	89 e5                	mov    %esp,%ebp
c0105ac8:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105acb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105ad2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105ad9:	eb 04                	jmp    c0105adf <strtol+0x1a>
        s ++;
c0105adb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105adf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae2:	0f b6 00             	movzbl (%eax),%eax
c0105ae5:	3c 20                	cmp    $0x20,%al
c0105ae7:	74 f2                	je     c0105adb <strtol+0x16>
c0105ae9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aec:	0f b6 00             	movzbl (%eax),%eax
c0105aef:	3c 09                	cmp    $0x9,%al
c0105af1:	74 e8                	je     c0105adb <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af6:	0f b6 00             	movzbl (%eax),%eax
c0105af9:	3c 2b                	cmp    $0x2b,%al
c0105afb:	75 06                	jne    c0105b03 <strtol+0x3e>
        s ++;
c0105afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b01:	eb 15                	jmp    c0105b18 <strtol+0x53>
    }
    else if (*s == '-') {
c0105b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b06:	0f b6 00             	movzbl (%eax),%eax
c0105b09:	3c 2d                	cmp    $0x2d,%al
c0105b0b:	75 0b                	jne    c0105b18 <strtol+0x53>
        s ++, neg = 1;
c0105b0d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b11:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105b18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b1c:	74 06                	je     c0105b24 <strtol+0x5f>
c0105b1e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105b22:	75 24                	jne    c0105b48 <strtol+0x83>
c0105b24:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b27:	0f b6 00             	movzbl (%eax),%eax
c0105b2a:	3c 30                	cmp    $0x30,%al
c0105b2c:	75 1a                	jne    c0105b48 <strtol+0x83>
c0105b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b31:	83 c0 01             	add    $0x1,%eax
c0105b34:	0f b6 00             	movzbl (%eax),%eax
c0105b37:	3c 78                	cmp    $0x78,%al
c0105b39:	75 0d                	jne    c0105b48 <strtol+0x83>
        s += 2, base = 16;
c0105b3b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105b3f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105b46:	eb 2a                	jmp    c0105b72 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105b48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b4c:	75 17                	jne    c0105b65 <strtol+0xa0>
c0105b4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b51:	0f b6 00             	movzbl (%eax),%eax
c0105b54:	3c 30                	cmp    $0x30,%al
c0105b56:	75 0d                	jne    c0105b65 <strtol+0xa0>
        s ++, base = 8;
c0105b58:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b5c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105b63:	eb 0d                	jmp    c0105b72 <strtol+0xad>
    }
    else if (base == 0) {
c0105b65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b69:	75 07                	jne    c0105b72 <strtol+0xad>
        base = 10;
c0105b6b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b75:	0f b6 00             	movzbl (%eax),%eax
c0105b78:	3c 2f                	cmp    $0x2f,%al
c0105b7a:	7e 1b                	jle    c0105b97 <strtol+0xd2>
c0105b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7f:	0f b6 00             	movzbl (%eax),%eax
c0105b82:	3c 39                	cmp    $0x39,%al
c0105b84:	7f 11                	jg     c0105b97 <strtol+0xd2>
            dig = *s - '0';
c0105b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b89:	0f b6 00             	movzbl (%eax),%eax
c0105b8c:	0f be c0             	movsbl %al,%eax
c0105b8f:	83 e8 30             	sub    $0x30,%eax
c0105b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b95:	eb 48                	jmp    c0105bdf <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105b97:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b9a:	0f b6 00             	movzbl (%eax),%eax
c0105b9d:	3c 60                	cmp    $0x60,%al
c0105b9f:	7e 1b                	jle    c0105bbc <strtol+0xf7>
c0105ba1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba4:	0f b6 00             	movzbl (%eax),%eax
c0105ba7:	3c 7a                	cmp    $0x7a,%al
c0105ba9:	7f 11                	jg     c0105bbc <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105bab:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bae:	0f b6 00             	movzbl (%eax),%eax
c0105bb1:	0f be c0             	movsbl %al,%eax
c0105bb4:	83 e8 57             	sub    $0x57,%eax
c0105bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bba:	eb 23                	jmp    c0105bdf <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105bbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbf:	0f b6 00             	movzbl (%eax),%eax
c0105bc2:	3c 40                	cmp    $0x40,%al
c0105bc4:	7e 3d                	jle    c0105c03 <strtol+0x13e>
c0105bc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc9:	0f b6 00             	movzbl (%eax),%eax
c0105bcc:	3c 5a                	cmp    $0x5a,%al
c0105bce:	7f 33                	jg     c0105c03 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105bd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd3:	0f b6 00             	movzbl (%eax),%eax
c0105bd6:	0f be c0             	movsbl %al,%eax
c0105bd9:	83 e8 37             	sub    $0x37,%eax
c0105bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105be2:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105be5:	7c 02                	jl     c0105be9 <strtol+0x124>
            break;
c0105be7:	eb 1a                	jmp    c0105c03 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105be9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bed:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105bf0:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105bf4:	89 c2                	mov    %eax,%edx
c0105bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bf9:	01 d0                	add    %edx,%eax
c0105bfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105bfe:	e9 6f ff ff ff       	jmp    c0105b72 <strtol+0xad>

    if (endptr) {
c0105c03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c07:	74 08                	je     c0105c11 <strtol+0x14c>
        *endptr = (char *) s;
c0105c09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c0c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c0f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105c11:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105c15:	74 07                	je     c0105c1e <strtol+0x159>
c0105c17:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c1a:	f7 d8                	neg    %eax
c0105c1c:	eb 03                	jmp    c0105c21 <strtol+0x15c>
c0105c1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105c21:	c9                   	leave  
c0105c22:	c3                   	ret    

c0105c23 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105c23:	55                   	push   %ebp
c0105c24:	89 e5                	mov    %esp,%ebp
c0105c26:	57                   	push   %edi
c0105c27:	83 ec 24             	sub    $0x24,%esp
c0105c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c2d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105c30:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105c34:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c37:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105c3a:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105c3d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105c43:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105c46:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105c4a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105c4d:	89 d7                	mov    %edx,%edi
c0105c4f:	f3 aa                	rep stos %al,%es:(%edi)
c0105c51:	89 fa                	mov    %edi,%edx
c0105c53:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105c56:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105c59:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105c5c:	83 c4 24             	add    $0x24,%esp
c0105c5f:	5f                   	pop    %edi
c0105c60:	5d                   	pop    %ebp
c0105c61:	c3                   	ret    

c0105c62 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105c62:	55                   	push   %ebp
c0105c63:	89 e5                	mov    %esp,%ebp
c0105c65:	57                   	push   %edi
c0105c66:	56                   	push   %esi
c0105c67:	53                   	push   %ebx
c0105c68:	83 ec 30             	sub    $0x30,%esp
c0105c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c74:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c77:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c7a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c80:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105c83:	73 42                	jae    c0105cc7 <memmove+0x65>
c0105c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105c91:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105c94:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105c97:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105c9a:	c1 e8 02             	shr    $0x2,%eax
c0105c9d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105c9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ca2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ca5:	89 d7                	mov    %edx,%edi
c0105ca7:	89 c6                	mov    %eax,%esi
c0105ca9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105cab:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105cae:	83 e1 03             	and    $0x3,%ecx
c0105cb1:	74 02                	je     c0105cb5 <memmove+0x53>
c0105cb3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105cb5:	89 f0                	mov    %esi,%eax
c0105cb7:	89 fa                	mov    %edi,%edx
c0105cb9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105cbc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105cbf:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105cc5:	eb 36                	jmp    c0105cfd <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105cc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cca:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105cd0:	01 c2                	add    %eax,%edx
c0105cd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cd5:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cdb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ce1:	89 c1                	mov    %eax,%ecx
c0105ce3:	89 d8                	mov    %ebx,%eax
c0105ce5:	89 d6                	mov    %edx,%esi
c0105ce7:	89 c7                	mov    %eax,%edi
c0105ce9:	fd                   	std    
c0105cea:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105cec:	fc                   	cld    
c0105ced:	89 f8                	mov    %edi,%eax
c0105cef:	89 f2                	mov    %esi,%edx
c0105cf1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105cf4:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105cf7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105cfd:	83 c4 30             	add    $0x30,%esp
c0105d00:	5b                   	pop    %ebx
c0105d01:	5e                   	pop    %esi
c0105d02:	5f                   	pop    %edi
c0105d03:	5d                   	pop    %ebp
c0105d04:	c3                   	ret    

c0105d05 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105d05:	55                   	push   %ebp
c0105d06:	89 e5                	mov    %esp,%ebp
c0105d08:	57                   	push   %edi
c0105d09:	56                   	push   %esi
c0105d0a:	83 ec 20             	sub    $0x20,%esp
c0105d0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d16:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d19:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d22:	c1 e8 02             	shr    $0x2,%eax
c0105d25:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105d27:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d2d:	89 d7                	mov    %edx,%edi
c0105d2f:	89 c6                	mov    %eax,%esi
c0105d31:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d33:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105d36:	83 e1 03             	and    $0x3,%ecx
c0105d39:	74 02                	je     c0105d3d <memcpy+0x38>
c0105d3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d3d:	89 f0                	mov    %esi,%eax
c0105d3f:	89 fa                	mov    %edi,%edx
c0105d41:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105d44:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105d47:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105d4d:	83 c4 20             	add    $0x20,%esp
c0105d50:	5e                   	pop    %esi
c0105d51:	5f                   	pop    %edi
c0105d52:	5d                   	pop    %ebp
c0105d53:	c3                   	ret    

c0105d54 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105d54:	55                   	push   %ebp
c0105d55:	89 e5                	mov    %esp,%ebp
c0105d57:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105d5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105d60:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d63:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105d66:	eb 30                	jmp    c0105d98 <memcmp+0x44>
        if (*s1 != *s2) {
c0105d68:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d6b:	0f b6 10             	movzbl (%eax),%edx
c0105d6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d71:	0f b6 00             	movzbl (%eax),%eax
c0105d74:	38 c2                	cmp    %al,%dl
c0105d76:	74 18                	je     c0105d90 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105d78:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d7b:	0f b6 00             	movzbl (%eax),%eax
c0105d7e:	0f b6 d0             	movzbl %al,%edx
c0105d81:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d84:	0f b6 00             	movzbl (%eax),%eax
c0105d87:	0f b6 c0             	movzbl %al,%eax
c0105d8a:	29 c2                	sub    %eax,%edx
c0105d8c:	89 d0                	mov    %edx,%eax
c0105d8e:	eb 1a                	jmp    c0105daa <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105d90:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105d94:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105d98:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d9b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d9e:	89 55 10             	mov    %edx,0x10(%ebp)
c0105da1:	85 c0                	test   %eax,%eax
c0105da3:	75 c3                	jne    c0105d68 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105da5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105daa:	c9                   	leave  
c0105dab:	c3                   	ret    
