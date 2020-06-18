
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 10 12 00 	lgdtl  0x121018
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
c010001e:	bc 00 10 12 c0       	mov    $0xc0121000,%esp
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
c0100030:	ba d0 2b 12 c0       	mov    $0xc0122bd0,%edx
c0100035:	b8 88 1a 12 c0       	mov    $0xc0121a88,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 88 1a 12 c0 	movl   $0xc0121a88,(%esp)
c0100051:	e8 10 8f 00 00       	call   c0108f66 <memset>

    cons_init();                // init the console
c0100056:	e8 80 15 00 00       	call   c01015db <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 00 91 10 c0 	movl   $0xc0109100,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 1c 91 10 c0 	movl   $0xc010911c,(%esp)
c0100070:	e8 d6 02 00 00       	call   c010034b <cprintf>

    print_kerninfo();
c0100075:	e8 05 08 00 00       	call   c010087f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 95 00 00 00       	call   c0100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 2f 4c 00 00       	call   c0104cb3 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 30 1f 00 00       	call   c0101fb9 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 82 20 00 00       	call   c0102110 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 29 79 00 00       	call   c01079bc <vmm_init>

    ide_init();                 // init ide devices
c0100093:	e8 74 16 00 00       	call   c010170c <ide_init>
    swap_init();                // init swap
c0100098:	e8 d9 5f 00 00       	call   c0106076 <swap_init>

    clock_init();               // init clock interrupt
c010009d:	e8 ef 0c 00 00       	call   c0100d91 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a2:	e8 80 1e 00 00       	call   c0101f27 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a7:	eb fe                	jmp    c01000a7 <kern_init+0x7d>

c01000a9 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a9:	55                   	push   %ebp
c01000aa:	89 e5                	mov    %esp,%ebp
c01000ac:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b6:	00 
c01000b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000be:	00 
c01000bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c6:	e8 f8 0b 00 00       	call   c0100cc3 <mon_backtrace>
}
c01000cb:	c9                   	leave  
c01000cc:	c3                   	ret    

c01000cd <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cd:	55                   	push   %ebp
c01000ce:	89 e5                	mov    %esp,%ebp
c01000d0:	53                   	push   %ebx
c01000d1:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d4:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000da:	8d 55 08             	lea    0x8(%ebp),%edx
c01000dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000ec:	89 04 24             	mov    %eax,(%esp)
c01000ef:	e8 b5 ff ff ff       	call   c01000a9 <grade_backtrace2>
}
c01000f4:	83 c4 14             	add    $0x14,%esp
c01000f7:	5b                   	pop    %ebx
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 bb ff ff ff       	call   c01000cd <grade_backtrace1>
}
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <grade_backtrace>:

void
grade_backtrace(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011a:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c010011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100126:	ff 
c0100127:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100132:	e8 c3 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c0100137:	c9                   	leave  
c0100138:	c3                   	ret    

c0100139 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100139:	55                   	push   %ebp
c010013a:	89 e5                	mov    %esp,%ebp
c010013c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100142:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100145:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100148:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010014b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014f:	0f b7 c0             	movzwl %ax,%eax
c0100152:	83 e0 03             	and    $0x3,%eax
c0100155:	89 c2                	mov    %eax,%edx
c0100157:	a1 a0 1a 12 c0       	mov    0xc0121aa0,%eax
c010015c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100160:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100164:	c7 04 24 21 91 10 c0 	movl   $0xc0109121,(%esp)
c010016b:	e8 db 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100170:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100174:	0f b7 d0             	movzwl %ax,%edx
c0100177:	a1 a0 1a 12 c0       	mov    0xc0121aa0,%eax
c010017c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100180:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100184:	c7 04 24 2f 91 10 c0 	movl   $0xc010912f,(%esp)
c010018b:	e8 bb 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100190:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100194:	0f b7 d0             	movzwl %ax,%edx
c0100197:	a1 a0 1a 12 c0       	mov    0xc0121aa0,%eax
c010019c:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a4:	c7 04 24 3d 91 10 c0 	movl   $0xc010913d,(%esp)
c01001ab:	e8 9b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b4:	0f b7 d0             	movzwl %ax,%edx
c01001b7:	a1 a0 1a 12 c0       	mov    0xc0121aa0,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 4b 91 10 c0 	movl   $0xc010914b,(%esp)
c01001cb:	e8 7b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	0f b7 d0             	movzwl %ax,%edx
c01001d7:	a1 a0 1a 12 c0       	mov    0xc0121aa0,%eax
c01001dc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e4:	c7 04 24 59 91 10 c0 	movl   $0xc0109159,(%esp)
c01001eb:	e8 5b 01 00 00       	call   c010034b <cprintf>
    round ++;
c01001f0:	a1 a0 1a 12 c0       	mov    0xc0121aa0,%eax
c01001f5:	83 c0 01             	add    $0x1,%eax
c01001f8:	a3 a0 1a 12 c0       	mov    %eax,0xc0121aa0
}
c01001fd:	c9                   	leave  
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	5d                   	pop    %ebp
c0100203:	c3                   	ret    

c0100204 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100207:	5d                   	pop    %ebp
c0100208:	c3                   	ret    

c0100209 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100209:	55                   	push   %ebp
c010020a:	89 e5                	mov    %esp,%ebp
c010020c:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020f:	e8 25 ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100214:	c7 04 24 68 91 10 c0 	movl   $0xc0109168,(%esp)
c010021b:	e8 2b 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_user();
c0100220:	e8 da ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100225:	e8 0f ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022a:	c7 04 24 88 91 10 c0 	movl   $0xc0109188,(%esp)
c0100231:	e8 15 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_kernel();
c0100236:	e8 c9 ff ff ff       	call   c0100204 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023b:	e8 f9 fe ff ff       	call   c0100139 <lab1_print_cur_status>
}
c0100240:	c9                   	leave  
c0100241:	c3                   	ret    

c0100242 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100242:	55                   	push   %ebp
c0100243:	89 e5                	mov    %esp,%ebp
c0100245:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010024c:	74 13                	je     c0100261 <readline+0x1f>
        cprintf("%s", prompt);
c010024e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100251:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100255:	c7 04 24 a7 91 10 c0 	movl   $0xc01091a7,(%esp)
c010025c:	e8 ea 00 00 00       	call   c010034b <cprintf>
    }
    int i = 0, c;
c0100261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100268:	e8 66 01 00 00       	call   c01003d3 <getchar>
c010026d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100274:	79 07                	jns    c010027d <readline+0x3b>
            return NULL;
c0100276:	b8 00 00 00 00       	mov    $0x0,%eax
c010027b:	eb 79                	jmp    c01002f6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100281:	7e 28                	jle    c01002ab <readline+0x69>
c0100283:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028a:	7f 1f                	jg     c01002ab <readline+0x69>
            cputchar(c);
c010028c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028f:	89 04 24             	mov    %eax,(%esp)
c0100292:	e8 da 00 00 00       	call   c0100371 <cputchar>
            buf[i ++] = c;
c0100297:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029a:	8d 50 01             	lea    0x1(%eax),%edx
c010029d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a3:	88 90 c0 1a 12 c0    	mov    %dl,-0x3fede540(%eax)
c01002a9:	eb 46                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002ab:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002af:	75 17                	jne    c01002c8 <readline+0x86>
c01002b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b5:	7e 11                	jle    c01002c8 <readline+0x86>
            cputchar(c);
c01002b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ba:	89 04 24             	mov    %eax,(%esp)
c01002bd:	e8 af 00 00 00       	call   c0100371 <cputchar>
            i --;
c01002c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c6:	eb 29                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002cc:	74 06                	je     c01002d4 <readline+0x92>
c01002ce:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d2:	75 1d                	jne    c01002f1 <readline+0xaf>
            cputchar(c);
c01002d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d7:	89 04 24             	mov    %eax,(%esp)
c01002da:	e8 92 00 00 00       	call   c0100371 <cputchar>
            buf[i] = '\0';
c01002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e2:	05 c0 1a 12 c0       	add    $0xc0121ac0,%eax
c01002e7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ea:	b8 c0 1a 12 c0       	mov    $0xc0121ac0,%eax
c01002ef:	eb 05                	jmp    c01002f6 <readline+0xb4>
        }
    }
c01002f1:	e9 72 ff ff ff       	jmp    c0100268 <readline+0x26>
}
c01002f6:	c9                   	leave  
c01002f7:	c3                   	ret    

c01002f8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f8:	55                   	push   %ebp
c01002f9:	89 e5                	mov    %esp,%ebp
c01002fb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100301:	89 04 24             	mov    %eax,(%esp)
c0100304:	e8 fe 12 00 00       	call   c0101607 <cons_putc>
    (*cnt) ++;
c0100309:	8b 45 0c             	mov    0xc(%ebp),%eax
c010030c:	8b 00                	mov    (%eax),%eax
c010030e:	8d 50 01             	lea    0x1(%eax),%edx
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	89 10                	mov    %edx,(%eax)
}
c0100316:	c9                   	leave  
c0100317:	c3                   	ret    

c0100318 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100318:	55                   	push   %ebp
c0100319:	89 e5                	mov    %esp,%ebp
c010031b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100325:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100328:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010032c:	8b 45 08             	mov    0x8(%ebp),%eax
c010032f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100333:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033a:	c7 04 24 f8 02 10 c0 	movl   $0xc01002f8,(%esp)
c0100341:	e8 61 83 00 00       	call   c01086a7 <vprintfmt>
    return cnt;
c0100346:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100349:	c9                   	leave  
c010034a:	c3                   	ret    

c010034b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010034b:	55                   	push   %ebp
c010034c:	89 e5                	mov    %esp,%ebp
c010034e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100351:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010035a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100361:	89 04 24             	mov    %eax,(%esp)
c0100364:	e8 af ff ff ff       	call   c0100318 <vcprintf>
c0100369:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036f:	c9                   	leave  
c0100370:	c3                   	ret    

c0100371 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100371:	55                   	push   %ebp
c0100372:	89 e5                	mov    %esp,%ebp
c0100374:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100377:	8b 45 08             	mov    0x8(%ebp),%eax
c010037a:	89 04 24             	mov    %eax,(%esp)
c010037d:	e8 85 12 00 00       	call   c0101607 <cons_putc>
}
c0100382:	c9                   	leave  
c0100383:	c3                   	ret    

c0100384 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100384:	55                   	push   %ebp
c0100385:	89 e5                	mov    %esp,%ebp
c0100387:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010038a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100391:	eb 13                	jmp    c01003a6 <cputs+0x22>
        cputch(c, &cnt);
c0100393:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100397:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010039a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039e:	89 04 24             	mov    %eax,(%esp)
c01003a1:	e8 52 ff ff ff       	call   c01002f8 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a9:	8d 50 01             	lea    0x1(%eax),%edx
c01003ac:	89 55 08             	mov    %edx,0x8(%ebp)
c01003af:	0f b6 00             	movzbl (%eax),%eax
c01003b2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b9:	75 d8                	jne    c0100393 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c9:	e8 2a ff ff ff       	call   c01002f8 <cputch>
    return cnt;
c01003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d1:	c9                   	leave  
c01003d2:	c3                   	ret    

c01003d3 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d3:	55                   	push   %ebp
c01003d4:	89 e5                	mov    %esp,%ebp
c01003d6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d9:	e8 65 12 00 00       	call   c0101643 <cons_getc>
c01003de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e5:	74 f2                	je     c01003d9 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003ea:	c9                   	leave  
c01003eb:	c3                   	ret    

c01003ec <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003ec:	55                   	push   %ebp
c01003ed:	89 e5                	mov    %esp,%ebp
c01003ef:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f5:	8b 00                	mov    (%eax),%eax
c01003f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100402:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100409:	e9 d2 00 00 00       	jmp    c01004e0 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100411:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100414:	01 d0                	add    %edx,%eax
c0100416:	89 c2                	mov    %eax,%edx
c0100418:	c1 ea 1f             	shr    $0x1f,%edx
c010041b:	01 d0                	add    %edx,%eax
c010041d:	d1 f8                	sar    %eax
c010041f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100422:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100425:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100428:	eb 04                	jmp    c010042e <stab_binsearch+0x42>
            m --;
c010042a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100431:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100434:	7c 1f                	jl     c0100455 <stab_binsearch+0x69>
c0100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100439:	89 d0                	mov    %edx,%eax
c010043b:	01 c0                	add    %eax,%eax
c010043d:	01 d0                	add    %edx,%eax
c010043f:	c1 e0 02             	shl    $0x2,%eax
c0100442:	89 c2                	mov    %eax,%edx
c0100444:	8b 45 08             	mov    0x8(%ebp),%eax
c0100447:	01 d0                	add    %edx,%eax
c0100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044d:	0f b6 c0             	movzbl %al,%eax
c0100450:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100453:	75 d5                	jne    c010042a <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045b:	7d 0b                	jge    c0100468 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100460:	83 c0 01             	add    $0x1,%eax
c0100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100466:	eb 78                	jmp    c01004e0 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100472:	89 d0                	mov    %edx,%eax
c0100474:	01 c0                	add    %eax,%eax
c0100476:	01 d0                	add    %edx,%eax
c0100478:	c1 e0 02             	shl    $0x2,%eax
c010047b:	89 c2                	mov    %eax,%edx
c010047d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100480:	01 d0                	add    %edx,%eax
c0100482:	8b 40 08             	mov    0x8(%eax),%eax
c0100485:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100488:	73 13                	jae    c010049d <stab_binsearch+0xb1>
            *region_left = m;
c010048a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100490:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100492:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100495:	83 c0 01             	add    $0x1,%eax
c0100498:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049b:	eb 43                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a0:	89 d0                	mov    %edx,%eax
c01004a2:	01 c0                	add    %eax,%eax
c01004a4:	01 d0                	add    %edx,%eax
c01004a6:	c1 e0 02             	shl    $0x2,%eax
c01004a9:	89 c2                	mov    %eax,%edx
c01004ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ae:	01 d0                	add    %edx,%eax
c01004b0:	8b 40 08             	mov    0x8(%eax),%eax
c01004b3:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b6:	76 16                	jbe    c01004ce <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004bb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004be:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c6:	83 e8 01             	sub    $0x1,%eax
c01004c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004cc:	eb 12                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d4:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004dc:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e6:	0f 8e 22 ff ff ff    	jle    c010040e <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f0:	75 0f                	jne    c0100501 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fd:	89 10                	mov    %edx,(%eax)
c01004ff:	eb 3f                	jmp    c0100540 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100501:	8b 45 10             	mov    0x10(%ebp),%eax
c0100504:	8b 00                	mov    (%eax),%eax
c0100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100509:	eb 04                	jmp    c010050f <stab_binsearch+0x123>
c010050b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100512:	8b 00                	mov    (%eax),%eax
c0100514:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100517:	7d 1f                	jge    c0100538 <stab_binsearch+0x14c>
c0100519:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051c:	89 d0                	mov    %edx,%eax
c010051e:	01 c0                	add    %eax,%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	c1 e0 02             	shl    $0x2,%eax
c0100525:	89 c2                	mov    %eax,%edx
c0100527:	8b 45 08             	mov    0x8(%ebp),%eax
c010052a:	01 d0                	add    %edx,%eax
c010052c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100530:	0f b6 c0             	movzbl %al,%eax
c0100533:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100536:	75 d3                	jne    c010050b <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053e:	89 10                	mov    %edx,(%eax)
    }
}
c0100540:	c9                   	leave  
c0100541:	c3                   	ret    

c0100542 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100542:	55                   	push   %ebp
c0100543:	89 e5                	mov    %esp,%ebp
c0100545:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054b:	c7 00 ac 91 10 c0    	movl   $0xc01091ac,(%eax)
    info->eip_line = 0;
c0100551:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010055b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055e:	c7 40 08 ac 91 10 c0 	movl   $0xc01091ac,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100568:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	8b 55 08             	mov    0x8(%ebp),%edx
c0100575:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100578:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100582:	c7 45 f4 14 b2 10 c0 	movl   $0xc010b214,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100589:	c7 45 f0 78 a7 11 c0 	movl   $0xc011a778,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100590:	c7 45 ec 79 a7 11 c0 	movl   $0xc011a779,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100597:	c7 45 e8 77 e1 11 c0 	movl   $0xc011e177,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a4:	76 0d                	jbe    c01005b3 <debuginfo_eip+0x71>
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	83 e8 01             	sub    $0x1,%eax
c01005ac:	0f b6 00             	movzbl (%eax),%eax
c01005af:	84 c0                	test   %al,%al
c01005b1:	74 0a                	je     c01005bd <debuginfo_eip+0x7b>
        return -1;
c01005b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b8:	e9 c0 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ca:	29 c2                	sub    %eax,%edx
c01005cc:	89 d0                	mov    %edx,%eax
c01005ce:	c1 f8 02             	sar    $0x2,%eax
c01005d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d7:	83 e8 01             	sub    $0x1,%eax
c01005da:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005eb:	00 
c01005ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fd:	89 04 24             	mov    %eax,(%esp)
c0100600:	e8 e7 fd ff ff       	call   c01003ec <stab_binsearch>
    if (lfile == 0)
c0100605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100608:	85 c0                	test   %eax,%eax
c010060a:	75 0a                	jne    c0100616 <debuginfo_eip+0xd4>
        return -1;
c010060c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100611:	e9 67 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100619:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010061c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100622:	8b 45 08             	mov    0x8(%ebp),%eax
c0100625:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100629:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100630:	00 
c0100631:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100634:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100638:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010063b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100642:	89 04 24             	mov    %eax,(%esp)
c0100645:	e8 a2 fd ff ff       	call   c01003ec <stab_binsearch>

    if (lfun <= rfun) {
c010064a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100650:	39 c2                	cmp    %eax,%edx
c0100652:	7f 7c                	jg     c01006d0 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100654:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100657:	89 c2                	mov    %eax,%edx
c0100659:	89 d0                	mov    %edx,%eax
c010065b:	01 c0                	add    %eax,%eax
c010065d:	01 d0                	add    %edx,%eax
c010065f:	c1 e0 02             	shl    $0x2,%eax
c0100662:	89 c2                	mov    %eax,%edx
c0100664:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100667:	01 d0                	add    %edx,%eax
c0100669:	8b 10                	mov    (%eax),%edx
c010066b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100671:	29 c1                	sub    %eax,%ecx
c0100673:	89 c8                	mov    %ecx,%eax
c0100675:	39 c2                	cmp    %eax,%edx
c0100677:	73 22                	jae    c010069b <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100679:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067c:	89 c2                	mov    %eax,%edx
c010067e:	89 d0                	mov    %edx,%eax
c0100680:	01 c0                	add    %eax,%eax
c0100682:	01 d0                	add    %edx,%eax
c0100684:	c1 e0 02             	shl    $0x2,%eax
c0100687:	89 c2                	mov    %eax,%edx
c0100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068c:	01 d0                	add    %edx,%eax
c010068e:	8b 10                	mov    (%eax),%edx
c0100690:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100693:	01 c2                	add    %eax,%edx
c0100695:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100698:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069e:	89 c2                	mov    %eax,%edx
c01006a0:	89 d0                	mov    %edx,%eax
c01006a2:	01 c0                	add    %eax,%eax
c01006a4:	01 d0                	add    %edx,%eax
c01006a6:	c1 e0 02             	shl    $0x2,%eax
c01006a9:	89 c2                	mov    %eax,%edx
c01006ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ae:	01 d0                	add    %edx,%eax
c01006b0:	8b 50 08             	mov    0x8(%eax),%edx
c01006b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bc:	8b 40 10             	mov    0x10(%eax),%eax
c01006bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006ce:	eb 15                	jmp    c01006e5 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e8:	8b 40 08             	mov    0x8(%eax),%eax
c01006eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f2:	00 
c01006f3:	89 04 24             	mov    %eax,(%esp)
c01006f6:	e8 df 86 00 00       	call   c0108dda <strfind>
c01006fb:	89 c2                	mov    %eax,%edx
c01006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100700:	8b 40 08             	mov    0x8(%eax),%eax
c0100703:	29 c2                	sub    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070b:	8b 45 08             	mov    0x8(%ebp),%eax
c010070e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100712:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100719:	00 
c010071a:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100721:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100724:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072b:	89 04 24             	mov    %eax,(%esp)
c010072e:	e8 b9 fc ff ff       	call   c01003ec <stab_binsearch>
    if (lline <= rline) {
c0100733:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100736:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100739:	39 c2                	cmp    %eax,%edx
c010073b:	7f 24                	jg     c0100761 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100740:	89 c2                	mov    %eax,%edx
c0100742:	89 d0                	mov    %edx,%eax
c0100744:	01 c0                	add    %eax,%eax
c0100746:	01 d0                	add    %edx,%eax
c0100748:	c1 e0 02             	shl    $0x2,%eax
c010074b:	89 c2                	mov    %eax,%edx
c010074d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100750:	01 d0                	add    %edx,%eax
c0100752:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100756:	0f b7 d0             	movzwl %ax,%edx
c0100759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075f:	eb 13                	jmp    c0100774 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100766:	e9 12 01 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076e:	83 e8 01             	sub    $0x1,%eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b3                	jne    c010076b <debuginfo_eip+0x229>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 97                	je     c010076b <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 46                	jl     c0100824 <debuginfo_eip+0x2e2>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007fb:	29 c1                	sub    %eax,%ecx
c01007fd:	89 c8                	mov    %ecx,%eax
c01007ff:	39 c2                	cmp    %eax,%edx
c0100801:	73 21                	jae    c0100824 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100806:	89 c2                	mov    %eax,%edx
c0100808:	89 d0                	mov    %edx,%eax
c010080a:	01 c0                	add    %eax,%eax
c010080c:	01 d0                	add    %edx,%eax
c010080e:	c1 e0 02             	shl    $0x2,%eax
c0100811:	89 c2                	mov    %eax,%edx
c0100813:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	8b 10                	mov    (%eax),%edx
c010081a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081d:	01 c2                	add    %eax,%edx
c010081f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100822:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100824:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100827:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010082a:	39 c2                	cmp    %eax,%edx
c010082c:	7d 4a                	jge    c0100878 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100831:	83 c0 01             	add    $0x1,%eax
c0100834:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100837:	eb 18                	jmp    c0100851 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100839:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083c:	8b 40 14             	mov    0x14(%eax),%eax
c010083f:	8d 50 01             	lea    0x1(%eax),%edx
c0100842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100845:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084b:	83 c0 01             	add    $0x1,%eax
c010084e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100851:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100854:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100857:	39 c2                	cmp    %eax,%edx
c0100859:	7d 1d                	jge    c0100878 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	89 d0                	mov    %edx,%eax
c0100862:	01 c0                	add    %eax,%eax
c0100864:	01 d0                	add    %edx,%eax
c0100866:	c1 e0 02             	shl    $0x2,%eax
c0100869:	89 c2                	mov    %eax,%edx
c010086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086e:	01 d0                	add    %edx,%eax
c0100870:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100874:	3c a0                	cmp    $0xa0,%al
c0100876:	74 c1                	je     c0100839 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100878:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087d:	c9                   	leave  
c010087e:	c3                   	ret    

c010087f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087f:	55                   	push   %ebp
c0100880:	89 e5                	mov    %esp,%ebp
c0100882:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100885:	c7 04 24 b6 91 10 c0 	movl   $0xc01091b6,(%esp)
c010088c:	e8 ba fa ff ff       	call   c010034b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100891:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100898:	c0 
c0100899:	c7 04 24 cf 91 10 c0 	movl   $0xc01091cf,(%esp)
c01008a0:	e8 a6 fa ff ff       	call   c010034b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a5:	c7 44 24 04 ef 90 10 	movl   $0xc01090ef,0x4(%esp)
c01008ac:	c0 
c01008ad:	c7 04 24 e7 91 10 c0 	movl   $0xc01091e7,(%esp)
c01008b4:	e8 92 fa ff ff       	call   c010034b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b9:	c7 44 24 04 88 1a 12 	movl   $0xc0121a88,0x4(%esp)
c01008c0:	c0 
c01008c1:	c7 04 24 ff 91 10 c0 	movl   $0xc01091ff,(%esp)
c01008c8:	e8 7e fa ff ff       	call   c010034b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008cd:	c7 44 24 04 d0 2b 12 	movl   $0xc0122bd0,0x4(%esp)
c01008d4:	c0 
c01008d5:	c7 04 24 17 92 10 c0 	movl   $0xc0109217,(%esp)
c01008dc:	e8 6a fa ff ff       	call   c010034b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e1:	b8 d0 2b 12 c0       	mov    $0xc0122bd0,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f1:	29 c2                	sub    %eax,%edx
c01008f3:	89 d0                	mov    %edx,%eax
c01008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fb:	85 c0                	test   %eax,%eax
c01008fd:	0f 48 c2             	cmovs  %edx,%eax
c0100900:	c1 f8 0a             	sar    $0xa,%eax
c0100903:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100907:	c7 04 24 30 92 10 c0 	movl   $0xc0109230,(%esp)
c010090e:	e8 38 fa ff ff       	call   c010034b <cprintf>
}
c0100913:	c9                   	leave  
c0100914:	c3                   	ret    

c0100915 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100915:	55                   	push   %ebp
c0100916:	89 e5                	mov    %esp,%ebp
c0100918:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100921:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 04 24             	mov    %eax,(%esp)
c010092b:	e8 12 fc ff ff       	call   c0100542 <debuginfo_eip>
c0100930:	85 c0                	test   %eax,%eax
c0100932:	74 15                	je     c0100949 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100934:	8b 45 08             	mov    0x8(%ebp),%eax
c0100937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093b:	c7 04 24 5a 92 10 c0 	movl   $0xc010925a,(%esp)
c0100942:	e8 04 fa ff ff       	call   c010034b <cprintf>
c0100947:	eb 6d                	jmp    c01009b6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100950:	eb 1c                	jmp    c010096e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100952:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100958:	01 d0                	add    %edx,%eax
c010095a:	0f b6 00             	movzbl (%eax),%eax
c010095d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100963:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100966:	01 ca                	add    %ecx,%edx
c0100968:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100971:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100974:	7f dc                	jg     c0100952 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100976:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097f:	01 d0                	add    %edx,%eax
c0100981:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100984:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100987:	8b 55 08             	mov    0x8(%ebp),%edx
c010098a:	89 d1                	mov    %edx,%ecx
c010098c:	29 c1                	sub    %eax,%ecx
c010098e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100991:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100994:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100998:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009aa:	c7 04 24 76 92 10 c0 	movl   $0xc0109276,(%esp)
c01009b1:	e8 95 f9 ff ff       	call   c010034b <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b6:	c9                   	leave  
c01009b7:	c3                   	ret    

c01009b8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b8:	55                   	push   %ebp
c01009b9:	89 e5                	mov    %esp,%ebp
c01009bb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009be:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c7:	c9                   	leave  
c01009c8:	c3                   	ret    

c01009c9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c9:	55                   	push   %ebp
c01009ca:	89 e5                	mov    %esp,%ebp
c01009cc:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cf:	89 e8                	mov    %ebp,%eax
c01009d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c01009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009da:	e8 d9 ff ff ff       	call   c01009b8 <read_eip>
c01009df:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// 循环打印，直到 STACKFRAME_DEPTH 栈的深度已经最大，并且还要满足ebp ！= 0
	int i;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
c01009e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e9:	e9 88 00 00 00       	jmp    c0100a76 <print_stackframe+0xad>
		cprintf("ebp: 0x%08x eip: 0x%08x args: ", ebp, eip);
c01009ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009fc:	c7 04 24 88 92 10 c0 	movl   $0xc0109288,(%esp)
c0100a03:	e8 43 f9 ff ff       	call   c010034b <cprintf>

		// ebp + 2才是第一个参数的地址，具体可以看笔记
		uint32_t *args = (uint32_t *)ebp + 2;
c0100a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0b:	83 c0 08             	add    $0x8,%eax
c0100a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		// 循环打印4个args
		int j;
		for (j = 0; j < 4; j++) {
c0100a11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a18:	eb 25                	jmp    c0100a3f <print_stackframe+0x76>
			cprintf("0x%08x ", args[j]);
c0100a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a27:	01 d0                	add    %edx,%eax
c0100a29:	8b 00                	mov    (%eax),%eax
c0100a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2f:	c7 04 24 a7 92 10 c0 	movl   $0xc01092a7,(%esp)
c0100a36:	e8 10 f9 ff ff       	call   c010034b <cprintf>
		// ebp + 2才是第一个参数的地址，具体可以看笔记
		uint32_t *args = (uint32_t *)ebp + 2;

		// 循环打印4个args
		int j;
		for (j = 0; j < 4; j++) {
c0100a3b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a3f:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a43:	7e d5                	jle    c0100a1a <print_stackframe+0x51>
			cprintf("0x%08x ", args[j]);
		}
		cprintf("\n");
c0100a45:	c7 04 24 af 92 10 c0 	movl   $0xc01092af,(%esp)
c0100a4c:	e8 fa f8 ff ff       	call   c010034b <cprintf>

		// 打印 kern/debug/kdebug.c:305: print_stackframe+22 类似这行的东西，应该是调试信息
		print_debuginfo(eip-1);
c0100a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a54:	83 e8 01             	sub    $0x1,%eax
c0100a57:	89 04 24             	mov    %eax,(%esp)
c0100a5a:	e8 b6 fe ff ff       	call   c0100915 <print_debuginfo>

		// 先把eip指向ebp+1的位置，即函数的返回地址（Return Address）
		eip = *((uint32_t *)ebp + 1);
c0100a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a62:	83 c0 04             	add    $0x4,%eax
c0100a65:	8b 00                	mov    (%eax),%eax
c0100a67:	89 45 f0             	mov    %eax,-0x10(%ebp)

		// ebp的内容给ebp回到上层调用函数
		ebp = *((uint32_t *)ebp);
c0100a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6d:	8b 00                	mov    (%eax),%eax
c0100a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();

	// 循环打印，直到 STACKFRAME_DEPTH 栈的深度已经最大，并且还要满足ebp ！= 0
	int i;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
c0100a72:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a76:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a7a:	7f 0a                	jg     c0100a86 <print_stackframe+0xbd>
c0100a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a80:	0f 85 68 ff ff ff    	jne    c01009ee <print_stackframe+0x25>
		eip = *((uint32_t *)ebp + 1);

		// ebp的内容给ebp回到上层调用函数
		ebp = *((uint32_t *)ebp);
	}
}
c0100a86:	c9                   	leave  
c0100a87:	c3                   	ret    

c0100a88 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a88:	55                   	push   %ebp
c0100a89:	89 e5                	mov    %esp,%ebp
c0100a8b:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a95:	eb 0c                	jmp    c0100aa3 <parse+0x1b>
            *buf ++ = '\0';
c0100a97:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9a:	8d 50 01             	lea    0x1(%eax),%edx
c0100a9d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa0:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa6:	0f b6 00             	movzbl (%eax),%eax
c0100aa9:	84 c0                	test   %al,%al
c0100aab:	74 1d                	je     c0100aca <parse+0x42>
c0100aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab0:	0f b6 00             	movzbl (%eax),%eax
c0100ab3:	0f be c0             	movsbl %al,%eax
c0100ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aba:	c7 04 24 34 93 10 c0 	movl   $0xc0109334,(%esp)
c0100ac1:	e8 e1 82 00 00       	call   c0108da7 <strchr>
c0100ac6:	85 c0                	test   %eax,%eax
c0100ac8:	75 cd                	jne    c0100a97 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0100acd:	0f b6 00             	movzbl (%eax),%eax
c0100ad0:	84 c0                	test   %al,%al
c0100ad2:	75 02                	jne    c0100ad6 <parse+0x4e>
            break;
c0100ad4:	eb 67                	jmp    c0100b3d <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ada:	75 14                	jne    c0100af0 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100adc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ae3:	00 
c0100ae4:	c7 04 24 39 93 10 c0 	movl   $0xc0109339,(%esp)
c0100aeb:	e8 5b f8 ff ff       	call   c010034b <cprintf>
        }
        argv[argc ++] = buf;
c0100af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af3:	8d 50 01             	lea    0x1(%eax),%edx
c0100af6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b03:	01 c2                	add    %eax,%edx
c0100b05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b08:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0a:	eb 04                	jmp    c0100b10 <parse+0x88>
            buf ++;
c0100b0c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b13:	0f b6 00             	movzbl (%eax),%eax
c0100b16:	84 c0                	test   %al,%al
c0100b18:	74 1d                	je     c0100b37 <parse+0xaf>
c0100b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1d:	0f b6 00             	movzbl (%eax),%eax
c0100b20:	0f be c0             	movsbl %al,%eax
c0100b23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b27:	c7 04 24 34 93 10 c0 	movl   $0xc0109334,(%esp)
c0100b2e:	e8 74 82 00 00       	call   c0108da7 <strchr>
c0100b33:	85 c0                	test   %eax,%eax
c0100b35:	74 d5                	je     c0100b0c <parse+0x84>
            buf ++;
        }
    }
c0100b37:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b38:	e9 66 ff ff ff       	jmp    c0100aa3 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b40:	c9                   	leave  
c0100b41:	c3                   	ret    

c0100b42 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b42:	55                   	push   %ebp
c0100b43:	89 e5                	mov    %esp,%ebp
c0100b45:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b48:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b52:	89 04 24             	mov    %eax,(%esp)
c0100b55:	e8 2e ff ff ff       	call   c0100a88 <parse>
c0100b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b61:	75 0a                	jne    c0100b6d <runcmd+0x2b>
        return 0;
c0100b63:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b68:	e9 85 00 00 00       	jmp    c0100bf2 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b74:	eb 5c                	jmp    c0100bd2 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b76:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b7c:	89 d0                	mov    %edx,%eax
c0100b7e:	01 c0                	add    %eax,%eax
c0100b80:	01 d0                	add    %edx,%eax
c0100b82:	c1 e0 02             	shl    $0x2,%eax
c0100b85:	05 20 10 12 c0       	add    $0xc0121020,%eax
c0100b8a:	8b 00                	mov    (%eax),%eax
c0100b8c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b90:	89 04 24             	mov    %eax,(%esp)
c0100b93:	e8 70 81 00 00       	call   c0108d08 <strcmp>
c0100b98:	85 c0                	test   %eax,%eax
c0100b9a:	75 32                	jne    c0100bce <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9f:	89 d0                	mov    %edx,%eax
c0100ba1:	01 c0                	add    %eax,%eax
c0100ba3:	01 d0                	add    %edx,%eax
c0100ba5:	c1 e0 02             	shl    $0x2,%eax
c0100ba8:	05 20 10 12 c0       	add    $0xc0121020,%eax
c0100bad:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bb3:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bbd:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc0:	83 c2 04             	add    $0x4,%edx
c0100bc3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc7:	89 0c 24             	mov    %ecx,(%esp)
c0100bca:	ff d0                	call   *%eax
c0100bcc:	eb 24                	jmp    c0100bf2 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd5:	83 f8 02             	cmp    $0x2,%eax
c0100bd8:	76 9c                	jbe    c0100b76 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bda:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be1:	c7 04 24 57 93 10 c0 	movl   $0xc0109357,(%esp)
c0100be8:	e8 5e f7 ff ff       	call   c010034b <cprintf>
    return 0;
c0100bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf2:	c9                   	leave  
c0100bf3:	c3                   	ret    

c0100bf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf4:	55                   	push   %ebp
c0100bf5:	89 e5                	mov    %esp,%ebp
c0100bf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bfa:	c7 04 24 70 93 10 c0 	movl   $0xc0109370,(%esp)
c0100c01:	e8 45 f7 ff ff       	call   c010034b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c06:	c7 04 24 98 93 10 c0 	movl   $0xc0109398,(%esp)
c0100c0d:	e8 39 f7 ff ff       	call   c010034b <cprintf>

    if (tf != NULL) {
c0100c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c16:	74 0b                	je     c0100c23 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1b:	89 04 24             	mov    %eax,(%esp)
c0100c1e:	e8 a5 16 00 00       	call   c01022c8 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c23:	c7 04 24 bd 93 10 c0 	movl   $0xc01093bd,(%esp)
c0100c2a:	e8 13 f6 ff ff       	call   c0100242 <readline>
c0100c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c36:	74 18                	je     c0100c50 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c42:	89 04 24             	mov    %eax,(%esp)
c0100c45:	e8 f8 fe ff ff       	call   c0100b42 <runcmd>
c0100c4a:	85 c0                	test   %eax,%eax
c0100c4c:	79 02                	jns    c0100c50 <kmonitor+0x5c>
                break;
c0100c4e:	eb 02                	jmp    c0100c52 <kmonitor+0x5e>
            }
        }
    }
c0100c50:	eb d1                	jmp    c0100c23 <kmonitor+0x2f>
}
c0100c52:	c9                   	leave  
c0100c53:	c3                   	ret    

c0100c54 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c54:	55                   	push   %ebp
c0100c55:	89 e5                	mov    %esp,%ebp
c0100c57:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c61:	eb 3f                	jmp    c0100ca2 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c66:	89 d0                	mov    %edx,%eax
c0100c68:	01 c0                	add    %eax,%eax
c0100c6a:	01 d0                	add    %edx,%eax
c0100c6c:	c1 e0 02             	shl    $0x2,%eax
c0100c6f:	05 20 10 12 c0       	add    $0xc0121020,%eax
c0100c74:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c77:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7a:	89 d0                	mov    %edx,%eax
c0100c7c:	01 c0                	add    %eax,%eax
c0100c7e:	01 d0                	add    %edx,%eax
c0100c80:	c1 e0 02             	shl    $0x2,%eax
c0100c83:	05 20 10 12 c0       	add    $0xc0121020,%eax
c0100c88:	8b 00                	mov    (%eax),%eax
c0100c8a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c92:	c7 04 24 c1 93 10 c0 	movl   $0xc01093c1,(%esp)
c0100c99:	e8 ad f6 ff ff       	call   c010034b <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca5:	83 f8 02             	cmp    $0x2,%eax
c0100ca8:	76 b9                	jbe    c0100c63 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100caf:	c9                   	leave  
c0100cb0:	c3                   	ret    

c0100cb1 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb1:	55                   	push   %ebp
c0100cb2:	89 e5                	mov    %esp,%ebp
c0100cb4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb7:	e8 c3 fb ff ff       	call   c010087f <print_kerninfo>
    return 0;
c0100cbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc1:	c9                   	leave  
c0100cc2:	c3                   	ret    

c0100cc3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cc3:	55                   	push   %ebp
c0100cc4:	89 e5                	mov    %esp,%ebp
c0100cc6:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc9:	e8 fb fc ff ff       	call   c01009c9 <print_stackframe>
    return 0;
c0100cce:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd3:	c9                   	leave  
c0100cd4:	c3                   	ret    

c0100cd5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cd5:	55                   	push   %ebp
c0100cd6:	89 e5                	mov    %esp,%ebp
c0100cd8:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cdb:	a1 c0 1e 12 c0       	mov    0xc0121ec0,%eax
c0100ce0:	85 c0                	test   %eax,%eax
c0100ce2:	74 02                	je     c0100ce6 <__panic+0x11>
        goto panic_dead;
c0100ce4:	eb 48                	jmp    c0100d2e <__panic+0x59>
    }
    is_panic = 1;
c0100ce6:	c7 05 c0 1e 12 c0 01 	movl   $0x1,0xc0121ec0
c0100ced:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf0:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d04:	c7 04 24 ca 93 10 c0 	movl   $0xc01093ca,(%esp)
c0100d0b:	e8 3b f6 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d17:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d1a:	89 04 24             	mov    %eax,(%esp)
c0100d1d:	e8 f6 f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d22:	c7 04 24 e6 93 10 c0 	movl   $0xc01093e6,(%esp)
c0100d29:	e8 1d f6 ff ff       	call   c010034b <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d2e:	e8 fa 11 00 00       	call   c0101f2d <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d3a:	e8 b5 fe ff ff       	call   c0100bf4 <kmonitor>
    }
c0100d3f:	eb f2                	jmp    c0100d33 <__panic+0x5e>

c0100d41 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d41:	55                   	push   %ebp
c0100d42:	89 e5                	mov    %esp,%ebp
c0100d44:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d47:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d50:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d54:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5b:	c7 04 24 e8 93 10 c0 	movl   $0xc01093e8,(%esp)
c0100d62:	e8 e4 f5 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d6e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d71:	89 04 24             	mov    %eax,(%esp)
c0100d74:	e8 9f f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d79:	c7 04 24 e6 93 10 c0 	movl   $0xc01093e6,(%esp)
c0100d80:	e8 c6 f5 ff ff       	call   c010034b <cprintf>
    va_end(ap);
}
c0100d85:	c9                   	leave  
c0100d86:	c3                   	ret    

c0100d87 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d87:	55                   	push   %ebp
c0100d88:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d8a:	a1 c0 1e 12 c0       	mov    0xc0121ec0,%eax
}
c0100d8f:	5d                   	pop    %ebp
c0100d90:	c3                   	ret    

c0100d91 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d91:	55                   	push   %ebp
c0100d92:	89 e5                	mov    %esp,%ebp
c0100d94:	83 ec 28             	sub    $0x28,%esp
c0100d97:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d9d:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100da5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da9:	ee                   	out    %al,(%dx)
c0100daa:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100db4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dbc:	ee                   	out    %al,(%dx)
c0100dbd:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dc3:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dc7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dcb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dcf:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd0:	c7 05 dc 2a 12 c0 00 	movl   $0x0,0xc0122adc
c0100dd7:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dda:	c7 04 24 06 94 10 c0 	movl   $0xc0109406,(%esp)
c0100de1:	e8 65 f5 ff ff       	call   c010034b <cprintf>
    pic_enable(IRQ_TIMER);
c0100de6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100ded:	e8 99 11 00 00       	call   c0101f8b <pic_enable>
}
c0100df2:	c9                   	leave  
c0100df3:	c3                   	ret    

c0100df4 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100df4:	55                   	push   %ebp
c0100df5:	89 e5                	mov    %esp,%ebp
c0100df7:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dfa:	9c                   	pushf  
c0100dfb:	58                   	pop    %eax
c0100dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e02:	25 00 02 00 00       	and    $0x200,%eax
c0100e07:	85 c0                	test   %eax,%eax
c0100e09:	74 0c                	je     c0100e17 <__intr_save+0x23>
        intr_disable();
c0100e0b:	e8 1d 11 00 00       	call   c0101f2d <intr_disable>
        return 1;
c0100e10:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e15:	eb 05                	jmp    c0100e1c <__intr_save+0x28>
    }
    return 0;
c0100e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e1c:	c9                   	leave  
c0100e1d:	c3                   	ret    

c0100e1e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e1e:	55                   	push   %ebp
c0100e1f:	89 e5                	mov    %esp,%ebp
c0100e21:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e28:	74 05                	je     c0100e2f <__intr_restore+0x11>
        intr_enable();
c0100e2a:	e8 f8 10 00 00       	call   c0101f27 <intr_enable>
    }
}
c0100e2f:	c9                   	leave  
c0100e30:	c3                   	ret    

c0100e31 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e31:	55                   	push   %ebp
c0100e32:	89 e5                	mov    %esp,%ebp
c0100e34:	83 ec 10             	sub    $0x10,%esp
c0100e37:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e3d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e41:	89 c2                	mov    %eax,%edx
c0100e43:	ec                   	in     (%dx),%al
c0100e44:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e47:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e4d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e51:	89 c2                	mov    %eax,%edx
c0100e53:	ec                   	in     (%dx),%al
c0100e54:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e57:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e5d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e61:	89 c2                	mov    %eax,%edx
c0100e63:	ec                   	in     (%dx),%al
c0100e64:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e67:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e6d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e71:	89 c2                	mov    %eax,%edx
c0100e73:	ec                   	in     (%dx),%al
c0100e74:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e77:	c9                   	leave  
c0100e78:	c3                   	ret    

c0100e79 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e79:	55                   	push   %ebp
c0100e7a:	89 e5                	mov    %esp,%ebp
c0100e7c:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e7f:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e89:	0f b7 00             	movzwl (%eax),%eax
c0100e8c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e93:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9b:	0f b7 00             	movzwl (%eax),%eax
c0100e9e:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ea2:	74 12                	je     c0100eb6 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ea4:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eab:	66 c7 05 e6 1e 12 c0 	movw   $0x3b4,0xc0121ee6
c0100eb2:	b4 03 
c0100eb4:	eb 13                	jmp    c0100ec9 <cga_init+0x50>
    } else {
        *cp = was;
c0100eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ebd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec0:	66 c7 05 e6 1e 12 c0 	movw   $0x3d4,0xc0121ee6
c0100ec7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec9:	0f b7 05 e6 1e 12 c0 	movzwl 0xc0121ee6,%eax
c0100ed0:	0f b7 c0             	movzwl %ax,%eax
c0100ed3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ed7:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100edb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100edf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ee3:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ee4:	0f b7 05 e6 1e 12 c0 	movzwl 0xc0121ee6,%eax
c0100eeb:	83 c0 01             	add    $0x1,%eax
c0100eee:	0f b7 c0             	movzwl %ax,%eax
c0100ef1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef5:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef9:	89 c2                	mov    %eax,%edx
c0100efb:	ec                   	in     (%dx),%al
c0100efc:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100eff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f03:	0f b6 c0             	movzbl %al,%eax
c0100f06:	c1 e0 08             	shl    $0x8,%eax
c0100f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f0c:	0f b7 05 e6 1e 12 c0 	movzwl 0xc0121ee6,%eax
c0100f13:	0f b7 c0             	movzwl %ax,%eax
c0100f16:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f1a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f1e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f22:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f26:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f27:	0f b7 05 e6 1e 12 c0 	movzwl 0xc0121ee6,%eax
c0100f2e:	83 c0 01             	add    $0x1,%eax
c0100f31:	0f b7 c0             	movzwl %ax,%eax
c0100f34:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f38:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f3c:	89 c2                	mov    %eax,%edx
c0100f3e:	ec                   	in     (%dx),%al
c0100f3f:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f42:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f46:	0f b6 c0             	movzbl %al,%eax
c0100f49:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f4f:	a3 e0 1e 12 c0       	mov    %eax,0xc0121ee0
    crt_pos = pos;
c0100f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f57:	66 a3 e4 1e 12 c0    	mov    %ax,0xc0121ee4
}
c0100f5d:	c9                   	leave  
c0100f5e:	c3                   	ret    

c0100f5f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f5f:	55                   	push   %ebp
c0100f60:	89 e5                	mov    %esp,%ebp
c0100f62:	83 ec 48             	sub    $0x48,%esp
c0100f65:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f6b:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f6f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f73:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f77:	ee                   	out    %al,(%dx)
c0100f78:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f7e:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f82:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f86:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f8a:	ee                   	out    %al,(%dx)
c0100f8b:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f91:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f95:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f99:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f9d:	ee                   	out    %al,(%dx)
c0100f9e:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa4:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fa8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb0:	ee                   	out    %al,(%dx)
c0100fb1:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fb7:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fbb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fbf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fc3:	ee                   	out    %al,(%dx)
c0100fc4:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fca:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fce:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fd2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd6:	ee                   	out    %al,(%dx)
c0100fd7:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fdd:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe9:	ee                   	out    %al,(%dx)
c0100fea:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff0:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ff4:	89 c2                	mov    %eax,%edx
c0100ff6:	ec                   	in     (%dx),%al
c0100ff7:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ffa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ffe:	3c ff                	cmp    $0xff,%al
c0101000:	0f 95 c0             	setne  %al
c0101003:	0f b6 c0             	movzbl %al,%eax
c0101006:	a3 e8 1e 12 c0       	mov    %eax,0xc0121ee8
c010100b:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101011:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101015:	89 c2                	mov    %eax,%edx
c0101017:	ec                   	in     (%dx),%al
c0101018:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010101b:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101021:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101025:	89 c2                	mov    %eax,%edx
c0101027:	ec                   	in     (%dx),%al
c0101028:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010102b:	a1 e8 1e 12 c0       	mov    0xc0121ee8,%eax
c0101030:	85 c0                	test   %eax,%eax
c0101032:	74 0c                	je     c0101040 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101034:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010103b:	e8 4b 0f 00 00       	call   c0101f8b <pic_enable>
    }
}
c0101040:	c9                   	leave  
c0101041:	c3                   	ret    

c0101042 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101042:	55                   	push   %ebp
c0101043:	89 e5                	mov    %esp,%ebp
c0101045:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101048:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010104f:	eb 09                	jmp    c010105a <lpt_putc_sub+0x18>
        delay();
c0101051:	e8 db fd ff ff       	call   c0100e31 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101056:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010105a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101060:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101064:	89 c2                	mov    %eax,%edx
c0101066:	ec                   	in     (%dx),%al
c0101067:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010106a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010106e:	84 c0                	test   %al,%al
c0101070:	78 09                	js     c010107b <lpt_putc_sub+0x39>
c0101072:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101079:	7e d6                	jle    c0101051 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010107b:	8b 45 08             	mov    0x8(%ebp),%eax
c010107e:	0f b6 c0             	movzbl %al,%eax
c0101081:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101087:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010108a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010108e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101092:	ee                   	out    %al,(%dx)
c0101093:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101099:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010109d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010a5:	ee                   	out    %al,(%dx)
c01010a6:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010ac:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010b4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010b8:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b9:	c9                   	leave  
c01010ba:	c3                   	ret    

c01010bb <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010bb:	55                   	push   %ebp
c01010bc:	89 e5                	mov    %esp,%ebp
c01010be:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010c5:	74 0d                	je     c01010d4 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ca:	89 04 24             	mov    %eax,(%esp)
c01010cd:	e8 70 ff ff ff       	call   c0101042 <lpt_putc_sub>
c01010d2:	eb 24                	jmp    c01010f8 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010d4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010db:	e8 62 ff ff ff       	call   c0101042 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010e7:	e8 56 ff ff ff       	call   c0101042 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010ec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f3:	e8 4a ff ff ff       	call   c0101042 <lpt_putc_sub>
    }
}
c01010f8:	c9                   	leave  
c01010f9:	c3                   	ret    

c01010fa <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010fa:	55                   	push   %ebp
c01010fb:	89 e5                	mov    %esp,%ebp
c01010fd:	53                   	push   %ebx
c01010fe:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101101:	8b 45 08             	mov    0x8(%ebp),%eax
c0101104:	b0 00                	mov    $0x0,%al
c0101106:	85 c0                	test   %eax,%eax
c0101108:	75 07                	jne    c0101111 <cga_putc+0x17>
        c |= 0x0700;
c010110a:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101111:	8b 45 08             	mov    0x8(%ebp),%eax
c0101114:	0f b6 c0             	movzbl %al,%eax
c0101117:	83 f8 0a             	cmp    $0xa,%eax
c010111a:	74 4c                	je     c0101168 <cga_putc+0x6e>
c010111c:	83 f8 0d             	cmp    $0xd,%eax
c010111f:	74 57                	je     c0101178 <cga_putc+0x7e>
c0101121:	83 f8 08             	cmp    $0x8,%eax
c0101124:	0f 85 88 00 00 00    	jne    c01011b2 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010112a:	0f b7 05 e4 1e 12 c0 	movzwl 0xc0121ee4,%eax
c0101131:	66 85 c0             	test   %ax,%ax
c0101134:	74 30                	je     c0101166 <cga_putc+0x6c>
            crt_pos --;
c0101136:	0f b7 05 e4 1e 12 c0 	movzwl 0xc0121ee4,%eax
c010113d:	83 e8 01             	sub    $0x1,%eax
c0101140:	66 a3 e4 1e 12 c0    	mov    %ax,0xc0121ee4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101146:	a1 e0 1e 12 c0       	mov    0xc0121ee0,%eax
c010114b:	0f b7 15 e4 1e 12 c0 	movzwl 0xc0121ee4,%edx
c0101152:	0f b7 d2             	movzwl %dx,%edx
c0101155:	01 d2                	add    %edx,%edx
c0101157:	01 c2                	add    %eax,%edx
c0101159:	8b 45 08             	mov    0x8(%ebp),%eax
c010115c:	b0 00                	mov    $0x0,%al
c010115e:	83 c8 20             	or     $0x20,%eax
c0101161:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101164:	eb 72                	jmp    c01011d8 <cga_putc+0xde>
c0101166:	eb 70                	jmp    c01011d8 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101168:	0f b7 05 e4 1e 12 c0 	movzwl 0xc0121ee4,%eax
c010116f:	83 c0 50             	add    $0x50,%eax
c0101172:	66 a3 e4 1e 12 c0    	mov    %ax,0xc0121ee4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101178:	0f b7 1d e4 1e 12 c0 	movzwl 0xc0121ee4,%ebx
c010117f:	0f b7 0d e4 1e 12 c0 	movzwl 0xc0121ee4,%ecx
c0101186:	0f b7 c1             	movzwl %cx,%eax
c0101189:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010118f:	c1 e8 10             	shr    $0x10,%eax
c0101192:	89 c2                	mov    %eax,%edx
c0101194:	66 c1 ea 06          	shr    $0x6,%dx
c0101198:	89 d0                	mov    %edx,%eax
c010119a:	c1 e0 02             	shl    $0x2,%eax
c010119d:	01 d0                	add    %edx,%eax
c010119f:	c1 e0 04             	shl    $0x4,%eax
c01011a2:	29 c1                	sub    %eax,%ecx
c01011a4:	89 ca                	mov    %ecx,%edx
c01011a6:	89 d8                	mov    %ebx,%eax
c01011a8:	29 d0                	sub    %edx,%eax
c01011aa:	66 a3 e4 1e 12 c0    	mov    %ax,0xc0121ee4
        break;
c01011b0:	eb 26                	jmp    c01011d8 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011b2:	8b 0d e0 1e 12 c0    	mov    0xc0121ee0,%ecx
c01011b8:	0f b7 05 e4 1e 12 c0 	movzwl 0xc0121ee4,%eax
c01011bf:	8d 50 01             	lea    0x1(%eax),%edx
c01011c2:	66 89 15 e4 1e 12 c0 	mov    %dx,0xc0121ee4
c01011c9:	0f b7 c0             	movzwl %ax,%eax
c01011cc:	01 c0                	add    %eax,%eax
c01011ce:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d4:	66 89 02             	mov    %ax,(%edx)
        break;
c01011d7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d8:	0f b7 05 e4 1e 12 c0 	movzwl 0xc0121ee4,%eax
c01011df:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011e3:	76 5b                	jbe    c0101240 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011e5:	a1 e0 1e 12 c0       	mov    0xc0121ee0,%eax
c01011ea:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f0:	a1 e0 1e 12 c0       	mov    0xc0121ee0,%eax
c01011f5:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011fc:	00 
c01011fd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101201:	89 04 24             	mov    %eax,(%esp)
c0101204:	e8 9c 7d 00 00       	call   c0108fa5 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101209:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101210:	eb 15                	jmp    c0101227 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101212:	a1 e0 1e 12 c0       	mov    0xc0121ee0,%eax
c0101217:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010121a:	01 d2                	add    %edx,%edx
c010121c:	01 d0                	add    %edx,%eax
c010121e:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101223:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101227:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010122e:	7e e2                	jle    c0101212 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101230:	0f b7 05 e4 1e 12 c0 	movzwl 0xc0121ee4,%eax
c0101237:	83 e8 50             	sub    $0x50,%eax
c010123a:	66 a3 e4 1e 12 c0    	mov    %ax,0xc0121ee4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101240:	0f b7 05 e6 1e 12 c0 	movzwl 0xc0121ee6,%eax
c0101247:	0f b7 c0             	movzwl %ax,%eax
c010124a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010124e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101252:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101256:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010125a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010125b:	0f b7 05 e4 1e 12 c0 	movzwl 0xc0121ee4,%eax
c0101262:	66 c1 e8 08          	shr    $0x8,%ax
c0101266:	0f b6 c0             	movzbl %al,%eax
c0101269:	0f b7 15 e6 1e 12 c0 	movzwl 0xc0121ee6,%edx
c0101270:	83 c2 01             	add    $0x1,%edx
c0101273:	0f b7 d2             	movzwl %dx,%edx
c0101276:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010127a:	88 45 ed             	mov    %al,-0x13(%ebp)
c010127d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101281:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101285:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101286:	0f b7 05 e6 1e 12 c0 	movzwl 0xc0121ee6,%eax
c010128d:	0f b7 c0             	movzwl %ax,%eax
c0101290:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101294:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101298:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010129c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a0:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a1:	0f b7 05 e4 1e 12 c0 	movzwl 0xc0121ee4,%eax
c01012a8:	0f b6 c0             	movzbl %al,%eax
c01012ab:	0f b7 15 e6 1e 12 c0 	movzwl 0xc0121ee6,%edx
c01012b2:	83 c2 01             	add    $0x1,%edx
c01012b5:	0f b7 d2             	movzwl %dx,%edx
c01012b8:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012bc:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c7:	ee                   	out    %al,(%dx)
}
c01012c8:	83 c4 34             	add    $0x34,%esp
c01012cb:	5b                   	pop    %ebx
c01012cc:	5d                   	pop    %ebp
c01012cd:	c3                   	ret    

c01012ce <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012ce:	55                   	push   %ebp
c01012cf:	89 e5                	mov    %esp,%ebp
c01012d1:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012db:	eb 09                	jmp    c01012e6 <serial_putc_sub+0x18>
        delay();
c01012dd:	e8 4f fb ff ff       	call   c0100e31 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012ec:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f0:	89 c2                	mov    %eax,%edx
c01012f2:	ec                   	in     (%dx),%al
c01012f3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012fa:	0f b6 c0             	movzbl %al,%eax
c01012fd:	83 e0 20             	and    $0x20,%eax
c0101300:	85 c0                	test   %eax,%eax
c0101302:	75 09                	jne    c010130d <serial_putc_sub+0x3f>
c0101304:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010130b:	7e d0                	jle    c01012dd <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010130d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101310:	0f b6 c0             	movzbl %al,%eax
c0101313:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101319:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010131c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101320:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101324:	ee                   	out    %al,(%dx)
}
c0101325:	c9                   	leave  
c0101326:	c3                   	ret    

c0101327 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101327:	55                   	push   %ebp
c0101328:	89 e5                	mov    %esp,%ebp
c010132a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010132d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101331:	74 0d                	je     c0101340 <serial_putc+0x19>
        serial_putc_sub(c);
c0101333:	8b 45 08             	mov    0x8(%ebp),%eax
c0101336:	89 04 24             	mov    %eax,(%esp)
c0101339:	e8 90 ff ff ff       	call   c01012ce <serial_putc_sub>
c010133e:	eb 24                	jmp    c0101364 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101340:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101347:	e8 82 ff ff ff       	call   c01012ce <serial_putc_sub>
        serial_putc_sub(' ');
c010134c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101353:	e8 76 ff ff ff       	call   c01012ce <serial_putc_sub>
        serial_putc_sub('\b');
c0101358:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010135f:	e8 6a ff ff ff       	call   c01012ce <serial_putc_sub>
    }
}
c0101364:	c9                   	leave  
c0101365:	c3                   	ret    

c0101366 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101366:	55                   	push   %ebp
c0101367:	89 e5                	mov    %esp,%ebp
c0101369:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010136c:	eb 33                	jmp    c01013a1 <cons_intr+0x3b>
        if (c != 0) {
c010136e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101372:	74 2d                	je     c01013a1 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101374:	a1 04 21 12 c0       	mov    0xc0122104,%eax
c0101379:	8d 50 01             	lea    0x1(%eax),%edx
c010137c:	89 15 04 21 12 c0    	mov    %edx,0xc0122104
c0101382:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101385:	88 90 00 1f 12 c0    	mov    %dl,-0x3fede100(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010138b:	a1 04 21 12 c0       	mov    0xc0122104,%eax
c0101390:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101395:	75 0a                	jne    c01013a1 <cons_intr+0x3b>
                cons.wpos = 0;
c0101397:	c7 05 04 21 12 c0 00 	movl   $0x0,0xc0122104
c010139e:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a4:	ff d0                	call   *%eax
c01013a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013ad:	75 bf                	jne    c010136e <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013af:	c9                   	leave  
c01013b0:	c3                   	ret    

c01013b1 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b1:	55                   	push   %ebp
c01013b2:	89 e5                	mov    %esp,%ebp
c01013b4:	83 ec 10             	sub    $0x10,%esp
c01013b7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013bd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c1:	89 c2                	mov    %eax,%edx
c01013c3:	ec                   	in     (%dx),%al
c01013c4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013c7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013cb:	0f b6 c0             	movzbl %al,%eax
c01013ce:	83 e0 01             	and    $0x1,%eax
c01013d1:	85 c0                	test   %eax,%eax
c01013d3:	75 07                	jne    c01013dc <serial_proc_data+0x2b>
        return -1;
c01013d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013da:	eb 2a                	jmp    c0101406 <serial_proc_data+0x55>
c01013dc:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e6:	89 c2                	mov    %eax,%edx
c01013e8:	ec                   	in     (%dx),%al
c01013e9:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013ec:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f0:	0f b6 c0             	movzbl %al,%eax
c01013f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f6:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013fa:	75 07                	jne    c0101403 <serial_proc_data+0x52>
        c = '\b';
c01013fc:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101403:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101406:	c9                   	leave  
c0101407:	c3                   	ret    

c0101408 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101408:	55                   	push   %ebp
c0101409:	89 e5                	mov    %esp,%ebp
c010140b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010140e:	a1 e8 1e 12 c0       	mov    0xc0121ee8,%eax
c0101413:	85 c0                	test   %eax,%eax
c0101415:	74 0c                	je     c0101423 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101417:	c7 04 24 b1 13 10 c0 	movl   $0xc01013b1,(%esp)
c010141e:	e8 43 ff ff ff       	call   c0101366 <cons_intr>
    }
}
c0101423:	c9                   	leave  
c0101424:	c3                   	ret    

c0101425 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101425:	55                   	push   %ebp
c0101426:	89 e5                	mov    %esp,%ebp
c0101428:	83 ec 38             	sub    $0x38,%esp
c010142b:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101431:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101435:	89 c2                	mov    %eax,%edx
c0101437:	ec                   	in     (%dx),%al
c0101438:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010143b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010143f:	0f b6 c0             	movzbl %al,%eax
c0101442:	83 e0 01             	and    $0x1,%eax
c0101445:	85 c0                	test   %eax,%eax
c0101447:	75 0a                	jne    c0101453 <kbd_proc_data+0x2e>
        return -1;
c0101449:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010144e:	e9 59 01 00 00       	jmp    c01015ac <kbd_proc_data+0x187>
c0101453:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101459:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010145d:	89 c2                	mov    %eax,%edx
c010145f:	ec                   	in     (%dx),%al
c0101460:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101463:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101467:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010146a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010146e:	75 17                	jne    c0101487 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101470:	a1 08 21 12 c0       	mov    0xc0122108,%eax
c0101475:	83 c8 40             	or     $0x40,%eax
c0101478:	a3 08 21 12 c0       	mov    %eax,0xc0122108
        return 0;
c010147d:	b8 00 00 00 00       	mov    $0x0,%eax
c0101482:	e9 25 01 00 00       	jmp    c01015ac <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101487:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148b:	84 c0                	test   %al,%al
c010148d:	79 47                	jns    c01014d6 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010148f:	a1 08 21 12 c0       	mov    0xc0122108,%eax
c0101494:	83 e0 40             	and    $0x40,%eax
c0101497:	85 c0                	test   %eax,%eax
c0101499:	75 09                	jne    c01014a4 <kbd_proc_data+0x7f>
c010149b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149f:	83 e0 7f             	and    $0x7f,%eax
c01014a2:	eb 04                	jmp    c01014a8 <kbd_proc_data+0x83>
c01014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a8:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014af:	0f b6 80 60 10 12 c0 	movzbl -0x3fedefa0(%eax),%eax
c01014b6:	83 c8 40             	or     $0x40,%eax
c01014b9:	0f b6 c0             	movzbl %al,%eax
c01014bc:	f7 d0                	not    %eax
c01014be:	89 c2                	mov    %eax,%edx
c01014c0:	a1 08 21 12 c0       	mov    0xc0122108,%eax
c01014c5:	21 d0                	and    %edx,%eax
c01014c7:	a3 08 21 12 c0       	mov    %eax,0xc0122108
        return 0;
c01014cc:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d1:	e9 d6 00 00 00       	jmp    c01015ac <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d6:	a1 08 21 12 c0       	mov    0xc0122108,%eax
c01014db:	83 e0 40             	and    $0x40,%eax
c01014de:	85 c0                	test   %eax,%eax
c01014e0:	74 11                	je     c01014f3 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014e2:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e6:	a1 08 21 12 c0       	mov    0xc0122108,%eax
c01014eb:	83 e0 bf             	and    $0xffffffbf,%eax
c01014ee:	a3 08 21 12 c0       	mov    %eax,0xc0122108
    }

    shift |= shiftcode[data];
c01014f3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f7:	0f b6 80 60 10 12 c0 	movzbl -0x3fedefa0(%eax),%eax
c01014fe:	0f b6 d0             	movzbl %al,%edx
c0101501:	a1 08 21 12 c0       	mov    0xc0122108,%eax
c0101506:	09 d0                	or     %edx,%eax
c0101508:	a3 08 21 12 c0       	mov    %eax,0xc0122108
    shift ^= togglecode[data];
c010150d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101511:	0f b6 80 60 11 12 c0 	movzbl -0x3fedeea0(%eax),%eax
c0101518:	0f b6 d0             	movzbl %al,%edx
c010151b:	a1 08 21 12 c0       	mov    0xc0122108,%eax
c0101520:	31 d0                	xor    %edx,%eax
c0101522:	a3 08 21 12 c0       	mov    %eax,0xc0122108

    c = charcode[shift & (CTL | SHIFT)][data];
c0101527:	a1 08 21 12 c0       	mov    0xc0122108,%eax
c010152c:	83 e0 03             	and    $0x3,%eax
c010152f:	8b 14 85 60 15 12 c0 	mov    -0x3fedeaa0(,%eax,4),%edx
c0101536:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010153a:	01 d0                	add    %edx,%eax
c010153c:	0f b6 00             	movzbl (%eax),%eax
c010153f:	0f b6 c0             	movzbl %al,%eax
c0101542:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101545:	a1 08 21 12 c0       	mov    0xc0122108,%eax
c010154a:	83 e0 08             	and    $0x8,%eax
c010154d:	85 c0                	test   %eax,%eax
c010154f:	74 22                	je     c0101573 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101551:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101555:	7e 0c                	jle    c0101563 <kbd_proc_data+0x13e>
c0101557:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010155b:	7f 06                	jg     c0101563 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010155d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101561:	eb 10                	jmp    c0101573 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101563:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101567:	7e 0a                	jle    c0101573 <kbd_proc_data+0x14e>
c0101569:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010156d:	7f 04                	jg     c0101573 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010156f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101573:	a1 08 21 12 c0       	mov    0xc0122108,%eax
c0101578:	f7 d0                	not    %eax
c010157a:	83 e0 06             	and    $0x6,%eax
c010157d:	85 c0                	test   %eax,%eax
c010157f:	75 28                	jne    c01015a9 <kbd_proc_data+0x184>
c0101581:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101588:	75 1f                	jne    c01015a9 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010158a:	c7 04 24 21 94 10 c0 	movl   $0xc0109421,(%esp)
c0101591:	e8 b5 ed ff ff       	call   c010034b <cprintf>
c0101596:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010159c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015a4:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a8:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ac:	c9                   	leave  
c01015ad:	c3                   	ret    

c01015ae <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015ae:	55                   	push   %ebp
c01015af:	89 e5                	mov    %esp,%ebp
c01015b1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015b4:	c7 04 24 25 14 10 c0 	movl   $0xc0101425,(%esp)
c01015bb:	e8 a6 fd ff ff       	call   c0101366 <cons_intr>
}
c01015c0:	c9                   	leave  
c01015c1:	c3                   	ret    

c01015c2 <kbd_init>:

static void
kbd_init(void) {
c01015c2:	55                   	push   %ebp
c01015c3:	89 e5                	mov    %esp,%ebp
c01015c5:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015c8:	e8 e1 ff ff ff       	call   c01015ae <kbd_intr>
    pic_enable(IRQ_KBD);
c01015cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015d4:	e8 b2 09 00 00       	call   c0101f8b <pic_enable>
}
c01015d9:	c9                   	leave  
c01015da:	c3                   	ret    

c01015db <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015db:	55                   	push   %ebp
c01015dc:	89 e5                	mov    %esp,%ebp
c01015de:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e1:	e8 93 f8 ff ff       	call   c0100e79 <cga_init>
    serial_init();
c01015e6:	e8 74 f9 ff ff       	call   c0100f5f <serial_init>
    kbd_init();
c01015eb:	e8 d2 ff ff ff       	call   c01015c2 <kbd_init>
    if (!serial_exists) {
c01015f0:	a1 e8 1e 12 c0       	mov    0xc0121ee8,%eax
c01015f5:	85 c0                	test   %eax,%eax
c01015f7:	75 0c                	jne    c0101605 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f9:	c7 04 24 2d 94 10 c0 	movl   $0xc010942d,(%esp)
c0101600:	e8 46 ed ff ff       	call   c010034b <cprintf>
    }
}
c0101605:	c9                   	leave  
c0101606:	c3                   	ret    

c0101607 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101607:	55                   	push   %ebp
c0101608:	89 e5                	mov    %esp,%ebp
c010160a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010160d:	e8 e2 f7 ff ff       	call   c0100df4 <__intr_save>
c0101612:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101615:	8b 45 08             	mov    0x8(%ebp),%eax
c0101618:	89 04 24             	mov    %eax,(%esp)
c010161b:	e8 9b fa ff ff       	call   c01010bb <lpt_putc>
        cga_putc(c);
c0101620:	8b 45 08             	mov    0x8(%ebp),%eax
c0101623:	89 04 24             	mov    %eax,(%esp)
c0101626:	e8 cf fa ff ff       	call   c01010fa <cga_putc>
        serial_putc(c);
c010162b:	8b 45 08             	mov    0x8(%ebp),%eax
c010162e:	89 04 24             	mov    %eax,(%esp)
c0101631:	e8 f1 fc ff ff       	call   c0101327 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101636:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101639:	89 04 24             	mov    %eax,(%esp)
c010163c:	e8 dd f7 ff ff       	call   c0100e1e <__intr_restore>
}
c0101641:	c9                   	leave  
c0101642:	c3                   	ret    

c0101643 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101643:	55                   	push   %ebp
c0101644:	89 e5                	mov    %esp,%ebp
c0101646:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101650:	e8 9f f7 ff ff       	call   c0100df4 <__intr_save>
c0101655:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101658:	e8 ab fd ff ff       	call   c0101408 <serial_intr>
        kbd_intr();
c010165d:	e8 4c ff ff ff       	call   c01015ae <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101662:	8b 15 00 21 12 c0    	mov    0xc0122100,%edx
c0101668:	a1 04 21 12 c0       	mov    0xc0122104,%eax
c010166d:	39 c2                	cmp    %eax,%edx
c010166f:	74 31                	je     c01016a2 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101671:	a1 00 21 12 c0       	mov    0xc0122100,%eax
c0101676:	8d 50 01             	lea    0x1(%eax),%edx
c0101679:	89 15 00 21 12 c0    	mov    %edx,0xc0122100
c010167f:	0f b6 80 00 1f 12 c0 	movzbl -0x3fede100(%eax),%eax
c0101686:	0f b6 c0             	movzbl %al,%eax
c0101689:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010168c:	a1 00 21 12 c0       	mov    0xc0122100,%eax
c0101691:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101696:	75 0a                	jne    c01016a2 <cons_getc+0x5f>
                cons.rpos = 0;
c0101698:	c7 05 00 21 12 c0 00 	movl   $0x0,0xc0122100
c010169f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016a5:	89 04 24             	mov    %eax,(%esp)
c01016a8:	e8 71 f7 ff ff       	call   c0100e1e <__intr_restore>
    return c;
c01016ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b0:	c9                   	leave  
c01016b1:	c3                   	ret    

c01016b2 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016b2:	55                   	push   %ebp
c01016b3:	89 e5                	mov    %esp,%ebp
c01016b5:	83 ec 14             	sub    $0x14,%esp
c01016b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016bf:	90                   	nop
c01016c0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c4:	83 c0 07             	add    $0x7,%eax
c01016c7:	0f b7 c0             	movzwl %ax,%eax
c01016ca:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016ce:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016d2:	89 c2                	mov    %eax,%edx
c01016d4:	ec                   	in     (%dx),%al
c01016d5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016dc:	0f b6 c0             	movzbl %al,%eax
c01016df:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016e5:	25 80 00 00 00       	and    $0x80,%eax
c01016ea:	85 c0                	test   %eax,%eax
c01016ec:	75 d2                	jne    c01016c0 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016f2:	74 11                	je     c0101705 <ide_wait_ready+0x53>
c01016f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016f7:	83 e0 21             	and    $0x21,%eax
c01016fa:	85 c0                	test   %eax,%eax
c01016fc:	74 07                	je     c0101705 <ide_wait_ready+0x53>
        return -1;
c01016fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101703:	eb 05                	jmp    c010170a <ide_wait_ready+0x58>
    }
    return 0;
c0101705:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010170a:	c9                   	leave  
c010170b:	c3                   	ret    

c010170c <ide_init>:

void
ide_init(void) {
c010170c:	55                   	push   %ebp
c010170d:	89 e5                	mov    %esp,%ebp
c010170f:	57                   	push   %edi
c0101710:	53                   	push   %ebx
c0101711:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101717:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c010171d:	e9 d6 02 00 00       	jmp    c01019f8 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101722:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101726:	c1 e0 03             	shl    $0x3,%eax
c0101729:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101730:	29 c2                	sub    %eax,%edx
c0101732:	8d 82 20 21 12 c0    	lea    -0x3feddee0(%edx),%eax
c0101738:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c010173b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010173f:	66 d1 e8             	shr    %ax
c0101742:	0f b7 c0             	movzwl %ax,%eax
c0101745:	0f b7 04 85 4c 94 10 	movzwl -0x3fef6bb4(,%eax,4),%eax
c010174c:	c0 
c010174d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101751:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101755:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010175c:	00 
c010175d:	89 04 24             	mov    %eax,(%esp)
c0101760:	e8 4d ff ff ff       	call   c01016b2 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101765:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101769:	83 e0 01             	and    $0x1,%eax
c010176c:	c1 e0 04             	shl    $0x4,%eax
c010176f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101772:	0f b6 c0             	movzbl %al,%eax
c0101775:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101779:	83 c2 06             	add    $0x6,%edx
c010177c:	0f b7 d2             	movzwl %dx,%edx
c010177f:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101783:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101786:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010178a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010178e:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c010178f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101793:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010179a:	00 
c010179b:	89 04 24             	mov    %eax,(%esp)
c010179e:	e8 0f ff ff ff       	call   c01016b2 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017a3:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017a7:	83 c0 07             	add    $0x7,%eax
c01017aa:	0f b7 c0             	movzwl %ax,%eax
c01017ad:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017b1:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017b5:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017b9:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017bd:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017be:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017c9:	00 
c01017ca:	89 04 24             	mov    %eax,(%esp)
c01017cd:	e8 e0 fe ff ff       	call   c01016b2 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017d2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017d6:	83 c0 07             	add    $0x7,%eax
c01017d9:	0f b7 c0             	movzwl %ax,%eax
c01017dc:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017e0:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017e4:	89 c2                	mov    %eax,%edx
c01017e6:	ec                   	in     (%dx),%al
c01017e7:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017ea:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017ee:	84 c0                	test   %al,%al
c01017f0:	0f 84 f7 01 00 00    	je     c01019ed <ide_init+0x2e1>
c01017f6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101801:	00 
c0101802:	89 04 24             	mov    %eax,(%esp)
c0101805:	e8 a8 fe ff ff       	call   c01016b2 <ide_wait_ready>
c010180a:	85 c0                	test   %eax,%eax
c010180c:	0f 85 db 01 00 00    	jne    c01019ed <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101812:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101816:	c1 e0 03             	shl    $0x3,%eax
c0101819:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101820:	29 c2                	sub    %eax,%edx
c0101822:	8d 82 20 21 12 c0    	lea    -0x3feddee0(%edx),%eax
c0101828:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c010182b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010182f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101832:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101838:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010183b:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101842:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101845:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101848:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010184b:	89 cb                	mov    %ecx,%ebx
c010184d:	89 df                	mov    %ebx,%edi
c010184f:	89 c1                	mov    %eax,%ecx
c0101851:	fc                   	cld    
c0101852:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101854:	89 c8                	mov    %ecx,%eax
c0101856:	89 fb                	mov    %edi,%ebx
c0101858:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c010185b:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c010185e:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101867:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010186a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101870:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101873:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101876:	25 00 00 00 04       	and    $0x4000000,%eax
c010187b:	85 c0                	test   %eax,%eax
c010187d:	74 0e                	je     c010188d <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c010187f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101882:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101888:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010188b:	eb 09                	jmp    c0101896 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c010188d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101890:	8b 40 78             	mov    0x78(%eax),%eax
c0101893:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101896:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010189a:	c1 e0 03             	shl    $0x3,%eax
c010189d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018a4:	29 c2                	sub    %eax,%edx
c01018a6:	81 c2 20 21 12 c0    	add    $0xc0122120,%edx
c01018ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018af:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018b2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018b6:	c1 e0 03             	shl    $0x3,%eax
c01018b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c0:	29 c2                	sub    %eax,%edx
c01018c2:	81 c2 20 21 12 c0    	add    $0xc0122120,%edx
c01018c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018cb:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018d1:	83 c0 62             	add    $0x62,%eax
c01018d4:	0f b7 00             	movzwl (%eax),%eax
c01018d7:	0f b7 c0             	movzwl %ax,%eax
c01018da:	25 00 02 00 00       	and    $0x200,%eax
c01018df:	85 c0                	test   %eax,%eax
c01018e1:	75 24                	jne    c0101907 <ide_init+0x1fb>
c01018e3:	c7 44 24 0c 54 94 10 	movl   $0xc0109454,0xc(%esp)
c01018ea:	c0 
c01018eb:	c7 44 24 08 97 94 10 	movl   $0xc0109497,0x8(%esp)
c01018f2:	c0 
c01018f3:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01018fa:	00 
c01018fb:	c7 04 24 ac 94 10 c0 	movl   $0xc01094ac,(%esp)
c0101902:	e8 ce f3 ff ff       	call   c0100cd5 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101907:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010190b:	c1 e0 03             	shl    $0x3,%eax
c010190e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101915:	29 c2                	sub    %eax,%edx
c0101917:	8d 82 20 21 12 c0    	lea    -0x3feddee0(%edx),%eax
c010191d:	83 c0 0c             	add    $0xc,%eax
c0101920:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101926:	83 c0 36             	add    $0x36,%eax
c0101929:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c010192c:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101933:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010193a:	eb 34                	jmp    c0101970 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c010193c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010193f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101942:	01 c2                	add    %eax,%edx
c0101944:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101947:	8d 48 01             	lea    0x1(%eax),%ecx
c010194a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010194d:	01 c8                	add    %ecx,%eax
c010194f:	0f b6 00             	movzbl (%eax),%eax
c0101952:	88 02                	mov    %al,(%edx)
c0101954:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101957:	8d 50 01             	lea    0x1(%eax),%edx
c010195a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010195d:	01 c2                	add    %eax,%edx
c010195f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101962:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101965:	01 c8                	add    %ecx,%eax
c0101967:	0f b6 00             	movzbl (%eax),%eax
c010196a:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c010196c:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101970:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101973:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101976:	72 c4                	jb     c010193c <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101978:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010197e:	01 d0                	add    %edx,%eax
c0101980:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101983:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101986:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101989:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010198c:	85 c0                	test   %eax,%eax
c010198e:	74 0f                	je     c010199f <ide_init+0x293>
c0101990:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101993:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101996:	01 d0                	add    %edx,%eax
c0101998:	0f b6 00             	movzbl (%eax),%eax
c010199b:	3c 20                	cmp    $0x20,%al
c010199d:	74 d9                	je     c0101978 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c010199f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019a3:	c1 e0 03             	shl    $0x3,%eax
c01019a6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019ad:	29 c2                	sub    %eax,%edx
c01019af:	8d 82 20 21 12 c0    	lea    -0x3feddee0(%edx),%eax
c01019b5:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019b8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019bc:	c1 e0 03             	shl    $0x3,%eax
c01019bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c6:	29 c2                	sub    %eax,%edx
c01019c8:	8d 82 20 21 12 c0    	lea    -0x3feddee0(%edx),%eax
c01019ce:	8b 50 08             	mov    0x8(%eax),%edx
c01019d1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019d5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e1:	c7 04 24 be 94 10 c0 	movl   $0xc01094be,(%esp)
c01019e8:	e8 5e e9 ff ff       	call   c010034b <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019ed:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f1:	83 c0 01             	add    $0x1,%eax
c01019f4:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01019f8:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c01019fd:	0f 86 1f fd ff ff    	jbe    c0101722 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a03:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a0a:	e8 7c 05 00 00       	call   c0101f8b <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a0f:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a16:	e8 70 05 00 00       	call   c0101f8b <pic_enable>
}
c0101a1b:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a21:	5b                   	pop    %ebx
c0101a22:	5f                   	pop    %edi
c0101a23:	5d                   	pop    %ebp
c0101a24:	c3                   	ret    

c0101a25 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a25:	55                   	push   %ebp
c0101a26:	89 e5                	mov    %esp,%ebp
c0101a28:	83 ec 04             	sub    $0x4,%esp
c0101a2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a32:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a37:	77 24                	ja     c0101a5d <ide_device_valid+0x38>
c0101a39:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a3d:	c1 e0 03             	shl    $0x3,%eax
c0101a40:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a47:	29 c2                	sub    %eax,%edx
c0101a49:	8d 82 20 21 12 c0    	lea    -0x3feddee0(%edx),%eax
c0101a4f:	0f b6 00             	movzbl (%eax),%eax
c0101a52:	84 c0                	test   %al,%al
c0101a54:	74 07                	je     c0101a5d <ide_device_valid+0x38>
c0101a56:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a5b:	eb 05                	jmp    c0101a62 <ide_device_valid+0x3d>
c0101a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a62:	c9                   	leave  
c0101a63:	c3                   	ret    

c0101a64 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a64:	55                   	push   %ebp
c0101a65:	89 e5                	mov    %esp,%ebp
c0101a67:	83 ec 08             	sub    $0x8,%esp
c0101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a71:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a75:	89 04 24             	mov    %eax,(%esp)
c0101a78:	e8 a8 ff ff ff       	call   c0101a25 <ide_device_valid>
c0101a7d:	85 c0                	test   %eax,%eax
c0101a7f:	74 1b                	je     c0101a9c <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a81:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a85:	c1 e0 03             	shl    $0x3,%eax
c0101a88:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a8f:	29 c2                	sub    %eax,%edx
c0101a91:	8d 82 20 21 12 c0    	lea    -0x3feddee0(%edx),%eax
c0101a97:	8b 40 08             	mov    0x8(%eax),%eax
c0101a9a:	eb 05                	jmp    c0101aa1 <ide_device_size+0x3d>
    }
    return 0;
c0101a9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101aa1:	c9                   	leave  
c0101aa2:	c3                   	ret    

c0101aa3 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101aa3:	55                   	push   %ebp
c0101aa4:	89 e5                	mov    %esp,%ebp
c0101aa6:	57                   	push   %edi
c0101aa7:	53                   	push   %ebx
c0101aa8:	83 ec 50             	sub    $0x50,%esp
c0101aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aae:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101ab2:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ab9:	77 24                	ja     c0101adf <ide_read_secs+0x3c>
c0101abb:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101ac0:	77 1d                	ja     c0101adf <ide_read_secs+0x3c>
c0101ac2:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ac6:	c1 e0 03             	shl    $0x3,%eax
c0101ac9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ad0:	29 c2                	sub    %eax,%edx
c0101ad2:	8d 82 20 21 12 c0    	lea    -0x3feddee0(%edx),%eax
c0101ad8:	0f b6 00             	movzbl (%eax),%eax
c0101adb:	84 c0                	test   %al,%al
c0101add:	75 24                	jne    c0101b03 <ide_read_secs+0x60>
c0101adf:	c7 44 24 0c dc 94 10 	movl   $0xc01094dc,0xc(%esp)
c0101ae6:	c0 
c0101ae7:	c7 44 24 08 97 94 10 	movl   $0xc0109497,0x8(%esp)
c0101aee:	c0 
c0101aef:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101af6:	00 
c0101af7:	c7 04 24 ac 94 10 c0 	movl   $0xc01094ac,(%esp)
c0101afe:	e8 d2 f1 ff ff       	call   c0100cd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b03:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b0a:	77 0f                	ja     c0101b1b <ide_read_secs+0x78>
c0101b0c:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b12:	01 d0                	add    %edx,%eax
c0101b14:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b19:	76 24                	jbe    c0101b3f <ide_read_secs+0x9c>
c0101b1b:	c7 44 24 0c 04 95 10 	movl   $0xc0109504,0xc(%esp)
c0101b22:	c0 
c0101b23:	c7 44 24 08 97 94 10 	movl   $0xc0109497,0x8(%esp)
c0101b2a:	c0 
c0101b2b:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b32:	00 
c0101b33:	c7 04 24 ac 94 10 c0 	movl   $0xc01094ac,(%esp)
c0101b3a:	e8 96 f1 ff ff       	call   c0100cd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b3f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b43:	66 d1 e8             	shr    %ax
c0101b46:	0f b7 c0             	movzwl %ax,%eax
c0101b49:	0f b7 04 85 4c 94 10 	movzwl -0x3fef6bb4(,%eax,4),%eax
c0101b50:	c0 
c0101b51:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b55:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b59:	66 d1 e8             	shr    %ax
c0101b5c:	0f b7 c0             	movzwl %ax,%eax
c0101b5f:	0f b7 04 85 4e 94 10 	movzwl -0x3fef6bb2(,%eax,4),%eax
c0101b66:	c0 
c0101b67:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b6b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b76:	00 
c0101b77:	89 04 24             	mov    %eax,(%esp)
c0101b7a:	e8 33 fb ff ff       	call   c01016b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b7f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b83:	83 c0 02             	add    $0x2,%eax
c0101b86:	0f b7 c0             	movzwl %ax,%eax
c0101b89:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b8d:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101b99:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101b9a:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b9d:	0f b6 c0             	movzbl %al,%eax
c0101ba0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ba4:	83 c2 02             	add    $0x2,%edx
c0101ba7:	0f b7 d2             	movzwl %dx,%edx
c0101baa:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bae:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bb1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bb5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bb9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bbd:	0f b6 c0             	movzbl %al,%eax
c0101bc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bc4:	83 c2 03             	add    $0x3,%edx
c0101bc7:	0f b7 d2             	movzwl %dx,%edx
c0101bca:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bce:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bd1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bd5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101bd9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101bda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bdd:	c1 e8 08             	shr    $0x8,%eax
c0101be0:	0f b6 c0             	movzbl %al,%eax
c0101be3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101be7:	83 c2 04             	add    $0x4,%edx
c0101bea:	0f b7 d2             	movzwl %dx,%edx
c0101bed:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101bf1:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bf4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101bf8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101bfc:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c00:	c1 e8 10             	shr    $0x10,%eax
c0101c03:	0f b6 c0             	movzbl %al,%eax
c0101c06:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c0a:	83 c2 05             	add    $0x5,%edx
c0101c0d:	0f b7 d2             	movzwl %dx,%edx
c0101c10:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c14:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c17:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c1b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c1f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c20:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c24:	83 e0 01             	and    $0x1,%eax
c0101c27:	c1 e0 04             	shl    $0x4,%eax
c0101c2a:	89 c2                	mov    %eax,%edx
c0101c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c2f:	c1 e8 18             	shr    $0x18,%eax
c0101c32:	83 e0 0f             	and    $0xf,%eax
c0101c35:	09 d0                	or     %edx,%eax
c0101c37:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c3a:	0f b6 c0             	movzbl %al,%eax
c0101c3d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c41:	83 c2 06             	add    $0x6,%edx
c0101c44:	0f b7 d2             	movzwl %dx,%edx
c0101c47:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c4b:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c4e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c52:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c56:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c57:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c5b:	83 c0 07             	add    $0x7,%eax
c0101c5e:	0f b7 c0             	movzwl %ax,%eax
c0101c61:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c65:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c69:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c6d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c71:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c79:	eb 5a                	jmp    c0101cd5 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c7b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c7f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c86:	00 
c0101c87:	89 04 24             	mov    %eax,(%esp)
c0101c8a:	e8 23 fa ff ff       	call   c01016b2 <ide_wait_ready>
c0101c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c96:	74 02                	je     c0101c9a <ide_read_secs+0x1f7>
            goto out;
c0101c98:	eb 41                	jmp    c0101cdb <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101c9a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c9e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ca1:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ca4:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ca7:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cae:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cb1:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cb4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cb7:	89 cb                	mov    %ecx,%ebx
c0101cb9:	89 df                	mov    %ebx,%edi
c0101cbb:	89 c1                	mov    %eax,%ecx
c0101cbd:	fc                   	cld    
c0101cbe:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cc0:	89 c8                	mov    %ecx,%eax
c0101cc2:	89 fb                	mov    %edi,%ebx
c0101cc4:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101cc7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cca:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cce:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cd5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101cd9:	75 a0                	jne    c0101c7b <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101cde:	83 c4 50             	add    $0x50,%esp
c0101ce1:	5b                   	pop    %ebx
c0101ce2:	5f                   	pop    %edi
c0101ce3:	5d                   	pop    %ebp
c0101ce4:	c3                   	ret    

c0101ce5 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101ce5:	55                   	push   %ebp
c0101ce6:	89 e5                	mov    %esp,%ebp
c0101ce8:	56                   	push   %esi
c0101ce9:	53                   	push   %ebx
c0101cea:	83 ec 50             	sub    $0x50,%esp
c0101ced:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf0:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cf4:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101cfb:	77 24                	ja     c0101d21 <ide_write_secs+0x3c>
c0101cfd:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d02:	77 1d                	ja     c0101d21 <ide_write_secs+0x3c>
c0101d04:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d08:	c1 e0 03             	shl    $0x3,%eax
c0101d0b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d12:	29 c2                	sub    %eax,%edx
c0101d14:	8d 82 20 21 12 c0    	lea    -0x3feddee0(%edx),%eax
c0101d1a:	0f b6 00             	movzbl (%eax),%eax
c0101d1d:	84 c0                	test   %al,%al
c0101d1f:	75 24                	jne    c0101d45 <ide_write_secs+0x60>
c0101d21:	c7 44 24 0c dc 94 10 	movl   $0xc01094dc,0xc(%esp)
c0101d28:	c0 
c0101d29:	c7 44 24 08 97 94 10 	movl   $0xc0109497,0x8(%esp)
c0101d30:	c0 
c0101d31:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d38:	00 
c0101d39:	c7 04 24 ac 94 10 c0 	movl   $0xc01094ac,(%esp)
c0101d40:	e8 90 ef ff ff       	call   c0100cd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d45:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d4c:	77 0f                	ja     c0101d5d <ide_write_secs+0x78>
c0101d4e:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d54:	01 d0                	add    %edx,%eax
c0101d56:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d5b:	76 24                	jbe    c0101d81 <ide_write_secs+0x9c>
c0101d5d:	c7 44 24 0c 04 95 10 	movl   $0xc0109504,0xc(%esp)
c0101d64:	c0 
c0101d65:	c7 44 24 08 97 94 10 	movl   $0xc0109497,0x8(%esp)
c0101d6c:	c0 
c0101d6d:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d74:	00 
c0101d75:	c7 04 24 ac 94 10 c0 	movl   $0xc01094ac,(%esp)
c0101d7c:	e8 54 ef ff ff       	call   c0100cd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d81:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d85:	66 d1 e8             	shr    %ax
c0101d88:	0f b7 c0             	movzwl %ax,%eax
c0101d8b:	0f b7 04 85 4c 94 10 	movzwl -0x3fef6bb4(,%eax,4),%eax
c0101d92:	c0 
c0101d93:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d97:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d9b:	66 d1 e8             	shr    %ax
c0101d9e:	0f b7 c0             	movzwl %ax,%eax
c0101da1:	0f b7 04 85 4e 94 10 	movzwl -0x3fef6bb2(,%eax,4),%eax
c0101da8:	c0 
c0101da9:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101dad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101db1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101db8:	00 
c0101db9:	89 04 24             	mov    %eax,(%esp)
c0101dbc:	e8 f1 f8 ff ff       	call   c01016b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dc1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dc5:	83 c0 02             	add    $0x2,%eax
c0101dc8:	0f b7 c0             	movzwl %ax,%eax
c0101dcb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dcf:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101dd3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101dd7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ddb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ddc:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ddf:	0f b6 c0             	movzbl %al,%eax
c0101de2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101de6:	83 c2 02             	add    $0x2,%edx
c0101de9:	0f b7 d2             	movzwl %dx,%edx
c0101dec:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101df0:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101df3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101df7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101dfb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101dff:	0f b6 c0             	movzbl %al,%eax
c0101e02:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e06:	83 c2 03             	add    $0x3,%edx
c0101e09:	0f b7 d2             	movzwl %dx,%edx
c0101e0c:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e10:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e13:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e17:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e1b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e1f:	c1 e8 08             	shr    $0x8,%eax
c0101e22:	0f b6 c0             	movzbl %al,%eax
c0101e25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e29:	83 c2 04             	add    $0x4,%edx
c0101e2c:	0f b7 d2             	movzwl %dx,%edx
c0101e2f:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e33:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e36:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e3a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e3e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e42:	c1 e8 10             	shr    $0x10,%eax
c0101e45:	0f b6 c0             	movzbl %al,%eax
c0101e48:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e4c:	83 c2 05             	add    $0x5,%edx
c0101e4f:	0f b7 d2             	movzwl %dx,%edx
c0101e52:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e56:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e59:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e5d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e61:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e62:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e66:	83 e0 01             	and    $0x1,%eax
c0101e69:	c1 e0 04             	shl    $0x4,%eax
c0101e6c:	89 c2                	mov    %eax,%edx
c0101e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e71:	c1 e8 18             	shr    $0x18,%eax
c0101e74:	83 e0 0f             	and    $0xf,%eax
c0101e77:	09 d0                	or     %edx,%eax
c0101e79:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e7c:	0f b6 c0             	movzbl %al,%eax
c0101e7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e83:	83 c2 06             	add    $0x6,%edx
c0101e86:	0f b7 d2             	movzwl %dx,%edx
c0101e89:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e8d:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e90:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e94:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101e98:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101e99:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e9d:	83 c0 07             	add    $0x7,%eax
c0101ea0:	0f b7 c0             	movzwl %ax,%eax
c0101ea3:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101ea7:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101eab:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eaf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101eb3:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101eb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ebb:	eb 5a                	jmp    c0101f17 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ebd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ec8:	00 
c0101ec9:	89 04 24             	mov    %eax,(%esp)
c0101ecc:	e8 e1 f7 ff ff       	call   c01016b2 <ide_wait_ready>
c0101ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101ed8:	74 02                	je     c0101edc <ide_write_secs+0x1f7>
            goto out;
c0101eda:	eb 41                	jmp    c0101f1d <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101edc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ee0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ee3:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ee6:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ee9:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ef0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101ef3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ef6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101ef9:	89 cb                	mov    %ecx,%ebx
c0101efb:	89 de                	mov    %ebx,%esi
c0101efd:	89 c1                	mov    %eax,%ecx
c0101eff:	fc                   	cld    
c0101f00:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f02:	89 c8                	mov    %ecx,%eax
c0101f04:	89 f3                	mov    %esi,%ebx
c0101f06:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f09:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f0c:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f10:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f17:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f1b:	75 a0                	jne    c0101ebd <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f20:	83 c4 50             	add    $0x50,%esp
c0101f23:	5b                   	pop    %ebx
c0101f24:	5e                   	pop    %esi
c0101f25:	5d                   	pop    %ebp
c0101f26:	c3                   	ret    

c0101f27 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f27:	55                   	push   %ebp
c0101f28:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f2a:	fb                   	sti    
    sti();
}
c0101f2b:	5d                   	pop    %ebp
c0101f2c:	c3                   	ret    

c0101f2d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f2d:	55                   	push   %ebp
c0101f2e:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f30:	fa                   	cli    
    cli();
}
c0101f31:	5d                   	pop    %ebp
c0101f32:	c3                   	ret    

c0101f33 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f33:	55                   	push   %ebp
c0101f34:	89 e5                	mov    %esp,%ebp
c0101f36:	83 ec 14             	sub    $0x14,%esp
c0101f39:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f3c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f40:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f44:	66 a3 70 15 12 c0    	mov    %ax,0xc0121570
    if (did_init) {
c0101f4a:	a1 00 22 12 c0       	mov    0xc0122200,%eax
c0101f4f:	85 c0                	test   %eax,%eax
c0101f51:	74 36                	je     c0101f89 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f53:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f57:	0f b6 c0             	movzbl %al,%eax
c0101f5a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f60:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f63:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f67:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f6b:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f6c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f70:	66 c1 e8 08          	shr    $0x8,%ax
c0101f74:	0f b6 c0             	movzbl %al,%eax
c0101f77:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f7d:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f80:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f84:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f88:	ee                   	out    %al,(%dx)
    }
}
c0101f89:	c9                   	leave  
c0101f8a:	c3                   	ret    

c0101f8b <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f8b:	55                   	push   %ebp
c0101f8c:	89 e5                	mov    %esp,%ebp
c0101f8e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f91:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f94:	ba 01 00 00 00       	mov    $0x1,%edx
c0101f99:	89 c1                	mov    %eax,%ecx
c0101f9b:	d3 e2                	shl    %cl,%edx
c0101f9d:	89 d0                	mov    %edx,%eax
c0101f9f:	f7 d0                	not    %eax
c0101fa1:	89 c2                	mov    %eax,%edx
c0101fa3:	0f b7 05 70 15 12 c0 	movzwl 0xc0121570,%eax
c0101faa:	21 d0                	and    %edx,%eax
c0101fac:	0f b7 c0             	movzwl %ax,%eax
c0101faf:	89 04 24             	mov    %eax,(%esp)
c0101fb2:	e8 7c ff ff ff       	call   c0101f33 <pic_setmask>
}
c0101fb7:	c9                   	leave  
c0101fb8:	c3                   	ret    

c0101fb9 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fb9:	55                   	push   %ebp
c0101fba:	89 e5                	mov    %esp,%ebp
c0101fbc:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fbf:	c7 05 00 22 12 c0 01 	movl   $0x1,0xc0122200
c0101fc6:	00 00 00 
c0101fc9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fcf:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fd3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fd7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fdb:	ee                   	out    %al,(%dx)
c0101fdc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fe2:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fe6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101fea:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fee:	ee                   	out    %al,(%dx)
c0101fef:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101ff5:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101ff9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101ffd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102001:	ee                   	out    %al,(%dx)
c0102002:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102008:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010200c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102010:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102014:	ee                   	out    %al,(%dx)
c0102015:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010201b:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010201f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102023:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102027:	ee                   	out    %al,(%dx)
c0102028:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010202e:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102032:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102036:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010203a:	ee                   	out    %al,(%dx)
c010203b:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102041:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102045:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102049:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010204d:	ee                   	out    %al,(%dx)
c010204e:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102054:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102058:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010205c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102060:	ee                   	out    %al,(%dx)
c0102061:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102067:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010206b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010206f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102073:	ee                   	out    %al,(%dx)
c0102074:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010207a:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010207e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102082:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102086:	ee                   	out    %al,(%dx)
c0102087:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010208d:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102091:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102095:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102099:	ee                   	out    %al,(%dx)
c010209a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020a0:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020a4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020a8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020ac:	ee                   	out    %al,(%dx)
c01020ad:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020b3:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020b7:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020bb:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020bf:	ee                   	out    %al,(%dx)
c01020c0:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020c6:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020ca:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020ce:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020d2:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020d3:	0f b7 05 70 15 12 c0 	movzwl 0xc0121570,%eax
c01020da:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020de:	74 12                	je     c01020f2 <pic_init+0x139>
        pic_setmask(irq_mask);
c01020e0:	0f b7 05 70 15 12 c0 	movzwl 0xc0121570,%eax
c01020e7:	0f b7 c0             	movzwl %ax,%eax
c01020ea:	89 04 24             	mov    %eax,(%esp)
c01020ed:	e8 41 fe ff ff       	call   c0101f33 <pic_setmask>
    }
}
c01020f2:	c9                   	leave  
c01020f3:	c3                   	ret    

c01020f4 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020f4:	55                   	push   %ebp
c01020f5:	89 e5                	mov    %esp,%ebp
c01020f7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01020fa:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102101:	00 
c0102102:	c7 04 24 40 95 10 c0 	movl   $0xc0109540,(%esp)
c0102109:	e8 3d e2 ff ff       	call   c010034b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010210e:	c9                   	leave  
c010210f:	c3                   	ret    

c0102110 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102110:	55                   	push   %ebp
c0102111:	89 e5                	mov    %esp,%ebp
c0102113:	83 ec 10             	sub    $0x10,%esp
      */
	extern uintptr_t __vectors[];

	// 计算出有多少个IDT，依次遍历他们
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
c0102116:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010211d:	e9 c3 00 00 00       	jmp    c01021e5 <idt_init+0xd5>

		// 初始化若干IDT
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102122:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102125:	8b 04 85 00 16 12 c0 	mov    -0x3fedea00(,%eax,4),%eax
c010212c:	89 c2                	mov    %eax,%edx
c010212e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102131:	66 89 14 c5 20 22 12 	mov    %dx,-0x3feddde0(,%eax,8)
c0102138:	c0 
c0102139:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010213c:	66 c7 04 c5 22 22 12 	movw   $0x8,-0x3fedddde(,%eax,8)
c0102143:	c0 08 00 
c0102146:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102149:	0f b6 14 c5 24 22 12 	movzbl -0x3feddddc(,%eax,8),%edx
c0102150:	c0 
c0102151:	83 e2 e0             	and    $0xffffffe0,%edx
c0102154:	88 14 c5 24 22 12 c0 	mov    %dl,-0x3feddddc(,%eax,8)
c010215b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010215e:	0f b6 14 c5 24 22 12 	movzbl -0x3feddddc(,%eax,8),%edx
c0102165:	c0 
c0102166:	83 e2 1f             	and    $0x1f,%edx
c0102169:	88 14 c5 24 22 12 c0 	mov    %dl,-0x3feddddc(,%eax,8)
c0102170:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102173:	0f b6 14 c5 25 22 12 	movzbl -0x3feddddb(,%eax,8),%edx
c010217a:	c0 
c010217b:	83 e2 f0             	and    $0xfffffff0,%edx
c010217e:	83 ca 0e             	or     $0xe,%edx
c0102181:	88 14 c5 25 22 12 c0 	mov    %dl,-0x3feddddb(,%eax,8)
c0102188:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218b:	0f b6 14 c5 25 22 12 	movzbl -0x3feddddb(,%eax,8),%edx
c0102192:	c0 
c0102193:	83 e2 ef             	and    $0xffffffef,%edx
c0102196:	88 14 c5 25 22 12 c0 	mov    %dl,-0x3feddddb(,%eax,8)
c010219d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a0:	0f b6 14 c5 25 22 12 	movzbl -0x3feddddb(,%eax,8),%edx
c01021a7:	c0 
c01021a8:	83 e2 9f             	and    $0xffffff9f,%edx
c01021ab:	88 14 c5 25 22 12 c0 	mov    %dl,-0x3feddddb(,%eax,8)
c01021b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021b5:	0f b6 14 c5 25 22 12 	movzbl -0x3feddddb(,%eax,8),%edx
c01021bc:	c0 
c01021bd:	83 ca 80             	or     $0xffffff80,%edx
c01021c0:	88 14 c5 25 22 12 c0 	mov    %dl,-0x3feddddb(,%eax,8)
c01021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ca:	8b 04 85 00 16 12 c0 	mov    -0x3fedea00(,%eax,4),%eax
c01021d1:	c1 e8 10             	shr    $0x10,%eax
c01021d4:	89 c2                	mov    %eax,%edx
c01021d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d9:	66 89 14 c5 26 22 12 	mov    %dx,-0x3fedddda(,%eax,8)
c01021e0:	c0 
      */
	extern uintptr_t __vectors[];

	// 计算出有多少个IDT，依次遍历他们
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
c01021e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01021e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e8:	3d ff 00 00 00       	cmp    $0xff,%eax
c01021ed:	0f 86 2f ff ff ff    	jbe    c0102122 <idt_init+0x12>
		// 初始化若干IDT
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	}

	// T_SWITCH_TOK 的发生时机是在用户空间的，所以对应的dpl需要修改为DPL_USER。
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01021f3:	a1 e4 17 12 c0       	mov    0xc01217e4,%eax
c01021f8:	66 a3 e8 25 12 c0    	mov    %ax,0xc01225e8
c01021fe:	66 c7 05 ea 25 12 c0 	movw   $0x8,0xc01225ea
c0102205:	08 00 
c0102207:	0f b6 05 ec 25 12 c0 	movzbl 0xc01225ec,%eax
c010220e:	83 e0 e0             	and    $0xffffffe0,%eax
c0102211:	a2 ec 25 12 c0       	mov    %al,0xc01225ec
c0102216:	0f b6 05 ec 25 12 c0 	movzbl 0xc01225ec,%eax
c010221d:	83 e0 1f             	and    $0x1f,%eax
c0102220:	a2 ec 25 12 c0       	mov    %al,0xc01225ec
c0102225:	0f b6 05 ed 25 12 c0 	movzbl 0xc01225ed,%eax
c010222c:	83 e0 f0             	and    $0xfffffff0,%eax
c010222f:	83 c8 0e             	or     $0xe,%eax
c0102232:	a2 ed 25 12 c0       	mov    %al,0xc01225ed
c0102237:	0f b6 05 ed 25 12 c0 	movzbl 0xc01225ed,%eax
c010223e:	83 e0 ef             	and    $0xffffffef,%eax
c0102241:	a2 ed 25 12 c0       	mov    %al,0xc01225ed
c0102246:	0f b6 05 ed 25 12 c0 	movzbl 0xc01225ed,%eax
c010224d:	83 c8 60             	or     $0x60,%eax
c0102250:	a2 ed 25 12 c0       	mov    %al,0xc01225ed
c0102255:	0f b6 05 ed 25 12 c0 	movzbl 0xc01225ed,%eax
c010225c:	83 c8 80             	or     $0xffffff80,%eax
c010225f:	a2 ed 25 12 c0       	mov    %al,0xc01225ed
c0102264:	a1 e4 17 12 c0       	mov    0xc01217e4,%eax
c0102269:	c1 e8 10             	shr    $0x10,%eax
c010226c:	66 a3 ee 25 12 c0    	mov    %ax,0xc01225ee
c0102272:	c7 45 f8 80 15 12 c0 	movl   $0xc0121580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102279:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010227c:	0f 01 18             	lidtl  (%eax)

	// 加载IDT，只有特权级为0才允许执行
	lidt(&idt_pd);
}
c010227f:	c9                   	leave  
c0102280:	c3                   	ret    

c0102281 <trapname>:

static const char *
trapname(int trapno) {
c0102281:	55                   	push   %ebp
c0102282:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102284:	8b 45 08             	mov    0x8(%ebp),%eax
c0102287:	83 f8 13             	cmp    $0x13,%eax
c010228a:	77 0c                	ja     c0102298 <trapname+0x17>
        return excnames[trapno];
c010228c:	8b 45 08             	mov    0x8(%ebp),%eax
c010228f:	8b 04 85 20 99 10 c0 	mov    -0x3fef66e0(,%eax,4),%eax
c0102296:	eb 18                	jmp    c01022b0 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102298:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010229c:	7e 0d                	jle    c01022ab <trapname+0x2a>
c010229e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022a2:	7f 07                	jg     c01022ab <trapname+0x2a>
        return "Hardware Interrupt";
c01022a4:	b8 4a 95 10 c0       	mov    $0xc010954a,%eax
c01022a9:	eb 05                	jmp    c01022b0 <trapname+0x2f>
    }
    return "(unknown trap)";
c01022ab:	b8 5d 95 10 c0       	mov    $0xc010955d,%eax
}
c01022b0:	5d                   	pop    %ebp
c01022b1:	c3                   	ret    

c01022b2 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022b2:	55                   	push   %ebp
c01022b3:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01022b8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022bc:	66 83 f8 08          	cmp    $0x8,%ax
c01022c0:	0f 94 c0             	sete   %al
c01022c3:	0f b6 c0             	movzbl %al,%eax
}
c01022c6:	5d                   	pop    %ebp
c01022c7:	c3                   	ret    

c01022c8 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01022c8:	55                   	push   %ebp
c01022c9:	89 e5                	mov    %esp,%ebp
c01022cb:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01022ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022d5:	c7 04 24 9e 95 10 c0 	movl   $0xc010959e,(%esp)
c01022dc:	e8 6a e0 ff ff       	call   c010034b <cprintf>
    print_regs(&tf->tf_regs);
c01022e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01022e4:	89 04 24             	mov    %eax,(%esp)
c01022e7:	e8 a1 01 00 00       	call   c010248d <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01022ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ef:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01022f3:	0f b7 c0             	movzwl %ax,%eax
c01022f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022fa:	c7 04 24 af 95 10 c0 	movl   $0xc01095af,(%esp)
c0102301:	e8 45 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102306:	8b 45 08             	mov    0x8(%ebp),%eax
c0102309:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c010230d:	0f b7 c0             	movzwl %ax,%eax
c0102310:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102314:	c7 04 24 c2 95 10 c0 	movl   $0xc01095c2,(%esp)
c010231b:	e8 2b e0 ff ff       	call   c010034b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102320:	8b 45 08             	mov    0x8(%ebp),%eax
c0102323:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102327:	0f b7 c0             	movzwl %ax,%eax
c010232a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010232e:	c7 04 24 d5 95 10 c0 	movl   $0xc01095d5,(%esp)
c0102335:	e8 11 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010233a:	8b 45 08             	mov    0x8(%ebp),%eax
c010233d:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102341:	0f b7 c0             	movzwl %ax,%eax
c0102344:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102348:	c7 04 24 e8 95 10 c0 	movl   $0xc01095e8,(%esp)
c010234f:	e8 f7 df ff ff       	call   c010034b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102354:	8b 45 08             	mov    0x8(%ebp),%eax
c0102357:	8b 40 30             	mov    0x30(%eax),%eax
c010235a:	89 04 24             	mov    %eax,(%esp)
c010235d:	e8 1f ff ff ff       	call   c0102281 <trapname>
c0102362:	8b 55 08             	mov    0x8(%ebp),%edx
c0102365:	8b 52 30             	mov    0x30(%edx),%edx
c0102368:	89 44 24 08          	mov    %eax,0x8(%esp)
c010236c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102370:	c7 04 24 fb 95 10 c0 	movl   $0xc01095fb,(%esp)
c0102377:	e8 cf df ff ff       	call   c010034b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c010237c:	8b 45 08             	mov    0x8(%ebp),%eax
c010237f:	8b 40 34             	mov    0x34(%eax),%eax
c0102382:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102386:	c7 04 24 0d 96 10 c0 	movl   $0xc010960d,(%esp)
c010238d:	e8 b9 df ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102392:	8b 45 08             	mov    0x8(%ebp),%eax
c0102395:	8b 40 38             	mov    0x38(%eax),%eax
c0102398:	89 44 24 04          	mov    %eax,0x4(%esp)
c010239c:	c7 04 24 1c 96 10 c0 	movl   $0xc010961c,(%esp)
c01023a3:	e8 a3 df ff ff       	call   c010034b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ab:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023af:	0f b7 c0             	movzwl %ax,%eax
c01023b2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023b6:	c7 04 24 2b 96 10 c0 	movl   $0xc010962b,(%esp)
c01023bd:	e8 89 df ff ff       	call   c010034b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023c5:	8b 40 40             	mov    0x40(%eax),%eax
c01023c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023cc:	c7 04 24 3e 96 10 c0 	movl   $0xc010963e,(%esp)
c01023d3:	e8 73 df ff ff       	call   c010034b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01023e6:	eb 3e                	jmp    c0102426 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01023e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01023eb:	8b 50 40             	mov    0x40(%eax),%edx
c01023ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023f1:	21 d0                	and    %edx,%eax
c01023f3:	85 c0                	test   %eax,%eax
c01023f5:	74 28                	je     c010241f <print_trapframe+0x157>
c01023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023fa:	8b 04 85 a0 15 12 c0 	mov    -0x3fedea60(,%eax,4),%eax
c0102401:	85 c0                	test   %eax,%eax
c0102403:	74 1a                	je     c010241f <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0102405:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102408:	8b 04 85 a0 15 12 c0 	mov    -0x3fedea60(,%eax,4),%eax
c010240f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102413:	c7 04 24 4d 96 10 c0 	movl   $0xc010964d,(%esp)
c010241a:	e8 2c df ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010241f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102423:	d1 65 f0             	shll   -0x10(%ebp)
c0102426:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102429:	83 f8 17             	cmp    $0x17,%eax
c010242c:	76 ba                	jbe    c01023e8 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c010242e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102431:	8b 40 40             	mov    0x40(%eax),%eax
c0102434:	25 00 30 00 00       	and    $0x3000,%eax
c0102439:	c1 e8 0c             	shr    $0xc,%eax
c010243c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102440:	c7 04 24 51 96 10 c0 	movl   $0xc0109651,(%esp)
c0102447:	e8 ff de ff ff       	call   c010034b <cprintf>

    if (!trap_in_kernel(tf)) {
c010244c:	8b 45 08             	mov    0x8(%ebp),%eax
c010244f:	89 04 24             	mov    %eax,(%esp)
c0102452:	e8 5b fe ff ff       	call   c01022b2 <trap_in_kernel>
c0102457:	85 c0                	test   %eax,%eax
c0102459:	75 30                	jne    c010248b <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c010245b:	8b 45 08             	mov    0x8(%ebp),%eax
c010245e:	8b 40 44             	mov    0x44(%eax),%eax
c0102461:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102465:	c7 04 24 5a 96 10 c0 	movl   $0xc010965a,(%esp)
c010246c:	e8 da de ff ff       	call   c010034b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102471:	8b 45 08             	mov    0x8(%ebp),%eax
c0102474:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102478:	0f b7 c0             	movzwl %ax,%eax
c010247b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010247f:	c7 04 24 69 96 10 c0 	movl   $0xc0109669,(%esp)
c0102486:	e8 c0 de ff ff       	call   c010034b <cprintf>
    }
}
c010248b:	c9                   	leave  
c010248c:	c3                   	ret    

c010248d <print_regs>:

void
print_regs(struct pushregs *regs) {
c010248d:	55                   	push   %ebp
c010248e:	89 e5                	mov    %esp,%ebp
c0102490:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102493:	8b 45 08             	mov    0x8(%ebp),%eax
c0102496:	8b 00                	mov    (%eax),%eax
c0102498:	89 44 24 04          	mov    %eax,0x4(%esp)
c010249c:	c7 04 24 7c 96 10 c0 	movl   $0xc010967c,(%esp)
c01024a3:	e8 a3 de ff ff       	call   c010034b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ab:	8b 40 04             	mov    0x4(%eax),%eax
c01024ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b2:	c7 04 24 8b 96 10 c0 	movl   $0xc010968b,(%esp)
c01024b9:	e8 8d de ff ff       	call   c010034b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024be:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c1:	8b 40 08             	mov    0x8(%eax),%eax
c01024c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024c8:	c7 04 24 9a 96 10 c0 	movl   $0xc010969a,(%esp)
c01024cf:	e8 77 de ff ff       	call   c010034b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01024d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01024d7:	8b 40 0c             	mov    0xc(%eax),%eax
c01024da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024de:	c7 04 24 a9 96 10 c0 	movl   $0xc01096a9,(%esp)
c01024e5:	e8 61 de ff ff       	call   c010034b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01024ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ed:	8b 40 10             	mov    0x10(%eax),%eax
c01024f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024f4:	c7 04 24 b8 96 10 c0 	movl   $0xc01096b8,(%esp)
c01024fb:	e8 4b de ff ff       	call   c010034b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102500:	8b 45 08             	mov    0x8(%ebp),%eax
c0102503:	8b 40 14             	mov    0x14(%eax),%eax
c0102506:	89 44 24 04          	mov    %eax,0x4(%esp)
c010250a:	c7 04 24 c7 96 10 c0 	movl   $0xc01096c7,(%esp)
c0102511:	e8 35 de ff ff       	call   c010034b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102516:	8b 45 08             	mov    0x8(%ebp),%eax
c0102519:	8b 40 18             	mov    0x18(%eax),%eax
c010251c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102520:	c7 04 24 d6 96 10 c0 	movl   $0xc01096d6,(%esp)
c0102527:	e8 1f de ff ff       	call   c010034b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010252c:	8b 45 08             	mov    0x8(%ebp),%eax
c010252f:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102532:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102536:	c7 04 24 e5 96 10 c0 	movl   $0xc01096e5,(%esp)
c010253d:	e8 09 de ff ff       	call   c010034b <cprintf>
}
c0102542:	c9                   	leave  
c0102543:	c3                   	ret    

c0102544 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102544:	55                   	push   %ebp
c0102545:	89 e5                	mov    %esp,%ebp
c0102547:	53                   	push   %ebx
c0102548:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010254b:	8b 45 08             	mov    0x8(%ebp),%eax
c010254e:	8b 40 34             	mov    0x34(%eax),%eax
c0102551:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102554:	85 c0                	test   %eax,%eax
c0102556:	74 07                	je     c010255f <print_pgfault+0x1b>
c0102558:	b9 f4 96 10 c0       	mov    $0xc01096f4,%ecx
c010255d:	eb 05                	jmp    c0102564 <print_pgfault+0x20>
c010255f:	b9 05 97 10 c0       	mov    $0xc0109705,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102564:	8b 45 08             	mov    0x8(%ebp),%eax
c0102567:	8b 40 34             	mov    0x34(%eax),%eax
c010256a:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010256d:	85 c0                	test   %eax,%eax
c010256f:	74 07                	je     c0102578 <print_pgfault+0x34>
c0102571:	ba 57 00 00 00       	mov    $0x57,%edx
c0102576:	eb 05                	jmp    c010257d <print_pgfault+0x39>
c0102578:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c010257d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102580:	8b 40 34             	mov    0x34(%eax),%eax
c0102583:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102586:	85 c0                	test   %eax,%eax
c0102588:	74 07                	je     c0102591 <print_pgfault+0x4d>
c010258a:	b8 55 00 00 00       	mov    $0x55,%eax
c010258f:	eb 05                	jmp    c0102596 <print_pgfault+0x52>
c0102591:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102596:	0f 20 d3             	mov    %cr2,%ebx
c0102599:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c010259c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c010259f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01025a3:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01025a7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01025ab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01025af:	c7 04 24 14 97 10 c0 	movl   $0xc0109714,(%esp)
c01025b6:	e8 90 dd ff ff       	call   c010034b <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01025bb:	83 c4 34             	add    $0x34,%esp
c01025be:	5b                   	pop    %ebx
c01025bf:	5d                   	pop    %ebp
c01025c0:	c3                   	ret    

c01025c1 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025c1:	55                   	push   %ebp
c01025c2:	89 e5                	mov    %esp,%ebp
c01025c4:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ca:	89 04 24             	mov    %eax,(%esp)
c01025cd:	e8 72 ff ff ff       	call   c0102544 <print_pgfault>
    if (check_mm_struct != NULL) {
c01025d2:	a1 cc 2b 12 c0       	mov    0xc0122bcc,%eax
c01025d7:	85 c0                	test   %eax,%eax
c01025d9:	74 28                	je     c0102603 <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025db:	0f 20 d0             	mov    %cr2,%eax
c01025de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01025e4:	89 c1                	mov    %eax,%ecx
c01025e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01025e9:	8b 50 34             	mov    0x34(%eax),%edx
c01025ec:	a1 cc 2b 12 c0       	mov    0xc0122bcc,%eax
c01025f1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01025f5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01025f9:	89 04 24             	mov    %eax,(%esp)
c01025fc:	e8 28 5b 00 00       	call   c0108129 <do_pgfault>
c0102601:	eb 1c                	jmp    c010261f <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c0102603:	c7 44 24 08 37 97 10 	movl   $0xc0109737,0x8(%esp)
c010260a:	c0 
c010260b:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0102612:	00 
c0102613:	c7 04 24 4e 97 10 c0 	movl   $0xc010974e,(%esp)
c010261a:	e8 b6 e6 ff ff       	call   c0100cd5 <__panic>
}
c010261f:	c9                   	leave  
c0102620:	c3                   	ret    

c0102621 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102621:	55                   	push   %ebp
c0102622:	89 e5                	mov    %esp,%ebp
c0102624:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102627:	8b 45 08             	mov    0x8(%ebp),%eax
c010262a:	8b 40 30             	mov    0x30(%eax),%eax
c010262d:	83 f8 24             	cmp    $0x24,%eax
c0102630:	0f 84 c2 00 00 00    	je     c01026f8 <trap_dispatch+0xd7>
c0102636:	83 f8 24             	cmp    $0x24,%eax
c0102639:	77 18                	ja     c0102653 <trap_dispatch+0x32>
c010263b:	83 f8 20             	cmp    $0x20,%eax
c010263e:	74 7d                	je     c01026bd <trap_dispatch+0x9c>
c0102640:	83 f8 21             	cmp    $0x21,%eax
c0102643:	0f 84 d5 00 00 00    	je     c010271e <trap_dispatch+0xfd>
c0102649:	83 f8 0e             	cmp    $0xe,%eax
c010264c:	74 28                	je     c0102676 <trap_dispatch+0x55>
c010264e:	e9 0d 01 00 00       	jmp    c0102760 <trap_dispatch+0x13f>
c0102653:	83 f8 2e             	cmp    $0x2e,%eax
c0102656:	0f 82 04 01 00 00    	jb     c0102760 <trap_dispatch+0x13f>
c010265c:	83 f8 2f             	cmp    $0x2f,%eax
c010265f:	0f 86 33 01 00 00    	jbe    c0102798 <trap_dispatch+0x177>
c0102665:	83 e8 78             	sub    $0x78,%eax
c0102668:	83 f8 01             	cmp    $0x1,%eax
c010266b:	0f 87 ef 00 00 00    	ja     c0102760 <trap_dispatch+0x13f>
c0102671:	e9 ce 00 00 00       	jmp    c0102744 <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102676:	8b 45 08             	mov    0x8(%ebp),%eax
c0102679:	89 04 24             	mov    %eax,(%esp)
c010267c:	e8 40 ff ff ff       	call   c01025c1 <pgfault_handler>
c0102681:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102684:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102688:	74 2e                	je     c01026b8 <trap_dispatch+0x97>
            print_trapframe(tf);
c010268a:	8b 45 08             	mov    0x8(%ebp),%eax
c010268d:	89 04 24             	mov    %eax,(%esp)
c0102690:	e8 33 fc ff ff       	call   c01022c8 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102695:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102698:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010269c:	c7 44 24 08 5f 97 10 	movl   $0xc010975f,0x8(%esp)
c01026a3:	c0 
c01026a4:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c01026ab:	00 
c01026ac:	c7 04 24 4e 97 10 c0 	movl   $0xc010974e,(%esp)
c01026b3:	e8 1d e6 ff ff       	call   c0100cd5 <__panic>
        }
        break;
c01026b8:	e9 dc 00 00 00       	jmp    c0102799 <trap_dispatch+0x178>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    ticks++;
c01026bd:	a1 dc 2a 12 c0       	mov    0xc0122adc,%eax
c01026c2:	83 c0 01             	add    $0x1,%eax
c01026c5:	a3 dc 2a 12 c0       	mov    %eax,0xc0122adc
    if (ticks % TICK_NUM == 0) {
c01026ca:	8b 0d dc 2a 12 c0    	mov    0xc0122adc,%ecx
c01026d0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01026d5:	89 c8                	mov    %ecx,%eax
c01026d7:	f7 e2                	mul    %edx
c01026d9:	89 d0                	mov    %edx,%eax
c01026db:	c1 e8 05             	shr    $0x5,%eax
c01026de:	6b c0 64             	imul   $0x64,%eax,%eax
c01026e1:	29 c1                	sub    %eax,%ecx
c01026e3:	89 c8                	mov    %ecx,%eax
c01026e5:	85 c0                	test   %eax,%eax
c01026e7:	75 0a                	jne    c01026f3 <trap_dispatch+0xd2>
    	print_ticks();
c01026e9:	e8 06 fa ff ff       	call   c01020f4 <print_ticks>
    }
        break;
c01026ee:	e9 a6 00 00 00       	jmp    c0102799 <trap_dispatch+0x178>
c01026f3:	e9 a1 00 00 00       	jmp    c0102799 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01026f8:	e8 46 ef ff ff       	call   c0101643 <cons_getc>
c01026fd:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102700:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102704:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102708:	89 54 24 08          	mov    %edx,0x8(%esp)
c010270c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102710:	c7 04 24 7a 97 10 c0 	movl   $0xc010977a,(%esp)
c0102717:	e8 2f dc ff ff       	call   c010034b <cprintf>
        break;
c010271c:	eb 7b                	jmp    c0102799 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c010271e:	e8 20 ef ff ff       	call   c0101643 <cons_getc>
c0102723:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102726:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c010272a:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c010272e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102732:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102736:	c7 04 24 8c 97 10 c0 	movl   $0xc010978c,(%esp)
c010273d:	e8 09 dc ff ff       	call   c010034b <cprintf>
        break;
c0102742:	eb 55                	jmp    c0102799 <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102744:	c7 44 24 08 9b 97 10 	movl   $0xc010979b,0x8(%esp)
c010274b:	c0 
c010274c:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0102753:	00 
c0102754:	c7 04 24 4e 97 10 c0 	movl   $0xc010974e,(%esp)
c010275b:	e8 75 e5 ff ff       	call   c0100cd5 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102760:	8b 45 08             	mov    0x8(%ebp),%eax
c0102763:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102767:	0f b7 c0             	movzwl %ax,%eax
c010276a:	83 e0 03             	and    $0x3,%eax
c010276d:	85 c0                	test   %eax,%eax
c010276f:	75 28                	jne    c0102799 <trap_dispatch+0x178>
            print_trapframe(tf);
c0102771:	8b 45 08             	mov    0x8(%ebp),%eax
c0102774:	89 04 24             	mov    %eax,(%esp)
c0102777:	e8 4c fb ff ff       	call   c01022c8 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010277c:	c7 44 24 08 ab 97 10 	movl   $0xc01097ab,0x8(%esp)
c0102783:	c0 
c0102784:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010278b:	00 
c010278c:	c7 04 24 4e 97 10 c0 	movl   $0xc010974e,(%esp)
c0102793:	e8 3d e5 ff ff       	call   c0100cd5 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102798:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102799:	c9                   	leave  
c010279a:	c3                   	ret    

c010279b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010279b:	55                   	push   %ebp
c010279c:	89 e5                	mov    %esp,%ebp
c010279e:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c01027a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01027a4:	89 04 24             	mov    %eax,(%esp)
c01027a7:	e8 75 fe ff ff       	call   c0102621 <trap_dispatch>
}
c01027ac:	c9                   	leave  
c01027ad:	c3                   	ret    

c01027ae <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01027ae:	1e                   	push   %ds
    pushl %es
c01027af:	06                   	push   %es
    pushl %fs
c01027b0:	0f a0                	push   %fs
    pushl %gs
c01027b2:	0f a8                	push   %gs
    pushal
c01027b4:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01027b5:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01027ba:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01027bc:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01027be:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01027bf:	e8 d7 ff ff ff       	call   c010279b <trap>

    # pop the pushed stack pointer
    popl %esp
c01027c4:	5c                   	pop    %esp

c01027c5 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01027c5:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01027c6:	0f a9                	pop    %gs
    popl %fs
c01027c8:	0f a1                	pop    %fs
    popl %es
c01027ca:	07                   	pop    %es
    popl %ds
c01027cb:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01027cc:	83 c4 08             	add    $0x8,%esp
    iret
c01027cf:	cf                   	iret   

c01027d0 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01027d0:	6a 00                	push   $0x0
  pushl $0
c01027d2:	6a 00                	push   $0x0
  jmp __alltraps
c01027d4:	e9 d5 ff ff ff       	jmp    c01027ae <__alltraps>

c01027d9 <vector1>:
.globl vector1
vector1:
  pushl $0
c01027d9:	6a 00                	push   $0x0
  pushl $1
c01027db:	6a 01                	push   $0x1
  jmp __alltraps
c01027dd:	e9 cc ff ff ff       	jmp    c01027ae <__alltraps>

c01027e2 <vector2>:
.globl vector2
vector2:
  pushl $0
c01027e2:	6a 00                	push   $0x0
  pushl $2
c01027e4:	6a 02                	push   $0x2
  jmp __alltraps
c01027e6:	e9 c3 ff ff ff       	jmp    c01027ae <__alltraps>

c01027eb <vector3>:
.globl vector3
vector3:
  pushl $0
c01027eb:	6a 00                	push   $0x0
  pushl $3
c01027ed:	6a 03                	push   $0x3
  jmp __alltraps
c01027ef:	e9 ba ff ff ff       	jmp    c01027ae <__alltraps>

c01027f4 <vector4>:
.globl vector4
vector4:
  pushl $0
c01027f4:	6a 00                	push   $0x0
  pushl $4
c01027f6:	6a 04                	push   $0x4
  jmp __alltraps
c01027f8:	e9 b1 ff ff ff       	jmp    c01027ae <__alltraps>

c01027fd <vector5>:
.globl vector5
vector5:
  pushl $0
c01027fd:	6a 00                	push   $0x0
  pushl $5
c01027ff:	6a 05                	push   $0x5
  jmp __alltraps
c0102801:	e9 a8 ff ff ff       	jmp    c01027ae <__alltraps>

c0102806 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102806:	6a 00                	push   $0x0
  pushl $6
c0102808:	6a 06                	push   $0x6
  jmp __alltraps
c010280a:	e9 9f ff ff ff       	jmp    c01027ae <__alltraps>

c010280f <vector7>:
.globl vector7
vector7:
  pushl $0
c010280f:	6a 00                	push   $0x0
  pushl $7
c0102811:	6a 07                	push   $0x7
  jmp __alltraps
c0102813:	e9 96 ff ff ff       	jmp    c01027ae <__alltraps>

c0102818 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102818:	6a 08                	push   $0x8
  jmp __alltraps
c010281a:	e9 8f ff ff ff       	jmp    c01027ae <__alltraps>

c010281f <vector9>:
.globl vector9
vector9:
  pushl $9
c010281f:	6a 09                	push   $0x9
  jmp __alltraps
c0102821:	e9 88 ff ff ff       	jmp    c01027ae <__alltraps>

c0102826 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102826:	6a 0a                	push   $0xa
  jmp __alltraps
c0102828:	e9 81 ff ff ff       	jmp    c01027ae <__alltraps>

c010282d <vector11>:
.globl vector11
vector11:
  pushl $11
c010282d:	6a 0b                	push   $0xb
  jmp __alltraps
c010282f:	e9 7a ff ff ff       	jmp    c01027ae <__alltraps>

c0102834 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102834:	6a 0c                	push   $0xc
  jmp __alltraps
c0102836:	e9 73 ff ff ff       	jmp    c01027ae <__alltraps>

c010283b <vector13>:
.globl vector13
vector13:
  pushl $13
c010283b:	6a 0d                	push   $0xd
  jmp __alltraps
c010283d:	e9 6c ff ff ff       	jmp    c01027ae <__alltraps>

c0102842 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102842:	6a 0e                	push   $0xe
  jmp __alltraps
c0102844:	e9 65 ff ff ff       	jmp    c01027ae <__alltraps>

c0102849 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102849:	6a 00                	push   $0x0
  pushl $15
c010284b:	6a 0f                	push   $0xf
  jmp __alltraps
c010284d:	e9 5c ff ff ff       	jmp    c01027ae <__alltraps>

c0102852 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102852:	6a 00                	push   $0x0
  pushl $16
c0102854:	6a 10                	push   $0x10
  jmp __alltraps
c0102856:	e9 53 ff ff ff       	jmp    c01027ae <__alltraps>

c010285b <vector17>:
.globl vector17
vector17:
  pushl $17
c010285b:	6a 11                	push   $0x11
  jmp __alltraps
c010285d:	e9 4c ff ff ff       	jmp    c01027ae <__alltraps>

c0102862 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102862:	6a 00                	push   $0x0
  pushl $18
c0102864:	6a 12                	push   $0x12
  jmp __alltraps
c0102866:	e9 43 ff ff ff       	jmp    c01027ae <__alltraps>

c010286b <vector19>:
.globl vector19
vector19:
  pushl $0
c010286b:	6a 00                	push   $0x0
  pushl $19
c010286d:	6a 13                	push   $0x13
  jmp __alltraps
c010286f:	e9 3a ff ff ff       	jmp    c01027ae <__alltraps>

c0102874 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102874:	6a 00                	push   $0x0
  pushl $20
c0102876:	6a 14                	push   $0x14
  jmp __alltraps
c0102878:	e9 31 ff ff ff       	jmp    c01027ae <__alltraps>

c010287d <vector21>:
.globl vector21
vector21:
  pushl $0
c010287d:	6a 00                	push   $0x0
  pushl $21
c010287f:	6a 15                	push   $0x15
  jmp __alltraps
c0102881:	e9 28 ff ff ff       	jmp    c01027ae <__alltraps>

c0102886 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102886:	6a 00                	push   $0x0
  pushl $22
c0102888:	6a 16                	push   $0x16
  jmp __alltraps
c010288a:	e9 1f ff ff ff       	jmp    c01027ae <__alltraps>

c010288f <vector23>:
.globl vector23
vector23:
  pushl $0
c010288f:	6a 00                	push   $0x0
  pushl $23
c0102891:	6a 17                	push   $0x17
  jmp __alltraps
c0102893:	e9 16 ff ff ff       	jmp    c01027ae <__alltraps>

c0102898 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102898:	6a 00                	push   $0x0
  pushl $24
c010289a:	6a 18                	push   $0x18
  jmp __alltraps
c010289c:	e9 0d ff ff ff       	jmp    c01027ae <__alltraps>

c01028a1 <vector25>:
.globl vector25
vector25:
  pushl $0
c01028a1:	6a 00                	push   $0x0
  pushl $25
c01028a3:	6a 19                	push   $0x19
  jmp __alltraps
c01028a5:	e9 04 ff ff ff       	jmp    c01027ae <__alltraps>

c01028aa <vector26>:
.globl vector26
vector26:
  pushl $0
c01028aa:	6a 00                	push   $0x0
  pushl $26
c01028ac:	6a 1a                	push   $0x1a
  jmp __alltraps
c01028ae:	e9 fb fe ff ff       	jmp    c01027ae <__alltraps>

c01028b3 <vector27>:
.globl vector27
vector27:
  pushl $0
c01028b3:	6a 00                	push   $0x0
  pushl $27
c01028b5:	6a 1b                	push   $0x1b
  jmp __alltraps
c01028b7:	e9 f2 fe ff ff       	jmp    c01027ae <__alltraps>

c01028bc <vector28>:
.globl vector28
vector28:
  pushl $0
c01028bc:	6a 00                	push   $0x0
  pushl $28
c01028be:	6a 1c                	push   $0x1c
  jmp __alltraps
c01028c0:	e9 e9 fe ff ff       	jmp    c01027ae <__alltraps>

c01028c5 <vector29>:
.globl vector29
vector29:
  pushl $0
c01028c5:	6a 00                	push   $0x0
  pushl $29
c01028c7:	6a 1d                	push   $0x1d
  jmp __alltraps
c01028c9:	e9 e0 fe ff ff       	jmp    c01027ae <__alltraps>

c01028ce <vector30>:
.globl vector30
vector30:
  pushl $0
c01028ce:	6a 00                	push   $0x0
  pushl $30
c01028d0:	6a 1e                	push   $0x1e
  jmp __alltraps
c01028d2:	e9 d7 fe ff ff       	jmp    c01027ae <__alltraps>

c01028d7 <vector31>:
.globl vector31
vector31:
  pushl $0
c01028d7:	6a 00                	push   $0x0
  pushl $31
c01028d9:	6a 1f                	push   $0x1f
  jmp __alltraps
c01028db:	e9 ce fe ff ff       	jmp    c01027ae <__alltraps>

c01028e0 <vector32>:
.globl vector32
vector32:
  pushl $0
c01028e0:	6a 00                	push   $0x0
  pushl $32
c01028e2:	6a 20                	push   $0x20
  jmp __alltraps
c01028e4:	e9 c5 fe ff ff       	jmp    c01027ae <__alltraps>

c01028e9 <vector33>:
.globl vector33
vector33:
  pushl $0
c01028e9:	6a 00                	push   $0x0
  pushl $33
c01028eb:	6a 21                	push   $0x21
  jmp __alltraps
c01028ed:	e9 bc fe ff ff       	jmp    c01027ae <__alltraps>

c01028f2 <vector34>:
.globl vector34
vector34:
  pushl $0
c01028f2:	6a 00                	push   $0x0
  pushl $34
c01028f4:	6a 22                	push   $0x22
  jmp __alltraps
c01028f6:	e9 b3 fe ff ff       	jmp    c01027ae <__alltraps>

c01028fb <vector35>:
.globl vector35
vector35:
  pushl $0
c01028fb:	6a 00                	push   $0x0
  pushl $35
c01028fd:	6a 23                	push   $0x23
  jmp __alltraps
c01028ff:	e9 aa fe ff ff       	jmp    c01027ae <__alltraps>

c0102904 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102904:	6a 00                	push   $0x0
  pushl $36
c0102906:	6a 24                	push   $0x24
  jmp __alltraps
c0102908:	e9 a1 fe ff ff       	jmp    c01027ae <__alltraps>

c010290d <vector37>:
.globl vector37
vector37:
  pushl $0
c010290d:	6a 00                	push   $0x0
  pushl $37
c010290f:	6a 25                	push   $0x25
  jmp __alltraps
c0102911:	e9 98 fe ff ff       	jmp    c01027ae <__alltraps>

c0102916 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102916:	6a 00                	push   $0x0
  pushl $38
c0102918:	6a 26                	push   $0x26
  jmp __alltraps
c010291a:	e9 8f fe ff ff       	jmp    c01027ae <__alltraps>

c010291f <vector39>:
.globl vector39
vector39:
  pushl $0
c010291f:	6a 00                	push   $0x0
  pushl $39
c0102921:	6a 27                	push   $0x27
  jmp __alltraps
c0102923:	e9 86 fe ff ff       	jmp    c01027ae <__alltraps>

c0102928 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102928:	6a 00                	push   $0x0
  pushl $40
c010292a:	6a 28                	push   $0x28
  jmp __alltraps
c010292c:	e9 7d fe ff ff       	jmp    c01027ae <__alltraps>

c0102931 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102931:	6a 00                	push   $0x0
  pushl $41
c0102933:	6a 29                	push   $0x29
  jmp __alltraps
c0102935:	e9 74 fe ff ff       	jmp    c01027ae <__alltraps>

c010293a <vector42>:
.globl vector42
vector42:
  pushl $0
c010293a:	6a 00                	push   $0x0
  pushl $42
c010293c:	6a 2a                	push   $0x2a
  jmp __alltraps
c010293e:	e9 6b fe ff ff       	jmp    c01027ae <__alltraps>

c0102943 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102943:	6a 00                	push   $0x0
  pushl $43
c0102945:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102947:	e9 62 fe ff ff       	jmp    c01027ae <__alltraps>

c010294c <vector44>:
.globl vector44
vector44:
  pushl $0
c010294c:	6a 00                	push   $0x0
  pushl $44
c010294e:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102950:	e9 59 fe ff ff       	jmp    c01027ae <__alltraps>

c0102955 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102955:	6a 00                	push   $0x0
  pushl $45
c0102957:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102959:	e9 50 fe ff ff       	jmp    c01027ae <__alltraps>

c010295e <vector46>:
.globl vector46
vector46:
  pushl $0
c010295e:	6a 00                	push   $0x0
  pushl $46
c0102960:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102962:	e9 47 fe ff ff       	jmp    c01027ae <__alltraps>

c0102967 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102967:	6a 00                	push   $0x0
  pushl $47
c0102969:	6a 2f                	push   $0x2f
  jmp __alltraps
c010296b:	e9 3e fe ff ff       	jmp    c01027ae <__alltraps>

c0102970 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102970:	6a 00                	push   $0x0
  pushl $48
c0102972:	6a 30                	push   $0x30
  jmp __alltraps
c0102974:	e9 35 fe ff ff       	jmp    c01027ae <__alltraps>

c0102979 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102979:	6a 00                	push   $0x0
  pushl $49
c010297b:	6a 31                	push   $0x31
  jmp __alltraps
c010297d:	e9 2c fe ff ff       	jmp    c01027ae <__alltraps>

c0102982 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102982:	6a 00                	push   $0x0
  pushl $50
c0102984:	6a 32                	push   $0x32
  jmp __alltraps
c0102986:	e9 23 fe ff ff       	jmp    c01027ae <__alltraps>

c010298b <vector51>:
.globl vector51
vector51:
  pushl $0
c010298b:	6a 00                	push   $0x0
  pushl $51
c010298d:	6a 33                	push   $0x33
  jmp __alltraps
c010298f:	e9 1a fe ff ff       	jmp    c01027ae <__alltraps>

c0102994 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102994:	6a 00                	push   $0x0
  pushl $52
c0102996:	6a 34                	push   $0x34
  jmp __alltraps
c0102998:	e9 11 fe ff ff       	jmp    c01027ae <__alltraps>

c010299d <vector53>:
.globl vector53
vector53:
  pushl $0
c010299d:	6a 00                	push   $0x0
  pushl $53
c010299f:	6a 35                	push   $0x35
  jmp __alltraps
c01029a1:	e9 08 fe ff ff       	jmp    c01027ae <__alltraps>

c01029a6 <vector54>:
.globl vector54
vector54:
  pushl $0
c01029a6:	6a 00                	push   $0x0
  pushl $54
c01029a8:	6a 36                	push   $0x36
  jmp __alltraps
c01029aa:	e9 ff fd ff ff       	jmp    c01027ae <__alltraps>

c01029af <vector55>:
.globl vector55
vector55:
  pushl $0
c01029af:	6a 00                	push   $0x0
  pushl $55
c01029b1:	6a 37                	push   $0x37
  jmp __alltraps
c01029b3:	e9 f6 fd ff ff       	jmp    c01027ae <__alltraps>

c01029b8 <vector56>:
.globl vector56
vector56:
  pushl $0
c01029b8:	6a 00                	push   $0x0
  pushl $56
c01029ba:	6a 38                	push   $0x38
  jmp __alltraps
c01029bc:	e9 ed fd ff ff       	jmp    c01027ae <__alltraps>

c01029c1 <vector57>:
.globl vector57
vector57:
  pushl $0
c01029c1:	6a 00                	push   $0x0
  pushl $57
c01029c3:	6a 39                	push   $0x39
  jmp __alltraps
c01029c5:	e9 e4 fd ff ff       	jmp    c01027ae <__alltraps>

c01029ca <vector58>:
.globl vector58
vector58:
  pushl $0
c01029ca:	6a 00                	push   $0x0
  pushl $58
c01029cc:	6a 3a                	push   $0x3a
  jmp __alltraps
c01029ce:	e9 db fd ff ff       	jmp    c01027ae <__alltraps>

c01029d3 <vector59>:
.globl vector59
vector59:
  pushl $0
c01029d3:	6a 00                	push   $0x0
  pushl $59
c01029d5:	6a 3b                	push   $0x3b
  jmp __alltraps
c01029d7:	e9 d2 fd ff ff       	jmp    c01027ae <__alltraps>

c01029dc <vector60>:
.globl vector60
vector60:
  pushl $0
c01029dc:	6a 00                	push   $0x0
  pushl $60
c01029de:	6a 3c                	push   $0x3c
  jmp __alltraps
c01029e0:	e9 c9 fd ff ff       	jmp    c01027ae <__alltraps>

c01029e5 <vector61>:
.globl vector61
vector61:
  pushl $0
c01029e5:	6a 00                	push   $0x0
  pushl $61
c01029e7:	6a 3d                	push   $0x3d
  jmp __alltraps
c01029e9:	e9 c0 fd ff ff       	jmp    c01027ae <__alltraps>

c01029ee <vector62>:
.globl vector62
vector62:
  pushl $0
c01029ee:	6a 00                	push   $0x0
  pushl $62
c01029f0:	6a 3e                	push   $0x3e
  jmp __alltraps
c01029f2:	e9 b7 fd ff ff       	jmp    c01027ae <__alltraps>

c01029f7 <vector63>:
.globl vector63
vector63:
  pushl $0
c01029f7:	6a 00                	push   $0x0
  pushl $63
c01029f9:	6a 3f                	push   $0x3f
  jmp __alltraps
c01029fb:	e9 ae fd ff ff       	jmp    c01027ae <__alltraps>

c0102a00 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102a00:	6a 00                	push   $0x0
  pushl $64
c0102a02:	6a 40                	push   $0x40
  jmp __alltraps
c0102a04:	e9 a5 fd ff ff       	jmp    c01027ae <__alltraps>

c0102a09 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102a09:	6a 00                	push   $0x0
  pushl $65
c0102a0b:	6a 41                	push   $0x41
  jmp __alltraps
c0102a0d:	e9 9c fd ff ff       	jmp    c01027ae <__alltraps>

c0102a12 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102a12:	6a 00                	push   $0x0
  pushl $66
c0102a14:	6a 42                	push   $0x42
  jmp __alltraps
c0102a16:	e9 93 fd ff ff       	jmp    c01027ae <__alltraps>

c0102a1b <vector67>:
.globl vector67
vector67:
  pushl $0
c0102a1b:	6a 00                	push   $0x0
  pushl $67
c0102a1d:	6a 43                	push   $0x43
  jmp __alltraps
c0102a1f:	e9 8a fd ff ff       	jmp    c01027ae <__alltraps>

c0102a24 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a24:	6a 00                	push   $0x0
  pushl $68
c0102a26:	6a 44                	push   $0x44
  jmp __alltraps
c0102a28:	e9 81 fd ff ff       	jmp    c01027ae <__alltraps>

c0102a2d <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a2d:	6a 00                	push   $0x0
  pushl $69
c0102a2f:	6a 45                	push   $0x45
  jmp __alltraps
c0102a31:	e9 78 fd ff ff       	jmp    c01027ae <__alltraps>

c0102a36 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a36:	6a 00                	push   $0x0
  pushl $70
c0102a38:	6a 46                	push   $0x46
  jmp __alltraps
c0102a3a:	e9 6f fd ff ff       	jmp    c01027ae <__alltraps>

c0102a3f <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a3f:	6a 00                	push   $0x0
  pushl $71
c0102a41:	6a 47                	push   $0x47
  jmp __alltraps
c0102a43:	e9 66 fd ff ff       	jmp    c01027ae <__alltraps>

c0102a48 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102a48:	6a 00                	push   $0x0
  pushl $72
c0102a4a:	6a 48                	push   $0x48
  jmp __alltraps
c0102a4c:	e9 5d fd ff ff       	jmp    c01027ae <__alltraps>

c0102a51 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102a51:	6a 00                	push   $0x0
  pushl $73
c0102a53:	6a 49                	push   $0x49
  jmp __alltraps
c0102a55:	e9 54 fd ff ff       	jmp    c01027ae <__alltraps>

c0102a5a <vector74>:
.globl vector74
vector74:
  pushl $0
c0102a5a:	6a 00                	push   $0x0
  pushl $74
c0102a5c:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102a5e:	e9 4b fd ff ff       	jmp    c01027ae <__alltraps>

c0102a63 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102a63:	6a 00                	push   $0x0
  pushl $75
c0102a65:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102a67:	e9 42 fd ff ff       	jmp    c01027ae <__alltraps>

c0102a6c <vector76>:
.globl vector76
vector76:
  pushl $0
c0102a6c:	6a 00                	push   $0x0
  pushl $76
c0102a6e:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102a70:	e9 39 fd ff ff       	jmp    c01027ae <__alltraps>

c0102a75 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a75:	6a 00                	push   $0x0
  pushl $77
c0102a77:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a79:	e9 30 fd ff ff       	jmp    c01027ae <__alltraps>

c0102a7e <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a7e:	6a 00                	push   $0x0
  pushl $78
c0102a80:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a82:	e9 27 fd ff ff       	jmp    c01027ae <__alltraps>

c0102a87 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a87:	6a 00                	push   $0x0
  pushl $79
c0102a89:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a8b:	e9 1e fd ff ff       	jmp    c01027ae <__alltraps>

c0102a90 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a90:	6a 00                	push   $0x0
  pushl $80
c0102a92:	6a 50                	push   $0x50
  jmp __alltraps
c0102a94:	e9 15 fd ff ff       	jmp    c01027ae <__alltraps>

c0102a99 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a99:	6a 00                	push   $0x0
  pushl $81
c0102a9b:	6a 51                	push   $0x51
  jmp __alltraps
c0102a9d:	e9 0c fd ff ff       	jmp    c01027ae <__alltraps>

c0102aa2 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102aa2:	6a 00                	push   $0x0
  pushl $82
c0102aa4:	6a 52                	push   $0x52
  jmp __alltraps
c0102aa6:	e9 03 fd ff ff       	jmp    c01027ae <__alltraps>

c0102aab <vector83>:
.globl vector83
vector83:
  pushl $0
c0102aab:	6a 00                	push   $0x0
  pushl $83
c0102aad:	6a 53                	push   $0x53
  jmp __alltraps
c0102aaf:	e9 fa fc ff ff       	jmp    c01027ae <__alltraps>

c0102ab4 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102ab4:	6a 00                	push   $0x0
  pushl $84
c0102ab6:	6a 54                	push   $0x54
  jmp __alltraps
c0102ab8:	e9 f1 fc ff ff       	jmp    c01027ae <__alltraps>

c0102abd <vector85>:
.globl vector85
vector85:
  pushl $0
c0102abd:	6a 00                	push   $0x0
  pushl $85
c0102abf:	6a 55                	push   $0x55
  jmp __alltraps
c0102ac1:	e9 e8 fc ff ff       	jmp    c01027ae <__alltraps>

c0102ac6 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102ac6:	6a 00                	push   $0x0
  pushl $86
c0102ac8:	6a 56                	push   $0x56
  jmp __alltraps
c0102aca:	e9 df fc ff ff       	jmp    c01027ae <__alltraps>

c0102acf <vector87>:
.globl vector87
vector87:
  pushl $0
c0102acf:	6a 00                	push   $0x0
  pushl $87
c0102ad1:	6a 57                	push   $0x57
  jmp __alltraps
c0102ad3:	e9 d6 fc ff ff       	jmp    c01027ae <__alltraps>

c0102ad8 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102ad8:	6a 00                	push   $0x0
  pushl $88
c0102ada:	6a 58                	push   $0x58
  jmp __alltraps
c0102adc:	e9 cd fc ff ff       	jmp    c01027ae <__alltraps>

c0102ae1 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102ae1:	6a 00                	push   $0x0
  pushl $89
c0102ae3:	6a 59                	push   $0x59
  jmp __alltraps
c0102ae5:	e9 c4 fc ff ff       	jmp    c01027ae <__alltraps>

c0102aea <vector90>:
.globl vector90
vector90:
  pushl $0
c0102aea:	6a 00                	push   $0x0
  pushl $90
c0102aec:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102aee:	e9 bb fc ff ff       	jmp    c01027ae <__alltraps>

c0102af3 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102af3:	6a 00                	push   $0x0
  pushl $91
c0102af5:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102af7:	e9 b2 fc ff ff       	jmp    c01027ae <__alltraps>

c0102afc <vector92>:
.globl vector92
vector92:
  pushl $0
c0102afc:	6a 00                	push   $0x0
  pushl $92
c0102afe:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102b00:	e9 a9 fc ff ff       	jmp    c01027ae <__alltraps>

c0102b05 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102b05:	6a 00                	push   $0x0
  pushl $93
c0102b07:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102b09:	e9 a0 fc ff ff       	jmp    c01027ae <__alltraps>

c0102b0e <vector94>:
.globl vector94
vector94:
  pushl $0
c0102b0e:	6a 00                	push   $0x0
  pushl $94
c0102b10:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102b12:	e9 97 fc ff ff       	jmp    c01027ae <__alltraps>

c0102b17 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b17:	6a 00                	push   $0x0
  pushl $95
c0102b19:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102b1b:	e9 8e fc ff ff       	jmp    c01027ae <__alltraps>

c0102b20 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102b20:	6a 00                	push   $0x0
  pushl $96
c0102b22:	6a 60                	push   $0x60
  jmp __alltraps
c0102b24:	e9 85 fc ff ff       	jmp    c01027ae <__alltraps>

c0102b29 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b29:	6a 00                	push   $0x0
  pushl $97
c0102b2b:	6a 61                	push   $0x61
  jmp __alltraps
c0102b2d:	e9 7c fc ff ff       	jmp    c01027ae <__alltraps>

c0102b32 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b32:	6a 00                	push   $0x0
  pushl $98
c0102b34:	6a 62                	push   $0x62
  jmp __alltraps
c0102b36:	e9 73 fc ff ff       	jmp    c01027ae <__alltraps>

c0102b3b <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b3b:	6a 00                	push   $0x0
  pushl $99
c0102b3d:	6a 63                	push   $0x63
  jmp __alltraps
c0102b3f:	e9 6a fc ff ff       	jmp    c01027ae <__alltraps>

c0102b44 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102b44:	6a 00                	push   $0x0
  pushl $100
c0102b46:	6a 64                	push   $0x64
  jmp __alltraps
c0102b48:	e9 61 fc ff ff       	jmp    c01027ae <__alltraps>

c0102b4d <vector101>:
.globl vector101
vector101:
  pushl $0
c0102b4d:	6a 00                	push   $0x0
  pushl $101
c0102b4f:	6a 65                	push   $0x65
  jmp __alltraps
c0102b51:	e9 58 fc ff ff       	jmp    c01027ae <__alltraps>

c0102b56 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102b56:	6a 00                	push   $0x0
  pushl $102
c0102b58:	6a 66                	push   $0x66
  jmp __alltraps
c0102b5a:	e9 4f fc ff ff       	jmp    c01027ae <__alltraps>

c0102b5f <vector103>:
.globl vector103
vector103:
  pushl $0
c0102b5f:	6a 00                	push   $0x0
  pushl $103
c0102b61:	6a 67                	push   $0x67
  jmp __alltraps
c0102b63:	e9 46 fc ff ff       	jmp    c01027ae <__alltraps>

c0102b68 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102b68:	6a 00                	push   $0x0
  pushl $104
c0102b6a:	6a 68                	push   $0x68
  jmp __alltraps
c0102b6c:	e9 3d fc ff ff       	jmp    c01027ae <__alltraps>

c0102b71 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102b71:	6a 00                	push   $0x0
  pushl $105
c0102b73:	6a 69                	push   $0x69
  jmp __alltraps
c0102b75:	e9 34 fc ff ff       	jmp    c01027ae <__alltraps>

c0102b7a <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b7a:	6a 00                	push   $0x0
  pushl $106
c0102b7c:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b7e:	e9 2b fc ff ff       	jmp    c01027ae <__alltraps>

c0102b83 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b83:	6a 00                	push   $0x0
  pushl $107
c0102b85:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b87:	e9 22 fc ff ff       	jmp    c01027ae <__alltraps>

c0102b8c <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b8c:	6a 00                	push   $0x0
  pushl $108
c0102b8e:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b90:	e9 19 fc ff ff       	jmp    c01027ae <__alltraps>

c0102b95 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b95:	6a 00                	push   $0x0
  pushl $109
c0102b97:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b99:	e9 10 fc ff ff       	jmp    c01027ae <__alltraps>

c0102b9e <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b9e:	6a 00                	push   $0x0
  pushl $110
c0102ba0:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102ba2:	e9 07 fc ff ff       	jmp    c01027ae <__alltraps>

c0102ba7 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102ba7:	6a 00                	push   $0x0
  pushl $111
c0102ba9:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102bab:	e9 fe fb ff ff       	jmp    c01027ae <__alltraps>

c0102bb0 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102bb0:	6a 00                	push   $0x0
  pushl $112
c0102bb2:	6a 70                	push   $0x70
  jmp __alltraps
c0102bb4:	e9 f5 fb ff ff       	jmp    c01027ae <__alltraps>

c0102bb9 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102bb9:	6a 00                	push   $0x0
  pushl $113
c0102bbb:	6a 71                	push   $0x71
  jmp __alltraps
c0102bbd:	e9 ec fb ff ff       	jmp    c01027ae <__alltraps>

c0102bc2 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102bc2:	6a 00                	push   $0x0
  pushl $114
c0102bc4:	6a 72                	push   $0x72
  jmp __alltraps
c0102bc6:	e9 e3 fb ff ff       	jmp    c01027ae <__alltraps>

c0102bcb <vector115>:
.globl vector115
vector115:
  pushl $0
c0102bcb:	6a 00                	push   $0x0
  pushl $115
c0102bcd:	6a 73                	push   $0x73
  jmp __alltraps
c0102bcf:	e9 da fb ff ff       	jmp    c01027ae <__alltraps>

c0102bd4 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102bd4:	6a 00                	push   $0x0
  pushl $116
c0102bd6:	6a 74                	push   $0x74
  jmp __alltraps
c0102bd8:	e9 d1 fb ff ff       	jmp    c01027ae <__alltraps>

c0102bdd <vector117>:
.globl vector117
vector117:
  pushl $0
c0102bdd:	6a 00                	push   $0x0
  pushl $117
c0102bdf:	6a 75                	push   $0x75
  jmp __alltraps
c0102be1:	e9 c8 fb ff ff       	jmp    c01027ae <__alltraps>

c0102be6 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102be6:	6a 00                	push   $0x0
  pushl $118
c0102be8:	6a 76                	push   $0x76
  jmp __alltraps
c0102bea:	e9 bf fb ff ff       	jmp    c01027ae <__alltraps>

c0102bef <vector119>:
.globl vector119
vector119:
  pushl $0
c0102bef:	6a 00                	push   $0x0
  pushl $119
c0102bf1:	6a 77                	push   $0x77
  jmp __alltraps
c0102bf3:	e9 b6 fb ff ff       	jmp    c01027ae <__alltraps>

c0102bf8 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102bf8:	6a 00                	push   $0x0
  pushl $120
c0102bfa:	6a 78                	push   $0x78
  jmp __alltraps
c0102bfc:	e9 ad fb ff ff       	jmp    c01027ae <__alltraps>

c0102c01 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102c01:	6a 00                	push   $0x0
  pushl $121
c0102c03:	6a 79                	push   $0x79
  jmp __alltraps
c0102c05:	e9 a4 fb ff ff       	jmp    c01027ae <__alltraps>

c0102c0a <vector122>:
.globl vector122
vector122:
  pushl $0
c0102c0a:	6a 00                	push   $0x0
  pushl $122
c0102c0c:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102c0e:	e9 9b fb ff ff       	jmp    c01027ae <__alltraps>

c0102c13 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102c13:	6a 00                	push   $0x0
  pushl $123
c0102c15:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c17:	e9 92 fb ff ff       	jmp    c01027ae <__alltraps>

c0102c1c <vector124>:
.globl vector124
vector124:
  pushl $0
c0102c1c:	6a 00                	push   $0x0
  pushl $124
c0102c1e:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102c20:	e9 89 fb ff ff       	jmp    c01027ae <__alltraps>

c0102c25 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c25:	6a 00                	push   $0x0
  pushl $125
c0102c27:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c29:	e9 80 fb ff ff       	jmp    c01027ae <__alltraps>

c0102c2e <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c2e:	6a 00                	push   $0x0
  pushl $126
c0102c30:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c32:	e9 77 fb ff ff       	jmp    c01027ae <__alltraps>

c0102c37 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c37:	6a 00                	push   $0x0
  pushl $127
c0102c39:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c3b:	e9 6e fb ff ff       	jmp    c01027ae <__alltraps>

c0102c40 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c40:	6a 00                	push   $0x0
  pushl $128
c0102c42:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102c47:	e9 62 fb ff ff       	jmp    c01027ae <__alltraps>

c0102c4c <vector129>:
.globl vector129
vector129:
  pushl $0
c0102c4c:	6a 00                	push   $0x0
  pushl $129
c0102c4e:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102c53:	e9 56 fb ff ff       	jmp    c01027ae <__alltraps>

c0102c58 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102c58:	6a 00                	push   $0x0
  pushl $130
c0102c5a:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102c5f:	e9 4a fb ff ff       	jmp    c01027ae <__alltraps>

c0102c64 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102c64:	6a 00                	push   $0x0
  pushl $131
c0102c66:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102c6b:	e9 3e fb ff ff       	jmp    c01027ae <__alltraps>

c0102c70 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102c70:	6a 00                	push   $0x0
  pushl $132
c0102c72:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c77:	e9 32 fb ff ff       	jmp    c01027ae <__alltraps>

c0102c7c <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c7c:	6a 00                	push   $0x0
  pushl $133
c0102c7e:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c83:	e9 26 fb ff ff       	jmp    c01027ae <__alltraps>

c0102c88 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c88:	6a 00                	push   $0x0
  pushl $134
c0102c8a:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c8f:	e9 1a fb ff ff       	jmp    c01027ae <__alltraps>

c0102c94 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c94:	6a 00                	push   $0x0
  pushl $135
c0102c96:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c9b:	e9 0e fb ff ff       	jmp    c01027ae <__alltraps>

c0102ca0 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102ca0:	6a 00                	push   $0x0
  pushl $136
c0102ca2:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102ca7:	e9 02 fb ff ff       	jmp    c01027ae <__alltraps>

c0102cac <vector137>:
.globl vector137
vector137:
  pushl $0
c0102cac:	6a 00                	push   $0x0
  pushl $137
c0102cae:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102cb3:	e9 f6 fa ff ff       	jmp    c01027ae <__alltraps>

c0102cb8 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102cb8:	6a 00                	push   $0x0
  pushl $138
c0102cba:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102cbf:	e9 ea fa ff ff       	jmp    c01027ae <__alltraps>

c0102cc4 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102cc4:	6a 00                	push   $0x0
  pushl $139
c0102cc6:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102ccb:	e9 de fa ff ff       	jmp    c01027ae <__alltraps>

c0102cd0 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102cd0:	6a 00                	push   $0x0
  pushl $140
c0102cd2:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102cd7:	e9 d2 fa ff ff       	jmp    c01027ae <__alltraps>

c0102cdc <vector141>:
.globl vector141
vector141:
  pushl $0
c0102cdc:	6a 00                	push   $0x0
  pushl $141
c0102cde:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102ce3:	e9 c6 fa ff ff       	jmp    c01027ae <__alltraps>

c0102ce8 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102ce8:	6a 00                	push   $0x0
  pushl $142
c0102cea:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102cef:	e9 ba fa ff ff       	jmp    c01027ae <__alltraps>

c0102cf4 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102cf4:	6a 00                	push   $0x0
  pushl $143
c0102cf6:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102cfb:	e9 ae fa ff ff       	jmp    c01027ae <__alltraps>

c0102d00 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102d00:	6a 00                	push   $0x0
  pushl $144
c0102d02:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102d07:	e9 a2 fa ff ff       	jmp    c01027ae <__alltraps>

c0102d0c <vector145>:
.globl vector145
vector145:
  pushl $0
c0102d0c:	6a 00                	push   $0x0
  pushl $145
c0102d0e:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102d13:	e9 96 fa ff ff       	jmp    c01027ae <__alltraps>

c0102d18 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d18:	6a 00                	push   $0x0
  pushl $146
c0102d1a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102d1f:	e9 8a fa ff ff       	jmp    c01027ae <__alltraps>

c0102d24 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d24:	6a 00                	push   $0x0
  pushl $147
c0102d26:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d2b:	e9 7e fa ff ff       	jmp    c01027ae <__alltraps>

c0102d30 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d30:	6a 00                	push   $0x0
  pushl $148
c0102d32:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d37:	e9 72 fa ff ff       	jmp    c01027ae <__alltraps>

c0102d3c <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d3c:	6a 00                	push   $0x0
  pushl $149
c0102d3e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102d43:	e9 66 fa ff ff       	jmp    c01027ae <__alltraps>

c0102d48 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102d48:	6a 00                	push   $0x0
  pushl $150
c0102d4a:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102d4f:	e9 5a fa ff ff       	jmp    c01027ae <__alltraps>

c0102d54 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102d54:	6a 00                	push   $0x0
  pushl $151
c0102d56:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102d5b:	e9 4e fa ff ff       	jmp    c01027ae <__alltraps>

c0102d60 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102d60:	6a 00                	push   $0x0
  pushl $152
c0102d62:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102d67:	e9 42 fa ff ff       	jmp    c01027ae <__alltraps>

c0102d6c <vector153>:
.globl vector153
vector153:
  pushl $0
c0102d6c:	6a 00                	push   $0x0
  pushl $153
c0102d6e:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d73:	e9 36 fa ff ff       	jmp    c01027ae <__alltraps>

c0102d78 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d78:	6a 00                	push   $0x0
  pushl $154
c0102d7a:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d7f:	e9 2a fa ff ff       	jmp    c01027ae <__alltraps>

c0102d84 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d84:	6a 00                	push   $0x0
  pushl $155
c0102d86:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d8b:	e9 1e fa ff ff       	jmp    c01027ae <__alltraps>

c0102d90 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d90:	6a 00                	push   $0x0
  pushl $156
c0102d92:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d97:	e9 12 fa ff ff       	jmp    c01027ae <__alltraps>

c0102d9c <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d9c:	6a 00                	push   $0x0
  pushl $157
c0102d9e:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102da3:	e9 06 fa ff ff       	jmp    c01027ae <__alltraps>

c0102da8 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102da8:	6a 00                	push   $0x0
  pushl $158
c0102daa:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102daf:	e9 fa f9 ff ff       	jmp    c01027ae <__alltraps>

c0102db4 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102db4:	6a 00                	push   $0x0
  pushl $159
c0102db6:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102dbb:	e9 ee f9 ff ff       	jmp    c01027ae <__alltraps>

c0102dc0 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102dc0:	6a 00                	push   $0x0
  pushl $160
c0102dc2:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102dc7:	e9 e2 f9 ff ff       	jmp    c01027ae <__alltraps>

c0102dcc <vector161>:
.globl vector161
vector161:
  pushl $0
c0102dcc:	6a 00                	push   $0x0
  pushl $161
c0102dce:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102dd3:	e9 d6 f9 ff ff       	jmp    c01027ae <__alltraps>

c0102dd8 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102dd8:	6a 00                	push   $0x0
  pushl $162
c0102dda:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102ddf:	e9 ca f9 ff ff       	jmp    c01027ae <__alltraps>

c0102de4 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102de4:	6a 00                	push   $0x0
  pushl $163
c0102de6:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102deb:	e9 be f9 ff ff       	jmp    c01027ae <__alltraps>

c0102df0 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102df0:	6a 00                	push   $0x0
  pushl $164
c0102df2:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102df7:	e9 b2 f9 ff ff       	jmp    c01027ae <__alltraps>

c0102dfc <vector165>:
.globl vector165
vector165:
  pushl $0
c0102dfc:	6a 00                	push   $0x0
  pushl $165
c0102dfe:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102e03:	e9 a6 f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e08 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102e08:	6a 00                	push   $0x0
  pushl $166
c0102e0a:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102e0f:	e9 9a f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e14 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102e14:	6a 00                	push   $0x0
  pushl $167
c0102e16:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102e1b:	e9 8e f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e20 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102e20:	6a 00                	push   $0x0
  pushl $168
c0102e22:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e27:	e9 82 f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e2c <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e2c:	6a 00                	push   $0x0
  pushl $169
c0102e2e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e33:	e9 76 f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e38 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e38:	6a 00                	push   $0x0
  pushl $170
c0102e3a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e3f:	e9 6a f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e44 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102e44:	6a 00                	push   $0x0
  pushl $171
c0102e46:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102e4b:	e9 5e f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e50 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102e50:	6a 00                	push   $0x0
  pushl $172
c0102e52:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102e57:	e9 52 f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e5c <vector173>:
.globl vector173
vector173:
  pushl $0
c0102e5c:	6a 00                	push   $0x0
  pushl $173
c0102e5e:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102e63:	e9 46 f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e68 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102e68:	6a 00                	push   $0x0
  pushl $174
c0102e6a:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e6f:	e9 3a f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e74 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e74:	6a 00                	push   $0x0
  pushl $175
c0102e76:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e7b:	e9 2e f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e80 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e80:	6a 00                	push   $0x0
  pushl $176
c0102e82:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e87:	e9 22 f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e8c <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e8c:	6a 00                	push   $0x0
  pushl $177
c0102e8e:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e93:	e9 16 f9 ff ff       	jmp    c01027ae <__alltraps>

c0102e98 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e98:	6a 00                	push   $0x0
  pushl $178
c0102e9a:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e9f:	e9 0a f9 ff ff       	jmp    c01027ae <__alltraps>

c0102ea4 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102ea4:	6a 00                	push   $0x0
  pushl $179
c0102ea6:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102eab:	e9 fe f8 ff ff       	jmp    c01027ae <__alltraps>

c0102eb0 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102eb0:	6a 00                	push   $0x0
  pushl $180
c0102eb2:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102eb7:	e9 f2 f8 ff ff       	jmp    c01027ae <__alltraps>

c0102ebc <vector181>:
.globl vector181
vector181:
  pushl $0
c0102ebc:	6a 00                	push   $0x0
  pushl $181
c0102ebe:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102ec3:	e9 e6 f8 ff ff       	jmp    c01027ae <__alltraps>

c0102ec8 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102ec8:	6a 00                	push   $0x0
  pushl $182
c0102eca:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102ecf:	e9 da f8 ff ff       	jmp    c01027ae <__alltraps>

c0102ed4 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102ed4:	6a 00                	push   $0x0
  pushl $183
c0102ed6:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102edb:	e9 ce f8 ff ff       	jmp    c01027ae <__alltraps>

c0102ee0 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102ee0:	6a 00                	push   $0x0
  pushl $184
c0102ee2:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102ee7:	e9 c2 f8 ff ff       	jmp    c01027ae <__alltraps>

c0102eec <vector185>:
.globl vector185
vector185:
  pushl $0
c0102eec:	6a 00                	push   $0x0
  pushl $185
c0102eee:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102ef3:	e9 b6 f8 ff ff       	jmp    c01027ae <__alltraps>

c0102ef8 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102ef8:	6a 00                	push   $0x0
  pushl $186
c0102efa:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102eff:	e9 aa f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f04 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102f04:	6a 00                	push   $0x0
  pushl $187
c0102f06:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102f0b:	e9 9e f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f10 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102f10:	6a 00                	push   $0x0
  pushl $188
c0102f12:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f17:	e9 92 f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f1c <vector189>:
.globl vector189
vector189:
  pushl $0
c0102f1c:	6a 00                	push   $0x0
  pushl $189
c0102f1e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102f23:	e9 86 f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f28 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f28:	6a 00                	push   $0x0
  pushl $190
c0102f2a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f2f:	e9 7a f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f34 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f34:	6a 00                	push   $0x0
  pushl $191
c0102f36:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f3b:	e9 6e f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f40 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f40:	6a 00                	push   $0x0
  pushl $192
c0102f42:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102f47:	e9 62 f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f4c <vector193>:
.globl vector193
vector193:
  pushl $0
c0102f4c:	6a 00                	push   $0x0
  pushl $193
c0102f4e:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102f53:	e9 56 f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f58 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102f58:	6a 00                	push   $0x0
  pushl $194
c0102f5a:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102f5f:	e9 4a f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f64 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102f64:	6a 00                	push   $0x0
  pushl $195
c0102f66:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102f6b:	e9 3e f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f70 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102f70:	6a 00                	push   $0x0
  pushl $196
c0102f72:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f77:	e9 32 f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f7c <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f7c:	6a 00                	push   $0x0
  pushl $197
c0102f7e:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f83:	e9 26 f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f88 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f88:	6a 00                	push   $0x0
  pushl $198
c0102f8a:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f8f:	e9 1a f8 ff ff       	jmp    c01027ae <__alltraps>

c0102f94 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f94:	6a 00                	push   $0x0
  pushl $199
c0102f96:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f9b:	e9 0e f8 ff ff       	jmp    c01027ae <__alltraps>

c0102fa0 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102fa0:	6a 00                	push   $0x0
  pushl $200
c0102fa2:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102fa7:	e9 02 f8 ff ff       	jmp    c01027ae <__alltraps>

c0102fac <vector201>:
.globl vector201
vector201:
  pushl $0
c0102fac:	6a 00                	push   $0x0
  pushl $201
c0102fae:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102fb3:	e9 f6 f7 ff ff       	jmp    c01027ae <__alltraps>

c0102fb8 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102fb8:	6a 00                	push   $0x0
  pushl $202
c0102fba:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102fbf:	e9 ea f7 ff ff       	jmp    c01027ae <__alltraps>

c0102fc4 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102fc4:	6a 00                	push   $0x0
  pushl $203
c0102fc6:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102fcb:	e9 de f7 ff ff       	jmp    c01027ae <__alltraps>

c0102fd0 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102fd0:	6a 00                	push   $0x0
  pushl $204
c0102fd2:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102fd7:	e9 d2 f7 ff ff       	jmp    c01027ae <__alltraps>

c0102fdc <vector205>:
.globl vector205
vector205:
  pushl $0
c0102fdc:	6a 00                	push   $0x0
  pushl $205
c0102fde:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102fe3:	e9 c6 f7 ff ff       	jmp    c01027ae <__alltraps>

c0102fe8 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102fe8:	6a 00                	push   $0x0
  pushl $206
c0102fea:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102fef:	e9 ba f7 ff ff       	jmp    c01027ae <__alltraps>

c0102ff4 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102ff4:	6a 00                	push   $0x0
  pushl $207
c0102ff6:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102ffb:	e9 ae f7 ff ff       	jmp    c01027ae <__alltraps>

c0103000 <vector208>:
.globl vector208
vector208:
  pushl $0
c0103000:	6a 00                	push   $0x0
  pushl $208
c0103002:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103007:	e9 a2 f7 ff ff       	jmp    c01027ae <__alltraps>

c010300c <vector209>:
.globl vector209
vector209:
  pushl $0
c010300c:	6a 00                	push   $0x0
  pushl $209
c010300e:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103013:	e9 96 f7 ff ff       	jmp    c01027ae <__alltraps>

c0103018 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103018:	6a 00                	push   $0x0
  pushl $210
c010301a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010301f:	e9 8a f7 ff ff       	jmp    c01027ae <__alltraps>

c0103024 <vector211>:
.globl vector211
vector211:
  pushl $0
c0103024:	6a 00                	push   $0x0
  pushl $211
c0103026:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010302b:	e9 7e f7 ff ff       	jmp    c01027ae <__alltraps>

c0103030 <vector212>:
.globl vector212
vector212:
  pushl $0
c0103030:	6a 00                	push   $0x0
  pushl $212
c0103032:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103037:	e9 72 f7 ff ff       	jmp    c01027ae <__alltraps>

c010303c <vector213>:
.globl vector213
vector213:
  pushl $0
c010303c:	6a 00                	push   $0x0
  pushl $213
c010303e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0103043:	e9 66 f7 ff ff       	jmp    c01027ae <__alltraps>

c0103048 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103048:	6a 00                	push   $0x0
  pushl $214
c010304a:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010304f:	e9 5a f7 ff ff       	jmp    c01027ae <__alltraps>

c0103054 <vector215>:
.globl vector215
vector215:
  pushl $0
c0103054:	6a 00                	push   $0x0
  pushl $215
c0103056:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010305b:	e9 4e f7 ff ff       	jmp    c01027ae <__alltraps>

c0103060 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103060:	6a 00                	push   $0x0
  pushl $216
c0103062:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103067:	e9 42 f7 ff ff       	jmp    c01027ae <__alltraps>

c010306c <vector217>:
.globl vector217
vector217:
  pushl $0
c010306c:	6a 00                	push   $0x0
  pushl $217
c010306e:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103073:	e9 36 f7 ff ff       	jmp    c01027ae <__alltraps>

c0103078 <vector218>:
.globl vector218
vector218:
  pushl $0
c0103078:	6a 00                	push   $0x0
  pushl $218
c010307a:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010307f:	e9 2a f7 ff ff       	jmp    c01027ae <__alltraps>

c0103084 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103084:	6a 00                	push   $0x0
  pushl $219
c0103086:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010308b:	e9 1e f7 ff ff       	jmp    c01027ae <__alltraps>

c0103090 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103090:	6a 00                	push   $0x0
  pushl $220
c0103092:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103097:	e9 12 f7 ff ff       	jmp    c01027ae <__alltraps>

c010309c <vector221>:
.globl vector221
vector221:
  pushl $0
c010309c:	6a 00                	push   $0x0
  pushl $221
c010309e:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01030a3:	e9 06 f7 ff ff       	jmp    c01027ae <__alltraps>

c01030a8 <vector222>:
.globl vector222
vector222:
  pushl $0
c01030a8:	6a 00                	push   $0x0
  pushl $222
c01030aa:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01030af:	e9 fa f6 ff ff       	jmp    c01027ae <__alltraps>

c01030b4 <vector223>:
.globl vector223
vector223:
  pushl $0
c01030b4:	6a 00                	push   $0x0
  pushl $223
c01030b6:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01030bb:	e9 ee f6 ff ff       	jmp    c01027ae <__alltraps>

c01030c0 <vector224>:
.globl vector224
vector224:
  pushl $0
c01030c0:	6a 00                	push   $0x0
  pushl $224
c01030c2:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01030c7:	e9 e2 f6 ff ff       	jmp    c01027ae <__alltraps>

c01030cc <vector225>:
.globl vector225
vector225:
  pushl $0
c01030cc:	6a 00                	push   $0x0
  pushl $225
c01030ce:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01030d3:	e9 d6 f6 ff ff       	jmp    c01027ae <__alltraps>

c01030d8 <vector226>:
.globl vector226
vector226:
  pushl $0
c01030d8:	6a 00                	push   $0x0
  pushl $226
c01030da:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01030df:	e9 ca f6 ff ff       	jmp    c01027ae <__alltraps>

c01030e4 <vector227>:
.globl vector227
vector227:
  pushl $0
c01030e4:	6a 00                	push   $0x0
  pushl $227
c01030e6:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01030eb:	e9 be f6 ff ff       	jmp    c01027ae <__alltraps>

c01030f0 <vector228>:
.globl vector228
vector228:
  pushl $0
c01030f0:	6a 00                	push   $0x0
  pushl $228
c01030f2:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01030f7:	e9 b2 f6 ff ff       	jmp    c01027ae <__alltraps>

c01030fc <vector229>:
.globl vector229
vector229:
  pushl $0
c01030fc:	6a 00                	push   $0x0
  pushl $229
c01030fe:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103103:	e9 a6 f6 ff ff       	jmp    c01027ae <__alltraps>

c0103108 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103108:	6a 00                	push   $0x0
  pushl $230
c010310a:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010310f:	e9 9a f6 ff ff       	jmp    c01027ae <__alltraps>

c0103114 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103114:	6a 00                	push   $0x0
  pushl $231
c0103116:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010311b:	e9 8e f6 ff ff       	jmp    c01027ae <__alltraps>

c0103120 <vector232>:
.globl vector232
vector232:
  pushl $0
c0103120:	6a 00                	push   $0x0
  pushl $232
c0103122:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103127:	e9 82 f6 ff ff       	jmp    c01027ae <__alltraps>

c010312c <vector233>:
.globl vector233
vector233:
  pushl $0
c010312c:	6a 00                	push   $0x0
  pushl $233
c010312e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103133:	e9 76 f6 ff ff       	jmp    c01027ae <__alltraps>

c0103138 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103138:	6a 00                	push   $0x0
  pushl $234
c010313a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010313f:	e9 6a f6 ff ff       	jmp    c01027ae <__alltraps>

c0103144 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103144:	6a 00                	push   $0x0
  pushl $235
c0103146:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010314b:	e9 5e f6 ff ff       	jmp    c01027ae <__alltraps>

c0103150 <vector236>:
.globl vector236
vector236:
  pushl $0
c0103150:	6a 00                	push   $0x0
  pushl $236
c0103152:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103157:	e9 52 f6 ff ff       	jmp    c01027ae <__alltraps>

c010315c <vector237>:
.globl vector237
vector237:
  pushl $0
c010315c:	6a 00                	push   $0x0
  pushl $237
c010315e:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103163:	e9 46 f6 ff ff       	jmp    c01027ae <__alltraps>

c0103168 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103168:	6a 00                	push   $0x0
  pushl $238
c010316a:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010316f:	e9 3a f6 ff ff       	jmp    c01027ae <__alltraps>

c0103174 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103174:	6a 00                	push   $0x0
  pushl $239
c0103176:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010317b:	e9 2e f6 ff ff       	jmp    c01027ae <__alltraps>

c0103180 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103180:	6a 00                	push   $0x0
  pushl $240
c0103182:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103187:	e9 22 f6 ff ff       	jmp    c01027ae <__alltraps>

c010318c <vector241>:
.globl vector241
vector241:
  pushl $0
c010318c:	6a 00                	push   $0x0
  pushl $241
c010318e:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103193:	e9 16 f6 ff ff       	jmp    c01027ae <__alltraps>

c0103198 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103198:	6a 00                	push   $0x0
  pushl $242
c010319a:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010319f:	e9 0a f6 ff ff       	jmp    c01027ae <__alltraps>

c01031a4 <vector243>:
.globl vector243
vector243:
  pushl $0
c01031a4:	6a 00                	push   $0x0
  pushl $243
c01031a6:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01031ab:	e9 fe f5 ff ff       	jmp    c01027ae <__alltraps>

c01031b0 <vector244>:
.globl vector244
vector244:
  pushl $0
c01031b0:	6a 00                	push   $0x0
  pushl $244
c01031b2:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01031b7:	e9 f2 f5 ff ff       	jmp    c01027ae <__alltraps>

c01031bc <vector245>:
.globl vector245
vector245:
  pushl $0
c01031bc:	6a 00                	push   $0x0
  pushl $245
c01031be:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01031c3:	e9 e6 f5 ff ff       	jmp    c01027ae <__alltraps>

c01031c8 <vector246>:
.globl vector246
vector246:
  pushl $0
c01031c8:	6a 00                	push   $0x0
  pushl $246
c01031ca:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01031cf:	e9 da f5 ff ff       	jmp    c01027ae <__alltraps>

c01031d4 <vector247>:
.globl vector247
vector247:
  pushl $0
c01031d4:	6a 00                	push   $0x0
  pushl $247
c01031d6:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01031db:	e9 ce f5 ff ff       	jmp    c01027ae <__alltraps>

c01031e0 <vector248>:
.globl vector248
vector248:
  pushl $0
c01031e0:	6a 00                	push   $0x0
  pushl $248
c01031e2:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01031e7:	e9 c2 f5 ff ff       	jmp    c01027ae <__alltraps>

c01031ec <vector249>:
.globl vector249
vector249:
  pushl $0
c01031ec:	6a 00                	push   $0x0
  pushl $249
c01031ee:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01031f3:	e9 b6 f5 ff ff       	jmp    c01027ae <__alltraps>

c01031f8 <vector250>:
.globl vector250
vector250:
  pushl $0
c01031f8:	6a 00                	push   $0x0
  pushl $250
c01031fa:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01031ff:	e9 aa f5 ff ff       	jmp    c01027ae <__alltraps>

c0103204 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103204:	6a 00                	push   $0x0
  pushl $251
c0103206:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010320b:	e9 9e f5 ff ff       	jmp    c01027ae <__alltraps>

c0103210 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103210:	6a 00                	push   $0x0
  pushl $252
c0103212:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103217:	e9 92 f5 ff ff       	jmp    c01027ae <__alltraps>

c010321c <vector253>:
.globl vector253
vector253:
  pushl $0
c010321c:	6a 00                	push   $0x0
  pushl $253
c010321e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103223:	e9 86 f5 ff ff       	jmp    c01027ae <__alltraps>

c0103228 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103228:	6a 00                	push   $0x0
  pushl $254
c010322a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010322f:	e9 7a f5 ff ff       	jmp    c01027ae <__alltraps>

c0103234 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103234:	6a 00                	push   $0x0
  pushl $255
c0103236:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010323b:	e9 6e f5 ff ff       	jmp    c01027ae <__alltraps>

c0103240 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103240:	55                   	push   %ebp
c0103241:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103243:	8b 55 08             	mov    0x8(%ebp),%edx
c0103246:	a1 f4 2a 12 c0       	mov    0xc0122af4,%eax
c010324b:	29 c2                	sub    %eax,%edx
c010324d:	89 d0                	mov    %edx,%eax
c010324f:	c1 f8 05             	sar    $0x5,%eax
}
c0103252:	5d                   	pop    %ebp
c0103253:	c3                   	ret    

c0103254 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103254:	55                   	push   %ebp
c0103255:	89 e5                	mov    %esp,%ebp
c0103257:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010325a:	8b 45 08             	mov    0x8(%ebp),%eax
c010325d:	89 04 24             	mov    %eax,(%esp)
c0103260:	e8 db ff ff ff       	call   c0103240 <page2ppn>
c0103265:	c1 e0 0c             	shl    $0xc,%eax
}
c0103268:	c9                   	leave  
c0103269:	c3                   	ret    

c010326a <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010326a:	55                   	push   %ebp
c010326b:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010326d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103270:	8b 00                	mov    (%eax),%eax
}
c0103272:	5d                   	pop    %ebp
c0103273:	c3                   	ret    

c0103274 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103274:	55                   	push   %ebp
c0103275:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103277:	8b 45 08             	mov    0x8(%ebp),%eax
c010327a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010327d:	89 10                	mov    %edx,(%eax)
}
c010327f:	5d                   	pop    %ebp
c0103280:	c3                   	ret    

c0103281 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103281:	55                   	push   %ebp
c0103282:	89 e5                	mov    %esp,%ebp
c0103284:	83 ec 10             	sub    $0x10,%esp
c0103287:	c7 45 fc e0 2a 12 c0 	movl   $0xc0122ae0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010328e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103291:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103294:	89 50 04             	mov    %edx,0x4(%eax)
c0103297:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010329a:	8b 50 04             	mov    0x4(%eax),%edx
c010329d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032a0:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01032a2:	c7 05 e8 2a 12 c0 00 	movl   $0x0,0xc0122ae8
c01032a9:	00 00 00 
}
c01032ac:	c9                   	leave  
c01032ad:	c3                   	ret    

c01032ae <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01032ae:	55                   	push   %ebp
c01032af:	89 e5                	mov    %esp,%ebp
c01032b1:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01032b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01032b8:	75 24                	jne    c01032de <default_init_memmap+0x30>
c01032ba:	c7 44 24 0c 70 99 10 	movl   $0xc0109970,0xc(%esp)
c01032c1:	c0 
c01032c2:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c01032c9:	c0 
c01032ca:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01032d1:	00 
c01032d2:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c01032d9:	e8 f7 d9 ff ff       	call   c0100cd5 <__panic>
    struct Page *p = base;
c01032de:	8b 45 08             	mov    0x8(%ebp),%eax
c01032e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01032e4:	e9 de 00 00 00       	jmp    c01033c7 <default_init_memmap+0x119>
        assert(PageReserved(p));
c01032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032ec:	83 c0 04             	add    $0x4,%eax
c01032ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01032f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01032f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01032ff:	0f a3 10             	bt     %edx,(%eax)
c0103302:	19 c0                	sbb    %eax,%eax
c0103304:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103307:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010330b:	0f 95 c0             	setne  %al
c010330e:	0f b6 c0             	movzbl %al,%eax
c0103311:	85 c0                	test   %eax,%eax
c0103313:	75 24                	jne    c0103339 <default_init_memmap+0x8b>
c0103315:	c7 44 24 0c a1 99 10 	movl   $0xc01099a1,0xc(%esp)
c010331c:	c0 
c010331d:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103324:	c0 
c0103325:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c010332c:	00 
c010332d:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103334:	e8 9c d9 ff ff       	call   c0100cd5 <__panic>
        p->flags = p->property = 0;
c0103339:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010333c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0103343:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103346:	8b 50 08             	mov    0x8(%eax),%edx
c0103349:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010334c:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010334f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103356:	00 
c0103357:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010335a:	89 04 24             	mov    %eax,(%esp)
c010335d:	e8 12 ff ff ff       	call   c0103274 <set_page_ref>
        SetPageProperty(p);
c0103362:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103365:	83 c0 04             	add    $0x4,%eax
c0103368:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010336f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103372:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103375:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103378:	0f ab 10             	bts    %edx,(%eax)
        list_add_before(&free_list, &(p->page_link));
c010337b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010337e:	83 c0 0c             	add    $0xc,%eax
c0103381:	c7 45 dc e0 2a 12 c0 	movl   $0xc0122ae0,-0x24(%ebp)
c0103388:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010338b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010338e:	8b 00                	mov    (%eax),%eax
c0103390:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103393:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103396:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103399:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010339c:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010339f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033a2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033a5:	89 10                	mov    %edx,(%eax)
c01033a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033aa:	8b 10                	mov    (%eax),%edx
c01033ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033af:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01033b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01033b5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01033b8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01033bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01033be:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033c1:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01033c3:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01033c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033ca:	c1 e0 05             	shl    $0x5,%eax
c01033cd:	89 c2                	mov    %eax,%edx
c01033cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01033d2:	01 d0                	add    %edx,%eax
c01033d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01033d7:	0f 85 0c ff ff ff    	jne    c01032e9 <default_init_memmap+0x3b>
        p->flags = p->property = 0;
        set_page_ref(p, 0);
        SetPageProperty(p);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c01033dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01033e0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01033e3:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c01033e6:	8b 15 e8 2a 12 c0    	mov    0xc0122ae8,%edx
c01033ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033ef:	01 d0                	add    %edx,%eax
c01033f1:	a3 e8 2a 12 c0       	mov    %eax,0xc0122ae8
}
c01033f6:	c9                   	leave  
c01033f7:	c3                   	ret    

c01033f8 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01033f8:	55                   	push   %ebp
c01033f9:	89 e5                	mov    %esp,%ebp
c01033fb:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01033fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103402:	75 24                	jne    c0103428 <default_alloc_pages+0x30>
c0103404:	c7 44 24 0c 70 99 10 	movl   $0xc0109970,0xc(%esp)
c010340b:	c0 
c010340c:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103413:	c0 
c0103414:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c010341b:	00 
c010341c:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103423:	e8 ad d8 ff ff       	call   c0100cd5 <__panic>
    if (n > nr_free) {
c0103428:	a1 e8 2a 12 c0       	mov    0xc0122ae8,%eax
c010342d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103430:	73 0a                	jae    c010343c <default_alloc_pages+0x44>
        return NULL;
c0103432:	b8 00 00 00 00       	mov    $0x0,%eax
c0103437:	e9 37 01 00 00       	jmp    c0103573 <default_alloc_pages+0x17b>
    }

    list_entry_t *len;			// 跟以前的p和q双指针差不多，le相当于前指针，len后指针
    list_entry_t *le = &free_list;
c010343c:	c7 45 f4 e0 2a 12 c0 	movl   $0xc0122ae0,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103443:	e9 0a 01 00 00       	jmp    c0103552 <default_alloc_pages+0x15a>
        struct Page *p = le2page(le, page_link);
c0103448:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010344b:	83 e8 0c             	sub    $0xc,%eax
c010344e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0103451:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103454:	8b 40 08             	mov    0x8(%eax),%eax
c0103457:	3b 45 08             	cmp    0x8(%ebp),%eax
c010345a:	0f 82 f2 00 00 00    	jb     c0103552 <default_alloc_pages+0x15a>
            // 分配页数
            int i;
            for (i = 0; i < n; i++) {
c0103460:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103467:	eb 7c                	jmp    c01034e5 <default_alloc_pages+0xed>
c0103469:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010346c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010346f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103472:	8b 40 04             	mov    0x4(%eax),%eax
            	len = list_next(le);
c0103475:	89 45 e8             	mov    %eax,-0x18(%ebp)
            	struct Page *pp = le2page(le, page_link);
c0103478:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010347b:	83 e8 0c             	sub    $0xc,%eax
c010347e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            	// 每一页的标志位改写
            	// 被内核所保留
            	SetPageReserved(pp);
c0103481:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103484:	83 c0 04             	add    $0x4,%eax
c0103487:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010348e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103491:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103494:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103497:	0f ab 10             	bts    %edx,(%eax)
            	// 不是头页
            	ClearPageProperty(pp);
c010349a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010349d:	83 c0 04             	add    $0x4,%eax
c01034a0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01034a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01034aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01034b0:	0f b3 10             	btr    %edx,(%eax)
c01034b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034b6:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01034b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01034bc:	8b 40 04             	mov    0x4(%eax),%eax
c01034bf:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01034c2:	8b 12                	mov    (%edx),%edx
c01034c4:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01034c7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01034ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01034cd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01034d0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01034d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01034d6:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01034d9:	89 10                	mov    %edx,(%eax)
            	// 既然分配好了，下一步就将其从freelist中删除
            	list_del(le);
            	le = len;
c01034db:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            // 分配页数
            int i;
            for (i = 0; i < n; i++) {
c01034e1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01034e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034e8:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034eb:	0f 82 78 ff ff ff    	jb     c0103469 <default_alloc_pages+0x71>
            	ClearPageProperty(pp);
            	// 既然分配好了，下一步就将其从freelist中删除
            	list_del(le);
            	le = len;
            }
            if (p->property > n) {
c01034f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034f4:	8b 40 08             	mov    0x8(%eax),%eax
c01034f7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034fa:	76 12                	jbe    c010350e <default_alloc_pages+0x116>
				// p指针移动到顶部（这里好象是反着的，其实到了头页）
				// 修改头页的标志位，可参考高书8.3.2
				//struct Page *p = le2page(le, page_link);
				le2page(le, page_link)->property = p->property - n;
c01034fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034ff:	8d 50 f4             	lea    -0xc(%eax),%edx
c0103502:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103505:	8b 40 08             	mov    0x8(%eax),%eax
c0103508:	2b 45 08             	sub    0x8(%ebp),%eax
c010350b:	89 42 08             	mov    %eax,0x8(%edx)
			}
            // 修改头页的标志位
            ClearPageProperty(p);
c010350e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103511:	83 c0 04             	add    $0x4,%eax
c0103514:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010351b:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010351e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103521:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103524:	0f b3 10             	btr    %edx,(%eax)
            SetPageReserved(p);
c0103527:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010352a:	83 c0 04             	add    $0x4,%eax
c010352d:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c0103534:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103537:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010353a:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010353d:	0f ab 10             	bts    %edx,(%eax)
            nr_free -= n;
c0103540:	a1 e8 2a 12 c0       	mov    0xc0122ae8,%eax
c0103545:	2b 45 08             	sub    0x8(%ebp),%eax
c0103548:	a3 e8 2a 12 c0       	mov    %eax,0xc0122ae8
            return p;
c010354d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103550:	eb 21                	jmp    c0103573 <default_alloc_pages+0x17b>
c0103552:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103555:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103558:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010355b:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }

    list_entry_t *len;			// 跟以前的p和q双指针差不多，le相当于前指针，len后指针
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010355e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103561:	81 7d f4 e0 2a 12 c0 	cmpl   $0xc0122ae0,-0xc(%ebp)
c0103568:	0f 85 da fe ff ff    	jne    c0103448 <default_alloc_pages+0x50>
            SetPageReserved(p);
            nr_free -= n;
            return p;
        }
    }
    return NULL;
c010356e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103573:	c9                   	leave  
c0103574:	c3                   	ret    

c0103575 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103575:	55                   	push   %ebp
c0103576:	89 e5                	mov    %esp,%ebp
c0103578:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010357b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010357f:	75 24                	jne    c01035a5 <default_free_pages+0x30>
c0103581:	c7 44 24 0c 70 99 10 	movl   $0xc0109970,0xc(%esp)
c0103588:	c0 
c0103589:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103590:	c0 
c0103591:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
c0103598:	00 
c0103599:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c01035a0:	e8 30 d7 ff ff       	call   c0100cd5 <__panic>
    // 断言是被内核保留页
    // 这里我不明白为什么申请和释放都标记为“内核保留”？？？
    assert(PageReserved(base));
c01035a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01035a8:	83 c0 04             	add    $0x4,%eax
c01035ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01035b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01035bb:	0f a3 10             	bt     %edx,(%eax)
c01035be:	19 c0                	sbb    %eax,%eax
c01035c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c01035c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01035c7:	0f 95 c0             	setne  %al
c01035ca:	0f b6 c0             	movzbl %al,%eax
c01035cd:	85 c0                	test   %eax,%eax
c01035cf:	75 24                	jne    c01035f5 <default_free_pages+0x80>
c01035d1:	c7 44 24 0c b1 99 10 	movl   $0xc01099b1,0xc(%esp)
c01035d8:	c0 
c01035d9:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c01035e0:	c0 
c01035e1:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c01035e8:	00 
c01035e9:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c01035f0:	e8 e0 d6 ff ff       	call   c0100cd5 <__panic>
    struct Page *p;
    list_entry_t *le = &free_list;
c01035f5:	c7 45 f0 e0 2a 12 c0 	movl   $0xc0122ae0,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01035fc:	eb 13                	jmp    c0103611 <default_free_pages+0x9c>
    	p = le2page(le, page_link);
c01035fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103601:	83 e8 0c             	sub    $0xc,%eax
c0103604:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (p>base) {
c0103607:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010360a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010360d:	76 02                	jbe    c0103611 <default_free_pages+0x9c>
			break;
c010360f:	eb 18                	jmp    c0103629 <default_free_pages+0xb4>
c0103611:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103614:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103617:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010361a:	8b 40 04             	mov    0x4(%eax),%eax
    // 断言是被内核保留页
    // 这里我不明白为什么申请和释放都标记为“内核保留”？？？
    assert(PageReserved(base));
    struct Page *p;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010361d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103620:	81 7d f0 e0 2a 12 c0 	cmpl   $0xc0122ae0,-0x10(%ebp)
c0103627:	75 d5                	jne    c01035fe <default_free_pages+0x89>
    	p = le2page(le, page_link);
		if (p>base) {
			break;
		}
    }
    for (p=base; p < base + n; p ++) {
c0103629:	8b 45 08             	mov    0x8(%ebp),%eax
c010362c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010362f:	eb 4b                	jmp    c010367c <default_free_pages+0x107>
    	// 因为被释放了，所以重新加回到freelist中
    	list_add_before(le, &(p->page_link));
c0103631:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103634:	8d 50 0c             	lea    0xc(%eax),%edx
c0103637:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010363a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010363d:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103640:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103643:	8b 00                	mov    (%eax),%eax
c0103645:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103648:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010364b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010364e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103651:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103654:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103657:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010365a:	89 10                	mov    %edx,(%eax)
c010365c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010365f:	8b 10                	mov    (%eax),%edx
c0103661:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103664:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103667:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010366a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010366d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103670:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103673:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103676:	89 10                	mov    %edx,(%eax)
    	p = le2page(le, page_link);
		if (p>base) {
			break;
		}
    }
    for (p=base; p < base + n; p ++) {
c0103678:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010367c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010367f:	c1 e0 05             	shl    $0x5,%eax
c0103682:	89 c2                	mov    %eax,%edx
c0103684:	8b 45 08             	mov    0x8(%ebp),%eax
c0103687:	01 d0                	add    %edx,%eax
c0103689:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010368c:	77 a3                	ja     c0103631 <default_free_pages+0xbc>
    	list_add_before(le, &(p->page_link));
    	// 每一页的标志位不用改了，改下头页就行了
    }

    // 下面这几句话是有顺序的？？？
    base->flags = 0;
c010368e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103691:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0103698:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010369f:	00 
c01036a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01036a3:	89 04 24             	mov    %eax,(%esp)
c01036a6:	e8 c9 fb ff ff       	call   c0103274 <set_page_ref>
    // 声明是头页
    SetPageProperty(base);
c01036ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01036ae:	83 c0 04             	add    $0x4,%eax
c01036b1:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c01036b8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01036bb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01036be:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01036c1:	0f ab 10             	bts    %edx,(%eax)
    // 记录空闲页的数目n
    base->property = n;
c01036c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01036c7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01036ca:	89 50 08             	mov    %edx,0x8(%eax)



    // 向高位合并
    p = le2page(le, page_link);
c01036cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036d0:	83 e8 0c             	sub    $0xc,%eax
c01036d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // p在高地址，base在低地址
    if (p == base + n) {
c01036d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036d9:	c1 e0 05             	shl    $0x5,%eax
c01036dc:	89 c2                	mov    %eax,%edx
c01036de:	8b 45 08             	mov    0x8(%ebp),%eax
c01036e1:	01 d0                	add    %edx,%eax
c01036e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036e6:	75 1e                	jne    c0103706 <default_free_pages+0x191>
    	// 下面的base的property改下
    	base->property = base->property + p->property;
c01036e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01036eb:	8b 50 08             	mov    0x8(%eax),%edx
c01036ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f1:	8b 40 08             	mov    0x8(%eax),%eax
c01036f4:	01 c2                	add    %eax,%edx
c01036f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01036f9:	89 50 08             	mov    %edx,0x8(%eax)
    	// 中间那层打掉了，参考高书图8-5
    	p->property = 0;
c01036fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }

    // 向低位合并，参考高书图8-6
    // 现在是在空闲结点（高书中间下面的那个），指针先往前移一个结点，就是高书图8-6(a)最中间的结点（p指向的那个）
    le = list_prev(&base->page_link);
c0103706:	8b 45 08             	mov    0x8(%ebp),%eax
c0103709:	83 c0 0c             	add    $0xc,%eax
c010370c:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010370f:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103712:	8b 00                	mov    (%eax),%eax
c0103714:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(le, page_link);
c0103717:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010371a:	83 e8 0c             	sub    $0xc,%eax
c010371d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // p指向中间上面结点的头页，base指向中间下面的结点的头页
    if (le != &free_list && p == base - 1) {
c0103720:	81 7d f0 e0 2a 12 c0 	cmpl   $0xc0122ae0,-0x10(%ebp)
c0103727:	74 57                	je     c0103780 <default_free_pages+0x20b>
c0103729:	8b 45 08             	mov    0x8(%ebp),%eax
c010372c:	83 e8 20             	sub    $0x20,%eax
c010372f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103732:	75 4c                	jne    c0103780 <default_free_pages+0x20b>
    	// 直到找到右边的空闲页
    	while (le != &free_list) {
c0103734:	eb 41                	jmp    c0103777 <default_free_pages+0x202>
    		// 中间上面的结点非空
    		if (p->property > 0) {
c0103736:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103739:	8b 40 08             	mov    0x8(%eax),%eax
c010373c:	85 c0                	test   %eax,%eax
c010373e:	74 20                	je     c0103760 <default_free_pages+0x1eb>
    			p->property = base->property + p->property;
c0103740:	8b 45 08             	mov    0x8(%ebp),%eax
c0103743:	8b 50 08             	mov    0x8(%eax),%edx
c0103746:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103749:	8b 40 08             	mov    0x8(%eax),%eax
c010374c:	01 c2                	add    %eax,%edx
c010374e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103751:	89 50 08             	mov    %edx,0x8(%eax)
    			base->property = 0;
c0103754:	8b 45 08             	mov    0x8(%ebp),%eax
c0103757:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    			break;
c010375e:	eb 20                	jmp    c0103780 <default_free_pages+0x20b>
c0103760:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103763:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103766:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103769:	8b 00                	mov    (%eax),%eax
    		}
    		// 那没找到右边空间页，就往前走
    		le = list_prev(le);
c010376b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    		p = le2page(le, page_link);
c010376e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103771:	83 e8 0c             	sub    $0xc,%eax
c0103774:	89 45 f4             	mov    %eax,-0xc(%ebp)
    le = list_prev(&base->page_link);
    p = le2page(le, page_link);
    // p指向中间上面结点的头页，base指向中间下面的结点的头页
    if (le != &free_list && p == base - 1) {
    	// 直到找到右边的空闲页
    	while (le != &free_list) {
c0103777:	81 7d f0 e0 2a 12 c0 	cmpl   $0xc0122ae0,-0x10(%ebp)
c010377e:	75 b6                	jne    c0103736 <default_free_pages+0x1c1>
    		le = list_prev(le);
    		p = le2page(le, page_link);

    	}
    }
    nr_free += n;
c0103780:	8b 15 e8 2a 12 c0    	mov    0xc0122ae8,%edx
c0103786:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103789:	01 d0                	add    %edx,%eax
c010378b:	a3 e8 2a 12 c0       	mov    %eax,0xc0122ae8
}
c0103790:	c9                   	leave  
c0103791:	c3                   	ret    

c0103792 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103792:	55                   	push   %ebp
c0103793:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103795:	a1 e8 2a 12 c0       	mov    0xc0122ae8,%eax
}
c010379a:	5d                   	pop    %ebp
c010379b:	c3                   	ret    

c010379c <basic_check>:

static void
basic_check(void) {
c010379c:	55                   	push   %ebp
c010379d:	89 e5                	mov    %esp,%ebp
c010379f:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01037a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01037a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01037af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01037b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037bc:	e8 bf 0e 00 00       	call   c0104680 <alloc_pages>
c01037c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01037c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01037c8:	75 24                	jne    c01037ee <basic_check+0x52>
c01037ca:	c7 44 24 0c c4 99 10 	movl   $0xc01099c4,0xc(%esp)
c01037d1:	c0 
c01037d2:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c01037d9:	c0 
c01037da:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c01037e1:	00 
c01037e2:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c01037e9:	e8 e7 d4 ff ff       	call   c0100cd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01037ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037f5:	e8 86 0e 00 00       	call   c0104680 <alloc_pages>
c01037fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01037fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103801:	75 24                	jne    c0103827 <basic_check+0x8b>
c0103803:	c7 44 24 0c e0 99 10 	movl   $0xc01099e0,0xc(%esp)
c010380a:	c0 
c010380b:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103812:	c0 
c0103813:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c010381a:	00 
c010381b:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103822:	e8 ae d4 ff ff       	call   c0100cd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103827:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010382e:	e8 4d 0e 00 00       	call   c0104680 <alloc_pages>
c0103833:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010383a:	75 24                	jne    c0103860 <basic_check+0xc4>
c010383c:	c7 44 24 0c fc 99 10 	movl   $0xc01099fc,0xc(%esp)
c0103843:	c0 
c0103844:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c010384b:	c0 
c010384c:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103853:	00 
c0103854:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c010385b:	e8 75 d4 ff ff       	call   c0100cd5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103860:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103863:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103866:	74 10                	je     c0103878 <basic_check+0xdc>
c0103868:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010386b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010386e:	74 08                	je     c0103878 <basic_check+0xdc>
c0103870:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103873:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103876:	75 24                	jne    c010389c <basic_check+0x100>
c0103878:	c7 44 24 0c 18 9a 10 	movl   $0xc0109a18,0xc(%esp)
c010387f:	c0 
c0103880:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103887:	c0 
c0103888:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c010388f:	00 
c0103890:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103897:	e8 39 d4 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010389c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010389f:	89 04 24             	mov    %eax,(%esp)
c01038a2:	e8 c3 f9 ff ff       	call   c010326a <page_ref>
c01038a7:	85 c0                	test   %eax,%eax
c01038a9:	75 1e                	jne    c01038c9 <basic_check+0x12d>
c01038ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038ae:	89 04 24             	mov    %eax,(%esp)
c01038b1:	e8 b4 f9 ff ff       	call   c010326a <page_ref>
c01038b6:	85 c0                	test   %eax,%eax
c01038b8:	75 0f                	jne    c01038c9 <basic_check+0x12d>
c01038ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038bd:	89 04 24             	mov    %eax,(%esp)
c01038c0:	e8 a5 f9 ff ff       	call   c010326a <page_ref>
c01038c5:	85 c0                	test   %eax,%eax
c01038c7:	74 24                	je     c01038ed <basic_check+0x151>
c01038c9:	c7 44 24 0c 3c 9a 10 	movl   $0xc0109a3c,0xc(%esp)
c01038d0:	c0 
c01038d1:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c01038d8:	c0 
c01038d9:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c01038e0:	00 
c01038e1:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c01038e8:	e8 e8 d3 ff ff       	call   c0100cd5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01038ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038f0:	89 04 24             	mov    %eax,(%esp)
c01038f3:	e8 5c f9 ff ff       	call   c0103254 <page2pa>
c01038f8:	8b 15 40 2a 12 c0    	mov    0xc0122a40,%edx
c01038fe:	c1 e2 0c             	shl    $0xc,%edx
c0103901:	39 d0                	cmp    %edx,%eax
c0103903:	72 24                	jb     c0103929 <basic_check+0x18d>
c0103905:	c7 44 24 0c 78 9a 10 	movl   $0xc0109a78,0xc(%esp)
c010390c:	c0 
c010390d:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103914:	c0 
c0103915:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010391c:	00 
c010391d:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103924:	e8 ac d3 ff ff       	call   c0100cd5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103929:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010392c:	89 04 24             	mov    %eax,(%esp)
c010392f:	e8 20 f9 ff ff       	call   c0103254 <page2pa>
c0103934:	8b 15 40 2a 12 c0    	mov    0xc0122a40,%edx
c010393a:	c1 e2 0c             	shl    $0xc,%edx
c010393d:	39 d0                	cmp    %edx,%eax
c010393f:	72 24                	jb     c0103965 <basic_check+0x1c9>
c0103941:	c7 44 24 0c 95 9a 10 	movl   $0xc0109a95,0xc(%esp)
c0103948:	c0 
c0103949:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103950:	c0 
c0103951:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103958:	00 
c0103959:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103960:	e8 70 d3 ff ff       	call   c0100cd5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103965:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103968:	89 04 24             	mov    %eax,(%esp)
c010396b:	e8 e4 f8 ff ff       	call   c0103254 <page2pa>
c0103970:	8b 15 40 2a 12 c0    	mov    0xc0122a40,%edx
c0103976:	c1 e2 0c             	shl    $0xc,%edx
c0103979:	39 d0                	cmp    %edx,%eax
c010397b:	72 24                	jb     c01039a1 <basic_check+0x205>
c010397d:	c7 44 24 0c b2 9a 10 	movl   $0xc0109ab2,0xc(%esp)
c0103984:	c0 
c0103985:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c010398c:	c0 
c010398d:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103994:	00 
c0103995:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c010399c:	e8 34 d3 ff ff       	call   c0100cd5 <__panic>

    list_entry_t free_list_store = free_list;
c01039a1:	a1 e0 2a 12 c0       	mov    0xc0122ae0,%eax
c01039a6:	8b 15 e4 2a 12 c0    	mov    0xc0122ae4,%edx
c01039ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01039af:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01039b2:	c7 45 e0 e0 2a 12 c0 	movl   $0xc0122ae0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01039b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01039bf:	89 50 04             	mov    %edx,0x4(%eax)
c01039c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039c5:	8b 50 04             	mov    0x4(%eax),%edx
c01039c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039cb:	89 10                	mov    %edx,(%eax)
c01039cd:	c7 45 dc e0 2a 12 c0 	movl   $0xc0122ae0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01039d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039d7:	8b 40 04             	mov    0x4(%eax),%eax
c01039da:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01039dd:	0f 94 c0             	sete   %al
c01039e0:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01039e3:	85 c0                	test   %eax,%eax
c01039e5:	75 24                	jne    c0103a0b <basic_check+0x26f>
c01039e7:	c7 44 24 0c cf 9a 10 	movl   $0xc0109acf,0xc(%esp)
c01039ee:	c0 
c01039ef:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c01039f6:	c0 
c01039f7:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01039fe:	00 
c01039ff:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103a06:	e8 ca d2 ff ff       	call   c0100cd5 <__panic>

    unsigned int nr_free_store = nr_free;
c0103a0b:	a1 e8 2a 12 c0       	mov    0xc0122ae8,%eax
c0103a10:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103a13:	c7 05 e8 2a 12 c0 00 	movl   $0x0,0xc0122ae8
c0103a1a:	00 00 00 

    assert(alloc_page() == NULL);
c0103a1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a24:	e8 57 0c 00 00       	call   c0104680 <alloc_pages>
c0103a29:	85 c0                	test   %eax,%eax
c0103a2b:	74 24                	je     c0103a51 <basic_check+0x2b5>
c0103a2d:	c7 44 24 0c e6 9a 10 	movl   $0xc0109ae6,0xc(%esp)
c0103a34:	c0 
c0103a35:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103a3c:	c0 
c0103a3d:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103a44:	00 
c0103a45:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103a4c:	e8 84 d2 ff ff       	call   c0100cd5 <__panic>

    free_page(p0);
c0103a51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a58:	00 
c0103a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a5c:	89 04 24             	mov    %eax,(%esp)
c0103a5f:	e8 87 0c 00 00       	call   c01046eb <free_pages>
    free_page(p1);
c0103a64:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a6b:	00 
c0103a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a6f:	89 04 24             	mov    %eax,(%esp)
c0103a72:	e8 74 0c 00 00       	call   c01046eb <free_pages>
    free_page(p2);
c0103a77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a7e:	00 
c0103a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a82:	89 04 24             	mov    %eax,(%esp)
c0103a85:	e8 61 0c 00 00       	call   c01046eb <free_pages>
    assert(nr_free == 3);
c0103a8a:	a1 e8 2a 12 c0       	mov    0xc0122ae8,%eax
c0103a8f:	83 f8 03             	cmp    $0x3,%eax
c0103a92:	74 24                	je     c0103ab8 <basic_check+0x31c>
c0103a94:	c7 44 24 0c fb 9a 10 	movl   $0xc0109afb,0xc(%esp)
c0103a9b:	c0 
c0103a9c:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103aa3:	c0 
c0103aa4:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103aab:	00 
c0103aac:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103ab3:	e8 1d d2 ff ff       	call   c0100cd5 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103ab8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103abf:	e8 bc 0b 00 00       	call   c0104680 <alloc_pages>
c0103ac4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103ac7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103acb:	75 24                	jne    c0103af1 <basic_check+0x355>
c0103acd:	c7 44 24 0c c4 99 10 	movl   $0xc01099c4,0xc(%esp)
c0103ad4:	c0 
c0103ad5:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103adc:	c0 
c0103add:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0103ae4:	00 
c0103ae5:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103aec:	e8 e4 d1 ff ff       	call   c0100cd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103af1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103af8:	e8 83 0b 00 00       	call   c0104680 <alloc_pages>
c0103afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b04:	75 24                	jne    c0103b2a <basic_check+0x38e>
c0103b06:	c7 44 24 0c e0 99 10 	movl   $0xc01099e0,0xc(%esp)
c0103b0d:	c0 
c0103b0e:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103b15:	c0 
c0103b16:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0103b1d:	00 
c0103b1e:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103b25:	e8 ab d1 ff ff       	call   c0100cd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103b2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b31:	e8 4a 0b 00 00       	call   c0104680 <alloc_pages>
c0103b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103b39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b3d:	75 24                	jne    c0103b63 <basic_check+0x3c7>
c0103b3f:	c7 44 24 0c fc 99 10 	movl   $0xc01099fc,0xc(%esp)
c0103b46:	c0 
c0103b47:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103b4e:	c0 
c0103b4f:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0103b56:	00 
c0103b57:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103b5e:	e8 72 d1 ff ff       	call   c0100cd5 <__panic>

    assert(alloc_page() == NULL);
c0103b63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b6a:	e8 11 0b 00 00       	call   c0104680 <alloc_pages>
c0103b6f:	85 c0                	test   %eax,%eax
c0103b71:	74 24                	je     c0103b97 <basic_check+0x3fb>
c0103b73:	c7 44 24 0c e6 9a 10 	movl   $0xc0109ae6,0xc(%esp)
c0103b7a:	c0 
c0103b7b:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103b82:	c0 
c0103b83:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103b8a:	00 
c0103b8b:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103b92:	e8 3e d1 ff ff       	call   c0100cd5 <__panic>

    free_page(p0);
c0103b97:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b9e:	00 
c0103b9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ba2:	89 04 24             	mov    %eax,(%esp)
c0103ba5:	e8 41 0b 00 00       	call   c01046eb <free_pages>
c0103baa:	c7 45 d8 e0 2a 12 c0 	movl   $0xc0122ae0,-0x28(%ebp)
c0103bb1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103bb4:	8b 40 04             	mov    0x4(%eax),%eax
c0103bb7:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103bba:	0f 94 c0             	sete   %al
c0103bbd:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103bc0:	85 c0                	test   %eax,%eax
c0103bc2:	74 24                	je     c0103be8 <basic_check+0x44c>
c0103bc4:	c7 44 24 0c 08 9b 10 	movl   $0xc0109b08,0xc(%esp)
c0103bcb:	c0 
c0103bcc:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103bd3:	c0 
c0103bd4:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103bdb:	00 
c0103bdc:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103be3:	e8 ed d0 ff ff       	call   c0100cd5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103be8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bef:	e8 8c 0a 00 00       	call   c0104680 <alloc_pages>
c0103bf4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bfa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103bfd:	74 24                	je     c0103c23 <basic_check+0x487>
c0103bff:	c7 44 24 0c 20 9b 10 	movl   $0xc0109b20,0xc(%esp)
c0103c06:	c0 
c0103c07:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103c0e:	c0 
c0103c0f:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0103c16:	00 
c0103c17:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103c1e:	e8 b2 d0 ff ff       	call   c0100cd5 <__panic>
    assert(alloc_page() == NULL);
c0103c23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c2a:	e8 51 0a 00 00       	call   c0104680 <alloc_pages>
c0103c2f:	85 c0                	test   %eax,%eax
c0103c31:	74 24                	je     c0103c57 <basic_check+0x4bb>
c0103c33:	c7 44 24 0c e6 9a 10 	movl   $0xc0109ae6,0xc(%esp)
c0103c3a:	c0 
c0103c3b:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103c42:	c0 
c0103c43:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0103c4a:	00 
c0103c4b:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103c52:	e8 7e d0 ff ff       	call   c0100cd5 <__panic>

    assert(nr_free == 0);
c0103c57:	a1 e8 2a 12 c0       	mov    0xc0122ae8,%eax
c0103c5c:	85 c0                	test   %eax,%eax
c0103c5e:	74 24                	je     c0103c84 <basic_check+0x4e8>
c0103c60:	c7 44 24 0c 39 9b 10 	movl   $0xc0109b39,0xc(%esp)
c0103c67:	c0 
c0103c68:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103c6f:	c0 
c0103c70:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103c77:	00 
c0103c78:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103c7f:	e8 51 d0 ff ff       	call   c0100cd5 <__panic>
    free_list = free_list_store;
c0103c84:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103c87:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103c8a:	a3 e0 2a 12 c0       	mov    %eax,0xc0122ae0
c0103c8f:	89 15 e4 2a 12 c0    	mov    %edx,0xc0122ae4
    nr_free = nr_free_store;
c0103c95:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c98:	a3 e8 2a 12 c0       	mov    %eax,0xc0122ae8

    free_page(p);
c0103c9d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ca4:	00 
c0103ca5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ca8:	89 04 24             	mov    %eax,(%esp)
c0103cab:	e8 3b 0a 00 00       	call   c01046eb <free_pages>
    free_page(p1);
c0103cb0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103cb7:	00 
c0103cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cbb:	89 04 24             	mov    %eax,(%esp)
c0103cbe:	e8 28 0a 00 00       	call   c01046eb <free_pages>
    free_page(p2);
c0103cc3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103cca:	00 
c0103ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cce:	89 04 24             	mov    %eax,(%esp)
c0103cd1:	e8 15 0a 00 00       	call   c01046eb <free_pages>
}
c0103cd6:	c9                   	leave  
c0103cd7:	c3                   	ret    

c0103cd8 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103cd8:	55                   	push   %ebp
c0103cd9:	89 e5                	mov    %esp,%ebp
c0103cdb:	53                   	push   %ebx
c0103cdc:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103ce2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103ce9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103cf0:	c7 45 ec e0 2a 12 c0 	movl   $0xc0122ae0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103cf7:	eb 6b                	jmp    c0103d64 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103cf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cfc:	83 e8 0c             	sub    $0xc,%eax
c0103cff:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103d02:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d05:	83 c0 04             	add    $0x4,%eax
c0103d08:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103d0f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103d12:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103d15:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103d18:	0f a3 10             	bt     %edx,(%eax)
c0103d1b:	19 c0                	sbb    %eax,%eax
c0103d1d:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103d20:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103d24:	0f 95 c0             	setne  %al
c0103d27:	0f b6 c0             	movzbl %al,%eax
c0103d2a:	85 c0                	test   %eax,%eax
c0103d2c:	75 24                	jne    c0103d52 <default_check+0x7a>
c0103d2e:	c7 44 24 0c 46 9b 10 	movl   $0xc0109b46,0xc(%esp)
c0103d35:	c0 
c0103d36:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103d3d:	c0 
c0103d3e:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103d45:	00 
c0103d46:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103d4d:	e8 83 cf ff ff       	call   c0100cd5 <__panic>
        count ++, total += p->property;
c0103d52:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103d56:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d59:	8b 50 08             	mov    0x8(%eax),%edx
c0103d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d5f:	01 d0                	add    %edx,%eax
c0103d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d67:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103d6a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103d6d:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103d70:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d73:	81 7d ec e0 2a 12 c0 	cmpl   $0xc0122ae0,-0x14(%ebp)
c0103d7a:	0f 85 79 ff ff ff    	jne    c0103cf9 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103d80:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103d83:	e8 95 09 00 00       	call   c010471d <nr_free_pages>
c0103d88:	39 c3                	cmp    %eax,%ebx
c0103d8a:	74 24                	je     c0103db0 <default_check+0xd8>
c0103d8c:	c7 44 24 0c 56 9b 10 	movl   $0xc0109b56,0xc(%esp)
c0103d93:	c0 
c0103d94:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103d9b:	c0 
c0103d9c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0103da3:	00 
c0103da4:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103dab:	e8 25 cf ff ff       	call   c0100cd5 <__panic>

    basic_check();
c0103db0:	e8 e7 f9 ff ff       	call   c010379c <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103db5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103dbc:	e8 bf 08 00 00       	call   c0104680 <alloc_pages>
c0103dc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103dc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103dc8:	75 24                	jne    c0103dee <default_check+0x116>
c0103dca:	c7 44 24 0c 6f 9b 10 	movl   $0xc0109b6f,0xc(%esp)
c0103dd1:	c0 
c0103dd2:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103dd9:	c0 
c0103dda:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103de1:	00 
c0103de2:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103de9:	e8 e7 ce ff ff       	call   c0100cd5 <__panic>
    assert(!PageProperty(p0));
c0103dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103df1:	83 c0 04             	add    $0x4,%eax
c0103df4:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103dfb:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103dfe:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103e01:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103e04:	0f a3 10             	bt     %edx,(%eax)
c0103e07:	19 c0                	sbb    %eax,%eax
c0103e09:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103e0c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103e10:	0f 95 c0             	setne  %al
c0103e13:	0f b6 c0             	movzbl %al,%eax
c0103e16:	85 c0                	test   %eax,%eax
c0103e18:	74 24                	je     c0103e3e <default_check+0x166>
c0103e1a:	c7 44 24 0c 7a 9b 10 	movl   $0xc0109b7a,0xc(%esp)
c0103e21:	c0 
c0103e22:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103e29:	c0 
c0103e2a:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0103e31:	00 
c0103e32:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103e39:	e8 97 ce ff ff       	call   c0100cd5 <__panic>

    list_entry_t free_list_store = free_list;
c0103e3e:	a1 e0 2a 12 c0       	mov    0xc0122ae0,%eax
c0103e43:	8b 15 e4 2a 12 c0    	mov    0xc0122ae4,%edx
c0103e49:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103e4c:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103e4f:	c7 45 b4 e0 2a 12 c0 	movl   $0xc0122ae0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103e56:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e59:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e5c:	89 50 04             	mov    %edx,0x4(%eax)
c0103e5f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e62:	8b 50 04             	mov    0x4(%eax),%edx
c0103e65:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e68:	89 10                	mov    %edx,(%eax)
c0103e6a:	c7 45 b0 e0 2a 12 c0 	movl   $0xc0122ae0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103e71:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e74:	8b 40 04             	mov    0x4(%eax),%eax
c0103e77:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103e7a:	0f 94 c0             	sete   %al
c0103e7d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103e80:	85 c0                	test   %eax,%eax
c0103e82:	75 24                	jne    c0103ea8 <default_check+0x1d0>
c0103e84:	c7 44 24 0c cf 9a 10 	movl   $0xc0109acf,0xc(%esp)
c0103e8b:	c0 
c0103e8c:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103e93:	c0 
c0103e94:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0103e9b:	00 
c0103e9c:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103ea3:	e8 2d ce ff ff       	call   c0100cd5 <__panic>
    assert(alloc_page() == NULL);
c0103ea8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103eaf:	e8 cc 07 00 00       	call   c0104680 <alloc_pages>
c0103eb4:	85 c0                	test   %eax,%eax
c0103eb6:	74 24                	je     c0103edc <default_check+0x204>
c0103eb8:	c7 44 24 0c e6 9a 10 	movl   $0xc0109ae6,0xc(%esp)
c0103ebf:	c0 
c0103ec0:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103ec7:	c0 
c0103ec8:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0103ecf:	00 
c0103ed0:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103ed7:	e8 f9 cd ff ff       	call   c0100cd5 <__panic>

    unsigned int nr_free_store = nr_free;
c0103edc:	a1 e8 2a 12 c0       	mov    0xc0122ae8,%eax
c0103ee1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103ee4:	c7 05 e8 2a 12 c0 00 	movl   $0x0,0xc0122ae8
c0103eeb:	00 00 00 

    free_pages(p0 + 2, 3);
c0103eee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ef1:	83 c0 40             	add    $0x40,%eax
c0103ef4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103efb:	00 
c0103efc:	89 04 24             	mov    %eax,(%esp)
c0103eff:	e8 e7 07 00 00       	call   c01046eb <free_pages>
    assert(alloc_pages(4) == NULL);
c0103f04:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103f0b:	e8 70 07 00 00       	call   c0104680 <alloc_pages>
c0103f10:	85 c0                	test   %eax,%eax
c0103f12:	74 24                	je     c0103f38 <default_check+0x260>
c0103f14:	c7 44 24 0c 8c 9b 10 	movl   $0xc0109b8c,0xc(%esp)
c0103f1b:	c0 
c0103f1c:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103f23:	c0 
c0103f24:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0103f2b:	00 
c0103f2c:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103f33:	e8 9d cd ff ff       	call   c0100cd5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103f38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f3b:	83 c0 40             	add    $0x40,%eax
c0103f3e:	83 c0 04             	add    $0x4,%eax
c0103f41:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103f48:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103f4b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f4e:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103f51:	0f a3 10             	bt     %edx,(%eax)
c0103f54:	19 c0                	sbb    %eax,%eax
c0103f56:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103f59:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103f5d:	0f 95 c0             	setne  %al
c0103f60:	0f b6 c0             	movzbl %al,%eax
c0103f63:	85 c0                	test   %eax,%eax
c0103f65:	74 0e                	je     c0103f75 <default_check+0x29d>
c0103f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f6a:	83 c0 40             	add    $0x40,%eax
c0103f6d:	8b 40 08             	mov    0x8(%eax),%eax
c0103f70:	83 f8 03             	cmp    $0x3,%eax
c0103f73:	74 24                	je     c0103f99 <default_check+0x2c1>
c0103f75:	c7 44 24 0c a4 9b 10 	movl   $0xc0109ba4,0xc(%esp)
c0103f7c:	c0 
c0103f7d:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103f84:	c0 
c0103f85:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0103f8c:	00 
c0103f8d:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103f94:	e8 3c cd ff ff       	call   c0100cd5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103f99:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103fa0:	e8 db 06 00 00       	call   c0104680 <alloc_pages>
c0103fa5:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103fa8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103fac:	75 24                	jne    c0103fd2 <default_check+0x2fa>
c0103fae:	c7 44 24 0c d0 9b 10 	movl   $0xc0109bd0,0xc(%esp)
c0103fb5:	c0 
c0103fb6:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103fbd:	c0 
c0103fbe:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0103fc5:	00 
c0103fc6:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0103fcd:	e8 03 cd ff ff       	call   c0100cd5 <__panic>
    assert(alloc_page() == NULL);
c0103fd2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fd9:	e8 a2 06 00 00       	call   c0104680 <alloc_pages>
c0103fde:	85 c0                	test   %eax,%eax
c0103fe0:	74 24                	je     c0104006 <default_check+0x32e>
c0103fe2:	c7 44 24 0c e6 9a 10 	movl   $0xc0109ae6,0xc(%esp)
c0103fe9:	c0 
c0103fea:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0103ff1:	c0 
c0103ff2:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0103ff9:	00 
c0103ffa:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0104001:	e8 cf cc ff ff       	call   c0100cd5 <__panic>
    assert(p0 + 2 == p1);
c0104006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104009:	83 c0 40             	add    $0x40,%eax
c010400c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010400f:	74 24                	je     c0104035 <default_check+0x35d>
c0104011:	c7 44 24 0c ee 9b 10 	movl   $0xc0109bee,0xc(%esp)
c0104018:	c0 
c0104019:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0104020:	c0 
c0104021:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0104028:	00 
c0104029:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0104030:	e8 a0 cc ff ff       	call   c0100cd5 <__panic>

    p2 = p0 + 1;
c0104035:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104038:	83 c0 20             	add    $0x20,%eax
c010403b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010403e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104045:	00 
c0104046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104049:	89 04 24             	mov    %eax,(%esp)
c010404c:	e8 9a 06 00 00       	call   c01046eb <free_pages>
    free_pages(p1, 3);
c0104051:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104058:	00 
c0104059:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010405c:	89 04 24             	mov    %eax,(%esp)
c010405f:	e8 87 06 00 00       	call   c01046eb <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104067:	83 c0 04             	add    $0x4,%eax
c010406a:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104071:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104074:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104077:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010407a:	0f a3 10             	bt     %edx,(%eax)
c010407d:	19 c0                	sbb    %eax,%eax
c010407f:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104082:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104086:	0f 95 c0             	setne  %al
c0104089:	0f b6 c0             	movzbl %al,%eax
c010408c:	85 c0                	test   %eax,%eax
c010408e:	74 0b                	je     c010409b <default_check+0x3c3>
c0104090:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104093:	8b 40 08             	mov    0x8(%eax),%eax
c0104096:	83 f8 01             	cmp    $0x1,%eax
c0104099:	74 24                	je     c01040bf <default_check+0x3e7>
c010409b:	c7 44 24 0c fc 9b 10 	movl   $0xc0109bfc,0xc(%esp)
c01040a2:	c0 
c01040a3:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c01040aa:	c0 
c01040ab:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01040b2:	00 
c01040b3:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c01040ba:	e8 16 cc ff ff       	call   c0100cd5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01040bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040c2:	83 c0 04             	add    $0x4,%eax
c01040c5:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01040cc:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01040cf:	8b 45 90             	mov    -0x70(%ebp),%eax
c01040d2:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01040d5:	0f a3 10             	bt     %edx,(%eax)
c01040d8:	19 c0                	sbb    %eax,%eax
c01040da:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01040dd:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01040e1:	0f 95 c0             	setne  %al
c01040e4:	0f b6 c0             	movzbl %al,%eax
c01040e7:	85 c0                	test   %eax,%eax
c01040e9:	74 0b                	je     c01040f6 <default_check+0x41e>
c01040eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040ee:	8b 40 08             	mov    0x8(%eax),%eax
c01040f1:	83 f8 03             	cmp    $0x3,%eax
c01040f4:	74 24                	je     c010411a <default_check+0x442>
c01040f6:	c7 44 24 0c 24 9c 10 	movl   $0xc0109c24,0xc(%esp)
c01040fd:	c0 
c01040fe:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0104105:	c0 
c0104106:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c010410d:	00 
c010410e:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0104115:	e8 bb cb ff ff       	call   c0100cd5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010411a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104121:	e8 5a 05 00 00       	call   c0104680 <alloc_pages>
c0104126:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104129:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010412c:	83 e8 20             	sub    $0x20,%eax
c010412f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104132:	74 24                	je     c0104158 <default_check+0x480>
c0104134:	c7 44 24 0c 4a 9c 10 	movl   $0xc0109c4a,0xc(%esp)
c010413b:	c0 
c010413c:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0104143:	c0 
c0104144:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c010414b:	00 
c010414c:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0104153:	e8 7d cb ff ff       	call   c0100cd5 <__panic>
    free_page(p0);
c0104158:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010415f:	00 
c0104160:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104163:	89 04 24             	mov    %eax,(%esp)
c0104166:	e8 80 05 00 00       	call   c01046eb <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010416b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104172:	e8 09 05 00 00       	call   c0104680 <alloc_pages>
c0104177:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010417a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010417d:	83 c0 20             	add    $0x20,%eax
c0104180:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104183:	74 24                	je     c01041a9 <default_check+0x4d1>
c0104185:	c7 44 24 0c 68 9c 10 	movl   $0xc0109c68,0xc(%esp)
c010418c:	c0 
c010418d:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0104194:	c0 
c0104195:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c010419c:	00 
c010419d:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c01041a4:	e8 2c cb ff ff       	call   c0100cd5 <__panic>

    free_pages(p0, 2);
c01041a9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01041b0:	00 
c01041b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041b4:	89 04 24             	mov    %eax,(%esp)
c01041b7:	e8 2f 05 00 00       	call   c01046eb <free_pages>
    free_page(p2);
c01041bc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01041c3:	00 
c01041c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041c7:	89 04 24             	mov    %eax,(%esp)
c01041ca:	e8 1c 05 00 00       	call   c01046eb <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01041cf:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01041d6:	e8 a5 04 00 00       	call   c0104680 <alloc_pages>
c01041db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01041e2:	75 24                	jne    c0104208 <default_check+0x530>
c01041e4:	c7 44 24 0c 88 9c 10 	movl   $0xc0109c88,0xc(%esp)
c01041eb:	c0 
c01041ec:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c01041f3:	c0 
c01041f4:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01041fb:	00 
c01041fc:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0104203:	e8 cd ca ff ff       	call   c0100cd5 <__panic>
    assert(alloc_page() == NULL);
c0104208:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010420f:	e8 6c 04 00 00       	call   c0104680 <alloc_pages>
c0104214:	85 c0                	test   %eax,%eax
c0104216:	74 24                	je     c010423c <default_check+0x564>
c0104218:	c7 44 24 0c e6 9a 10 	movl   $0xc0109ae6,0xc(%esp)
c010421f:	c0 
c0104220:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0104227:	c0 
c0104228:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010422f:	00 
c0104230:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0104237:	e8 99 ca ff ff       	call   c0100cd5 <__panic>

    assert(nr_free == 0);
c010423c:	a1 e8 2a 12 c0       	mov    0xc0122ae8,%eax
c0104241:	85 c0                	test   %eax,%eax
c0104243:	74 24                	je     c0104269 <default_check+0x591>
c0104245:	c7 44 24 0c 39 9b 10 	movl   $0xc0109b39,0xc(%esp)
c010424c:	c0 
c010424d:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0104254:	c0 
c0104255:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c010425c:	00 
c010425d:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0104264:	e8 6c ca ff ff       	call   c0100cd5 <__panic>
    nr_free = nr_free_store;
c0104269:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010426c:	a3 e8 2a 12 c0       	mov    %eax,0xc0122ae8

    free_list = free_list_store;
c0104271:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104274:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104277:	a3 e0 2a 12 c0       	mov    %eax,0xc0122ae0
c010427c:	89 15 e4 2a 12 c0    	mov    %edx,0xc0122ae4
    free_pages(p0, 5);
c0104282:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104289:	00 
c010428a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010428d:	89 04 24             	mov    %eax,(%esp)
c0104290:	e8 56 04 00 00       	call   c01046eb <free_pages>

    le = &free_list;
c0104295:	c7 45 ec e0 2a 12 c0 	movl   $0xc0122ae0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010429c:	eb 1d                	jmp    c01042bb <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010429e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042a1:	83 e8 0c             	sub    $0xc,%eax
c01042a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01042a7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01042ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01042ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01042b1:	8b 40 08             	mov    0x8(%eax),%eax
c01042b4:	29 c2                	sub    %eax,%edx
c01042b6:	89 d0                	mov    %edx,%eax
c01042b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01042bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042be:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01042c1:	8b 45 88             	mov    -0x78(%ebp),%eax
c01042c4:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01042c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01042ca:	81 7d ec e0 2a 12 c0 	cmpl   $0xc0122ae0,-0x14(%ebp)
c01042d1:	75 cb                	jne    c010429e <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01042d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042d7:	74 24                	je     c01042fd <default_check+0x625>
c01042d9:	c7 44 24 0c a6 9c 10 	movl   $0xc0109ca6,0xc(%esp)
c01042e0:	c0 
c01042e1:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c01042e8:	c0 
c01042e9:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c01042f0:	00 
c01042f1:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c01042f8:	e8 d8 c9 ff ff       	call   c0100cd5 <__panic>
    assert(total == 0);
c01042fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104301:	74 24                	je     c0104327 <default_check+0x64f>
c0104303:	c7 44 24 0c b1 9c 10 	movl   $0xc0109cb1,0xc(%esp)
c010430a:	c0 
c010430b:	c7 44 24 08 76 99 10 	movl   $0xc0109976,0x8(%esp)
c0104312:	c0 
c0104313:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c010431a:	00 
c010431b:	c7 04 24 8b 99 10 c0 	movl   $0xc010998b,(%esp)
c0104322:	e8 ae c9 ff ff       	call   c0100cd5 <__panic>
}
c0104327:	81 c4 94 00 00 00    	add    $0x94,%esp
c010432d:	5b                   	pop    %ebx
c010432e:	5d                   	pop    %ebp
c010432f:	c3                   	ret    

c0104330 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104330:	55                   	push   %ebp
c0104331:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104333:	8b 55 08             	mov    0x8(%ebp),%edx
c0104336:	a1 f4 2a 12 c0       	mov    0xc0122af4,%eax
c010433b:	29 c2                	sub    %eax,%edx
c010433d:	89 d0                	mov    %edx,%eax
c010433f:	c1 f8 05             	sar    $0x5,%eax
}
c0104342:	5d                   	pop    %ebp
c0104343:	c3                   	ret    

c0104344 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104344:	55                   	push   %ebp
c0104345:	89 e5                	mov    %esp,%ebp
c0104347:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010434a:	8b 45 08             	mov    0x8(%ebp),%eax
c010434d:	89 04 24             	mov    %eax,(%esp)
c0104350:	e8 db ff ff ff       	call   c0104330 <page2ppn>
c0104355:	c1 e0 0c             	shl    $0xc,%eax
}
c0104358:	c9                   	leave  
c0104359:	c3                   	ret    

c010435a <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010435a:	55                   	push   %ebp
c010435b:	89 e5                	mov    %esp,%ebp
c010435d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104360:	8b 45 08             	mov    0x8(%ebp),%eax
c0104363:	c1 e8 0c             	shr    $0xc,%eax
c0104366:	89 c2                	mov    %eax,%edx
c0104368:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c010436d:	39 c2                	cmp    %eax,%edx
c010436f:	72 1c                	jb     c010438d <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104371:	c7 44 24 08 ec 9c 10 	movl   $0xc0109cec,0x8(%esp)
c0104378:	c0 
c0104379:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0104380:	00 
c0104381:	c7 04 24 0b 9d 10 c0 	movl   $0xc0109d0b,(%esp)
c0104388:	e8 48 c9 ff ff       	call   c0100cd5 <__panic>
    }
    return &pages[PPN(pa)];
c010438d:	a1 f4 2a 12 c0       	mov    0xc0122af4,%eax
c0104392:	8b 55 08             	mov    0x8(%ebp),%edx
c0104395:	c1 ea 0c             	shr    $0xc,%edx
c0104398:	c1 e2 05             	shl    $0x5,%edx
c010439b:	01 d0                	add    %edx,%eax
}
c010439d:	c9                   	leave  
c010439e:	c3                   	ret    

c010439f <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010439f:	55                   	push   %ebp
c01043a0:	89 e5                	mov    %esp,%ebp
c01043a2:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01043a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01043a8:	89 04 24             	mov    %eax,(%esp)
c01043ab:	e8 94 ff ff ff       	call   c0104344 <page2pa>
c01043b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043b6:	c1 e8 0c             	shr    $0xc,%eax
c01043b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043bc:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c01043c1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01043c4:	72 23                	jb     c01043e9 <page2kva+0x4a>
c01043c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043cd:	c7 44 24 08 1c 9d 10 	movl   $0xc0109d1c,0x8(%esp)
c01043d4:	c0 
c01043d5:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01043dc:	00 
c01043dd:	c7 04 24 0b 9d 10 c0 	movl   $0xc0109d0b,(%esp)
c01043e4:	e8 ec c8 ff ff       	call   c0100cd5 <__panic>
c01043e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043ec:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01043f1:	c9                   	leave  
c01043f2:	c3                   	ret    

c01043f3 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01043f3:	55                   	push   %ebp
c01043f4:	89 e5                	mov    %esp,%ebp
c01043f6:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01043f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01043fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043ff:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104406:	77 23                	ja     c010442b <kva2page+0x38>
c0104408:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010440b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010440f:	c7 44 24 08 40 9d 10 	movl   $0xc0109d40,0x8(%esp)
c0104416:	c0 
c0104417:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c010441e:	00 
c010441f:	c7 04 24 0b 9d 10 c0 	movl   $0xc0109d0b,(%esp)
c0104426:	e8 aa c8 ff ff       	call   c0100cd5 <__panic>
c010442b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010442e:	05 00 00 00 40       	add    $0x40000000,%eax
c0104433:	89 04 24             	mov    %eax,(%esp)
c0104436:	e8 1f ff ff ff       	call   c010435a <pa2page>
}
c010443b:	c9                   	leave  
c010443c:	c3                   	ret    

c010443d <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c010443d:	55                   	push   %ebp
c010443e:	89 e5                	mov    %esp,%ebp
c0104440:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104443:	8b 45 08             	mov    0x8(%ebp),%eax
c0104446:	83 e0 01             	and    $0x1,%eax
c0104449:	85 c0                	test   %eax,%eax
c010444b:	75 1c                	jne    c0104469 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010444d:	c7 44 24 08 64 9d 10 	movl   $0xc0109d64,0x8(%esp)
c0104454:	c0 
c0104455:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010445c:	00 
c010445d:	c7 04 24 0b 9d 10 c0 	movl   $0xc0109d0b,(%esp)
c0104464:	e8 6c c8 ff ff       	call   c0100cd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104469:	8b 45 08             	mov    0x8(%ebp),%eax
c010446c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104471:	89 04 24             	mov    %eax,(%esp)
c0104474:	e8 e1 fe ff ff       	call   c010435a <pa2page>
}
c0104479:	c9                   	leave  
c010447a:	c3                   	ret    

c010447b <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010447b:	55                   	push   %ebp
c010447c:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010447e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104481:	8b 00                	mov    (%eax),%eax
}
c0104483:	5d                   	pop    %ebp
c0104484:	c3                   	ret    

c0104485 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104485:	55                   	push   %ebp
c0104486:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104488:	8b 45 08             	mov    0x8(%ebp),%eax
c010448b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010448e:	89 10                	mov    %edx,(%eax)
}
c0104490:	5d                   	pop    %ebp
c0104491:	c3                   	ret    

c0104492 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104492:	55                   	push   %ebp
c0104493:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104495:	8b 45 08             	mov    0x8(%ebp),%eax
c0104498:	8b 00                	mov    (%eax),%eax
c010449a:	8d 50 01             	lea    0x1(%eax),%edx
c010449d:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a0:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01044a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a5:	8b 00                	mov    (%eax),%eax
}
c01044a7:	5d                   	pop    %ebp
c01044a8:	c3                   	ret    

c01044a9 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01044a9:	55                   	push   %ebp
c01044aa:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01044ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01044af:	8b 00                	mov    (%eax),%eax
c01044b1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01044b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01044b7:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01044b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01044bc:	8b 00                	mov    (%eax),%eax
}
c01044be:	5d                   	pop    %ebp
c01044bf:	c3                   	ret    

c01044c0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01044c0:	55                   	push   %ebp
c01044c1:	89 e5                	mov    %esp,%ebp
c01044c3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01044c6:	9c                   	pushf  
c01044c7:	58                   	pop    %eax
c01044c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01044cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01044ce:	25 00 02 00 00       	and    $0x200,%eax
c01044d3:	85 c0                	test   %eax,%eax
c01044d5:	74 0c                	je     c01044e3 <__intr_save+0x23>
        intr_disable();
c01044d7:	e8 51 da ff ff       	call   c0101f2d <intr_disable>
        return 1;
c01044dc:	b8 01 00 00 00       	mov    $0x1,%eax
c01044e1:	eb 05                	jmp    c01044e8 <__intr_save+0x28>
    }
    return 0;
c01044e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01044e8:	c9                   	leave  
c01044e9:	c3                   	ret    

c01044ea <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01044ea:	55                   	push   %ebp
c01044eb:	89 e5                	mov    %esp,%ebp
c01044ed:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01044f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01044f4:	74 05                	je     c01044fb <__intr_restore+0x11>
        intr_enable();
c01044f6:	e8 2c da ff ff       	call   c0101f27 <intr_enable>
    }
}
c01044fb:	c9                   	leave  
c01044fc:	c3                   	ret    

c01044fd <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01044fd:	55                   	push   %ebp
c01044fe:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104500:	8b 45 08             	mov    0x8(%ebp),%eax
c0104503:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104506:	b8 23 00 00 00       	mov    $0x23,%eax
c010450b:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c010450d:	b8 23 00 00 00       	mov    $0x23,%eax
c0104512:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104514:	b8 10 00 00 00       	mov    $0x10,%eax
c0104519:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c010451b:	b8 10 00 00 00       	mov    $0x10,%eax
c0104520:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104522:	b8 10 00 00 00       	mov    $0x10,%eax
c0104527:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104529:	ea 30 45 10 c0 08 00 	ljmp   $0x8,$0xc0104530
}
c0104530:	5d                   	pop    %ebp
c0104531:	c3                   	ret    

c0104532 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104532:	55                   	push   %ebp
c0104533:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104535:	8b 45 08             	mov    0x8(%ebp),%eax
c0104538:	a3 64 2a 12 c0       	mov    %eax,0xc0122a64
}
c010453d:	5d                   	pop    %ebp
c010453e:	c3                   	ret    

c010453f <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c010453f:	55                   	push   %ebp
c0104540:	89 e5                	mov    %esp,%ebp
c0104542:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104545:	b8 00 10 12 c0       	mov    $0xc0121000,%eax
c010454a:	89 04 24             	mov    %eax,(%esp)
c010454d:	e8 e0 ff ff ff       	call   c0104532 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104552:	66 c7 05 68 2a 12 c0 	movw   $0x10,0xc0122a68
c0104559:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c010455b:	66 c7 05 28 1a 12 c0 	movw   $0x68,0xc0121a28
c0104562:	68 00 
c0104564:	b8 60 2a 12 c0       	mov    $0xc0122a60,%eax
c0104569:	66 a3 2a 1a 12 c0    	mov    %ax,0xc0121a2a
c010456f:	b8 60 2a 12 c0       	mov    $0xc0122a60,%eax
c0104574:	c1 e8 10             	shr    $0x10,%eax
c0104577:	a2 2c 1a 12 c0       	mov    %al,0xc0121a2c
c010457c:	0f b6 05 2d 1a 12 c0 	movzbl 0xc0121a2d,%eax
c0104583:	83 e0 f0             	and    $0xfffffff0,%eax
c0104586:	83 c8 09             	or     $0x9,%eax
c0104589:	a2 2d 1a 12 c0       	mov    %al,0xc0121a2d
c010458e:	0f b6 05 2d 1a 12 c0 	movzbl 0xc0121a2d,%eax
c0104595:	83 e0 ef             	and    $0xffffffef,%eax
c0104598:	a2 2d 1a 12 c0       	mov    %al,0xc0121a2d
c010459d:	0f b6 05 2d 1a 12 c0 	movzbl 0xc0121a2d,%eax
c01045a4:	83 e0 9f             	and    $0xffffff9f,%eax
c01045a7:	a2 2d 1a 12 c0       	mov    %al,0xc0121a2d
c01045ac:	0f b6 05 2d 1a 12 c0 	movzbl 0xc0121a2d,%eax
c01045b3:	83 c8 80             	or     $0xffffff80,%eax
c01045b6:	a2 2d 1a 12 c0       	mov    %al,0xc0121a2d
c01045bb:	0f b6 05 2e 1a 12 c0 	movzbl 0xc0121a2e,%eax
c01045c2:	83 e0 f0             	and    $0xfffffff0,%eax
c01045c5:	a2 2e 1a 12 c0       	mov    %al,0xc0121a2e
c01045ca:	0f b6 05 2e 1a 12 c0 	movzbl 0xc0121a2e,%eax
c01045d1:	83 e0 ef             	and    $0xffffffef,%eax
c01045d4:	a2 2e 1a 12 c0       	mov    %al,0xc0121a2e
c01045d9:	0f b6 05 2e 1a 12 c0 	movzbl 0xc0121a2e,%eax
c01045e0:	83 e0 df             	and    $0xffffffdf,%eax
c01045e3:	a2 2e 1a 12 c0       	mov    %al,0xc0121a2e
c01045e8:	0f b6 05 2e 1a 12 c0 	movzbl 0xc0121a2e,%eax
c01045ef:	83 c8 40             	or     $0x40,%eax
c01045f2:	a2 2e 1a 12 c0       	mov    %al,0xc0121a2e
c01045f7:	0f b6 05 2e 1a 12 c0 	movzbl 0xc0121a2e,%eax
c01045fe:	83 e0 7f             	and    $0x7f,%eax
c0104601:	a2 2e 1a 12 c0       	mov    %al,0xc0121a2e
c0104606:	b8 60 2a 12 c0       	mov    $0xc0122a60,%eax
c010460b:	c1 e8 18             	shr    $0x18,%eax
c010460e:	a2 2f 1a 12 c0       	mov    %al,0xc0121a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104613:	c7 04 24 30 1a 12 c0 	movl   $0xc0121a30,(%esp)
c010461a:	e8 de fe ff ff       	call   c01044fd <lgdt>
c010461f:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104625:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104629:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c010462c:	c9                   	leave  
c010462d:	c3                   	ret    

c010462e <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c010462e:	55                   	push   %ebp
c010462f:	89 e5                	mov    %esp,%ebp
c0104631:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104634:	c7 05 ec 2a 12 c0 d0 	movl   $0xc0109cd0,0xc0122aec
c010463b:	9c 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c010463e:	a1 ec 2a 12 c0       	mov    0xc0122aec,%eax
c0104643:	8b 00                	mov    (%eax),%eax
c0104645:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104649:	c7 04 24 90 9d 10 c0 	movl   $0xc0109d90,(%esp)
c0104650:	e8 f6 bc ff ff       	call   c010034b <cprintf>
    pmm_manager->init();
c0104655:	a1 ec 2a 12 c0       	mov    0xc0122aec,%eax
c010465a:	8b 40 04             	mov    0x4(%eax),%eax
c010465d:	ff d0                	call   *%eax
}
c010465f:	c9                   	leave  
c0104660:	c3                   	ret    

c0104661 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104661:	55                   	push   %ebp
c0104662:	89 e5                	mov    %esp,%ebp
c0104664:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104667:	a1 ec 2a 12 c0       	mov    0xc0122aec,%eax
c010466c:	8b 40 08             	mov    0x8(%eax),%eax
c010466f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104672:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104676:	8b 55 08             	mov    0x8(%ebp),%edx
c0104679:	89 14 24             	mov    %edx,(%esp)
c010467c:	ff d0                	call   *%eax
}
c010467e:	c9                   	leave  
c010467f:	c3                   	ret    

c0104680 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104680:	55                   	push   %ebp
c0104681:	89 e5                	mov    %esp,%ebp
c0104683:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104686:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c010468d:	e8 2e fe ff ff       	call   c01044c0 <__intr_save>
c0104692:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104695:	a1 ec 2a 12 c0       	mov    0xc0122aec,%eax
c010469a:	8b 40 0c             	mov    0xc(%eax),%eax
c010469d:	8b 55 08             	mov    0x8(%ebp),%edx
c01046a0:	89 14 24             	mov    %edx,(%esp)
c01046a3:	ff d0                	call   *%eax
c01046a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c01046a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046ab:	89 04 24             	mov    %eax,(%esp)
c01046ae:	e8 37 fe ff ff       	call   c01044ea <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c01046b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046b7:	75 2d                	jne    c01046e6 <alloc_pages+0x66>
c01046b9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c01046bd:	77 27                	ja     c01046e6 <alloc_pages+0x66>
c01046bf:	a1 cc 2a 12 c0       	mov    0xc0122acc,%eax
c01046c4:	85 c0                	test   %eax,%eax
c01046c6:	74 1e                	je     c01046e6 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c01046c8:	8b 55 08             	mov    0x8(%ebp),%edx
c01046cb:	a1 cc 2b 12 c0       	mov    0xc0122bcc,%eax
c01046d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046d7:	00 
c01046d8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01046dc:	89 04 24             	mov    %eax,(%esp)
c01046df:	e8 9e 1a 00 00       	call   c0106182 <swap_out>
    }
c01046e4:	eb a7                	jmp    c010468d <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c01046e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01046e9:	c9                   	leave  
c01046ea:	c3                   	ret    

c01046eb <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c01046eb:	55                   	push   %ebp
c01046ec:	89 e5                	mov    %esp,%ebp
c01046ee:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01046f1:	e8 ca fd ff ff       	call   c01044c0 <__intr_save>
c01046f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01046f9:	a1 ec 2a 12 c0       	mov    0xc0122aec,%eax
c01046fe:	8b 40 10             	mov    0x10(%eax),%eax
c0104701:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104704:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104708:	8b 55 08             	mov    0x8(%ebp),%edx
c010470b:	89 14 24             	mov    %edx,(%esp)
c010470e:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104710:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104713:	89 04 24             	mov    %eax,(%esp)
c0104716:	e8 cf fd ff ff       	call   c01044ea <__intr_restore>
}
c010471b:	c9                   	leave  
c010471c:	c3                   	ret    

c010471d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c010471d:	55                   	push   %ebp
c010471e:	89 e5                	mov    %esp,%ebp
c0104720:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104723:	e8 98 fd ff ff       	call   c01044c0 <__intr_save>
c0104728:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c010472b:	a1 ec 2a 12 c0       	mov    0xc0122aec,%eax
c0104730:	8b 40 14             	mov    0x14(%eax),%eax
c0104733:	ff d0                	call   *%eax
c0104735:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104738:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010473b:	89 04 24             	mov    %eax,(%esp)
c010473e:	e8 a7 fd ff ff       	call   c01044ea <__intr_restore>
    return ret;
c0104743:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104746:	c9                   	leave  
c0104747:	c3                   	ret    

c0104748 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104748:	55                   	push   %ebp
c0104749:	89 e5                	mov    %esp,%ebp
c010474b:	57                   	push   %edi
c010474c:	56                   	push   %esi
c010474d:	53                   	push   %ebx
c010474e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104754:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c010475b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104762:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104769:	c7 04 24 a7 9d 10 c0 	movl   $0xc0109da7,(%esp)
c0104770:	e8 d6 bb ff ff       	call   c010034b <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104775:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010477c:	e9 15 01 00 00       	jmp    c0104896 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104781:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104784:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104787:	89 d0                	mov    %edx,%eax
c0104789:	c1 e0 02             	shl    $0x2,%eax
c010478c:	01 d0                	add    %edx,%eax
c010478e:	c1 e0 02             	shl    $0x2,%eax
c0104791:	01 c8                	add    %ecx,%eax
c0104793:	8b 50 08             	mov    0x8(%eax),%edx
c0104796:	8b 40 04             	mov    0x4(%eax),%eax
c0104799:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010479c:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010479f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01047a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047a5:	89 d0                	mov    %edx,%eax
c01047a7:	c1 e0 02             	shl    $0x2,%eax
c01047aa:	01 d0                	add    %edx,%eax
c01047ac:	c1 e0 02             	shl    $0x2,%eax
c01047af:	01 c8                	add    %ecx,%eax
c01047b1:	8b 48 0c             	mov    0xc(%eax),%ecx
c01047b4:	8b 58 10             	mov    0x10(%eax),%ebx
c01047b7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01047ba:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01047bd:	01 c8                	add    %ecx,%eax
c01047bf:	11 da                	adc    %ebx,%edx
c01047c1:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01047c4:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01047c7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01047ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047cd:	89 d0                	mov    %edx,%eax
c01047cf:	c1 e0 02             	shl    $0x2,%eax
c01047d2:	01 d0                	add    %edx,%eax
c01047d4:	c1 e0 02             	shl    $0x2,%eax
c01047d7:	01 c8                	add    %ecx,%eax
c01047d9:	83 c0 14             	add    $0x14,%eax
c01047dc:	8b 00                	mov    (%eax),%eax
c01047de:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c01047e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01047e7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01047ea:	83 c0 ff             	add    $0xffffffff,%eax
c01047ed:	83 d2 ff             	adc    $0xffffffff,%edx
c01047f0:	89 c6                	mov    %eax,%esi
c01047f2:	89 d7                	mov    %edx,%edi
c01047f4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01047f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047fa:	89 d0                	mov    %edx,%eax
c01047fc:	c1 e0 02             	shl    $0x2,%eax
c01047ff:	01 d0                	add    %edx,%eax
c0104801:	c1 e0 02             	shl    $0x2,%eax
c0104804:	01 c8                	add    %ecx,%eax
c0104806:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104809:	8b 58 10             	mov    0x10(%eax),%ebx
c010480c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104812:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104816:	89 74 24 14          	mov    %esi,0x14(%esp)
c010481a:	89 7c 24 18          	mov    %edi,0x18(%esp)
c010481e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104821:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104824:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104828:	89 54 24 10          	mov    %edx,0x10(%esp)
c010482c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104830:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104834:	c7 04 24 b4 9d 10 c0 	movl   $0xc0109db4,(%esp)
c010483b:	e8 0b bb ff ff       	call   c010034b <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104840:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104843:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104846:	89 d0                	mov    %edx,%eax
c0104848:	c1 e0 02             	shl    $0x2,%eax
c010484b:	01 d0                	add    %edx,%eax
c010484d:	c1 e0 02             	shl    $0x2,%eax
c0104850:	01 c8                	add    %ecx,%eax
c0104852:	83 c0 14             	add    $0x14,%eax
c0104855:	8b 00                	mov    (%eax),%eax
c0104857:	83 f8 01             	cmp    $0x1,%eax
c010485a:	75 36                	jne    c0104892 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c010485c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010485f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104862:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104865:	77 2b                	ja     c0104892 <page_init+0x14a>
c0104867:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010486a:	72 05                	jb     c0104871 <page_init+0x129>
c010486c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c010486f:	73 21                	jae    c0104892 <page_init+0x14a>
c0104871:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104875:	77 1b                	ja     c0104892 <page_init+0x14a>
c0104877:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010487b:	72 09                	jb     c0104886 <page_init+0x13e>
c010487d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104884:	77 0c                	ja     c0104892 <page_init+0x14a>
                maxpa = end;
c0104886:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104889:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010488c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010488f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104892:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104896:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104899:	8b 00                	mov    (%eax),%eax
c010489b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010489e:	0f 8f dd fe ff ff    	jg     c0104781 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01048a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01048a8:	72 1d                	jb     c01048c7 <page_init+0x17f>
c01048aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01048ae:	77 09                	ja     c01048b9 <page_init+0x171>
c01048b0:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01048b7:	76 0e                	jbe    c01048c7 <page_init+0x17f>
        maxpa = KMEMSIZE;
c01048b9:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01048c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01048c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01048ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01048cd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01048d1:	c1 ea 0c             	shr    $0xc,%edx
c01048d4:	a3 40 2a 12 c0       	mov    %eax,0xc0122a40
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01048d9:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01048e0:	b8 d0 2b 12 c0       	mov    $0xc0122bd0,%eax
c01048e5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01048e8:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01048eb:	01 d0                	add    %edx,%eax
c01048ed:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01048f0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01048f3:	ba 00 00 00 00       	mov    $0x0,%edx
c01048f8:	f7 75 ac             	divl   -0x54(%ebp)
c01048fb:	89 d0                	mov    %edx,%eax
c01048fd:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104900:	29 c2                	sub    %eax,%edx
c0104902:	89 d0                	mov    %edx,%eax
c0104904:	a3 f4 2a 12 c0       	mov    %eax,0xc0122af4

    for (i = 0; i < npage; i ++) {
c0104909:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104910:	eb 27                	jmp    c0104939 <page_init+0x1f1>
        SetPageReserved(pages + i);
c0104912:	a1 f4 2a 12 c0       	mov    0xc0122af4,%eax
c0104917:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010491a:	c1 e2 05             	shl    $0x5,%edx
c010491d:	01 d0                	add    %edx,%eax
c010491f:	83 c0 04             	add    $0x4,%eax
c0104922:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104929:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010492c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010492f:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104932:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0104935:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104939:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010493c:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c0104941:	39 c2                	cmp    %eax,%edx
c0104943:	72 cd                	jb     c0104912 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104945:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c010494a:	c1 e0 05             	shl    $0x5,%eax
c010494d:	89 c2                	mov    %eax,%edx
c010494f:	a1 f4 2a 12 c0       	mov    0xc0122af4,%eax
c0104954:	01 d0                	add    %edx,%eax
c0104956:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104959:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104960:	77 23                	ja     c0104985 <page_init+0x23d>
c0104962:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104965:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104969:	c7 44 24 08 40 9d 10 	movl   $0xc0109d40,0x8(%esp)
c0104970:	c0 
c0104971:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0104978:	00 
c0104979:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0104980:	e8 50 c3 ff ff       	call   c0100cd5 <__panic>
c0104985:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104988:	05 00 00 00 40       	add    $0x40000000,%eax
c010498d:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104990:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104997:	e9 74 01 00 00       	jmp    c0104b10 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010499c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010499f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049a2:	89 d0                	mov    %edx,%eax
c01049a4:	c1 e0 02             	shl    $0x2,%eax
c01049a7:	01 d0                	add    %edx,%eax
c01049a9:	c1 e0 02             	shl    $0x2,%eax
c01049ac:	01 c8                	add    %ecx,%eax
c01049ae:	8b 50 08             	mov    0x8(%eax),%edx
c01049b1:	8b 40 04             	mov    0x4(%eax),%eax
c01049b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01049b7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01049ba:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01049bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049c0:	89 d0                	mov    %edx,%eax
c01049c2:	c1 e0 02             	shl    $0x2,%eax
c01049c5:	01 d0                	add    %edx,%eax
c01049c7:	c1 e0 02             	shl    $0x2,%eax
c01049ca:	01 c8                	add    %ecx,%eax
c01049cc:	8b 48 0c             	mov    0xc(%eax),%ecx
c01049cf:	8b 58 10             	mov    0x10(%eax),%ebx
c01049d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01049d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01049d8:	01 c8                	add    %ecx,%eax
c01049da:	11 da                	adc    %ebx,%edx
c01049dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01049df:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01049e2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01049e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049e8:	89 d0                	mov    %edx,%eax
c01049ea:	c1 e0 02             	shl    $0x2,%eax
c01049ed:	01 d0                	add    %edx,%eax
c01049ef:	c1 e0 02             	shl    $0x2,%eax
c01049f2:	01 c8                	add    %ecx,%eax
c01049f4:	83 c0 14             	add    $0x14,%eax
c01049f7:	8b 00                	mov    (%eax),%eax
c01049f9:	83 f8 01             	cmp    $0x1,%eax
c01049fc:	0f 85 0a 01 00 00    	jne    c0104b0c <page_init+0x3c4>
            if (begin < freemem) {
c0104a02:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104a05:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a0a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104a0d:	72 17                	jb     c0104a26 <page_init+0x2de>
c0104a0f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104a12:	77 05                	ja     c0104a19 <page_init+0x2d1>
c0104a14:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104a17:	76 0d                	jbe    c0104a26 <page_init+0x2de>
                begin = freemem;
c0104a19:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104a1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a1f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104a26:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104a2a:	72 1d                	jb     c0104a49 <page_init+0x301>
c0104a2c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104a30:	77 09                	ja     c0104a3b <page_init+0x2f3>
c0104a32:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104a39:	76 0e                	jbe    c0104a49 <page_init+0x301>
                end = KMEMSIZE;
c0104a3b:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104a42:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104a49:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a4c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a4f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104a52:	0f 87 b4 00 00 00    	ja     c0104b0c <page_init+0x3c4>
c0104a58:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104a5b:	72 09                	jb     c0104a66 <page_init+0x31e>
c0104a5d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104a60:	0f 83 a6 00 00 00    	jae    c0104b0c <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0104a66:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104a6d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104a70:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104a73:	01 d0                	add    %edx,%eax
c0104a75:	83 e8 01             	sub    $0x1,%eax
c0104a78:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104a7b:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104a7e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a83:	f7 75 9c             	divl   -0x64(%ebp)
c0104a86:	89 d0                	mov    %edx,%eax
c0104a88:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104a8b:	29 c2                	sub    %eax,%edx
c0104a8d:	89 d0                	mov    %edx,%eax
c0104a8f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a97:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104a9a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104a9d:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104aa0:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104aa3:	ba 00 00 00 00       	mov    $0x0,%edx
c0104aa8:	89 c7                	mov    %eax,%edi
c0104aaa:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104ab0:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104ab3:	89 d0                	mov    %edx,%eax
c0104ab5:	83 e0 00             	and    $0x0,%eax
c0104ab8:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104abb:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104abe:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104ac1:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104ac4:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104ac7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104aca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104acd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104ad0:	77 3a                	ja     c0104b0c <page_init+0x3c4>
c0104ad2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104ad5:	72 05                	jb     c0104adc <page_init+0x394>
c0104ad7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104ada:	73 30                	jae    c0104b0c <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104adc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104adf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104ae2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104ae5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104ae8:	29 c8                	sub    %ecx,%eax
c0104aea:	19 da                	sbb    %ebx,%edx
c0104aec:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104af0:	c1 ea 0c             	shr    $0xc,%edx
c0104af3:	89 c3                	mov    %eax,%ebx
c0104af5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104af8:	89 04 24             	mov    %eax,(%esp)
c0104afb:	e8 5a f8 ff ff       	call   c010435a <pa2page>
c0104b00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104b04:	89 04 24             	mov    %eax,(%esp)
c0104b07:	e8 55 fb ff ff       	call   c0104661 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104b0c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104b10:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104b13:	8b 00                	mov    (%eax),%eax
c0104b15:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104b18:	0f 8f 7e fe ff ff    	jg     c010499c <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104b1e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104b24:	5b                   	pop    %ebx
c0104b25:	5e                   	pop    %esi
c0104b26:	5f                   	pop    %edi
c0104b27:	5d                   	pop    %ebp
c0104b28:	c3                   	ret    

c0104b29 <enable_paging>:

static void
enable_paging(void) {
c0104b29:	55                   	push   %ebp
c0104b2a:	89 e5                	mov    %esp,%ebp
c0104b2c:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104b2f:	a1 f0 2a 12 c0       	mov    0xc0122af0,%eax
c0104b34:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104b37:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104b3a:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104b3d:	0f 20 c0             	mov    %cr0,%eax
c0104b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104b43:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104b46:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104b49:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104b50:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b5d:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104b60:	c9                   	leave  
c0104b61:	c3                   	ret    

c0104b62 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104b62:	55                   	push   %ebp
c0104b63:	89 e5                	mov    %esp,%ebp
c0104b65:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104b68:	8b 45 14             	mov    0x14(%ebp),%eax
c0104b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104b6e:	31 d0                	xor    %edx,%eax
c0104b70:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104b75:	85 c0                	test   %eax,%eax
c0104b77:	74 24                	je     c0104b9d <boot_map_segment+0x3b>
c0104b79:	c7 44 24 0c f2 9d 10 	movl   $0xc0109df2,0xc(%esp)
c0104b80:	c0 
c0104b81:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0104b88:	c0 
c0104b89:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104b90:	00 
c0104b91:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0104b98:	e8 38 c1 ff ff       	call   c0100cd5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104b9d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ba7:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104bac:	89 c2                	mov    %eax,%edx
c0104bae:	8b 45 10             	mov    0x10(%ebp),%eax
c0104bb1:	01 c2                	add    %eax,%edx
c0104bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bb6:	01 d0                	add    %edx,%eax
c0104bb8:	83 e8 01             	sub    $0x1,%eax
c0104bbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bc1:	ba 00 00 00 00       	mov    $0x0,%edx
c0104bc6:	f7 75 f0             	divl   -0x10(%ebp)
c0104bc9:	89 d0                	mov    %edx,%eax
c0104bcb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104bce:	29 c2                	sub    %eax,%edx
c0104bd0:	89 d0                	mov    %edx,%eax
c0104bd2:	c1 e8 0c             	shr    $0xc,%eax
c0104bd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104bdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104bde:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104be1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104be6:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104be9:	8b 45 14             	mov    0x14(%ebp),%eax
c0104bec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104bef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bf2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104bf7:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104bfa:	eb 6b                	jmp    c0104c67 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104bfc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104c03:	00 
c0104c04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104c0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c0e:	89 04 24             	mov    %eax,(%esp)
c0104c11:	e8 cc 01 00 00       	call   c0104de2 <get_pte>
c0104c16:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104c19:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104c1d:	75 24                	jne    c0104c43 <boot_map_segment+0xe1>
c0104c1f:	c7 44 24 0c 1e 9e 10 	movl   $0xc0109e1e,0xc(%esp)
c0104c26:	c0 
c0104c27:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0104c2e:	c0 
c0104c2f:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0104c36:	00 
c0104c37:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0104c3e:	e8 92 c0 ff ff       	call   c0100cd5 <__panic>
        *ptep = pa | PTE_P | perm;
c0104c43:	8b 45 18             	mov    0x18(%ebp),%eax
c0104c46:	8b 55 14             	mov    0x14(%ebp),%edx
c0104c49:	09 d0                	or     %edx,%eax
c0104c4b:	83 c8 01             	or     $0x1,%eax
c0104c4e:	89 c2                	mov    %eax,%edx
c0104c50:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c53:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104c55:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104c59:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104c60:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104c67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c6b:	75 8f                	jne    c0104bfc <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104c6d:	c9                   	leave  
c0104c6e:	c3                   	ret    

c0104c6f <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104c6f:	55                   	push   %ebp
c0104c70:	89 e5                	mov    %esp,%ebp
c0104c72:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104c75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c7c:	e8 ff f9 ff ff       	call   c0104680 <alloc_pages>
c0104c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104c84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c88:	75 1c                	jne    c0104ca6 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104c8a:	c7 44 24 08 2b 9e 10 	movl   $0xc0109e2b,0x8(%esp)
c0104c91:	c0 
c0104c92:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104c99:	00 
c0104c9a:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0104ca1:	e8 2f c0 ff ff       	call   c0100cd5 <__panic>
    }
    return page2kva(p);
c0104ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ca9:	89 04 24             	mov    %eax,(%esp)
c0104cac:	e8 ee f6 ff ff       	call   c010439f <page2kva>
}
c0104cb1:	c9                   	leave  
c0104cb2:	c3                   	ret    

c0104cb3 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104cb3:	55                   	push   %ebp
c0104cb4:	89 e5                	mov    %esp,%ebp
c0104cb6:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104cb9:	e8 70 f9 ff ff       	call   c010462e <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104cbe:	e8 85 fa ff ff       	call   c0104748 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104cc3:	e8 38 05 00 00       	call   c0105200 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104cc8:	e8 a2 ff ff ff       	call   c0104c6f <boot_alloc_page>
c0104ccd:	a3 44 2a 12 c0       	mov    %eax,0xc0122a44
    memset(boot_pgdir, 0, PGSIZE);
c0104cd2:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0104cd7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104cde:	00 
c0104cdf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ce6:	00 
c0104ce7:	89 04 24             	mov    %eax,(%esp)
c0104cea:	e8 77 42 00 00       	call   c0108f66 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104cef:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0104cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104cf7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104cfe:	77 23                	ja     c0104d23 <pmm_init+0x70>
c0104d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d03:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d07:	c7 44 24 08 40 9d 10 	movl   $0xc0109d40,0x8(%esp)
c0104d0e:	c0 
c0104d0f:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104d16:	00 
c0104d17:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0104d1e:	e8 b2 bf ff ff       	call   c0100cd5 <__panic>
c0104d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d26:	05 00 00 00 40       	add    $0x40000000,%eax
c0104d2b:	a3 f0 2a 12 c0       	mov    %eax,0xc0122af0

    check_pgdir();
c0104d30:	e8 e9 04 00 00       	call   c010521e <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104d35:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0104d3a:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104d40:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0104d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d48:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104d4f:	77 23                	ja     c0104d74 <pmm_init+0xc1>
c0104d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d54:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d58:	c7 44 24 08 40 9d 10 	movl   $0xc0109d40,0x8(%esp)
c0104d5f:	c0 
c0104d60:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0104d67:	00 
c0104d68:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0104d6f:	e8 61 bf ff ff       	call   c0100cd5 <__panic>
c0104d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d77:	05 00 00 00 40       	add    $0x40000000,%eax
c0104d7c:	83 c8 03             	or     $0x3,%eax
c0104d7f:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104d81:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0104d86:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104d8d:	00 
c0104d8e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104d95:	00 
c0104d96:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104d9d:	38 
c0104d9e:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104da5:	c0 
c0104da6:	89 04 24             	mov    %eax,(%esp)
c0104da9:	e8 b4 fd ff ff       	call   c0104b62 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104dae:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0104db3:	8b 15 44 2a 12 c0    	mov    0xc0122a44,%edx
c0104db9:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104dbf:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104dc1:	e8 63 fd ff ff       	call   c0104b29 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104dc6:	e8 74 f7 ff ff       	call   c010453f <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104dcb:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0104dd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104dd6:	e8 de 0a 00 00       	call   c01058b9 <check_boot_pgdir>

    print_pgdir();
c0104ddb:	e8 6b 0f 00 00       	call   c0105d4b <print_pgdir>

}
c0104de0:	c9                   	leave  
c0104de1:	c3                   	ret    

c0104de2 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104de2:	55                   	push   %ebp
c0104de3:	89 e5                	mov    %esp,%ebp
c0104de5:	83 ec 38             	sub    $0x38,%esp
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */

	// 获取页目录表（一级页表）
	pde_t *pdep = &pgdir[PDX(la)];   // (1) find page directory entry
c0104de8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104deb:	c1 e8 16             	shr    $0x16,%eax
c0104dee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104df5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104df8:	01 d0                	add    %edx,%eax
c0104dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// 页表、页目录表不存在
	if (!(PTE_P & *pdep)) {              // (2) check if entry is not present
c0104dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e00:	8b 00                	mov    (%eax),%eax
c0104e02:	83 e0 01             	and    $0x1,%eax
c0104e05:	85 c0                	test   %eax,%eax
c0104e07:	0f 85 b6 00 00 00    	jne    c0104ec3 <get_pte+0xe1>
		struct Page *page = NULL;
c0104e0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		// 如果不需要create或者alloc_page失败
		if(!create || (page = alloc_page()) == NULL) {				  // (3) check if creating is needed, then alloc page for page table
c0104e14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104e18:	74 15                	je     c0104e2f <get_pte+0x4d>
c0104e1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e21:	e8 5a f8 ff ff       	call   c0104680 <alloc_pages>
c0104e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e2d:	75 0a                	jne    c0104e39 <get_pte+0x57>
			return NULL;
c0104e2f:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e34:	e9 e6 00 00 00       	jmp    c0104f1f <get_pte+0x13d>
		}                  // CAUTION: this page is used for page table, not for common data page
		// 到这里，如果需要create的话，就已经执行过alloc了
		// 引用数+1
		set_page_ref(page,1);					// (4) set page reference
c0104e39:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e40:	00 
c0104e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e44:	89 04 24             	mov    %eax,(%esp)
c0104e47:	e8 39 f6 ff ff       	call   c0104485 <set_page_ref>
		// 获得线性地址
		uintptr_t pa = page2pa(page); 			// (5) get linear address of page
c0104e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e4f:	89 04 24             	mov    %eax,(%esp)
c0104e52:	e8 ed f4 ff ff       	call   c0104344 <page2pa>
c0104e57:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// If you need to visit a physical address, please use KADDR()
		// KADDR(pa)将物理地址转换为内核虚拟地址，第二个参数将这一页清空，第三个参数是4096也就是一页的大小
		memset(KADDR(pa), 0, PGSIZE);      		// (6) clear page content using memset
c0104e5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e63:	c1 e8 0c             	shr    $0xc,%eax
c0104e66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e69:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c0104e6e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104e71:	72 23                	jb     c0104e96 <get_pte+0xb4>
c0104e73:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e76:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e7a:	c7 44 24 08 1c 9d 10 	movl   $0xc0109d1c,0x8(%esp)
c0104e81:	c0 
c0104e82:	c7 44 24 04 91 01 00 	movl   $0x191,0x4(%esp)
c0104e89:	00 
c0104e8a:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0104e91:	e8 3f be ff ff       	call   c0100cd5 <__panic>
c0104e96:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e99:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e9e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104ea5:	00 
c0104ea6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ead:	00 
c0104eae:	89 04 24             	mov    %eax,(%esp)
c0104eb1:	e8 b0 40 00 00       	call   c0108f66 <memset>
		// 页目录项内容 = (页表起始物理地址 &0x0FFF) | PTE_U | PTE_W | PTE_P
		*pdep = pa | PTE_U | PTE_W | PTE_P;		// (7) set page directory entry's permission
c0104eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104eb9:	83 c8 07             	or     $0x7,%eax
c0104ebc:	89 c2                	mov    %eax,%edx
c0104ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ec1:	89 10                	mov    %edx,(%eax)
	}
	// 返回pte_t *，页表的地址
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ec6:	8b 00                	mov    (%eax),%eax
c0104ec8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ecd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ed3:	c1 e8 0c             	shr    $0xc,%eax
c0104ed6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104ed9:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c0104ede:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104ee1:	72 23                	jb     c0104f06 <get_pte+0x124>
c0104ee3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ee6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104eea:	c7 44 24 08 1c 9d 10 	movl   $0xc0109d1c,0x8(%esp)
c0104ef1:	c0 
c0104ef2:	c7 44 24 04 96 01 00 	movl   $0x196,0x4(%esp)
c0104ef9:	00 
c0104efa:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0104f01:	e8 cf bd ff ff       	call   c0100cd5 <__panic>
c0104f06:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f09:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104f11:	c1 ea 0c             	shr    $0xc,%edx
c0104f14:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104f1a:	c1 e2 02             	shl    $0x2,%edx
c0104f1d:	01 d0                	add    %edx,%eax
	// 不用再返回NULL了，前面如果不需要create或者alloc失败就会返回NULL
	//return NULL;          // (8) return page table entry


}
c0104f1f:	c9                   	leave  
c0104f20:	c3                   	ret    

c0104f21 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104f21:	55                   	push   %ebp
c0104f22:	89 e5                	mov    %esp,%ebp
c0104f24:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104f27:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f2e:	00 
c0104f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f36:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f39:	89 04 24             	mov    %eax,(%esp)
c0104f3c:	e8 a1 fe ff ff       	call   c0104de2 <get_pte>
c0104f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104f44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104f48:	74 08                	je     c0104f52 <get_page+0x31>
        *ptep_store = ptep;
c0104f4a:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f50:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f56:	74 1b                	je     c0104f73 <get_page+0x52>
c0104f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f5b:	8b 00                	mov    (%eax),%eax
c0104f5d:	83 e0 01             	and    $0x1,%eax
c0104f60:	85 c0                	test   %eax,%eax
c0104f62:	74 0f                	je     c0104f73 <get_page+0x52>
        return pa2page(*ptep);
c0104f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f67:	8b 00                	mov    (%eax),%eax
c0104f69:	89 04 24             	mov    %eax,(%esp)
c0104f6c:	e8 e9 f3 ff ff       	call   c010435a <pa2page>
c0104f71:	eb 05                	jmp    c0104f78 <get_page+0x57>
    }
    return NULL;
c0104f73:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104f78:	c9                   	leave  
c0104f79:	c3                   	ret    

c0104f7a <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104f7a:	55                   	push   %ebp
c0104f7b:	89 e5                	mov    %esp,%ebp
c0104f7d:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */

    if (*ptep & PTE_P) {                      //(1) check if this page table entry is present（存在）
c0104f80:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f83:	8b 00                	mov    (%eax),%eax
c0104f85:	83 e0 01             	and    $0x1,%eax
c0104f88:	85 c0                	test   %eax,%eax
c0104f8a:	74 4d                	je     c0104fd9 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
c0104f8c:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f8f:	8b 00                	mov    (%eax),%eax
c0104f91:	89 04 24             	mov    %eax,(%esp)
c0104f94:	e8 a4 f4 ff ff       	call   c010443d <pte2page>
c0104f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {               //(3) decrease page reference
c0104f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f9f:	89 04 24             	mov    %eax,(%esp)
c0104fa2:	e8 02 f5 ff ff       	call   c01044a9 <page_ref_dec>
c0104fa7:	85 c0                	test   %eax,%eax
c0104fa9:	75 13                	jne    c0104fbe <page_remove_pte+0x44>
        	free_page(page);
c0104fab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fb2:	00 
c0104fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fb6:	89 04 24             	mov    %eax,(%esp)
c0104fb9:	e8 2d f7 ff ff       	call   c01046eb <free_pages>
        }
        *ptep = 0;						  //(4) and free this page when page reference reachs 0
c0104fbe:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                                  	  	  //(5) clear second page table entry
        tlb_invalidate(pgdir, la);  	  //(6) flush tlb
c0104fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fce:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fd1:	89 04 24             	mov    %eax,(%esp)
c0104fd4:	e8 ff 00 00 00       	call   c01050d8 <tlb_invalidate>
    }

}
c0104fd9:	c9                   	leave  
c0104fda:	c3                   	ret    

c0104fdb <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104fdb:	55                   	push   %ebp
c0104fdc:	89 e5                	mov    %esp,%ebp
c0104fde:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104fe1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104fe8:	00 
c0104fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ff0:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ff3:	89 04 24             	mov    %eax,(%esp)
c0104ff6:	e8 e7 fd ff ff       	call   c0104de2 <get_pte>
c0104ffb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104ffe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105002:	74 19                	je     c010501d <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105004:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105007:	89 44 24 08          	mov    %eax,0x8(%esp)
c010500b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010500e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105012:	8b 45 08             	mov    0x8(%ebp),%eax
c0105015:	89 04 24             	mov    %eax,(%esp)
c0105018:	e8 5d ff ff ff       	call   c0104f7a <page_remove_pte>
    }
}
c010501d:	c9                   	leave  
c010501e:	c3                   	ret    

c010501f <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010501f:	55                   	push   %ebp
c0105020:	89 e5                	mov    %esp,%ebp
c0105022:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105025:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010502c:	00 
c010502d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105030:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105034:	8b 45 08             	mov    0x8(%ebp),%eax
c0105037:	89 04 24             	mov    %eax,(%esp)
c010503a:	e8 a3 fd ff ff       	call   c0104de2 <get_pte>
c010503f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105046:	75 0a                	jne    c0105052 <page_insert+0x33>
        return -E_NO_MEM;
c0105048:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010504d:	e9 84 00 00 00       	jmp    c01050d6 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105052:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105055:	89 04 24             	mov    %eax,(%esp)
c0105058:	e8 35 f4 ff ff       	call   c0104492 <page_ref_inc>
    if (*ptep & PTE_P) {
c010505d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105060:	8b 00                	mov    (%eax),%eax
c0105062:	83 e0 01             	and    $0x1,%eax
c0105065:	85 c0                	test   %eax,%eax
c0105067:	74 3e                	je     c01050a7 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105069:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010506c:	8b 00                	mov    (%eax),%eax
c010506e:	89 04 24             	mov    %eax,(%esp)
c0105071:	e8 c7 f3 ff ff       	call   c010443d <pte2page>
c0105076:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105079:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010507c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010507f:	75 0d                	jne    c010508e <page_insert+0x6f>
            page_ref_dec(page);
c0105081:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105084:	89 04 24             	mov    %eax,(%esp)
c0105087:	e8 1d f4 ff ff       	call   c01044a9 <page_ref_dec>
c010508c:	eb 19                	jmp    c01050a7 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010508e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105091:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105095:	8b 45 10             	mov    0x10(%ebp),%eax
c0105098:	89 44 24 04          	mov    %eax,0x4(%esp)
c010509c:	8b 45 08             	mov    0x8(%ebp),%eax
c010509f:	89 04 24             	mov    %eax,(%esp)
c01050a2:	e8 d3 fe ff ff       	call   c0104f7a <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01050a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050aa:	89 04 24             	mov    %eax,(%esp)
c01050ad:	e8 92 f2 ff ff       	call   c0104344 <page2pa>
c01050b2:	0b 45 14             	or     0x14(%ebp),%eax
c01050b5:	83 c8 01             	or     $0x1,%eax
c01050b8:	89 c2                	mov    %eax,%edx
c01050ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050bd:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01050bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01050c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01050c9:	89 04 24             	mov    %eax,(%esp)
c01050cc:	e8 07 00 00 00       	call   c01050d8 <tlb_invalidate>
    return 0;
c01050d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01050d6:	c9                   	leave  
c01050d7:	c3                   	ret    

c01050d8 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01050d8:	55                   	push   %ebp
c01050d9:	89 e5                	mov    %esp,%ebp
c01050db:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01050de:	0f 20 d8             	mov    %cr3,%eax
c01050e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01050e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01050e7:	89 c2                	mov    %eax,%edx
c01050e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01050ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01050ef:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01050f6:	77 23                	ja     c010511b <tlb_invalidate+0x43>
c01050f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050ff:	c7 44 24 08 40 9d 10 	movl   $0xc0109d40,0x8(%esp)
c0105106:	c0 
c0105107:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c010510e:	00 
c010510f:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105116:	e8 ba bb ff ff       	call   c0100cd5 <__panic>
c010511b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010511e:	05 00 00 00 40       	add    $0x40000000,%eax
c0105123:	39 c2                	cmp    %eax,%edx
c0105125:	75 0c                	jne    c0105133 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105127:	8b 45 0c             	mov    0xc(%ebp),%eax
c010512a:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010512d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105130:	0f 01 38             	invlpg (%eax)
    }
}
c0105133:	c9                   	leave  
c0105134:	c3                   	ret    

c0105135 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105135:	55                   	push   %ebp
c0105136:	89 e5                	mov    %esp,%ebp
c0105138:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c010513b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105142:	e8 39 f5 ff ff       	call   c0104680 <alloc_pages>
c0105147:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c010514a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010514e:	0f 84 a7 00 00 00    	je     c01051fb <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0105154:	8b 45 10             	mov    0x10(%ebp),%eax
c0105157:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010515b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010515e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105162:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105165:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105169:	8b 45 08             	mov    0x8(%ebp),%eax
c010516c:	89 04 24             	mov    %eax,(%esp)
c010516f:	e8 ab fe ff ff       	call   c010501f <page_insert>
c0105174:	85 c0                	test   %eax,%eax
c0105176:	74 1a                	je     c0105192 <pgdir_alloc_page+0x5d>
            free_page(page);
c0105178:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010517f:	00 
c0105180:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105183:	89 04 24             	mov    %eax,(%esp)
c0105186:	e8 60 f5 ff ff       	call   c01046eb <free_pages>
            return NULL;
c010518b:	b8 00 00 00 00       	mov    $0x0,%eax
c0105190:	eb 6c                	jmp    c01051fe <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0105192:	a1 cc 2a 12 c0       	mov    0xc0122acc,%eax
c0105197:	85 c0                	test   %eax,%eax
c0105199:	74 60                	je     c01051fb <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c010519b:	a1 cc 2b 12 c0       	mov    0xc0122bcc,%eax
c01051a0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01051a7:	00 
c01051a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01051ab:	89 54 24 08          	mov    %edx,0x8(%esp)
c01051af:	8b 55 0c             	mov    0xc(%ebp),%edx
c01051b2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051b6:	89 04 24             	mov    %eax,(%esp)
c01051b9:	e8 78 0f 00 00       	call   c0106136 <swap_map_swappable>
            page->pra_vaddr=la;
c01051be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051c1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01051c4:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01051c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051ca:	89 04 24             	mov    %eax,(%esp)
c01051cd:	e8 a9 f2 ff ff       	call   c010447b <page_ref>
c01051d2:	83 f8 01             	cmp    $0x1,%eax
c01051d5:	74 24                	je     c01051fb <pgdir_alloc_page+0xc6>
c01051d7:	c7 44 24 0c 44 9e 10 	movl   $0xc0109e44,0xc(%esp)
c01051de:	c0 
c01051df:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c01051e6:	c0 
c01051e7:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c01051ee:	00 
c01051ef:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c01051f6:	e8 da ba ff ff       	call   c0100cd5 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c01051fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01051fe:	c9                   	leave  
c01051ff:	c3                   	ret    

c0105200 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105200:	55                   	push   %ebp
c0105201:	89 e5                	mov    %esp,%ebp
c0105203:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105206:	a1 ec 2a 12 c0       	mov    0xc0122aec,%eax
c010520b:	8b 40 18             	mov    0x18(%eax),%eax
c010520e:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105210:	c7 04 24 58 9e 10 c0 	movl   $0xc0109e58,(%esp)
c0105217:	e8 2f b1 ff ff       	call   c010034b <cprintf>
}
c010521c:	c9                   	leave  
c010521d:	c3                   	ret    

c010521e <check_pgdir>:

static void
check_pgdir(void) {
c010521e:	55                   	push   %ebp
c010521f:	89 e5                	mov    %esp,%ebp
c0105221:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105224:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c0105229:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010522e:	76 24                	jbe    c0105254 <check_pgdir+0x36>
c0105230:	c7 44 24 0c 77 9e 10 	movl   $0xc0109e77,0xc(%esp)
c0105237:	c0 
c0105238:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c010523f:	c0 
c0105240:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0105247:	00 
c0105248:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c010524f:	e8 81 ba ff ff       	call   c0100cd5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105254:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105259:	85 c0                	test   %eax,%eax
c010525b:	74 0e                	je     c010526b <check_pgdir+0x4d>
c010525d:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105262:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105267:	85 c0                	test   %eax,%eax
c0105269:	74 24                	je     c010528f <check_pgdir+0x71>
c010526b:	c7 44 24 0c 94 9e 10 	movl   $0xc0109e94,0xc(%esp)
c0105272:	c0 
c0105273:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c010527a:	c0 
c010527b:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0105282:	00 
c0105283:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c010528a:	e8 46 ba ff ff       	call   c0100cd5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010528f:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105294:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010529b:	00 
c010529c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01052a3:	00 
c01052a4:	89 04 24             	mov    %eax,(%esp)
c01052a7:	e8 75 fc ff ff       	call   c0104f21 <get_page>
c01052ac:	85 c0                	test   %eax,%eax
c01052ae:	74 24                	je     c01052d4 <check_pgdir+0xb6>
c01052b0:	c7 44 24 0c cc 9e 10 	movl   $0xc0109ecc,0xc(%esp)
c01052b7:	c0 
c01052b8:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c01052bf:	c0 
c01052c0:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c01052c7:	00 
c01052c8:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c01052cf:	e8 01 ba ff ff       	call   c0100cd5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01052d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052db:	e8 a0 f3 ff ff       	call   c0104680 <alloc_pages>
c01052e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01052e3:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c01052e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01052ef:	00 
c01052f0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01052f7:	00 
c01052f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01052fb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052ff:	89 04 24             	mov    %eax,(%esp)
c0105302:	e8 18 fd ff ff       	call   c010501f <page_insert>
c0105307:	85 c0                	test   %eax,%eax
c0105309:	74 24                	je     c010532f <check_pgdir+0x111>
c010530b:	c7 44 24 0c f4 9e 10 	movl   $0xc0109ef4,0xc(%esp)
c0105312:	c0 
c0105313:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c010531a:	c0 
c010531b:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0105322:	00 
c0105323:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c010532a:	e8 a6 b9 ff ff       	call   c0100cd5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010532f:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105334:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010533b:	00 
c010533c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105343:	00 
c0105344:	89 04 24             	mov    %eax,(%esp)
c0105347:	e8 96 fa ff ff       	call   c0104de2 <get_pte>
c010534c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010534f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105353:	75 24                	jne    c0105379 <check_pgdir+0x15b>
c0105355:	c7 44 24 0c 20 9f 10 	movl   $0xc0109f20,0xc(%esp)
c010535c:	c0 
c010535d:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105364:	c0 
c0105365:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c010536c:	00 
c010536d:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105374:	e8 5c b9 ff ff       	call   c0100cd5 <__panic>
    assert(pa2page(*ptep) == p1);
c0105379:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010537c:	8b 00                	mov    (%eax),%eax
c010537e:	89 04 24             	mov    %eax,(%esp)
c0105381:	e8 d4 ef ff ff       	call   c010435a <pa2page>
c0105386:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105389:	74 24                	je     c01053af <check_pgdir+0x191>
c010538b:	c7 44 24 0c 4d 9f 10 	movl   $0xc0109f4d,0xc(%esp)
c0105392:	c0 
c0105393:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c010539a:	c0 
c010539b:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c01053a2:	00 
c01053a3:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c01053aa:	e8 26 b9 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p1) == 1);
c01053af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053b2:	89 04 24             	mov    %eax,(%esp)
c01053b5:	e8 c1 f0 ff ff       	call   c010447b <page_ref>
c01053ba:	83 f8 01             	cmp    $0x1,%eax
c01053bd:	74 24                	je     c01053e3 <check_pgdir+0x1c5>
c01053bf:	c7 44 24 0c 62 9f 10 	movl   $0xc0109f62,0xc(%esp)
c01053c6:	c0 
c01053c7:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c01053ce:	c0 
c01053cf:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c01053d6:	00 
c01053d7:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c01053de:	e8 f2 b8 ff ff       	call   c0100cd5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01053e3:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c01053e8:	8b 00                	mov    (%eax),%eax
c01053ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01053ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01053f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053f5:	c1 e8 0c             	shr    $0xc,%eax
c01053f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053fb:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c0105400:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105403:	72 23                	jb     c0105428 <check_pgdir+0x20a>
c0105405:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105408:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010540c:	c7 44 24 08 1c 9d 10 	movl   $0xc0109d1c,0x8(%esp)
c0105413:	c0 
c0105414:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c010541b:	00 
c010541c:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105423:	e8 ad b8 ff ff       	call   c0100cd5 <__panic>
c0105428:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010542b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105430:	83 c0 04             	add    $0x4,%eax
c0105433:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105436:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c010543b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105442:	00 
c0105443:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010544a:	00 
c010544b:	89 04 24             	mov    %eax,(%esp)
c010544e:	e8 8f f9 ff ff       	call   c0104de2 <get_pte>
c0105453:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105456:	74 24                	je     c010547c <check_pgdir+0x25e>
c0105458:	c7 44 24 0c 74 9f 10 	movl   $0xc0109f74,0xc(%esp)
c010545f:	c0 
c0105460:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105467:	c0 
c0105468:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c010546f:	00 
c0105470:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105477:	e8 59 b8 ff ff       	call   c0100cd5 <__panic>

    p2 = alloc_page();
c010547c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105483:	e8 f8 f1 ff ff       	call   c0104680 <alloc_pages>
c0105488:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010548b:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105490:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105497:	00 
c0105498:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010549f:	00 
c01054a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054a3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01054a7:	89 04 24             	mov    %eax,(%esp)
c01054aa:	e8 70 fb ff ff       	call   c010501f <page_insert>
c01054af:	85 c0                	test   %eax,%eax
c01054b1:	74 24                	je     c01054d7 <check_pgdir+0x2b9>
c01054b3:	c7 44 24 0c 9c 9f 10 	movl   $0xc0109f9c,0xc(%esp)
c01054ba:	c0 
c01054bb:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c01054c2:	c0 
c01054c3:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c01054ca:	00 
c01054cb:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c01054d2:	e8 fe b7 ff ff       	call   c0100cd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01054d7:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c01054dc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01054e3:	00 
c01054e4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01054eb:	00 
c01054ec:	89 04 24             	mov    %eax,(%esp)
c01054ef:	e8 ee f8 ff ff       	call   c0104de2 <get_pte>
c01054f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01054fb:	75 24                	jne    c0105521 <check_pgdir+0x303>
c01054fd:	c7 44 24 0c d4 9f 10 	movl   $0xc0109fd4,0xc(%esp)
c0105504:	c0 
c0105505:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c010550c:	c0 
c010550d:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0105514:	00 
c0105515:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c010551c:	e8 b4 b7 ff ff       	call   c0100cd5 <__panic>
    assert(*ptep & PTE_U);
c0105521:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105524:	8b 00                	mov    (%eax),%eax
c0105526:	83 e0 04             	and    $0x4,%eax
c0105529:	85 c0                	test   %eax,%eax
c010552b:	75 24                	jne    c0105551 <check_pgdir+0x333>
c010552d:	c7 44 24 0c 04 a0 10 	movl   $0xc010a004,0xc(%esp)
c0105534:	c0 
c0105535:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c010553c:	c0 
c010553d:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105544:	00 
c0105545:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c010554c:	e8 84 b7 ff ff       	call   c0100cd5 <__panic>
    assert(*ptep & PTE_W);
c0105551:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105554:	8b 00                	mov    (%eax),%eax
c0105556:	83 e0 02             	and    $0x2,%eax
c0105559:	85 c0                	test   %eax,%eax
c010555b:	75 24                	jne    c0105581 <check_pgdir+0x363>
c010555d:	c7 44 24 0c 12 a0 10 	movl   $0xc010a012,0xc(%esp)
c0105564:	c0 
c0105565:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c010556c:	c0 
c010556d:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0105574:	00 
c0105575:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c010557c:	e8 54 b7 ff ff       	call   c0100cd5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105581:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105586:	8b 00                	mov    (%eax),%eax
c0105588:	83 e0 04             	and    $0x4,%eax
c010558b:	85 c0                	test   %eax,%eax
c010558d:	75 24                	jne    c01055b3 <check_pgdir+0x395>
c010558f:	c7 44 24 0c 20 a0 10 	movl   $0xc010a020,0xc(%esp)
c0105596:	c0 
c0105597:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c010559e:	c0 
c010559f:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c01055a6:	00 
c01055a7:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c01055ae:	e8 22 b7 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p2) == 1);
c01055b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055b6:	89 04 24             	mov    %eax,(%esp)
c01055b9:	e8 bd ee ff ff       	call   c010447b <page_ref>
c01055be:	83 f8 01             	cmp    $0x1,%eax
c01055c1:	74 24                	je     c01055e7 <check_pgdir+0x3c9>
c01055c3:	c7 44 24 0c 36 a0 10 	movl   $0xc010a036,0xc(%esp)
c01055ca:	c0 
c01055cb:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c01055d2:	c0 
c01055d3:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c01055da:	00 
c01055db:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c01055e2:	e8 ee b6 ff ff       	call   c0100cd5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01055e7:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c01055ec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01055f3:	00 
c01055f4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01055fb:	00 
c01055fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01055ff:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105603:	89 04 24             	mov    %eax,(%esp)
c0105606:	e8 14 fa ff ff       	call   c010501f <page_insert>
c010560b:	85 c0                	test   %eax,%eax
c010560d:	74 24                	je     c0105633 <check_pgdir+0x415>
c010560f:	c7 44 24 0c 48 a0 10 	movl   $0xc010a048,0xc(%esp)
c0105616:	c0 
c0105617:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c010561e:	c0 
c010561f:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105626:	00 
c0105627:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c010562e:	e8 a2 b6 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p1) == 2);
c0105633:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105636:	89 04 24             	mov    %eax,(%esp)
c0105639:	e8 3d ee ff ff       	call   c010447b <page_ref>
c010563e:	83 f8 02             	cmp    $0x2,%eax
c0105641:	74 24                	je     c0105667 <check_pgdir+0x449>
c0105643:	c7 44 24 0c 74 a0 10 	movl   $0xc010a074,0xc(%esp)
c010564a:	c0 
c010564b:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105652:	c0 
c0105653:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c010565a:	00 
c010565b:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105662:	e8 6e b6 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p2) == 0);
c0105667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010566a:	89 04 24             	mov    %eax,(%esp)
c010566d:	e8 09 ee ff ff       	call   c010447b <page_ref>
c0105672:	85 c0                	test   %eax,%eax
c0105674:	74 24                	je     c010569a <check_pgdir+0x47c>
c0105676:	c7 44 24 0c 86 a0 10 	movl   $0xc010a086,0xc(%esp)
c010567d:	c0 
c010567e:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105685:	c0 
c0105686:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c010568d:	00 
c010568e:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105695:	e8 3b b6 ff ff       	call   c0100cd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010569a:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c010569f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01056a6:	00 
c01056a7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01056ae:	00 
c01056af:	89 04 24             	mov    %eax,(%esp)
c01056b2:	e8 2b f7 ff ff       	call   c0104de2 <get_pte>
c01056b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01056be:	75 24                	jne    c01056e4 <check_pgdir+0x4c6>
c01056c0:	c7 44 24 0c d4 9f 10 	movl   $0xc0109fd4,0xc(%esp)
c01056c7:	c0 
c01056c8:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c01056cf:	c0 
c01056d0:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c01056d7:	00 
c01056d8:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c01056df:	e8 f1 b5 ff ff       	call   c0100cd5 <__panic>
    assert(pa2page(*ptep) == p1);
c01056e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056e7:	8b 00                	mov    (%eax),%eax
c01056e9:	89 04 24             	mov    %eax,(%esp)
c01056ec:	e8 69 ec ff ff       	call   c010435a <pa2page>
c01056f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01056f4:	74 24                	je     c010571a <check_pgdir+0x4fc>
c01056f6:	c7 44 24 0c 4d 9f 10 	movl   $0xc0109f4d,0xc(%esp)
c01056fd:	c0 
c01056fe:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105705:	c0 
c0105706:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c010570d:	00 
c010570e:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105715:	e8 bb b5 ff ff       	call   c0100cd5 <__panic>
    assert((*ptep & PTE_U) == 0);
c010571a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010571d:	8b 00                	mov    (%eax),%eax
c010571f:	83 e0 04             	and    $0x4,%eax
c0105722:	85 c0                	test   %eax,%eax
c0105724:	74 24                	je     c010574a <check_pgdir+0x52c>
c0105726:	c7 44 24 0c 98 a0 10 	movl   $0xc010a098,0xc(%esp)
c010572d:	c0 
c010572e:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105735:	c0 
c0105736:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c010573d:	00 
c010573e:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105745:	e8 8b b5 ff ff       	call   c0100cd5 <__panic>

    page_remove(boot_pgdir, 0x0);
c010574a:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c010574f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105756:	00 
c0105757:	89 04 24             	mov    %eax,(%esp)
c010575a:	e8 7c f8 ff ff       	call   c0104fdb <page_remove>
    assert(page_ref(p1) == 1);
c010575f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105762:	89 04 24             	mov    %eax,(%esp)
c0105765:	e8 11 ed ff ff       	call   c010447b <page_ref>
c010576a:	83 f8 01             	cmp    $0x1,%eax
c010576d:	74 24                	je     c0105793 <check_pgdir+0x575>
c010576f:	c7 44 24 0c 62 9f 10 	movl   $0xc0109f62,0xc(%esp)
c0105776:	c0 
c0105777:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c010577e:	c0 
c010577f:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105786:	00 
c0105787:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c010578e:	e8 42 b5 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p2) == 0);
c0105793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105796:	89 04 24             	mov    %eax,(%esp)
c0105799:	e8 dd ec ff ff       	call   c010447b <page_ref>
c010579e:	85 c0                	test   %eax,%eax
c01057a0:	74 24                	je     c01057c6 <check_pgdir+0x5a8>
c01057a2:	c7 44 24 0c 86 a0 10 	movl   $0xc010a086,0xc(%esp)
c01057a9:	c0 
c01057aa:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c01057b1:	c0 
c01057b2:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c01057b9:	00 
c01057ba:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c01057c1:	e8 0f b5 ff ff       	call   c0100cd5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01057c6:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c01057cb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01057d2:	00 
c01057d3:	89 04 24             	mov    %eax,(%esp)
c01057d6:	e8 00 f8 ff ff       	call   c0104fdb <page_remove>
    assert(page_ref(p1) == 0);
c01057db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057de:	89 04 24             	mov    %eax,(%esp)
c01057e1:	e8 95 ec ff ff       	call   c010447b <page_ref>
c01057e6:	85 c0                	test   %eax,%eax
c01057e8:	74 24                	je     c010580e <check_pgdir+0x5f0>
c01057ea:	c7 44 24 0c ad a0 10 	movl   $0xc010a0ad,0xc(%esp)
c01057f1:	c0 
c01057f2:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c01057f9:	c0 
c01057fa:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105801:	00 
c0105802:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105809:	e8 c7 b4 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p2) == 0);
c010580e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105811:	89 04 24             	mov    %eax,(%esp)
c0105814:	e8 62 ec ff ff       	call   c010447b <page_ref>
c0105819:	85 c0                	test   %eax,%eax
c010581b:	74 24                	je     c0105841 <check_pgdir+0x623>
c010581d:	c7 44 24 0c 86 a0 10 	movl   $0xc010a086,0xc(%esp)
c0105824:	c0 
c0105825:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c010582c:	c0 
c010582d:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105834:	00 
c0105835:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c010583c:	e8 94 b4 ff ff       	call   c0100cd5 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0105841:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105846:	8b 00                	mov    (%eax),%eax
c0105848:	89 04 24             	mov    %eax,(%esp)
c010584b:	e8 0a eb ff ff       	call   c010435a <pa2page>
c0105850:	89 04 24             	mov    %eax,(%esp)
c0105853:	e8 23 ec ff ff       	call   c010447b <page_ref>
c0105858:	83 f8 01             	cmp    $0x1,%eax
c010585b:	74 24                	je     c0105881 <check_pgdir+0x663>
c010585d:	c7 44 24 0c c0 a0 10 	movl   $0xc010a0c0,0xc(%esp)
c0105864:	c0 
c0105865:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c010586c:	c0 
c010586d:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105874:	00 
c0105875:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c010587c:	e8 54 b4 ff ff       	call   c0100cd5 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0105881:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105886:	8b 00                	mov    (%eax),%eax
c0105888:	89 04 24             	mov    %eax,(%esp)
c010588b:	e8 ca ea ff ff       	call   c010435a <pa2page>
c0105890:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105897:	00 
c0105898:	89 04 24             	mov    %eax,(%esp)
c010589b:	e8 4b ee ff ff       	call   c01046eb <free_pages>
    boot_pgdir[0] = 0;
c01058a0:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c01058a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01058ab:	c7 04 24 e6 a0 10 c0 	movl   $0xc010a0e6,(%esp)
c01058b2:	e8 94 aa ff ff       	call   c010034b <cprintf>
}
c01058b7:	c9                   	leave  
c01058b8:	c3                   	ret    

c01058b9 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01058b9:	55                   	push   %ebp
c01058ba:	89 e5                	mov    %esp,%ebp
c01058bc:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01058bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01058c6:	e9 ca 00 00 00       	jmp    c0105995 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01058cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058d4:	c1 e8 0c             	shr    $0xc,%eax
c01058d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01058da:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c01058df:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01058e2:	72 23                	jb     c0105907 <check_boot_pgdir+0x4e>
c01058e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058eb:	c7 44 24 08 1c 9d 10 	movl   $0xc0109d1c,0x8(%esp)
c01058f2:	c0 
c01058f3:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
c01058fa:	00 
c01058fb:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105902:	e8 ce b3 ff ff       	call   c0100cd5 <__panic>
c0105907:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010590a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010590f:	89 c2                	mov    %eax,%edx
c0105911:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105916:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010591d:	00 
c010591e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105922:	89 04 24             	mov    %eax,(%esp)
c0105925:	e8 b8 f4 ff ff       	call   c0104de2 <get_pte>
c010592a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010592d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105931:	75 24                	jne    c0105957 <check_boot_pgdir+0x9e>
c0105933:	c7 44 24 0c 00 a1 10 	movl   $0xc010a100,0xc(%esp)
c010593a:	c0 
c010593b:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105942:	c0 
c0105943:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
c010594a:	00 
c010594b:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105952:	e8 7e b3 ff ff       	call   c0100cd5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105957:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010595a:	8b 00                	mov    (%eax),%eax
c010595c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105961:	89 c2                	mov    %eax,%edx
c0105963:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105966:	39 c2                	cmp    %eax,%edx
c0105968:	74 24                	je     c010598e <check_boot_pgdir+0xd5>
c010596a:	c7 44 24 0c 3d a1 10 	movl   $0xc010a13d,0xc(%esp)
c0105971:	c0 
c0105972:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105979:	c0 
c010597a:	c7 44 24 04 4e 02 00 	movl   $0x24e,0x4(%esp)
c0105981:	00 
c0105982:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105989:	e8 47 b3 ff ff       	call   c0100cd5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010598e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105995:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105998:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c010599d:	39 c2                	cmp    %eax,%edx
c010599f:	0f 82 26 ff ff ff    	jb     c01058cb <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01059a5:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c01059aa:	05 ac 0f 00 00       	add    $0xfac,%eax
c01059af:	8b 00                	mov    (%eax),%eax
c01059b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01059b6:	89 c2                	mov    %eax,%edx
c01059b8:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c01059bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01059c0:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01059c7:	77 23                	ja     c01059ec <check_boot_pgdir+0x133>
c01059c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059d0:	c7 44 24 08 40 9d 10 	movl   $0xc0109d40,0x8(%esp)
c01059d7:	c0 
c01059d8:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
c01059df:	00 
c01059e0:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c01059e7:	e8 e9 b2 ff ff       	call   c0100cd5 <__panic>
c01059ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059ef:	05 00 00 00 40       	add    $0x40000000,%eax
c01059f4:	39 c2                	cmp    %eax,%edx
c01059f6:	74 24                	je     c0105a1c <check_boot_pgdir+0x163>
c01059f8:	c7 44 24 0c 54 a1 10 	movl   $0xc010a154,0xc(%esp)
c01059ff:	c0 
c0105a00:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105a07:	c0 
c0105a08:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
c0105a0f:	00 
c0105a10:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105a17:	e8 b9 b2 ff ff       	call   c0100cd5 <__panic>

    assert(boot_pgdir[0] == 0);
c0105a1c:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105a21:	8b 00                	mov    (%eax),%eax
c0105a23:	85 c0                	test   %eax,%eax
c0105a25:	74 24                	je     c0105a4b <check_boot_pgdir+0x192>
c0105a27:	c7 44 24 0c 88 a1 10 	movl   $0xc010a188,0xc(%esp)
c0105a2e:	c0 
c0105a2f:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105a36:	c0 
c0105a37:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0105a3e:	00 
c0105a3f:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105a46:	e8 8a b2 ff ff       	call   c0100cd5 <__panic>

    struct Page *p;
    p = alloc_page();
c0105a4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105a52:	e8 29 ec ff ff       	call   c0104680 <alloc_pages>
c0105a57:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105a5a:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105a5f:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105a66:	00 
c0105a67:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105a6e:	00 
c0105a6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a72:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a76:	89 04 24             	mov    %eax,(%esp)
c0105a79:	e8 a1 f5 ff ff       	call   c010501f <page_insert>
c0105a7e:	85 c0                	test   %eax,%eax
c0105a80:	74 24                	je     c0105aa6 <check_boot_pgdir+0x1ed>
c0105a82:	c7 44 24 0c 9c a1 10 	movl   $0xc010a19c,0xc(%esp)
c0105a89:	c0 
c0105a8a:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105a91:	c0 
c0105a92:	c7 44 24 04 57 02 00 	movl   $0x257,0x4(%esp)
c0105a99:	00 
c0105a9a:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105aa1:	e8 2f b2 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p) == 1);
c0105aa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105aa9:	89 04 24             	mov    %eax,(%esp)
c0105aac:	e8 ca e9 ff ff       	call   c010447b <page_ref>
c0105ab1:	83 f8 01             	cmp    $0x1,%eax
c0105ab4:	74 24                	je     c0105ada <check_boot_pgdir+0x221>
c0105ab6:	c7 44 24 0c ca a1 10 	movl   $0xc010a1ca,0xc(%esp)
c0105abd:	c0 
c0105abe:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105ac5:	c0 
c0105ac6:	c7 44 24 04 58 02 00 	movl   $0x258,0x4(%esp)
c0105acd:	00 
c0105ace:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105ad5:	e8 fb b1 ff ff       	call   c0100cd5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105ada:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105adf:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105ae6:	00 
c0105ae7:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105aee:	00 
c0105aef:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105af2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105af6:	89 04 24             	mov    %eax,(%esp)
c0105af9:	e8 21 f5 ff ff       	call   c010501f <page_insert>
c0105afe:	85 c0                	test   %eax,%eax
c0105b00:	74 24                	je     c0105b26 <check_boot_pgdir+0x26d>
c0105b02:	c7 44 24 0c dc a1 10 	movl   $0xc010a1dc,0xc(%esp)
c0105b09:	c0 
c0105b0a:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105b11:	c0 
c0105b12:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c0105b19:	00 
c0105b1a:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105b21:	e8 af b1 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p) == 2);
c0105b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b29:	89 04 24             	mov    %eax,(%esp)
c0105b2c:	e8 4a e9 ff ff       	call   c010447b <page_ref>
c0105b31:	83 f8 02             	cmp    $0x2,%eax
c0105b34:	74 24                	je     c0105b5a <check_boot_pgdir+0x2a1>
c0105b36:	c7 44 24 0c 13 a2 10 	movl   $0xc010a213,0xc(%esp)
c0105b3d:	c0 
c0105b3e:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105b45:	c0 
c0105b46:	c7 44 24 04 5a 02 00 	movl   $0x25a,0x4(%esp)
c0105b4d:	00 
c0105b4e:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105b55:	e8 7b b1 ff ff       	call   c0100cd5 <__panic>

    const char *str = "ucore: Hello world!!";
c0105b5a:	c7 45 dc 24 a2 10 c0 	movl   $0xc010a224,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105b61:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b68:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b6f:	e8 1b 31 00 00       	call   c0108c8f <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105b74:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105b7b:	00 
c0105b7c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b83:	e8 80 31 00 00       	call   c0108d08 <strcmp>
c0105b88:	85 c0                	test   %eax,%eax
c0105b8a:	74 24                	je     c0105bb0 <check_boot_pgdir+0x2f7>
c0105b8c:	c7 44 24 0c 3c a2 10 	movl   $0xc010a23c,0xc(%esp)
c0105b93:	c0 
c0105b94:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105b9b:	c0 
c0105b9c:	c7 44 24 04 5e 02 00 	movl   $0x25e,0x4(%esp)
c0105ba3:	00 
c0105ba4:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105bab:	e8 25 b1 ff ff       	call   c0100cd5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105bb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105bb3:	89 04 24             	mov    %eax,(%esp)
c0105bb6:	e8 e4 e7 ff ff       	call   c010439f <page2kva>
c0105bbb:	05 00 01 00 00       	add    $0x100,%eax
c0105bc0:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105bc3:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105bca:	e8 68 30 00 00       	call   c0108c37 <strlen>
c0105bcf:	85 c0                	test   %eax,%eax
c0105bd1:	74 24                	je     c0105bf7 <check_boot_pgdir+0x33e>
c0105bd3:	c7 44 24 0c 74 a2 10 	movl   $0xc010a274,0xc(%esp)
c0105bda:	c0 
c0105bdb:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105be2:	c0 
c0105be3:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c0105bea:	00 
c0105beb:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105bf2:	e8 de b0 ff ff       	call   c0100cd5 <__panic>

    free_page(p);
c0105bf7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105bfe:	00 
c0105bff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c02:	89 04 24             	mov    %eax,(%esp)
c0105c05:	e8 e1 ea ff ff       	call   c01046eb <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105c0a:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105c0f:	8b 00                	mov    (%eax),%eax
c0105c11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105c16:	89 04 24             	mov    %eax,(%esp)
c0105c19:	e8 3c e7 ff ff       	call   c010435a <pa2page>
c0105c1e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c25:	00 
c0105c26:	89 04 24             	mov    %eax,(%esp)
c0105c29:	e8 bd ea ff ff       	call   c01046eb <free_pages>
    boot_pgdir[0] = 0;
c0105c2e:	a1 44 2a 12 c0       	mov    0xc0122a44,%eax
c0105c33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105c39:	c7 04 24 98 a2 10 c0 	movl   $0xc010a298,(%esp)
c0105c40:	e8 06 a7 ff ff       	call   c010034b <cprintf>
}
c0105c45:	c9                   	leave  
c0105c46:	c3                   	ret    

c0105c47 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105c47:	55                   	push   %ebp
c0105c48:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105c4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c4d:	83 e0 04             	and    $0x4,%eax
c0105c50:	85 c0                	test   %eax,%eax
c0105c52:	74 07                	je     c0105c5b <perm2str+0x14>
c0105c54:	b8 75 00 00 00       	mov    $0x75,%eax
c0105c59:	eb 05                	jmp    c0105c60 <perm2str+0x19>
c0105c5b:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105c60:	a2 c8 2a 12 c0       	mov    %al,0xc0122ac8
    str[1] = 'r';
c0105c65:	c6 05 c9 2a 12 c0 72 	movb   $0x72,0xc0122ac9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105c6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6f:	83 e0 02             	and    $0x2,%eax
c0105c72:	85 c0                	test   %eax,%eax
c0105c74:	74 07                	je     c0105c7d <perm2str+0x36>
c0105c76:	b8 77 00 00 00       	mov    $0x77,%eax
c0105c7b:	eb 05                	jmp    c0105c82 <perm2str+0x3b>
c0105c7d:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105c82:	a2 ca 2a 12 c0       	mov    %al,0xc0122aca
    str[3] = '\0';
c0105c87:	c6 05 cb 2a 12 c0 00 	movb   $0x0,0xc0122acb
    return str;
c0105c8e:	b8 c8 2a 12 c0       	mov    $0xc0122ac8,%eax
}
c0105c93:	5d                   	pop    %ebp
c0105c94:	c3                   	ret    

c0105c95 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105c95:	55                   	push   %ebp
c0105c96:	89 e5                	mov    %esp,%ebp
c0105c98:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105c9b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c9e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ca1:	72 0a                	jb     c0105cad <get_pgtable_items+0x18>
        return 0;
c0105ca3:	b8 00 00 00 00       	mov    $0x0,%eax
c0105ca8:	e9 9c 00 00 00       	jmp    c0105d49 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105cad:	eb 04                	jmp    c0105cb3 <get_pgtable_items+0x1e>
        start ++;
c0105caf:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105cb3:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cb6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105cb9:	73 18                	jae    c0105cd3 <get_pgtable_items+0x3e>
c0105cbb:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cbe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105cc5:	8b 45 14             	mov    0x14(%ebp),%eax
c0105cc8:	01 d0                	add    %edx,%eax
c0105cca:	8b 00                	mov    (%eax),%eax
c0105ccc:	83 e0 01             	and    $0x1,%eax
c0105ccf:	85 c0                	test   %eax,%eax
c0105cd1:	74 dc                	je     c0105caf <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105cd3:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cd6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105cd9:	73 69                	jae    c0105d44 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105cdb:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105cdf:	74 08                	je     c0105ce9 <get_pgtable_items+0x54>
            *left_store = start;
c0105ce1:	8b 45 18             	mov    0x18(%ebp),%eax
c0105ce4:	8b 55 10             	mov    0x10(%ebp),%edx
c0105ce7:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105ce9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cec:	8d 50 01             	lea    0x1(%eax),%edx
c0105cef:	89 55 10             	mov    %edx,0x10(%ebp)
c0105cf2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105cf9:	8b 45 14             	mov    0x14(%ebp),%eax
c0105cfc:	01 d0                	add    %edx,%eax
c0105cfe:	8b 00                	mov    (%eax),%eax
c0105d00:	83 e0 07             	and    $0x7,%eax
c0105d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105d06:	eb 04                	jmp    c0105d0c <get_pgtable_items+0x77>
            start ++;
c0105d08:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105d0c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d0f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d12:	73 1d                	jae    c0105d31 <get_pgtable_items+0x9c>
c0105d14:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d17:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105d1e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d21:	01 d0                	add    %edx,%eax
c0105d23:	8b 00                	mov    (%eax),%eax
c0105d25:	83 e0 07             	and    $0x7,%eax
c0105d28:	89 c2                	mov    %eax,%edx
c0105d2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d2d:	39 c2                	cmp    %eax,%edx
c0105d2f:	74 d7                	je     c0105d08 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105d31:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105d35:	74 08                	je     c0105d3f <get_pgtable_items+0xaa>
            *right_store = start;
c0105d37:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105d3a:	8b 55 10             	mov    0x10(%ebp),%edx
c0105d3d:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105d3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d42:	eb 05                	jmp    c0105d49 <get_pgtable_items+0xb4>
    }
    return 0;
c0105d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d49:	c9                   	leave  
c0105d4a:	c3                   	ret    

c0105d4b <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105d4b:	55                   	push   %ebp
c0105d4c:	89 e5                	mov    %esp,%ebp
c0105d4e:	57                   	push   %edi
c0105d4f:	56                   	push   %esi
c0105d50:	53                   	push   %ebx
c0105d51:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105d54:	c7 04 24 b8 a2 10 c0 	movl   $0xc010a2b8,(%esp)
c0105d5b:	e8 eb a5 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
c0105d60:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105d67:	e9 fa 00 00 00       	jmp    c0105e66 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d6f:	89 04 24             	mov    %eax,(%esp)
c0105d72:	e8 d0 fe ff ff       	call   c0105c47 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105d77:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105d7a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d7d:	29 d1                	sub    %edx,%ecx
c0105d7f:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105d81:	89 d6                	mov    %edx,%esi
c0105d83:	c1 e6 16             	shl    $0x16,%esi
c0105d86:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105d89:	89 d3                	mov    %edx,%ebx
c0105d8b:	c1 e3 16             	shl    $0x16,%ebx
c0105d8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d91:	89 d1                	mov    %edx,%ecx
c0105d93:	c1 e1 16             	shl    $0x16,%ecx
c0105d96:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105d99:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d9c:	29 d7                	sub    %edx,%edi
c0105d9e:	89 fa                	mov    %edi,%edx
c0105da0:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105da4:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105da8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105dac:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105db0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105db4:	c7 04 24 e9 a2 10 c0 	movl   $0xc010a2e9,(%esp)
c0105dbb:	e8 8b a5 ff ff       	call   c010034b <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105dc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105dc3:	c1 e0 0a             	shl    $0xa,%eax
c0105dc6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105dc9:	eb 54                	jmp    c0105e1f <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105dce:	89 04 24             	mov    %eax,(%esp)
c0105dd1:	e8 71 fe ff ff       	call   c0105c47 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105dd6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105dd9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105ddc:	29 d1                	sub    %edx,%ecx
c0105dde:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105de0:	89 d6                	mov    %edx,%esi
c0105de2:	c1 e6 0c             	shl    $0xc,%esi
c0105de5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105de8:	89 d3                	mov    %edx,%ebx
c0105dea:	c1 e3 0c             	shl    $0xc,%ebx
c0105ded:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105df0:	c1 e2 0c             	shl    $0xc,%edx
c0105df3:	89 d1                	mov    %edx,%ecx
c0105df5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105df8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105dfb:	29 d7                	sub    %edx,%edi
c0105dfd:	89 fa                	mov    %edi,%edx
c0105dff:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105e03:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105e07:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105e0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105e0f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e13:	c7 04 24 08 a3 10 c0 	movl   $0xc010a308,(%esp)
c0105e1a:	e8 2c a5 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105e1f:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105e24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105e27:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e2a:	89 ce                	mov    %ecx,%esi
c0105e2c:	c1 e6 0a             	shl    $0xa,%esi
c0105e2f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105e32:	89 cb                	mov    %ecx,%ebx
c0105e34:	c1 e3 0a             	shl    $0xa,%ebx
c0105e37:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105e3a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105e3e:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105e41:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105e45:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e49:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e4d:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105e51:	89 1c 24             	mov    %ebx,(%esp)
c0105e54:	e8 3c fe ff ff       	call   c0105c95 <get_pgtable_items>
c0105e59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105e60:	0f 85 65 ff ff ff    	jne    c0105dcb <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105e66:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105e6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e6e:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105e71:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105e75:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105e78:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105e7c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e80:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e84:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105e8b:	00 
c0105e8c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105e93:	e8 fd fd ff ff       	call   c0105c95 <get_pgtable_items>
c0105e98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105e9f:	0f 85 c7 fe ff ff    	jne    c0105d6c <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105ea5:	c7 04 24 2c a3 10 c0 	movl   $0xc010a32c,(%esp)
c0105eac:	e8 9a a4 ff ff       	call   c010034b <cprintf>
}
c0105eb1:	83 c4 4c             	add    $0x4c,%esp
c0105eb4:	5b                   	pop    %ebx
c0105eb5:	5e                   	pop    %esi
c0105eb6:	5f                   	pop    %edi
c0105eb7:	5d                   	pop    %ebp
c0105eb8:	c3                   	ret    

c0105eb9 <kmalloc>:

void *
kmalloc(size_t n) {
c0105eb9:	55                   	push   %ebp
c0105eba:	89 e5                	mov    %esp,%ebp
c0105ebc:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0105ebf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0105ec6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0105ecd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105ed1:	74 09                	je     c0105edc <kmalloc+0x23>
c0105ed3:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0105eda:	76 24                	jbe    c0105f00 <kmalloc+0x47>
c0105edc:	c7 44 24 0c 5d a3 10 	movl   $0xc010a35d,0xc(%esp)
c0105ee3:	c0 
c0105ee4:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105eeb:	c0 
c0105eec:	c7 44 24 04 ad 02 00 	movl   $0x2ad,0x4(%esp)
c0105ef3:	00 
c0105ef4:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105efb:	e8 d5 ad ff ff       	call   c0100cd5 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105f00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f03:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105f08:	c1 e8 0c             	shr    $0xc,%eax
c0105f0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0105f0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f11:	89 04 24             	mov    %eax,(%esp)
c0105f14:	e8 67 e7 ff ff       	call   c0104680 <alloc_pages>
c0105f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0105f1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105f20:	75 24                	jne    c0105f46 <kmalloc+0x8d>
c0105f22:	c7 44 24 0c 74 a3 10 	movl   $0xc010a374,0xc(%esp)
c0105f29:	c0 
c0105f2a:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105f31:	c0 
c0105f32:	c7 44 24 04 b0 02 00 	movl   $0x2b0,0x4(%esp)
c0105f39:	00 
c0105f3a:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105f41:	e8 8f ad ff ff       	call   c0100cd5 <__panic>
    ptr=page2kva(base);
c0105f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f49:	89 04 24             	mov    %eax,(%esp)
c0105f4c:	e8 4e e4 ff ff       	call   c010439f <page2kva>
c0105f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0105f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105f57:	c9                   	leave  
c0105f58:	c3                   	ret    

c0105f59 <kfree>:

void 
kfree(void *ptr, size_t n) {
c0105f59:	55                   	push   %ebp
c0105f5a:	89 e5                	mov    %esp,%ebp
c0105f5c:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c0105f5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105f63:	74 09                	je     c0105f6e <kfree+0x15>
c0105f65:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0105f6c:	76 24                	jbe    c0105f92 <kfree+0x39>
c0105f6e:	c7 44 24 0c 5d a3 10 	movl   $0xc010a35d,0xc(%esp)
c0105f75:	c0 
c0105f76:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105f7d:	c0 
c0105f7e:	c7 44 24 04 b7 02 00 	movl   $0x2b7,0x4(%esp)
c0105f85:	00 
c0105f86:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105f8d:	e8 43 ad ff ff       	call   c0100cd5 <__panic>
    assert(ptr != NULL);
c0105f92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105f96:	75 24                	jne    c0105fbc <kfree+0x63>
c0105f98:	c7 44 24 0c 81 a3 10 	movl   $0xc010a381,0xc(%esp)
c0105f9f:	c0 
c0105fa0:	c7 44 24 08 09 9e 10 	movl   $0xc0109e09,0x8(%esp)
c0105fa7:	c0 
c0105fa8:	c7 44 24 04 b8 02 00 	movl   $0x2b8,0x4(%esp)
c0105faf:	00 
c0105fb0:	c7 04 24 e4 9d 10 c0 	movl   $0xc0109de4,(%esp)
c0105fb7:	e8 19 ad ff ff       	call   c0100cd5 <__panic>
    struct Page *base=NULL;
c0105fbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fc6:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105fcb:	c1 e8 0c             	shr    $0xc,%eax
c0105fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0105fd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fd4:	89 04 24             	mov    %eax,(%esp)
c0105fd7:	e8 17 e4 ff ff       	call   c01043f3 <kva2page>
c0105fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0105fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fe2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fe9:	89 04 24             	mov    %eax,(%esp)
c0105fec:	e8 fa e6 ff ff       	call   c01046eb <free_pages>
}
c0105ff1:	c9                   	leave  
c0105ff2:	c3                   	ret    

c0105ff3 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0105ff3:	55                   	push   %ebp
c0105ff4:	89 e5                	mov    %esp,%ebp
c0105ff6:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0105ff9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ffc:	c1 e8 0c             	shr    $0xc,%eax
c0105fff:	89 c2                	mov    %eax,%edx
c0106001:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c0106006:	39 c2                	cmp    %eax,%edx
c0106008:	72 1c                	jb     c0106026 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010600a:	c7 44 24 08 90 a3 10 	movl   $0xc010a390,0x8(%esp)
c0106011:	c0 
c0106012:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0106019:	00 
c010601a:	c7 04 24 af a3 10 c0 	movl   $0xc010a3af,(%esp)
c0106021:	e8 af ac ff ff       	call   c0100cd5 <__panic>
    }
    return &pages[PPN(pa)];
c0106026:	a1 f4 2a 12 c0       	mov    0xc0122af4,%eax
c010602b:	8b 55 08             	mov    0x8(%ebp),%edx
c010602e:	c1 ea 0c             	shr    $0xc,%edx
c0106031:	c1 e2 05             	shl    $0x5,%edx
c0106034:	01 d0                	add    %edx,%eax
}
c0106036:	c9                   	leave  
c0106037:	c3                   	ret    

c0106038 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106038:	55                   	push   %ebp
c0106039:	89 e5                	mov    %esp,%ebp
c010603b:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c010603e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106041:	83 e0 01             	and    $0x1,%eax
c0106044:	85 c0                	test   %eax,%eax
c0106046:	75 1c                	jne    c0106064 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106048:	c7 44 24 08 c0 a3 10 	movl   $0xc010a3c0,0x8(%esp)
c010604f:	c0 
c0106050:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106057:	00 
c0106058:	c7 04 24 af a3 10 c0 	movl   $0xc010a3af,(%esp)
c010605f:	e8 71 ac ff ff       	call   c0100cd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106064:	8b 45 08             	mov    0x8(%ebp),%eax
c0106067:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010606c:	89 04 24             	mov    %eax,(%esp)
c010606f:	e8 7f ff ff ff       	call   c0105ff3 <pa2page>
}
c0106074:	c9                   	leave  
c0106075:	c3                   	ret    

c0106076 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106076:	55                   	push   %ebp
c0106077:	89 e5                	mov    %esp,%ebp
c0106079:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c010607c:	e8 31 23 00 00       	call   c01083b2 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106081:	a1 9c 2b 12 c0       	mov    0xc0122b9c,%eax
c0106086:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c010608b:	76 0c                	jbe    c0106099 <swap_init+0x23>
c010608d:	a1 9c 2b 12 c0       	mov    0xc0122b9c,%eax
c0106092:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106097:	76 25                	jbe    c01060be <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106099:	a1 9c 2b 12 c0       	mov    0xc0122b9c,%eax
c010609e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01060a2:	c7 44 24 08 e1 a3 10 	movl   $0xc010a3e1,0x8(%esp)
c01060a9:	c0 
c01060aa:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
c01060b1:	00 
c01060b2:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c01060b9:	e8 17 ac ff ff       	call   c0100cd5 <__panic>
     }
     

     //sm = &swap_manager_fifo;
     sm = &swap_manager_extended_clock;
c01060be:	c7 05 d4 2a 12 c0 40 	movl   $0xc0121a40,0xc0122ad4
c01060c5:	1a 12 c0 
     int r = sm->init();
c01060c8:	a1 d4 2a 12 c0       	mov    0xc0122ad4,%eax
c01060cd:	8b 40 04             	mov    0x4(%eax),%eax
c01060d0:	ff d0                	call   *%eax
c01060d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01060d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01060d9:	75 26                	jne    c0106101 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c01060db:	c7 05 cc 2a 12 c0 01 	movl   $0x1,0xc0122acc
c01060e2:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01060e5:	a1 d4 2a 12 c0       	mov    0xc0122ad4,%eax
c01060ea:	8b 00                	mov    (%eax),%eax
c01060ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060f0:	c7 04 24 0b a4 10 c0 	movl   $0xc010a40b,(%esp)
c01060f7:	e8 4f a2 ff ff       	call   c010034b <cprintf>
          check_swap();
c01060fc:	e8 a4 04 00 00       	call   c01065a5 <check_swap>
     }

     return r;
c0106101:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106104:	c9                   	leave  
c0106105:	c3                   	ret    

c0106106 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106106:	55                   	push   %ebp
c0106107:	89 e5                	mov    %esp,%ebp
c0106109:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c010610c:	a1 d4 2a 12 c0       	mov    0xc0122ad4,%eax
c0106111:	8b 40 08             	mov    0x8(%eax),%eax
c0106114:	8b 55 08             	mov    0x8(%ebp),%edx
c0106117:	89 14 24             	mov    %edx,(%esp)
c010611a:	ff d0                	call   *%eax
}
c010611c:	c9                   	leave  
c010611d:	c3                   	ret    

c010611e <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c010611e:	55                   	push   %ebp
c010611f:	89 e5                	mov    %esp,%ebp
c0106121:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106124:	a1 d4 2a 12 c0       	mov    0xc0122ad4,%eax
c0106129:	8b 40 0c             	mov    0xc(%eax),%eax
c010612c:	8b 55 08             	mov    0x8(%ebp),%edx
c010612f:	89 14 24             	mov    %edx,(%esp)
c0106132:	ff d0                	call   *%eax
}
c0106134:	c9                   	leave  
c0106135:	c3                   	ret    

c0106136 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106136:	55                   	push   %ebp
c0106137:	89 e5                	mov    %esp,%ebp
c0106139:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c010613c:	a1 d4 2a 12 c0       	mov    0xc0122ad4,%eax
c0106141:	8b 40 10             	mov    0x10(%eax),%eax
c0106144:	8b 55 14             	mov    0x14(%ebp),%edx
c0106147:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010614b:	8b 55 10             	mov    0x10(%ebp),%edx
c010614e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106152:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106155:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106159:	8b 55 08             	mov    0x8(%ebp),%edx
c010615c:	89 14 24             	mov    %edx,(%esp)
c010615f:	ff d0                	call   *%eax
}
c0106161:	c9                   	leave  
c0106162:	c3                   	ret    

c0106163 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106163:	55                   	push   %ebp
c0106164:	89 e5                	mov    %esp,%ebp
c0106166:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106169:	a1 d4 2a 12 c0       	mov    0xc0122ad4,%eax
c010616e:	8b 40 14             	mov    0x14(%eax),%eax
c0106171:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106174:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106178:	8b 55 08             	mov    0x8(%ebp),%edx
c010617b:	89 14 24             	mov    %edx,(%esp)
c010617e:	ff d0                	call   *%eax
}
c0106180:	c9                   	leave  
c0106181:	c3                   	ret    

c0106182 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106182:	55                   	push   %ebp
c0106183:	89 e5                	mov    %esp,%ebp
c0106185:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106188:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010618f:	e9 5a 01 00 00       	jmp    c01062ee <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106194:	a1 d4 2a 12 c0       	mov    0xc0122ad4,%eax
c0106199:	8b 40 18             	mov    0x18(%eax),%eax
c010619c:	8b 55 10             	mov    0x10(%ebp),%edx
c010619f:	89 54 24 08          	mov    %edx,0x8(%esp)
c01061a3:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c01061a6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01061ad:	89 14 24             	mov    %edx,(%esp)
c01061b0:	ff d0                	call   *%eax
c01061b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01061b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01061b9:	74 18                	je     c01061d3 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01061bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061c2:	c7 04 24 20 a4 10 c0 	movl   $0xc010a420,(%esp)
c01061c9:	e8 7d a1 ff ff       	call   c010034b <cprintf>
c01061ce:	e9 27 01 00 00       	jmp    c01062fa <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c01061d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061d6:	8b 40 1c             	mov    0x1c(%eax),%eax
c01061d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c01061dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01061df:	8b 40 0c             	mov    0xc(%eax),%eax
c01061e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01061e9:	00 
c01061ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01061ed:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061f1:	89 04 24             	mov    %eax,(%esp)
c01061f4:	e8 e9 eb ff ff       	call   c0104de2 <get_pte>
c01061f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01061fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01061ff:	8b 00                	mov    (%eax),%eax
c0106201:	83 e0 01             	and    $0x1,%eax
c0106204:	85 c0                	test   %eax,%eax
c0106206:	75 24                	jne    c010622c <swap_out+0xaa>
c0106208:	c7 44 24 0c 4d a4 10 	movl   $0xc010a44d,0xc(%esp)
c010620f:	c0 
c0106210:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106217:	c0 
c0106218:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c010621f:	00 
c0106220:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106227:	e8 a9 aa ff ff       	call   c0100cd5 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c010622c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010622f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106232:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106235:	c1 ea 0c             	shr    $0xc,%edx
c0106238:	83 c2 01             	add    $0x1,%edx
c010623b:	c1 e2 08             	shl    $0x8,%edx
c010623e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106242:	89 14 24             	mov    %edx,(%esp)
c0106245:	e8 22 22 00 00       	call   c010846c <swapfs_write>
c010624a:	85 c0                	test   %eax,%eax
c010624c:	74 34                	je     c0106282 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c010624e:	c7 04 24 77 a4 10 c0 	movl   $0xc010a477,(%esp)
c0106255:	e8 f1 a0 ff ff       	call   c010034b <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c010625a:	a1 d4 2a 12 c0       	mov    0xc0122ad4,%eax
c010625f:	8b 40 10             	mov    0x10(%eax),%eax
c0106262:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106265:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010626c:	00 
c010626d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106271:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106274:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106278:	8b 55 08             	mov    0x8(%ebp),%edx
c010627b:	89 14 24             	mov    %edx,(%esp)
c010627e:	ff d0                	call   *%eax
c0106280:	eb 68                	jmp    c01062ea <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106285:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106288:	c1 e8 0c             	shr    $0xc,%eax
c010628b:	83 c0 01             	add    $0x1,%eax
c010628e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106292:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106295:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106299:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010629c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062a0:	c7 04 24 90 a4 10 c0 	movl   $0xc010a490,(%esp)
c01062a7:	e8 9f a0 ff ff       	call   c010034b <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c01062ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062af:	8b 40 1c             	mov    0x1c(%eax),%eax
c01062b2:	c1 e8 0c             	shr    $0xc,%eax
c01062b5:	83 c0 01             	add    $0x1,%eax
c01062b8:	c1 e0 08             	shl    $0x8,%eax
c01062bb:	89 c2                	mov    %eax,%edx
c01062bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01062c0:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01062c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062cc:	00 
c01062cd:	89 04 24             	mov    %eax,(%esp)
c01062d0:	e8 16 e4 ff ff       	call   c01046eb <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c01062d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01062d8:	8b 40 0c             	mov    0xc(%eax),%eax
c01062db:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01062de:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062e2:	89 04 24             	mov    %eax,(%esp)
c01062e5:	e8 ee ed ff ff       	call   c01050d8 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c01062ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01062ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01062f4:	0f 85 9a fe ff ff    	jne    c0106194 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c01062fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01062fd:	c9                   	leave  
c01062fe:	c3                   	ret    

c01062ff <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01062ff:	55                   	push   %ebp
c0106300:	89 e5                	mov    %esp,%ebp
c0106302:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106305:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010630c:	e8 6f e3 ff ff       	call   c0104680 <alloc_pages>
c0106311:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106318:	75 24                	jne    c010633e <swap_in+0x3f>
c010631a:	c7 44 24 0c d0 a4 10 	movl   $0xc010a4d0,0xc(%esp)
c0106321:	c0 
c0106322:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106329:	c0 
c010632a:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0106331:	00 
c0106332:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106339:	e8 97 a9 ff ff       	call   c0100cd5 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c010633e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106341:	8b 40 0c             	mov    0xc(%eax),%eax
c0106344:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010634b:	00 
c010634c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010634f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106353:	89 04 24             	mov    %eax,(%esp)
c0106356:	e8 87 ea ff ff       	call   c0104de2 <get_pte>
c010635b:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c010635e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106361:	8b 00                	mov    (%eax),%eax
c0106363:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106366:	89 54 24 04          	mov    %edx,0x4(%esp)
c010636a:	89 04 24             	mov    %eax,(%esp)
c010636d:	e8 88 20 00 00       	call   c01083fa <swapfs_read>
c0106372:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106375:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106379:	74 2a                	je     c01063a5 <swap_in+0xa6>
     {
        assert(r!=0);
c010637b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010637f:	75 24                	jne    c01063a5 <swap_in+0xa6>
c0106381:	c7 44 24 0c dd a4 10 	movl   $0xc010a4dd,0xc(%esp)
c0106388:	c0 
c0106389:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106390:	c0 
c0106391:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
c0106398:	00 
c0106399:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c01063a0:	e8 30 a9 ff ff       	call   c0100cd5 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01063a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01063a8:	8b 00                	mov    (%eax),%eax
c01063aa:	c1 e8 08             	shr    $0x8,%eax
c01063ad:	89 c2                	mov    %eax,%edx
c01063af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01063b2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01063b6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063ba:	c7 04 24 e4 a4 10 c0 	movl   $0xc010a4e4,(%esp)
c01063c1:	e8 85 9f ff ff       	call   c010034b <cprintf>
     *ptr_result=result;
c01063c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01063c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01063cc:	89 10                	mov    %edx,(%eax)
     return 0;
c01063ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01063d3:	c9                   	leave  
c01063d4:	c3                   	ret    

c01063d5 <check_content_set>:



static inline void
check_content_set(void)
{
c01063d5:	55                   	push   %ebp
c01063d6:	89 e5                	mov    %esp,%ebp
c01063d8:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01063db:	b8 00 10 00 00       	mov    $0x1000,%eax
c01063e0:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01063e3:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c01063e8:	83 f8 01             	cmp    $0x1,%eax
c01063eb:	74 24                	je     c0106411 <check_content_set+0x3c>
c01063ed:	c7 44 24 0c 22 a5 10 	movl   $0xc010a522,0xc(%esp)
c01063f4:	c0 
c01063f5:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c01063fc:	c0 
c01063fd:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0106404:	00 
c0106405:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c010640c:	e8 c4 a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106411:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106416:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106419:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c010641e:	83 f8 01             	cmp    $0x1,%eax
c0106421:	74 24                	je     c0106447 <check_content_set+0x72>
c0106423:	c7 44 24 0c 22 a5 10 	movl   $0xc010a522,0xc(%esp)
c010642a:	c0 
c010642b:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106432:	c0 
c0106433:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c010643a:	00 
c010643b:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106442:	e8 8e a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106447:	b8 00 20 00 00       	mov    $0x2000,%eax
c010644c:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010644f:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0106454:	83 f8 02             	cmp    $0x2,%eax
c0106457:	74 24                	je     c010647d <check_content_set+0xa8>
c0106459:	c7 44 24 0c 31 a5 10 	movl   $0xc010a531,0xc(%esp)
c0106460:	c0 
c0106461:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106468:	c0 
c0106469:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106470:	00 
c0106471:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106478:	e8 58 a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c010647d:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106482:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106485:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c010648a:	83 f8 02             	cmp    $0x2,%eax
c010648d:	74 24                	je     c01064b3 <check_content_set+0xde>
c010648f:	c7 44 24 0c 31 a5 10 	movl   $0xc010a531,0xc(%esp)
c0106496:	c0 
c0106497:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c010649e:	c0 
c010649f:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c01064a6:	00 
c01064a7:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c01064ae:	e8 22 a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c01064b3:	b8 00 30 00 00       	mov    $0x3000,%eax
c01064b8:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01064bb:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c01064c0:	83 f8 03             	cmp    $0x3,%eax
c01064c3:	74 24                	je     c01064e9 <check_content_set+0x114>
c01064c5:	c7 44 24 0c 40 a5 10 	movl   $0xc010a540,0xc(%esp)
c01064cc:	c0 
c01064cd:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c01064d4:	c0 
c01064d5:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c01064dc:	00 
c01064dd:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c01064e4:	e8 ec a7 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01064e9:	b8 10 30 00 00       	mov    $0x3010,%eax
c01064ee:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01064f1:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c01064f6:	83 f8 03             	cmp    $0x3,%eax
c01064f9:	74 24                	je     c010651f <check_content_set+0x14a>
c01064fb:	c7 44 24 0c 40 a5 10 	movl   $0xc010a540,0xc(%esp)
c0106502:	c0 
c0106503:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c010650a:	c0 
c010650b:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106512:	00 
c0106513:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c010651a:	e8 b6 a7 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c010651f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106524:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106527:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c010652c:	83 f8 04             	cmp    $0x4,%eax
c010652f:	74 24                	je     c0106555 <check_content_set+0x180>
c0106531:	c7 44 24 0c 4f a5 10 	movl   $0xc010a54f,0xc(%esp)
c0106538:	c0 
c0106539:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106540:	c0 
c0106541:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106548:	00 
c0106549:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106550:	e8 80 a7 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106555:	b8 10 40 00 00       	mov    $0x4010,%eax
c010655a:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c010655d:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0106562:	83 f8 04             	cmp    $0x4,%eax
c0106565:	74 24                	je     c010658b <check_content_set+0x1b6>
c0106567:	c7 44 24 0c 4f a5 10 	movl   $0xc010a54f,0xc(%esp)
c010656e:	c0 
c010656f:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106576:	c0 
c0106577:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c010657e:	00 
c010657f:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106586:	e8 4a a7 ff ff       	call   c0100cd5 <__panic>
}
c010658b:	c9                   	leave  
c010658c:	c3                   	ret    

c010658d <check_content_access>:

static inline int
check_content_access(void)
{
c010658d:	55                   	push   %ebp
c010658e:	89 e5                	mov    %esp,%ebp
c0106590:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106593:	a1 d4 2a 12 c0       	mov    0xc0122ad4,%eax
c0106598:	8b 40 1c             	mov    0x1c(%eax),%eax
c010659b:	ff d0                	call   *%eax
c010659d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c01065a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01065a3:	c9                   	leave  
c01065a4:	c3                   	ret    

c01065a5 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c01065a5:	55                   	push   %ebp
c01065a6:	89 e5                	mov    %esp,%ebp
c01065a8:	53                   	push   %ebx
c01065a9:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c01065ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01065b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c01065ba:	c7 45 e8 e0 2a 12 c0 	movl   $0xc0122ae0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01065c1:	eb 6b                	jmp    c010662e <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c01065c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01065c6:	83 e8 0c             	sub    $0xc,%eax
c01065c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c01065cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065cf:	83 c0 04             	add    $0x4,%eax
c01065d2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01065d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01065dc:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01065df:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01065e2:	0f a3 10             	bt     %edx,(%eax)
c01065e5:	19 c0                	sbb    %eax,%eax
c01065e7:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c01065ea:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01065ee:	0f 95 c0             	setne  %al
c01065f1:	0f b6 c0             	movzbl %al,%eax
c01065f4:	85 c0                	test   %eax,%eax
c01065f6:	75 24                	jne    c010661c <check_swap+0x77>
c01065f8:	c7 44 24 0c 5e a5 10 	movl   $0xc010a55e,0xc(%esp)
c01065ff:	c0 
c0106600:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106607:	c0 
c0106608:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c010660f:	00 
c0106610:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106617:	e8 b9 a6 ff ff       	call   c0100cd5 <__panic>
        count ++, total += p->property;
c010661c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106623:	8b 50 08             	mov    0x8(%eax),%edx
c0106626:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106629:	01 d0                	add    %edx,%eax
c010662b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010662e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106631:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106634:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106637:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c010663a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010663d:	81 7d e8 e0 2a 12 c0 	cmpl   $0xc0122ae0,-0x18(%ebp)
c0106644:	0f 85 79 ff ff ff    	jne    c01065c3 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c010664a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010664d:	e8 cb e0 ff ff       	call   c010471d <nr_free_pages>
c0106652:	39 c3                	cmp    %eax,%ebx
c0106654:	74 24                	je     c010667a <check_swap+0xd5>
c0106656:	c7 44 24 0c 6e a5 10 	movl   $0xc010a56e,0xc(%esp)
c010665d:	c0 
c010665e:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106665:	c0 
c0106666:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c010666d:	00 
c010666e:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106675:	e8 5b a6 ff ff       	call   c0100cd5 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c010667a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010667d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106681:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106684:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106688:	c7 04 24 88 a5 10 c0 	movl   $0xc010a588,(%esp)
c010668f:	e8 b7 9c ff ff       	call   c010034b <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106694:	e8 6c 0f 00 00       	call   c0107605 <mm_create>
c0106699:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c010669c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01066a0:	75 24                	jne    c01066c6 <check_swap+0x121>
c01066a2:	c7 44 24 0c ae a5 10 	movl   $0xc010a5ae,0xc(%esp)
c01066a9:	c0 
c01066aa:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c01066b1:	c0 
c01066b2:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c01066b9:	00 
c01066ba:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c01066c1:	e8 0f a6 ff ff       	call   c0100cd5 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c01066c6:	a1 cc 2b 12 c0       	mov    0xc0122bcc,%eax
c01066cb:	85 c0                	test   %eax,%eax
c01066cd:	74 24                	je     c01066f3 <check_swap+0x14e>
c01066cf:	c7 44 24 0c b9 a5 10 	movl   $0xc010a5b9,0xc(%esp)
c01066d6:	c0 
c01066d7:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c01066de:	c0 
c01066df:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c01066e6:	00 
c01066e7:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c01066ee:	e8 e2 a5 ff ff       	call   c0100cd5 <__panic>

     check_mm_struct = mm;
c01066f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066f6:	a3 cc 2b 12 c0       	mov    %eax,0xc0122bcc

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c01066fb:	8b 15 44 2a 12 c0    	mov    0xc0122a44,%edx
c0106701:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106704:	89 50 0c             	mov    %edx,0xc(%eax)
c0106707:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010670a:	8b 40 0c             	mov    0xc(%eax),%eax
c010670d:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106710:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106713:	8b 00                	mov    (%eax),%eax
c0106715:	85 c0                	test   %eax,%eax
c0106717:	74 24                	je     c010673d <check_swap+0x198>
c0106719:	c7 44 24 0c d1 a5 10 	movl   $0xc010a5d1,0xc(%esp)
c0106720:	c0 
c0106721:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106728:	c0 
c0106729:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0106730:	00 
c0106731:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106738:	e8 98 a5 ff ff       	call   c0100cd5 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c010673d:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106744:	00 
c0106745:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c010674c:	00 
c010674d:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106754:	e8 24 0f 00 00       	call   c010767d <vma_create>
c0106759:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c010675c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106760:	75 24                	jne    c0106786 <check_swap+0x1e1>
c0106762:	c7 44 24 0c df a5 10 	movl   $0xc010a5df,0xc(%esp)
c0106769:	c0 
c010676a:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106771:	c0 
c0106772:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0106779:	00 
c010677a:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106781:	e8 4f a5 ff ff       	call   c0100cd5 <__panic>

     insert_vma_struct(mm, vma);
c0106786:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106789:	89 44 24 04          	mov    %eax,0x4(%esp)
c010678d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106790:	89 04 24             	mov    %eax,(%esp)
c0106793:	e8 75 10 00 00       	call   c010780d <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106798:	c7 04 24 ec a5 10 c0 	movl   $0xc010a5ec,(%esp)
c010679f:	e8 a7 9b ff ff       	call   c010034b <cprintf>
     pte_t *temp_ptep=NULL;
c01067a4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c01067ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067ae:	8b 40 0c             	mov    0xc(%eax),%eax
c01067b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01067b8:	00 
c01067b9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01067c0:	00 
c01067c1:	89 04 24             	mov    %eax,(%esp)
c01067c4:	e8 19 e6 ff ff       	call   c0104de2 <get_pte>
c01067c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c01067cc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01067d0:	75 24                	jne    c01067f6 <check_swap+0x251>
c01067d2:	c7 44 24 0c 20 a6 10 	movl   $0xc010a620,0xc(%esp)
c01067d9:	c0 
c01067da:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c01067e1:	c0 
c01067e2:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01067e9:	00 
c01067ea:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c01067f1:	e8 df a4 ff ff       	call   c0100cd5 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01067f6:	c7 04 24 34 a6 10 c0 	movl   $0xc010a634,(%esp)
c01067fd:	e8 49 9b ff ff       	call   c010034b <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106802:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106809:	e9 a3 00 00 00       	jmp    c01068b1 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c010680e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106815:	e8 66 de ff ff       	call   c0104680 <alloc_pages>
c010681a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010681d:	89 04 95 00 2b 12 c0 	mov    %eax,-0x3fedd500(,%edx,4)
          assert(check_rp[i] != NULL );
c0106824:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106827:	8b 04 85 00 2b 12 c0 	mov    -0x3fedd500(,%eax,4),%eax
c010682e:	85 c0                	test   %eax,%eax
c0106830:	75 24                	jne    c0106856 <check_swap+0x2b1>
c0106832:	c7 44 24 0c 58 a6 10 	movl   $0xc010a658,0xc(%esp)
c0106839:	c0 
c010683a:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106841:	c0 
c0106842:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0106849:	00 
c010684a:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106851:	e8 7f a4 ff ff       	call   c0100cd5 <__panic>
          assert(!PageProperty(check_rp[i]));
c0106856:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106859:	8b 04 85 00 2b 12 c0 	mov    -0x3fedd500(,%eax,4),%eax
c0106860:	83 c0 04             	add    $0x4,%eax
c0106863:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c010686a:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010686d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106870:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106873:	0f a3 10             	bt     %edx,(%eax)
c0106876:	19 c0                	sbb    %eax,%eax
c0106878:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c010687b:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c010687f:	0f 95 c0             	setne  %al
c0106882:	0f b6 c0             	movzbl %al,%eax
c0106885:	85 c0                	test   %eax,%eax
c0106887:	74 24                	je     c01068ad <check_swap+0x308>
c0106889:	c7 44 24 0c 6c a6 10 	movl   $0xc010a66c,0xc(%esp)
c0106890:	c0 
c0106891:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106898:	c0 
c0106899:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01068a0:	00 
c01068a1:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c01068a8:	e8 28 a4 ff ff       	call   c0100cd5 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01068ad:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01068b1:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01068b5:	0f 8e 53 ff ff ff    	jle    c010680e <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c01068bb:	a1 e0 2a 12 c0       	mov    0xc0122ae0,%eax
c01068c0:	8b 15 e4 2a 12 c0    	mov    0xc0122ae4,%edx
c01068c6:	89 45 98             	mov    %eax,-0x68(%ebp)
c01068c9:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01068cc:	c7 45 a8 e0 2a 12 c0 	movl   $0xc0122ae0,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01068d3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01068d6:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01068d9:	89 50 04             	mov    %edx,0x4(%eax)
c01068dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01068df:	8b 50 04             	mov    0x4(%eax),%edx
c01068e2:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01068e5:	89 10                	mov    %edx,(%eax)
c01068e7:	c7 45 a4 e0 2a 12 c0 	movl   $0xc0122ae0,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01068ee:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01068f1:	8b 40 04             	mov    0x4(%eax),%eax
c01068f4:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c01068f7:	0f 94 c0             	sete   %al
c01068fa:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c01068fd:	85 c0                	test   %eax,%eax
c01068ff:	75 24                	jne    c0106925 <check_swap+0x380>
c0106901:	c7 44 24 0c 87 a6 10 	movl   $0xc010a687,0xc(%esp)
c0106908:	c0 
c0106909:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106910:	c0 
c0106911:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0106918:	00 
c0106919:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106920:	e8 b0 a3 ff ff       	call   c0100cd5 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106925:	a1 e8 2a 12 c0       	mov    0xc0122ae8,%eax
c010692a:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c010692d:	c7 05 e8 2a 12 c0 00 	movl   $0x0,0xc0122ae8
c0106934:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106937:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010693e:	eb 1e                	jmp    c010695e <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106940:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106943:	8b 04 85 00 2b 12 c0 	mov    -0x3fedd500(,%eax,4),%eax
c010694a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106951:	00 
c0106952:	89 04 24             	mov    %eax,(%esp)
c0106955:	e8 91 dd ff ff       	call   c01046eb <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010695a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010695e:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106962:	7e dc                	jle    c0106940 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106964:	a1 e8 2a 12 c0       	mov    0xc0122ae8,%eax
c0106969:	83 f8 04             	cmp    $0x4,%eax
c010696c:	74 24                	je     c0106992 <check_swap+0x3ed>
c010696e:	c7 44 24 0c a0 a6 10 	movl   $0xc010a6a0,0xc(%esp)
c0106975:	c0 
c0106976:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c010697d:	c0 
c010697e:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0106985:	00 
c0106986:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c010698d:	e8 43 a3 ff ff       	call   c0100cd5 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106992:	c7 04 24 c4 a6 10 c0 	movl   $0xc010a6c4,(%esp)
c0106999:	e8 ad 99 ff ff       	call   c010034b <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c010699e:	c7 05 d8 2a 12 c0 00 	movl   $0x0,0xc0122ad8
c01069a5:	00 00 00 
     
     check_content_set();
c01069a8:	e8 28 fa ff ff       	call   c01063d5 <check_content_set>
     assert( nr_free == 0);         
c01069ad:	a1 e8 2a 12 c0       	mov    0xc0122ae8,%eax
c01069b2:	85 c0                	test   %eax,%eax
c01069b4:	74 24                	je     c01069da <check_swap+0x435>
c01069b6:	c7 44 24 0c eb a6 10 	movl   $0xc010a6eb,0xc(%esp)
c01069bd:	c0 
c01069be:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c01069c5:	c0 
c01069c6:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c01069cd:	00 
c01069ce:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c01069d5:	e8 fb a2 ff ff       	call   c0100cd5 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01069da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01069e1:	eb 26                	jmp    c0106a09 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c01069e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069e6:	c7 04 85 20 2b 12 c0 	movl   $0xffffffff,-0x3fedd4e0(,%eax,4)
c01069ed:	ff ff ff ff 
c01069f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069f4:	8b 14 85 20 2b 12 c0 	mov    -0x3fedd4e0(,%eax,4),%edx
c01069fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069fe:	89 14 85 60 2b 12 c0 	mov    %edx,-0x3fedd4a0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106a05:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106a09:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106a0d:	7e d4                	jle    c01069e3 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106a0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106a16:	e9 eb 00 00 00       	jmp    c0106b06 <check_swap+0x561>
         check_ptep[i]=0;
c0106a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a1e:	c7 04 85 b4 2b 12 c0 	movl   $0x0,-0x3fedd44c(,%eax,4)
c0106a25:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a2c:	83 c0 01             	add    $0x1,%eax
c0106a2f:	c1 e0 0c             	shl    $0xc,%eax
c0106a32:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106a39:	00 
c0106a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106a3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a41:	89 04 24             	mov    %eax,(%esp)
c0106a44:	e8 99 e3 ff ff       	call   c0104de2 <get_pte>
c0106a49:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106a4c:	89 04 95 b4 2b 12 c0 	mov    %eax,-0x3fedd44c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a56:	8b 04 85 b4 2b 12 c0 	mov    -0x3fedd44c(,%eax,4),%eax
c0106a5d:	85 c0                	test   %eax,%eax
c0106a5f:	75 24                	jne    c0106a85 <check_swap+0x4e0>
c0106a61:	c7 44 24 0c f8 a6 10 	movl   $0xc010a6f8,0xc(%esp)
c0106a68:	c0 
c0106a69:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106a70:	c0 
c0106a71:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0106a78:	00 
c0106a79:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106a80:	e8 50 a2 ff ff       	call   c0100cd5 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a88:	8b 04 85 b4 2b 12 c0 	mov    -0x3fedd44c(,%eax,4),%eax
c0106a8f:	8b 00                	mov    (%eax),%eax
c0106a91:	89 04 24             	mov    %eax,(%esp)
c0106a94:	e8 9f f5 ff ff       	call   c0106038 <pte2page>
c0106a99:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106a9c:	8b 14 95 00 2b 12 c0 	mov    -0x3fedd500(,%edx,4),%edx
c0106aa3:	39 d0                	cmp    %edx,%eax
c0106aa5:	74 24                	je     c0106acb <check_swap+0x526>
c0106aa7:	c7 44 24 0c 10 a7 10 	movl   $0xc010a710,0xc(%esp)
c0106aae:	c0 
c0106aaf:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106ab6:	c0 
c0106ab7:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0106abe:	00 
c0106abf:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106ac6:	e8 0a a2 ff ff       	call   c0100cd5 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ace:	8b 04 85 b4 2b 12 c0 	mov    -0x3fedd44c(,%eax,4),%eax
c0106ad5:	8b 00                	mov    (%eax),%eax
c0106ad7:	83 e0 01             	and    $0x1,%eax
c0106ada:	85 c0                	test   %eax,%eax
c0106adc:	75 24                	jne    c0106b02 <check_swap+0x55d>
c0106ade:	c7 44 24 0c 38 a7 10 	movl   $0xc010a738,0xc(%esp)
c0106ae5:	c0 
c0106ae6:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106aed:	c0 
c0106aee:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0106af5:	00 
c0106af6:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106afd:	e8 d3 a1 ff ff       	call   c0100cd5 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b02:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106b06:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106b0a:	0f 8e 0b ff ff ff    	jle    c0106a1b <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0106b10:	c7 04 24 54 a7 10 c0 	movl   $0xc010a754,(%esp)
c0106b17:	e8 2f 98 ff ff       	call   c010034b <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106b1c:	e8 6c fa ff ff       	call   c010658d <check_content_access>
c0106b21:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0106b24:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106b28:	74 24                	je     c0106b4e <check_swap+0x5a9>
c0106b2a:	c7 44 24 0c 7a a7 10 	movl   $0xc010a77a,0xc(%esp)
c0106b31:	c0 
c0106b32:	c7 44 24 08 62 a4 10 	movl   $0xc010a462,0x8(%esp)
c0106b39:	c0 
c0106b3a:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0106b41:	00 
c0106b42:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106b49:	e8 87 a1 ff ff       	call   c0100cd5 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b4e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106b55:	eb 1e                	jmp    c0106b75 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0106b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b5a:	8b 04 85 00 2b 12 c0 	mov    -0x3fedd500(,%eax,4),%eax
c0106b61:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106b68:	00 
c0106b69:	89 04 24             	mov    %eax,(%esp)
c0106b6c:	e8 7a db ff ff       	call   c01046eb <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b71:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106b75:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106b79:	7e dc                	jle    c0106b57 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106b7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106b7e:	89 04 24             	mov    %eax,(%esp)
c0106b81:	e8 b7 0d 00 00       	call   c010793d <mm_destroy>
         
     nr_free = nr_free_store;
c0106b86:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106b89:	a3 e8 2a 12 c0       	mov    %eax,0xc0122ae8
     free_list = free_list_store;
c0106b8e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106b91:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106b94:	a3 e0 2a 12 c0       	mov    %eax,0xc0122ae0
c0106b99:	89 15 e4 2a 12 c0    	mov    %edx,0xc0122ae4

     
     le = &free_list;
c0106b9f:	c7 45 e8 e0 2a 12 c0 	movl   $0xc0122ae0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106ba6:	eb 1d                	jmp    c0106bc5 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0106ba8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106bab:	83 e8 0c             	sub    $0xc,%eax
c0106bae:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0106bb1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106bb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106bb8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106bbb:	8b 40 08             	mov    0x8(%eax),%eax
c0106bbe:	29 c2                	sub    %eax,%edx
c0106bc0:	89 d0                	mov    %edx,%eax
c0106bc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106bc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106bc8:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106bcb:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106bce:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106bd1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106bd4:	81 7d e8 e0 2a 12 c0 	cmpl   $0xc0122ae0,-0x18(%ebp)
c0106bdb:	75 cb                	jne    c0106ba8 <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106be0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106be7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106beb:	c7 04 24 81 a7 10 c0 	movl   $0xc010a781,(%esp)
c0106bf2:	e8 54 97 ff ff       	call   c010034b <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0106bf7:	c7 04 24 9b a7 10 c0 	movl   $0xc010a79b,(%esp)
c0106bfe:	e8 48 97 ff ff       	call   c010034b <cprintf>
}
c0106c03:	83 c4 74             	add    $0x74,%esp
c0106c06:	5b                   	pop    %ebx
c0106c07:	5d                   	pop    %ebp
c0106c08:	c3                   	ret    

c0106c09 <_extended_clock_init_mm>:

list_entry_t pra_list_head;

static int
_extended_clock_init_mm(struct mm_struct *mm)
{
c0106c09:	55                   	push   %ebp
c0106c0a:	89 e5                	mov    %esp,%ebp
c0106c0c:	83 ec 10             	sub    $0x10,%esp
c0106c0f:	c7 45 fc c4 2b 12 c0 	movl   $0xc0122bc4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106c16:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c19:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106c1c:	89 50 04             	mov    %edx,0x4(%eax)
c0106c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c22:	8b 50 04             	mov    0x4(%eax),%edx
c0106c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c28:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106c2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c2d:	c7 40 14 c4 2b 12 c0 	movl   $0xc0122bc4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106c34:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106c39:	c9                   	leave  
c0106c3a:	c3                   	ret    

c0106c3b <_extended_clock_map_swappable>:

static int
_extended_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106c3b:	55                   	push   %ebp
c0106c3c:	89 e5                	mov    %esp,%ebp
c0106c3e:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106c41:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c44:	8b 40 14             	mov    0x14(%eax),%eax
c0106c47:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106c4a:	8b 45 10             	mov    0x10(%ebp),%eax
c0106c4d:	83 c0 14             	add    $0x14,%eax
c0106c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(entry != NULL && head != NULL);
c0106c53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106c57:	74 06                	je     c0106c5f <_extended_clock_map_swappable+0x24>
c0106c59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106c5d:	75 24                	jne    c0106c83 <_extended_clock_map_swappable+0x48>
c0106c5f:	c7 44 24 0c b4 a7 10 	movl   $0xc010a7b4,0xc(%esp)
c0106c66:	c0 
c0106c67:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c0106c6e:	c0 
c0106c6f:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0106c76:	00 
c0106c77:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c0106c7e:	e8 52 a0 ff ff       	call   c0100cd5 <__panic>
c0106c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106c8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c92:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106c95:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c98:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0106c9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c9e:	8b 40 04             	mov    0x4(%eax),%eax
c0106ca1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106ca4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106ca7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106caa:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0106cad:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0106cb0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106cb3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106cb6:	89 10                	mov    %edx,(%eax)
c0106cb8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106cbb:	8b 10                	mov    (%eax),%edx
c0106cbd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106cc0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106cc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106cc6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106cc9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106ccc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106ccf:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106cd2:	89 10                	mov    %edx,(%eax)

    list_add(head, entry);
    // 初始访问位和修改位均置0
    struct Page *ptr = le2page(entry, pra_page_link);
c0106cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106cd7:	83 e8 14             	sub    $0x14,%eax
c0106cda:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pte_t *pte = get_pte(mm -> pgdir, ptr -> pra_vaddr, 0);
c0106cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ce0:	8b 50 1c             	mov    0x1c(%eax),%edx
c0106ce3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ce6:	8b 40 0c             	mov    0xc(%eax),%eax
c0106ce9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106cf0:	00 
c0106cf1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106cf5:	89 04 24             	mov    %eax,(%esp)
c0106cf8:	e8 e5 e0 ff ff       	call   c0104de2 <get_pte>
c0106cfd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // 将PTE_A（访问位）和PTE_D（读写位）置0
    *pte &= ~PTE_D;
c0106d00:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d03:	8b 00                	mov    (%eax),%eax
c0106d05:	83 e0 bf             	and    $0xffffffbf,%eax
c0106d08:	89 c2                	mov    %eax,%edx
c0106d0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d0d:	89 10                	mov    %edx,(%eax)
    *pte &= ~PTE_A;
c0106d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d12:	8b 00                	mov    (%eax),%eax
c0106d14:	83 e0 df             	and    $0xffffffdf,%eax
c0106d17:	89 c2                	mov    %eax,%edx
c0106d19:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d1c:	89 10                	mov    %edx,(%eax)
    return 0;
c0106d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d23:	c9                   	leave  
c0106d24:	c3                   	ret    

c0106d25 <_extended_clock_swap_out_victim>:


static int
_extended_clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106d25:	55                   	push   %ebp
c0106d26:	89 e5                	mov    %esp,%ebp
c0106d28:	83 ec 38             	sub    $0x38,%esp
	// 两个指针，一个指向头，一个指向尾
    list_entry_t *head = (list_entry_t*)mm->sm_priv;
c0106d2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d2e:	8b 40 14             	mov    0x14(%eax),%eax
c0106d31:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(head != NULL);
c0106d34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106d38:	75 24                	jne    c0106d5e <_extended_clock_swap_out_victim+0x39>
c0106d3a:	c7 44 24 0c 05 a8 10 	movl   $0xc010a805,0xc(%esp)
c0106d41:	c0 
c0106d42:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c0106d49:	c0 
c0106d4a:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
c0106d51:	00 
c0106d52:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c0106d59:	e8 77 9f ff ff       	call   c0100cd5 <__panic>
    assert(in_tick == 0);
c0106d5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106d62:	74 24                	je     c0106d88 <_extended_clock_swap_out_victim+0x63>
c0106d64:	c7 44 24 0c 12 a8 10 	movl   $0xc010a812,0xc(%esp)
c0106d6b:	c0 
c0106d6c:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c0106d73:	c0 
c0106d74:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
c0106d7b:	00 
c0106d7c:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c0106d83:	e8 4d 9f ff ff       	call   c0100cd5 <__panic>
    list_entry_t *tail = head->prev;
c0106d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d8b:	8b 00                	mov    (%eax),%eax
c0106d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(head != tail);
c0106d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106d96:	75 24                	jne    c0106dbc <_extended_clock_swap_out_victim+0x97>
c0106d98:	c7 44 24 0c 1f a8 10 	movl   $0xc010a81f,0xc(%esp)
c0106d9f:	c0 
c0106da0:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c0106da7:	c0 
c0106da8:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
c0106daf:	00 
c0106db0:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c0106db7:	e8 19 9f ff ff       	call   c0100cd5 <__panic>

    // 怎么实现指针旋转的？答案是通过tail指针不断向前移动，直到tail == head时终止
    // 实现extended clock算法（参考：《现代操作系统P115页》）
    int i;
    for (i = 0; i < 3; i ++) {
c0106dbc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0106dc3:	e9 f1 00 00 00       	jmp    c0106eb9 <_extended_clock_swap_out_victim+0x194>
        while (tail != head) {
c0106dc8:	e9 d4 00 00 00       	jmp    c0106ea1 <_extended_clock_swap_out_victim+0x17c>
            struct Page *page = le2page(tail, pra_page_link);
c0106dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106dd0:	83 e8 14             	sub    $0x14,%eax
c0106dd3:	89 45 e8             	mov    %eax,-0x18(%ebp)
            pte_t *ptep = get_pte(mm->pgdir, page->pra_vaddr, 0);
c0106dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106dd9:	8b 50 1c             	mov    0x1c(%eax),%edx
c0106ddc:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ddf:	8b 40 0c             	mov    0xc(%eax),%eax
c0106de2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106de9:	00 
c0106dea:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106dee:	89 04 24             	mov    %eax,(%esp)
c0106df1:	e8 ec df ff ff       	call   c0104de2 <get_pte>
c0106df6:	89 45 e4             	mov    %eax,-0x1c(%ebp)

            // 第一类情况 访问位和修改位都是0 意味着没有访问也没有被修改 应最先被置换出去，该置换函数也只将第一类情况置换出去
            if (!(*ptep & PTE_A) && !(*ptep & PTE_D)) {
c0106df9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106dfc:	8b 00                	mov    (%eax),%eax
c0106dfe:	83 e0 20             	and    $0x20,%eax
c0106e01:	85 c0                	test   %eax,%eax
c0106e03:	75 43                	jne    c0106e48 <_extended_clock_swap_out_victim+0x123>
c0106e05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e08:	8b 00                	mov    (%eax),%eax
c0106e0a:	83 e0 40             	and    $0x40,%eax
c0106e0d:	85 c0                	test   %eax,%eax
c0106e0f:	75 37                	jne    c0106e48 <_extended_clock_swap_out_victim+0x123>
c0106e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e14:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0106e17:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e1a:	8b 40 04             	mov    0x4(%eax),%eax
c0106e1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106e20:	8b 12                	mov    (%edx),%edx
c0106e22:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106e25:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0106e28:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106e2b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106e2e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106e31:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106e34:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106e37:	89 10                	mov    %edx,(%eax)
                list_del(tail);
                *ptr_page = page;
c0106e39:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106e3f:	89 10                	mov    %edx,(%eax)
                return 0;
c0106e41:	b8 00 00 00 00       	mov    $0x0,%eax
c0106e46:	eb 7b                	jmp    c0106ec3 <_extended_clock_swap_out_victim+0x19e>
            }
            // (PTE_D, PTE_A) = 1, 0或者是0, 1
            if ((*ptep & PTE_A) ^ (*ptep & PTE_D)) {
c0106e48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e4b:	8b 00                	mov    (%eax),%eax
c0106e4d:	83 e0 60             	and    $0x60,%eax
c0106e50:	85 c0                	test   %eax,%eax
c0106e52:	74 1e                	je     c0106e72 <_extended_clock_swap_out_victim+0x14d>
                // 访问位和修改位都置0,可参考word笔记
            	*ptep &= ~PTE_D;
c0106e54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e57:	8b 00                	mov    (%eax),%eax
c0106e59:	83 e0 bf             	and    $0xffffffbf,%eax
c0106e5c:	89 c2                	mov    %eax,%edx
c0106e5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e61:	89 10                	mov    %edx,(%eax)
                *ptep &= ~PTE_A;
c0106e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e66:	8b 00                	mov    (%eax),%eax
c0106e68:	83 e0 df             	and    $0xffffffdf,%eax
c0106e6b:	89 c2                	mov    %eax,%edx
c0106e6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e70:	89 10                	mov    %edx,(%eax)
            }
            // (PTE_D, PTE_A) = (1,1)
            if ((*ptep & PTE_A) && (*ptep & PTE_D)) {
c0106e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e75:	8b 00                	mov    (%eax),%eax
c0106e77:	83 e0 20             	and    $0x20,%eax
c0106e7a:	85 c0                	test   %eax,%eax
c0106e7c:	74 1b                	je     c0106e99 <_extended_clock_swap_out_victim+0x174>
c0106e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e81:	8b 00                	mov    (%eax),%eax
c0106e83:	83 e0 40             	and    $0x40,%eax
c0106e86:	85 c0                	test   %eax,%eax
c0106e88:	74 0f                	je     c0106e99 <_extended_clock_swap_out_victim+0x174>
            	// 访问了 所以访问位要置0
                *ptep &= ~PTE_A;
c0106e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e8d:	8b 00                	mov    (%eax),%eax
c0106e8f:	83 e0 df             	and    $0xffffffdf,%eax
c0106e92:	89 c2                	mov    %eax,%edx
c0106e94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e97:	89 10                	mov    %edx,(%eax)
            }
            tail = tail->prev;
c0106e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e9c:	8b 00                	mov    (%eax),%eax
c0106e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)

    // 怎么实现指针旋转的？答案是通过tail指针不断向前移动，直到tail == head时终止
    // 实现extended clock算法（参考：《现代操作系统P115页》）
    int i;
    for (i = 0; i < 3; i ++) {
        while (tail != head) {
c0106ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ea4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106ea7:	0f 85 20 ff ff ff    	jne    c0106dcd <_extended_clock_swap_out_victim+0xa8>
            	// 访问了 所以访问位要置0
                *ptep &= ~PTE_A;
            }
            tail = tail->prev;
        }
        tail = tail->prev;
c0106ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106eb0:	8b 00                	mov    (%eax),%eax
c0106eb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(head != tail);

    // 怎么实现指针旋转的？答案是通过tail指针不断向前移动，直到tail == head时终止
    // 实现extended clock算法（参考：《现代操作系统P115页》）
    int i;
    for (i = 0; i < 3; i ++) {
c0106eb5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0106eb9:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
c0106ebd:	0f 8e 05 ff ff ff    	jle    c0106dc8 <_extended_clock_swap_out_victim+0xa3>
            }
            tail = tail->prev;
        }
        tail = tail->prev;
    }
}
c0106ec3:	c9                   	leave  
c0106ec4:	c3                   	ret    

c0106ec5 <_extended_clock_check_swap>:

static int
_extended_clock_check_swap(void) {
c0106ec5:	55                   	push   %ebp
c0106ec6:	89 e5                	mov    %esp,%ebp
c0106ec8:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in extended_clock_check_swap\n");
c0106ecb:	c7 04 24 2c a8 10 c0 	movl   $0xc010a82c,(%esp)
c0106ed2:	e8 74 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106ed7:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106edc:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106edf:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0106ee4:	83 f8 04             	cmp    $0x4,%eax
c0106ee7:	74 24                	je     c0106f0d <_extended_clock_check_swap+0x48>
c0106ee9:	c7 44 24 0c 5c a8 10 	movl   $0xc010a85c,0xc(%esp)
c0106ef0:	c0 
c0106ef1:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c0106ef8:	c0 
c0106ef9:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
c0106f00:	00 
c0106f01:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c0106f08:	e8 c8 9d ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page a in extended_clock_check_swap\n");
c0106f0d:	c7 04 24 6c a8 10 c0 	movl   $0xc010a86c,(%esp)
c0106f14:	e8 32 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106f19:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106f1e:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0106f21:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0106f26:	83 f8 04             	cmp    $0x4,%eax
c0106f29:	74 24                	je     c0106f4f <_extended_clock_check_swap+0x8a>
c0106f2b:	c7 44 24 0c 5c a8 10 	movl   $0xc010a85c,0xc(%esp)
c0106f32:	c0 
c0106f33:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c0106f3a:	c0 
c0106f3b:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c0106f42:	00 
c0106f43:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c0106f4a:	e8 86 9d ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page d in extended_clock_check_swap\n");
c0106f4f:	c7 04 24 9c a8 10 c0 	movl   $0xc010a89c,(%esp)
c0106f56:	e8 f0 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106f5b:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106f60:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106f63:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0106f68:	83 f8 04             	cmp    $0x4,%eax
c0106f6b:	74 24                	je     c0106f91 <_extended_clock_check_swap+0xcc>
c0106f6d:	c7 44 24 0c 5c a8 10 	movl   $0xc010a85c,0xc(%esp)
c0106f74:	c0 
c0106f75:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c0106f7c:	c0 
c0106f7d:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
c0106f84:	00 
c0106f85:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c0106f8c:	e8 44 9d ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page b in extended_clock_check_swap\n");
c0106f91:	c7 04 24 cc a8 10 c0 	movl   $0xc010a8cc,(%esp)
c0106f98:	e8 ae 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106f9d:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106fa2:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106fa5:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0106faa:	83 f8 04             	cmp    $0x4,%eax
c0106fad:	74 24                	je     c0106fd3 <_extended_clock_check_swap+0x10e>
c0106faf:	c7 44 24 0c 5c a8 10 	movl   $0xc010a85c,0xc(%esp)
c0106fb6:	c0 
c0106fb7:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c0106fbe:	c0 
c0106fbf:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
c0106fc6:	00 
c0106fc7:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c0106fce:	e8 02 9d ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page e in extended_clock_check_swap\n");
c0106fd3:	c7 04 24 fc a8 10 c0 	movl   $0xc010a8fc,(%esp)
c0106fda:	e8 6c 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0106fdf:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106fe4:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0106fe7:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0106fec:	83 f8 05             	cmp    $0x5,%eax
c0106fef:	74 24                	je     c0107015 <_extended_clock_check_swap+0x150>
c0106ff1:	c7 44 24 0c 2c a9 10 	movl   $0xc010a92c,0xc(%esp)
c0106ff8:	c0 
c0106ff9:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c0107000:	c0 
c0107001:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0107008:	00 
c0107009:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c0107010:	e8 c0 9c ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page b in extended_clock_check_swap\n");
c0107015:	c7 04 24 cc a8 10 c0 	movl   $0xc010a8cc,(%esp)
c010701c:	e8 2a 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107021:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107026:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107029:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c010702e:	83 f8 05             	cmp    $0x5,%eax
c0107031:	74 24                	je     c0107057 <_extended_clock_check_swap+0x192>
c0107033:	c7 44 24 0c 2c a9 10 	movl   $0xc010a92c,0xc(%esp)
c010703a:	c0 
c010703b:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c0107042:	c0 
c0107043:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c010704a:	00 
c010704b:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c0107052:	e8 7e 9c ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page a in extended_clock_check_swap\n");
c0107057:	c7 04 24 6c a8 10 c0 	movl   $0xc010a86c,(%esp)
c010705e:	e8 e8 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107063:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107068:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c010706b:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0107070:	83 f8 06             	cmp    $0x6,%eax
c0107073:	74 24                	je     c0107099 <_extended_clock_check_swap+0x1d4>
c0107075:	c7 44 24 0c 3b a9 10 	movl   $0xc010a93b,0xc(%esp)
c010707c:	c0 
c010707d:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c0107084:	c0 
c0107085:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c010708c:	00 
c010708d:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c0107094:	e8 3c 9c ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page b in extended_clock_check_swap\n");
c0107099:	c7 04 24 cc a8 10 c0 	movl   $0xc010a8cc,(%esp)
c01070a0:	e8 a6 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01070a5:	b8 00 20 00 00       	mov    $0x2000,%eax
c01070aa:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==6);
c01070ad:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c01070b2:	83 f8 06             	cmp    $0x6,%eax
c01070b5:	74 24                	je     c01070db <_extended_clock_check_swap+0x216>
c01070b7:	c7 44 24 0c 3b a9 10 	movl   $0xc010a93b,0xc(%esp)
c01070be:	c0 
c01070bf:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c01070c6:	c0 
c01070c7:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c01070ce:	00 
c01070cf:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c01070d6:	e8 fa 9b ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page c in extended_clock_check_swap\n");
c01070db:	c7 04 24 2c a8 10 c0 	movl   $0xc010a82c,(%esp)
c01070e2:	e8 64 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01070e7:	b8 00 30 00 00       	mov    $0x3000,%eax
c01070ec:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==7);
c01070ef:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c01070f4:	83 f8 07             	cmp    $0x7,%eax
c01070f7:	74 24                	je     c010711d <_extended_clock_check_swap+0x258>
c01070f9:	c7 44 24 0c 4a a9 10 	movl   $0xc010a94a,0xc(%esp)
c0107100:	c0 
c0107101:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c0107108:	c0 
c0107109:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0107110:	00 
c0107111:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c0107118:	e8 b8 9b ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page d in extended_clock_check_swap\n");
c010711d:	c7 04 24 9c a8 10 c0 	movl   $0xc010a89c,(%esp)
c0107124:	e8 22 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107129:	b8 00 40 00 00       	mov    $0x4000,%eax
c010712e:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==8);
c0107131:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0107136:	83 f8 08             	cmp    $0x8,%eax
c0107139:	74 24                	je     c010715f <_extended_clock_check_swap+0x29a>
c010713b:	c7 44 24 0c 59 a9 10 	movl   $0xc010a959,0xc(%esp)
c0107142:	c0 
c0107143:	c7 44 24 08 d2 a7 10 	movl   $0xc010a7d2,0x8(%esp)
c010714a:	c0 
c010714b:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
c0107152:	00 
c0107153:	c7 04 24 e7 a7 10 c0 	movl   $0xc010a7e7,(%esp)
c010715a:	e8 76 9b ff ff       	call   c0100cd5 <__panic>
    return 0;
c010715f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107164:	c9                   	leave  
c0107165:	c3                   	ret    

c0107166 <_extended_clock_init>:

static int
_extended_clock_init(void)
{
c0107166:	55                   	push   %ebp
c0107167:	89 e5                	mov    %esp,%ebp
    return 0;
c0107169:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010716e:	5d                   	pop    %ebp
c010716f:	c3                   	ret    

c0107170 <_extended_clock_set_unswappable>:

static int
_extended_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107170:	55                   	push   %ebp
c0107171:	89 e5                	mov    %esp,%ebp
    return 0;
c0107173:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107178:	5d                   	pop    %ebp
c0107179:	c3                   	ret    

c010717a <_extended_clock_tick_event>:

static int
_extended_clock_tick_event(struct mm_struct *mm)
{ return 0; }
c010717a:	55                   	push   %ebp
c010717b:	89 e5                	mov    %esp,%ebp
c010717d:	b8 00 00 00 00       	mov    $0x0,%eax
c0107182:	5d                   	pop    %ebp
c0107183:	c3                   	ret    

c0107184 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0107184:	55                   	push   %ebp
c0107185:	89 e5                	mov    %esp,%ebp
c0107187:	83 ec 10             	sub    $0x10,%esp
c010718a:	c7 45 fc c4 2b 12 c0 	movl   $0xc0122bc4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107191:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107194:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107197:	89 50 04             	mov    %edx,0x4(%eax)
c010719a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010719d:	8b 50 04             	mov    0x4(%eax),%edx
c01071a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01071a3:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c01071a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01071a8:	c7 40 14 c4 2b 12 c0 	movl   $0xc0122bc4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c01071af:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01071b4:	c9                   	leave  
c01071b5:	c3                   	ret    

c01071b6 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01071b6:	55                   	push   %ebp
c01071b7:	89 e5                	mov    %esp,%ebp
c01071b9:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01071bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01071bf:	8b 40 14             	mov    0x14(%eax),%eax
c01071c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c01071c5:	8b 45 10             	mov    0x10(%ebp),%eax
c01071c8:	83 c0 14             	add    $0x14,%eax
c01071cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c01071ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01071d2:	74 06                	je     c01071da <_fifo_map_swappable+0x24>
c01071d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071d8:	75 24                	jne    c01071fe <_fifo_map_swappable+0x48>
c01071da:	c7 44 24 0c 84 a9 10 	movl   $0xc010a984,0xc(%esp)
c01071e1:	c0 
c01071e2:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c01071e9:	c0 
c01071ea:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c01071f1:	00 
c01071f2:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c01071f9:	e8 d7 9a ff ff       	call   c0100cd5 <__panic>
c01071fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107201:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107204:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107207:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010720a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010720d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107210:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107213:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107219:	8b 40 04             	mov    0x4(%eax),%eax
c010721c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010721f:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0107222:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107225:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0107228:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010722b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010722e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107231:	89 10                	mov    %edx,(%eax)
c0107233:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107236:	8b 10                	mov    (%eax),%edx
c0107238:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010723b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010723e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107241:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107244:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107247:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010724a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010724d:	89 10                	mov    %edx,(%eax)
    //record the page access situlation（情况）
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    // 在头部插入
    list_add(head, entry);				// 用list_add()和list_add_after()都行，查看下这个双向链表的操作函数（在list.h）就知道了。
    return 0;
c010724f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107254:	c9                   	leave  
c0107255:	c3                   	ret    

c0107256 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0107256:	55                   	push   %ebp
c0107257:	89 e5                	mov    %esp,%ebp
c0107259:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c010725c:	8b 45 08             	mov    0x8(%ebp),%eax
c010725f:	8b 40 14             	mov    0x14(%eax),%eax
c0107262:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0107265:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107269:	75 24                	jne    c010728f <_fifo_swap_out_victim+0x39>
c010726b:	c7 44 24 0c cb a9 10 	movl   $0xc010a9cb,0xc(%esp)
c0107272:	c0 
c0107273:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c010727a:	c0 
c010727b:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0107282:	00 
c0107283:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c010728a:	e8 46 9a ff ff       	call   c0100cd5 <__panic>
     assert(in_tick==0);
c010728f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107293:	74 24                	je     c01072b9 <_fifo_swap_out_victim+0x63>
c0107295:	c7 44 24 0c d8 a9 10 	movl   $0xc010a9d8,0xc(%esp)
c010729c:	c0 
c010729d:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c01072a4:	c0 
c01072a5:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
c01072ac:	00 
c01072ad:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c01072b4:	e8 1c 9a ff ff       	call   c0100cd5 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     // 尾部删除，因为是双向链表，所以很方便找到尾部
     // tail指向尾部
     list_entry_t *tail = head->prev;
c01072b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072bc:	8b 00                	mov    (%eax),%eax
c01072be:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page *page = le2page(tail, pra_page_link);
c01072c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072c4:	83 e8 14             	sub    $0x14,%eax
c01072c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01072ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01072d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072d3:	8b 40 04             	mov    0x4(%eax),%eax
c01072d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01072d9:	8b 12                	mov    (%edx),%edx
c01072db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01072de:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01072e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01072e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01072e7:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01072ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01072ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01072f0:	89 10                	mov    %edx,(%eax)
     list_del(tail);
     //(2)  set the addr of addr of this page to ptr_page
     *ptr_page = page;
c01072f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01072f8:	89 10                	mov    %edx,(%eax)
     return 0;
c01072fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01072ff:	c9                   	leave  
c0107300:	c3                   	ret    

c0107301 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0107301:	55                   	push   %ebp
c0107302:	89 e5                	mov    %esp,%ebp
c0107304:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107307:	c7 04 24 e4 a9 10 c0 	movl   $0xc010a9e4,(%esp)
c010730e:	e8 38 90 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107313:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107318:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c010731b:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0107320:	83 f8 04             	cmp    $0x4,%eax
c0107323:	74 24                	je     c0107349 <_fifo_check_swap+0x48>
c0107325:	c7 44 24 0c 0a aa 10 	movl   $0xc010aa0a,0xc(%esp)
c010732c:	c0 
c010732d:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c0107334:	c0 
c0107335:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c010733c:	00 
c010733d:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c0107344:	e8 8c 99 ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107349:	c7 04 24 1c aa 10 c0 	movl   $0xc010aa1c,(%esp)
c0107350:	e8 f6 8f ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107355:	b8 00 10 00 00       	mov    $0x1000,%eax
c010735a:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c010735d:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0107362:	83 f8 04             	cmp    $0x4,%eax
c0107365:	74 24                	je     c010738b <_fifo_check_swap+0x8a>
c0107367:	c7 44 24 0c 0a aa 10 	movl   $0xc010aa0a,0xc(%esp)
c010736e:	c0 
c010736f:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c0107376:	c0 
c0107377:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c010737e:	00 
c010737f:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c0107386:	e8 4a 99 ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c010738b:	c7 04 24 44 aa 10 c0 	movl   $0xc010aa44,(%esp)
c0107392:	e8 b4 8f ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107397:	b8 00 40 00 00       	mov    $0x4000,%eax
c010739c:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c010739f:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c01073a4:	83 f8 04             	cmp    $0x4,%eax
c01073a7:	74 24                	je     c01073cd <_fifo_check_swap+0xcc>
c01073a9:	c7 44 24 0c 0a aa 10 	movl   $0xc010aa0a,0xc(%esp)
c01073b0:	c0 
c01073b1:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c01073b8:	c0 
c01073b9:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01073c0:	00 
c01073c1:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c01073c8:	e8 08 99 ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01073cd:	c7 04 24 6c aa 10 c0 	movl   $0xc010aa6c,(%esp)
c01073d4:	e8 72 8f ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01073d9:	b8 00 20 00 00       	mov    $0x2000,%eax
c01073de:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c01073e1:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c01073e6:	83 f8 04             	cmp    $0x4,%eax
c01073e9:	74 24                	je     c010740f <_fifo_check_swap+0x10e>
c01073eb:	c7 44 24 0c 0a aa 10 	movl   $0xc010aa0a,0xc(%esp)
c01073f2:	c0 
c01073f3:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c01073fa:	c0 
c01073fb:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107402:	00 
c0107403:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c010740a:	e8 c6 98 ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c010740f:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0107416:	e8 30 8f ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c010741b:	b8 00 50 00 00       	mov    $0x5000,%eax
c0107420:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0107423:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0107428:	83 f8 05             	cmp    $0x5,%eax
c010742b:	74 24                	je     c0107451 <_fifo_check_swap+0x150>
c010742d:	c7 44 24 0c ba aa 10 	movl   $0xc010aaba,0xc(%esp)
c0107434:	c0 
c0107435:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c010743c:	c0 
c010743d:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0107444:	00 
c0107445:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c010744c:	e8 84 98 ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107451:	c7 04 24 6c aa 10 c0 	movl   $0xc010aa6c,(%esp)
c0107458:	e8 ee 8e ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010745d:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107462:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107465:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c010746a:	83 f8 05             	cmp    $0x5,%eax
c010746d:	74 24                	je     c0107493 <_fifo_check_swap+0x192>
c010746f:	c7 44 24 0c ba aa 10 	movl   $0xc010aaba,0xc(%esp)
c0107476:	c0 
c0107477:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c010747e:	c0 
c010747f:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0107486:	00 
c0107487:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c010748e:	e8 42 98 ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107493:	c7 04 24 1c aa 10 c0 	movl   $0xc010aa1c,(%esp)
c010749a:	e8 ac 8e ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c010749f:	b8 00 10 00 00       	mov    $0x1000,%eax
c01074a4:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c01074a7:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c01074ac:	83 f8 06             	cmp    $0x6,%eax
c01074af:	74 24                	je     c01074d5 <_fifo_check_swap+0x1d4>
c01074b1:	c7 44 24 0c c9 aa 10 	movl   $0xc010aac9,0xc(%esp)
c01074b8:	c0 
c01074b9:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c01074c0:	c0 
c01074c1:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01074c8:	00 
c01074c9:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c01074d0:	e8 00 98 ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01074d5:	c7 04 24 6c aa 10 c0 	movl   $0xc010aa6c,(%esp)
c01074dc:	e8 6a 8e ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01074e1:	b8 00 20 00 00       	mov    $0x2000,%eax
c01074e6:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c01074e9:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c01074ee:	83 f8 07             	cmp    $0x7,%eax
c01074f1:	74 24                	je     c0107517 <_fifo_check_swap+0x216>
c01074f3:	c7 44 24 0c d8 aa 10 	movl   $0xc010aad8,0xc(%esp)
c01074fa:	c0 
c01074fb:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c0107502:	c0 
c0107503:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010750a:	00 
c010750b:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c0107512:	e8 be 97 ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107517:	c7 04 24 e4 a9 10 c0 	movl   $0xc010a9e4,(%esp)
c010751e:	e8 28 8e ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107523:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107528:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c010752b:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0107530:	83 f8 08             	cmp    $0x8,%eax
c0107533:	74 24                	je     c0107559 <_fifo_check_swap+0x258>
c0107535:	c7 44 24 0c e7 aa 10 	movl   $0xc010aae7,0xc(%esp)
c010753c:	c0 
c010753d:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c0107544:	c0 
c0107545:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010754c:	00 
c010754d:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c0107554:	e8 7c 97 ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107559:	c7 04 24 44 aa 10 c0 	movl   $0xc010aa44,(%esp)
c0107560:	e8 e6 8d ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107565:	b8 00 40 00 00       	mov    $0x4000,%eax
c010756a:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c010756d:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0107572:	83 f8 09             	cmp    $0x9,%eax
c0107575:	74 24                	je     c010759b <_fifo_check_swap+0x29a>
c0107577:	c7 44 24 0c f6 aa 10 	movl   $0xc010aaf6,0xc(%esp)
c010757e:	c0 
c010757f:	c7 44 24 08 a2 a9 10 	movl   $0xc010a9a2,0x8(%esp)
c0107586:	c0 
c0107587:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010758e:	00 
c010758f:	c7 04 24 b7 a9 10 c0 	movl   $0xc010a9b7,(%esp)
c0107596:	e8 3a 97 ff ff       	call   c0100cd5 <__panic>
    return 0;
c010759b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01075a0:	c9                   	leave  
c01075a1:	c3                   	ret    

c01075a2 <_fifo_init>:


static int
_fifo_init(void)
{
c01075a2:	55                   	push   %ebp
c01075a3:	89 e5                	mov    %esp,%ebp
    return 0;
c01075a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01075aa:	5d                   	pop    %ebp
c01075ab:	c3                   	ret    

c01075ac <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01075ac:	55                   	push   %ebp
c01075ad:	89 e5                	mov    %esp,%ebp
    return 0;
c01075af:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01075b4:	5d                   	pop    %ebp
c01075b5:	c3                   	ret    

c01075b6 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c01075b6:	55                   	push   %ebp
c01075b7:	89 e5                	mov    %esp,%ebp
c01075b9:	b8 00 00 00 00       	mov    $0x0,%eax
c01075be:	5d                   	pop    %ebp
c01075bf:	c3                   	ret    

c01075c0 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01075c0:	55                   	push   %ebp
c01075c1:	89 e5                	mov    %esp,%ebp
c01075c3:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01075c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01075c9:	c1 e8 0c             	shr    $0xc,%eax
c01075cc:	89 c2                	mov    %eax,%edx
c01075ce:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c01075d3:	39 c2                	cmp    %eax,%edx
c01075d5:	72 1c                	jb     c01075f3 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01075d7:	c7 44 24 08 18 ab 10 	movl   $0xc010ab18,0x8(%esp)
c01075de:	c0 
c01075df:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01075e6:	00 
c01075e7:	c7 04 24 37 ab 10 c0 	movl   $0xc010ab37,(%esp)
c01075ee:	e8 e2 96 ff ff       	call   c0100cd5 <__panic>
    }
    return &pages[PPN(pa)];
c01075f3:	a1 f4 2a 12 c0       	mov    0xc0122af4,%eax
c01075f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01075fb:	c1 ea 0c             	shr    $0xc,%edx
c01075fe:	c1 e2 05             	shl    $0x5,%edx
c0107601:	01 d0                	add    %edx,%eax
}
c0107603:	c9                   	leave  
c0107604:	c3                   	ret    

c0107605 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107605:	55                   	push   %ebp
c0107606:	89 e5                	mov    %esp,%ebp
c0107608:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c010760b:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107612:	e8 a2 e8 ff ff       	call   c0105eb9 <kmalloc>
c0107617:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c010761a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010761e:	74 58                	je     c0107678 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c0107620:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107623:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107626:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107629:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010762c:	89 50 04             	mov    %edx,0x4(%eax)
c010762f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107632:	8b 50 04             	mov    0x4(%eax),%edx
c0107635:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107638:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c010763a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010763d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107644:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107647:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c010764e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107651:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107658:	a1 cc 2a 12 c0       	mov    0xc0122acc,%eax
c010765d:	85 c0                	test   %eax,%eax
c010765f:	74 0d                	je     c010766e <mm_create+0x69>
c0107661:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107664:	89 04 24             	mov    %eax,(%esp)
c0107667:	e8 9a ea ff ff       	call   c0106106 <swap_init_mm>
c010766c:	eb 0a                	jmp    c0107678 <mm_create+0x73>
        else mm->sm_priv = NULL;
c010766e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107671:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0107678:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010767b:	c9                   	leave  
c010767c:	c3                   	ret    

c010767d <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c010767d:	55                   	push   %ebp
c010767e:	89 e5                	mov    %esp,%ebp
c0107680:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107683:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c010768a:	e8 2a e8 ff ff       	call   c0105eb9 <kmalloc>
c010768f:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107696:	74 1b                	je     c01076b3 <vma_create+0x36>
        vma->vm_start = vm_start;
c0107698:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010769b:	8b 55 08             	mov    0x8(%ebp),%edx
c010769e:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01076a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076a4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01076a7:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01076aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076ad:	8b 55 10             	mov    0x10(%ebp),%edx
c01076b0:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c01076b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01076b6:	c9                   	leave  
c01076b7:	c3                   	ret    

c01076b8 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01076b8:	55                   	push   %ebp
c01076b9:	89 e5                	mov    %esp,%ebp
c01076bb:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c01076be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c01076c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01076c9:	0f 84 95 00 00 00    	je     c0107764 <find_vma+0xac>
        vma = mm->mmap_cache;
c01076cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01076d2:	8b 40 08             	mov    0x8(%eax),%eax
c01076d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c01076d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01076dc:	74 16                	je     c01076f4 <find_vma+0x3c>
c01076de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01076e1:	8b 40 04             	mov    0x4(%eax),%eax
c01076e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01076e7:	77 0b                	ja     c01076f4 <find_vma+0x3c>
c01076e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01076ec:	8b 40 08             	mov    0x8(%eax),%eax
c01076ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01076f2:	77 61                	ja     c0107755 <find_vma+0x9d>
                bool found = 0;
c01076f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c01076fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01076fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107701:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107704:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107707:	eb 28                	jmp    c0107731 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0107709:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010770c:	83 e8 10             	sub    $0x10,%eax
c010770f:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0107712:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107715:	8b 40 04             	mov    0x4(%eax),%eax
c0107718:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010771b:	77 14                	ja     c0107731 <find_vma+0x79>
c010771d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107720:	8b 40 08             	mov    0x8(%eax),%eax
c0107723:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107726:	76 09                	jbe    c0107731 <find_vma+0x79>
                        found = 1;
c0107728:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c010772f:	eb 17                	jmp    c0107748 <find_vma+0x90>
c0107731:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107734:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107737:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010773a:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c010773d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107740:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107743:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107746:	75 c1                	jne    c0107709 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107748:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010774c:	75 07                	jne    c0107755 <find_vma+0x9d>
                    vma = NULL;
c010774e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107755:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107759:	74 09                	je     c0107764 <find_vma+0xac>
            mm->mmap_cache = vma;
c010775b:	8b 45 08             	mov    0x8(%ebp),%eax
c010775e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107761:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107764:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107767:	c9                   	leave  
c0107768:	c3                   	ret    

c0107769 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107769:	55                   	push   %ebp
c010776a:	89 e5                	mov    %esp,%ebp
c010776c:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c010776f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107772:	8b 50 04             	mov    0x4(%eax),%edx
c0107775:	8b 45 08             	mov    0x8(%ebp),%eax
c0107778:	8b 40 08             	mov    0x8(%eax),%eax
c010777b:	39 c2                	cmp    %eax,%edx
c010777d:	72 24                	jb     c01077a3 <check_vma_overlap+0x3a>
c010777f:	c7 44 24 0c 45 ab 10 	movl   $0xc010ab45,0xc(%esp)
c0107786:	c0 
c0107787:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c010778e:	c0 
c010778f:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0107796:	00 
c0107797:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c010779e:	e8 32 95 ff ff       	call   c0100cd5 <__panic>
    assert(prev->vm_end <= next->vm_start);
c01077a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01077a6:	8b 50 08             	mov    0x8(%eax),%edx
c01077a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077ac:	8b 40 04             	mov    0x4(%eax),%eax
c01077af:	39 c2                	cmp    %eax,%edx
c01077b1:	76 24                	jbe    c01077d7 <check_vma_overlap+0x6e>
c01077b3:	c7 44 24 0c 88 ab 10 	movl   $0xc010ab88,0xc(%esp)
c01077ba:	c0 
c01077bb:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c01077c2:	c0 
c01077c3:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c01077ca:	00 
c01077cb:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c01077d2:	e8 fe 94 ff ff       	call   c0100cd5 <__panic>
    assert(next->vm_start < next->vm_end);
c01077d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077da:	8b 50 04             	mov    0x4(%eax),%edx
c01077dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077e0:	8b 40 08             	mov    0x8(%eax),%eax
c01077e3:	39 c2                	cmp    %eax,%edx
c01077e5:	72 24                	jb     c010780b <check_vma_overlap+0xa2>
c01077e7:	c7 44 24 0c a7 ab 10 	movl   $0xc010aba7,0xc(%esp)
c01077ee:	c0 
c01077ef:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c01077f6:	c0 
c01077f7:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01077fe:	00 
c01077ff:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107806:	e8 ca 94 ff ff       	call   c0100cd5 <__panic>
}
c010780b:	c9                   	leave  
c010780c:	c3                   	ret    

c010780d <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c010780d:	55                   	push   %ebp
c010780e:	89 e5                	mov    %esp,%ebp
c0107810:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107813:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107816:	8b 50 04             	mov    0x4(%eax),%edx
c0107819:	8b 45 0c             	mov    0xc(%ebp),%eax
c010781c:	8b 40 08             	mov    0x8(%eax),%eax
c010781f:	39 c2                	cmp    %eax,%edx
c0107821:	72 24                	jb     c0107847 <insert_vma_struct+0x3a>
c0107823:	c7 44 24 0c c5 ab 10 	movl   $0xc010abc5,0xc(%esp)
c010782a:	c0 
c010782b:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107832:	c0 
c0107833:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010783a:	00 
c010783b:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107842:	e8 8e 94 ff ff       	call   c0100cd5 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107847:	8b 45 08             	mov    0x8(%ebp),%eax
c010784a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c010784d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107850:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107853:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107856:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107859:	eb 21                	jmp    c010787c <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c010785b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010785e:	83 e8 10             	sub    $0x10,%eax
c0107861:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0107864:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107867:	8b 50 04             	mov    0x4(%eax),%edx
c010786a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010786d:	8b 40 04             	mov    0x4(%eax),%eax
c0107870:	39 c2                	cmp    %eax,%edx
c0107872:	76 02                	jbe    c0107876 <insert_vma_struct+0x69>
                break;
c0107874:	eb 1d                	jmp    c0107893 <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107876:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107879:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010787c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010787f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107882:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107885:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107888:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010788b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010788e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107891:	75 c8                	jne    c010785b <insert_vma_struct+0x4e>
c0107893:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107896:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107899:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010789c:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c010789f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c01078a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078a8:	74 15                	je     c01078bf <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01078aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078ad:	8d 50 f0             	lea    -0x10(%eax),%edx
c01078b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078b7:	89 14 24             	mov    %edx,(%esp)
c01078ba:	e8 aa fe ff ff       	call   c0107769 <check_vma_overlap>
    }
    if (le_next != list) {
c01078bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01078c2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078c5:	74 15                	je     c01078dc <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c01078c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01078ca:	83 e8 10             	sub    $0x10,%eax
c01078cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078d4:	89 04 24             	mov    %eax,(%esp)
c01078d7:	e8 8d fe ff ff       	call   c0107769 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c01078dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078df:	8b 55 08             	mov    0x8(%ebp),%edx
c01078e2:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01078e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078e7:	8d 50 10             	lea    0x10(%eax),%edx
c01078ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01078f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01078f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01078f6:	8b 40 04             	mov    0x4(%eax),%eax
c01078f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01078fc:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01078ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107902:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107905:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107908:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010790b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010790e:	89 10                	mov    %edx,(%eax)
c0107910:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107913:	8b 10                	mov    (%eax),%edx
c0107915:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107918:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010791b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010791e:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107921:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107924:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107927:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010792a:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c010792c:	8b 45 08             	mov    0x8(%ebp),%eax
c010792f:	8b 40 10             	mov    0x10(%eax),%eax
c0107932:	8d 50 01             	lea    0x1(%eax),%edx
c0107935:	8b 45 08             	mov    0x8(%ebp),%eax
c0107938:	89 50 10             	mov    %edx,0x10(%eax)
}
c010793b:	c9                   	leave  
c010793c:	c3                   	ret    

c010793d <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c010793d:	55                   	push   %ebp
c010793e:	89 e5                	mov    %esp,%ebp
c0107940:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107943:	8b 45 08             	mov    0x8(%ebp),%eax
c0107946:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107949:	eb 3e                	jmp    c0107989 <mm_destroy+0x4c>
c010794b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010794e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107951:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107954:	8b 40 04             	mov    0x4(%eax),%eax
c0107957:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010795a:	8b 12                	mov    (%edx),%edx
c010795c:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010795f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107962:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107965:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107968:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010796b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010796e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107971:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c0107973:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107976:	83 e8 10             	sub    $0x10,%eax
c0107979:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0107980:	00 
c0107981:	89 04 24             	mov    %eax,(%esp)
c0107984:	e8 d0 e5 ff ff       	call   c0105f59 <kfree>
c0107989:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010798c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010798f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107992:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0107995:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107998:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010799b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010799e:	75 ab                	jne    c010794b <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c01079a0:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c01079a7:	00 
c01079a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01079ab:	89 04 24             	mov    %eax,(%esp)
c01079ae:	e8 a6 e5 ff ff       	call   c0105f59 <kfree>
    mm=NULL;
c01079b3:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01079ba:	c9                   	leave  
c01079bb:	c3                   	ret    

c01079bc <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c01079bc:	55                   	push   %ebp
c01079bd:	89 e5                	mov    %esp,%ebp
c01079bf:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c01079c2:	e8 02 00 00 00       	call   c01079c9 <check_vmm>
}
c01079c7:	c9                   	leave  
c01079c8:	c3                   	ret    

c01079c9 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c01079c9:	55                   	push   %ebp
c01079ca:	89 e5                	mov    %esp,%ebp
c01079cc:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01079cf:	e8 49 cd ff ff       	call   c010471d <nr_free_pages>
c01079d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01079d7:	e8 41 00 00 00       	call   c0107a1d <check_vma_struct>
    check_pgfault();
c01079dc:	e8 03 05 00 00       	call   c0107ee4 <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c01079e1:	e8 37 cd ff ff       	call   c010471d <nr_free_pages>
c01079e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01079e9:	74 24                	je     c0107a0f <check_vmm+0x46>
c01079eb:	c7 44 24 0c e4 ab 10 	movl   $0xc010abe4,0xc(%esp)
c01079f2:	c0 
c01079f3:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c01079fa:	c0 
c01079fb:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0107a02:	00 
c0107a03:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107a0a:	e8 c6 92 ff ff       	call   c0100cd5 <__panic>

    cprintf("check_vmm() succeeded.\n");
c0107a0f:	c7 04 24 0b ac 10 c0 	movl   $0xc010ac0b,(%esp)
c0107a16:	e8 30 89 ff ff       	call   c010034b <cprintf>
}
c0107a1b:	c9                   	leave  
c0107a1c:	c3                   	ret    

c0107a1d <check_vma_struct>:

static void
check_vma_struct(void) {
c0107a1d:	55                   	push   %ebp
c0107a1e:	89 e5                	mov    %esp,%ebp
c0107a20:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107a23:	e8 f5 cc ff ff       	call   c010471d <nr_free_pages>
c0107a28:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0107a2b:	e8 d5 fb ff ff       	call   c0107605 <mm_create>
c0107a30:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107a33:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107a37:	75 24                	jne    c0107a5d <check_vma_struct+0x40>
c0107a39:	c7 44 24 0c 23 ac 10 	movl   $0xc010ac23,0xc(%esp)
c0107a40:	c0 
c0107a41:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107a48:	c0 
c0107a49:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0107a50:	00 
c0107a51:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107a58:	e8 78 92 ff ff       	call   c0100cd5 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107a5d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0107a64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107a67:	89 d0                	mov    %edx,%eax
c0107a69:	c1 e0 02             	shl    $0x2,%eax
c0107a6c:	01 d0                	add    %edx,%eax
c0107a6e:	01 c0                	add    %eax,%eax
c0107a70:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107a73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107a79:	eb 70                	jmp    c0107aeb <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a7e:	89 d0                	mov    %edx,%eax
c0107a80:	c1 e0 02             	shl    $0x2,%eax
c0107a83:	01 d0                	add    %edx,%eax
c0107a85:	83 c0 02             	add    $0x2,%eax
c0107a88:	89 c1                	mov    %eax,%ecx
c0107a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a8d:	89 d0                	mov    %edx,%eax
c0107a8f:	c1 e0 02             	shl    $0x2,%eax
c0107a92:	01 d0                	add    %edx,%eax
c0107a94:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107a9b:	00 
c0107a9c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107aa0:	89 04 24             	mov    %eax,(%esp)
c0107aa3:	e8 d5 fb ff ff       	call   c010767d <vma_create>
c0107aa8:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107aab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107aaf:	75 24                	jne    c0107ad5 <check_vma_struct+0xb8>
c0107ab1:	c7 44 24 0c 2e ac 10 	movl   $0xc010ac2e,0xc(%esp)
c0107ab8:	c0 
c0107ab9:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107ac0:	c0 
c0107ac1:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0107ac8:	00 
c0107ac9:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107ad0:	e8 00 92 ff ff       	call   c0100cd5 <__panic>
        insert_vma_struct(mm, vma);
c0107ad5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107ad8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107adc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107adf:	89 04 24             	mov    %eax,(%esp)
c0107ae2:	e8 26 fd ff ff       	call   c010780d <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0107ae7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107aeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107aef:	7f 8a                	jg     c0107a7b <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107af1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107af4:	83 c0 01             	add    $0x1,%eax
c0107af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107afa:	eb 70                	jmp    c0107b6c <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107afc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107aff:	89 d0                	mov    %edx,%eax
c0107b01:	c1 e0 02             	shl    $0x2,%eax
c0107b04:	01 d0                	add    %edx,%eax
c0107b06:	83 c0 02             	add    $0x2,%eax
c0107b09:	89 c1                	mov    %eax,%ecx
c0107b0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b0e:	89 d0                	mov    %edx,%eax
c0107b10:	c1 e0 02             	shl    $0x2,%eax
c0107b13:	01 d0                	add    %edx,%eax
c0107b15:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107b1c:	00 
c0107b1d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107b21:	89 04 24             	mov    %eax,(%esp)
c0107b24:	e8 54 fb ff ff       	call   c010767d <vma_create>
c0107b29:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107b2c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107b30:	75 24                	jne    c0107b56 <check_vma_struct+0x139>
c0107b32:	c7 44 24 0c 2e ac 10 	movl   $0xc010ac2e,0xc(%esp)
c0107b39:	c0 
c0107b3a:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107b41:	c0 
c0107b42:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0107b49:	00 
c0107b4a:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107b51:	e8 7f 91 ff ff       	call   c0100cd5 <__panic>
        insert_vma_struct(mm, vma);
c0107b56:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107b59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b60:	89 04 24             	mov    %eax,(%esp)
c0107b63:	e8 a5 fc ff ff       	call   c010780d <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107b68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b6f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107b72:	7e 88                	jle    c0107afc <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0107b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b77:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107b7a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107b7d:	8b 40 04             	mov    0x4(%eax),%eax
c0107b80:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107b83:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107b8a:	e9 97 00 00 00       	jmp    c0107c26 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107b8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b92:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107b95:	75 24                	jne    c0107bbb <check_vma_struct+0x19e>
c0107b97:	c7 44 24 0c 3a ac 10 	movl   $0xc010ac3a,0xc(%esp)
c0107b9e:	c0 
c0107b9f:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107ba6:	c0 
c0107ba7:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0107bae:	00 
c0107baf:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107bb6:	e8 1a 91 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107bbe:	83 e8 10             	sub    $0x10,%eax
c0107bc1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107bc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107bc7:	8b 48 04             	mov    0x4(%eax),%ecx
c0107bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107bcd:	89 d0                	mov    %edx,%eax
c0107bcf:	c1 e0 02             	shl    $0x2,%eax
c0107bd2:	01 d0                	add    %edx,%eax
c0107bd4:	39 c1                	cmp    %eax,%ecx
c0107bd6:	75 17                	jne    c0107bef <check_vma_struct+0x1d2>
c0107bd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107bdb:	8b 48 08             	mov    0x8(%eax),%ecx
c0107bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107be1:	89 d0                	mov    %edx,%eax
c0107be3:	c1 e0 02             	shl    $0x2,%eax
c0107be6:	01 d0                	add    %edx,%eax
c0107be8:	83 c0 02             	add    $0x2,%eax
c0107beb:	39 c1                	cmp    %eax,%ecx
c0107bed:	74 24                	je     c0107c13 <check_vma_struct+0x1f6>
c0107bef:	c7 44 24 0c 54 ac 10 	movl   $0xc010ac54,0xc(%esp)
c0107bf6:	c0 
c0107bf7:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107bfe:	c0 
c0107bff:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0107c06:	00 
c0107c07:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107c0e:	e8 c2 90 ff ff       	call   c0100cd5 <__panic>
c0107c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c16:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0107c19:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107c1c:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0107c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0107c22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c29:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107c2c:	0f 8e 5d ff ff ff    	jle    c0107b8f <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107c32:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107c39:	e9 cd 01 00 00       	jmp    c0107e0b <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c45:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c48:	89 04 24             	mov    %eax,(%esp)
c0107c4b:	e8 68 fa ff ff       	call   c01076b8 <find_vma>
c0107c50:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107c53:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107c57:	75 24                	jne    c0107c7d <check_vma_struct+0x260>
c0107c59:	c7 44 24 0c 89 ac 10 	movl   $0xc010ac89,0xc(%esp)
c0107c60:	c0 
c0107c61:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107c68:	c0 
c0107c69:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0107c70:	00 
c0107c71:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107c78:	e8 58 90 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c80:	83 c0 01             	add    $0x1,%eax
c0107c83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c87:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c8a:	89 04 24             	mov    %eax,(%esp)
c0107c8d:	e8 26 fa ff ff       	call   c01076b8 <find_vma>
c0107c92:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0107c95:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107c99:	75 24                	jne    c0107cbf <check_vma_struct+0x2a2>
c0107c9b:	c7 44 24 0c 96 ac 10 	movl   $0xc010ac96,0xc(%esp)
c0107ca2:	c0 
c0107ca3:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107caa:	c0 
c0107cab:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0107cb2:	00 
c0107cb3:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107cba:	e8 16 90 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cc2:	83 c0 02             	add    $0x2,%eax
c0107cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ccc:	89 04 24             	mov    %eax,(%esp)
c0107ccf:	e8 e4 f9 ff ff       	call   c01076b8 <find_vma>
c0107cd4:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107cd7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107cdb:	74 24                	je     c0107d01 <check_vma_struct+0x2e4>
c0107cdd:	c7 44 24 0c a3 ac 10 	movl   $0xc010aca3,0xc(%esp)
c0107ce4:	c0 
c0107ce5:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107cec:	c0 
c0107ced:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0107cf4:	00 
c0107cf5:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107cfc:	e8 d4 8f ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d04:	83 c0 03             	add    $0x3,%eax
c0107d07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d0e:	89 04 24             	mov    %eax,(%esp)
c0107d11:	e8 a2 f9 ff ff       	call   c01076b8 <find_vma>
c0107d16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0107d19:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107d1d:	74 24                	je     c0107d43 <check_vma_struct+0x326>
c0107d1f:	c7 44 24 0c b0 ac 10 	movl   $0xc010acb0,0xc(%esp)
c0107d26:	c0 
c0107d27:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107d2e:	c0 
c0107d2f:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0107d36:	00 
c0107d37:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107d3e:	e8 92 8f ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d46:	83 c0 04             	add    $0x4,%eax
c0107d49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d50:	89 04 24             	mov    %eax,(%esp)
c0107d53:	e8 60 f9 ff ff       	call   c01076b8 <find_vma>
c0107d58:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107d5b:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107d5f:	74 24                	je     c0107d85 <check_vma_struct+0x368>
c0107d61:	c7 44 24 0c bd ac 10 	movl   $0xc010acbd,0xc(%esp)
c0107d68:	c0 
c0107d69:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107d70:	c0 
c0107d71:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0107d78:	00 
c0107d79:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107d80:	e8 50 8f ff ff       	call   c0100cd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107d85:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d88:	8b 50 04             	mov    0x4(%eax),%edx
c0107d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d8e:	39 c2                	cmp    %eax,%edx
c0107d90:	75 10                	jne    c0107da2 <check_vma_struct+0x385>
c0107d92:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d95:	8b 50 08             	mov    0x8(%eax),%edx
c0107d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d9b:	83 c0 02             	add    $0x2,%eax
c0107d9e:	39 c2                	cmp    %eax,%edx
c0107da0:	74 24                	je     c0107dc6 <check_vma_struct+0x3a9>
c0107da2:	c7 44 24 0c cc ac 10 	movl   $0xc010accc,0xc(%esp)
c0107da9:	c0 
c0107daa:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107db1:	c0 
c0107db2:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107db9:	00 
c0107dba:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107dc1:	e8 0f 8f ff ff       	call   c0100cd5 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0107dc6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107dc9:	8b 50 04             	mov    0x4(%eax),%edx
c0107dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dcf:	39 c2                	cmp    %eax,%edx
c0107dd1:	75 10                	jne    c0107de3 <check_vma_struct+0x3c6>
c0107dd3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107dd6:	8b 50 08             	mov    0x8(%eax),%edx
c0107dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ddc:	83 c0 02             	add    $0x2,%eax
c0107ddf:	39 c2                	cmp    %eax,%edx
c0107de1:	74 24                	je     c0107e07 <check_vma_struct+0x3ea>
c0107de3:	c7 44 24 0c fc ac 10 	movl   $0xc010acfc,0xc(%esp)
c0107dea:	c0 
c0107deb:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107df2:	c0 
c0107df3:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0107dfa:	00 
c0107dfb:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107e02:	e8 ce 8e ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107e07:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107e0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107e0e:	89 d0                	mov    %edx,%eax
c0107e10:	c1 e0 02             	shl    $0x2,%eax
c0107e13:	01 d0                	add    %edx,%eax
c0107e15:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107e18:	0f 8d 20 fe ff ff    	jge    c0107c3e <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107e1e:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107e25:	eb 70                	jmp    c0107e97 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e31:	89 04 24             	mov    %eax,(%esp)
c0107e34:	e8 7f f8 ff ff       	call   c01076b8 <find_vma>
c0107e39:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107e3c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107e40:	74 27                	je     c0107e69 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107e42:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107e45:	8b 50 08             	mov    0x8(%eax),%edx
c0107e48:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107e4b:	8b 40 04             	mov    0x4(%eax),%eax
c0107e4e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107e52:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e5d:	c7 04 24 2c ad 10 c0 	movl   $0xc010ad2c,(%esp)
c0107e64:	e8 e2 84 ff ff       	call   c010034b <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107e69:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107e6d:	74 24                	je     c0107e93 <check_vma_struct+0x476>
c0107e6f:	c7 44 24 0c 51 ad 10 	movl   $0xc010ad51,0xc(%esp)
c0107e76:	c0 
c0107e77:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107e7e:	c0 
c0107e7f:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0107e86:	00 
c0107e87:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107e8e:	e8 42 8e ff ff       	call   c0100cd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107e93:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107e97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107e9b:	79 8a                	jns    c0107e27 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0107e9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ea0:	89 04 24             	mov    %eax,(%esp)
c0107ea3:	e8 95 fa ff ff       	call   c010793d <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c0107ea8:	e8 70 c8 ff ff       	call   c010471d <nr_free_pages>
c0107ead:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107eb0:	74 24                	je     c0107ed6 <check_vma_struct+0x4b9>
c0107eb2:	c7 44 24 0c e4 ab 10 	movl   $0xc010abe4,0xc(%esp)
c0107eb9:	c0 
c0107eba:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107ec1:	c0 
c0107ec2:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0107ec9:	00 
c0107eca:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107ed1:	e8 ff 8d ff ff       	call   c0100cd5 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0107ed6:	c7 04 24 68 ad 10 c0 	movl   $0xc010ad68,(%esp)
c0107edd:	e8 69 84 ff ff       	call   c010034b <cprintf>
}
c0107ee2:	c9                   	leave  
c0107ee3:	c3                   	ret    

c0107ee4 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107ee4:	55                   	push   %ebp
c0107ee5:	89 e5                	mov    %esp,%ebp
c0107ee7:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107eea:	e8 2e c8 ff ff       	call   c010471d <nr_free_pages>
c0107eef:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107ef2:	e8 0e f7 ff ff       	call   c0107605 <mm_create>
c0107ef7:	a3 cc 2b 12 c0       	mov    %eax,0xc0122bcc
    assert(check_mm_struct != NULL);
c0107efc:	a1 cc 2b 12 c0       	mov    0xc0122bcc,%eax
c0107f01:	85 c0                	test   %eax,%eax
c0107f03:	75 24                	jne    c0107f29 <check_pgfault+0x45>
c0107f05:	c7 44 24 0c 87 ad 10 	movl   $0xc010ad87,0xc(%esp)
c0107f0c:	c0 
c0107f0d:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107f14:	c0 
c0107f15:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0107f1c:	00 
c0107f1d:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107f24:	e8 ac 8d ff ff       	call   c0100cd5 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107f29:	a1 cc 2b 12 c0       	mov    0xc0122bcc,%eax
c0107f2e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107f31:	8b 15 44 2a 12 c0    	mov    0xc0122a44,%edx
c0107f37:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f3a:	89 50 0c             	mov    %edx,0xc(%eax)
c0107f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f40:	8b 40 0c             	mov    0xc(%eax),%eax
c0107f43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107f46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f49:	8b 00                	mov    (%eax),%eax
c0107f4b:	85 c0                	test   %eax,%eax
c0107f4d:	74 24                	je     c0107f73 <check_pgfault+0x8f>
c0107f4f:	c7 44 24 0c 9f ad 10 	movl   $0xc010ad9f,0xc(%esp)
c0107f56:	c0 
c0107f57:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107f5e:	c0 
c0107f5f:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107f66:	00 
c0107f67:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107f6e:	e8 62 8d ff ff       	call   c0100cd5 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107f73:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107f7a:	00 
c0107f7b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107f82:	00 
c0107f83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107f8a:	e8 ee f6 ff ff       	call   c010767d <vma_create>
c0107f8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107f92:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107f96:	75 24                	jne    c0107fbc <check_pgfault+0xd8>
c0107f98:	c7 44 24 0c 2e ac 10 	movl   $0xc010ac2e,0xc(%esp)
c0107f9f:	c0 
c0107fa0:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107fa7:	c0 
c0107fa8:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107faf:	00 
c0107fb0:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0107fb7:	e8 19 8d ff ff       	call   c0100cd5 <__panic>

    insert_vma_struct(mm, vma);
c0107fbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107fbf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107fc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107fc6:	89 04 24             	mov    %eax,(%esp)
c0107fc9:	e8 3f f8 ff ff       	call   c010780d <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107fce:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107fd5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107fdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107fdf:	89 04 24             	mov    %eax,(%esp)
c0107fe2:	e8 d1 f6 ff ff       	call   c01076b8 <find_vma>
c0107fe7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107fea:	74 24                	je     c0108010 <check_pgfault+0x12c>
c0107fec:	c7 44 24 0c ad ad 10 	movl   $0xc010adad,0xc(%esp)
c0107ff3:	c0 
c0107ff4:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0107ffb:	c0 
c0107ffc:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0108003:	00 
c0108004:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c010800b:	e8 c5 8c ff ff       	call   c0100cd5 <__panic>

    int i, sum = 0;
c0108010:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0108017:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010801e:	eb 17                	jmp    c0108037 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0108020:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108023:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108026:	01 d0                	add    %edx,%eax
c0108028:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010802b:	88 10                	mov    %dl,(%eax)
        sum += i;
c010802d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108030:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0108033:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108037:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010803b:	7e e3                	jle    c0108020 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c010803d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108044:	eb 15                	jmp    c010805b <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0108046:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108049:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010804c:	01 d0                	add    %edx,%eax
c010804e:	0f b6 00             	movzbl (%eax),%eax
c0108051:	0f be c0             	movsbl %al,%eax
c0108054:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108057:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010805b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010805f:	7e e5                	jle    c0108046 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0108061:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108065:	74 24                	je     c010808b <check_pgfault+0x1a7>
c0108067:	c7 44 24 0c c7 ad 10 	movl   $0xc010adc7,0xc(%esp)
c010806e:	c0 
c010806f:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0108076:	c0 
c0108077:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c010807e:	00 
c010807f:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0108086:	e8 4a 8c ff ff       	call   c0100cd5 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c010808b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010808e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108091:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108099:	89 44 24 04          	mov    %eax,0x4(%esp)
c010809d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080a0:	89 04 24             	mov    %eax,(%esp)
c01080a3:	e8 33 cf ff ff       	call   c0104fdb <page_remove>
    free_page(pa2page(pgdir[0]));
c01080a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080ab:	8b 00                	mov    (%eax),%eax
c01080ad:	89 04 24             	mov    %eax,(%esp)
c01080b0:	e8 0b f5 ff ff       	call   c01075c0 <pa2page>
c01080b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01080bc:	00 
c01080bd:	89 04 24             	mov    %eax,(%esp)
c01080c0:	e8 26 c6 ff ff       	call   c01046eb <free_pages>
    pgdir[0] = 0;
c01080c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c01080ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01080d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c01080d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01080db:	89 04 24             	mov    %eax,(%esp)
c01080de:	e8 5a f8 ff ff       	call   c010793d <mm_destroy>
    check_mm_struct = NULL;
c01080e3:	c7 05 cc 2b 12 c0 00 	movl   $0x0,0xc0122bcc
c01080ea:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c01080ed:	e8 2b c6 ff ff       	call   c010471d <nr_free_pages>
c01080f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01080f5:	74 24                	je     c010811b <check_pgfault+0x237>
c01080f7:	c7 44 24 0c e4 ab 10 	movl   $0xc010abe4,0xc(%esp)
c01080fe:	c0 
c01080ff:	c7 44 24 08 63 ab 10 	movl   $0xc010ab63,0x8(%esp)
c0108106:	c0 
c0108107:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c010810e:	00 
c010810f:	c7 04 24 78 ab 10 c0 	movl   $0xc010ab78,(%esp)
c0108116:	e8 ba 8b ff ff       	call   c0100cd5 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c010811b:	c7 04 24 d0 ad 10 c0 	movl   $0xc010add0,(%esp)
c0108122:	e8 24 82 ff ff       	call   c010034b <cprintf>
}
c0108127:	c9                   	leave  
c0108128:	c3                   	ret    

c0108129 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0108129:	55                   	push   %ebp
c010812a:	89 e5                	mov    %esp,%ebp
c010812c:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c010812f:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0108136:	8b 45 10             	mov    0x10(%ebp),%eax
c0108139:	89 44 24 04          	mov    %eax,0x4(%esp)
c010813d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108140:	89 04 24             	mov    %eax,(%esp)
c0108143:	e8 70 f5 ff ff       	call   c01076b8 <find_vma>
c0108148:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c010814b:	a1 d8 2a 12 c0       	mov    0xc0122ad8,%eax
c0108150:	83 c0 01             	add    $0x1,%eax
c0108153:	a3 d8 2a 12 c0       	mov    %eax,0xc0122ad8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0108158:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010815c:	74 0b                	je     c0108169 <do_pgfault+0x40>
c010815e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108161:	8b 40 04             	mov    0x4(%eax),%eax
c0108164:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108167:	76 18                	jbe    c0108181 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0108169:	8b 45 10             	mov    0x10(%ebp),%eax
c010816c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108170:	c7 04 24 ec ad 10 c0 	movl   $0xc010adec,(%esp)
c0108177:	e8 cf 81 ff ff       	call   c010034b <cprintf>
        goto failed;
c010817c:	e9 ae 01 00 00       	jmp    c010832f <do_pgfault+0x206>
    }
    //check the error_code
    switch (error_code & 3) {
c0108181:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108184:	83 e0 03             	and    $0x3,%eax
c0108187:	85 c0                	test   %eax,%eax
c0108189:	74 36                	je     c01081c1 <do_pgfault+0x98>
c010818b:	83 f8 01             	cmp    $0x1,%eax
c010818e:	74 20                	je     c01081b0 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0108190:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108193:	8b 40 0c             	mov    0xc(%eax),%eax
c0108196:	83 e0 02             	and    $0x2,%eax
c0108199:	85 c0                	test   %eax,%eax
c010819b:	75 11                	jne    c01081ae <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c010819d:	c7 04 24 1c ae 10 c0 	movl   $0xc010ae1c,(%esp)
c01081a4:	e8 a2 81 ff ff       	call   c010034b <cprintf>
            goto failed;
c01081a9:	e9 81 01 00 00       	jmp    c010832f <do_pgfault+0x206>
        }
        break;
c01081ae:	eb 2f                	jmp    c01081df <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c01081b0:	c7 04 24 7c ae 10 c0 	movl   $0xc010ae7c,(%esp)
c01081b7:	e8 8f 81 ff ff       	call   c010034b <cprintf>
        goto failed;
c01081bc:	e9 6e 01 00 00       	jmp    c010832f <do_pgfault+0x206>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c01081c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081c4:	8b 40 0c             	mov    0xc(%eax),%eax
c01081c7:	83 e0 05             	and    $0x5,%eax
c01081ca:	85 c0                	test   %eax,%eax
c01081cc:	75 11                	jne    c01081df <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c01081ce:	c7 04 24 b4 ae 10 c0 	movl   $0xc010aeb4,(%esp)
c01081d5:	e8 71 81 ff ff       	call   c010034b <cprintf>
            goto failed;
c01081da:	e9 50 01 00 00       	jmp    c010832f <do_pgfault+0x206>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c01081df:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c01081e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081e9:	8b 40 0c             	mov    0xc(%eax),%eax
c01081ec:	83 e0 02             	and    $0x2,%eax
c01081ef:	85 c0                	test   %eax,%eax
c01081f1:	74 04                	je     c01081f7 <do_pgfault+0xce>
        perm |= PTE_W;
c01081f3:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c01081f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01081fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01081fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108200:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108205:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0108208:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c010820f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    *
    */

    /*LAB3 EXERCISE 1: YOUR CODE*/
    // 通过addr这个线性地址返回对应的虚拟页pte 如果没有get_pte会创建一个虚拟页 同时ptep等于0
    ptep = get_pte(mm->pgdir, addr, 1);             //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
c0108216:	8b 45 08             	mov    0x8(%ebp),%eax
c0108219:	8b 40 0c             	mov    0xc(%eax),%eax
c010821c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0108223:	00 
c0108224:	8b 55 10             	mov    0x10(%ebp),%edx
c0108227:	89 54 24 04          	mov    %edx,0x4(%esp)
c010822b:	89 04 24             	mov    %eax,(%esp)
c010822e:	e8 af cb ff ff       	call   c0104de2 <get_pte>
c0108233:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // ptep等于NULL代表alloc_page创建虚拟页失败
    if (ptep == NULL) {
c0108236:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010823a:	75 11                	jne    c010824d <do_pgfault+0x124>
    	cprintf("ptep == NULL");		// 方便调试
c010823c:	c7 04 24 17 af 10 c0 	movl   $0xc010af17,(%esp)
c0108243:	e8 03 81 ff ff       	call   c010034b <cprintf>
    	goto failed;
c0108248:	e9 e2 00 00 00       	jmp    c010832f <do_pgfault+0x206>
    }
    // 等于0是创建好虚拟页后还没有物理页与之对应
    if (*ptep == 0) {
c010824d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108250:	8b 00                	mov    (%eax),%eax
c0108252:	85 c0                	test   %eax,%eax
c0108254:	75 35                	jne    c010828b <do_pgfault+0x162>
    	// 尝试分配物理页
    	if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {     //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
c0108256:	8b 45 08             	mov    0x8(%ebp),%eax
c0108259:	8b 40 0c             	mov    0xc(%eax),%eax
c010825c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010825f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108263:	8b 55 10             	mov    0x10(%ebp),%edx
c0108266:	89 54 24 04          	mov    %edx,0x4(%esp)
c010826a:	89 04 24             	mov    %eax,(%esp)
c010826d:	e8 c3 ce ff ff       	call   c0105135 <pgdir_alloc_page>
c0108272:	85 c0                	test   %eax,%eax
c0108274:	0f 85 ae 00 00 00    	jne    c0108328 <do_pgfault+0x1ff>
    		cprintf("pgdir_alloc_page(mm->pgdir, addr, perm) == NULL");
c010827a:	c7 04 24 24 af 10 c0 	movl   $0xc010af24,(%esp)
c0108281:	e8 c5 80 ff ff       	call   c010034b <cprintf>
    		goto failed;
c0108286:	e9 a4 00 00 00       	jmp    c010832f <do_pgfault+0x206>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {
c010828b:	a1 cc 2a 12 c0       	mov    0xc0122acc,%eax
c0108290:	85 c0                	test   %eax,%eax
c0108292:	74 7d                	je     c0108311 <do_pgfault+0x1e8>
        	// 将磁盘中的页换入到内存
            struct Page *page=NULL;
c0108294:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            ret = swap_in(mm, addr, &page);                        //(1）According to the mm AND addr, try to load the content of right disk page
c010829b:	8d 45 e0             	lea    -0x20(%ebp),%eax
c010829e:	89 44 24 08          	mov    %eax,0x8(%esp)
c01082a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01082a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01082ac:	89 04 24             	mov    %eax,(%esp)
c01082af:	e8 4b e0 ff ff       	call   c01062ff <swap_in>
c01082b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c01082b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01082bb:	74 0e                	je     c01082cb <do_pgfault+0x1a2>
            	cprintf("swap_in in do_pgfault failed\n");
c01082bd:	c7 04 24 54 af 10 c0 	movl   $0xc010af54,(%esp)
c01082c4:	e8 82 80 ff ff       	call   c010034b <cprintf>
c01082c9:	eb 64                	jmp    c010832f <do_pgfault+0x206>
            	goto failed;
            }
            // 建立虚拟地址和物理地址之间的对应关系                         						 //    into the memory which page managed.
            page_insert(mm->pgdir, page, addr, perm);              //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
c01082cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01082ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01082d1:	8b 40 0c             	mov    0xc(%eax),%eax
c01082d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01082d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01082db:	8b 4d 10             	mov    0x10(%ebp),%ecx
c01082de:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01082e2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01082e6:	89 04 24             	mov    %eax,(%esp)
c01082e9:	e8 31 cd ff ff       	call   c010501f <page_insert>
            // 最后的swap_in等于1使页面可替换
            swap_map_swappable(mm, addr, page, 1);     //(3) make the page swappable.
c01082ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082f1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c01082f8:	00 
c01082f9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01082fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0108300:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108304:	8b 45 08             	mov    0x8(%ebp),%eax
c0108307:	89 04 24             	mov    %eax,(%esp)
c010830a:	e8 27 de ff ff       	call   c0106136 <swap_map_swappable>
c010830f:	eb 17                	jmp    c0108328 <do_pgfault+0x1ff>
            //page->pra_vaddr = addr;
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0108311:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108314:	8b 00                	mov    (%eax),%eax
c0108316:	89 44 24 04          	mov    %eax,0x4(%esp)
c010831a:	c7 04 24 74 af 10 c0 	movl   $0xc010af74,(%esp)
c0108321:	e8 25 80 ff ff       	call   c010034b <cprintf>
            goto failed;
c0108326:	eb 07                	jmp    c010832f <do_pgfault+0x206>
        }
   }

   ret = 0;
c0108328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c010832f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108332:	c9                   	leave  
c0108333:	c3                   	ret    

c0108334 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108334:	55                   	push   %ebp
c0108335:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108337:	8b 55 08             	mov    0x8(%ebp),%edx
c010833a:	a1 f4 2a 12 c0       	mov    0xc0122af4,%eax
c010833f:	29 c2                	sub    %eax,%edx
c0108341:	89 d0                	mov    %edx,%eax
c0108343:	c1 f8 05             	sar    $0x5,%eax
}
c0108346:	5d                   	pop    %ebp
c0108347:	c3                   	ret    

c0108348 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108348:	55                   	push   %ebp
c0108349:	89 e5                	mov    %esp,%ebp
c010834b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010834e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108351:	89 04 24             	mov    %eax,(%esp)
c0108354:	e8 db ff ff ff       	call   c0108334 <page2ppn>
c0108359:	c1 e0 0c             	shl    $0xc,%eax
}
c010835c:	c9                   	leave  
c010835d:	c3                   	ret    

c010835e <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c010835e:	55                   	push   %ebp
c010835f:	89 e5                	mov    %esp,%ebp
c0108361:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108364:	8b 45 08             	mov    0x8(%ebp),%eax
c0108367:	89 04 24             	mov    %eax,(%esp)
c010836a:	e8 d9 ff ff ff       	call   c0108348 <page2pa>
c010836f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108372:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108375:	c1 e8 0c             	shr    $0xc,%eax
c0108378:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010837b:	a1 40 2a 12 c0       	mov    0xc0122a40,%eax
c0108380:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108383:	72 23                	jb     c01083a8 <page2kva+0x4a>
c0108385:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108388:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010838c:	c7 44 24 08 9c af 10 	movl   $0xc010af9c,0x8(%esp)
c0108393:	c0 
c0108394:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c010839b:	00 
c010839c:	c7 04 24 bf af 10 c0 	movl   $0xc010afbf,(%esp)
c01083a3:	e8 2d 89 ff ff       	call   c0100cd5 <__panic>
c01083a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083ab:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01083b0:	c9                   	leave  
c01083b1:	c3                   	ret    

c01083b2 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c01083b2:	55                   	push   %ebp
c01083b3:	89 e5                	mov    %esp,%ebp
c01083b5:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c01083b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01083bf:	e8 61 96 ff ff       	call   c0101a25 <ide_device_valid>
c01083c4:	85 c0                	test   %eax,%eax
c01083c6:	75 1c                	jne    c01083e4 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c01083c8:	c7 44 24 08 cd af 10 	movl   $0xc010afcd,0x8(%esp)
c01083cf:	c0 
c01083d0:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c01083d7:	00 
c01083d8:	c7 04 24 e7 af 10 c0 	movl   $0xc010afe7,(%esp)
c01083df:	e8 f1 88 ff ff       	call   c0100cd5 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c01083e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01083eb:	e8 74 96 ff ff       	call   c0101a64 <ide_device_size>
c01083f0:	c1 e8 03             	shr    $0x3,%eax
c01083f3:	a3 9c 2b 12 c0       	mov    %eax,0xc0122b9c
}
c01083f8:	c9                   	leave  
c01083f9:	c3                   	ret    

c01083fa <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c01083fa:	55                   	push   %ebp
c01083fb:	89 e5                	mov    %esp,%ebp
c01083fd:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108400:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108403:	89 04 24             	mov    %eax,(%esp)
c0108406:	e8 53 ff ff ff       	call   c010835e <page2kva>
c010840b:	8b 55 08             	mov    0x8(%ebp),%edx
c010840e:	c1 ea 08             	shr    $0x8,%edx
c0108411:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108414:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108418:	74 0b                	je     c0108425 <swapfs_read+0x2b>
c010841a:	8b 15 9c 2b 12 c0    	mov    0xc0122b9c,%edx
c0108420:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108423:	72 23                	jb     c0108448 <swapfs_read+0x4e>
c0108425:	8b 45 08             	mov    0x8(%ebp),%eax
c0108428:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010842c:	c7 44 24 08 f8 af 10 	movl   $0xc010aff8,0x8(%esp)
c0108433:	c0 
c0108434:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c010843b:	00 
c010843c:	c7 04 24 e7 af 10 c0 	movl   $0xc010afe7,(%esp)
c0108443:	e8 8d 88 ff ff       	call   c0100cd5 <__panic>
c0108448:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010844b:	c1 e2 03             	shl    $0x3,%edx
c010844e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108455:	00 
c0108456:	89 44 24 08          	mov    %eax,0x8(%esp)
c010845a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010845e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108465:	e8 39 96 ff ff       	call   c0101aa3 <ide_read_secs>
}
c010846a:	c9                   	leave  
c010846b:	c3                   	ret    

c010846c <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c010846c:	55                   	push   %ebp
c010846d:	89 e5                	mov    %esp,%ebp
c010846f:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108472:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108475:	89 04 24             	mov    %eax,(%esp)
c0108478:	e8 e1 fe ff ff       	call   c010835e <page2kva>
c010847d:	8b 55 08             	mov    0x8(%ebp),%edx
c0108480:	c1 ea 08             	shr    $0x8,%edx
c0108483:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108486:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010848a:	74 0b                	je     c0108497 <swapfs_write+0x2b>
c010848c:	8b 15 9c 2b 12 c0    	mov    0xc0122b9c,%edx
c0108492:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108495:	72 23                	jb     c01084ba <swapfs_write+0x4e>
c0108497:	8b 45 08             	mov    0x8(%ebp),%eax
c010849a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010849e:	c7 44 24 08 f8 af 10 	movl   $0xc010aff8,0x8(%esp)
c01084a5:	c0 
c01084a6:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c01084ad:	00 
c01084ae:	c7 04 24 e7 af 10 c0 	movl   $0xc010afe7,(%esp)
c01084b5:	e8 1b 88 ff ff       	call   c0100cd5 <__panic>
c01084ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01084bd:	c1 e2 03             	shl    $0x3,%edx
c01084c0:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01084c7:	00 
c01084c8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01084cc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01084d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01084d7:	e8 09 98 ff ff       	call   c0101ce5 <ide_write_secs>
}
c01084dc:	c9                   	leave  
c01084dd:	c3                   	ret    

c01084de <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01084de:	55                   	push   %ebp
c01084df:	89 e5                	mov    %esp,%ebp
c01084e1:	83 ec 58             	sub    $0x58,%esp
c01084e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01084e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01084ea:	8b 45 14             	mov    0x14(%ebp),%eax
c01084ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01084f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01084f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01084f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01084f9:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01084fc:	8b 45 18             	mov    0x18(%ebp),%eax
c01084ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108502:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108505:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108508:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010850b:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010850e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108511:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108514:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108518:	74 1c                	je     c0108536 <printnum+0x58>
c010851a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010851d:	ba 00 00 00 00       	mov    $0x0,%edx
c0108522:	f7 75 e4             	divl   -0x1c(%ebp)
c0108525:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108528:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010852b:	ba 00 00 00 00       	mov    $0x0,%edx
c0108530:	f7 75 e4             	divl   -0x1c(%ebp)
c0108533:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108536:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108539:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010853c:	f7 75 e4             	divl   -0x1c(%ebp)
c010853f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108542:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0108545:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108548:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010854b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010854e:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108551:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108554:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0108557:	8b 45 18             	mov    0x18(%ebp),%eax
c010855a:	ba 00 00 00 00       	mov    $0x0,%edx
c010855f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108562:	77 56                	ja     c01085ba <printnum+0xdc>
c0108564:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108567:	72 05                	jb     c010856e <printnum+0x90>
c0108569:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010856c:	77 4c                	ja     c01085ba <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010856e:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108571:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108574:	8b 45 20             	mov    0x20(%ebp),%eax
c0108577:	89 44 24 18          	mov    %eax,0x18(%esp)
c010857b:	89 54 24 14          	mov    %edx,0x14(%esp)
c010857f:	8b 45 18             	mov    0x18(%ebp),%eax
c0108582:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108586:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108589:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010858c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108590:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108594:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108597:	89 44 24 04          	mov    %eax,0x4(%esp)
c010859b:	8b 45 08             	mov    0x8(%ebp),%eax
c010859e:	89 04 24             	mov    %eax,(%esp)
c01085a1:	e8 38 ff ff ff       	call   c01084de <printnum>
c01085a6:	eb 1c                	jmp    c01085c4 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01085a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085af:	8b 45 20             	mov    0x20(%ebp),%eax
c01085b2:	89 04 24             	mov    %eax,(%esp)
c01085b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01085b8:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01085ba:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01085be:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01085c2:	7f e4                	jg     c01085a8 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01085c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01085c7:	05 98 b0 10 c0       	add    $0xc010b098,%eax
c01085cc:	0f b6 00             	movzbl (%eax),%eax
c01085cf:	0f be c0             	movsbl %al,%eax
c01085d2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01085d5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01085d9:	89 04 24             	mov    %eax,(%esp)
c01085dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01085df:	ff d0                	call   *%eax
}
c01085e1:	c9                   	leave  
c01085e2:	c3                   	ret    

c01085e3 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01085e3:	55                   	push   %ebp
c01085e4:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01085e6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01085ea:	7e 14                	jle    c0108600 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01085ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01085ef:	8b 00                	mov    (%eax),%eax
c01085f1:	8d 48 08             	lea    0x8(%eax),%ecx
c01085f4:	8b 55 08             	mov    0x8(%ebp),%edx
c01085f7:	89 0a                	mov    %ecx,(%edx)
c01085f9:	8b 50 04             	mov    0x4(%eax),%edx
c01085fc:	8b 00                	mov    (%eax),%eax
c01085fe:	eb 30                	jmp    c0108630 <getuint+0x4d>
    }
    else if (lflag) {
c0108600:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108604:	74 16                	je     c010861c <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0108606:	8b 45 08             	mov    0x8(%ebp),%eax
c0108609:	8b 00                	mov    (%eax),%eax
c010860b:	8d 48 04             	lea    0x4(%eax),%ecx
c010860e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108611:	89 0a                	mov    %ecx,(%edx)
c0108613:	8b 00                	mov    (%eax),%eax
c0108615:	ba 00 00 00 00       	mov    $0x0,%edx
c010861a:	eb 14                	jmp    c0108630 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010861c:	8b 45 08             	mov    0x8(%ebp),%eax
c010861f:	8b 00                	mov    (%eax),%eax
c0108621:	8d 48 04             	lea    0x4(%eax),%ecx
c0108624:	8b 55 08             	mov    0x8(%ebp),%edx
c0108627:	89 0a                	mov    %ecx,(%edx)
c0108629:	8b 00                	mov    (%eax),%eax
c010862b:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0108630:	5d                   	pop    %ebp
c0108631:	c3                   	ret    

c0108632 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0108632:	55                   	push   %ebp
c0108633:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108635:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108639:	7e 14                	jle    c010864f <getint+0x1d>
        return va_arg(*ap, long long);
c010863b:	8b 45 08             	mov    0x8(%ebp),%eax
c010863e:	8b 00                	mov    (%eax),%eax
c0108640:	8d 48 08             	lea    0x8(%eax),%ecx
c0108643:	8b 55 08             	mov    0x8(%ebp),%edx
c0108646:	89 0a                	mov    %ecx,(%edx)
c0108648:	8b 50 04             	mov    0x4(%eax),%edx
c010864b:	8b 00                	mov    (%eax),%eax
c010864d:	eb 28                	jmp    c0108677 <getint+0x45>
    }
    else if (lflag) {
c010864f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108653:	74 12                	je     c0108667 <getint+0x35>
        return va_arg(*ap, long);
c0108655:	8b 45 08             	mov    0x8(%ebp),%eax
c0108658:	8b 00                	mov    (%eax),%eax
c010865a:	8d 48 04             	lea    0x4(%eax),%ecx
c010865d:	8b 55 08             	mov    0x8(%ebp),%edx
c0108660:	89 0a                	mov    %ecx,(%edx)
c0108662:	8b 00                	mov    (%eax),%eax
c0108664:	99                   	cltd   
c0108665:	eb 10                	jmp    c0108677 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0108667:	8b 45 08             	mov    0x8(%ebp),%eax
c010866a:	8b 00                	mov    (%eax),%eax
c010866c:	8d 48 04             	lea    0x4(%eax),%ecx
c010866f:	8b 55 08             	mov    0x8(%ebp),%edx
c0108672:	89 0a                	mov    %ecx,(%edx)
c0108674:	8b 00                	mov    (%eax),%eax
c0108676:	99                   	cltd   
    }
}
c0108677:	5d                   	pop    %ebp
c0108678:	c3                   	ret    

c0108679 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0108679:	55                   	push   %ebp
c010867a:	89 e5                	mov    %esp,%ebp
c010867c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010867f:	8d 45 14             	lea    0x14(%ebp),%eax
c0108682:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0108685:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108688:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010868c:	8b 45 10             	mov    0x10(%ebp),%eax
c010868f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108693:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108696:	89 44 24 04          	mov    %eax,0x4(%esp)
c010869a:	8b 45 08             	mov    0x8(%ebp),%eax
c010869d:	89 04 24             	mov    %eax,(%esp)
c01086a0:	e8 02 00 00 00       	call   c01086a7 <vprintfmt>
    va_end(ap);
}
c01086a5:	c9                   	leave  
c01086a6:	c3                   	ret    

c01086a7 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01086a7:	55                   	push   %ebp
c01086a8:	89 e5                	mov    %esp,%ebp
c01086aa:	56                   	push   %esi
c01086ab:	53                   	push   %ebx
c01086ac:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01086af:	eb 18                	jmp    c01086c9 <vprintfmt+0x22>
            if (ch == '\0') {
c01086b1:	85 db                	test   %ebx,%ebx
c01086b3:	75 05                	jne    c01086ba <vprintfmt+0x13>
                return;
c01086b5:	e9 d1 03 00 00       	jmp    c0108a8b <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01086ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086c1:	89 1c 24             	mov    %ebx,(%esp)
c01086c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01086c7:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01086c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01086cc:	8d 50 01             	lea    0x1(%eax),%edx
c01086cf:	89 55 10             	mov    %edx,0x10(%ebp)
c01086d2:	0f b6 00             	movzbl (%eax),%eax
c01086d5:	0f b6 d8             	movzbl %al,%ebx
c01086d8:	83 fb 25             	cmp    $0x25,%ebx
c01086db:	75 d4                	jne    c01086b1 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01086dd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01086e1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01086e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01086eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01086ee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01086f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01086f8:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01086fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01086fe:	8d 50 01             	lea    0x1(%eax),%edx
c0108701:	89 55 10             	mov    %edx,0x10(%ebp)
c0108704:	0f b6 00             	movzbl (%eax),%eax
c0108707:	0f b6 d8             	movzbl %al,%ebx
c010870a:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010870d:	83 f8 55             	cmp    $0x55,%eax
c0108710:	0f 87 44 03 00 00    	ja     c0108a5a <vprintfmt+0x3b3>
c0108716:	8b 04 85 bc b0 10 c0 	mov    -0x3fef4f44(,%eax,4),%eax
c010871d:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010871f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0108723:	eb d6                	jmp    c01086fb <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0108725:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0108729:	eb d0                	jmp    c01086fb <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010872b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0108732:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108735:	89 d0                	mov    %edx,%eax
c0108737:	c1 e0 02             	shl    $0x2,%eax
c010873a:	01 d0                	add    %edx,%eax
c010873c:	01 c0                	add    %eax,%eax
c010873e:	01 d8                	add    %ebx,%eax
c0108740:	83 e8 30             	sub    $0x30,%eax
c0108743:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0108746:	8b 45 10             	mov    0x10(%ebp),%eax
c0108749:	0f b6 00             	movzbl (%eax),%eax
c010874c:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010874f:	83 fb 2f             	cmp    $0x2f,%ebx
c0108752:	7e 0b                	jle    c010875f <vprintfmt+0xb8>
c0108754:	83 fb 39             	cmp    $0x39,%ebx
c0108757:	7f 06                	jg     c010875f <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108759:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010875d:	eb d3                	jmp    c0108732 <vprintfmt+0x8b>
            goto process_precision;
c010875f:	eb 33                	jmp    c0108794 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0108761:	8b 45 14             	mov    0x14(%ebp),%eax
c0108764:	8d 50 04             	lea    0x4(%eax),%edx
c0108767:	89 55 14             	mov    %edx,0x14(%ebp)
c010876a:	8b 00                	mov    (%eax),%eax
c010876c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010876f:	eb 23                	jmp    c0108794 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0108771:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108775:	79 0c                	jns    c0108783 <vprintfmt+0xdc>
                width = 0;
c0108777:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010877e:	e9 78 ff ff ff       	jmp    c01086fb <vprintfmt+0x54>
c0108783:	e9 73 ff ff ff       	jmp    c01086fb <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0108788:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010878f:	e9 67 ff ff ff       	jmp    c01086fb <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0108794:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108798:	79 12                	jns    c01087ac <vprintfmt+0x105>
                width = precision, precision = -1;
c010879a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010879d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01087a0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01087a7:	e9 4f ff ff ff       	jmp    c01086fb <vprintfmt+0x54>
c01087ac:	e9 4a ff ff ff       	jmp    c01086fb <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01087b1:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01087b5:	e9 41 ff ff ff       	jmp    c01086fb <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01087ba:	8b 45 14             	mov    0x14(%ebp),%eax
c01087bd:	8d 50 04             	lea    0x4(%eax),%edx
c01087c0:	89 55 14             	mov    %edx,0x14(%ebp)
c01087c3:	8b 00                	mov    (%eax),%eax
c01087c5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01087c8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01087cc:	89 04 24             	mov    %eax,(%esp)
c01087cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01087d2:	ff d0                	call   *%eax
            break;
c01087d4:	e9 ac 02 00 00       	jmp    c0108a85 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01087d9:	8b 45 14             	mov    0x14(%ebp),%eax
c01087dc:	8d 50 04             	lea    0x4(%eax),%edx
c01087df:	89 55 14             	mov    %edx,0x14(%ebp)
c01087e2:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01087e4:	85 db                	test   %ebx,%ebx
c01087e6:	79 02                	jns    c01087ea <vprintfmt+0x143>
                err = -err;
c01087e8:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01087ea:	83 fb 06             	cmp    $0x6,%ebx
c01087ed:	7f 0b                	jg     c01087fa <vprintfmt+0x153>
c01087ef:	8b 34 9d 7c b0 10 c0 	mov    -0x3fef4f84(,%ebx,4),%esi
c01087f6:	85 f6                	test   %esi,%esi
c01087f8:	75 23                	jne    c010881d <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01087fa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01087fe:	c7 44 24 08 a9 b0 10 	movl   $0xc010b0a9,0x8(%esp)
c0108805:	c0 
c0108806:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108809:	89 44 24 04          	mov    %eax,0x4(%esp)
c010880d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108810:	89 04 24             	mov    %eax,(%esp)
c0108813:	e8 61 fe ff ff       	call   c0108679 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0108818:	e9 68 02 00 00       	jmp    c0108a85 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010881d:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0108821:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0108828:	c0 
c0108829:	8b 45 0c             	mov    0xc(%ebp),%eax
c010882c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108830:	8b 45 08             	mov    0x8(%ebp),%eax
c0108833:	89 04 24             	mov    %eax,(%esp)
c0108836:	e8 3e fe ff ff       	call   c0108679 <printfmt>
            }
            break;
c010883b:	e9 45 02 00 00       	jmp    c0108a85 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0108840:	8b 45 14             	mov    0x14(%ebp),%eax
c0108843:	8d 50 04             	lea    0x4(%eax),%edx
c0108846:	89 55 14             	mov    %edx,0x14(%ebp)
c0108849:	8b 30                	mov    (%eax),%esi
c010884b:	85 f6                	test   %esi,%esi
c010884d:	75 05                	jne    c0108854 <vprintfmt+0x1ad>
                p = "(null)";
c010884f:	be b5 b0 10 c0       	mov    $0xc010b0b5,%esi
            }
            if (width > 0 && padc != '-') {
c0108854:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108858:	7e 3e                	jle    c0108898 <vprintfmt+0x1f1>
c010885a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010885e:	74 38                	je     c0108898 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108860:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0108863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108866:	89 44 24 04          	mov    %eax,0x4(%esp)
c010886a:	89 34 24             	mov    %esi,(%esp)
c010886d:	e8 ed 03 00 00       	call   c0108c5f <strnlen>
c0108872:	29 c3                	sub    %eax,%ebx
c0108874:	89 d8                	mov    %ebx,%eax
c0108876:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108879:	eb 17                	jmp    c0108892 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010887b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010887f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108882:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108886:	89 04 24             	mov    %eax,(%esp)
c0108889:	8b 45 08             	mov    0x8(%ebp),%eax
c010888c:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010888e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108892:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108896:	7f e3                	jg     c010887b <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108898:	eb 38                	jmp    c01088d2 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010889a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010889e:	74 1f                	je     c01088bf <vprintfmt+0x218>
c01088a0:	83 fb 1f             	cmp    $0x1f,%ebx
c01088a3:	7e 05                	jle    c01088aa <vprintfmt+0x203>
c01088a5:	83 fb 7e             	cmp    $0x7e,%ebx
c01088a8:	7e 15                	jle    c01088bf <vprintfmt+0x218>
                    putch('?', putdat);
c01088aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01088b1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01088b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01088bb:	ff d0                	call   *%eax
c01088bd:	eb 0f                	jmp    c01088ce <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01088bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01088c6:	89 1c 24             	mov    %ebx,(%esp)
c01088c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01088cc:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01088ce:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01088d2:	89 f0                	mov    %esi,%eax
c01088d4:	8d 70 01             	lea    0x1(%eax),%esi
c01088d7:	0f b6 00             	movzbl (%eax),%eax
c01088da:	0f be d8             	movsbl %al,%ebx
c01088dd:	85 db                	test   %ebx,%ebx
c01088df:	74 10                	je     c01088f1 <vprintfmt+0x24a>
c01088e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01088e5:	78 b3                	js     c010889a <vprintfmt+0x1f3>
c01088e7:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01088eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01088ef:	79 a9                	jns    c010889a <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01088f1:	eb 17                	jmp    c010890a <vprintfmt+0x263>
                putch(' ', putdat);
c01088f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01088fa:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0108901:	8b 45 08             	mov    0x8(%ebp),%eax
c0108904:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0108906:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010890a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010890e:	7f e3                	jg     c01088f3 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0108910:	e9 70 01 00 00       	jmp    c0108a85 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0108915:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108918:	89 44 24 04          	mov    %eax,0x4(%esp)
c010891c:	8d 45 14             	lea    0x14(%ebp),%eax
c010891f:	89 04 24             	mov    %eax,(%esp)
c0108922:	e8 0b fd ff ff       	call   c0108632 <getint>
c0108927:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010892a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010892d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108930:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108933:	85 d2                	test   %edx,%edx
c0108935:	79 26                	jns    c010895d <vprintfmt+0x2b6>
                putch('-', putdat);
c0108937:	8b 45 0c             	mov    0xc(%ebp),%eax
c010893a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010893e:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0108945:	8b 45 08             	mov    0x8(%ebp),%eax
c0108948:	ff d0                	call   *%eax
                num = -(long long)num;
c010894a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010894d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108950:	f7 d8                	neg    %eax
c0108952:	83 d2 00             	adc    $0x0,%edx
c0108955:	f7 da                	neg    %edx
c0108957:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010895a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010895d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0108964:	e9 a8 00 00 00       	jmp    c0108a11 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0108969:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010896c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108970:	8d 45 14             	lea    0x14(%ebp),%eax
c0108973:	89 04 24             	mov    %eax,(%esp)
c0108976:	e8 68 fc ff ff       	call   c01085e3 <getuint>
c010897b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010897e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0108981:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0108988:	e9 84 00 00 00       	jmp    c0108a11 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010898d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108990:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108994:	8d 45 14             	lea    0x14(%ebp),%eax
c0108997:	89 04 24             	mov    %eax,(%esp)
c010899a:	e8 44 fc ff ff       	call   c01085e3 <getuint>
c010899f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01089a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01089a5:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01089ac:	eb 63                	jmp    c0108a11 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01089ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089b5:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01089bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01089bf:	ff d0                	call   *%eax
            putch('x', putdat);
c01089c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089c8:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01089cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01089d2:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01089d4:	8b 45 14             	mov    0x14(%ebp),%eax
c01089d7:	8d 50 04             	lea    0x4(%eax),%edx
c01089da:	89 55 14             	mov    %edx,0x14(%ebp)
c01089dd:	8b 00                	mov    (%eax),%eax
c01089df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01089e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01089e9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01089f0:	eb 1f                	jmp    c0108a11 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01089f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01089f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089f9:	8d 45 14             	lea    0x14(%ebp),%eax
c01089fc:	89 04 24             	mov    %eax,(%esp)
c01089ff:	e8 df fb ff ff       	call   c01085e3 <getuint>
c0108a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a07:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0108a0a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0108a11:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0108a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a18:	89 54 24 18          	mov    %edx,0x18(%esp)
c0108a1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108a1f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108a23:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108a2d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108a31:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108a35:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a3f:	89 04 24             	mov    %eax,(%esp)
c0108a42:	e8 97 fa ff ff       	call   c01084de <printnum>
            break;
c0108a47:	eb 3c                	jmp    c0108a85 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0108a49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a50:	89 1c 24             	mov    %ebx,(%esp)
c0108a53:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a56:	ff d0                	call   *%eax
            break;
c0108a58:	eb 2b                	jmp    c0108a85 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0108a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a61:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0108a68:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a6b:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108a6d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108a71:	eb 04                	jmp    c0108a77 <vprintfmt+0x3d0>
c0108a73:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108a77:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a7a:	83 e8 01             	sub    $0x1,%eax
c0108a7d:	0f b6 00             	movzbl (%eax),%eax
c0108a80:	3c 25                	cmp    $0x25,%al
c0108a82:	75 ef                	jne    c0108a73 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0108a84:	90                   	nop
        }
    }
c0108a85:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108a86:	e9 3e fc ff ff       	jmp    c01086c9 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0108a8b:	83 c4 40             	add    $0x40,%esp
c0108a8e:	5b                   	pop    %ebx
c0108a8f:	5e                   	pop    %esi
c0108a90:	5d                   	pop    %ebp
c0108a91:	c3                   	ret    

c0108a92 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0108a92:	55                   	push   %ebp
c0108a93:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0108a95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a98:	8b 40 08             	mov    0x8(%eax),%eax
c0108a9b:	8d 50 01             	lea    0x1(%eax),%edx
c0108a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108aa1:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0108aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108aa7:	8b 10                	mov    (%eax),%edx
c0108aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108aac:	8b 40 04             	mov    0x4(%eax),%eax
c0108aaf:	39 c2                	cmp    %eax,%edx
c0108ab1:	73 12                	jae    c0108ac5 <sprintputch+0x33>
        *b->buf ++ = ch;
c0108ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ab6:	8b 00                	mov    (%eax),%eax
c0108ab8:	8d 48 01             	lea    0x1(%eax),%ecx
c0108abb:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108abe:	89 0a                	mov    %ecx,(%edx)
c0108ac0:	8b 55 08             	mov    0x8(%ebp),%edx
c0108ac3:	88 10                	mov    %dl,(%eax)
    }
}
c0108ac5:	5d                   	pop    %ebp
c0108ac6:	c3                   	ret    

c0108ac7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0108ac7:	55                   	push   %ebp
c0108ac8:	89 e5                	mov    %esp,%ebp
c0108aca:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0108acd:	8d 45 14             	lea    0x14(%ebp),%eax
c0108ad0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0108ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ad6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108ada:	8b 45 10             	mov    0x10(%ebp),%eax
c0108add:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ae8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aeb:	89 04 24             	mov    %eax,(%esp)
c0108aee:	e8 08 00 00 00       	call   c0108afb <vsnprintf>
c0108af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0108af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108af9:	c9                   	leave  
c0108afa:	c3                   	ret    

c0108afb <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0108afb:	55                   	push   %ebp
c0108afc:	89 e5                	mov    %esp,%ebp
c0108afe:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0108b01:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b04:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108b07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b0a:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b10:	01 d0                	add    %edx,%eax
c0108b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0108b1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108b20:	74 0a                	je     c0108b2c <vsnprintf+0x31>
c0108b22:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b28:	39 c2                	cmp    %eax,%edx
c0108b2a:	76 07                	jbe    c0108b33 <vsnprintf+0x38>
        return -E_INVAL;
c0108b2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108b31:	eb 2a                	jmp    c0108b5d <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0108b33:	8b 45 14             	mov    0x14(%ebp),%eax
c0108b36:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108b3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b3d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108b41:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0108b44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108b48:	c7 04 24 92 8a 10 c0 	movl   $0xc0108a92,(%esp)
c0108b4f:	e8 53 fb ff ff       	call   c01086a7 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0108b54:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b57:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0108b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108b5d:	c9                   	leave  
c0108b5e:	c3                   	ret    

c0108b5f <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0108b5f:	55                   	push   %ebp
c0108b60:	89 e5                	mov    %esp,%ebp
c0108b62:	57                   	push   %edi
c0108b63:	56                   	push   %esi
c0108b64:	53                   	push   %ebx
c0108b65:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0108b68:	a1 80 1a 12 c0       	mov    0xc0121a80,%eax
c0108b6d:	8b 15 84 1a 12 c0    	mov    0xc0121a84,%edx
c0108b73:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0108b79:	6b f0 05             	imul   $0x5,%eax,%esi
c0108b7c:	01 f7                	add    %esi,%edi
c0108b7e:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c0108b83:	f7 e6                	mul    %esi
c0108b85:	8d 34 17             	lea    (%edi,%edx,1),%esi
c0108b88:	89 f2                	mov    %esi,%edx
c0108b8a:	83 c0 0b             	add    $0xb,%eax
c0108b8d:	83 d2 00             	adc    $0x0,%edx
c0108b90:	89 c7                	mov    %eax,%edi
c0108b92:	83 e7 ff             	and    $0xffffffff,%edi
c0108b95:	89 f9                	mov    %edi,%ecx
c0108b97:	0f b7 da             	movzwl %dx,%ebx
c0108b9a:	89 0d 80 1a 12 c0    	mov    %ecx,0xc0121a80
c0108ba0:	89 1d 84 1a 12 c0    	mov    %ebx,0xc0121a84
    unsigned long long result = (next >> 12);
c0108ba6:	a1 80 1a 12 c0       	mov    0xc0121a80,%eax
c0108bab:	8b 15 84 1a 12 c0    	mov    0xc0121a84,%edx
c0108bb1:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0108bb5:	c1 ea 0c             	shr    $0xc,%edx
c0108bb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108bbb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0108bbe:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0108bc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108bc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108bcb:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108bce:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108bd7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108bdb:	74 1c                	je     c0108bf9 <rand+0x9a>
c0108bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108be0:	ba 00 00 00 00       	mov    $0x0,%edx
c0108be5:	f7 75 dc             	divl   -0x24(%ebp)
c0108be8:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108beb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bee:	ba 00 00 00 00       	mov    $0x0,%edx
c0108bf3:	f7 75 dc             	divl   -0x24(%ebp)
c0108bf6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108bf9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108bfc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108bff:	f7 75 dc             	divl   -0x24(%ebp)
c0108c02:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108c05:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108c0b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108c0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108c11:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108c14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0108c17:	83 c4 24             	add    $0x24,%esp
c0108c1a:	5b                   	pop    %ebx
c0108c1b:	5e                   	pop    %esi
c0108c1c:	5f                   	pop    %edi
c0108c1d:	5d                   	pop    %ebp
c0108c1e:	c3                   	ret    

c0108c1f <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0108c1f:	55                   	push   %ebp
c0108c20:	89 e5                	mov    %esp,%ebp
    next = seed;
c0108c22:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c25:	ba 00 00 00 00       	mov    $0x0,%edx
c0108c2a:	a3 80 1a 12 c0       	mov    %eax,0xc0121a80
c0108c2f:	89 15 84 1a 12 c0    	mov    %edx,0xc0121a84
}
c0108c35:	5d                   	pop    %ebp
c0108c36:	c3                   	ret    

c0108c37 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0108c37:	55                   	push   %ebp
c0108c38:	89 e5                	mov    %esp,%ebp
c0108c3a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108c3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0108c44:	eb 04                	jmp    c0108c4a <strlen+0x13>
        cnt ++;
c0108c46:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0108c4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c4d:	8d 50 01             	lea    0x1(%eax),%edx
c0108c50:	89 55 08             	mov    %edx,0x8(%ebp)
c0108c53:	0f b6 00             	movzbl (%eax),%eax
c0108c56:	84 c0                	test   %al,%al
c0108c58:	75 ec                	jne    c0108c46 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0108c5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108c5d:	c9                   	leave  
c0108c5e:	c3                   	ret    

c0108c5f <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0108c5f:	55                   	push   %ebp
c0108c60:	89 e5                	mov    %esp,%ebp
c0108c62:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108c65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108c6c:	eb 04                	jmp    c0108c72 <strnlen+0x13>
        cnt ++;
c0108c6e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0108c72:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108c75:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108c78:	73 10                	jae    c0108c8a <strnlen+0x2b>
c0108c7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c7d:	8d 50 01             	lea    0x1(%eax),%edx
c0108c80:	89 55 08             	mov    %edx,0x8(%ebp)
c0108c83:	0f b6 00             	movzbl (%eax),%eax
c0108c86:	84 c0                	test   %al,%al
c0108c88:	75 e4                	jne    c0108c6e <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0108c8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108c8d:	c9                   	leave  
c0108c8e:	c3                   	ret    

c0108c8f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0108c8f:	55                   	push   %ebp
c0108c90:	89 e5                	mov    %esp,%ebp
c0108c92:	57                   	push   %edi
c0108c93:	56                   	push   %esi
c0108c94:	83 ec 20             	sub    $0x20,%esp
c0108c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ca0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0108ca3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ca9:	89 d1                	mov    %edx,%ecx
c0108cab:	89 c2                	mov    %eax,%edx
c0108cad:	89 ce                	mov    %ecx,%esi
c0108caf:	89 d7                	mov    %edx,%edi
c0108cb1:	ac                   	lods   %ds:(%esi),%al
c0108cb2:	aa                   	stos   %al,%es:(%edi)
c0108cb3:	84 c0                	test   %al,%al
c0108cb5:	75 fa                	jne    c0108cb1 <strcpy+0x22>
c0108cb7:	89 fa                	mov    %edi,%edx
c0108cb9:	89 f1                	mov    %esi,%ecx
c0108cbb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108cbe:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108cc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0108cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0108cc7:	83 c4 20             	add    $0x20,%esp
c0108cca:	5e                   	pop    %esi
c0108ccb:	5f                   	pop    %edi
c0108ccc:	5d                   	pop    %ebp
c0108ccd:	c3                   	ret    

c0108cce <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0108cce:	55                   	push   %ebp
c0108ccf:	89 e5                	mov    %esp,%ebp
c0108cd1:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0108cd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0108cda:	eb 21                	jmp    c0108cfd <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0108cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108cdf:	0f b6 10             	movzbl (%eax),%edx
c0108ce2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108ce5:	88 10                	mov    %dl,(%eax)
c0108ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108cea:	0f b6 00             	movzbl (%eax),%eax
c0108ced:	84 c0                	test   %al,%al
c0108cef:	74 04                	je     c0108cf5 <strncpy+0x27>
            src ++;
c0108cf1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0108cf5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108cf9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0108cfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108d01:	75 d9                	jne    c0108cdc <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0108d03:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108d06:	c9                   	leave  
c0108d07:	c3                   	ret    

c0108d08 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0108d08:	55                   	push   %ebp
c0108d09:	89 e5                	mov    %esp,%ebp
c0108d0b:	57                   	push   %edi
c0108d0c:	56                   	push   %esi
c0108d0d:	83 ec 20             	sub    $0x20,%esp
c0108d10:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108d16:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0108d1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d22:	89 d1                	mov    %edx,%ecx
c0108d24:	89 c2                	mov    %eax,%edx
c0108d26:	89 ce                	mov    %ecx,%esi
c0108d28:	89 d7                	mov    %edx,%edi
c0108d2a:	ac                   	lods   %ds:(%esi),%al
c0108d2b:	ae                   	scas   %es:(%edi),%al
c0108d2c:	75 08                	jne    c0108d36 <strcmp+0x2e>
c0108d2e:	84 c0                	test   %al,%al
c0108d30:	75 f8                	jne    c0108d2a <strcmp+0x22>
c0108d32:	31 c0                	xor    %eax,%eax
c0108d34:	eb 04                	jmp    c0108d3a <strcmp+0x32>
c0108d36:	19 c0                	sbb    %eax,%eax
c0108d38:	0c 01                	or     $0x1,%al
c0108d3a:	89 fa                	mov    %edi,%edx
c0108d3c:	89 f1                	mov    %esi,%ecx
c0108d3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108d41:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108d44:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0108d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0108d4a:	83 c4 20             	add    $0x20,%esp
c0108d4d:	5e                   	pop    %esi
c0108d4e:	5f                   	pop    %edi
c0108d4f:	5d                   	pop    %ebp
c0108d50:	c3                   	ret    

c0108d51 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0108d51:	55                   	push   %ebp
c0108d52:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108d54:	eb 0c                	jmp    c0108d62 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0108d56:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108d5a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108d5e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108d66:	74 1a                	je     c0108d82 <strncmp+0x31>
c0108d68:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d6b:	0f b6 00             	movzbl (%eax),%eax
c0108d6e:	84 c0                	test   %al,%al
c0108d70:	74 10                	je     c0108d82 <strncmp+0x31>
c0108d72:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d75:	0f b6 10             	movzbl (%eax),%edx
c0108d78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d7b:	0f b6 00             	movzbl (%eax),%eax
c0108d7e:	38 c2                	cmp    %al,%dl
c0108d80:	74 d4                	je     c0108d56 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108d82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108d86:	74 18                	je     c0108da0 <strncmp+0x4f>
c0108d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d8b:	0f b6 00             	movzbl (%eax),%eax
c0108d8e:	0f b6 d0             	movzbl %al,%edx
c0108d91:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d94:	0f b6 00             	movzbl (%eax),%eax
c0108d97:	0f b6 c0             	movzbl %al,%eax
c0108d9a:	29 c2                	sub    %eax,%edx
c0108d9c:	89 d0                	mov    %edx,%eax
c0108d9e:	eb 05                	jmp    c0108da5 <strncmp+0x54>
c0108da0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108da5:	5d                   	pop    %ebp
c0108da6:	c3                   	ret    

c0108da7 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0108da7:	55                   	push   %ebp
c0108da8:	89 e5                	mov    %esp,%ebp
c0108daa:	83 ec 04             	sub    $0x4,%esp
c0108dad:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108db0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108db3:	eb 14                	jmp    c0108dc9 <strchr+0x22>
        if (*s == c) {
c0108db5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108db8:	0f b6 00             	movzbl (%eax),%eax
c0108dbb:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108dbe:	75 05                	jne    c0108dc5 <strchr+0x1e>
            return (char *)s;
c0108dc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dc3:	eb 13                	jmp    c0108dd8 <strchr+0x31>
        }
        s ++;
c0108dc5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0108dc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dcc:	0f b6 00             	movzbl (%eax),%eax
c0108dcf:	84 c0                	test   %al,%al
c0108dd1:	75 e2                	jne    c0108db5 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0108dd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108dd8:	c9                   	leave  
c0108dd9:	c3                   	ret    

c0108dda <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0108dda:	55                   	push   %ebp
c0108ddb:	89 e5                	mov    %esp,%ebp
c0108ddd:	83 ec 04             	sub    $0x4,%esp
c0108de0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108de3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108de6:	eb 11                	jmp    c0108df9 <strfind+0x1f>
        if (*s == c) {
c0108de8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108deb:	0f b6 00             	movzbl (%eax),%eax
c0108dee:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108df1:	75 02                	jne    c0108df5 <strfind+0x1b>
            break;
c0108df3:	eb 0e                	jmp    c0108e03 <strfind+0x29>
        }
        s ++;
c0108df5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0108df9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dfc:	0f b6 00             	movzbl (%eax),%eax
c0108dff:	84 c0                	test   %al,%al
c0108e01:	75 e5                	jne    c0108de8 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0108e03:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108e06:	c9                   	leave  
c0108e07:	c3                   	ret    

c0108e08 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0108e08:	55                   	push   %ebp
c0108e09:	89 e5                	mov    %esp,%ebp
c0108e0b:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0108e0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0108e15:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108e1c:	eb 04                	jmp    c0108e22 <strtol+0x1a>
        s ++;
c0108e1e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108e22:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e25:	0f b6 00             	movzbl (%eax),%eax
c0108e28:	3c 20                	cmp    $0x20,%al
c0108e2a:	74 f2                	je     c0108e1e <strtol+0x16>
c0108e2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e2f:	0f b6 00             	movzbl (%eax),%eax
c0108e32:	3c 09                	cmp    $0x9,%al
c0108e34:	74 e8                	je     c0108e1e <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0108e36:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e39:	0f b6 00             	movzbl (%eax),%eax
c0108e3c:	3c 2b                	cmp    $0x2b,%al
c0108e3e:	75 06                	jne    c0108e46 <strtol+0x3e>
        s ++;
c0108e40:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108e44:	eb 15                	jmp    c0108e5b <strtol+0x53>
    }
    else if (*s == '-') {
c0108e46:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e49:	0f b6 00             	movzbl (%eax),%eax
c0108e4c:	3c 2d                	cmp    $0x2d,%al
c0108e4e:	75 0b                	jne    c0108e5b <strtol+0x53>
        s ++, neg = 1;
c0108e50:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108e54:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0108e5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108e5f:	74 06                	je     c0108e67 <strtol+0x5f>
c0108e61:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0108e65:	75 24                	jne    c0108e8b <strtol+0x83>
c0108e67:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e6a:	0f b6 00             	movzbl (%eax),%eax
c0108e6d:	3c 30                	cmp    $0x30,%al
c0108e6f:	75 1a                	jne    c0108e8b <strtol+0x83>
c0108e71:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e74:	83 c0 01             	add    $0x1,%eax
c0108e77:	0f b6 00             	movzbl (%eax),%eax
c0108e7a:	3c 78                	cmp    $0x78,%al
c0108e7c:	75 0d                	jne    c0108e8b <strtol+0x83>
        s += 2, base = 16;
c0108e7e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108e82:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0108e89:	eb 2a                	jmp    c0108eb5 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0108e8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108e8f:	75 17                	jne    c0108ea8 <strtol+0xa0>
c0108e91:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e94:	0f b6 00             	movzbl (%eax),%eax
c0108e97:	3c 30                	cmp    $0x30,%al
c0108e99:	75 0d                	jne    c0108ea8 <strtol+0xa0>
        s ++, base = 8;
c0108e9b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108e9f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108ea6:	eb 0d                	jmp    c0108eb5 <strtol+0xad>
    }
    else if (base == 0) {
c0108ea8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108eac:	75 07                	jne    c0108eb5 <strtol+0xad>
        base = 10;
c0108eae:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108eb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108eb8:	0f b6 00             	movzbl (%eax),%eax
c0108ebb:	3c 2f                	cmp    $0x2f,%al
c0108ebd:	7e 1b                	jle    c0108eda <strtol+0xd2>
c0108ebf:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ec2:	0f b6 00             	movzbl (%eax),%eax
c0108ec5:	3c 39                	cmp    $0x39,%al
c0108ec7:	7f 11                	jg     c0108eda <strtol+0xd2>
            dig = *s - '0';
c0108ec9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ecc:	0f b6 00             	movzbl (%eax),%eax
c0108ecf:	0f be c0             	movsbl %al,%eax
c0108ed2:	83 e8 30             	sub    $0x30,%eax
c0108ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108ed8:	eb 48                	jmp    c0108f22 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0108eda:	8b 45 08             	mov    0x8(%ebp),%eax
c0108edd:	0f b6 00             	movzbl (%eax),%eax
c0108ee0:	3c 60                	cmp    $0x60,%al
c0108ee2:	7e 1b                	jle    c0108eff <strtol+0xf7>
c0108ee4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ee7:	0f b6 00             	movzbl (%eax),%eax
c0108eea:	3c 7a                	cmp    $0x7a,%al
c0108eec:	7f 11                	jg     c0108eff <strtol+0xf7>
            dig = *s - 'a' + 10;
c0108eee:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ef1:	0f b6 00             	movzbl (%eax),%eax
c0108ef4:	0f be c0             	movsbl %al,%eax
c0108ef7:	83 e8 57             	sub    $0x57,%eax
c0108efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108efd:	eb 23                	jmp    c0108f22 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0108eff:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f02:	0f b6 00             	movzbl (%eax),%eax
c0108f05:	3c 40                	cmp    $0x40,%al
c0108f07:	7e 3d                	jle    c0108f46 <strtol+0x13e>
c0108f09:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f0c:	0f b6 00             	movzbl (%eax),%eax
c0108f0f:	3c 5a                	cmp    $0x5a,%al
c0108f11:	7f 33                	jg     c0108f46 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0108f13:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f16:	0f b6 00             	movzbl (%eax),%eax
c0108f19:	0f be c0             	movsbl %al,%eax
c0108f1c:	83 e8 37             	sub    $0x37,%eax
c0108f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f25:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108f28:	7c 02                	jl     c0108f2c <strtol+0x124>
            break;
c0108f2a:	eb 1a                	jmp    c0108f46 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0108f2c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108f30:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108f33:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108f37:	89 c2                	mov    %eax,%edx
c0108f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f3c:	01 d0                	add    %edx,%eax
c0108f3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0108f41:	e9 6f ff ff ff       	jmp    c0108eb5 <strtol+0xad>

    if (endptr) {
c0108f46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108f4a:	74 08                	je     c0108f54 <strtol+0x14c>
        *endptr = (char *) s;
c0108f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108f4f:	8b 55 08             	mov    0x8(%ebp),%edx
c0108f52:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108f54:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108f58:	74 07                	je     c0108f61 <strtol+0x159>
c0108f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108f5d:	f7 d8                	neg    %eax
c0108f5f:	eb 03                	jmp    c0108f64 <strtol+0x15c>
c0108f61:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108f64:	c9                   	leave  
c0108f65:	c3                   	ret    

c0108f66 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108f66:	55                   	push   %ebp
c0108f67:	89 e5                	mov    %esp,%ebp
c0108f69:	57                   	push   %edi
c0108f6a:	83 ec 24             	sub    $0x24,%esp
c0108f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108f70:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108f73:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108f77:	8b 55 08             	mov    0x8(%ebp),%edx
c0108f7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0108f7d:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108f80:	8b 45 10             	mov    0x10(%ebp),%eax
c0108f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108f86:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108f89:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0108f8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108f90:	89 d7                	mov    %edx,%edi
c0108f92:	f3 aa                	rep stos %al,%es:(%edi)
c0108f94:	89 fa                	mov    %edi,%edx
c0108f96:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108f99:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108f9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108f9f:	83 c4 24             	add    $0x24,%esp
c0108fa2:	5f                   	pop    %edi
c0108fa3:	5d                   	pop    %ebp
c0108fa4:	c3                   	ret    

c0108fa5 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108fa5:	55                   	push   %ebp
c0108fa6:	89 e5                	mov    %esp,%ebp
c0108fa8:	57                   	push   %edi
c0108fa9:	56                   	push   %esi
c0108faa:	53                   	push   %ebx
c0108fab:	83 ec 30             	sub    $0x30,%esp
c0108fae:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108fb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108fba:	8b 45 10             	mov    0x10(%ebp),%eax
c0108fbd:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108fc3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108fc6:	73 42                	jae    c010900a <memmove+0x65>
c0108fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108fcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108fd1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108fd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108fd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108fda:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108fdd:	c1 e8 02             	shr    $0x2,%eax
c0108fe0:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108fe2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108fe5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108fe8:	89 d7                	mov    %edx,%edi
c0108fea:	89 c6                	mov    %eax,%esi
c0108fec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108fee:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108ff1:	83 e1 03             	and    $0x3,%ecx
c0108ff4:	74 02                	je     c0108ff8 <memmove+0x53>
c0108ff6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108ff8:	89 f0                	mov    %esi,%eax
c0108ffa:	89 fa                	mov    %edi,%edx
c0108ffc:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108fff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109002:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109005:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109008:	eb 36                	jmp    c0109040 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010900a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010900d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109010:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109013:	01 c2                	add    %eax,%edx
c0109015:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109018:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010901b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010901e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0109021:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109024:	89 c1                	mov    %eax,%ecx
c0109026:	89 d8                	mov    %ebx,%eax
c0109028:	89 d6                	mov    %edx,%esi
c010902a:	89 c7                	mov    %eax,%edi
c010902c:	fd                   	std    
c010902d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010902f:	fc                   	cld    
c0109030:	89 f8                	mov    %edi,%eax
c0109032:	89 f2                	mov    %esi,%edx
c0109034:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0109037:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010903a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010903d:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109040:	83 c4 30             	add    $0x30,%esp
c0109043:	5b                   	pop    %ebx
c0109044:	5e                   	pop    %esi
c0109045:	5f                   	pop    %edi
c0109046:	5d                   	pop    %ebp
c0109047:	c3                   	ret    

c0109048 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109048:	55                   	push   %ebp
c0109049:	89 e5                	mov    %esp,%ebp
c010904b:	57                   	push   %edi
c010904c:	56                   	push   %esi
c010904d:	83 ec 20             	sub    $0x20,%esp
c0109050:	8b 45 08             	mov    0x8(%ebp),%eax
c0109053:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109056:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109059:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010905c:	8b 45 10             	mov    0x10(%ebp),%eax
c010905f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109062:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109065:	c1 e8 02             	shr    $0x2,%eax
c0109068:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010906a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010906d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109070:	89 d7                	mov    %edx,%edi
c0109072:	89 c6                	mov    %eax,%esi
c0109074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109076:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109079:	83 e1 03             	and    $0x3,%ecx
c010907c:	74 02                	je     c0109080 <memcpy+0x38>
c010907e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109080:	89 f0                	mov    %esi,%eax
c0109082:	89 fa                	mov    %edi,%edx
c0109084:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109087:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010908a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010908d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0109090:	83 c4 20             	add    $0x20,%esp
c0109093:	5e                   	pop    %esi
c0109094:	5f                   	pop    %edi
c0109095:	5d                   	pop    %ebp
c0109096:	c3                   	ret    

c0109097 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109097:	55                   	push   %ebp
c0109098:	89 e5                	mov    %esp,%ebp
c010909a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010909d:	8b 45 08             	mov    0x8(%ebp),%eax
c01090a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01090a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01090a9:	eb 30                	jmp    c01090db <memcmp+0x44>
        if (*s1 != *s2) {
c01090ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01090ae:	0f b6 10             	movzbl (%eax),%edx
c01090b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01090b4:	0f b6 00             	movzbl (%eax),%eax
c01090b7:	38 c2                	cmp    %al,%dl
c01090b9:	74 18                	je     c01090d3 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01090bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01090be:	0f b6 00             	movzbl (%eax),%eax
c01090c1:	0f b6 d0             	movzbl %al,%edx
c01090c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01090c7:	0f b6 00             	movzbl (%eax),%eax
c01090ca:	0f b6 c0             	movzbl %al,%eax
c01090cd:	29 c2                	sub    %eax,%edx
c01090cf:	89 d0                	mov    %edx,%eax
c01090d1:	eb 1a                	jmp    c01090ed <memcmp+0x56>
        }
        s1 ++, s2 ++;
c01090d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01090d7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c01090db:	8b 45 10             	mov    0x10(%ebp),%eax
c01090de:	8d 50 ff             	lea    -0x1(%eax),%edx
c01090e1:	89 55 10             	mov    %edx,0x10(%ebp)
c01090e4:	85 c0                	test   %eax,%eax
c01090e6:	75 c3                	jne    c01090ab <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c01090e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01090ed:	c9                   	leave  
c01090ee:	c3                   	ret    
