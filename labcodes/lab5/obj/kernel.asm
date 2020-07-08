
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 a0 12 00 	lgdtl  0x12a018
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
c010001e:	bc 00 a0 12 c0       	mov    $0xc012a000,%esp
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
c0100030:	ba b8 f0 19 c0       	mov    $0xc019f0b8,%edx
c0100035:	b8 2a bf 19 c0       	mov    $0xc019bf2a,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 2a bf 19 c0 	movl   $0xc019bf2a,(%esp)
c0100051:	e8 d6 ba 00 00       	call   c010bb2c <memset>

    cons_init();                // init the console
c0100056:	e8 80 16 00 00       	call   c01016db <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 c0 bc 10 c0 	movl   $0xc010bcc0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 dc bc 10 c0 	movl   $0xc010bcdc,(%esp)
c0100070:	e8 de 02 00 00       	call   c0100353 <cprintf>

    print_kerninfo();
c0100075:	e8 05 09 00 00       	call   c010097f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 9d 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 e9 55 00 00       	call   c010566d <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 30 20 00 00       	call   c01020b9 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 82 21 00 00       	call   c0102210 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 97 84 00 00       	call   c010852a <vmm_init>
    proc_init();                // init process table
c0100093:	e8 57 aa 00 00       	call   c010aaef <proc_init>
    
    ide_init();                 // init ide devices
c0100098:	e8 6f 17 00 00       	call   c010180c <ide_init>
    swap_init();                // init swap
c010009d:	e8 80 6c 00 00       	call   c0106d22 <swap_init>

    clock_init();               // init clock interrupt
c01000a2:	e8 ea 0d 00 00       	call   c0100e91 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a7:	e8 7b 1f 00 00       	call   c0102027 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000ac:	e8 fd ab 00 00       	call   c010acae <cpu_idle>

c01000b1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b1:	55                   	push   %ebp
c01000b2:	89 e5                	mov    %esp,%ebp
c01000b4:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000be:	00 
c01000bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c6:	00 
c01000c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000ce:	e8 f0 0c 00 00       	call   c0100dc3 <mon_backtrace>
}
c01000d3:	c9                   	leave  
c01000d4:	c3                   	ret    

c01000d5 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d5:	55                   	push   %ebp
c01000d6:	89 e5                	mov    %esp,%ebp
c01000d8:	53                   	push   %ebx
c01000d9:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000dc:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e2:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000ec:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f4:	89 04 24             	mov    %eax,(%esp)
c01000f7:	e8 b5 ff ff ff       	call   c01000b1 <grade_backtrace2>
}
c01000fc:	83 c4 14             	add    $0x14,%esp
c01000ff:	5b                   	pop    %ebx
c0100100:	5d                   	pop    %ebp
c0100101:	c3                   	ret    

c0100102 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100102:	55                   	push   %ebp
c0100103:	89 e5                	mov    %esp,%ebp
c0100105:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100108:	8b 45 10             	mov    0x10(%ebp),%eax
c010010b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010010f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100112:	89 04 24             	mov    %eax,(%esp)
c0100115:	e8 bb ff ff ff       	call   c01000d5 <grade_backtrace1>
}
c010011a:	c9                   	leave  
c010011b:	c3                   	ret    

c010011c <grade_backtrace>:

void
grade_backtrace(void) {
c010011c:	55                   	push   %ebp
c010011d:	89 e5                	mov    %esp,%ebp
c010011f:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100122:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100127:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010012e:	ff 
c010012f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013a:	e8 c3 ff ff ff       	call   c0100102 <grade_backtrace0>
}
c010013f:	c9                   	leave  
c0100140:	c3                   	ret    

c0100141 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100141:	55                   	push   %ebp
c0100142:	89 e5                	mov    %esp,%ebp
c0100144:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100147:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014a:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014d:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100150:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100153:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100157:	0f b7 c0             	movzwl %ax,%eax
c010015a:	83 e0 03             	and    $0x3,%eax
c010015d:	89 c2                	mov    %eax,%edx
c010015f:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 e1 bc 10 c0 	movl   $0xc010bce1,(%esp)
c0100173:	e8 db 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	0f b7 d0             	movzwl %ax,%edx
c010017f:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c0100184:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100188:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018c:	c7 04 24 ef bc 10 c0 	movl   $0xc010bcef,(%esp)
c0100193:	e8 bb 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100198:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ac:	c7 04 24 fd bc 10 c0 	movl   $0xc010bcfd,(%esp)
c01001b3:	e8 9b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bc:	0f b7 d0             	movzwl %ax,%edx
c01001bf:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001cc:	c7 04 24 0b bd 10 c0 	movl   $0xc010bd0b,(%esp)
c01001d3:	e8 7b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001dc:	0f b7 d0             	movzwl %ax,%edx
c01001df:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ec:	c7 04 24 19 bd 10 c0 	movl   $0xc010bd19,(%esp)
c01001f3:	e8 5b 01 00 00       	call   c0100353 <cprintf>
    round ++;
c01001f8:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001fd:	83 c0 01             	add    $0x1,%eax
c0100200:	a3 40 bf 19 c0       	mov    %eax,0xc019bf40
}
c0100205:	c9                   	leave  
c0100206:	c3                   	ret    

c0100207 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100207:	55                   	push   %ebp
c0100208:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020a:	5d                   	pop    %ebp
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010020c:	55                   	push   %ebp
c010020d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c010020f:	5d                   	pop    %ebp
c0100210:	c3                   	ret    

c0100211 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100211:	55                   	push   %ebp
c0100212:	89 e5                	mov    %esp,%ebp
c0100214:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100217:	e8 25 ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010021c:	c7 04 24 28 bd 10 c0 	movl   $0xc010bd28,(%esp)
c0100223:	e8 2b 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_user();
c0100228:	e8 da ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 0f ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 48 bd 10 c0 	movl   $0xc010bd48,(%esp)
c0100239:	e8 15 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_kernel();
c010023e:	e8 c9 ff ff ff       	call   c010020c <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100243:	e8 f9 fe ff ff       	call   c0100141 <lab1_print_cur_status>
}
c0100248:	c9                   	leave  
c0100249:	c3                   	ret    

c010024a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010024a:	55                   	push   %ebp
c010024b:	89 e5                	mov    %esp,%ebp
c010024d:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100254:	74 13                	je     c0100269 <readline+0x1f>
        cprintf("%s", prompt);
c0100256:	8b 45 08             	mov    0x8(%ebp),%eax
c0100259:	89 44 24 04          	mov    %eax,0x4(%esp)
c010025d:	c7 04 24 67 bd 10 c0 	movl   $0xc010bd67,(%esp)
c0100264:	e8 ea 00 00 00       	call   c0100353 <cprintf>
    }
    int i = 0, c;
c0100269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100270:	e8 66 01 00 00       	call   c01003db <getchar>
c0100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010027c:	79 07                	jns    c0100285 <readline+0x3b>
            return NULL;
c010027e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100283:	eb 79                	jmp    c01002fe <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100285:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100289:	7e 28                	jle    c01002b3 <readline+0x69>
c010028b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100292:	7f 1f                	jg     c01002b3 <readline+0x69>
            cputchar(c);
c0100294:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100297:	89 04 24             	mov    %eax,(%esp)
c010029a:	e8 da 00 00 00       	call   c0100379 <cputchar>
            buf[i ++] = c;
c010029f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002a2:	8d 50 01             	lea    0x1(%eax),%edx
c01002a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002ab:	88 90 60 bf 19 c0    	mov    %dl,-0x3fe640a0(%eax)
c01002b1:	eb 46                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002b3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b7:	75 17                	jne    c01002d0 <readline+0x86>
c01002b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002bd:	7e 11                	jle    c01002d0 <readline+0x86>
            cputchar(c);
c01002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c2:	89 04 24             	mov    %eax,(%esp)
c01002c5:	e8 af 00 00 00       	call   c0100379 <cputchar>
            i --;
c01002ca:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002ce:	eb 29                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d4:	74 06                	je     c01002dc <readline+0x92>
c01002d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002da:	75 1d                	jne    c01002f9 <readline+0xaf>
            cputchar(c);
c01002dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002df:	89 04 24             	mov    %eax,(%esp)
c01002e2:	e8 92 00 00 00       	call   c0100379 <cputchar>
            buf[i] = '\0';
c01002e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ea:	05 60 bf 19 c0       	add    $0xc019bf60,%eax
c01002ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f2:	b8 60 bf 19 c0       	mov    $0xc019bf60,%eax
c01002f7:	eb 05                	jmp    c01002fe <readline+0xb4>
        }
    }
c01002f9:	e9 72 ff ff ff       	jmp    c0100270 <readline+0x26>
}
c01002fe:	c9                   	leave  
c01002ff:	c3                   	ret    

c0100300 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100300:	55                   	push   %ebp
c0100301:	89 e5                	mov    %esp,%ebp
c0100303:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100306:	8b 45 08             	mov    0x8(%ebp),%eax
c0100309:	89 04 24             	mov    %eax,(%esp)
c010030c:	e8 f6 13 00 00       	call   c0101707 <cons_putc>
    (*cnt) ++;
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	8b 00                	mov    (%eax),%eax
c0100316:	8d 50 01             	lea    0x1(%eax),%edx
c0100319:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031c:	89 10                	mov    %edx,(%eax)
}
c010031e:	c9                   	leave  
c010031f:	c3                   	ret    

c0100320 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100320:	55                   	push   %ebp
c0100321:	89 e5                	mov    %esp,%ebp
c0100323:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010032d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100330:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100334:	8b 45 08             	mov    0x8(%ebp),%eax
c0100337:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033b:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010033e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100342:	c7 04 24 00 03 10 c0 	movl   $0xc0100300,(%esp)
c0100349:	e8 1f af 00 00       	call   c010b26d <vprintfmt>
    return cnt;
c010034e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100351:	c9                   	leave  
c0100352:	c3                   	ret    

c0100353 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100353:	55                   	push   %ebp
c0100354:	89 e5                	mov    %esp,%ebp
c0100356:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100359:	8d 45 0c             	lea    0xc(%ebp),%eax
c010035c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010035f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100362:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100366:	8b 45 08             	mov    0x8(%ebp),%eax
c0100369:	89 04 24             	mov    %eax,(%esp)
c010036c:	e8 af ff ff ff       	call   c0100320 <vcprintf>
c0100371:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100374:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100377:	c9                   	leave  
c0100378:	c3                   	ret    

c0100379 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100379:	55                   	push   %ebp
c010037a:	89 e5                	mov    %esp,%ebp
c010037c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010037f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100382:	89 04 24             	mov    %eax,(%esp)
c0100385:	e8 7d 13 00 00       	call   c0101707 <cons_putc>
}
c010038a:	c9                   	leave  
c010038b:	c3                   	ret    

c010038c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010038c:	55                   	push   %ebp
c010038d:	89 e5                	mov    %esp,%ebp
c010038f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100399:	eb 13                	jmp    c01003ae <cputs+0x22>
        cputch(c, &cnt);
c010039b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010039f:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003a2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003a6:	89 04 24             	mov    %eax,(%esp)
c01003a9:	e8 52 ff ff ff       	call   c0100300 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b1:	8d 50 01             	lea    0x1(%eax),%edx
c01003b4:	89 55 08             	mov    %edx,0x8(%ebp)
c01003b7:	0f b6 00             	movzbl (%eax),%eax
c01003ba:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003bd:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c1:	75 d8                	jne    c010039b <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003ca:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d1:	e8 2a ff ff ff       	call   c0100300 <cputch>
    return cnt;
c01003d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d9:	c9                   	leave  
c01003da:	c3                   	ret    

c01003db <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003db:	55                   	push   %ebp
c01003dc:	89 e5                	mov    %esp,%ebp
c01003de:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003e1:	e8 5d 13 00 00       	call   c0101743 <cons_getc>
c01003e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003ed:	74 f2                	je     c01003e1 <getchar+0x6>
        /* do nothing */;
    return c;
c01003ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003f2:	c9                   	leave  
c01003f3:	c3                   	ret    

c01003f4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003f4:	55                   	push   %ebp
c01003f5:	89 e5                	mov    %esp,%ebp
c01003f7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100402:	8b 45 10             	mov    0x10(%ebp),%eax
c0100405:	8b 00                	mov    (%eax),%eax
c0100407:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010040a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100411:	e9 d2 00 00 00       	jmp    c01004e8 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c0100416:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100419:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010041c:	01 d0                	add    %edx,%eax
c010041e:	89 c2                	mov    %eax,%edx
c0100420:	c1 ea 1f             	shr    $0x1f,%edx
c0100423:	01 d0                	add    %edx,%eax
c0100425:	d1 f8                	sar    %eax
c0100427:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010042a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010042d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100430:	eb 04                	jmp    c0100436 <stab_binsearch+0x42>
            m --;
c0100432:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100436:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100439:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010043c:	7c 1f                	jl     c010045d <stab_binsearch+0x69>
c010043e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100441:	89 d0                	mov    %edx,%eax
c0100443:	01 c0                	add    %eax,%eax
c0100445:	01 d0                	add    %edx,%eax
c0100447:	c1 e0 02             	shl    $0x2,%eax
c010044a:	89 c2                	mov    %eax,%edx
c010044c:	8b 45 08             	mov    0x8(%ebp),%eax
c010044f:	01 d0                	add    %edx,%eax
c0100451:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100455:	0f b6 c0             	movzbl %al,%eax
c0100458:	3b 45 14             	cmp    0x14(%ebp),%eax
c010045b:	75 d5                	jne    c0100432 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c010045d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100460:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100463:	7d 0b                	jge    c0100470 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100465:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100468:	83 c0 01             	add    $0x1,%eax
c010046b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010046e:	eb 78                	jmp    c01004e8 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100470:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047a:	89 d0                	mov    %edx,%eax
c010047c:	01 c0                	add    %eax,%eax
c010047e:	01 d0                	add    %edx,%eax
c0100480:	c1 e0 02             	shl    $0x2,%eax
c0100483:	89 c2                	mov    %eax,%edx
c0100485:	8b 45 08             	mov    0x8(%ebp),%eax
c0100488:	01 d0                	add    %edx,%eax
c010048a:	8b 40 08             	mov    0x8(%eax),%eax
c010048d:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100490:	73 13                	jae    c01004a5 <stab_binsearch+0xb1>
            *region_left = m;
c0100492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100495:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100498:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010049a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010049d:	83 c0 01             	add    $0x1,%eax
c01004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004a3:	eb 43                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c01004a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a8:	89 d0                	mov    %edx,%eax
c01004aa:	01 c0                	add    %eax,%eax
c01004ac:	01 d0                	add    %edx,%eax
c01004ae:	c1 e0 02             	shl    $0x2,%eax
c01004b1:	89 c2                	mov    %eax,%edx
c01004b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01004b6:	01 d0                	add    %edx,%eax
c01004b8:	8b 40 08             	mov    0x8(%eax),%eax
c01004bb:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004be:	76 16                	jbe    c01004d6 <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ce:	83 e8 01             	sub    $0x1,%eax
c01004d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d4:	eb 12                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004dc:	89 10                	mov    %edx,(%eax)
            l = m;
c01004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004e4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004ee:	0f 8e 22 ff ff ff    	jle    c0100416 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f8:	75 0f                	jne    c0100509 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004fd:	8b 00                	mov    (%eax),%eax
c01004ff:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100502:	8b 45 10             	mov    0x10(%ebp),%eax
c0100505:	89 10                	mov    %edx,(%eax)
c0100507:	eb 3f                	jmp    c0100548 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100509:	8b 45 10             	mov    0x10(%ebp),%eax
c010050c:	8b 00                	mov    (%eax),%eax
c010050e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100511:	eb 04                	jmp    c0100517 <stab_binsearch+0x123>
c0100513:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100517:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051a:	8b 00                	mov    (%eax),%eax
c010051c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010051f:	7d 1f                	jge    c0100540 <stab_binsearch+0x14c>
c0100521:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100524:	89 d0                	mov    %edx,%eax
c0100526:	01 c0                	add    %eax,%eax
c0100528:	01 d0                	add    %edx,%eax
c010052a:	c1 e0 02             	shl    $0x2,%eax
c010052d:	89 c2                	mov    %eax,%edx
c010052f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100532:	01 d0                	add    %edx,%eax
c0100534:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100538:	0f b6 c0             	movzbl %al,%eax
c010053b:	3b 45 14             	cmp    0x14(%ebp),%eax
c010053e:	75 d3                	jne    c0100513 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100540:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100543:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100546:	89 10                	mov    %edx,(%eax)
    }
}
c0100548:	c9                   	leave  
c0100549:	c3                   	ret    

c010054a <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010054a:	55                   	push   %ebp
c010054b:	89 e5                	mov    %esp,%ebp
c010054d:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100550:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100553:	c7 00 6c bd 10 c0    	movl   $0xc010bd6c,(%eax)
    info->eip_line = 0;
c0100559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 08 6c bd 10 c0 	movl   $0xc010bd6c,0x8(%eax)
    info->eip_fn_namelen = 9;
c010056d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100570:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100577:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057a:	8b 55 08             	mov    0x8(%ebp),%edx
c010057d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100580:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100583:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    // find the relevant set of stabs
    if (addr >= KERNBASE) {
c010058a:	81 7d 08 ff ff ff bf 	cmpl   $0xbfffffff,0x8(%ebp)
c0100591:	76 21                	jbe    c01005b4 <debuginfo_eip+0x6a>
        stabs = __STAB_BEGIN__;
c0100593:	c7 45 f4 00 e4 10 c0 	movl   $0xc010e400,-0xc(%ebp)
        stab_end = __STAB_END__;
c010059a:	c7 45 f0 20 26 12 c0 	movl   $0xc0122620,-0x10(%ebp)
        stabstr = __STABSTR_BEGIN__;
c01005a1:	c7 45 ec 21 26 12 c0 	movl   $0xc0122621,-0x14(%ebp)
        stabstr_end = __STABSTR_END__;
c01005a8:	c7 45 e8 f6 72 12 c0 	movl   $0xc01272f6,-0x18(%ebp)
c01005af:	e9 ea 00 00 00       	jmp    c010069e <debuginfo_eip+0x154>
    }
    else {
        // user-program linker script, tools/user.ld puts the information about the
        // program's stabs (included __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__,
        // and __STABSTR_END__) in a structure located at virtual address USTAB.
        const struct userstabdata *usd = (struct userstabdata *)USTAB;
c01005b4:	c7 45 e4 00 00 20 00 	movl   $0x200000,-0x1c(%ebp)

        // make sure that debugger (current process) can access this memory
        struct mm_struct *mm;
        if (current == NULL || (mm = current->mm) == NULL) {
c01005bb:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01005c0:	85 c0                	test   %eax,%eax
c01005c2:	74 11                	je     c01005d5 <debuginfo_eip+0x8b>
c01005c4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01005c9:	8b 40 18             	mov    0x18(%eax),%eax
c01005cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01005cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01005d3:	75 0a                	jne    c01005df <debuginfo_eip+0x95>
            return -1;
c01005d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005da:	e9 9e 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
        if (!user_mem_check(mm, (uintptr_t)usd, sizeof(struct userstabdata), 0)) {
c01005df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005e2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01005e9:	00 
c01005ea:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01005f1:	00 
c01005f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01005f9:	89 04 24             	mov    %eax,(%esp)
c01005fc:	e8 45 88 00 00       	call   c0108e46 <user_mem_check>
c0100601:	85 c0                	test   %eax,%eax
c0100603:	75 0a                	jne    c010060f <debuginfo_eip+0xc5>
            return -1;
c0100605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060a:	e9 6e 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }

        stabs = usd->stabs;
c010060f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100612:	8b 00                	mov    (%eax),%eax
c0100614:	89 45 f4             	mov    %eax,-0xc(%ebp)
        stab_end = usd->stab_end;
c0100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061a:	8b 40 04             	mov    0x4(%eax),%eax
c010061d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stabstr = usd->stabstr;
c0100620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100623:	8b 40 08             	mov    0x8(%eax),%eax
c0100626:	89 45 ec             	mov    %eax,-0x14(%ebp)
        stabstr_end = usd->stabstr_end;
c0100629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010062c:	8b 40 0c             	mov    0xc(%eax),%eax
c010062f:	89 45 e8             	mov    %eax,-0x18(%ebp)

        // make sure the STABS and string table memory is valid
        if (!user_mem_check(mm, (uintptr_t)stabs, (uintptr_t)stab_end - (uintptr_t)stabs, 0)) {
c0100632:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100635:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100638:	29 c2                	sub    %eax,%edx
c010063a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0100644:	00 
c0100645:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100649:	89 44 24 04          	mov    %eax,0x4(%esp)
c010064d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100650:	89 04 24             	mov    %eax,(%esp)
c0100653:	e8 ee 87 00 00       	call   c0108e46 <user_mem_check>
c0100658:	85 c0                	test   %eax,%eax
c010065a:	75 0a                	jne    c0100666 <debuginfo_eip+0x11c>
            return -1;
c010065c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100661:	e9 17 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
        if (!user_mem_check(mm, (uintptr_t)stabstr, stabstr_end - stabstr, 0)) {
c0100666:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0100669:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066c:	29 c2                	sub    %eax,%edx
c010066e:	89 d0                	mov    %edx,%eax
c0100670:	89 c2                	mov    %eax,%edx
c0100672:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100675:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010067c:	00 
c010067d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100681:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100685:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100688:	89 04 24             	mov    %eax,(%esp)
c010068b:	e8 b6 87 00 00       	call   c0108e46 <user_mem_check>
c0100690:	85 c0                	test   %eax,%eax
c0100692:	75 0a                	jne    c010069e <debuginfo_eip+0x154>
            return -1;
c0100694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100699:	e9 df 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010069e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006a4:	76 0d                	jbe    c01006b3 <debuginfo_eip+0x169>
c01006a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006a9:	83 e8 01             	sub    $0x1,%eax
c01006ac:	0f b6 00             	movzbl (%eax),%eax
c01006af:	84 c0                	test   %al,%al
c01006b1:	74 0a                	je     c01006bd <debuginfo_eip+0x173>
        return -1;
c01006b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006b8:	e9 c0 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01006c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ca:	29 c2                	sub    %eax,%edx
c01006cc:	89 d0                	mov    %edx,%eax
c01006ce:	c1 f8 02             	sar    $0x2,%eax
c01006d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006d7:	83 e8 01             	sub    $0x1,%eax
c01006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01006e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006eb:	00 
c01006ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006f3:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006fd:	89 04 24             	mov    %eax,(%esp)
c0100700:	e8 ef fc ff ff       	call   c01003f4 <stab_binsearch>
    if (lfile == 0)
c0100705:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100708:	85 c0                	test   %eax,%eax
c010070a:	75 0a                	jne    c0100716 <debuginfo_eip+0x1cc>
        return -1;
c010070c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100711:	e9 67 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100716:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100719:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010071c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010071f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100722:	8b 45 08             	mov    0x8(%ebp),%eax
c0100725:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100729:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100730:	00 
c0100731:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100734:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100738:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010073b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010073f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100742:	89 04 24             	mov    %eax,(%esp)
c0100745:	e8 aa fc ff ff       	call   c01003f4 <stab_binsearch>

    if (lfun <= rfun) {
c010074a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010074d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100750:	39 c2                	cmp    %eax,%edx
c0100752:	7f 7c                	jg     c01007d0 <debuginfo_eip+0x286>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100757:	89 c2                	mov    %eax,%edx
c0100759:	89 d0                	mov    %edx,%eax
c010075b:	01 c0                	add    %eax,%eax
c010075d:	01 d0                	add    %edx,%eax
c010075f:	c1 e0 02             	shl    $0x2,%eax
c0100762:	89 c2                	mov    %eax,%edx
c0100764:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100767:	01 d0                	add    %edx,%eax
c0100769:	8b 10                	mov    (%eax),%edx
c010076b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010076e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100771:	29 c1                	sub    %eax,%ecx
c0100773:	89 c8                	mov    %ecx,%eax
c0100775:	39 c2                	cmp    %eax,%edx
c0100777:	73 22                	jae    c010079b <debuginfo_eip+0x251>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100779:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077c:	89 c2                	mov    %eax,%edx
c010077e:	89 d0                	mov    %edx,%eax
c0100780:	01 c0                	add    %eax,%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	c1 e0 02             	shl    $0x2,%eax
c0100787:	89 c2                	mov    %eax,%edx
c0100789:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078c:	01 d0                	add    %edx,%eax
c010078e:	8b 10                	mov    (%eax),%edx
c0100790:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100793:	01 c2                	add    %eax,%edx
c0100795:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100798:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	8b 50 08             	mov    0x8(%eax),%edx
c01007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bc:	8b 40 10             	mov    0x10(%eax),%eax
c01007bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfun;
c01007c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007cb:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01007ce:	eb 15                	jmp    c01007e5 <debuginfo_eip+0x29b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01007d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfile;
c01007df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e8:	8b 40 08             	mov    0x8(%eax),%eax
c01007eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007f2:	00 
c01007f3:	89 04 24             	mov    %eax,(%esp)
c01007f6:	e8 a5 b1 00 00       	call   c010b9a0 <strfind>
c01007fb:	89 c2                	mov    %eax,%edx
c01007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100800:	8b 40 08             	mov    0x8(%eax),%eax
c0100803:	29 c2                	sub    %eax,%edx
c0100805:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100808:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010080b:	8b 45 08             	mov    0x8(%ebp),%eax
c010080e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100812:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100819:	00 
c010081a:	8d 45 c8             	lea    -0x38(%ebp),%eax
c010081d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100821:	8d 45 cc             	lea    -0x34(%ebp),%eax
c0100824:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010082b:	89 04 24             	mov    %eax,(%esp)
c010082e:	e8 c1 fb ff ff       	call   c01003f4 <stab_binsearch>
    if (lline <= rline) {
c0100833:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100836:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0100839:	39 c2                	cmp    %eax,%edx
c010083b:	7f 24                	jg     c0100861 <debuginfo_eip+0x317>
        info->eip_line = stabs[rline].n_desc;
c010083d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0100840:	89 c2                	mov    %eax,%edx
c0100842:	89 d0                	mov    %edx,%eax
c0100844:	01 c0                	add    %eax,%eax
c0100846:	01 d0                	add    %edx,%eax
c0100848:	c1 e0 02             	shl    $0x2,%eax
c010084b:	89 c2                	mov    %eax,%edx
c010084d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100850:	01 d0                	add    %edx,%eax
c0100852:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100856:	0f b7 d0             	movzwl %ax,%edx
c0100859:	8b 45 0c             	mov    0xc(%ebp),%eax
c010085c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010085f:	eb 13                	jmp    c0100874 <debuginfo_eip+0x32a>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100866:	e9 12 01 00 00       	jmp    c010097d <debuginfo_eip+0x433>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010086b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010086e:	83 e8 01             	sub    $0x1,%eax
c0100871:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100874:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100877:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010087a:	39 c2                	cmp    %eax,%edx
c010087c:	7c 56                	jl     c01008d4 <debuginfo_eip+0x38a>
           && stabs[lline].n_type != N_SOL
c010087e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100881:	89 c2                	mov    %eax,%edx
c0100883:	89 d0                	mov    %edx,%eax
c0100885:	01 c0                	add    %eax,%eax
c0100887:	01 d0                	add    %edx,%eax
c0100889:	c1 e0 02             	shl    $0x2,%eax
c010088c:	89 c2                	mov    %eax,%edx
c010088e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100891:	01 d0                	add    %edx,%eax
c0100893:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100897:	3c 84                	cmp    $0x84,%al
c0100899:	74 39                	je     c01008d4 <debuginfo_eip+0x38a>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010089b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010089e:	89 c2                	mov    %eax,%edx
c01008a0:	89 d0                	mov    %edx,%eax
c01008a2:	01 c0                	add    %eax,%eax
c01008a4:	01 d0                	add    %edx,%eax
c01008a6:	c1 e0 02             	shl    $0x2,%eax
c01008a9:	89 c2                	mov    %eax,%edx
c01008ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ae:	01 d0                	add    %edx,%eax
c01008b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008b4:	3c 64                	cmp    $0x64,%al
c01008b6:	75 b3                	jne    c010086b <debuginfo_eip+0x321>
c01008b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008bb:	89 c2                	mov    %eax,%edx
c01008bd:	89 d0                	mov    %edx,%eax
c01008bf:	01 c0                	add    %eax,%eax
c01008c1:	01 d0                	add    %edx,%eax
c01008c3:	c1 e0 02             	shl    $0x2,%eax
c01008c6:	89 c2                	mov    %eax,%edx
c01008c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008cb:	01 d0                	add    %edx,%eax
c01008cd:	8b 40 08             	mov    0x8(%eax),%eax
c01008d0:	85 c0                	test   %eax,%eax
c01008d2:	74 97                	je     c010086b <debuginfo_eip+0x321>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008d4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01008d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008da:	39 c2                	cmp    %eax,%edx
c01008dc:	7c 46                	jl     c0100924 <debuginfo_eip+0x3da>
c01008de:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008e1:	89 c2                	mov    %eax,%edx
c01008e3:	89 d0                	mov    %edx,%eax
c01008e5:	01 c0                	add    %eax,%eax
c01008e7:	01 d0                	add    %edx,%eax
c01008e9:	c1 e0 02             	shl    $0x2,%eax
c01008ec:	89 c2                	mov    %eax,%edx
c01008ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008f1:	01 d0                	add    %edx,%eax
c01008f3:	8b 10                	mov    (%eax),%edx
c01008f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008fb:	29 c1                	sub    %eax,%ecx
c01008fd:	89 c8                	mov    %ecx,%eax
c01008ff:	39 c2                	cmp    %eax,%edx
c0100901:	73 21                	jae    c0100924 <debuginfo_eip+0x3da>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100903:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100906:	89 c2                	mov    %eax,%edx
c0100908:	89 d0                	mov    %edx,%eax
c010090a:	01 c0                	add    %eax,%eax
c010090c:	01 d0                	add    %edx,%eax
c010090e:	c1 e0 02             	shl    $0x2,%eax
c0100911:	89 c2                	mov    %eax,%edx
c0100913:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100916:	01 d0                	add    %edx,%eax
c0100918:	8b 10                	mov    (%eax),%edx
c010091a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010091d:	01 c2                	add    %eax,%edx
c010091f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100922:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100924:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100927:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010092a:	39 c2                	cmp    %eax,%edx
c010092c:	7d 4a                	jge    c0100978 <debuginfo_eip+0x42e>
        for (lline = lfun + 1;
c010092e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100931:	83 c0 01             	add    $0x1,%eax
c0100934:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0100937:	eb 18                	jmp    c0100951 <debuginfo_eip+0x407>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100939:	8b 45 0c             	mov    0xc(%ebp),%eax
c010093c:	8b 40 14             	mov    0x14(%eax),%eax
c010093f:	8d 50 01             	lea    0x1(%eax),%edx
c0100942:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100945:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100948:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010094b:	83 c0 01             	add    $0x1,%eax
c010094e:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100951:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100954:	8b 45 d0             	mov    -0x30(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100957:	39 c2                	cmp    %eax,%edx
c0100959:	7d 1d                	jge    c0100978 <debuginfo_eip+0x42e>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010095b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010095e:	89 c2                	mov    %eax,%edx
c0100960:	89 d0                	mov    %edx,%eax
c0100962:	01 c0                	add    %eax,%eax
c0100964:	01 d0                	add    %edx,%eax
c0100966:	c1 e0 02             	shl    $0x2,%eax
c0100969:	89 c2                	mov    %eax,%edx
c010096b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010096e:	01 d0                	add    %edx,%eax
c0100970:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100974:	3c a0                	cmp    $0xa0,%al
c0100976:	74 c1                	je     c0100939 <debuginfo_eip+0x3ef>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100978:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010097d:	c9                   	leave  
c010097e:	c3                   	ret    

c010097f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010097f:	55                   	push   %ebp
c0100980:	89 e5                	mov    %esp,%ebp
c0100982:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100985:	c7 04 24 76 bd 10 c0 	movl   $0xc010bd76,(%esp)
c010098c:	e8 c2 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100991:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100998:	c0 
c0100999:	c7 04 24 8f bd 10 c0 	movl   $0xc010bd8f,(%esp)
c01009a0:	e8 ae f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009a5:	c7 44 24 04 b5 bc 10 	movl   $0xc010bcb5,0x4(%esp)
c01009ac:	c0 
c01009ad:	c7 04 24 a7 bd 10 c0 	movl   $0xc010bda7,(%esp)
c01009b4:	e8 9a f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009b9:	c7 44 24 04 2a bf 19 	movl   $0xc019bf2a,0x4(%esp)
c01009c0:	c0 
c01009c1:	c7 04 24 bf bd 10 c0 	movl   $0xc010bdbf,(%esp)
c01009c8:	e8 86 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009cd:	c7 44 24 04 b8 f0 19 	movl   $0xc019f0b8,0x4(%esp)
c01009d4:	c0 
c01009d5:	c7 04 24 d7 bd 10 c0 	movl   $0xc010bdd7,(%esp)
c01009dc:	e8 72 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009e1:	b8 b8 f0 19 c0       	mov    $0xc019f0b8,%eax
c01009e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01009f1:	29 c2                	sub    %eax,%edx
c01009f3:	89 d0                	mov    %edx,%eax
c01009f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009fb:	85 c0                	test   %eax,%eax
c01009fd:	0f 48 c2             	cmovs  %edx,%eax
c0100a00:	c1 f8 0a             	sar    $0xa,%eax
c0100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a07:	c7 04 24 f0 bd 10 c0 	movl   $0xc010bdf0,(%esp)
c0100a0e:	e8 40 f9 ff ff       	call   c0100353 <cprintf>
}
c0100a13:	c9                   	leave  
c0100a14:	c3                   	ret    

c0100a15 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a15:	55                   	push   %ebp
c0100a16:	89 e5                	mov    %esp,%ebp
c0100a18:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a1e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a28:	89 04 24             	mov    %eax,(%esp)
c0100a2b:	e8 1a fb ff ff       	call   c010054a <debuginfo_eip>
c0100a30:	85 c0                	test   %eax,%eax
c0100a32:	74 15                	je     c0100a49 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3b:	c7 04 24 1a be 10 c0 	movl   $0xc010be1a,(%esp)
c0100a42:	e8 0c f9 ff ff       	call   c0100353 <cprintf>
c0100a47:	eb 6d                	jmp    c0100ab6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a50:	eb 1c                	jmp    c0100a6e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a58:	01 d0                	add    %edx,%eax
c0100a5a:	0f b6 00             	movzbl (%eax),%eax
c0100a5d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a66:	01 ca                	add    %ecx,%edx
c0100a68:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a6a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a71:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a74:	7f dc                	jg     c0100a52 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a76:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a7f:	01 d0                	add    %edx,%eax
c0100a81:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a87:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a8a:	89 d1                	mov    %edx,%ecx
c0100a8c:	29 c1                	sub    %eax,%ecx
c0100a8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a94:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a98:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a9e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100aa2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aaa:	c7 04 24 36 be 10 c0 	movl   $0xc010be36,(%esp)
c0100ab1:	e8 9d f8 ff ff       	call   c0100353 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c0100ab6:	c9                   	leave  
c0100ab7:	c3                   	ret    

c0100ab8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100ab8:	55                   	push   %ebp
c0100ab9:	89 e5                	mov    %esp,%ebp
c0100abb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100abe:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ac1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100ac4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100ac7:	c9                   	leave  
c0100ac8:	c3                   	ret    

c0100ac9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100ac9:	55                   	push   %ebp
c0100aca:	89 e5                	mov    %esp,%ebp
c0100acc:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100acf:	89 e8                	mov    %ebp,%eax
c0100ad1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100ad4:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c0100ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c0100ada:	e8 d9 ff ff ff       	call   c0100ab8 <read_eip>
c0100adf:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// 循环打印，直到 STACKFRAME_DEPTH 栈的深度已经最大，并且还要满足ebp ！= 0
	int i;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
c0100ae2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100ae9:	e9 88 00 00 00       	jmp    c0100b76 <print_stackframe+0xad>
		cprintf("ebp: 0x%08x eip: 0x%08x args: ", ebp, eip);
c0100aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100af1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100afc:	c7 04 24 48 be 10 c0 	movl   $0xc010be48,(%esp)
c0100b03:	e8 4b f8 ff ff       	call   c0100353 <cprintf>

		// ebp + 2才是第一个参数的地址，具体可以看笔记
		uint32_t *args = (uint32_t *)ebp + 2;
c0100b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0b:	83 c0 08             	add    $0x8,%eax
c0100b0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		// 循环打印4个args
		int j;
		for (j = 0; j < 4; j++) {
c0100b11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100b18:	eb 25                	jmp    c0100b3f <print_stackframe+0x76>
			cprintf("0x%08x ", args[j]);
c0100b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b27:	01 d0                	add    %edx,%eax
c0100b29:	8b 00                	mov    (%eax),%eax
c0100b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2f:	c7 04 24 67 be 10 c0 	movl   $0xc010be67,(%esp)
c0100b36:	e8 18 f8 ff ff       	call   c0100353 <cprintf>
		// ebp + 2才是第一个参数的地址，具体可以看笔记
		uint32_t *args = (uint32_t *)ebp + 2;

		// 循环打印4个args
		int j;
		for (j = 0; j < 4; j++) {
c0100b3b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100b3f:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b43:	7e d5                	jle    c0100b1a <print_stackframe+0x51>
			cprintf("0x%08x ", args[j]);
		}
		cprintf("\n");
c0100b45:	c7 04 24 6f be 10 c0 	movl   $0xc010be6f,(%esp)
c0100b4c:	e8 02 f8 ff ff       	call   c0100353 <cprintf>

		// 打印 kern/debug/kdebug.c:305: print_stackframe+22 类似这行的东西，应该是调试信息
		print_debuginfo(eip-1);
c0100b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b54:	83 e8 01             	sub    $0x1,%eax
c0100b57:	89 04 24             	mov    %eax,(%esp)
c0100b5a:	e8 b6 fe ff ff       	call   c0100a15 <print_debuginfo>

		// 先把eip指向ebp+1的位置，即函数的返回地址（Return Address）
		eip = *((uint32_t *)ebp + 1);
c0100b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b62:	83 c0 04             	add    $0x4,%eax
c0100b65:	8b 00                	mov    (%eax),%eax
c0100b67:	89 45 f0             	mov    %eax,-0x10(%ebp)

		// ebp的内容给ebp回到上层调用函数
		ebp = *((uint32_t *)ebp);
c0100b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b6d:	8b 00                	mov    (%eax),%eax
c0100b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();

	// 循环打印，直到 STACKFRAME_DEPTH 栈的深度已经最大，并且还要满足ebp ！= 0
	int i;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
c0100b72:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b76:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b7a:	7f 0a                	jg     c0100b86 <print_stackframe+0xbd>
c0100b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b80:	0f 85 68 ff ff ff    	jne    c0100aee <print_stackframe+0x25>
		eip = *((uint32_t *)ebp + 1);

		// ebp的内容给ebp回到上层调用函数
		ebp = *((uint32_t *)ebp);
	}
}
c0100b86:	c9                   	leave  
c0100b87:	c3                   	ret    

c0100b88 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b88:	55                   	push   %ebp
c0100b89:	89 e5                	mov    %esp,%ebp
c0100b8b:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b95:	eb 0c                	jmp    c0100ba3 <parse+0x1b>
            *buf ++ = '\0';
c0100b97:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b9a:	8d 50 01             	lea    0x1(%eax),%edx
c0100b9d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100ba0:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba6:	0f b6 00             	movzbl (%eax),%eax
c0100ba9:	84 c0                	test   %al,%al
c0100bab:	74 1d                	je     c0100bca <parse+0x42>
c0100bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb0:	0f b6 00             	movzbl (%eax),%eax
c0100bb3:	0f be c0             	movsbl %al,%eax
c0100bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bba:	c7 04 24 f4 be 10 c0 	movl   $0xc010bef4,(%esp)
c0100bc1:	e8 a7 ad 00 00       	call   c010b96d <strchr>
c0100bc6:	85 c0                	test   %eax,%eax
c0100bc8:	75 cd                	jne    c0100b97 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100bca:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bcd:	0f b6 00             	movzbl (%eax),%eax
c0100bd0:	84 c0                	test   %al,%al
c0100bd2:	75 02                	jne    c0100bd6 <parse+0x4e>
            break;
c0100bd4:	eb 67                	jmp    c0100c3d <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bd6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bda:	75 14                	jne    c0100bf0 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bdc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100be3:	00 
c0100be4:	c7 04 24 f9 be 10 c0 	movl   $0xc010bef9,(%esp)
c0100beb:	e8 63 f7 ff ff       	call   c0100353 <cprintf>
        }
        argv[argc ++] = buf;
c0100bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bf3:	8d 50 01             	lea    0x1(%eax),%edx
c0100bf6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bf9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c03:	01 c2                	add    %eax,%edx
c0100c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c08:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c0a:	eb 04                	jmp    c0100c10 <parse+0x88>
            buf ++;
c0100c0c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c13:	0f b6 00             	movzbl (%eax),%eax
c0100c16:	84 c0                	test   %al,%al
c0100c18:	74 1d                	je     c0100c37 <parse+0xaf>
c0100c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1d:	0f b6 00             	movzbl (%eax),%eax
c0100c20:	0f be c0             	movsbl %al,%eax
c0100c23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c27:	c7 04 24 f4 be 10 c0 	movl   $0xc010bef4,(%esp)
c0100c2e:	e8 3a ad 00 00       	call   c010b96d <strchr>
c0100c33:	85 c0                	test   %eax,%eax
c0100c35:	74 d5                	je     c0100c0c <parse+0x84>
            buf ++;
        }
    }
c0100c37:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c38:	e9 66 ff ff ff       	jmp    c0100ba3 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c40:	c9                   	leave  
c0100c41:	c3                   	ret    

c0100c42 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c42:	55                   	push   %ebp
c0100c43:	89 e5                	mov    %esp,%ebp
c0100c45:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c48:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c52:	89 04 24             	mov    %eax,(%esp)
c0100c55:	e8 2e ff ff ff       	call   c0100b88 <parse>
c0100c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c61:	75 0a                	jne    c0100c6d <runcmd+0x2b>
        return 0;
c0100c63:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c68:	e9 85 00 00 00       	jmp    c0100cf2 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c74:	eb 5c                	jmp    c0100cd2 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c76:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7c:	89 d0                	mov    %edx,%eax
c0100c7e:	01 c0                	add    %eax,%eax
c0100c80:	01 d0                	add    %edx,%eax
c0100c82:	c1 e0 02             	shl    $0x2,%eax
c0100c85:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100c8a:	8b 00                	mov    (%eax),%eax
c0100c8c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c90:	89 04 24             	mov    %eax,(%esp)
c0100c93:	e8 36 ac 00 00       	call   c010b8ce <strcmp>
c0100c98:	85 c0                	test   %eax,%eax
c0100c9a:	75 32                	jne    c0100cce <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c9f:	89 d0                	mov    %edx,%eax
c0100ca1:	01 c0                	add    %eax,%eax
c0100ca3:	01 d0                	add    %edx,%eax
c0100ca5:	c1 e0 02             	shl    $0x2,%eax
c0100ca8:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100cad:	8b 40 08             	mov    0x8(%eax),%eax
c0100cb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100cb3:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100cb9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100cbd:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100cc0:	83 c2 04             	add    $0x4,%edx
c0100cc3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100cc7:	89 0c 24             	mov    %ecx,(%esp)
c0100cca:	ff d0                	call   *%eax
c0100ccc:	eb 24                	jmp    c0100cf2 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cd5:	83 f8 02             	cmp    $0x2,%eax
c0100cd8:	76 9c                	jbe    c0100c76 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cda:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ce1:	c7 04 24 17 bf 10 c0 	movl   $0xc010bf17,(%esp)
c0100ce8:	e8 66 f6 ff ff       	call   c0100353 <cprintf>
    return 0;
c0100ced:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cf2:	c9                   	leave  
c0100cf3:	c3                   	ret    

c0100cf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cf4:	55                   	push   %ebp
c0100cf5:	89 e5                	mov    %esp,%ebp
c0100cf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cfa:	c7 04 24 30 bf 10 c0 	movl   $0xc010bf30,(%esp)
c0100d01:	e8 4d f6 ff ff       	call   c0100353 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d06:	c7 04 24 58 bf 10 c0 	movl   $0xc010bf58,(%esp)
c0100d0d:	e8 41 f6 ff ff       	call   c0100353 <cprintf>

    if (tf != NULL) {
c0100d12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d16:	74 0b                	je     c0100d23 <kmonitor+0x2f>
        print_trapframe(tf);
c0100d18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d1b:	89 04 24             	mov    %eax,(%esp)
c0100d1e:	e8 a2 16 00 00       	call   c01023c5 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d23:	c7 04 24 7d bf 10 c0 	movl   $0xc010bf7d,(%esp)
c0100d2a:	e8 1b f5 ff ff       	call   c010024a <readline>
c0100d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d36:	74 18                	je     c0100d50 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100d38:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d42:	89 04 24             	mov    %eax,(%esp)
c0100d45:	e8 f8 fe ff ff       	call   c0100c42 <runcmd>
c0100d4a:	85 c0                	test   %eax,%eax
c0100d4c:	79 02                	jns    c0100d50 <kmonitor+0x5c>
                break;
c0100d4e:	eb 02                	jmp    c0100d52 <kmonitor+0x5e>
            }
        }
    }
c0100d50:	eb d1                	jmp    c0100d23 <kmonitor+0x2f>
}
c0100d52:	c9                   	leave  
c0100d53:	c3                   	ret    

c0100d54 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d54:	55                   	push   %ebp
c0100d55:	89 e5                	mov    %esp,%ebp
c0100d57:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d61:	eb 3f                	jmp    c0100da2 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d66:	89 d0                	mov    %edx,%eax
c0100d68:	01 c0                	add    %eax,%eax
c0100d6a:	01 d0                	add    %edx,%eax
c0100d6c:	c1 e0 02             	shl    $0x2,%eax
c0100d6f:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100d74:	8b 48 04             	mov    0x4(%eax),%ecx
c0100d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d7a:	89 d0                	mov    %edx,%eax
c0100d7c:	01 c0                	add    %eax,%eax
c0100d7e:	01 d0                	add    %edx,%eax
c0100d80:	c1 e0 02             	shl    $0x2,%eax
c0100d83:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100d88:	8b 00                	mov    (%eax),%eax
c0100d8a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d92:	c7 04 24 81 bf 10 c0 	movl   $0xc010bf81,(%esp)
c0100d99:	e8 b5 f5 ff ff       	call   c0100353 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d9e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100da5:	83 f8 02             	cmp    $0x2,%eax
c0100da8:	76 b9                	jbe    c0100d63 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100daa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100daf:	c9                   	leave  
c0100db0:	c3                   	ret    

c0100db1 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100db1:	55                   	push   %ebp
c0100db2:	89 e5                	mov    %esp,%ebp
c0100db4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100db7:	e8 c3 fb ff ff       	call   c010097f <print_kerninfo>
    return 0;
c0100dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dc1:	c9                   	leave  
c0100dc2:	c3                   	ret    

c0100dc3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100dc3:	55                   	push   %ebp
c0100dc4:	89 e5                	mov    %esp,%ebp
c0100dc6:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100dc9:	e8 fb fc ff ff       	call   c0100ac9 <print_stackframe>
    return 0;
c0100dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dd3:	c9                   	leave  
c0100dd4:	c3                   	ret    

c0100dd5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100dd5:	55                   	push   %ebp
c0100dd6:	89 e5                	mov    %esp,%ebp
c0100dd8:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ddb:	a1 60 c3 19 c0       	mov    0xc019c360,%eax
c0100de0:	85 c0                	test   %eax,%eax
c0100de2:	74 02                	je     c0100de6 <__panic+0x11>
        goto panic_dead;
c0100de4:	eb 48                	jmp    c0100e2e <__panic+0x59>
    }
    is_panic = 1;
c0100de6:	c7 05 60 c3 19 c0 01 	movl   $0x1,0xc019c360
c0100ded:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100df0:	8d 45 14             	lea    0x14(%ebp),%eax
c0100df3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100df6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100df9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100dfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e04:	c7 04 24 8a bf 10 c0 	movl   $0xc010bf8a,(%esp)
c0100e0b:	e8 43 f5 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e17:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e1a:	89 04 24             	mov    %eax,(%esp)
c0100e1d:	e8 fe f4 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100e22:	c7 04 24 a6 bf 10 c0 	movl   $0xc010bfa6,(%esp)
c0100e29:	e8 25 f5 ff ff       	call   c0100353 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100e2e:	e8 fa 11 00 00       	call   c010202d <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100e33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e3a:	e8 b5 fe ff ff       	call   c0100cf4 <kmonitor>
    }
c0100e3f:	eb f2                	jmp    c0100e33 <__panic+0x5e>

c0100e41 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100e41:	55                   	push   %ebp
c0100e42:	89 e5                	mov    %esp,%ebp
c0100e44:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100e47:	8d 45 14             	lea    0x14(%ebp),%eax
c0100e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100e50:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e5b:	c7 04 24 a8 bf 10 c0 	movl   $0xc010bfa8,(%esp)
c0100e62:	e8 ec f4 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e6e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e71:	89 04 24             	mov    %eax,(%esp)
c0100e74:	e8 a7 f4 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100e79:	c7 04 24 a6 bf 10 c0 	movl   $0xc010bfa6,(%esp)
c0100e80:	e8 ce f4 ff ff       	call   c0100353 <cprintf>
    va_end(ap);
}
c0100e85:	c9                   	leave  
c0100e86:	c3                   	ret    

c0100e87 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100e87:	55                   	push   %ebp
c0100e88:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100e8a:	a1 60 c3 19 c0       	mov    0xc019c360,%eax
}
c0100e8f:	5d                   	pop    %ebp
c0100e90:	c3                   	ret    

c0100e91 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100e91:	55                   	push   %ebp
c0100e92:	89 e5                	mov    %esp,%ebp
c0100e94:	83 ec 28             	sub    $0x28,%esp
c0100e97:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100e9d:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ea1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100ea5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ea9:	ee                   	out    %al,(%dx)
c0100eaa:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100eb0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100eb4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100eb8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ebc:	ee                   	out    %al,(%dx)
c0100ebd:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100ec3:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100ec7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ecb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ecf:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100ed0:	c7 05 b4 ef 19 c0 00 	movl   $0x0,0xc019efb4
c0100ed7:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100eda:	c7 04 24 c6 bf 10 c0 	movl   $0xc010bfc6,(%esp)
c0100ee1:	e8 6d f4 ff ff       	call   c0100353 <cprintf>
    pic_enable(IRQ_TIMER);
c0100ee6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100eed:	e8 99 11 00 00       	call   c010208b <pic_enable>
}
c0100ef2:	c9                   	leave  
c0100ef3:	c3                   	ret    

c0100ef4 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0100ef4:	55                   	push   %ebp
c0100ef5:	89 e5                	mov    %esp,%ebp
c0100ef7:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100efa:	9c                   	pushf  
c0100efb:	58                   	pop    %eax
c0100efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100f02:	25 00 02 00 00       	and    $0x200,%eax
c0100f07:	85 c0                	test   %eax,%eax
c0100f09:	74 0c                	je     c0100f17 <__intr_save+0x23>
        intr_disable();
c0100f0b:	e8 1d 11 00 00       	call   c010202d <intr_disable>
        return 1;
c0100f10:	b8 01 00 00 00       	mov    $0x1,%eax
c0100f15:	eb 05                	jmp    c0100f1c <__intr_save+0x28>
    }
    return 0;
c0100f17:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100f1c:	c9                   	leave  
c0100f1d:	c3                   	ret    

c0100f1e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100f1e:	55                   	push   %ebp
c0100f1f:	89 e5                	mov    %esp,%ebp
c0100f21:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100f24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100f28:	74 05                	je     c0100f2f <__intr_restore+0x11>
        intr_enable();
c0100f2a:	e8 f8 10 00 00       	call   c0102027 <intr_enable>
    }
}
c0100f2f:	c9                   	leave  
c0100f30:	c3                   	ret    

c0100f31 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100f31:	55                   	push   %ebp
c0100f32:	89 e5                	mov    %esp,%ebp
c0100f34:	83 ec 10             	sub    $0x10,%esp
c0100f37:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100f41:	89 c2                	mov    %eax,%edx
c0100f43:	ec                   	in     (%dx),%al
c0100f44:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100f47:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100f4d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100f51:	89 c2                	mov    %eax,%edx
c0100f53:	ec                   	in     (%dx),%al
c0100f54:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100f57:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100f5d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f61:	89 c2                	mov    %eax,%edx
c0100f63:	ec                   	in     (%dx),%al
c0100f64:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100f67:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100f6d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f71:	89 c2                	mov    %eax,%edx
c0100f73:	ec                   	in     (%dx),%al
c0100f74:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100f77:	c9                   	leave  
c0100f78:	c3                   	ret    

c0100f79 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100f79:	55                   	push   %ebp
c0100f7a:	89 e5                	mov    %esp,%ebp
c0100f7c:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100f7f:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f89:	0f b7 00             	movzwl (%eax),%eax
c0100f8c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f93:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f9b:	0f b7 00             	movzwl (%eax),%eax
c0100f9e:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100fa2:	74 12                	je     c0100fb6 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100fa4:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100fab:	66 c7 05 86 c3 19 c0 	movw   $0x3b4,0xc019c386
c0100fb2:	b4 03 
c0100fb4:	eb 13                	jmp    c0100fc9 <cga_init+0x50>
    } else {
        *cp = was;
c0100fb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fb9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100fbd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100fc0:	66 c7 05 86 c3 19 c0 	movw   $0x3d4,0xc019c386
c0100fc7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100fc9:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0100fd0:	0f b7 c0             	movzwl %ax,%eax
c0100fd3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100fd7:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fdb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fdf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fe3:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100fe4:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0100feb:	83 c0 01             	add    $0x1,%eax
c0100fee:	0f b7 c0             	movzwl %ax,%eax
c0100ff1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff5:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ff9:	89 c2                	mov    %eax,%edx
c0100ffb:	ec                   	in     (%dx),%al
c0100ffc:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100fff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101003:	0f b6 c0             	movzbl %al,%eax
c0101006:	c1 e0 08             	shl    $0x8,%eax
c0101009:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c010100c:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0101013:	0f b7 c0             	movzwl %ax,%eax
c0101016:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010101a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010101e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101022:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101026:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0101027:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c010102e:	83 c0 01             	add    $0x1,%eax
c0101031:	0f b7 c0             	movzwl %ax,%eax
c0101034:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101038:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c010103c:	89 c2                	mov    %eax,%edx
c010103e:	ec                   	in     (%dx),%al
c010103f:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0101042:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101046:	0f b6 c0             	movzbl %al,%eax
c0101049:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c010104c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010104f:	a3 80 c3 19 c0       	mov    %eax,0xc019c380
    crt_pos = pos;
c0101054:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101057:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
}
c010105d:	c9                   	leave  
c010105e:	c3                   	ret    

c010105f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c010105f:	55                   	push   %ebp
c0101060:	89 e5                	mov    %esp,%ebp
c0101062:	83 ec 48             	sub    $0x48,%esp
c0101065:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c010106b:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010106f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101073:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101077:	ee                   	out    %al,(%dx)
c0101078:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c010107e:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0101082:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101086:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010108a:	ee                   	out    %al,(%dx)
c010108b:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0101091:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0101095:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101099:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010109d:	ee                   	out    %al,(%dx)
c010109e:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c01010a4:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c01010a8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01010ac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01010b0:	ee                   	out    %al,(%dx)
c01010b1:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c01010b7:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c01010bb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01010bf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01010c3:	ee                   	out    %al,(%dx)
c01010c4:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c01010ca:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c01010ce:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01010d2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01010d6:	ee                   	out    %al,(%dx)
c01010d7:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c01010dd:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c01010e1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01010e5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01010e9:	ee                   	out    %al,(%dx)
c01010ea:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01010f0:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01010f4:	89 c2                	mov    %eax,%edx
c01010f6:	ec                   	in     (%dx),%al
c01010f7:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c01010fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c01010fe:	3c ff                	cmp    $0xff,%al
c0101100:	0f 95 c0             	setne  %al
c0101103:	0f b6 c0             	movzbl %al,%eax
c0101106:	a3 88 c3 19 c0       	mov    %eax,0xc019c388
c010110b:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101111:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101115:	89 c2                	mov    %eax,%edx
c0101117:	ec                   	in     (%dx),%al
c0101118:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010111b:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101121:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101125:	89 c2                	mov    %eax,%edx
c0101127:	ec                   	in     (%dx),%al
c0101128:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010112b:	a1 88 c3 19 c0       	mov    0xc019c388,%eax
c0101130:	85 c0                	test   %eax,%eax
c0101132:	74 0c                	je     c0101140 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101134:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010113b:	e8 4b 0f 00 00       	call   c010208b <pic_enable>
    }
}
c0101140:	c9                   	leave  
c0101141:	c3                   	ret    

c0101142 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101142:	55                   	push   %ebp
c0101143:	89 e5                	mov    %esp,%ebp
c0101145:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101148:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010114f:	eb 09                	jmp    c010115a <lpt_putc_sub+0x18>
        delay();
c0101151:	e8 db fd ff ff       	call   c0100f31 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101156:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010115a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101160:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101164:	89 c2                	mov    %eax,%edx
c0101166:	ec                   	in     (%dx),%al
c0101167:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010116a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010116e:	84 c0                	test   %al,%al
c0101170:	78 09                	js     c010117b <lpt_putc_sub+0x39>
c0101172:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101179:	7e d6                	jle    c0101151 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010117b:	8b 45 08             	mov    0x8(%ebp),%eax
c010117e:	0f b6 c0             	movzbl %al,%eax
c0101181:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101187:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010118a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010118e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101192:	ee                   	out    %al,(%dx)
c0101193:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101199:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010119d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01011a1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01011a5:	ee                   	out    %al,(%dx)
c01011a6:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01011ac:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01011b0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01011b4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011b8:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01011b9:	c9                   	leave  
c01011ba:	c3                   	ret    

c01011bb <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01011bb:	55                   	push   %ebp
c01011bc:	89 e5                	mov    %esp,%ebp
c01011be:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01011c1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01011c5:	74 0d                	je     c01011d4 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01011c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ca:	89 04 24             	mov    %eax,(%esp)
c01011cd:	e8 70 ff ff ff       	call   c0101142 <lpt_putc_sub>
c01011d2:	eb 24                	jmp    c01011f8 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01011d4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011db:	e8 62 ff ff ff       	call   c0101142 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01011e0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01011e7:	e8 56 ff ff ff       	call   c0101142 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01011ec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011f3:	e8 4a ff ff ff       	call   c0101142 <lpt_putc_sub>
    }
}
c01011f8:	c9                   	leave  
c01011f9:	c3                   	ret    

c01011fa <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01011fa:	55                   	push   %ebp
c01011fb:	89 e5                	mov    %esp,%ebp
c01011fd:	53                   	push   %ebx
c01011fe:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101201:	8b 45 08             	mov    0x8(%ebp),%eax
c0101204:	b0 00                	mov    $0x0,%al
c0101206:	85 c0                	test   %eax,%eax
c0101208:	75 07                	jne    c0101211 <cga_putc+0x17>
        c |= 0x0700;
c010120a:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101211:	8b 45 08             	mov    0x8(%ebp),%eax
c0101214:	0f b6 c0             	movzbl %al,%eax
c0101217:	83 f8 0a             	cmp    $0xa,%eax
c010121a:	74 4c                	je     c0101268 <cga_putc+0x6e>
c010121c:	83 f8 0d             	cmp    $0xd,%eax
c010121f:	74 57                	je     c0101278 <cga_putc+0x7e>
c0101221:	83 f8 08             	cmp    $0x8,%eax
c0101224:	0f 85 88 00 00 00    	jne    c01012b2 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010122a:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c0101231:	66 85 c0             	test   %ax,%ax
c0101234:	74 30                	je     c0101266 <cga_putc+0x6c>
            crt_pos --;
c0101236:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c010123d:	83 e8 01             	sub    $0x1,%eax
c0101240:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101246:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c010124b:	0f b7 15 84 c3 19 c0 	movzwl 0xc019c384,%edx
c0101252:	0f b7 d2             	movzwl %dx,%edx
c0101255:	01 d2                	add    %edx,%edx
c0101257:	01 c2                	add    %eax,%edx
c0101259:	8b 45 08             	mov    0x8(%ebp),%eax
c010125c:	b0 00                	mov    $0x0,%al
c010125e:	83 c8 20             	or     $0x20,%eax
c0101261:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101264:	eb 72                	jmp    c01012d8 <cga_putc+0xde>
c0101266:	eb 70                	jmp    c01012d8 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101268:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c010126f:	83 c0 50             	add    $0x50,%eax
c0101272:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101278:	0f b7 1d 84 c3 19 c0 	movzwl 0xc019c384,%ebx
c010127f:	0f b7 0d 84 c3 19 c0 	movzwl 0xc019c384,%ecx
c0101286:	0f b7 c1             	movzwl %cx,%eax
c0101289:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010128f:	c1 e8 10             	shr    $0x10,%eax
c0101292:	89 c2                	mov    %eax,%edx
c0101294:	66 c1 ea 06          	shr    $0x6,%dx
c0101298:	89 d0                	mov    %edx,%eax
c010129a:	c1 e0 02             	shl    $0x2,%eax
c010129d:	01 d0                	add    %edx,%eax
c010129f:	c1 e0 04             	shl    $0x4,%eax
c01012a2:	29 c1                	sub    %eax,%ecx
c01012a4:	89 ca                	mov    %ecx,%edx
c01012a6:	89 d8                	mov    %ebx,%eax
c01012a8:	29 d0                	sub    %edx,%eax
c01012aa:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
        break;
c01012b0:	eb 26                	jmp    c01012d8 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01012b2:	8b 0d 80 c3 19 c0    	mov    0xc019c380,%ecx
c01012b8:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c01012bf:	8d 50 01             	lea    0x1(%eax),%edx
c01012c2:	66 89 15 84 c3 19 c0 	mov    %dx,0xc019c384
c01012c9:	0f b7 c0             	movzwl %ax,%eax
c01012cc:	01 c0                	add    %eax,%eax
c01012ce:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01012d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01012d4:	66 89 02             	mov    %ax,(%edx)
        break;
c01012d7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01012d8:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c01012df:	66 3d cf 07          	cmp    $0x7cf,%ax
c01012e3:	76 5b                	jbe    c0101340 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01012e5:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c01012ea:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01012f0:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c01012f5:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012fc:	00 
c01012fd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101301:	89 04 24             	mov    %eax,(%esp)
c0101304:	e8 62 a8 00 00       	call   c010bb6b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101309:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101310:	eb 15                	jmp    c0101327 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101312:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c0101317:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010131a:	01 d2                	add    %edx,%edx
c010131c:	01 d0                	add    %edx,%eax
c010131e:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101323:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101327:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010132e:	7e e2                	jle    c0101312 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101330:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c0101337:	83 e8 50             	sub    $0x50,%eax
c010133a:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101340:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0101347:	0f b7 c0             	movzwl %ax,%eax
c010134a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010134e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101352:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101356:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010135a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010135b:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c0101362:	66 c1 e8 08          	shr    $0x8,%ax
c0101366:	0f b6 c0             	movzbl %al,%eax
c0101369:	0f b7 15 86 c3 19 c0 	movzwl 0xc019c386,%edx
c0101370:	83 c2 01             	add    $0x1,%edx
c0101373:	0f b7 d2             	movzwl %dx,%edx
c0101376:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010137a:	88 45 ed             	mov    %al,-0x13(%ebp)
c010137d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101381:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101385:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101386:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c010138d:	0f b7 c0             	movzwl %ax,%eax
c0101390:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101394:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101398:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010139c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01013a0:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01013a1:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c01013a8:	0f b6 c0             	movzbl %al,%eax
c01013ab:	0f b7 15 86 c3 19 c0 	movzwl 0xc019c386,%edx
c01013b2:	83 c2 01             	add    $0x1,%edx
c01013b5:	0f b7 d2             	movzwl %dx,%edx
c01013b8:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01013bc:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01013bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01013c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01013c7:	ee                   	out    %al,(%dx)
}
c01013c8:	83 c4 34             	add    $0x34,%esp
c01013cb:	5b                   	pop    %ebx
c01013cc:	5d                   	pop    %ebp
c01013cd:	c3                   	ret    

c01013ce <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01013ce:	55                   	push   %ebp
c01013cf:	89 e5                	mov    %esp,%ebp
c01013d1:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01013db:	eb 09                	jmp    c01013e6 <serial_putc_sub+0x18>
        delay();
c01013dd:	e8 4f fb ff ff       	call   c0100f31 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01013e6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ec:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013f0:	89 c2                	mov    %eax,%edx
c01013f2:	ec                   	in     (%dx),%al
c01013f3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013f6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013fa:	0f b6 c0             	movzbl %al,%eax
c01013fd:	83 e0 20             	and    $0x20,%eax
c0101400:	85 c0                	test   %eax,%eax
c0101402:	75 09                	jne    c010140d <serial_putc_sub+0x3f>
c0101404:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010140b:	7e d0                	jle    c01013dd <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010140d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101410:	0f b6 c0             	movzbl %al,%eax
c0101413:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101419:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010141c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101420:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101424:	ee                   	out    %al,(%dx)
}
c0101425:	c9                   	leave  
c0101426:	c3                   	ret    

c0101427 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101427:	55                   	push   %ebp
c0101428:	89 e5                	mov    %esp,%ebp
c010142a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010142d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101431:	74 0d                	je     c0101440 <serial_putc+0x19>
        serial_putc_sub(c);
c0101433:	8b 45 08             	mov    0x8(%ebp),%eax
c0101436:	89 04 24             	mov    %eax,(%esp)
c0101439:	e8 90 ff ff ff       	call   c01013ce <serial_putc_sub>
c010143e:	eb 24                	jmp    c0101464 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101440:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101447:	e8 82 ff ff ff       	call   c01013ce <serial_putc_sub>
        serial_putc_sub(' ');
c010144c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101453:	e8 76 ff ff ff       	call   c01013ce <serial_putc_sub>
        serial_putc_sub('\b');
c0101458:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010145f:	e8 6a ff ff ff       	call   c01013ce <serial_putc_sub>
    }
}
c0101464:	c9                   	leave  
c0101465:	c3                   	ret    

c0101466 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101466:	55                   	push   %ebp
c0101467:	89 e5                	mov    %esp,%ebp
c0101469:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010146c:	eb 33                	jmp    c01014a1 <cons_intr+0x3b>
        if (c != 0) {
c010146e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101472:	74 2d                	je     c01014a1 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101474:	a1 a4 c5 19 c0       	mov    0xc019c5a4,%eax
c0101479:	8d 50 01             	lea    0x1(%eax),%edx
c010147c:	89 15 a4 c5 19 c0    	mov    %edx,0xc019c5a4
c0101482:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101485:	88 90 a0 c3 19 c0    	mov    %dl,-0x3fe63c60(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010148b:	a1 a4 c5 19 c0       	mov    0xc019c5a4,%eax
c0101490:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101495:	75 0a                	jne    c01014a1 <cons_intr+0x3b>
                cons.wpos = 0;
c0101497:	c7 05 a4 c5 19 c0 00 	movl   $0x0,0xc019c5a4
c010149e:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01014a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01014a4:	ff d0                	call   *%eax
c01014a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01014a9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01014ad:	75 bf                	jne    c010146e <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01014af:	c9                   	leave  
c01014b0:	c3                   	ret    

c01014b1 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01014b1:	55                   	push   %ebp
c01014b2:	89 e5                	mov    %esp,%ebp
c01014b4:	83 ec 10             	sub    $0x10,%esp
c01014b7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014bd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01014c1:	89 c2                	mov    %eax,%edx
c01014c3:	ec                   	in     (%dx),%al
c01014c4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01014c7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01014cb:	0f b6 c0             	movzbl %al,%eax
c01014ce:	83 e0 01             	and    $0x1,%eax
c01014d1:	85 c0                	test   %eax,%eax
c01014d3:	75 07                	jne    c01014dc <serial_proc_data+0x2b>
        return -1;
c01014d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014da:	eb 2a                	jmp    c0101506 <serial_proc_data+0x55>
c01014dc:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014e2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014e6:	89 c2                	mov    %eax,%edx
c01014e8:	ec                   	in     (%dx),%al
c01014e9:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014ec:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014f0:	0f b6 c0             	movzbl %al,%eax
c01014f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014f6:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014fa:	75 07                	jne    c0101503 <serial_proc_data+0x52>
        c = '\b';
c01014fc:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101503:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101506:	c9                   	leave  
c0101507:	c3                   	ret    

c0101508 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101508:	55                   	push   %ebp
c0101509:	89 e5                	mov    %esp,%ebp
c010150b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010150e:	a1 88 c3 19 c0       	mov    0xc019c388,%eax
c0101513:	85 c0                	test   %eax,%eax
c0101515:	74 0c                	je     c0101523 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101517:	c7 04 24 b1 14 10 c0 	movl   $0xc01014b1,(%esp)
c010151e:	e8 43 ff ff ff       	call   c0101466 <cons_intr>
    }
}
c0101523:	c9                   	leave  
c0101524:	c3                   	ret    

c0101525 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101525:	55                   	push   %ebp
c0101526:	89 e5                	mov    %esp,%ebp
c0101528:	83 ec 38             	sub    $0x38,%esp
c010152b:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101531:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101535:	89 c2                	mov    %eax,%edx
c0101537:	ec                   	in     (%dx),%al
c0101538:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010153b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010153f:	0f b6 c0             	movzbl %al,%eax
c0101542:	83 e0 01             	and    $0x1,%eax
c0101545:	85 c0                	test   %eax,%eax
c0101547:	75 0a                	jne    c0101553 <kbd_proc_data+0x2e>
        return -1;
c0101549:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010154e:	e9 59 01 00 00       	jmp    c01016ac <kbd_proc_data+0x187>
c0101553:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101559:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010155d:	89 c2                	mov    %eax,%edx
c010155f:	ec                   	in     (%dx),%al
c0101560:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101563:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101567:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010156a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010156e:	75 17                	jne    c0101587 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101570:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101575:	83 c8 40             	or     $0x40,%eax
c0101578:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
        return 0;
c010157d:	b8 00 00 00 00       	mov    $0x0,%eax
c0101582:	e9 25 01 00 00       	jmp    c01016ac <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101587:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010158b:	84 c0                	test   %al,%al
c010158d:	79 47                	jns    c01015d6 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010158f:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101594:	83 e0 40             	and    $0x40,%eax
c0101597:	85 c0                	test   %eax,%eax
c0101599:	75 09                	jne    c01015a4 <kbd_proc_data+0x7f>
c010159b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010159f:	83 e0 7f             	and    $0x7f,%eax
c01015a2:	eb 04                	jmp    c01015a8 <kbd_proc_data+0x83>
c01015a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a8:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01015ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015af:	0f b6 80 60 a0 12 c0 	movzbl -0x3fed5fa0(%eax),%eax
c01015b6:	83 c8 40             	or     $0x40,%eax
c01015b9:	0f b6 c0             	movzbl %al,%eax
c01015bc:	f7 d0                	not    %eax
c01015be:	89 c2                	mov    %eax,%edx
c01015c0:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c01015c5:	21 d0                	and    %edx,%eax
c01015c7:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
        return 0;
c01015cc:	b8 00 00 00 00       	mov    $0x0,%eax
c01015d1:	e9 d6 00 00 00       	jmp    c01016ac <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01015d6:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c01015db:	83 e0 40             	and    $0x40,%eax
c01015de:	85 c0                	test   %eax,%eax
c01015e0:	74 11                	je     c01015f3 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015e2:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015e6:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c01015eb:	83 e0 bf             	and    $0xffffffbf,%eax
c01015ee:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
    }

    shift |= shiftcode[data];
c01015f3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015f7:	0f b6 80 60 a0 12 c0 	movzbl -0x3fed5fa0(%eax),%eax
c01015fe:	0f b6 d0             	movzbl %al,%edx
c0101601:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101606:	09 d0                	or     %edx,%eax
c0101608:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
    shift ^= togglecode[data];
c010160d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101611:	0f b6 80 60 a1 12 c0 	movzbl -0x3fed5ea0(%eax),%eax
c0101618:	0f b6 d0             	movzbl %al,%edx
c010161b:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101620:	31 d0                	xor    %edx,%eax
c0101622:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101627:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c010162c:	83 e0 03             	and    $0x3,%eax
c010162f:	8b 14 85 60 a5 12 c0 	mov    -0x3fed5aa0(,%eax,4),%edx
c0101636:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010163a:	01 d0                	add    %edx,%eax
c010163c:	0f b6 00             	movzbl (%eax),%eax
c010163f:	0f b6 c0             	movzbl %al,%eax
c0101642:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101645:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c010164a:	83 e0 08             	and    $0x8,%eax
c010164d:	85 c0                	test   %eax,%eax
c010164f:	74 22                	je     c0101673 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101651:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101655:	7e 0c                	jle    c0101663 <kbd_proc_data+0x13e>
c0101657:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010165b:	7f 06                	jg     c0101663 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010165d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101661:	eb 10                	jmp    c0101673 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101663:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101667:	7e 0a                	jle    c0101673 <kbd_proc_data+0x14e>
c0101669:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010166d:	7f 04                	jg     c0101673 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010166f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101673:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101678:	f7 d0                	not    %eax
c010167a:	83 e0 06             	and    $0x6,%eax
c010167d:	85 c0                	test   %eax,%eax
c010167f:	75 28                	jne    c01016a9 <kbd_proc_data+0x184>
c0101681:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101688:	75 1f                	jne    c01016a9 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010168a:	c7 04 24 e1 bf 10 c0 	movl   $0xc010bfe1,(%esp)
c0101691:	e8 bd ec ff ff       	call   c0100353 <cprintf>
c0101696:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010169c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016a0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01016a4:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01016a8:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016ac:	c9                   	leave  
c01016ad:	c3                   	ret    

c01016ae <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01016ae:	55                   	push   %ebp
c01016af:	89 e5                	mov    %esp,%ebp
c01016b1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01016b4:	c7 04 24 25 15 10 c0 	movl   $0xc0101525,(%esp)
c01016bb:	e8 a6 fd ff ff       	call   c0101466 <cons_intr>
}
c01016c0:	c9                   	leave  
c01016c1:	c3                   	ret    

c01016c2 <kbd_init>:

static void
kbd_init(void) {
c01016c2:	55                   	push   %ebp
c01016c3:	89 e5                	mov    %esp,%ebp
c01016c5:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01016c8:	e8 e1 ff ff ff       	call   c01016ae <kbd_intr>
    pic_enable(IRQ_KBD);
c01016cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016d4:	e8 b2 09 00 00       	call   c010208b <pic_enable>
}
c01016d9:	c9                   	leave  
c01016da:	c3                   	ret    

c01016db <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016db:	55                   	push   %ebp
c01016dc:	89 e5                	mov    %esp,%ebp
c01016de:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016e1:	e8 93 f8 ff ff       	call   c0100f79 <cga_init>
    serial_init();
c01016e6:	e8 74 f9 ff ff       	call   c010105f <serial_init>
    kbd_init();
c01016eb:	e8 d2 ff ff ff       	call   c01016c2 <kbd_init>
    if (!serial_exists) {
c01016f0:	a1 88 c3 19 c0       	mov    0xc019c388,%eax
c01016f5:	85 c0                	test   %eax,%eax
c01016f7:	75 0c                	jne    c0101705 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01016f9:	c7 04 24 ed bf 10 c0 	movl   $0xc010bfed,(%esp)
c0101700:	e8 4e ec ff ff       	call   c0100353 <cprintf>
    }
}
c0101705:	c9                   	leave  
c0101706:	c3                   	ret    

c0101707 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101707:	55                   	push   %ebp
c0101708:	89 e5                	mov    %esp,%ebp
c010170a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010170d:	e8 e2 f7 ff ff       	call   c0100ef4 <__intr_save>
c0101712:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101715:	8b 45 08             	mov    0x8(%ebp),%eax
c0101718:	89 04 24             	mov    %eax,(%esp)
c010171b:	e8 9b fa ff ff       	call   c01011bb <lpt_putc>
        cga_putc(c);
c0101720:	8b 45 08             	mov    0x8(%ebp),%eax
c0101723:	89 04 24             	mov    %eax,(%esp)
c0101726:	e8 cf fa ff ff       	call   c01011fa <cga_putc>
        serial_putc(c);
c010172b:	8b 45 08             	mov    0x8(%ebp),%eax
c010172e:	89 04 24             	mov    %eax,(%esp)
c0101731:	e8 f1 fc ff ff       	call   c0101427 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101736:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101739:	89 04 24             	mov    %eax,(%esp)
c010173c:	e8 dd f7 ff ff       	call   c0100f1e <__intr_restore>
}
c0101741:	c9                   	leave  
c0101742:	c3                   	ret    

c0101743 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101743:	55                   	push   %ebp
c0101744:	89 e5                	mov    %esp,%ebp
c0101746:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101750:	e8 9f f7 ff ff       	call   c0100ef4 <__intr_save>
c0101755:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101758:	e8 ab fd ff ff       	call   c0101508 <serial_intr>
        kbd_intr();
c010175d:	e8 4c ff ff ff       	call   c01016ae <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101762:	8b 15 a0 c5 19 c0    	mov    0xc019c5a0,%edx
c0101768:	a1 a4 c5 19 c0       	mov    0xc019c5a4,%eax
c010176d:	39 c2                	cmp    %eax,%edx
c010176f:	74 31                	je     c01017a2 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101771:	a1 a0 c5 19 c0       	mov    0xc019c5a0,%eax
c0101776:	8d 50 01             	lea    0x1(%eax),%edx
c0101779:	89 15 a0 c5 19 c0    	mov    %edx,0xc019c5a0
c010177f:	0f b6 80 a0 c3 19 c0 	movzbl -0x3fe63c60(%eax),%eax
c0101786:	0f b6 c0             	movzbl %al,%eax
c0101789:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010178c:	a1 a0 c5 19 c0       	mov    0xc019c5a0,%eax
c0101791:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101796:	75 0a                	jne    c01017a2 <cons_getc+0x5f>
                cons.rpos = 0;
c0101798:	c7 05 a0 c5 19 c0 00 	movl   $0x0,0xc019c5a0
c010179f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01017a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01017a5:	89 04 24             	mov    %eax,(%esp)
c01017a8:	e8 71 f7 ff ff       	call   c0100f1e <__intr_restore>
    return c;
c01017ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01017b0:	c9                   	leave  
c01017b1:	c3                   	ret    

c01017b2 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01017b2:	55                   	push   %ebp
c01017b3:	89 e5                	mov    %esp,%ebp
c01017b5:	83 ec 14             	sub    $0x14,%esp
c01017b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01017bb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01017bf:	90                   	nop
c01017c0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017c4:	83 c0 07             	add    $0x7,%eax
c01017c7:	0f b7 c0             	movzwl %ax,%eax
c01017ca:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017ce:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01017d2:	89 c2                	mov    %eax,%edx
c01017d4:	ec                   	in     (%dx),%al
c01017d5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01017d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017dc:	0f b6 c0             	movzbl %al,%eax
c01017df:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017e5:	25 80 00 00 00       	and    $0x80,%eax
c01017ea:	85 c0                	test   %eax,%eax
c01017ec:	75 d2                	jne    c01017c0 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01017ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01017f2:	74 11                	je     c0101805 <ide_wait_ready+0x53>
c01017f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017f7:	83 e0 21             	and    $0x21,%eax
c01017fa:	85 c0                	test   %eax,%eax
c01017fc:	74 07                	je     c0101805 <ide_wait_ready+0x53>
        return -1;
c01017fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101803:	eb 05                	jmp    c010180a <ide_wait_ready+0x58>
    }
    return 0;
c0101805:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010180a:	c9                   	leave  
c010180b:	c3                   	ret    

c010180c <ide_init>:

void
ide_init(void) {
c010180c:	55                   	push   %ebp
c010180d:	89 e5                	mov    %esp,%ebp
c010180f:	57                   	push   %edi
c0101810:	53                   	push   %ebx
c0101811:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101817:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c010181d:	e9 d6 02 00 00       	jmp    c0101af8 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101822:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101826:	c1 e0 03             	shl    $0x3,%eax
c0101829:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101830:	29 c2                	sub    %eax,%edx
c0101832:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101838:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c010183b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010183f:	66 d1 e8             	shr    %ax
c0101842:	0f b7 c0             	movzwl %ax,%eax
c0101845:	0f b7 04 85 0c c0 10 	movzwl -0x3fef3ff4(,%eax,4),%eax
c010184c:	c0 
c010184d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101851:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101855:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010185c:	00 
c010185d:	89 04 24             	mov    %eax,(%esp)
c0101860:	e8 4d ff ff ff       	call   c01017b2 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101865:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101869:	83 e0 01             	and    $0x1,%eax
c010186c:	c1 e0 04             	shl    $0x4,%eax
c010186f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101872:	0f b6 c0             	movzbl %al,%eax
c0101875:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101879:	83 c2 06             	add    $0x6,%edx
c010187c:	0f b7 d2             	movzwl %dx,%edx
c010187f:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101883:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101886:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010188a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010188e:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c010188f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101893:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010189a:	00 
c010189b:	89 04 24             	mov    %eax,(%esp)
c010189e:	e8 0f ff ff ff       	call   c01017b2 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01018a3:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018a7:	83 c0 07             	add    $0x7,%eax
c01018aa:	0f b7 c0             	movzwl %ax,%eax
c01018ad:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01018b1:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01018b5:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01018b9:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01018bd:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01018be:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01018c9:	00 
c01018ca:	89 04 24             	mov    %eax,(%esp)
c01018cd:	e8 e0 fe ff ff       	call   c01017b2 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01018d2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018d6:	83 c0 07             	add    $0x7,%eax
c01018d9:	0f b7 c0             	movzwl %ax,%eax
c01018dc:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01018e0:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01018e4:	89 c2                	mov    %eax,%edx
c01018e6:	ec                   	in     (%dx),%al
c01018e7:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01018ea:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01018ee:	84 c0                	test   %al,%al
c01018f0:	0f 84 f7 01 00 00    	je     c0101aed <ide_init+0x2e1>
c01018f6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101901:	00 
c0101902:	89 04 24             	mov    %eax,(%esp)
c0101905:	e8 a8 fe ff ff       	call   c01017b2 <ide_wait_ready>
c010190a:	85 c0                	test   %eax,%eax
c010190c:	0f 85 db 01 00 00    	jne    c0101aed <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101912:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101916:	c1 e0 03             	shl    $0x3,%eax
c0101919:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101920:	29 c2                	sub    %eax,%edx
c0101922:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101928:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c010192b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010192f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101932:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101938:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010193b:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101942:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101945:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101948:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010194b:	89 cb                	mov    %ecx,%ebx
c010194d:	89 df                	mov    %ebx,%edi
c010194f:	89 c1                	mov    %eax,%ecx
c0101951:	fc                   	cld    
c0101952:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101954:	89 c8                	mov    %ecx,%eax
c0101956:	89 fb                	mov    %edi,%ebx
c0101958:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c010195b:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c010195e:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101964:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010196a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101970:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101973:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101976:	25 00 00 00 04       	and    $0x4000000,%eax
c010197b:	85 c0                	test   %eax,%eax
c010197d:	74 0e                	je     c010198d <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c010197f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101982:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101988:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010198b:	eb 09                	jmp    c0101996 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c010198d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101990:	8b 40 78             	mov    0x78(%eax),%eax
c0101993:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101996:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010199a:	c1 e0 03             	shl    $0x3,%eax
c010199d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019a4:	29 c2                	sub    %eax,%edx
c01019a6:	81 c2 c0 c5 19 c0    	add    $0xc019c5c0,%edx
c01019ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01019af:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01019b2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019b6:	c1 e0 03             	shl    $0x3,%eax
c01019b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c0:	29 c2                	sub    %eax,%edx
c01019c2:	81 c2 c0 c5 19 c0    	add    $0xc019c5c0,%edx
c01019c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01019cb:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01019ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01019d1:	83 c0 62             	add    $0x62,%eax
c01019d4:	0f b7 00             	movzwl (%eax),%eax
c01019d7:	0f b7 c0             	movzwl %ax,%eax
c01019da:	25 00 02 00 00       	and    $0x200,%eax
c01019df:	85 c0                	test   %eax,%eax
c01019e1:	75 24                	jne    c0101a07 <ide_init+0x1fb>
c01019e3:	c7 44 24 0c 14 c0 10 	movl   $0xc010c014,0xc(%esp)
c01019ea:	c0 
c01019eb:	c7 44 24 08 57 c0 10 	movl   $0xc010c057,0x8(%esp)
c01019f2:	c0 
c01019f3:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01019fa:	00 
c01019fb:	c7 04 24 6c c0 10 c0 	movl   $0xc010c06c,(%esp)
c0101a02:	e8 ce f3 ff ff       	call   c0100dd5 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101a07:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a0b:	c1 e0 03             	shl    $0x3,%eax
c0101a0e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a15:	29 c2                	sub    %eax,%edx
c0101a17:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101a1d:	83 c0 0c             	add    $0xc,%eax
c0101a20:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101a26:	83 c0 36             	add    $0x36,%eax
c0101a29:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101a2c:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101a33:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101a3a:	eb 34                	jmp    c0101a70 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a3f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a42:	01 c2                	add    %eax,%edx
c0101a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a47:	8d 48 01             	lea    0x1(%eax),%ecx
c0101a4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101a4d:	01 c8                	add    %ecx,%eax
c0101a4f:	0f b6 00             	movzbl (%eax),%eax
c0101a52:	88 02                	mov    %al,(%edx)
c0101a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a57:	8d 50 01             	lea    0x1(%eax),%edx
c0101a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a5d:	01 c2                	add    %eax,%edx
c0101a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a62:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101a65:	01 c8                	add    %ecx,%eax
c0101a67:	0f b6 00             	movzbl (%eax),%eax
c0101a6a:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101a6c:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a73:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101a76:	72 c4                	jb     c0101a3c <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a7e:	01 d0                	add    %edx,%eax
c0101a80:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a86:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101a89:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101a8c:	85 c0                	test   %eax,%eax
c0101a8e:	74 0f                	je     c0101a9f <ide_init+0x293>
c0101a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a93:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a96:	01 d0                	add    %edx,%eax
c0101a98:	0f b6 00             	movzbl (%eax),%eax
c0101a9b:	3c 20                	cmp    $0x20,%al
c0101a9d:	74 d9                	je     c0101a78 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101a9f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101aa3:	c1 e0 03             	shl    $0x3,%eax
c0101aa6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101aad:	29 c2                	sub    %eax,%edx
c0101aaf:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101ab5:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101ab8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101abc:	c1 e0 03             	shl    $0x3,%eax
c0101abf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ac6:	29 c2                	sub    %eax,%edx
c0101ac8:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101ace:	8b 50 08             	mov    0x8(%eax),%edx
c0101ad1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101ad5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101ad9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101add:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae1:	c7 04 24 7e c0 10 c0 	movl   $0xc010c07e,(%esp)
c0101ae8:	e8 66 e8 ff ff       	call   c0100353 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101aed:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101af1:	83 c0 01             	add    $0x1,%eax
c0101af4:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101af8:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101afd:	0f 86 1f fd ff ff    	jbe    c0101822 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101b03:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101b0a:	e8 7c 05 00 00       	call   c010208b <pic_enable>
    pic_enable(IRQ_IDE2);
c0101b0f:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101b16:	e8 70 05 00 00       	call   c010208b <pic_enable>
}
c0101b1b:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101b21:	5b                   	pop    %ebx
c0101b22:	5f                   	pop    %edi
c0101b23:	5d                   	pop    %ebp
c0101b24:	c3                   	ret    

c0101b25 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101b25:	55                   	push   %ebp
c0101b26:	89 e5                	mov    %esp,%ebp
c0101b28:	83 ec 04             	sub    $0x4,%esp
c0101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101b32:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101b37:	77 24                	ja     c0101b5d <ide_device_valid+0x38>
c0101b39:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b3d:	c1 e0 03             	shl    $0x3,%eax
c0101b40:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b47:	29 c2                	sub    %eax,%edx
c0101b49:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101b4f:	0f b6 00             	movzbl (%eax),%eax
c0101b52:	84 c0                	test   %al,%al
c0101b54:	74 07                	je     c0101b5d <ide_device_valid+0x38>
c0101b56:	b8 01 00 00 00       	mov    $0x1,%eax
c0101b5b:	eb 05                	jmp    c0101b62 <ide_device_valid+0x3d>
c0101b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b62:	c9                   	leave  
c0101b63:	c3                   	ret    

c0101b64 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101b64:	55                   	push   %ebp
c0101b65:	89 e5                	mov    %esp,%ebp
c0101b67:	83 ec 08             	sub    $0x8,%esp
c0101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101b71:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b75:	89 04 24             	mov    %eax,(%esp)
c0101b78:	e8 a8 ff ff ff       	call   c0101b25 <ide_device_valid>
c0101b7d:	85 c0                	test   %eax,%eax
c0101b7f:	74 1b                	je     c0101b9c <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101b81:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b85:	c1 e0 03             	shl    $0x3,%eax
c0101b88:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b8f:	29 c2                	sub    %eax,%edx
c0101b91:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101b97:	8b 40 08             	mov    0x8(%eax),%eax
c0101b9a:	eb 05                	jmp    c0101ba1 <ide_device_size+0x3d>
    }
    return 0;
c0101b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101ba1:	c9                   	leave  
c0101ba2:	c3                   	ret    

c0101ba3 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101ba3:	55                   	push   %ebp
c0101ba4:	89 e5                	mov    %esp,%ebp
c0101ba6:	57                   	push   %edi
c0101ba7:	53                   	push   %ebx
c0101ba8:	83 ec 50             	sub    $0x50,%esp
c0101bab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bae:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101bb2:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101bb9:	77 24                	ja     c0101bdf <ide_read_secs+0x3c>
c0101bbb:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101bc0:	77 1d                	ja     c0101bdf <ide_read_secs+0x3c>
c0101bc2:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101bc6:	c1 e0 03             	shl    $0x3,%eax
c0101bc9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101bd0:	29 c2                	sub    %eax,%edx
c0101bd2:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101bd8:	0f b6 00             	movzbl (%eax),%eax
c0101bdb:	84 c0                	test   %al,%al
c0101bdd:	75 24                	jne    c0101c03 <ide_read_secs+0x60>
c0101bdf:	c7 44 24 0c 9c c0 10 	movl   $0xc010c09c,0xc(%esp)
c0101be6:	c0 
c0101be7:	c7 44 24 08 57 c0 10 	movl   $0xc010c057,0x8(%esp)
c0101bee:	c0 
c0101bef:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101bf6:	00 
c0101bf7:	c7 04 24 6c c0 10 c0 	movl   $0xc010c06c,(%esp)
c0101bfe:	e8 d2 f1 ff ff       	call   c0100dd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101c03:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101c0a:	77 0f                	ja     c0101c1b <ide_read_secs+0x78>
c0101c0c:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101c12:	01 d0                	add    %edx,%eax
c0101c14:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101c19:	76 24                	jbe    c0101c3f <ide_read_secs+0x9c>
c0101c1b:	c7 44 24 0c c4 c0 10 	movl   $0xc010c0c4,0xc(%esp)
c0101c22:	c0 
c0101c23:	c7 44 24 08 57 c0 10 	movl   $0xc010c057,0x8(%esp)
c0101c2a:	c0 
c0101c2b:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101c32:	00 
c0101c33:	c7 04 24 6c c0 10 c0 	movl   $0xc010c06c,(%esp)
c0101c3a:	e8 96 f1 ff ff       	call   c0100dd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101c3f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c43:	66 d1 e8             	shr    %ax
c0101c46:	0f b7 c0             	movzwl %ax,%eax
c0101c49:	0f b7 04 85 0c c0 10 	movzwl -0x3fef3ff4(,%eax,4),%eax
c0101c50:	c0 
c0101c51:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101c55:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c59:	66 d1 e8             	shr    %ax
c0101c5c:	0f b7 c0             	movzwl %ax,%eax
c0101c5f:	0f b7 04 85 0e c0 10 	movzwl -0x3fef3ff2(,%eax,4),%eax
c0101c66:	c0 
c0101c67:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101c6b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101c76:	00 
c0101c77:	89 04 24             	mov    %eax,(%esp)
c0101c7a:	e8 33 fb ff ff       	call   c01017b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101c7f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101c83:	83 c0 02             	add    $0x2,%eax
c0101c86:	0f b7 c0             	movzwl %ax,%eax
c0101c89:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101c8d:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101c95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101c99:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101c9a:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c9d:	0f b6 c0             	movzbl %al,%eax
c0101ca0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ca4:	83 c2 02             	add    $0x2,%edx
c0101ca7:	0f b7 d2             	movzwl %dx,%edx
c0101caa:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101cae:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101cb1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101cb5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101cb9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101cba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cbd:	0f b6 c0             	movzbl %al,%eax
c0101cc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101cc4:	83 c2 03             	add    $0x3,%edx
c0101cc7:	0f b7 d2             	movzwl %dx,%edx
c0101cca:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101cce:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101cd1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101cd5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101cd9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101cda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cdd:	c1 e8 08             	shr    $0x8,%eax
c0101ce0:	0f b6 c0             	movzbl %al,%eax
c0101ce3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ce7:	83 c2 04             	add    $0x4,%edx
c0101cea:	0f b7 d2             	movzwl %dx,%edx
c0101ced:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101cf1:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101cf4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101cf8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101cfc:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d00:	c1 e8 10             	shr    $0x10,%eax
c0101d03:	0f b6 c0             	movzbl %al,%eax
c0101d06:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d0a:	83 c2 05             	add    $0x5,%edx
c0101d0d:	0f b7 d2             	movzwl %dx,%edx
c0101d10:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101d14:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101d17:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101d1b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101d1f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101d20:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d24:	83 e0 01             	and    $0x1,%eax
c0101d27:	c1 e0 04             	shl    $0x4,%eax
c0101d2a:	89 c2                	mov    %eax,%edx
c0101d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d2f:	c1 e8 18             	shr    $0x18,%eax
c0101d32:	83 e0 0f             	and    $0xf,%eax
c0101d35:	09 d0                	or     %edx,%eax
c0101d37:	83 c8 e0             	or     $0xffffffe0,%eax
c0101d3a:	0f b6 c0             	movzbl %al,%eax
c0101d3d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d41:	83 c2 06             	add    $0x6,%edx
c0101d44:	0f b7 d2             	movzwl %dx,%edx
c0101d47:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101d4b:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101d4e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101d52:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101d56:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101d57:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d5b:	83 c0 07             	add    $0x7,%eax
c0101d5e:	0f b7 c0             	movzwl %ax,%eax
c0101d61:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101d65:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101d69:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101d6d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101d71:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101d72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101d79:	eb 5a                	jmp    c0101dd5 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101d7b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d7f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101d86:	00 
c0101d87:	89 04 24             	mov    %eax,(%esp)
c0101d8a:	e8 23 fa ff ff       	call   c01017b2 <ide_wait_ready>
c0101d8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101d92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101d96:	74 02                	je     c0101d9a <ide_read_secs+0x1f7>
            goto out;
c0101d98:	eb 41                	jmp    c0101ddb <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101d9a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d9e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101da1:	8b 45 10             	mov    0x10(%ebp),%eax
c0101da4:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101da7:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101dae:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101db1:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101db4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101db7:	89 cb                	mov    %ecx,%ebx
c0101db9:	89 df                	mov    %ebx,%edi
c0101dbb:	89 c1                	mov    %eax,%ecx
c0101dbd:	fc                   	cld    
c0101dbe:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101dc0:	89 c8                	mov    %ecx,%eax
c0101dc2:	89 fb                	mov    %edi,%ebx
c0101dc4:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101dc7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101dca:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101dce:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101dd5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101dd9:	75 a0                	jne    c0101d7b <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101dde:	83 c4 50             	add    $0x50,%esp
c0101de1:	5b                   	pop    %ebx
c0101de2:	5f                   	pop    %edi
c0101de3:	5d                   	pop    %ebp
c0101de4:	c3                   	ret    

c0101de5 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101de5:	55                   	push   %ebp
c0101de6:	89 e5                	mov    %esp,%ebp
c0101de8:	56                   	push   %esi
c0101de9:	53                   	push   %ebx
c0101dea:	83 ec 50             	sub    $0x50,%esp
c0101ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df0:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101df4:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101dfb:	77 24                	ja     c0101e21 <ide_write_secs+0x3c>
c0101dfd:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101e02:	77 1d                	ja     c0101e21 <ide_write_secs+0x3c>
c0101e04:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e08:	c1 e0 03             	shl    $0x3,%eax
c0101e0b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101e12:	29 c2                	sub    %eax,%edx
c0101e14:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101e1a:	0f b6 00             	movzbl (%eax),%eax
c0101e1d:	84 c0                	test   %al,%al
c0101e1f:	75 24                	jne    c0101e45 <ide_write_secs+0x60>
c0101e21:	c7 44 24 0c 9c c0 10 	movl   $0xc010c09c,0xc(%esp)
c0101e28:	c0 
c0101e29:	c7 44 24 08 57 c0 10 	movl   $0xc010c057,0x8(%esp)
c0101e30:	c0 
c0101e31:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101e38:	00 
c0101e39:	c7 04 24 6c c0 10 c0 	movl   $0xc010c06c,(%esp)
c0101e40:	e8 90 ef ff ff       	call   c0100dd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101e45:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101e4c:	77 0f                	ja     c0101e5d <ide_write_secs+0x78>
c0101e4e:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101e54:	01 d0                	add    %edx,%eax
c0101e56:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101e5b:	76 24                	jbe    c0101e81 <ide_write_secs+0x9c>
c0101e5d:	c7 44 24 0c c4 c0 10 	movl   $0xc010c0c4,0xc(%esp)
c0101e64:	c0 
c0101e65:	c7 44 24 08 57 c0 10 	movl   $0xc010c057,0x8(%esp)
c0101e6c:	c0 
c0101e6d:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101e74:	00 
c0101e75:	c7 04 24 6c c0 10 c0 	movl   $0xc010c06c,(%esp)
c0101e7c:	e8 54 ef ff ff       	call   c0100dd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101e81:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e85:	66 d1 e8             	shr    %ax
c0101e88:	0f b7 c0             	movzwl %ax,%eax
c0101e8b:	0f b7 04 85 0c c0 10 	movzwl -0x3fef3ff4(,%eax,4),%eax
c0101e92:	c0 
c0101e93:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101e97:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e9b:	66 d1 e8             	shr    %ax
c0101e9e:	0f b7 c0             	movzwl %ax,%eax
c0101ea1:	0f b7 04 85 0e c0 10 	movzwl -0x3fef3ff2(,%eax,4),%eax
c0101ea8:	c0 
c0101ea9:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101ead:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101eb1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101eb8:	00 
c0101eb9:	89 04 24             	mov    %eax,(%esp)
c0101ebc:	e8 f1 f8 ff ff       	call   c01017b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101ec1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101ec5:	83 c0 02             	add    $0x2,%eax
c0101ec8:	0f b7 c0             	movzwl %ax,%eax
c0101ecb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101ecf:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ed3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101ed7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101edb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101edc:	8b 45 14             	mov    0x14(%ebp),%eax
c0101edf:	0f b6 c0             	movzbl %al,%eax
c0101ee2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ee6:	83 c2 02             	add    $0x2,%edx
c0101ee9:	0f b7 d2             	movzwl %dx,%edx
c0101eec:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101ef0:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101ef3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101ef7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101efb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101efc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101eff:	0f b6 c0             	movzbl %al,%eax
c0101f02:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f06:	83 c2 03             	add    $0x3,%edx
c0101f09:	0f b7 d2             	movzwl %dx,%edx
c0101f0c:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101f10:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101f13:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101f17:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101f1b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f1f:	c1 e8 08             	shr    $0x8,%eax
c0101f22:	0f b6 c0             	movzbl %al,%eax
c0101f25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f29:	83 c2 04             	add    $0x4,%edx
c0101f2c:	0f b7 d2             	movzwl %dx,%edx
c0101f2f:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101f33:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101f36:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101f3a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101f3e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f42:	c1 e8 10             	shr    $0x10,%eax
c0101f45:	0f b6 c0             	movzbl %al,%eax
c0101f48:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f4c:	83 c2 05             	add    $0x5,%edx
c0101f4f:	0f b7 d2             	movzwl %dx,%edx
c0101f52:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101f56:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101f59:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101f5d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101f61:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101f62:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101f66:	83 e0 01             	and    $0x1,%eax
c0101f69:	c1 e0 04             	shl    $0x4,%eax
c0101f6c:	89 c2                	mov    %eax,%edx
c0101f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f71:	c1 e8 18             	shr    $0x18,%eax
c0101f74:	83 e0 0f             	and    $0xf,%eax
c0101f77:	09 d0                	or     %edx,%eax
c0101f79:	83 c8 e0             	or     $0xffffffe0,%eax
c0101f7c:	0f b6 c0             	movzbl %al,%eax
c0101f7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f83:	83 c2 06             	add    $0x6,%edx
c0101f86:	0f b7 d2             	movzwl %dx,%edx
c0101f89:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101f8d:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101f90:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101f94:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101f98:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101f99:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f9d:	83 c0 07             	add    $0x7,%eax
c0101fa0:	0f b7 c0             	movzwl %ax,%eax
c0101fa3:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101fa7:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101fab:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101faf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101fb3:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101fb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101fbb:	eb 5a                	jmp    c0102017 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101fbd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fc1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101fc8:	00 
c0101fc9:	89 04 24             	mov    %eax,(%esp)
c0101fcc:	e8 e1 f7 ff ff       	call   c01017b2 <ide_wait_ready>
c0101fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101fd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101fd8:	74 02                	je     c0101fdc <ide_write_secs+0x1f7>
            goto out;
c0101fda:	eb 41                	jmp    c010201d <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101fdc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fe0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101fe3:	8b 45 10             	mov    0x10(%ebp),%eax
c0101fe6:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101fe9:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ff0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101ff3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ff6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101ff9:	89 cb                	mov    %ecx,%ebx
c0101ffb:	89 de                	mov    %ebx,%esi
c0101ffd:	89 c1                	mov    %eax,%ecx
c0101fff:	fc                   	cld    
c0102000:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0102002:	89 c8                	mov    %ecx,%eax
c0102004:	89 f3                	mov    %esi,%ebx
c0102006:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0102009:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c010200c:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0102010:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0102017:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c010201b:	75 a0                	jne    c0101fbd <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c010201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102020:	83 c4 50             	add    $0x50,%esp
c0102023:	5b                   	pop    %ebx
c0102024:	5e                   	pop    %esi
c0102025:	5d                   	pop    %ebp
c0102026:	c3                   	ret    

c0102027 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0102027:	55                   	push   %ebp
c0102028:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010202a:	fb                   	sti    
    sti();
}
c010202b:	5d                   	pop    %ebp
c010202c:	c3                   	ret    

c010202d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010202d:	55                   	push   %ebp
c010202e:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0102030:	fa                   	cli    
    cli();
}
c0102031:	5d                   	pop    %ebp
c0102032:	c3                   	ret    

c0102033 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0102033:	55                   	push   %ebp
c0102034:	89 e5                	mov    %esp,%ebp
c0102036:	83 ec 14             	sub    $0x14,%esp
c0102039:	8b 45 08             	mov    0x8(%ebp),%eax
c010203c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0102040:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102044:	66 a3 70 a5 12 c0    	mov    %ax,0xc012a570
    if (did_init) {
c010204a:	a1 a0 c6 19 c0       	mov    0xc019c6a0,%eax
c010204f:	85 c0                	test   %eax,%eax
c0102051:	74 36                	je     c0102089 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0102053:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102057:	0f b6 c0             	movzbl %al,%eax
c010205a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0102060:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102063:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102067:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010206b:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c010206c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102070:	66 c1 e8 08          	shr    $0x8,%ax
c0102074:	0f b6 c0             	movzbl %al,%eax
c0102077:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010207d:	88 45 f9             	mov    %al,-0x7(%ebp)
c0102080:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0102084:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102088:	ee                   	out    %al,(%dx)
    }
}
c0102089:	c9                   	leave  
c010208a:	c3                   	ret    

c010208b <pic_enable>:

void
pic_enable(unsigned int irq) {
c010208b:	55                   	push   %ebp
c010208c:	89 e5                	mov    %esp,%ebp
c010208e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0102091:	8b 45 08             	mov    0x8(%ebp),%eax
c0102094:	ba 01 00 00 00       	mov    $0x1,%edx
c0102099:	89 c1                	mov    %eax,%ecx
c010209b:	d3 e2                	shl    %cl,%edx
c010209d:	89 d0                	mov    %edx,%eax
c010209f:	f7 d0                	not    %eax
c01020a1:	89 c2                	mov    %eax,%edx
c01020a3:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01020aa:	21 d0                	and    %edx,%eax
c01020ac:	0f b7 c0             	movzwl %ax,%eax
c01020af:	89 04 24             	mov    %eax,(%esp)
c01020b2:	e8 7c ff ff ff       	call   c0102033 <pic_setmask>
}
c01020b7:	c9                   	leave  
c01020b8:	c3                   	ret    

c01020b9 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01020b9:	55                   	push   %ebp
c01020ba:	89 e5                	mov    %esp,%ebp
c01020bc:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01020bf:	c7 05 a0 c6 19 c0 01 	movl   $0x1,0xc019c6a0
c01020c6:	00 00 00 
c01020c9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01020cf:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c01020d3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01020d7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01020db:	ee                   	out    %al,(%dx)
c01020dc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01020e2:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01020e6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01020ea:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01020ee:	ee                   	out    %al,(%dx)
c01020ef:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01020f5:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01020f9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01020fd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102101:	ee                   	out    %al,(%dx)
c0102102:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102108:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010210c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102110:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102114:	ee                   	out    %al,(%dx)
c0102115:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010211b:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010211f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102123:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102127:	ee                   	out    %al,(%dx)
c0102128:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010212e:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102132:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102136:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010213a:	ee                   	out    %al,(%dx)
c010213b:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102141:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102145:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102149:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010214d:	ee                   	out    %al,(%dx)
c010214e:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102154:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102158:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010215c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102160:	ee                   	out    %al,(%dx)
c0102161:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102167:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010216b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010216f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102173:	ee                   	out    %al,(%dx)
c0102174:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010217a:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010217e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102182:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102186:	ee                   	out    %al,(%dx)
c0102187:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010218d:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102191:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102195:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102199:	ee                   	out    %al,(%dx)
c010219a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01021a0:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01021a4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01021a8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01021ac:	ee                   	out    %al,(%dx)
c01021ad:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01021b3:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01021b7:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01021bb:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01021bf:	ee                   	out    %al,(%dx)
c01021c0:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01021c6:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01021ca:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01021ce:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01021d2:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01021d3:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01021da:	66 83 f8 ff          	cmp    $0xffff,%ax
c01021de:	74 12                	je     c01021f2 <pic_init+0x139>
        pic_setmask(irq_mask);
c01021e0:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01021e7:	0f b7 c0             	movzwl %ax,%eax
c01021ea:	89 04 24             	mov    %eax,(%esp)
c01021ed:	e8 41 fe ff ff       	call   c0102033 <pic_setmask>
    }
}
c01021f2:	c9                   	leave  
c01021f3:	c3                   	ret    

c01021f4 <print_ticks>:
#include <sched.h>
#include <sync.h>

#define TICK_NUM 100

static void print_ticks() {
c01021f4:	55                   	push   %ebp
c01021f5:	89 e5                	mov    %esp,%ebp
c01021f7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01021fa:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102201:	00 
c0102202:	c7 04 24 00 c1 10 c0 	movl   $0xc010c100,(%esp)
c0102209:	e8 45 e1 ff ff       	call   c0100353 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010220e:	c9                   	leave  
c010220f:	c3                   	ret    

c0102210 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102210:	55                   	push   %ebp
c0102211:	89 e5                	mov    %esp,%ebp
c0102213:	83 ec 10             	sub    $0x10,%esp
     //so you should setup the syscall interrupt gate in here
	extern uintptr_t __vectors[];

	// 计算出有多少个IDT，依次遍历他们
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
c0102216:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010221d:	e9 c3 00 00 00       	jmp    c01022e5 <idt_init+0xd5>

		// 初始化若干IDT
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102222:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102225:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c010222c:	89 c2                	mov    %eax,%edx
c010222e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102231:	66 89 14 c5 c0 c6 19 	mov    %dx,-0x3fe63940(,%eax,8)
c0102238:	c0 
c0102239:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010223c:	66 c7 04 c5 c2 c6 19 	movw   $0x8,-0x3fe6393e(,%eax,8)
c0102243:	c0 08 00 
c0102246:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102249:	0f b6 14 c5 c4 c6 19 	movzbl -0x3fe6393c(,%eax,8),%edx
c0102250:	c0 
c0102251:	83 e2 e0             	and    $0xffffffe0,%edx
c0102254:	88 14 c5 c4 c6 19 c0 	mov    %dl,-0x3fe6393c(,%eax,8)
c010225b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010225e:	0f b6 14 c5 c4 c6 19 	movzbl -0x3fe6393c(,%eax,8),%edx
c0102265:	c0 
c0102266:	83 e2 1f             	and    $0x1f,%edx
c0102269:	88 14 c5 c4 c6 19 c0 	mov    %dl,-0x3fe6393c(,%eax,8)
c0102270:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102273:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c010227a:	c0 
c010227b:	83 e2 f0             	and    $0xfffffff0,%edx
c010227e:	83 ca 0e             	or     $0xe,%edx
c0102281:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c0102288:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010228b:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c0102292:	c0 
c0102293:	83 e2 ef             	and    $0xffffffef,%edx
c0102296:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c010229d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022a0:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022a7:	c0 
c01022a8:	83 e2 9f             	and    $0xffffff9f,%edx
c01022ab:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022b5:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022bc:	c0 
c01022bd:	83 ca 80             	or     $0xffffff80,%edx
c01022c0:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022ca:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c01022d1:	c1 e8 10             	shr    $0x10,%eax
c01022d4:	89 c2                	mov    %eax,%edx
c01022d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022d9:	66 89 14 c5 c6 c6 19 	mov    %dx,-0x3fe6393a(,%eax,8)
c01022e0:	c0 
     //so you should setup the syscall interrupt gate in here
	extern uintptr_t __vectors[];

	// 计算出有多少个IDT，依次遍历他们
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
c01022e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01022e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022e8:	3d ff 00 00 00       	cmp    $0xff,%eax
c01022ed:	0f 86 2f ff ff ff    	jbe    c0102222 <idt_init+0x12>

	// T_SWITCH_TOK 的发生时机是在用户空间的，所以对应的dpl需要修改为DPL_USER。
	//SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);

	// 用户态中断门，使用户态可以调用系统中断（从实验手册来的）
	SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
c01022f3:	a1 00 a8 12 c0       	mov    0xc012a800,%eax
c01022f8:	66 a3 c0 ca 19 c0    	mov    %ax,0xc019cac0
c01022fe:	66 c7 05 c2 ca 19 c0 	movw   $0x8,0xc019cac2
c0102305:	08 00 
c0102307:	0f b6 05 c4 ca 19 c0 	movzbl 0xc019cac4,%eax
c010230e:	83 e0 e0             	and    $0xffffffe0,%eax
c0102311:	a2 c4 ca 19 c0       	mov    %al,0xc019cac4
c0102316:	0f b6 05 c4 ca 19 c0 	movzbl 0xc019cac4,%eax
c010231d:	83 e0 1f             	and    $0x1f,%eax
c0102320:	a2 c4 ca 19 c0       	mov    %al,0xc019cac4
c0102325:	0f b6 05 c5 ca 19 c0 	movzbl 0xc019cac5,%eax
c010232c:	83 c8 0f             	or     $0xf,%eax
c010232f:	a2 c5 ca 19 c0       	mov    %al,0xc019cac5
c0102334:	0f b6 05 c5 ca 19 c0 	movzbl 0xc019cac5,%eax
c010233b:	83 e0 ef             	and    $0xffffffef,%eax
c010233e:	a2 c5 ca 19 c0       	mov    %al,0xc019cac5
c0102343:	0f b6 05 c5 ca 19 c0 	movzbl 0xc019cac5,%eax
c010234a:	83 c8 60             	or     $0x60,%eax
c010234d:	a2 c5 ca 19 c0       	mov    %al,0xc019cac5
c0102352:	0f b6 05 c5 ca 19 c0 	movzbl 0xc019cac5,%eax
c0102359:	83 c8 80             	or     $0xffffff80,%eax
c010235c:	a2 c5 ca 19 c0       	mov    %al,0xc019cac5
c0102361:	a1 00 a8 12 c0       	mov    0xc012a800,%eax
c0102366:	c1 e8 10             	shr    $0x10,%eax
c0102369:	66 a3 c6 ca 19 c0    	mov    %ax,0xc019cac6
c010236f:	c7 45 f8 80 a5 12 c0 	movl   $0xc012a580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102376:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102379:	0f 01 18             	lidtl  (%eax)

	// 加载IDT，只有特权级为0才允许执行
	lidt(&idt_pd);
}
c010237c:	c9                   	leave  
c010237d:	c3                   	ret    

c010237e <trapname>:

static const char *
trapname(int trapno) {
c010237e:	55                   	push   %ebp
c010237f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102381:	8b 45 08             	mov    0x8(%ebp),%eax
c0102384:	83 f8 13             	cmp    $0x13,%eax
c0102387:	77 0c                	ja     c0102395 <trapname+0x17>
        return excnames[trapno];
c0102389:	8b 45 08             	mov    0x8(%ebp),%eax
c010238c:	8b 04 85 80 c5 10 c0 	mov    -0x3fef3a80(,%eax,4),%eax
c0102393:	eb 18                	jmp    c01023ad <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102395:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102399:	7e 0d                	jle    c01023a8 <trapname+0x2a>
c010239b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c010239f:	7f 07                	jg     c01023a8 <trapname+0x2a>
        return "Hardware Interrupt";
c01023a1:	b8 0a c1 10 c0       	mov    $0xc010c10a,%eax
c01023a6:	eb 05                	jmp    c01023ad <trapname+0x2f>
    }
    return "(unknown trap)";
c01023a8:	b8 1d c1 10 c0       	mov    $0xc010c11d,%eax
}
c01023ad:	5d                   	pop    %ebp
c01023ae:	c3                   	ret    

c01023af <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01023af:	55                   	push   %ebp
c01023b0:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01023b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023b9:	66 83 f8 08          	cmp    $0x8,%ax
c01023bd:	0f 94 c0             	sete   %al
c01023c0:	0f b6 c0             	movzbl %al,%eax
}
c01023c3:	5d                   	pop    %ebp
c01023c4:	c3                   	ret    

c01023c5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01023c5:	55                   	push   %ebp
c01023c6:	89 e5                	mov    %esp,%ebp
c01023c8:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01023cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023d2:	c7 04 24 5e c1 10 c0 	movl   $0xc010c15e,(%esp)
c01023d9:	e8 75 df ff ff       	call   c0100353 <cprintf>
    print_regs(&tf->tf_regs);
c01023de:	8b 45 08             	mov    0x8(%ebp),%eax
c01023e1:	89 04 24             	mov    %eax,(%esp)
c01023e4:	e8 a1 01 00 00       	call   c010258a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01023e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ec:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01023f0:	0f b7 c0             	movzwl %ax,%eax
c01023f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023f7:	c7 04 24 6f c1 10 c0 	movl   $0xc010c16f,(%esp)
c01023fe:	e8 50 df ff ff       	call   c0100353 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102403:	8b 45 08             	mov    0x8(%ebp),%eax
c0102406:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c010240a:	0f b7 c0             	movzwl %ax,%eax
c010240d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102411:	c7 04 24 82 c1 10 c0 	movl   $0xc010c182,(%esp)
c0102418:	e8 36 df ff ff       	call   c0100353 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c010241d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102420:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102424:	0f b7 c0             	movzwl %ax,%eax
c0102427:	89 44 24 04          	mov    %eax,0x4(%esp)
c010242b:	c7 04 24 95 c1 10 c0 	movl   $0xc010c195,(%esp)
c0102432:	e8 1c df ff ff       	call   c0100353 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102437:	8b 45 08             	mov    0x8(%ebp),%eax
c010243a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010243e:	0f b7 c0             	movzwl %ax,%eax
c0102441:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102445:	c7 04 24 a8 c1 10 c0 	movl   $0xc010c1a8,(%esp)
c010244c:	e8 02 df ff ff       	call   c0100353 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102451:	8b 45 08             	mov    0x8(%ebp),%eax
c0102454:	8b 40 30             	mov    0x30(%eax),%eax
c0102457:	89 04 24             	mov    %eax,(%esp)
c010245a:	e8 1f ff ff ff       	call   c010237e <trapname>
c010245f:	8b 55 08             	mov    0x8(%ebp),%edx
c0102462:	8b 52 30             	mov    0x30(%edx),%edx
c0102465:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102469:	89 54 24 04          	mov    %edx,0x4(%esp)
c010246d:	c7 04 24 bb c1 10 c0 	movl   $0xc010c1bb,(%esp)
c0102474:	e8 da de ff ff       	call   c0100353 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102479:	8b 45 08             	mov    0x8(%ebp),%eax
c010247c:	8b 40 34             	mov    0x34(%eax),%eax
c010247f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102483:	c7 04 24 cd c1 10 c0 	movl   $0xc010c1cd,(%esp)
c010248a:	e8 c4 de ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c010248f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102492:	8b 40 38             	mov    0x38(%eax),%eax
c0102495:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102499:	c7 04 24 dc c1 10 c0 	movl   $0xc010c1dc,(%esp)
c01024a0:	e8 ae de ff ff       	call   c0100353 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01024a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01024ac:	0f b7 c0             	movzwl %ax,%eax
c01024af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b3:	c7 04 24 eb c1 10 c0 	movl   $0xc010c1eb,(%esp)
c01024ba:	e8 94 de ff ff       	call   c0100353 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01024bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c2:	8b 40 40             	mov    0x40(%eax),%eax
c01024c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024c9:	c7 04 24 fe c1 10 c0 	movl   $0xc010c1fe,(%esp)
c01024d0:	e8 7e de ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01024d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01024dc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01024e3:	eb 3e                	jmp    c0102523 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01024e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e8:	8b 50 40             	mov    0x40(%eax),%edx
c01024eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01024ee:	21 d0                	and    %edx,%eax
c01024f0:	85 c0                	test   %eax,%eax
c01024f2:	74 28                	je     c010251c <print_trapframe+0x157>
c01024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024f7:	8b 04 85 a0 a5 12 c0 	mov    -0x3fed5a60(,%eax,4),%eax
c01024fe:	85 c0                	test   %eax,%eax
c0102500:	74 1a                	je     c010251c <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0102502:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102505:	8b 04 85 a0 a5 12 c0 	mov    -0x3fed5a60(,%eax,4),%eax
c010250c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102510:	c7 04 24 0d c2 10 c0 	movl   $0xc010c20d,(%esp)
c0102517:	e8 37 de ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010251c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102520:	d1 65 f0             	shll   -0x10(%ebp)
c0102523:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102526:	83 f8 17             	cmp    $0x17,%eax
c0102529:	76 ba                	jbe    c01024e5 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c010252b:	8b 45 08             	mov    0x8(%ebp),%eax
c010252e:	8b 40 40             	mov    0x40(%eax),%eax
c0102531:	25 00 30 00 00       	and    $0x3000,%eax
c0102536:	c1 e8 0c             	shr    $0xc,%eax
c0102539:	89 44 24 04          	mov    %eax,0x4(%esp)
c010253d:	c7 04 24 11 c2 10 c0 	movl   $0xc010c211,(%esp)
c0102544:	e8 0a de ff ff       	call   c0100353 <cprintf>

    if (!trap_in_kernel(tf)) {
c0102549:	8b 45 08             	mov    0x8(%ebp),%eax
c010254c:	89 04 24             	mov    %eax,(%esp)
c010254f:	e8 5b fe ff ff       	call   c01023af <trap_in_kernel>
c0102554:	85 c0                	test   %eax,%eax
c0102556:	75 30                	jne    c0102588 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102558:	8b 45 08             	mov    0x8(%ebp),%eax
c010255b:	8b 40 44             	mov    0x44(%eax),%eax
c010255e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102562:	c7 04 24 1a c2 10 c0 	movl   $0xc010c21a,(%esp)
c0102569:	e8 e5 dd ff ff       	call   c0100353 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010256e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102571:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102575:	0f b7 c0             	movzwl %ax,%eax
c0102578:	89 44 24 04          	mov    %eax,0x4(%esp)
c010257c:	c7 04 24 29 c2 10 c0 	movl   $0xc010c229,(%esp)
c0102583:	e8 cb dd ff ff       	call   c0100353 <cprintf>
    }
}
c0102588:	c9                   	leave  
c0102589:	c3                   	ret    

c010258a <print_regs>:

void
print_regs(struct pushregs *regs) {
c010258a:	55                   	push   %ebp
c010258b:	89 e5                	mov    %esp,%ebp
c010258d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102590:	8b 45 08             	mov    0x8(%ebp),%eax
c0102593:	8b 00                	mov    (%eax),%eax
c0102595:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102599:	c7 04 24 3c c2 10 c0 	movl   $0xc010c23c,(%esp)
c01025a0:	e8 ae dd ff ff       	call   c0100353 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01025a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01025a8:	8b 40 04             	mov    0x4(%eax),%eax
c01025ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025af:	c7 04 24 4b c2 10 c0 	movl   $0xc010c24b,(%esp)
c01025b6:	e8 98 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01025bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01025be:	8b 40 08             	mov    0x8(%eax),%eax
c01025c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025c5:	c7 04 24 5a c2 10 c0 	movl   $0xc010c25a,(%esp)
c01025cc:	e8 82 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01025d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01025d4:	8b 40 0c             	mov    0xc(%eax),%eax
c01025d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025db:	c7 04 24 69 c2 10 c0 	movl   $0xc010c269,(%esp)
c01025e2:	e8 6c dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01025e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ea:	8b 40 10             	mov    0x10(%eax),%eax
c01025ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025f1:	c7 04 24 78 c2 10 c0 	movl   $0xc010c278,(%esp)
c01025f8:	e8 56 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01025fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102600:	8b 40 14             	mov    0x14(%eax),%eax
c0102603:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102607:	c7 04 24 87 c2 10 c0 	movl   $0xc010c287,(%esp)
c010260e:	e8 40 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102613:	8b 45 08             	mov    0x8(%ebp),%eax
c0102616:	8b 40 18             	mov    0x18(%eax),%eax
c0102619:	89 44 24 04          	mov    %eax,0x4(%esp)
c010261d:	c7 04 24 96 c2 10 c0 	movl   $0xc010c296,(%esp)
c0102624:	e8 2a dd ff ff       	call   c0100353 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102629:	8b 45 08             	mov    0x8(%ebp),%eax
c010262c:	8b 40 1c             	mov    0x1c(%eax),%eax
c010262f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102633:	c7 04 24 a5 c2 10 c0 	movl   $0xc010c2a5,(%esp)
c010263a:	e8 14 dd ff ff       	call   c0100353 <cprintf>
}
c010263f:	c9                   	leave  
c0102640:	c3                   	ret    

c0102641 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102641:	55                   	push   %ebp
c0102642:	89 e5                	mov    %esp,%ebp
c0102644:	53                   	push   %ebx
c0102645:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102648:	8b 45 08             	mov    0x8(%ebp),%eax
c010264b:	8b 40 34             	mov    0x34(%eax),%eax
c010264e:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102651:	85 c0                	test   %eax,%eax
c0102653:	74 07                	je     c010265c <print_pgfault+0x1b>
c0102655:	b9 b4 c2 10 c0       	mov    $0xc010c2b4,%ecx
c010265a:	eb 05                	jmp    c0102661 <print_pgfault+0x20>
c010265c:	b9 c5 c2 10 c0       	mov    $0xc010c2c5,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102661:	8b 45 08             	mov    0x8(%ebp),%eax
c0102664:	8b 40 34             	mov    0x34(%eax),%eax
c0102667:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010266a:	85 c0                	test   %eax,%eax
c010266c:	74 07                	je     c0102675 <print_pgfault+0x34>
c010266e:	ba 57 00 00 00       	mov    $0x57,%edx
c0102673:	eb 05                	jmp    c010267a <print_pgfault+0x39>
c0102675:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c010267a:	8b 45 08             	mov    0x8(%ebp),%eax
c010267d:	8b 40 34             	mov    0x34(%eax),%eax
c0102680:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102683:	85 c0                	test   %eax,%eax
c0102685:	74 07                	je     c010268e <print_pgfault+0x4d>
c0102687:	b8 55 00 00 00       	mov    $0x55,%eax
c010268c:	eb 05                	jmp    c0102693 <print_pgfault+0x52>
c010268e:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102693:	0f 20 d3             	mov    %cr2,%ebx
c0102696:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c0102699:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c010269c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01026a0:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01026a4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01026a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01026ac:	c7 04 24 d4 c2 10 c0 	movl   $0xc010c2d4,(%esp)
c01026b3:	e8 9b dc ff ff       	call   c0100353 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01026b8:	83 c4 34             	add    $0x34,%esp
c01026bb:	5b                   	pop    %ebx
c01026bc:	5d                   	pop    %ebp
c01026bd:	c3                   	ret    

c01026be <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01026be:	55                   	push   %ebp
c01026bf:	89 e5                	mov    %esp,%ebp
c01026c1:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    if(check_mm_struct !=NULL) { //used for test check_swap
c01026c4:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c01026c9:	85 c0                	test   %eax,%eax
c01026cb:	74 0b                	je     c01026d8 <pgfault_handler+0x1a>
            print_pgfault(tf);
c01026cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01026d0:	89 04 24             	mov    %eax,(%esp)
c01026d3:	e8 69 ff ff ff       	call   c0102641 <print_pgfault>
        }
    struct mm_struct *mm;
    if (check_mm_struct != NULL) {
c01026d8:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c01026dd:	85 c0                	test   %eax,%eax
c01026df:	74 3d                	je     c010271e <pgfault_handler+0x60>
        assert(current == idleproc);
c01026e1:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c01026e7:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c01026ec:	39 c2                	cmp    %eax,%edx
c01026ee:	74 24                	je     c0102714 <pgfault_handler+0x56>
c01026f0:	c7 44 24 0c f7 c2 10 	movl   $0xc010c2f7,0xc(%esp)
c01026f7:	c0 
c01026f8:	c7 44 24 08 0b c3 10 	movl   $0xc010c30b,0x8(%esp)
c01026ff:	c0 
c0102700:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0102707:	00 
c0102708:	c7 04 24 20 c3 10 c0 	movl   $0xc010c320,(%esp)
c010270f:	e8 c1 e6 ff ff       	call   c0100dd5 <__panic>
        mm = check_mm_struct;
c0102714:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0102719:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010271c:	eb 46                	jmp    c0102764 <pgfault_handler+0xa6>
    }
    else {
        if (current == NULL) {
c010271e:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102723:	85 c0                	test   %eax,%eax
c0102725:	75 32                	jne    c0102759 <pgfault_handler+0x9b>
            print_trapframe(tf);
c0102727:	8b 45 08             	mov    0x8(%ebp),%eax
c010272a:	89 04 24             	mov    %eax,(%esp)
c010272d:	e8 93 fc ff ff       	call   c01023c5 <print_trapframe>
            print_pgfault(tf);
c0102732:	8b 45 08             	mov    0x8(%ebp),%eax
c0102735:	89 04 24             	mov    %eax,(%esp)
c0102738:	e8 04 ff ff ff       	call   c0102641 <print_pgfault>
            panic("unhandled page fault.\n");
c010273d:	c7 44 24 08 31 c3 10 	movl   $0xc010c331,0x8(%esp)
c0102744:	c0 
c0102745:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c010274c:	00 
c010274d:	c7 04 24 20 c3 10 c0 	movl   $0xc010c320,(%esp)
c0102754:	e8 7c e6 ff ff       	call   c0100dd5 <__panic>
        }
        mm = current->mm;
c0102759:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010275e:	8b 40 18             	mov    0x18(%eax),%eax
c0102761:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102764:	0f 20 d0             	mov    %cr2,%eax
c0102767:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr2;
c010276a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    }
    return do_pgfault(mm, tf->tf_err, rcr2());
c010276d:	89 c2                	mov    %eax,%edx
c010276f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102772:	8b 40 34             	mov    0x34(%eax),%eax
c0102775:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102779:	89 44 24 04          	mov    %eax,0x4(%esp)
c010277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102780:	89 04 24             	mov    %eax,(%esp)
c0102783:	e8 b3 64 00 00       	call   c0108c3b <do_pgfault>
}
c0102788:	c9                   	leave  
c0102789:	c3                   	ret    

c010278a <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c010278a:	55                   	push   %ebp
c010278b:	89 e5                	mov    %esp,%ebp
c010278d:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret=0;
c0102790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    switch (tf->tf_trapno) {
c0102797:	8b 45 08             	mov    0x8(%ebp),%eax
c010279a:	8b 40 30             	mov    0x30(%eax),%eax
c010279d:	83 f8 2f             	cmp    $0x2f,%eax
c01027a0:	77 38                	ja     c01027da <trap_dispatch+0x50>
c01027a2:	83 f8 2e             	cmp    $0x2e,%eax
c01027a5:	0f 83 0a 02 00 00    	jae    c01029b5 <trap_dispatch+0x22b>
c01027ab:	83 f8 20             	cmp    $0x20,%eax
c01027ae:	0f 84 07 01 00 00    	je     c01028bb <trap_dispatch+0x131>
c01027b4:	83 f8 20             	cmp    $0x20,%eax
c01027b7:	77 0a                	ja     c01027c3 <trap_dispatch+0x39>
c01027b9:	83 f8 0e             	cmp    $0xe,%eax
c01027bc:	74 3e                	je     c01027fc <trap_dispatch+0x72>
c01027be:	e9 aa 01 00 00       	jmp    c010296d <trap_dispatch+0x1e3>
c01027c3:	83 f8 21             	cmp    $0x21,%eax
c01027c6:	0f 84 5f 01 00 00    	je     c010292b <trap_dispatch+0x1a1>
c01027cc:	83 f8 24             	cmp    $0x24,%eax
c01027cf:	0f 84 2d 01 00 00    	je     c0102902 <trap_dispatch+0x178>
c01027d5:	e9 93 01 00 00       	jmp    c010296d <trap_dispatch+0x1e3>
c01027da:	83 f8 78             	cmp    $0x78,%eax
c01027dd:	0f 82 8a 01 00 00    	jb     c010296d <trap_dispatch+0x1e3>
c01027e3:	83 f8 79             	cmp    $0x79,%eax
c01027e6:	0f 86 65 01 00 00    	jbe    c0102951 <trap_dispatch+0x1c7>
c01027ec:	3d 80 00 00 00       	cmp    $0x80,%eax
c01027f1:	0f 84 ba 00 00 00    	je     c01028b1 <trap_dispatch+0x127>
c01027f7:	e9 71 01 00 00       	jmp    c010296d <trap_dispatch+0x1e3>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01027fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ff:	89 04 24             	mov    %eax,(%esp)
c0102802:	e8 b7 fe ff ff       	call   c01026be <pgfault_handler>
c0102807:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010280a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010280e:	0f 84 98 00 00 00    	je     c01028ac <trap_dispatch+0x122>
            print_trapframe(tf);
c0102814:	8b 45 08             	mov    0x8(%ebp),%eax
c0102817:	89 04 24             	mov    %eax,(%esp)
c010281a:	e8 a6 fb ff ff       	call   c01023c5 <print_trapframe>
            if (current == NULL) {
c010281f:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102824:	85 c0                	test   %eax,%eax
c0102826:	75 23                	jne    c010284b <trap_dispatch+0xc1>
                panic("handle pgfault failed. ret=%d\n", ret);
c0102828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010282b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010282f:	c7 44 24 08 48 c3 10 	movl   $0xc010c348,0x8(%esp)
c0102836:	c0 
c0102837:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c010283e:	00 
c010283f:	c7 04 24 20 c3 10 c0 	movl   $0xc010c320,(%esp)
c0102846:	e8 8a e5 ff ff       	call   c0100dd5 <__panic>
            }
            else {
                if (trap_in_kernel(tf)) {
c010284b:	8b 45 08             	mov    0x8(%ebp),%eax
c010284e:	89 04 24             	mov    %eax,(%esp)
c0102851:	e8 59 fb ff ff       	call   c01023af <trap_in_kernel>
c0102856:	85 c0                	test   %eax,%eax
c0102858:	74 23                	je     c010287d <trap_dispatch+0xf3>
                    panic("handle pgfault failed in kernel mode. ret=%d\n", ret);
c010285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010285d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102861:	c7 44 24 08 68 c3 10 	movl   $0xc010c368,0x8(%esp)
c0102868:	c0 
c0102869:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0102870:	00 
c0102871:	c7 04 24 20 c3 10 c0 	movl   $0xc010c320,(%esp)
c0102878:	e8 58 e5 ff ff       	call   c0100dd5 <__panic>
                }
                cprintf("killed by kernel.\n");
c010287d:	c7 04 24 96 c3 10 c0 	movl   $0xc010c396,(%esp)
c0102884:	e8 ca da ff ff       	call   c0100353 <cprintf>
                panic("handle user mode pgfault failed. ret=%d\n", ret); 
c0102889:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010288c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102890:	c7 44 24 08 ac c3 10 	movl   $0xc010c3ac,0x8(%esp)
c0102897:	c0 
c0102898:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010289f:	00 
c01028a0:	c7 04 24 20 c3 10 c0 	movl   $0xc010c320,(%esp)
c01028a7:	e8 29 e5 ff ff       	call   c0100dd5 <__panic>
                do_exit(-E_KILLED);
            }
        }
        break;
c01028ac:	e9 05 01 00 00       	jmp    c01029b6 <trap_dispatch+0x22c>
    case T_SYSCALL:
        syscall();
c01028b1:	e8 03 87 00 00       	call   c010afb9 <syscall>
        break;
c01028b6:	e9 fb 00 00 00       	jmp    c01029b6 <trap_dispatch+0x22c>
         */
        /* LAB5 YOUR CODE */
        /* you should upate you lab1 code (just add ONE or TWO lines of code):
         *    Every TICK_NUM cycle, you should set current process's current->need_resched = 1
         */
    ticks++;
c01028bb:	a1 b4 ef 19 c0       	mov    0xc019efb4,%eax
c01028c0:	83 c0 01             	add    $0x1,%eax
c01028c3:	a3 b4 ef 19 c0       	mov    %eax,0xc019efb4
    if (ticks % TICK_NUM == 0) {
c01028c8:	8b 0d b4 ef 19 c0    	mov    0xc019efb4,%ecx
c01028ce:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01028d3:	89 c8                	mov    %ecx,%eax
c01028d5:	f7 e2                	mul    %edx
c01028d7:	89 d0                	mov    %edx,%eax
c01028d9:	c1 e8 05             	shr    $0x5,%eax
c01028dc:	6b c0 64             	imul   $0x64,%eax,%eax
c01028df:	29 c1                	sub    %eax,%ecx
c01028e1:	89 c8                	mov    %ecx,%eax
c01028e3:	85 c0                	test   %eax,%eax
c01028e5:	75 16                	jne    c01028fd <trap_dispatch+0x173>
    	print_ticks();
c01028e7:	e8 08 f9 ff ff       	call   c01021f4 <print_ticks>
    	current->need_resched = 1;
c01028ec:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01028f1:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    }  
        break;
c01028f8:	e9 b9 00 00 00       	jmp    c01029b6 <trap_dispatch+0x22c>
c01028fd:	e9 b4 00 00 00       	jmp    c01029b6 <trap_dispatch+0x22c>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102902:	e8 3c ee ff ff       	call   c0101743 <cons_getc>
c0102907:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c010290a:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c010290e:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102912:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102916:	89 44 24 04          	mov    %eax,0x4(%esp)
c010291a:	c7 04 24 d5 c3 10 c0 	movl   $0xc010c3d5,(%esp)
c0102921:	e8 2d da ff ff       	call   c0100353 <cprintf>
        break;
c0102926:	e9 8b 00 00 00       	jmp    c01029b6 <trap_dispatch+0x22c>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c010292b:	e8 13 ee ff ff       	call   c0101743 <cons_getc>
c0102930:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102933:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102937:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c010293b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010293f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102943:	c7 04 24 e7 c3 10 c0 	movl   $0xc010c3e7,(%esp)
c010294a:	e8 04 da ff ff       	call   c0100353 <cprintf>
        break;
c010294f:	eb 65                	jmp    c01029b6 <trap_dispatch+0x22c>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102951:	c7 44 24 08 f6 c3 10 	movl   $0xc010c3f6,0x8(%esp)
c0102958:	c0 
c0102959:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0102960:	00 
c0102961:	c7 04 24 20 c3 10 c0 	movl   $0xc010c320,(%esp)
c0102968:	e8 68 e4 ff ff       	call   c0100dd5 <__panic>
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        print_trapframe(tf);
c010296d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102970:	89 04 24             	mov    %eax,(%esp)
c0102973:	e8 4d fa ff ff       	call   c01023c5 <print_trapframe>
        if (current != NULL) {
c0102978:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010297d:	85 c0                	test   %eax,%eax
c010297f:	74 18                	je     c0102999 <trap_dispatch+0x20f>
            cprintf("unhandled trap.\n");
c0102981:	c7 04 24 06 c4 10 c0 	movl   $0xc010c406,(%esp)
c0102988:	e8 c6 d9 ff ff       	call   c0100353 <cprintf>
            do_exit(-E_KILLED);
c010298d:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c0102994:	e8 c3 73 00 00       	call   c0109d5c <do_exit>
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");
c0102999:	c7 44 24 08 17 c4 10 	movl   $0xc010c417,0x8(%esp)
c01029a0:	c0 
c01029a1:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c01029a8:	00 
c01029a9:	c7 04 24 20 c3 10 c0 	movl   $0xc010c320,(%esp)
c01029b0:	e8 20 e4 ff ff       	call   c0100dd5 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c01029b5:	90                   	nop
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");

    }
}
c01029b6:	c9                   	leave  
c01029b7:	c3                   	ret    

c01029b8 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01029b8:	55                   	push   %ebp
c01029b9:	89 e5                	mov    %esp,%ebp
c01029bb:	83 ec 28             	sub    $0x28,%esp
    // dispatch based on what type of trap occurred
    // used for previous projects
    if (current == NULL) {
c01029be:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01029c3:	85 c0                	test   %eax,%eax
c01029c5:	75 0d                	jne    c01029d4 <trap+0x1c>
        trap_dispatch(tf);
c01029c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ca:	89 04 24             	mov    %eax,(%esp)
c01029cd:	e8 b8 fd ff ff       	call   c010278a <trap_dispatch>
c01029d2:	eb 6c                	jmp    c0102a40 <trap+0x88>
    }
    else {
        // keep a trapframe chain in stack
        struct trapframe *otf = current->tf;
c01029d4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01029d9:	8b 40 3c             	mov    0x3c(%eax),%eax
c01029dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        current->tf = tf;
c01029df:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01029e4:	8b 55 08             	mov    0x8(%ebp),%edx
c01029e7:	89 50 3c             	mov    %edx,0x3c(%eax)
    
        bool in_kernel = trap_in_kernel(tf);
c01029ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ed:	89 04 24             	mov    %eax,(%esp)
c01029f0:	e8 ba f9 ff ff       	call   c01023af <trap_in_kernel>
c01029f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
        trap_dispatch(tf);
c01029f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01029fb:	89 04 24             	mov    %eax,(%esp)
c01029fe:	e8 87 fd ff ff       	call   c010278a <trap_dispatch>
    
        current->tf = otf;
c0102a03:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102a0b:	89 50 3c             	mov    %edx,0x3c(%eax)
        if (!in_kernel) {
c0102a0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102a12:	75 2c                	jne    c0102a40 <trap+0x88>
            if (current->flags & PF_EXITING) {
c0102a14:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102a19:	8b 40 44             	mov    0x44(%eax),%eax
c0102a1c:	83 e0 01             	and    $0x1,%eax
c0102a1f:	85 c0                	test   %eax,%eax
c0102a21:	74 0c                	je     c0102a2f <trap+0x77>
                do_exit(-E_KILLED);
c0102a23:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c0102a2a:	e8 2d 73 00 00       	call   c0109d5c <do_exit>
            }
            if (current->need_resched) {
c0102a2f:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102a34:	8b 40 10             	mov    0x10(%eax),%eax
c0102a37:	85 c0                	test   %eax,%eax
c0102a39:	74 05                	je     c0102a40 <trap+0x88>
                schedule();
c0102a3b:	e8 81 83 00 00       	call   c010adc1 <schedule>
            }
        }
    }
}
c0102a40:	c9                   	leave  
c0102a41:	c3                   	ret    

c0102a42 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102a42:	1e                   	push   %ds
    pushl %es
c0102a43:	06                   	push   %es
    pushl %fs
c0102a44:	0f a0                	push   %fs
    pushl %gs
c0102a46:	0f a8                	push   %gs
    pushal
c0102a48:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102a49:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102a4e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102a50:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102a52:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102a53:	e8 60 ff ff ff       	call   c01029b8 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102a58:	5c                   	pop    %esp

c0102a59 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102a59:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102a5a:	0f a9                	pop    %gs
    popl %fs
c0102a5c:	0f a1                	pop    %fs
    popl %es
c0102a5e:	07                   	pop    %es
    popl %ds
c0102a5f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102a60:	83 c4 08             	add    $0x8,%esp
    iret
c0102a63:	cf                   	iret   

c0102a64 <forkrets>:
    # 当iret返回时，会跳到entry.S 中的 kernel_thread_entry:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c0102a64:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c0102a68:	e9 ec ff ff ff       	jmp    c0102a59 <__trapret>

c0102a6d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102a6d:	6a 00                	push   $0x0
  pushl $0
c0102a6f:	6a 00                	push   $0x0
  jmp __alltraps
c0102a71:	e9 cc ff ff ff       	jmp    c0102a42 <__alltraps>

c0102a76 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102a76:	6a 00                	push   $0x0
  pushl $1
c0102a78:	6a 01                	push   $0x1
  jmp __alltraps
c0102a7a:	e9 c3 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102a7f <vector2>:
.globl vector2
vector2:
  pushl $0
c0102a7f:	6a 00                	push   $0x0
  pushl $2
c0102a81:	6a 02                	push   $0x2
  jmp __alltraps
c0102a83:	e9 ba ff ff ff       	jmp    c0102a42 <__alltraps>

c0102a88 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102a88:	6a 00                	push   $0x0
  pushl $3
c0102a8a:	6a 03                	push   $0x3
  jmp __alltraps
c0102a8c:	e9 b1 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102a91 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102a91:	6a 00                	push   $0x0
  pushl $4
c0102a93:	6a 04                	push   $0x4
  jmp __alltraps
c0102a95:	e9 a8 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102a9a <vector5>:
.globl vector5
vector5:
  pushl $0
c0102a9a:	6a 00                	push   $0x0
  pushl $5
c0102a9c:	6a 05                	push   $0x5
  jmp __alltraps
c0102a9e:	e9 9f ff ff ff       	jmp    c0102a42 <__alltraps>

c0102aa3 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102aa3:	6a 00                	push   $0x0
  pushl $6
c0102aa5:	6a 06                	push   $0x6
  jmp __alltraps
c0102aa7:	e9 96 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102aac <vector7>:
.globl vector7
vector7:
  pushl $0
c0102aac:	6a 00                	push   $0x0
  pushl $7
c0102aae:	6a 07                	push   $0x7
  jmp __alltraps
c0102ab0:	e9 8d ff ff ff       	jmp    c0102a42 <__alltraps>

c0102ab5 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102ab5:	6a 08                	push   $0x8
  jmp __alltraps
c0102ab7:	e9 86 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102abc <vector9>:
.globl vector9
vector9:
  pushl $9
c0102abc:	6a 09                	push   $0x9
  jmp __alltraps
c0102abe:	e9 7f ff ff ff       	jmp    c0102a42 <__alltraps>

c0102ac3 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102ac3:	6a 0a                	push   $0xa
  jmp __alltraps
c0102ac5:	e9 78 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102aca <vector11>:
.globl vector11
vector11:
  pushl $11
c0102aca:	6a 0b                	push   $0xb
  jmp __alltraps
c0102acc:	e9 71 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102ad1 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102ad1:	6a 0c                	push   $0xc
  jmp __alltraps
c0102ad3:	e9 6a ff ff ff       	jmp    c0102a42 <__alltraps>

c0102ad8 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102ad8:	6a 0d                	push   $0xd
  jmp __alltraps
c0102ada:	e9 63 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102adf <vector14>:
.globl vector14
vector14:
  pushl $14
c0102adf:	6a 0e                	push   $0xe
  jmp __alltraps
c0102ae1:	e9 5c ff ff ff       	jmp    c0102a42 <__alltraps>

c0102ae6 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102ae6:	6a 00                	push   $0x0
  pushl $15
c0102ae8:	6a 0f                	push   $0xf
  jmp __alltraps
c0102aea:	e9 53 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102aef <vector16>:
.globl vector16
vector16:
  pushl $0
c0102aef:	6a 00                	push   $0x0
  pushl $16
c0102af1:	6a 10                	push   $0x10
  jmp __alltraps
c0102af3:	e9 4a ff ff ff       	jmp    c0102a42 <__alltraps>

c0102af8 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102af8:	6a 11                	push   $0x11
  jmp __alltraps
c0102afa:	e9 43 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102aff <vector18>:
.globl vector18
vector18:
  pushl $0
c0102aff:	6a 00                	push   $0x0
  pushl $18
c0102b01:	6a 12                	push   $0x12
  jmp __alltraps
c0102b03:	e9 3a ff ff ff       	jmp    c0102a42 <__alltraps>

c0102b08 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102b08:	6a 00                	push   $0x0
  pushl $19
c0102b0a:	6a 13                	push   $0x13
  jmp __alltraps
c0102b0c:	e9 31 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102b11 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102b11:	6a 00                	push   $0x0
  pushl $20
c0102b13:	6a 14                	push   $0x14
  jmp __alltraps
c0102b15:	e9 28 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102b1a <vector21>:
.globl vector21
vector21:
  pushl $0
c0102b1a:	6a 00                	push   $0x0
  pushl $21
c0102b1c:	6a 15                	push   $0x15
  jmp __alltraps
c0102b1e:	e9 1f ff ff ff       	jmp    c0102a42 <__alltraps>

c0102b23 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102b23:	6a 00                	push   $0x0
  pushl $22
c0102b25:	6a 16                	push   $0x16
  jmp __alltraps
c0102b27:	e9 16 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102b2c <vector23>:
.globl vector23
vector23:
  pushl $0
c0102b2c:	6a 00                	push   $0x0
  pushl $23
c0102b2e:	6a 17                	push   $0x17
  jmp __alltraps
c0102b30:	e9 0d ff ff ff       	jmp    c0102a42 <__alltraps>

c0102b35 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102b35:	6a 00                	push   $0x0
  pushl $24
c0102b37:	6a 18                	push   $0x18
  jmp __alltraps
c0102b39:	e9 04 ff ff ff       	jmp    c0102a42 <__alltraps>

c0102b3e <vector25>:
.globl vector25
vector25:
  pushl $0
c0102b3e:	6a 00                	push   $0x0
  pushl $25
c0102b40:	6a 19                	push   $0x19
  jmp __alltraps
c0102b42:	e9 fb fe ff ff       	jmp    c0102a42 <__alltraps>

c0102b47 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102b47:	6a 00                	push   $0x0
  pushl $26
c0102b49:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102b4b:	e9 f2 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102b50 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102b50:	6a 00                	push   $0x0
  pushl $27
c0102b52:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102b54:	e9 e9 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102b59 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102b59:	6a 00                	push   $0x0
  pushl $28
c0102b5b:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102b5d:	e9 e0 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102b62 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102b62:	6a 00                	push   $0x0
  pushl $29
c0102b64:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102b66:	e9 d7 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102b6b <vector30>:
.globl vector30
vector30:
  pushl $0
c0102b6b:	6a 00                	push   $0x0
  pushl $30
c0102b6d:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102b6f:	e9 ce fe ff ff       	jmp    c0102a42 <__alltraps>

c0102b74 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102b74:	6a 00                	push   $0x0
  pushl $31
c0102b76:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102b78:	e9 c5 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102b7d <vector32>:
.globl vector32
vector32:
  pushl $0
c0102b7d:	6a 00                	push   $0x0
  pushl $32
c0102b7f:	6a 20                	push   $0x20
  jmp __alltraps
c0102b81:	e9 bc fe ff ff       	jmp    c0102a42 <__alltraps>

c0102b86 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102b86:	6a 00                	push   $0x0
  pushl $33
c0102b88:	6a 21                	push   $0x21
  jmp __alltraps
c0102b8a:	e9 b3 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102b8f <vector34>:
.globl vector34
vector34:
  pushl $0
c0102b8f:	6a 00                	push   $0x0
  pushl $34
c0102b91:	6a 22                	push   $0x22
  jmp __alltraps
c0102b93:	e9 aa fe ff ff       	jmp    c0102a42 <__alltraps>

c0102b98 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102b98:	6a 00                	push   $0x0
  pushl $35
c0102b9a:	6a 23                	push   $0x23
  jmp __alltraps
c0102b9c:	e9 a1 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102ba1 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102ba1:	6a 00                	push   $0x0
  pushl $36
c0102ba3:	6a 24                	push   $0x24
  jmp __alltraps
c0102ba5:	e9 98 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102baa <vector37>:
.globl vector37
vector37:
  pushl $0
c0102baa:	6a 00                	push   $0x0
  pushl $37
c0102bac:	6a 25                	push   $0x25
  jmp __alltraps
c0102bae:	e9 8f fe ff ff       	jmp    c0102a42 <__alltraps>

c0102bb3 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102bb3:	6a 00                	push   $0x0
  pushl $38
c0102bb5:	6a 26                	push   $0x26
  jmp __alltraps
c0102bb7:	e9 86 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102bbc <vector39>:
.globl vector39
vector39:
  pushl $0
c0102bbc:	6a 00                	push   $0x0
  pushl $39
c0102bbe:	6a 27                	push   $0x27
  jmp __alltraps
c0102bc0:	e9 7d fe ff ff       	jmp    c0102a42 <__alltraps>

c0102bc5 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102bc5:	6a 00                	push   $0x0
  pushl $40
c0102bc7:	6a 28                	push   $0x28
  jmp __alltraps
c0102bc9:	e9 74 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102bce <vector41>:
.globl vector41
vector41:
  pushl $0
c0102bce:	6a 00                	push   $0x0
  pushl $41
c0102bd0:	6a 29                	push   $0x29
  jmp __alltraps
c0102bd2:	e9 6b fe ff ff       	jmp    c0102a42 <__alltraps>

c0102bd7 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102bd7:	6a 00                	push   $0x0
  pushl $42
c0102bd9:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102bdb:	e9 62 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102be0 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102be0:	6a 00                	push   $0x0
  pushl $43
c0102be2:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102be4:	e9 59 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102be9 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102be9:	6a 00                	push   $0x0
  pushl $44
c0102beb:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102bed:	e9 50 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102bf2 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102bf2:	6a 00                	push   $0x0
  pushl $45
c0102bf4:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102bf6:	e9 47 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102bfb <vector46>:
.globl vector46
vector46:
  pushl $0
c0102bfb:	6a 00                	push   $0x0
  pushl $46
c0102bfd:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102bff:	e9 3e fe ff ff       	jmp    c0102a42 <__alltraps>

c0102c04 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102c04:	6a 00                	push   $0x0
  pushl $47
c0102c06:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102c08:	e9 35 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102c0d <vector48>:
.globl vector48
vector48:
  pushl $0
c0102c0d:	6a 00                	push   $0x0
  pushl $48
c0102c0f:	6a 30                	push   $0x30
  jmp __alltraps
c0102c11:	e9 2c fe ff ff       	jmp    c0102a42 <__alltraps>

c0102c16 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102c16:	6a 00                	push   $0x0
  pushl $49
c0102c18:	6a 31                	push   $0x31
  jmp __alltraps
c0102c1a:	e9 23 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102c1f <vector50>:
.globl vector50
vector50:
  pushl $0
c0102c1f:	6a 00                	push   $0x0
  pushl $50
c0102c21:	6a 32                	push   $0x32
  jmp __alltraps
c0102c23:	e9 1a fe ff ff       	jmp    c0102a42 <__alltraps>

c0102c28 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102c28:	6a 00                	push   $0x0
  pushl $51
c0102c2a:	6a 33                	push   $0x33
  jmp __alltraps
c0102c2c:	e9 11 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102c31 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102c31:	6a 00                	push   $0x0
  pushl $52
c0102c33:	6a 34                	push   $0x34
  jmp __alltraps
c0102c35:	e9 08 fe ff ff       	jmp    c0102a42 <__alltraps>

c0102c3a <vector53>:
.globl vector53
vector53:
  pushl $0
c0102c3a:	6a 00                	push   $0x0
  pushl $53
c0102c3c:	6a 35                	push   $0x35
  jmp __alltraps
c0102c3e:	e9 ff fd ff ff       	jmp    c0102a42 <__alltraps>

c0102c43 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102c43:	6a 00                	push   $0x0
  pushl $54
c0102c45:	6a 36                	push   $0x36
  jmp __alltraps
c0102c47:	e9 f6 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102c4c <vector55>:
.globl vector55
vector55:
  pushl $0
c0102c4c:	6a 00                	push   $0x0
  pushl $55
c0102c4e:	6a 37                	push   $0x37
  jmp __alltraps
c0102c50:	e9 ed fd ff ff       	jmp    c0102a42 <__alltraps>

c0102c55 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102c55:	6a 00                	push   $0x0
  pushl $56
c0102c57:	6a 38                	push   $0x38
  jmp __alltraps
c0102c59:	e9 e4 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102c5e <vector57>:
.globl vector57
vector57:
  pushl $0
c0102c5e:	6a 00                	push   $0x0
  pushl $57
c0102c60:	6a 39                	push   $0x39
  jmp __alltraps
c0102c62:	e9 db fd ff ff       	jmp    c0102a42 <__alltraps>

c0102c67 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102c67:	6a 00                	push   $0x0
  pushl $58
c0102c69:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102c6b:	e9 d2 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102c70 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102c70:	6a 00                	push   $0x0
  pushl $59
c0102c72:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102c74:	e9 c9 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102c79 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102c79:	6a 00                	push   $0x0
  pushl $60
c0102c7b:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102c7d:	e9 c0 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102c82 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102c82:	6a 00                	push   $0x0
  pushl $61
c0102c84:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102c86:	e9 b7 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102c8b <vector62>:
.globl vector62
vector62:
  pushl $0
c0102c8b:	6a 00                	push   $0x0
  pushl $62
c0102c8d:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102c8f:	e9 ae fd ff ff       	jmp    c0102a42 <__alltraps>

c0102c94 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102c94:	6a 00                	push   $0x0
  pushl $63
c0102c96:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102c98:	e9 a5 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102c9d <vector64>:
.globl vector64
vector64:
  pushl $0
c0102c9d:	6a 00                	push   $0x0
  pushl $64
c0102c9f:	6a 40                	push   $0x40
  jmp __alltraps
c0102ca1:	e9 9c fd ff ff       	jmp    c0102a42 <__alltraps>

c0102ca6 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102ca6:	6a 00                	push   $0x0
  pushl $65
c0102ca8:	6a 41                	push   $0x41
  jmp __alltraps
c0102caa:	e9 93 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102caf <vector66>:
.globl vector66
vector66:
  pushl $0
c0102caf:	6a 00                	push   $0x0
  pushl $66
c0102cb1:	6a 42                	push   $0x42
  jmp __alltraps
c0102cb3:	e9 8a fd ff ff       	jmp    c0102a42 <__alltraps>

c0102cb8 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102cb8:	6a 00                	push   $0x0
  pushl $67
c0102cba:	6a 43                	push   $0x43
  jmp __alltraps
c0102cbc:	e9 81 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102cc1 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102cc1:	6a 00                	push   $0x0
  pushl $68
c0102cc3:	6a 44                	push   $0x44
  jmp __alltraps
c0102cc5:	e9 78 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102cca <vector69>:
.globl vector69
vector69:
  pushl $0
c0102cca:	6a 00                	push   $0x0
  pushl $69
c0102ccc:	6a 45                	push   $0x45
  jmp __alltraps
c0102cce:	e9 6f fd ff ff       	jmp    c0102a42 <__alltraps>

c0102cd3 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102cd3:	6a 00                	push   $0x0
  pushl $70
c0102cd5:	6a 46                	push   $0x46
  jmp __alltraps
c0102cd7:	e9 66 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102cdc <vector71>:
.globl vector71
vector71:
  pushl $0
c0102cdc:	6a 00                	push   $0x0
  pushl $71
c0102cde:	6a 47                	push   $0x47
  jmp __alltraps
c0102ce0:	e9 5d fd ff ff       	jmp    c0102a42 <__alltraps>

c0102ce5 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102ce5:	6a 00                	push   $0x0
  pushl $72
c0102ce7:	6a 48                	push   $0x48
  jmp __alltraps
c0102ce9:	e9 54 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102cee <vector73>:
.globl vector73
vector73:
  pushl $0
c0102cee:	6a 00                	push   $0x0
  pushl $73
c0102cf0:	6a 49                	push   $0x49
  jmp __alltraps
c0102cf2:	e9 4b fd ff ff       	jmp    c0102a42 <__alltraps>

c0102cf7 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102cf7:	6a 00                	push   $0x0
  pushl $74
c0102cf9:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102cfb:	e9 42 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102d00 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102d00:	6a 00                	push   $0x0
  pushl $75
c0102d02:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102d04:	e9 39 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102d09 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102d09:	6a 00                	push   $0x0
  pushl $76
c0102d0b:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102d0d:	e9 30 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102d12 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102d12:	6a 00                	push   $0x0
  pushl $77
c0102d14:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102d16:	e9 27 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102d1b <vector78>:
.globl vector78
vector78:
  pushl $0
c0102d1b:	6a 00                	push   $0x0
  pushl $78
c0102d1d:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102d1f:	e9 1e fd ff ff       	jmp    c0102a42 <__alltraps>

c0102d24 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102d24:	6a 00                	push   $0x0
  pushl $79
c0102d26:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102d28:	e9 15 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102d2d <vector80>:
.globl vector80
vector80:
  pushl $0
c0102d2d:	6a 00                	push   $0x0
  pushl $80
c0102d2f:	6a 50                	push   $0x50
  jmp __alltraps
c0102d31:	e9 0c fd ff ff       	jmp    c0102a42 <__alltraps>

c0102d36 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102d36:	6a 00                	push   $0x0
  pushl $81
c0102d38:	6a 51                	push   $0x51
  jmp __alltraps
c0102d3a:	e9 03 fd ff ff       	jmp    c0102a42 <__alltraps>

c0102d3f <vector82>:
.globl vector82
vector82:
  pushl $0
c0102d3f:	6a 00                	push   $0x0
  pushl $82
c0102d41:	6a 52                	push   $0x52
  jmp __alltraps
c0102d43:	e9 fa fc ff ff       	jmp    c0102a42 <__alltraps>

c0102d48 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102d48:	6a 00                	push   $0x0
  pushl $83
c0102d4a:	6a 53                	push   $0x53
  jmp __alltraps
c0102d4c:	e9 f1 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102d51 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102d51:	6a 00                	push   $0x0
  pushl $84
c0102d53:	6a 54                	push   $0x54
  jmp __alltraps
c0102d55:	e9 e8 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102d5a <vector85>:
.globl vector85
vector85:
  pushl $0
c0102d5a:	6a 00                	push   $0x0
  pushl $85
c0102d5c:	6a 55                	push   $0x55
  jmp __alltraps
c0102d5e:	e9 df fc ff ff       	jmp    c0102a42 <__alltraps>

c0102d63 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102d63:	6a 00                	push   $0x0
  pushl $86
c0102d65:	6a 56                	push   $0x56
  jmp __alltraps
c0102d67:	e9 d6 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102d6c <vector87>:
.globl vector87
vector87:
  pushl $0
c0102d6c:	6a 00                	push   $0x0
  pushl $87
c0102d6e:	6a 57                	push   $0x57
  jmp __alltraps
c0102d70:	e9 cd fc ff ff       	jmp    c0102a42 <__alltraps>

c0102d75 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102d75:	6a 00                	push   $0x0
  pushl $88
c0102d77:	6a 58                	push   $0x58
  jmp __alltraps
c0102d79:	e9 c4 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102d7e <vector89>:
.globl vector89
vector89:
  pushl $0
c0102d7e:	6a 00                	push   $0x0
  pushl $89
c0102d80:	6a 59                	push   $0x59
  jmp __alltraps
c0102d82:	e9 bb fc ff ff       	jmp    c0102a42 <__alltraps>

c0102d87 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102d87:	6a 00                	push   $0x0
  pushl $90
c0102d89:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102d8b:	e9 b2 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102d90 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102d90:	6a 00                	push   $0x0
  pushl $91
c0102d92:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102d94:	e9 a9 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102d99 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102d99:	6a 00                	push   $0x0
  pushl $92
c0102d9b:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102d9d:	e9 a0 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102da2 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102da2:	6a 00                	push   $0x0
  pushl $93
c0102da4:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102da6:	e9 97 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102dab <vector94>:
.globl vector94
vector94:
  pushl $0
c0102dab:	6a 00                	push   $0x0
  pushl $94
c0102dad:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102daf:	e9 8e fc ff ff       	jmp    c0102a42 <__alltraps>

c0102db4 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102db4:	6a 00                	push   $0x0
  pushl $95
c0102db6:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102db8:	e9 85 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102dbd <vector96>:
.globl vector96
vector96:
  pushl $0
c0102dbd:	6a 00                	push   $0x0
  pushl $96
c0102dbf:	6a 60                	push   $0x60
  jmp __alltraps
c0102dc1:	e9 7c fc ff ff       	jmp    c0102a42 <__alltraps>

c0102dc6 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102dc6:	6a 00                	push   $0x0
  pushl $97
c0102dc8:	6a 61                	push   $0x61
  jmp __alltraps
c0102dca:	e9 73 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102dcf <vector98>:
.globl vector98
vector98:
  pushl $0
c0102dcf:	6a 00                	push   $0x0
  pushl $98
c0102dd1:	6a 62                	push   $0x62
  jmp __alltraps
c0102dd3:	e9 6a fc ff ff       	jmp    c0102a42 <__alltraps>

c0102dd8 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102dd8:	6a 00                	push   $0x0
  pushl $99
c0102dda:	6a 63                	push   $0x63
  jmp __alltraps
c0102ddc:	e9 61 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102de1 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102de1:	6a 00                	push   $0x0
  pushl $100
c0102de3:	6a 64                	push   $0x64
  jmp __alltraps
c0102de5:	e9 58 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102dea <vector101>:
.globl vector101
vector101:
  pushl $0
c0102dea:	6a 00                	push   $0x0
  pushl $101
c0102dec:	6a 65                	push   $0x65
  jmp __alltraps
c0102dee:	e9 4f fc ff ff       	jmp    c0102a42 <__alltraps>

c0102df3 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102df3:	6a 00                	push   $0x0
  pushl $102
c0102df5:	6a 66                	push   $0x66
  jmp __alltraps
c0102df7:	e9 46 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102dfc <vector103>:
.globl vector103
vector103:
  pushl $0
c0102dfc:	6a 00                	push   $0x0
  pushl $103
c0102dfe:	6a 67                	push   $0x67
  jmp __alltraps
c0102e00:	e9 3d fc ff ff       	jmp    c0102a42 <__alltraps>

c0102e05 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102e05:	6a 00                	push   $0x0
  pushl $104
c0102e07:	6a 68                	push   $0x68
  jmp __alltraps
c0102e09:	e9 34 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102e0e <vector105>:
.globl vector105
vector105:
  pushl $0
c0102e0e:	6a 00                	push   $0x0
  pushl $105
c0102e10:	6a 69                	push   $0x69
  jmp __alltraps
c0102e12:	e9 2b fc ff ff       	jmp    c0102a42 <__alltraps>

c0102e17 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102e17:	6a 00                	push   $0x0
  pushl $106
c0102e19:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102e1b:	e9 22 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102e20 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102e20:	6a 00                	push   $0x0
  pushl $107
c0102e22:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102e24:	e9 19 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102e29 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102e29:	6a 00                	push   $0x0
  pushl $108
c0102e2b:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102e2d:	e9 10 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102e32 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102e32:	6a 00                	push   $0x0
  pushl $109
c0102e34:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102e36:	e9 07 fc ff ff       	jmp    c0102a42 <__alltraps>

c0102e3b <vector110>:
.globl vector110
vector110:
  pushl $0
c0102e3b:	6a 00                	push   $0x0
  pushl $110
c0102e3d:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102e3f:	e9 fe fb ff ff       	jmp    c0102a42 <__alltraps>

c0102e44 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102e44:	6a 00                	push   $0x0
  pushl $111
c0102e46:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102e48:	e9 f5 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102e4d <vector112>:
.globl vector112
vector112:
  pushl $0
c0102e4d:	6a 00                	push   $0x0
  pushl $112
c0102e4f:	6a 70                	push   $0x70
  jmp __alltraps
c0102e51:	e9 ec fb ff ff       	jmp    c0102a42 <__alltraps>

c0102e56 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102e56:	6a 00                	push   $0x0
  pushl $113
c0102e58:	6a 71                	push   $0x71
  jmp __alltraps
c0102e5a:	e9 e3 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102e5f <vector114>:
.globl vector114
vector114:
  pushl $0
c0102e5f:	6a 00                	push   $0x0
  pushl $114
c0102e61:	6a 72                	push   $0x72
  jmp __alltraps
c0102e63:	e9 da fb ff ff       	jmp    c0102a42 <__alltraps>

c0102e68 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102e68:	6a 00                	push   $0x0
  pushl $115
c0102e6a:	6a 73                	push   $0x73
  jmp __alltraps
c0102e6c:	e9 d1 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102e71 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102e71:	6a 00                	push   $0x0
  pushl $116
c0102e73:	6a 74                	push   $0x74
  jmp __alltraps
c0102e75:	e9 c8 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102e7a <vector117>:
.globl vector117
vector117:
  pushl $0
c0102e7a:	6a 00                	push   $0x0
  pushl $117
c0102e7c:	6a 75                	push   $0x75
  jmp __alltraps
c0102e7e:	e9 bf fb ff ff       	jmp    c0102a42 <__alltraps>

c0102e83 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102e83:	6a 00                	push   $0x0
  pushl $118
c0102e85:	6a 76                	push   $0x76
  jmp __alltraps
c0102e87:	e9 b6 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102e8c <vector119>:
.globl vector119
vector119:
  pushl $0
c0102e8c:	6a 00                	push   $0x0
  pushl $119
c0102e8e:	6a 77                	push   $0x77
  jmp __alltraps
c0102e90:	e9 ad fb ff ff       	jmp    c0102a42 <__alltraps>

c0102e95 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102e95:	6a 00                	push   $0x0
  pushl $120
c0102e97:	6a 78                	push   $0x78
  jmp __alltraps
c0102e99:	e9 a4 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102e9e <vector121>:
.globl vector121
vector121:
  pushl $0
c0102e9e:	6a 00                	push   $0x0
  pushl $121
c0102ea0:	6a 79                	push   $0x79
  jmp __alltraps
c0102ea2:	e9 9b fb ff ff       	jmp    c0102a42 <__alltraps>

c0102ea7 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102ea7:	6a 00                	push   $0x0
  pushl $122
c0102ea9:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102eab:	e9 92 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102eb0 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102eb0:	6a 00                	push   $0x0
  pushl $123
c0102eb2:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102eb4:	e9 89 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102eb9 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102eb9:	6a 00                	push   $0x0
  pushl $124
c0102ebb:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102ebd:	e9 80 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102ec2 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102ec2:	6a 00                	push   $0x0
  pushl $125
c0102ec4:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102ec6:	e9 77 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102ecb <vector126>:
.globl vector126
vector126:
  pushl $0
c0102ecb:	6a 00                	push   $0x0
  pushl $126
c0102ecd:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102ecf:	e9 6e fb ff ff       	jmp    c0102a42 <__alltraps>

c0102ed4 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102ed4:	6a 00                	push   $0x0
  pushl $127
c0102ed6:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102ed8:	e9 65 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102edd <vector128>:
.globl vector128
vector128:
  pushl $0
c0102edd:	6a 00                	push   $0x0
  pushl $128
c0102edf:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102ee4:	e9 59 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102ee9 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102ee9:	6a 00                	push   $0x0
  pushl $129
c0102eeb:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102ef0:	e9 4d fb ff ff       	jmp    c0102a42 <__alltraps>

c0102ef5 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102ef5:	6a 00                	push   $0x0
  pushl $130
c0102ef7:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102efc:	e9 41 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102f01 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102f01:	6a 00                	push   $0x0
  pushl $131
c0102f03:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102f08:	e9 35 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102f0d <vector132>:
.globl vector132
vector132:
  pushl $0
c0102f0d:	6a 00                	push   $0x0
  pushl $132
c0102f0f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102f14:	e9 29 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102f19 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102f19:	6a 00                	push   $0x0
  pushl $133
c0102f1b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102f20:	e9 1d fb ff ff       	jmp    c0102a42 <__alltraps>

c0102f25 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102f25:	6a 00                	push   $0x0
  pushl $134
c0102f27:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102f2c:	e9 11 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102f31 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102f31:	6a 00                	push   $0x0
  pushl $135
c0102f33:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102f38:	e9 05 fb ff ff       	jmp    c0102a42 <__alltraps>

c0102f3d <vector136>:
.globl vector136
vector136:
  pushl $0
c0102f3d:	6a 00                	push   $0x0
  pushl $136
c0102f3f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102f44:	e9 f9 fa ff ff       	jmp    c0102a42 <__alltraps>

c0102f49 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102f49:	6a 00                	push   $0x0
  pushl $137
c0102f4b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102f50:	e9 ed fa ff ff       	jmp    c0102a42 <__alltraps>

c0102f55 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102f55:	6a 00                	push   $0x0
  pushl $138
c0102f57:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102f5c:	e9 e1 fa ff ff       	jmp    c0102a42 <__alltraps>

c0102f61 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102f61:	6a 00                	push   $0x0
  pushl $139
c0102f63:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102f68:	e9 d5 fa ff ff       	jmp    c0102a42 <__alltraps>

c0102f6d <vector140>:
.globl vector140
vector140:
  pushl $0
c0102f6d:	6a 00                	push   $0x0
  pushl $140
c0102f6f:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102f74:	e9 c9 fa ff ff       	jmp    c0102a42 <__alltraps>

c0102f79 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102f79:	6a 00                	push   $0x0
  pushl $141
c0102f7b:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102f80:	e9 bd fa ff ff       	jmp    c0102a42 <__alltraps>

c0102f85 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102f85:	6a 00                	push   $0x0
  pushl $142
c0102f87:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102f8c:	e9 b1 fa ff ff       	jmp    c0102a42 <__alltraps>

c0102f91 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102f91:	6a 00                	push   $0x0
  pushl $143
c0102f93:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102f98:	e9 a5 fa ff ff       	jmp    c0102a42 <__alltraps>

c0102f9d <vector144>:
.globl vector144
vector144:
  pushl $0
c0102f9d:	6a 00                	push   $0x0
  pushl $144
c0102f9f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102fa4:	e9 99 fa ff ff       	jmp    c0102a42 <__alltraps>

c0102fa9 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102fa9:	6a 00                	push   $0x0
  pushl $145
c0102fab:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102fb0:	e9 8d fa ff ff       	jmp    c0102a42 <__alltraps>

c0102fb5 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102fb5:	6a 00                	push   $0x0
  pushl $146
c0102fb7:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102fbc:	e9 81 fa ff ff       	jmp    c0102a42 <__alltraps>

c0102fc1 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102fc1:	6a 00                	push   $0x0
  pushl $147
c0102fc3:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102fc8:	e9 75 fa ff ff       	jmp    c0102a42 <__alltraps>

c0102fcd <vector148>:
.globl vector148
vector148:
  pushl $0
c0102fcd:	6a 00                	push   $0x0
  pushl $148
c0102fcf:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102fd4:	e9 69 fa ff ff       	jmp    c0102a42 <__alltraps>

c0102fd9 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102fd9:	6a 00                	push   $0x0
  pushl $149
c0102fdb:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102fe0:	e9 5d fa ff ff       	jmp    c0102a42 <__alltraps>

c0102fe5 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102fe5:	6a 00                	push   $0x0
  pushl $150
c0102fe7:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102fec:	e9 51 fa ff ff       	jmp    c0102a42 <__alltraps>

c0102ff1 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102ff1:	6a 00                	push   $0x0
  pushl $151
c0102ff3:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102ff8:	e9 45 fa ff ff       	jmp    c0102a42 <__alltraps>

c0102ffd <vector152>:
.globl vector152
vector152:
  pushl $0
c0102ffd:	6a 00                	push   $0x0
  pushl $152
c0102fff:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0103004:	e9 39 fa ff ff       	jmp    c0102a42 <__alltraps>

c0103009 <vector153>:
.globl vector153
vector153:
  pushl $0
c0103009:	6a 00                	push   $0x0
  pushl $153
c010300b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0103010:	e9 2d fa ff ff       	jmp    c0102a42 <__alltraps>

c0103015 <vector154>:
.globl vector154
vector154:
  pushl $0
c0103015:	6a 00                	push   $0x0
  pushl $154
c0103017:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010301c:	e9 21 fa ff ff       	jmp    c0102a42 <__alltraps>

c0103021 <vector155>:
.globl vector155
vector155:
  pushl $0
c0103021:	6a 00                	push   $0x0
  pushl $155
c0103023:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0103028:	e9 15 fa ff ff       	jmp    c0102a42 <__alltraps>

c010302d <vector156>:
.globl vector156
vector156:
  pushl $0
c010302d:	6a 00                	push   $0x0
  pushl $156
c010302f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0103034:	e9 09 fa ff ff       	jmp    c0102a42 <__alltraps>

c0103039 <vector157>:
.globl vector157
vector157:
  pushl $0
c0103039:	6a 00                	push   $0x0
  pushl $157
c010303b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0103040:	e9 fd f9 ff ff       	jmp    c0102a42 <__alltraps>

c0103045 <vector158>:
.globl vector158
vector158:
  pushl $0
c0103045:	6a 00                	push   $0x0
  pushl $158
c0103047:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010304c:	e9 f1 f9 ff ff       	jmp    c0102a42 <__alltraps>

c0103051 <vector159>:
.globl vector159
vector159:
  pushl $0
c0103051:	6a 00                	push   $0x0
  pushl $159
c0103053:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0103058:	e9 e5 f9 ff ff       	jmp    c0102a42 <__alltraps>

c010305d <vector160>:
.globl vector160
vector160:
  pushl $0
c010305d:	6a 00                	push   $0x0
  pushl $160
c010305f:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0103064:	e9 d9 f9 ff ff       	jmp    c0102a42 <__alltraps>

c0103069 <vector161>:
.globl vector161
vector161:
  pushl $0
c0103069:	6a 00                	push   $0x0
  pushl $161
c010306b:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0103070:	e9 cd f9 ff ff       	jmp    c0102a42 <__alltraps>

c0103075 <vector162>:
.globl vector162
vector162:
  pushl $0
c0103075:	6a 00                	push   $0x0
  pushl $162
c0103077:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010307c:	e9 c1 f9 ff ff       	jmp    c0102a42 <__alltraps>

c0103081 <vector163>:
.globl vector163
vector163:
  pushl $0
c0103081:	6a 00                	push   $0x0
  pushl $163
c0103083:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0103088:	e9 b5 f9 ff ff       	jmp    c0102a42 <__alltraps>

c010308d <vector164>:
.globl vector164
vector164:
  pushl $0
c010308d:	6a 00                	push   $0x0
  pushl $164
c010308f:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0103094:	e9 a9 f9 ff ff       	jmp    c0102a42 <__alltraps>

c0103099 <vector165>:
.globl vector165
vector165:
  pushl $0
c0103099:	6a 00                	push   $0x0
  pushl $165
c010309b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01030a0:	e9 9d f9 ff ff       	jmp    c0102a42 <__alltraps>

c01030a5 <vector166>:
.globl vector166
vector166:
  pushl $0
c01030a5:	6a 00                	push   $0x0
  pushl $166
c01030a7:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01030ac:	e9 91 f9 ff ff       	jmp    c0102a42 <__alltraps>

c01030b1 <vector167>:
.globl vector167
vector167:
  pushl $0
c01030b1:	6a 00                	push   $0x0
  pushl $167
c01030b3:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01030b8:	e9 85 f9 ff ff       	jmp    c0102a42 <__alltraps>

c01030bd <vector168>:
.globl vector168
vector168:
  pushl $0
c01030bd:	6a 00                	push   $0x0
  pushl $168
c01030bf:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01030c4:	e9 79 f9 ff ff       	jmp    c0102a42 <__alltraps>

c01030c9 <vector169>:
.globl vector169
vector169:
  pushl $0
c01030c9:	6a 00                	push   $0x0
  pushl $169
c01030cb:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01030d0:	e9 6d f9 ff ff       	jmp    c0102a42 <__alltraps>

c01030d5 <vector170>:
.globl vector170
vector170:
  pushl $0
c01030d5:	6a 00                	push   $0x0
  pushl $170
c01030d7:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01030dc:	e9 61 f9 ff ff       	jmp    c0102a42 <__alltraps>

c01030e1 <vector171>:
.globl vector171
vector171:
  pushl $0
c01030e1:	6a 00                	push   $0x0
  pushl $171
c01030e3:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01030e8:	e9 55 f9 ff ff       	jmp    c0102a42 <__alltraps>

c01030ed <vector172>:
.globl vector172
vector172:
  pushl $0
c01030ed:	6a 00                	push   $0x0
  pushl $172
c01030ef:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01030f4:	e9 49 f9 ff ff       	jmp    c0102a42 <__alltraps>

c01030f9 <vector173>:
.globl vector173
vector173:
  pushl $0
c01030f9:	6a 00                	push   $0x0
  pushl $173
c01030fb:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0103100:	e9 3d f9 ff ff       	jmp    c0102a42 <__alltraps>

c0103105 <vector174>:
.globl vector174
vector174:
  pushl $0
c0103105:	6a 00                	push   $0x0
  pushl $174
c0103107:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010310c:	e9 31 f9 ff ff       	jmp    c0102a42 <__alltraps>

c0103111 <vector175>:
.globl vector175
vector175:
  pushl $0
c0103111:	6a 00                	push   $0x0
  pushl $175
c0103113:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0103118:	e9 25 f9 ff ff       	jmp    c0102a42 <__alltraps>

c010311d <vector176>:
.globl vector176
vector176:
  pushl $0
c010311d:	6a 00                	push   $0x0
  pushl $176
c010311f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0103124:	e9 19 f9 ff ff       	jmp    c0102a42 <__alltraps>

c0103129 <vector177>:
.globl vector177
vector177:
  pushl $0
c0103129:	6a 00                	push   $0x0
  pushl $177
c010312b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0103130:	e9 0d f9 ff ff       	jmp    c0102a42 <__alltraps>

c0103135 <vector178>:
.globl vector178
vector178:
  pushl $0
c0103135:	6a 00                	push   $0x0
  pushl $178
c0103137:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010313c:	e9 01 f9 ff ff       	jmp    c0102a42 <__alltraps>

c0103141 <vector179>:
.globl vector179
vector179:
  pushl $0
c0103141:	6a 00                	push   $0x0
  pushl $179
c0103143:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0103148:	e9 f5 f8 ff ff       	jmp    c0102a42 <__alltraps>

c010314d <vector180>:
.globl vector180
vector180:
  pushl $0
c010314d:	6a 00                	push   $0x0
  pushl $180
c010314f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0103154:	e9 e9 f8 ff ff       	jmp    c0102a42 <__alltraps>

c0103159 <vector181>:
.globl vector181
vector181:
  pushl $0
c0103159:	6a 00                	push   $0x0
  pushl $181
c010315b:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0103160:	e9 dd f8 ff ff       	jmp    c0102a42 <__alltraps>

c0103165 <vector182>:
.globl vector182
vector182:
  pushl $0
c0103165:	6a 00                	push   $0x0
  pushl $182
c0103167:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010316c:	e9 d1 f8 ff ff       	jmp    c0102a42 <__alltraps>

c0103171 <vector183>:
.globl vector183
vector183:
  pushl $0
c0103171:	6a 00                	push   $0x0
  pushl $183
c0103173:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0103178:	e9 c5 f8 ff ff       	jmp    c0102a42 <__alltraps>

c010317d <vector184>:
.globl vector184
vector184:
  pushl $0
c010317d:	6a 00                	push   $0x0
  pushl $184
c010317f:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0103184:	e9 b9 f8 ff ff       	jmp    c0102a42 <__alltraps>

c0103189 <vector185>:
.globl vector185
vector185:
  pushl $0
c0103189:	6a 00                	push   $0x0
  pushl $185
c010318b:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0103190:	e9 ad f8 ff ff       	jmp    c0102a42 <__alltraps>

c0103195 <vector186>:
.globl vector186
vector186:
  pushl $0
c0103195:	6a 00                	push   $0x0
  pushl $186
c0103197:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010319c:	e9 a1 f8 ff ff       	jmp    c0102a42 <__alltraps>

c01031a1 <vector187>:
.globl vector187
vector187:
  pushl $0
c01031a1:	6a 00                	push   $0x0
  pushl $187
c01031a3:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01031a8:	e9 95 f8 ff ff       	jmp    c0102a42 <__alltraps>

c01031ad <vector188>:
.globl vector188
vector188:
  pushl $0
c01031ad:	6a 00                	push   $0x0
  pushl $188
c01031af:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01031b4:	e9 89 f8 ff ff       	jmp    c0102a42 <__alltraps>

c01031b9 <vector189>:
.globl vector189
vector189:
  pushl $0
c01031b9:	6a 00                	push   $0x0
  pushl $189
c01031bb:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01031c0:	e9 7d f8 ff ff       	jmp    c0102a42 <__alltraps>

c01031c5 <vector190>:
.globl vector190
vector190:
  pushl $0
c01031c5:	6a 00                	push   $0x0
  pushl $190
c01031c7:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01031cc:	e9 71 f8 ff ff       	jmp    c0102a42 <__alltraps>

c01031d1 <vector191>:
.globl vector191
vector191:
  pushl $0
c01031d1:	6a 00                	push   $0x0
  pushl $191
c01031d3:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01031d8:	e9 65 f8 ff ff       	jmp    c0102a42 <__alltraps>

c01031dd <vector192>:
.globl vector192
vector192:
  pushl $0
c01031dd:	6a 00                	push   $0x0
  pushl $192
c01031df:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01031e4:	e9 59 f8 ff ff       	jmp    c0102a42 <__alltraps>

c01031e9 <vector193>:
.globl vector193
vector193:
  pushl $0
c01031e9:	6a 00                	push   $0x0
  pushl $193
c01031eb:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01031f0:	e9 4d f8 ff ff       	jmp    c0102a42 <__alltraps>

c01031f5 <vector194>:
.globl vector194
vector194:
  pushl $0
c01031f5:	6a 00                	push   $0x0
  pushl $194
c01031f7:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01031fc:	e9 41 f8 ff ff       	jmp    c0102a42 <__alltraps>

c0103201 <vector195>:
.globl vector195
vector195:
  pushl $0
c0103201:	6a 00                	push   $0x0
  pushl $195
c0103203:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0103208:	e9 35 f8 ff ff       	jmp    c0102a42 <__alltraps>

c010320d <vector196>:
.globl vector196
vector196:
  pushl $0
c010320d:	6a 00                	push   $0x0
  pushl $196
c010320f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0103214:	e9 29 f8 ff ff       	jmp    c0102a42 <__alltraps>

c0103219 <vector197>:
.globl vector197
vector197:
  pushl $0
c0103219:	6a 00                	push   $0x0
  pushl $197
c010321b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0103220:	e9 1d f8 ff ff       	jmp    c0102a42 <__alltraps>

c0103225 <vector198>:
.globl vector198
vector198:
  pushl $0
c0103225:	6a 00                	push   $0x0
  pushl $198
c0103227:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010322c:	e9 11 f8 ff ff       	jmp    c0102a42 <__alltraps>

c0103231 <vector199>:
.globl vector199
vector199:
  pushl $0
c0103231:	6a 00                	push   $0x0
  pushl $199
c0103233:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0103238:	e9 05 f8 ff ff       	jmp    c0102a42 <__alltraps>

c010323d <vector200>:
.globl vector200
vector200:
  pushl $0
c010323d:	6a 00                	push   $0x0
  pushl $200
c010323f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0103244:	e9 f9 f7 ff ff       	jmp    c0102a42 <__alltraps>

c0103249 <vector201>:
.globl vector201
vector201:
  pushl $0
c0103249:	6a 00                	push   $0x0
  pushl $201
c010324b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0103250:	e9 ed f7 ff ff       	jmp    c0102a42 <__alltraps>

c0103255 <vector202>:
.globl vector202
vector202:
  pushl $0
c0103255:	6a 00                	push   $0x0
  pushl $202
c0103257:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010325c:	e9 e1 f7 ff ff       	jmp    c0102a42 <__alltraps>

c0103261 <vector203>:
.globl vector203
vector203:
  pushl $0
c0103261:	6a 00                	push   $0x0
  pushl $203
c0103263:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0103268:	e9 d5 f7 ff ff       	jmp    c0102a42 <__alltraps>

c010326d <vector204>:
.globl vector204
vector204:
  pushl $0
c010326d:	6a 00                	push   $0x0
  pushl $204
c010326f:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0103274:	e9 c9 f7 ff ff       	jmp    c0102a42 <__alltraps>

c0103279 <vector205>:
.globl vector205
vector205:
  pushl $0
c0103279:	6a 00                	push   $0x0
  pushl $205
c010327b:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0103280:	e9 bd f7 ff ff       	jmp    c0102a42 <__alltraps>

c0103285 <vector206>:
.globl vector206
vector206:
  pushl $0
c0103285:	6a 00                	push   $0x0
  pushl $206
c0103287:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010328c:	e9 b1 f7 ff ff       	jmp    c0102a42 <__alltraps>

c0103291 <vector207>:
.globl vector207
vector207:
  pushl $0
c0103291:	6a 00                	push   $0x0
  pushl $207
c0103293:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0103298:	e9 a5 f7 ff ff       	jmp    c0102a42 <__alltraps>

c010329d <vector208>:
.globl vector208
vector208:
  pushl $0
c010329d:	6a 00                	push   $0x0
  pushl $208
c010329f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01032a4:	e9 99 f7 ff ff       	jmp    c0102a42 <__alltraps>

c01032a9 <vector209>:
.globl vector209
vector209:
  pushl $0
c01032a9:	6a 00                	push   $0x0
  pushl $209
c01032ab:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01032b0:	e9 8d f7 ff ff       	jmp    c0102a42 <__alltraps>

c01032b5 <vector210>:
.globl vector210
vector210:
  pushl $0
c01032b5:	6a 00                	push   $0x0
  pushl $210
c01032b7:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01032bc:	e9 81 f7 ff ff       	jmp    c0102a42 <__alltraps>

c01032c1 <vector211>:
.globl vector211
vector211:
  pushl $0
c01032c1:	6a 00                	push   $0x0
  pushl $211
c01032c3:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01032c8:	e9 75 f7 ff ff       	jmp    c0102a42 <__alltraps>

c01032cd <vector212>:
.globl vector212
vector212:
  pushl $0
c01032cd:	6a 00                	push   $0x0
  pushl $212
c01032cf:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01032d4:	e9 69 f7 ff ff       	jmp    c0102a42 <__alltraps>

c01032d9 <vector213>:
.globl vector213
vector213:
  pushl $0
c01032d9:	6a 00                	push   $0x0
  pushl $213
c01032db:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01032e0:	e9 5d f7 ff ff       	jmp    c0102a42 <__alltraps>

c01032e5 <vector214>:
.globl vector214
vector214:
  pushl $0
c01032e5:	6a 00                	push   $0x0
  pushl $214
c01032e7:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01032ec:	e9 51 f7 ff ff       	jmp    c0102a42 <__alltraps>

c01032f1 <vector215>:
.globl vector215
vector215:
  pushl $0
c01032f1:	6a 00                	push   $0x0
  pushl $215
c01032f3:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01032f8:	e9 45 f7 ff ff       	jmp    c0102a42 <__alltraps>

c01032fd <vector216>:
.globl vector216
vector216:
  pushl $0
c01032fd:	6a 00                	push   $0x0
  pushl $216
c01032ff:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103304:	e9 39 f7 ff ff       	jmp    c0102a42 <__alltraps>

c0103309 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103309:	6a 00                	push   $0x0
  pushl $217
c010330b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103310:	e9 2d f7 ff ff       	jmp    c0102a42 <__alltraps>

c0103315 <vector218>:
.globl vector218
vector218:
  pushl $0
c0103315:	6a 00                	push   $0x0
  pushl $218
c0103317:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010331c:	e9 21 f7 ff ff       	jmp    c0102a42 <__alltraps>

c0103321 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103321:	6a 00                	push   $0x0
  pushl $219
c0103323:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0103328:	e9 15 f7 ff ff       	jmp    c0102a42 <__alltraps>

c010332d <vector220>:
.globl vector220
vector220:
  pushl $0
c010332d:	6a 00                	push   $0x0
  pushl $220
c010332f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103334:	e9 09 f7 ff ff       	jmp    c0102a42 <__alltraps>

c0103339 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103339:	6a 00                	push   $0x0
  pushl $221
c010333b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103340:	e9 fd f6 ff ff       	jmp    c0102a42 <__alltraps>

c0103345 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103345:	6a 00                	push   $0x0
  pushl $222
c0103347:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010334c:	e9 f1 f6 ff ff       	jmp    c0102a42 <__alltraps>

c0103351 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103351:	6a 00                	push   $0x0
  pushl $223
c0103353:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103358:	e9 e5 f6 ff ff       	jmp    c0102a42 <__alltraps>

c010335d <vector224>:
.globl vector224
vector224:
  pushl $0
c010335d:	6a 00                	push   $0x0
  pushl $224
c010335f:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103364:	e9 d9 f6 ff ff       	jmp    c0102a42 <__alltraps>

c0103369 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103369:	6a 00                	push   $0x0
  pushl $225
c010336b:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103370:	e9 cd f6 ff ff       	jmp    c0102a42 <__alltraps>

c0103375 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103375:	6a 00                	push   $0x0
  pushl $226
c0103377:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010337c:	e9 c1 f6 ff ff       	jmp    c0102a42 <__alltraps>

c0103381 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103381:	6a 00                	push   $0x0
  pushl $227
c0103383:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0103388:	e9 b5 f6 ff ff       	jmp    c0102a42 <__alltraps>

c010338d <vector228>:
.globl vector228
vector228:
  pushl $0
c010338d:	6a 00                	push   $0x0
  pushl $228
c010338f:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103394:	e9 a9 f6 ff ff       	jmp    c0102a42 <__alltraps>

c0103399 <vector229>:
.globl vector229
vector229:
  pushl $0
c0103399:	6a 00                	push   $0x0
  pushl $229
c010339b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01033a0:	e9 9d f6 ff ff       	jmp    c0102a42 <__alltraps>

c01033a5 <vector230>:
.globl vector230
vector230:
  pushl $0
c01033a5:	6a 00                	push   $0x0
  pushl $230
c01033a7:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01033ac:	e9 91 f6 ff ff       	jmp    c0102a42 <__alltraps>

c01033b1 <vector231>:
.globl vector231
vector231:
  pushl $0
c01033b1:	6a 00                	push   $0x0
  pushl $231
c01033b3:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01033b8:	e9 85 f6 ff ff       	jmp    c0102a42 <__alltraps>

c01033bd <vector232>:
.globl vector232
vector232:
  pushl $0
c01033bd:	6a 00                	push   $0x0
  pushl $232
c01033bf:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01033c4:	e9 79 f6 ff ff       	jmp    c0102a42 <__alltraps>

c01033c9 <vector233>:
.globl vector233
vector233:
  pushl $0
c01033c9:	6a 00                	push   $0x0
  pushl $233
c01033cb:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01033d0:	e9 6d f6 ff ff       	jmp    c0102a42 <__alltraps>

c01033d5 <vector234>:
.globl vector234
vector234:
  pushl $0
c01033d5:	6a 00                	push   $0x0
  pushl $234
c01033d7:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01033dc:	e9 61 f6 ff ff       	jmp    c0102a42 <__alltraps>

c01033e1 <vector235>:
.globl vector235
vector235:
  pushl $0
c01033e1:	6a 00                	push   $0x0
  pushl $235
c01033e3:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01033e8:	e9 55 f6 ff ff       	jmp    c0102a42 <__alltraps>

c01033ed <vector236>:
.globl vector236
vector236:
  pushl $0
c01033ed:	6a 00                	push   $0x0
  pushl $236
c01033ef:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01033f4:	e9 49 f6 ff ff       	jmp    c0102a42 <__alltraps>

c01033f9 <vector237>:
.globl vector237
vector237:
  pushl $0
c01033f9:	6a 00                	push   $0x0
  pushl $237
c01033fb:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103400:	e9 3d f6 ff ff       	jmp    c0102a42 <__alltraps>

c0103405 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103405:	6a 00                	push   $0x0
  pushl $238
c0103407:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010340c:	e9 31 f6 ff ff       	jmp    c0102a42 <__alltraps>

c0103411 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103411:	6a 00                	push   $0x0
  pushl $239
c0103413:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0103418:	e9 25 f6 ff ff       	jmp    c0102a42 <__alltraps>

c010341d <vector240>:
.globl vector240
vector240:
  pushl $0
c010341d:	6a 00                	push   $0x0
  pushl $240
c010341f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103424:	e9 19 f6 ff ff       	jmp    c0102a42 <__alltraps>

c0103429 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103429:	6a 00                	push   $0x0
  pushl $241
c010342b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103430:	e9 0d f6 ff ff       	jmp    c0102a42 <__alltraps>

c0103435 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103435:	6a 00                	push   $0x0
  pushl $242
c0103437:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010343c:	e9 01 f6 ff ff       	jmp    c0102a42 <__alltraps>

c0103441 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103441:	6a 00                	push   $0x0
  pushl $243
c0103443:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103448:	e9 f5 f5 ff ff       	jmp    c0102a42 <__alltraps>

c010344d <vector244>:
.globl vector244
vector244:
  pushl $0
c010344d:	6a 00                	push   $0x0
  pushl $244
c010344f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103454:	e9 e9 f5 ff ff       	jmp    c0102a42 <__alltraps>

c0103459 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103459:	6a 00                	push   $0x0
  pushl $245
c010345b:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103460:	e9 dd f5 ff ff       	jmp    c0102a42 <__alltraps>

c0103465 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103465:	6a 00                	push   $0x0
  pushl $246
c0103467:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010346c:	e9 d1 f5 ff ff       	jmp    c0102a42 <__alltraps>

c0103471 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103471:	6a 00                	push   $0x0
  pushl $247
c0103473:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0103478:	e9 c5 f5 ff ff       	jmp    c0102a42 <__alltraps>

c010347d <vector248>:
.globl vector248
vector248:
  pushl $0
c010347d:	6a 00                	push   $0x0
  pushl $248
c010347f:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103484:	e9 b9 f5 ff ff       	jmp    c0102a42 <__alltraps>

c0103489 <vector249>:
.globl vector249
vector249:
  pushl $0
c0103489:	6a 00                	push   $0x0
  pushl $249
c010348b:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103490:	e9 ad f5 ff ff       	jmp    c0102a42 <__alltraps>

c0103495 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103495:	6a 00                	push   $0x0
  pushl $250
c0103497:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010349c:	e9 a1 f5 ff ff       	jmp    c0102a42 <__alltraps>

c01034a1 <vector251>:
.globl vector251
vector251:
  pushl $0
c01034a1:	6a 00                	push   $0x0
  pushl $251
c01034a3:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01034a8:	e9 95 f5 ff ff       	jmp    c0102a42 <__alltraps>

c01034ad <vector252>:
.globl vector252
vector252:
  pushl $0
c01034ad:	6a 00                	push   $0x0
  pushl $252
c01034af:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01034b4:	e9 89 f5 ff ff       	jmp    c0102a42 <__alltraps>

c01034b9 <vector253>:
.globl vector253
vector253:
  pushl $0
c01034b9:	6a 00                	push   $0x0
  pushl $253
c01034bb:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01034c0:	e9 7d f5 ff ff       	jmp    c0102a42 <__alltraps>

c01034c5 <vector254>:
.globl vector254
vector254:
  pushl $0
c01034c5:	6a 00                	push   $0x0
  pushl $254
c01034c7:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01034cc:	e9 71 f5 ff ff       	jmp    c0102a42 <__alltraps>

c01034d1 <vector255>:
.globl vector255
vector255:
  pushl $0
c01034d1:	6a 00                	push   $0x0
  pushl $255
c01034d3:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01034d8:	e9 65 f5 ff ff       	jmp    c0102a42 <__alltraps>

c01034dd <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01034dd:	55                   	push   %ebp
c01034de:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01034e0:	8b 55 08             	mov    0x8(%ebp),%edx
c01034e3:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01034e8:	29 c2                	sub    %eax,%edx
c01034ea:	89 d0                	mov    %edx,%eax
c01034ec:	c1 f8 05             	sar    $0x5,%eax
}
c01034ef:	5d                   	pop    %ebp
c01034f0:	c3                   	ret    

c01034f1 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01034f1:	55                   	push   %ebp
c01034f2:	89 e5                	mov    %esp,%ebp
c01034f4:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01034f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01034fa:	89 04 24             	mov    %eax,(%esp)
c01034fd:	e8 db ff ff ff       	call   c01034dd <page2ppn>
c0103502:	c1 e0 0c             	shl    $0xc,%eax
}
c0103505:	c9                   	leave  
c0103506:	c3                   	ret    

c0103507 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103507:	55                   	push   %ebp
c0103508:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010350a:	8b 45 08             	mov    0x8(%ebp),%eax
c010350d:	8b 00                	mov    (%eax),%eax
}
c010350f:	5d                   	pop    %ebp
c0103510:	c3                   	ret    

c0103511 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103511:	55                   	push   %ebp
c0103512:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103514:	8b 45 08             	mov    0x8(%ebp),%eax
c0103517:	8b 55 0c             	mov    0xc(%ebp),%edx
c010351a:	89 10                	mov    %edx,(%eax)
}
c010351c:	5d                   	pop    %ebp
c010351d:	c3                   	ret    

c010351e <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010351e:	55                   	push   %ebp
c010351f:	89 e5                	mov    %esp,%ebp
c0103521:	83 ec 10             	sub    $0x10,%esp
c0103524:	c7 45 fc b8 ef 19 c0 	movl   $0xc019efb8,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010352b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010352e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103531:	89 50 04             	mov    %edx,0x4(%eax)
c0103534:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103537:	8b 50 04             	mov    0x4(%eax),%edx
c010353a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010353d:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010353f:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c0103546:	00 00 00 
}
c0103549:	c9                   	leave  
c010354a:	c3                   	ret    

c010354b <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010354b:	55                   	push   %ebp
c010354c:	89 e5                	mov    %esp,%ebp
c010354e:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103551:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103555:	75 24                	jne    c010357b <default_init_memmap+0x30>
c0103557:	c7 44 24 0c d0 c5 10 	movl   $0xc010c5d0,0xc(%esp)
c010355e:	c0 
c010355f:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103566:	c0 
c0103567:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010356e:	00 
c010356f:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103576:	e8 5a d8 ff ff       	call   c0100dd5 <__panic>
    struct Page *p = base;
c010357b:	8b 45 08             	mov    0x8(%ebp),%eax
c010357e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103581:	e9 de 00 00 00       	jmp    c0103664 <default_init_memmap+0x119>
        assert(PageReserved(p));
c0103586:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103589:	83 c0 04             	add    $0x4,%eax
c010358c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103593:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103596:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103599:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010359c:	0f a3 10             	bt     %edx,(%eax)
c010359f:	19 c0                	sbb    %eax,%eax
c01035a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01035a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01035a8:	0f 95 c0             	setne  %al
c01035ab:	0f b6 c0             	movzbl %al,%eax
c01035ae:	85 c0                	test   %eax,%eax
c01035b0:	75 24                	jne    c01035d6 <default_init_memmap+0x8b>
c01035b2:	c7 44 24 0c 01 c6 10 	movl   $0xc010c601,0xc(%esp)
c01035b9:	c0 
c01035ba:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c01035c1:	c0 
c01035c2:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01035c9:	00 
c01035ca:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c01035d1:	e8 ff d7 ff ff       	call   c0100dd5 <__panic>
        p->flags = p->property = 0;
c01035d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01035e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e3:	8b 50 08             	mov    0x8(%eax),%edx
c01035e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e9:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01035ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01035f3:	00 
c01035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f7:	89 04 24             	mov    %eax,(%esp)
c01035fa:	e8 12 ff ff ff       	call   c0103511 <set_page_ref>
        SetPageProperty(p);
c01035ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103602:	83 c0 04             	add    $0x4,%eax
c0103605:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010360c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010360f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103612:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103615:	0f ab 10             	bts    %edx,(%eax)
        list_add_before(&free_list, &(p->page_link));
c0103618:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010361b:	83 c0 0c             	add    $0xc,%eax
c010361e:	c7 45 dc b8 ef 19 c0 	movl   $0xc019efb8,-0x24(%ebp)
c0103625:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103628:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010362b:	8b 00                	mov    (%eax),%eax
c010362d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103630:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103633:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103636:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103639:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010363c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010363f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103642:	89 10                	mov    %edx,(%eax)
c0103644:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103647:	8b 10                	mov    (%eax),%edx
c0103649:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010364c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010364f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103652:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103655:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103658:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010365b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010365e:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0103660:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103664:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103667:	c1 e0 05             	shl    $0x5,%eax
c010366a:	89 c2                	mov    %eax,%edx
c010366c:	8b 45 08             	mov    0x8(%ebp),%eax
c010366f:	01 d0                	add    %edx,%eax
c0103671:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103674:	0f 85 0c ff ff ff    	jne    c0103586 <default_init_memmap+0x3b>
        p->flags = p->property = 0;
        set_page_ref(p, 0);
        SetPageProperty(p);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c010367a:	8b 45 08             	mov    0x8(%ebp),%eax
c010367d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103680:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0103683:	8b 15 c0 ef 19 c0    	mov    0xc019efc0,%edx
c0103689:	8b 45 0c             	mov    0xc(%ebp),%eax
c010368c:	01 d0                	add    %edx,%eax
c010368e:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
}
c0103693:	c9                   	leave  
c0103694:	c3                   	ret    

c0103695 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0103695:	55                   	push   %ebp
c0103696:	89 e5                	mov    %esp,%ebp
c0103698:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010369b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010369f:	75 24                	jne    c01036c5 <default_alloc_pages+0x30>
c01036a1:	c7 44 24 0c d0 c5 10 	movl   $0xc010c5d0,0xc(%esp)
c01036a8:	c0 
c01036a9:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c01036b0:	c0 
c01036b1:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c01036b8:	00 
c01036b9:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c01036c0:	e8 10 d7 ff ff       	call   c0100dd5 <__panic>
    if (n > nr_free) {
c01036c5:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01036ca:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036cd:	73 0a                	jae    c01036d9 <default_alloc_pages+0x44>
        return NULL;
c01036cf:	b8 00 00 00 00       	mov    $0x0,%eax
c01036d4:	e9 37 01 00 00       	jmp    c0103810 <default_alloc_pages+0x17b>
    }

    list_entry_t *len;			// 跟以前的p和q双指针差不多，le相当于前指针，len后指针
    list_entry_t *le = &free_list;
c01036d9:	c7 45 f4 b8 ef 19 c0 	movl   $0xc019efb8,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01036e0:	e9 0a 01 00 00       	jmp    c01037ef <default_alloc_pages+0x15a>
        struct Page *p = le2page(le, page_link);
c01036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e8:	83 e8 0c             	sub    $0xc,%eax
c01036eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01036ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036f1:	8b 40 08             	mov    0x8(%eax),%eax
c01036f4:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036f7:	0f 82 f2 00 00 00    	jb     c01037ef <default_alloc_pages+0x15a>
            // 分配页数
            int i;
            for (i = 0; i < n; i++) {
c01036fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103704:	eb 7c                	jmp    c0103782 <default_alloc_pages+0xed>
c0103706:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103709:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010370c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010370f:	8b 40 04             	mov    0x4(%eax),%eax
            	len = list_next(le);
c0103712:	89 45 e8             	mov    %eax,-0x18(%ebp)
            	struct Page *pp = le2page(le, page_link);
c0103715:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103718:	83 e8 0c             	sub    $0xc,%eax
c010371b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            	// 每一页的标志位改写
            	// 被内核所保留
            	SetPageReserved(pp);
c010371e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103721:	83 c0 04             	add    $0x4,%eax
c0103724:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010372b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010372e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103731:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103734:	0f ab 10             	bts    %edx,(%eax)
            	// 不是头页
            	ClearPageProperty(pp);
c0103737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010373a:	83 c0 04             	add    $0x4,%eax
c010373d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103744:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103747:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010374a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010374d:	0f b3 10             	btr    %edx,(%eax)
c0103750:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103753:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103756:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103759:	8b 40 04             	mov    0x4(%eax),%eax
c010375c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010375f:	8b 12                	mov    (%edx),%edx
c0103761:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103764:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103767:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010376a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010376d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103770:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103773:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103776:	89 10                	mov    %edx,(%eax)
            	// 既然分配好了，下一步就将其从freelist中删除
            	list_del(le);
            	le = len;
c0103778:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010377b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            // 分配页数
            int i;
            for (i = 0; i < n; i++) {
c010377e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0103782:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103785:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103788:	0f 82 78 ff ff ff    	jb     c0103706 <default_alloc_pages+0x71>
            	ClearPageProperty(pp);
            	// 既然分配好了，下一步就将其从freelist中删除
            	list_del(le);
            	le = len;
            }
            if (p->property > n) {
c010378e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103791:	8b 40 08             	mov    0x8(%eax),%eax
c0103794:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103797:	76 12                	jbe    c01037ab <default_alloc_pages+0x116>
				// p指针移动到顶部（这里好象是反着的，其实到了头页）
				// 修改头页的标志位，可参考高书8.3.2
				//struct Page *p = le2page(le, page_link);
				le2page(le, page_link)->property = p->property - n;
c0103799:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010379c:	8d 50 f4             	lea    -0xc(%eax),%edx
c010379f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037a2:	8b 40 08             	mov    0x8(%eax),%eax
c01037a5:	2b 45 08             	sub    0x8(%ebp),%eax
c01037a8:	89 42 08             	mov    %eax,0x8(%edx)
			}
            // 修改头页的标志位
            ClearPageProperty(p);
c01037ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037ae:	83 c0 04             	add    $0x4,%eax
c01037b1:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01037b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01037bb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01037be:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01037c1:	0f b3 10             	btr    %edx,(%eax)
            SetPageReserved(p);
c01037c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037c7:	83 c0 04             	add    $0x4,%eax
c01037ca:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c01037d1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01037d4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01037d7:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01037da:	0f ab 10             	bts    %edx,(%eax)
            nr_free -= n;
c01037dd:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01037e2:	2b 45 08             	sub    0x8(%ebp),%eax
c01037e5:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
            return p;
c01037ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037ed:	eb 21                	jmp    c0103810 <default_alloc_pages+0x17b>
c01037ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037f2:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01037f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01037f8:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }

    list_entry_t *len;			// 跟以前的p和q双指针差不多，le相当于前指针，len后指针
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01037fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01037fe:	81 7d f4 b8 ef 19 c0 	cmpl   $0xc019efb8,-0xc(%ebp)
c0103805:	0f 85 da fe ff ff    	jne    c01036e5 <default_alloc_pages+0x50>
            SetPageReserved(p);
            nr_free -= n;
            return p;
        }
    }
    return NULL;
c010380b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103810:	c9                   	leave  
c0103811:	c3                   	ret    

c0103812 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103812:	55                   	push   %ebp
c0103813:	89 e5                	mov    %esp,%ebp
c0103815:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0103818:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010381c:	75 24                	jne    c0103842 <default_free_pages+0x30>
c010381e:	c7 44 24 0c d0 c5 10 	movl   $0xc010c5d0,0xc(%esp)
c0103825:	c0 
c0103826:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c010382d:	c0 
c010382e:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
c0103835:	00 
c0103836:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c010383d:	e8 93 d5 ff ff       	call   c0100dd5 <__panic>
    // 断言是被内核保留页
    // 这里我不明白为什么申请和释放都标记为“内核保留”？？？
    assert(PageReserved(base));
c0103842:	8b 45 08             	mov    0x8(%ebp),%eax
c0103845:	83 c0 04             	add    $0x4,%eax
c0103848:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010384f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103852:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103855:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103858:	0f a3 10             	bt     %edx,(%eax)
c010385b:	19 c0                	sbb    %eax,%eax
c010385d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0103860:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103864:	0f 95 c0             	setne  %al
c0103867:	0f b6 c0             	movzbl %al,%eax
c010386a:	85 c0                	test   %eax,%eax
c010386c:	75 24                	jne    c0103892 <default_free_pages+0x80>
c010386e:	c7 44 24 0c 11 c6 10 	movl   $0xc010c611,0xc(%esp)
c0103875:	c0 
c0103876:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c010387d:	c0 
c010387e:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c0103885:	00 
c0103886:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c010388d:	e8 43 d5 ff ff       	call   c0100dd5 <__panic>
    struct Page *p;
    list_entry_t *le = &free_list;
c0103892:	c7 45 f0 b8 ef 19 c0 	movl   $0xc019efb8,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103899:	eb 13                	jmp    c01038ae <default_free_pages+0x9c>
    	p = le2page(le, page_link);
c010389b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010389e:	83 e8 0c             	sub    $0xc,%eax
c01038a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (p>base) {
c01038a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038a7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01038aa:	76 02                	jbe    c01038ae <default_free_pages+0x9c>
			break;
c01038ac:	eb 18                	jmp    c01038c6 <default_free_pages+0xb4>
c01038ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01038b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038b7:	8b 40 04             	mov    0x4(%eax),%eax
    // 断言是被内核保留页
    // 这里我不明白为什么申请和释放都标记为“内核保留”？？？
    assert(PageReserved(base));
    struct Page *p;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01038ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038bd:	81 7d f0 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x10(%ebp)
c01038c4:	75 d5                	jne    c010389b <default_free_pages+0x89>
    	p = le2page(le, page_link);
		if (p>base) {
			break;
		}
    }
    for (p=base; p < base + n; p ++) {
c01038c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01038c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01038cc:	eb 4b                	jmp    c0103919 <default_free_pages+0x107>
    	// 因为被释放了，所以重新加回到freelist中
    	list_add_before(le, &(p->page_link));
c01038ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038d1:	8d 50 0c             	lea    0xc(%eax),%edx
c01038d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01038da:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01038dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01038e0:	8b 00                	mov    (%eax),%eax
c01038e2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01038e5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01038e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01038eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01038ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01038f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01038f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01038f7:	89 10                	mov    %edx,(%eax)
c01038f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01038fc:	8b 10                	mov    (%eax),%edx
c01038fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103901:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103904:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103907:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010390a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010390d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103910:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103913:	89 10                	mov    %edx,(%eax)
    	p = le2page(le, page_link);
		if (p>base) {
			break;
		}
    }
    for (p=base; p < base + n; p ++) {
c0103915:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103919:	8b 45 0c             	mov    0xc(%ebp),%eax
c010391c:	c1 e0 05             	shl    $0x5,%eax
c010391f:	89 c2                	mov    %eax,%edx
c0103921:	8b 45 08             	mov    0x8(%ebp),%eax
c0103924:	01 d0                	add    %edx,%eax
c0103926:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103929:	77 a3                	ja     c01038ce <default_free_pages+0xbc>
    	list_add_before(le, &(p->page_link));
    	// 每一页的标志位不用改了，改下头页就行了
    }

    // 下面这几句话是有顺序的？？？
    base->flags = 0;
c010392b:	8b 45 08             	mov    0x8(%ebp),%eax
c010392e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0103935:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010393c:	00 
c010393d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103940:	89 04 24             	mov    %eax,(%esp)
c0103943:	e8 c9 fb ff ff       	call   c0103511 <set_page_ref>
    // 声明是头页
    SetPageProperty(base);
c0103948:	8b 45 08             	mov    0x8(%ebp),%eax
c010394b:	83 c0 04             	add    $0x4,%eax
c010394e:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0103955:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103958:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010395b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010395e:	0f ab 10             	bts    %edx,(%eax)
    // 记录空闲页的数目n
    base->property = n;
c0103961:	8b 45 08             	mov    0x8(%ebp),%eax
c0103964:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103967:	89 50 08             	mov    %edx,0x8(%eax)



    // 向高位合并
    p = le2page(le, page_link);
c010396a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010396d:	83 e8 0c             	sub    $0xc,%eax
c0103970:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // p在高地址，base在低地址
    if (p == base + n) {
c0103973:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103976:	c1 e0 05             	shl    $0x5,%eax
c0103979:	89 c2                	mov    %eax,%edx
c010397b:	8b 45 08             	mov    0x8(%ebp),%eax
c010397e:	01 d0                	add    %edx,%eax
c0103980:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103983:	75 1e                	jne    c01039a3 <default_free_pages+0x191>
    	// 下面的base的property改下
    	base->property = base->property + p->property;
c0103985:	8b 45 08             	mov    0x8(%ebp),%eax
c0103988:	8b 50 08             	mov    0x8(%eax),%edx
c010398b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010398e:	8b 40 08             	mov    0x8(%eax),%eax
c0103991:	01 c2                	add    %eax,%edx
c0103993:	8b 45 08             	mov    0x8(%ebp),%eax
c0103996:	89 50 08             	mov    %edx,0x8(%eax)
    	// 中间那层打掉了，参考高书图8-5
    	p->property = 0;
c0103999:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010399c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }

    // 向低位合并，参考高书图8-6
    // 现在是在空闲结点（高书中间下面的那个），指针先往前移一个结点，就是高书图8-6(a)最中间的结点（p指向的那个）
    le = list_prev(&base->page_link);
c01039a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01039a6:	83 c0 0c             	add    $0xc,%eax
c01039a9:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01039ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01039af:	8b 00                	mov    (%eax),%eax
c01039b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(le, page_link);
c01039b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039b7:	83 e8 0c             	sub    $0xc,%eax
c01039ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // p指向中间上面结点的头页，base指向中间下面的结点的头页
    if (le != &free_list && p == base - 1) {
c01039bd:	81 7d f0 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x10(%ebp)
c01039c4:	74 57                	je     c0103a1d <default_free_pages+0x20b>
c01039c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01039c9:	83 e8 20             	sub    $0x20,%eax
c01039cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01039cf:	75 4c                	jne    c0103a1d <default_free_pages+0x20b>
    	// 直到找到右边的空闲页
    	while (le != &free_list) {
c01039d1:	eb 41                	jmp    c0103a14 <default_free_pages+0x202>
    		// 中间上面的结点非空
    		if (p->property > 0) {
c01039d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039d6:	8b 40 08             	mov    0x8(%eax),%eax
c01039d9:	85 c0                	test   %eax,%eax
c01039db:	74 20                	je     c01039fd <default_free_pages+0x1eb>
    			p->property = base->property + p->property;
c01039dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01039e0:	8b 50 08             	mov    0x8(%eax),%edx
c01039e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039e6:	8b 40 08             	mov    0x8(%eax),%eax
c01039e9:	01 c2                	add    %eax,%edx
c01039eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039ee:	89 50 08             	mov    %edx,0x8(%eax)
    			base->property = 0;
c01039f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01039f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    			break;
c01039fb:	eb 20                	jmp    c0103a1d <default_free_pages+0x20b>
c01039fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a00:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103a03:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103a06:	8b 00                	mov    (%eax),%eax
    		}
    		// 那没找到右边空间页，就往前走
    		le = list_prev(le);
c0103a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    		p = le2page(le, page_link);
c0103a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a0e:	83 e8 0c             	sub    $0xc,%eax
c0103a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    le = list_prev(&base->page_link);
    p = le2page(le, page_link);
    // p指向中间上面结点的头页，base指向中间下面的结点的头页
    if (le != &free_list && p == base - 1) {
    	// 直到找到右边的空闲页
    	while (le != &free_list) {
c0103a14:	81 7d f0 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x10(%ebp)
c0103a1b:	75 b6                	jne    c01039d3 <default_free_pages+0x1c1>
    		le = list_prev(le);
    		p = le2page(le, page_link);

    	}
    }
    nr_free += n;
c0103a1d:	8b 15 c0 ef 19 c0    	mov    0xc019efc0,%edx
c0103a23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103a26:	01 d0                	add    %edx,%eax
c0103a28:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
}
c0103a2d:	c9                   	leave  
c0103a2e:	c3                   	ret    

c0103a2f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103a2f:	55                   	push   %ebp
c0103a30:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103a32:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
}
c0103a37:	5d                   	pop    %ebp
c0103a38:	c3                   	ret    

c0103a39 <basic_check>:

static void
basic_check(void) {
c0103a39:	55                   	push   %ebp
c0103a3a:	89 e5                	mov    %esp,%ebp
c0103a3c:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103a3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103a52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a59:	e8 dc 15 00 00       	call   c010503a <alloc_pages>
c0103a5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a61:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103a65:	75 24                	jne    c0103a8b <basic_check+0x52>
c0103a67:	c7 44 24 0c 24 c6 10 	movl   $0xc010c624,0xc(%esp)
c0103a6e:	c0 
c0103a6f:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103a76:	c0 
c0103a77:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0103a7e:	00 
c0103a7f:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103a86:	e8 4a d3 ff ff       	call   c0100dd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103a8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a92:	e8 a3 15 00 00       	call   c010503a <alloc_pages>
c0103a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a9e:	75 24                	jne    c0103ac4 <basic_check+0x8b>
c0103aa0:	c7 44 24 0c 40 c6 10 	movl   $0xc010c640,0xc(%esp)
c0103aa7:	c0 
c0103aa8:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103aaf:	c0 
c0103ab0:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0103ab7:	00 
c0103ab8:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103abf:	e8 11 d3 ff ff       	call   c0100dd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103ac4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103acb:	e8 6a 15 00 00       	call   c010503a <alloc_pages>
c0103ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103ad7:	75 24                	jne    c0103afd <basic_check+0xc4>
c0103ad9:	c7 44 24 0c 5c c6 10 	movl   $0xc010c65c,0xc(%esp)
c0103ae0:	c0 
c0103ae1:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103ae8:	c0 
c0103ae9:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103af0:	00 
c0103af1:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103af8:	e8 d8 d2 ff ff       	call   c0100dd5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b00:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103b03:	74 10                	je     c0103b15 <basic_check+0xdc>
c0103b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103b0b:	74 08                	je     c0103b15 <basic_check+0xdc>
c0103b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b10:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103b13:	75 24                	jne    c0103b39 <basic_check+0x100>
c0103b15:	c7 44 24 0c 78 c6 10 	movl   $0xc010c678,0xc(%esp)
c0103b1c:	c0 
c0103b1d:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103b24:	c0 
c0103b25:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103b2c:	00 
c0103b2d:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103b34:	e8 9c d2 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b3c:	89 04 24             	mov    %eax,(%esp)
c0103b3f:	e8 c3 f9 ff ff       	call   c0103507 <page_ref>
c0103b44:	85 c0                	test   %eax,%eax
c0103b46:	75 1e                	jne    c0103b66 <basic_check+0x12d>
c0103b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b4b:	89 04 24             	mov    %eax,(%esp)
c0103b4e:	e8 b4 f9 ff ff       	call   c0103507 <page_ref>
c0103b53:	85 c0                	test   %eax,%eax
c0103b55:	75 0f                	jne    c0103b66 <basic_check+0x12d>
c0103b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b5a:	89 04 24             	mov    %eax,(%esp)
c0103b5d:	e8 a5 f9 ff ff       	call   c0103507 <page_ref>
c0103b62:	85 c0                	test   %eax,%eax
c0103b64:	74 24                	je     c0103b8a <basic_check+0x151>
c0103b66:	c7 44 24 0c 9c c6 10 	movl   $0xc010c69c,0xc(%esp)
c0103b6d:	c0 
c0103b6e:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103b75:	c0 
c0103b76:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0103b7d:	00 
c0103b7e:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103b85:	e8 4b d2 ff ff       	call   c0100dd5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b8d:	89 04 24             	mov    %eax,(%esp)
c0103b90:	e8 5c f9 ff ff       	call   c01034f1 <page2pa>
c0103b95:	8b 15 e0 ce 19 c0    	mov    0xc019cee0,%edx
c0103b9b:	c1 e2 0c             	shl    $0xc,%edx
c0103b9e:	39 d0                	cmp    %edx,%eax
c0103ba0:	72 24                	jb     c0103bc6 <basic_check+0x18d>
c0103ba2:	c7 44 24 0c d8 c6 10 	movl   $0xc010c6d8,0xc(%esp)
c0103ba9:	c0 
c0103baa:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103bb1:	c0 
c0103bb2:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0103bb9:	00 
c0103bba:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103bc1:	e8 0f d2 ff ff       	call   c0100dd5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bc9:	89 04 24             	mov    %eax,(%esp)
c0103bcc:	e8 20 f9 ff ff       	call   c01034f1 <page2pa>
c0103bd1:	8b 15 e0 ce 19 c0    	mov    0xc019cee0,%edx
c0103bd7:	c1 e2 0c             	shl    $0xc,%edx
c0103bda:	39 d0                	cmp    %edx,%eax
c0103bdc:	72 24                	jb     c0103c02 <basic_check+0x1c9>
c0103bde:	c7 44 24 0c f5 c6 10 	movl   $0xc010c6f5,0xc(%esp)
c0103be5:	c0 
c0103be6:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103bed:	c0 
c0103bee:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103bf5:	00 
c0103bf6:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103bfd:	e8 d3 d1 ff ff       	call   c0100dd5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c05:	89 04 24             	mov    %eax,(%esp)
c0103c08:	e8 e4 f8 ff ff       	call   c01034f1 <page2pa>
c0103c0d:	8b 15 e0 ce 19 c0    	mov    0xc019cee0,%edx
c0103c13:	c1 e2 0c             	shl    $0xc,%edx
c0103c16:	39 d0                	cmp    %edx,%eax
c0103c18:	72 24                	jb     c0103c3e <basic_check+0x205>
c0103c1a:	c7 44 24 0c 12 c7 10 	movl   $0xc010c712,0xc(%esp)
c0103c21:	c0 
c0103c22:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103c29:	c0 
c0103c2a:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103c31:	00 
c0103c32:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103c39:	e8 97 d1 ff ff       	call   c0100dd5 <__panic>

    list_entry_t free_list_store = free_list;
c0103c3e:	a1 b8 ef 19 c0       	mov    0xc019efb8,%eax
c0103c43:	8b 15 bc ef 19 c0    	mov    0xc019efbc,%edx
c0103c49:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103c4c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103c4f:	c7 45 e0 b8 ef 19 c0 	movl   $0xc019efb8,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103c56:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c59:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103c5c:	89 50 04             	mov    %edx,0x4(%eax)
c0103c5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c62:	8b 50 04             	mov    0x4(%eax),%edx
c0103c65:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c68:	89 10                	mov    %edx,(%eax)
c0103c6a:	c7 45 dc b8 ef 19 c0 	movl   $0xc019efb8,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103c71:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103c74:	8b 40 04             	mov    0x4(%eax),%eax
c0103c77:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103c7a:	0f 94 c0             	sete   %al
c0103c7d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103c80:	85 c0                	test   %eax,%eax
c0103c82:	75 24                	jne    c0103ca8 <basic_check+0x26f>
c0103c84:	c7 44 24 0c 2f c7 10 	movl   $0xc010c72f,0xc(%esp)
c0103c8b:	c0 
c0103c8c:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103c93:	c0 
c0103c94:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0103c9b:	00 
c0103c9c:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103ca3:	e8 2d d1 ff ff       	call   c0100dd5 <__panic>

    unsigned int nr_free_store = nr_free;
c0103ca8:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0103cad:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103cb0:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c0103cb7:	00 00 00 

    assert(alloc_page() == NULL);
c0103cba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cc1:	e8 74 13 00 00       	call   c010503a <alloc_pages>
c0103cc6:	85 c0                	test   %eax,%eax
c0103cc8:	74 24                	je     c0103cee <basic_check+0x2b5>
c0103cca:	c7 44 24 0c 46 c7 10 	movl   $0xc010c746,0xc(%esp)
c0103cd1:	c0 
c0103cd2:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103cd9:	c0 
c0103cda:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103ce1:	00 
c0103ce2:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103ce9:	e8 e7 d0 ff ff       	call   c0100dd5 <__panic>

    free_page(p0);
c0103cee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103cf5:	00 
c0103cf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cf9:	89 04 24             	mov    %eax,(%esp)
c0103cfc:	e8 a4 13 00 00       	call   c01050a5 <free_pages>
    free_page(p1);
c0103d01:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d08:	00 
c0103d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d0c:	89 04 24             	mov    %eax,(%esp)
c0103d0f:	e8 91 13 00 00       	call   c01050a5 <free_pages>
    free_page(p2);
c0103d14:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d1b:	00 
c0103d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d1f:	89 04 24             	mov    %eax,(%esp)
c0103d22:	e8 7e 13 00 00       	call   c01050a5 <free_pages>
    assert(nr_free == 3);
c0103d27:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0103d2c:	83 f8 03             	cmp    $0x3,%eax
c0103d2f:	74 24                	je     c0103d55 <basic_check+0x31c>
c0103d31:	c7 44 24 0c 5b c7 10 	movl   $0xc010c75b,0xc(%esp)
c0103d38:	c0 
c0103d39:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103d40:	c0 
c0103d41:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103d48:	00 
c0103d49:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103d50:	e8 80 d0 ff ff       	call   c0100dd5 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103d55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d5c:	e8 d9 12 00 00       	call   c010503a <alloc_pages>
c0103d61:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103d68:	75 24                	jne    c0103d8e <basic_check+0x355>
c0103d6a:	c7 44 24 0c 24 c6 10 	movl   $0xc010c624,0xc(%esp)
c0103d71:	c0 
c0103d72:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103d79:	c0 
c0103d7a:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0103d81:	00 
c0103d82:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103d89:	e8 47 d0 ff ff       	call   c0100dd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103d8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d95:	e8 a0 12 00 00       	call   c010503a <alloc_pages>
c0103d9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103da1:	75 24                	jne    c0103dc7 <basic_check+0x38e>
c0103da3:	c7 44 24 0c 40 c6 10 	movl   $0xc010c640,0xc(%esp)
c0103daa:	c0 
c0103dab:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103db2:	c0 
c0103db3:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0103dba:	00 
c0103dbb:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103dc2:	e8 0e d0 ff ff       	call   c0100dd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103dc7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103dce:	e8 67 12 00 00       	call   c010503a <alloc_pages>
c0103dd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103dd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103dda:	75 24                	jne    c0103e00 <basic_check+0x3c7>
c0103ddc:	c7 44 24 0c 5c c6 10 	movl   $0xc010c65c,0xc(%esp)
c0103de3:	c0 
c0103de4:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103deb:	c0 
c0103dec:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0103df3:	00 
c0103df4:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103dfb:	e8 d5 cf ff ff       	call   c0100dd5 <__panic>

    assert(alloc_page() == NULL);
c0103e00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e07:	e8 2e 12 00 00       	call   c010503a <alloc_pages>
c0103e0c:	85 c0                	test   %eax,%eax
c0103e0e:	74 24                	je     c0103e34 <basic_check+0x3fb>
c0103e10:	c7 44 24 0c 46 c7 10 	movl   $0xc010c746,0xc(%esp)
c0103e17:	c0 
c0103e18:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103e1f:	c0 
c0103e20:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103e27:	00 
c0103e28:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103e2f:	e8 a1 cf ff ff       	call   c0100dd5 <__panic>

    free_page(p0);
c0103e34:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103e3b:	00 
c0103e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e3f:	89 04 24             	mov    %eax,(%esp)
c0103e42:	e8 5e 12 00 00       	call   c01050a5 <free_pages>
c0103e47:	c7 45 d8 b8 ef 19 c0 	movl   $0xc019efb8,-0x28(%ebp)
c0103e4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103e51:	8b 40 04             	mov    0x4(%eax),%eax
c0103e54:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103e57:	0f 94 c0             	sete   %al
c0103e5a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103e5d:	85 c0                	test   %eax,%eax
c0103e5f:	74 24                	je     c0103e85 <basic_check+0x44c>
c0103e61:	c7 44 24 0c 68 c7 10 	movl   $0xc010c768,0xc(%esp)
c0103e68:	c0 
c0103e69:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103e70:	c0 
c0103e71:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103e78:	00 
c0103e79:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103e80:	e8 50 cf ff ff       	call   c0100dd5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103e85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e8c:	e8 a9 11 00 00       	call   c010503a <alloc_pages>
c0103e91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103e94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e97:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103e9a:	74 24                	je     c0103ec0 <basic_check+0x487>
c0103e9c:	c7 44 24 0c 80 c7 10 	movl   $0xc010c780,0xc(%esp)
c0103ea3:	c0 
c0103ea4:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103eab:	c0 
c0103eac:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0103eb3:	00 
c0103eb4:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103ebb:	e8 15 cf ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c0103ec0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ec7:	e8 6e 11 00 00       	call   c010503a <alloc_pages>
c0103ecc:	85 c0                	test   %eax,%eax
c0103ece:	74 24                	je     c0103ef4 <basic_check+0x4bb>
c0103ed0:	c7 44 24 0c 46 c7 10 	movl   $0xc010c746,0xc(%esp)
c0103ed7:	c0 
c0103ed8:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103edf:	c0 
c0103ee0:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0103ee7:	00 
c0103ee8:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103eef:	e8 e1 ce ff ff       	call   c0100dd5 <__panic>

    assert(nr_free == 0);
c0103ef4:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0103ef9:	85 c0                	test   %eax,%eax
c0103efb:	74 24                	je     c0103f21 <basic_check+0x4e8>
c0103efd:	c7 44 24 0c 99 c7 10 	movl   $0xc010c799,0xc(%esp)
c0103f04:	c0 
c0103f05:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103f0c:	c0 
c0103f0d:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103f14:	00 
c0103f15:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103f1c:	e8 b4 ce ff ff       	call   c0100dd5 <__panic>
    free_list = free_list_store;
c0103f21:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f24:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f27:	a3 b8 ef 19 c0       	mov    %eax,0xc019efb8
c0103f2c:	89 15 bc ef 19 c0    	mov    %edx,0xc019efbc
    nr_free = nr_free_store;
c0103f32:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f35:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0

    free_page(p);
c0103f3a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f41:	00 
c0103f42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f45:	89 04 24             	mov    %eax,(%esp)
c0103f48:	e8 58 11 00 00       	call   c01050a5 <free_pages>
    free_page(p1);
c0103f4d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f54:	00 
c0103f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f58:	89 04 24             	mov    %eax,(%esp)
c0103f5b:	e8 45 11 00 00       	call   c01050a5 <free_pages>
    free_page(p2);
c0103f60:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f67:	00 
c0103f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f6b:	89 04 24             	mov    %eax,(%esp)
c0103f6e:	e8 32 11 00 00       	call   c01050a5 <free_pages>
}
c0103f73:	c9                   	leave  
c0103f74:	c3                   	ret    

c0103f75 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103f75:	55                   	push   %ebp
c0103f76:	89 e5                	mov    %esp,%ebp
c0103f78:	53                   	push   %ebx
c0103f79:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103f7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103f86:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103f8d:	c7 45 ec b8 ef 19 c0 	movl   $0xc019efb8,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103f94:	eb 6b                	jmp    c0104001 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103f96:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f99:	83 e8 0c             	sub    $0xc,%eax
c0103f9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103fa2:	83 c0 04             	add    $0x4,%eax
c0103fa5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103fac:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103faf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103fb2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103fb5:	0f a3 10             	bt     %edx,(%eax)
c0103fb8:	19 c0                	sbb    %eax,%eax
c0103fba:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103fbd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103fc1:	0f 95 c0             	setne  %al
c0103fc4:	0f b6 c0             	movzbl %al,%eax
c0103fc7:	85 c0                	test   %eax,%eax
c0103fc9:	75 24                	jne    c0103fef <default_check+0x7a>
c0103fcb:	c7 44 24 0c a6 c7 10 	movl   $0xc010c7a6,0xc(%esp)
c0103fd2:	c0 
c0103fd3:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0103fda:	c0 
c0103fdb:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103fe2:	00 
c0103fe3:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0103fea:	e8 e6 cd ff ff       	call   c0100dd5 <__panic>
        count ++, total += p->property;
c0103fef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103ff3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ff6:	8b 50 08             	mov    0x8(%eax),%edx
c0103ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ffc:	01 d0                	add    %edx,%eax
c0103ffe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104001:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104004:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104007:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010400a:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010400d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104010:	81 7d ec b8 ef 19 c0 	cmpl   $0xc019efb8,-0x14(%ebp)
c0104017:	0f 85 79 ff ff ff    	jne    c0103f96 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010401d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0104020:	e8 b2 10 00 00       	call   c01050d7 <nr_free_pages>
c0104025:	39 c3                	cmp    %eax,%ebx
c0104027:	74 24                	je     c010404d <default_check+0xd8>
c0104029:	c7 44 24 0c b6 c7 10 	movl   $0xc010c7b6,0xc(%esp)
c0104030:	c0 
c0104031:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0104038:	c0 
c0104039:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0104040:	00 
c0104041:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0104048:	e8 88 cd ff ff       	call   c0100dd5 <__panic>

    basic_check();
c010404d:	e8 e7 f9 ff ff       	call   c0103a39 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104052:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104059:	e8 dc 0f 00 00       	call   c010503a <alloc_pages>
c010405e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0104061:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104065:	75 24                	jne    c010408b <default_check+0x116>
c0104067:	c7 44 24 0c cf c7 10 	movl   $0xc010c7cf,0xc(%esp)
c010406e:	c0 
c010406f:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0104076:	c0 
c0104077:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010407e:	00 
c010407f:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0104086:	e8 4a cd ff ff       	call   c0100dd5 <__panic>
    assert(!PageProperty(p0));
c010408b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010408e:	83 c0 04             	add    $0x4,%eax
c0104091:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104098:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010409b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010409e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01040a1:	0f a3 10             	bt     %edx,(%eax)
c01040a4:	19 c0                	sbb    %eax,%eax
c01040a6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01040a9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01040ad:	0f 95 c0             	setne  %al
c01040b0:	0f b6 c0             	movzbl %al,%eax
c01040b3:	85 c0                	test   %eax,%eax
c01040b5:	74 24                	je     c01040db <default_check+0x166>
c01040b7:	c7 44 24 0c da c7 10 	movl   $0xc010c7da,0xc(%esp)
c01040be:	c0 
c01040bf:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c01040c6:	c0 
c01040c7:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01040ce:	00 
c01040cf:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c01040d6:	e8 fa cc ff ff       	call   c0100dd5 <__panic>

    list_entry_t free_list_store = free_list;
c01040db:	a1 b8 ef 19 c0       	mov    0xc019efb8,%eax
c01040e0:	8b 15 bc ef 19 c0    	mov    0xc019efbc,%edx
c01040e6:	89 45 80             	mov    %eax,-0x80(%ebp)
c01040e9:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01040ec:	c7 45 b4 b8 ef 19 c0 	movl   $0xc019efb8,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01040f3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01040f6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01040f9:	89 50 04             	mov    %edx,0x4(%eax)
c01040fc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01040ff:	8b 50 04             	mov    0x4(%eax),%edx
c0104102:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104105:	89 10                	mov    %edx,(%eax)
c0104107:	c7 45 b0 b8 ef 19 c0 	movl   $0xc019efb8,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010410e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104111:	8b 40 04             	mov    0x4(%eax),%eax
c0104114:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0104117:	0f 94 c0             	sete   %al
c010411a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010411d:	85 c0                	test   %eax,%eax
c010411f:	75 24                	jne    c0104145 <default_check+0x1d0>
c0104121:	c7 44 24 0c 2f c7 10 	movl   $0xc010c72f,0xc(%esp)
c0104128:	c0 
c0104129:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0104130:	c0 
c0104131:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0104138:	00 
c0104139:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0104140:	e8 90 cc ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c0104145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010414c:	e8 e9 0e 00 00       	call   c010503a <alloc_pages>
c0104151:	85 c0                	test   %eax,%eax
c0104153:	74 24                	je     c0104179 <default_check+0x204>
c0104155:	c7 44 24 0c 46 c7 10 	movl   $0xc010c746,0xc(%esp)
c010415c:	c0 
c010415d:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0104164:	c0 
c0104165:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c010416c:	00 
c010416d:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0104174:	e8 5c cc ff ff       	call   c0100dd5 <__panic>

    unsigned int nr_free_store = nr_free;
c0104179:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c010417e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0104181:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c0104188:	00 00 00 

    free_pages(p0 + 2, 3);
c010418b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010418e:	83 c0 40             	add    $0x40,%eax
c0104191:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104198:	00 
c0104199:	89 04 24             	mov    %eax,(%esp)
c010419c:	e8 04 0f 00 00       	call   c01050a5 <free_pages>
    assert(alloc_pages(4) == NULL);
c01041a1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01041a8:	e8 8d 0e 00 00       	call   c010503a <alloc_pages>
c01041ad:	85 c0                	test   %eax,%eax
c01041af:	74 24                	je     c01041d5 <default_check+0x260>
c01041b1:	c7 44 24 0c ec c7 10 	movl   $0xc010c7ec,0xc(%esp)
c01041b8:	c0 
c01041b9:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c01041c0:	c0 
c01041c1:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c01041c8:	00 
c01041c9:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c01041d0:	e8 00 cc ff ff       	call   c0100dd5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01041d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041d8:	83 c0 40             	add    $0x40,%eax
c01041db:	83 c0 04             	add    $0x4,%eax
c01041de:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01041e5:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01041e8:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01041eb:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01041ee:	0f a3 10             	bt     %edx,(%eax)
c01041f1:	19 c0                	sbb    %eax,%eax
c01041f3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01041f6:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01041fa:	0f 95 c0             	setne  %al
c01041fd:	0f b6 c0             	movzbl %al,%eax
c0104200:	85 c0                	test   %eax,%eax
c0104202:	74 0e                	je     c0104212 <default_check+0x29d>
c0104204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104207:	83 c0 40             	add    $0x40,%eax
c010420a:	8b 40 08             	mov    0x8(%eax),%eax
c010420d:	83 f8 03             	cmp    $0x3,%eax
c0104210:	74 24                	je     c0104236 <default_check+0x2c1>
c0104212:	c7 44 24 0c 04 c8 10 	movl   $0xc010c804,0xc(%esp)
c0104219:	c0 
c010421a:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0104221:	c0 
c0104222:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104229:	00 
c010422a:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0104231:	e8 9f cb ff ff       	call   c0100dd5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104236:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010423d:	e8 f8 0d 00 00       	call   c010503a <alloc_pages>
c0104242:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104245:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104249:	75 24                	jne    c010426f <default_check+0x2fa>
c010424b:	c7 44 24 0c 30 c8 10 	movl   $0xc010c830,0xc(%esp)
c0104252:	c0 
c0104253:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c010425a:	c0 
c010425b:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0104262:	00 
c0104263:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c010426a:	e8 66 cb ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c010426f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104276:	e8 bf 0d 00 00       	call   c010503a <alloc_pages>
c010427b:	85 c0                	test   %eax,%eax
c010427d:	74 24                	je     c01042a3 <default_check+0x32e>
c010427f:	c7 44 24 0c 46 c7 10 	movl   $0xc010c746,0xc(%esp)
c0104286:	c0 
c0104287:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c010428e:	c0 
c010428f:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0104296:	00 
c0104297:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c010429e:	e8 32 cb ff ff       	call   c0100dd5 <__panic>
    assert(p0 + 2 == p1);
c01042a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042a6:	83 c0 40             	add    $0x40,%eax
c01042a9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01042ac:	74 24                	je     c01042d2 <default_check+0x35d>
c01042ae:	c7 44 24 0c 4e c8 10 	movl   $0xc010c84e,0xc(%esp)
c01042b5:	c0 
c01042b6:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c01042bd:	c0 
c01042be:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c01042c5:	00 
c01042c6:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c01042cd:	e8 03 cb ff ff       	call   c0100dd5 <__panic>

    p2 = p0 + 1;
c01042d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042d5:	83 c0 20             	add    $0x20,%eax
c01042d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01042db:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01042e2:	00 
c01042e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042e6:	89 04 24             	mov    %eax,(%esp)
c01042e9:	e8 b7 0d 00 00       	call   c01050a5 <free_pages>
    free_pages(p1, 3);
c01042ee:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01042f5:	00 
c01042f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042f9:	89 04 24             	mov    %eax,(%esp)
c01042fc:	e8 a4 0d 00 00       	call   c01050a5 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104301:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104304:	83 c0 04             	add    $0x4,%eax
c0104307:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010430e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104311:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104314:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104317:	0f a3 10             	bt     %edx,(%eax)
c010431a:	19 c0                	sbb    %eax,%eax
c010431c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010431f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104323:	0f 95 c0             	setne  %al
c0104326:	0f b6 c0             	movzbl %al,%eax
c0104329:	85 c0                	test   %eax,%eax
c010432b:	74 0b                	je     c0104338 <default_check+0x3c3>
c010432d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104330:	8b 40 08             	mov    0x8(%eax),%eax
c0104333:	83 f8 01             	cmp    $0x1,%eax
c0104336:	74 24                	je     c010435c <default_check+0x3e7>
c0104338:	c7 44 24 0c 5c c8 10 	movl   $0xc010c85c,0xc(%esp)
c010433f:	c0 
c0104340:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0104347:	c0 
c0104348:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c010434f:	00 
c0104350:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0104357:	e8 79 ca ff ff       	call   c0100dd5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010435c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010435f:	83 c0 04             	add    $0x4,%eax
c0104362:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104369:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010436c:	8b 45 90             	mov    -0x70(%ebp),%eax
c010436f:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104372:	0f a3 10             	bt     %edx,(%eax)
c0104375:	19 c0                	sbb    %eax,%eax
c0104377:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010437a:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010437e:	0f 95 c0             	setne  %al
c0104381:	0f b6 c0             	movzbl %al,%eax
c0104384:	85 c0                	test   %eax,%eax
c0104386:	74 0b                	je     c0104393 <default_check+0x41e>
c0104388:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010438b:	8b 40 08             	mov    0x8(%eax),%eax
c010438e:	83 f8 03             	cmp    $0x3,%eax
c0104391:	74 24                	je     c01043b7 <default_check+0x442>
c0104393:	c7 44 24 0c 84 c8 10 	movl   $0xc010c884,0xc(%esp)
c010439a:	c0 
c010439b:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c01043a2:	c0 
c01043a3:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01043aa:	00 
c01043ab:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c01043b2:	e8 1e ca ff ff       	call   c0100dd5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01043b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01043be:	e8 77 0c 00 00       	call   c010503a <alloc_pages>
c01043c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043c9:	83 e8 20             	sub    $0x20,%eax
c01043cc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01043cf:	74 24                	je     c01043f5 <default_check+0x480>
c01043d1:	c7 44 24 0c aa c8 10 	movl   $0xc010c8aa,0xc(%esp)
c01043d8:	c0 
c01043d9:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c01043e0:	c0 
c01043e1:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c01043e8:	00 
c01043e9:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c01043f0:	e8 e0 c9 ff ff       	call   c0100dd5 <__panic>
    free_page(p0);
c01043f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043fc:	00 
c01043fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104400:	89 04 24             	mov    %eax,(%esp)
c0104403:	e8 9d 0c 00 00       	call   c01050a5 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104408:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010440f:	e8 26 0c 00 00       	call   c010503a <alloc_pages>
c0104414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104417:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010441a:	83 c0 20             	add    $0x20,%eax
c010441d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104420:	74 24                	je     c0104446 <default_check+0x4d1>
c0104422:	c7 44 24 0c c8 c8 10 	movl   $0xc010c8c8,0xc(%esp)
c0104429:	c0 
c010442a:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0104431:	c0 
c0104432:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0104439:	00 
c010443a:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0104441:	e8 8f c9 ff ff       	call   c0100dd5 <__panic>

    free_pages(p0, 2);
c0104446:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010444d:	00 
c010444e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104451:	89 04 24             	mov    %eax,(%esp)
c0104454:	e8 4c 0c 00 00       	call   c01050a5 <free_pages>
    free_page(p2);
c0104459:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104460:	00 
c0104461:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104464:	89 04 24             	mov    %eax,(%esp)
c0104467:	e8 39 0c 00 00       	call   c01050a5 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010446c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104473:	e8 c2 0b 00 00       	call   c010503a <alloc_pages>
c0104478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010447b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010447f:	75 24                	jne    c01044a5 <default_check+0x530>
c0104481:	c7 44 24 0c e8 c8 10 	movl   $0xc010c8e8,0xc(%esp)
c0104488:	c0 
c0104489:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0104490:	c0 
c0104491:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104498:	00 
c0104499:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c01044a0:	e8 30 c9 ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c01044a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044ac:	e8 89 0b 00 00       	call   c010503a <alloc_pages>
c01044b1:	85 c0                	test   %eax,%eax
c01044b3:	74 24                	je     c01044d9 <default_check+0x564>
c01044b5:	c7 44 24 0c 46 c7 10 	movl   $0xc010c746,0xc(%esp)
c01044bc:	c0 
c01044bd:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c01044c4:	c0 
c01044c5:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01044cc:	00 
c01044cd:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c01044d4:	e8 fc c8 ff ff       	call   c0100dd5 <__panic>

    assert(nr_free == 0);
c01044d9:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01044de:	85 c0                	test   %eax,%eax
c01044e0:	74 24                	je     c0104506 <default_check+0x591>
c01044e2:	c7 44 24 0c 99 c7 10 	movl   $0xc010c799,0xc(%esp)
c01044e9:	c0 
c01044ea:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c01044f1:	c0 
c01044f2:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c01044f9:	00 
c01044fa:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0104501:	e8 cf c8 ff ff       	call   c0100dd5 <__panic>
    nr_free = nr_free_store;
c0104506:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104509:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0

    free_list = free_list_store;
c010450e:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104511:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104514:	a3 b8 ef 19 c0       	mov    %eax,0xc019efb8
c0104519:	89 15 bc ef 19 c0    	mov    %edx,0xc019efbc
    free_pages(p0, 5);
c010451f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104526:	00 
c0104527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010452a:	89 04 24             	mov    %eax,(%esp)
c010452d:	e8 73 0b 00 00       	call   c01050a5 <free_pages>

    le = &free_list;
c0104532:	c7 45 ec b8 ef 19 c0 	movl   $0xc019efb8,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104539:	eb 1d                	jmp    c0104558 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010453b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010453e:	83 e8 0c             	sub    $0xc,%eax
c0104541:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104544:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104548:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010454b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010454e:	8b 40 08             	mov    0x8(%eax),%eax
c0104551:	29 c2                	sub    %eax,%edx
c0104553:	89 d0                	mov    %edx,%eax
c0104555:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104558:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010455b:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010455e:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104561:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104564:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104567:	81 7d ec b8 ef 19 c0 	cmpl   $0xc019efb8,-0x14(%ebp)
c010456e:	75 cb                	jne    c010453b <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104574:	74 24                	je     c010459a <default_check+0x625>
c0104576:	c7 44 24 0c 06 c9 10 	movl   $0xc010c906,0xc(%esp)
c010457d:	c0 
c010457e:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c0104585:	c0 
c0104586:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c010458d:	00 
c010458e:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c0104595:	e8 3b c8 ff ff       	call   c0100dd5 <__panic>
    assert(total == 0);
c010459a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010459e:	74 24                	je     c01045c4 <default_check+0x64f>
c01045a0:	c7 44 24 0c 11 c9 10 	movl   $0xc010c911,0xc(%esp)
c01045a7:	c0 
c01045a8:	c7 44 24 08 d6 c5 10 	movl   $0xc010c5d6,0x8(%esp)
c01045af:	c0 
c01045b0:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c01045b7:	00 
c01045b8:	c7 04 24 eb c5 10 c0 	movl   $0xc010c5eb,(%esp)
c01045bf:	e8 11 c8 ff ff       	call   c0100dd5 <__panic>
}
c01045c4:	81 c4 94 00 00 00    	add    $0x94,%esp
c01045ca:	5b                   	pop    %ebx
c01045cb:	5d                   	pop    %ebp
c01045cc:	c3                   	ret    

c01045cd <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c01045cd:	55                   	push   %ebp
c01045ce:	89 e5                	mov    %esp,%ebp
c01045d0:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01045d3:	9c                   	pushf  
c01045d4:	58                   	pop    %eax
c01045d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01045d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01045db:	25 00 02 00 00       	and    $0x200,%eax
c01045e0:	85 c0                	test   %eax,%eax
c01045e2:	74 0c                	je     c01045f0 <__intr_save+0x23>
        intr_disable();
c01045e4:	e8 44 da ff ff       	call   c010202d <intr_disable>
        return 1;
c01045e9:	b8 01 00 00 00       	mov    $0x1,%eax
c01045ee:	eb 05                	jmp    c01045f5 <__intr_save+0x28>
    }
    return 0;
c01045f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045f5:	c9                   	leave  
c01045f6:	c3                   	ret    

c01045f7 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01045f7:	55                   	push   %ebp
c01045f8:	89 e5                	mov    %esp,%ebp
c01045fa:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01045fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104601:	74 05                	je     c0104608 <__intr_restore+0x11>
        intr_enable();
c0104603:	e8 1f da ff ff       	call   c0102027 <intr_enable>
    }
}
c0104608:	c9                   	leave  
c0104609:	c3                   	ret    

c010460a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010460a:	55                   	push   %ebp
c010460b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010460d:	8b 55 08             	mov    0x8(%ebp),%edx
c0104610:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0104615:	29 c2                	sub    %eax,%edx
c0104617:	89 d0                	mov    %edx,%eax
c0104619:	c1 f8 05             	sar    $0x5,%eax
}
c010461c:	5d                   	pop    %ebp
c010461d:	c3                   	ret    

c010461e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010461e:	55                   	push   %ebp
c010461f:	89 e5                	mov    %esp,%ebp
c0104621:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104624:	8b 45 08             	mov    0x8(%ebp),%eax
c0104627:	89 04 24             	mov    %eax,(%esp)
c010462a:	e8 db ff ff ff       	call   c010460a <page2ppn>
c010462f:	c1 e0 0c             	shl    $0xc,%eax
}
c0104632:	c9                   	leave  
c0104633:	c3                   	ret    

c0104634 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104634:	55                   	push   %ebp
c0104635:	89 e5                	mov    %esp,%ebp
c0104637:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010463a:	8b 45 08             	mov    0x8(%ebp),%eax
c010463d:	c1 e8 0c             	shr    $0xc,%eax
c0104640:	89 c2                	mov    %eax,%edx
c0104642:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0104647:	39 c2                	cmp    %eax,%edx
c0104649:	72 1c                	jb     c0104667 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010464b:	c7 44 24 08 4c c9 10 	movl   $0xc010c94c,0x8(%esp)
c0104652:	c0 
c0104653:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c010465a:	00 
c010465b:	c7 04 24 6b c9 10 c0 	movl   $0xc010c96b,(%esp)
c0104662:	e8 6e c7 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0104667:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c010466c:	8b 55 08             	mov    0x8(%ebp),%edx
c010466f:	c1 ea 0c             	shr    $0xc,%edx
c0104672:	c1 e2 05             	shl    $0x5,%edx
c0104675:	01 d0                	add    %edx,%eax
}
c0104677:	c9                   	leave  
c0104678:	c3                   	ret    

c0104679 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104679:	55                   	push   %ebp
c010467a:	89 e5                	mov    %esp,%ebp
c010467c:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010467f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104682:	89 04 24             	mov    %eax,(%esp)
c0104685:	e8 94 ff ff ff       	call   c010461e <page2pa>
c010468a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010468d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104690:	c1 e8 0c             	shr    $0xc,%eax
c0104693:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104696:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c010469b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010469e:	72 23                	jb     c01046c3 <page2kva+0x4a>
c01046a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046a7:	c7 44 24 08 7c c9 10 	movl   $0xc010c97c,0x8(%esp)
c01046ae:	c0 
c01046af:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01046b6:	00 
c01046b7:	c7 04 24 6b c9 10 c0 	movl   $0xc010c96b,(%esp)
c01046be:	e8 12 c7 ff ff       	call   c0100dd5 <__panic>
c01046c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c6:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01046cb:	c9                   	leave  
c01046cc:	c3                   	ret    

c01046cd <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01046cd:	55                   	push   %ebp
c01046ce:	89 e5                	mov    %esp,%ebp
c01046d0:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01046d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01046d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046d9:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01046e0:	77 23                	ja     c0104705 <kva2page+0x38>
c01046e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046e9:	c7 44 24 08 a0 c9 10 	movl   $0xc010c9a0,0x8(%esp)
c01046f0:	c0 
c01046f1:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c01046f8:	00 
c01046f9:	c7 04 24 6b c9 10 c0 	movl   $0xc010c96b,(%esp)
c0104700:	e8 d0 c6 ff ff       	call   c0100dd5 <__panic>
c0104705:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104708:	05 00 00 00 40       	add    $0x40000000,%eax
c010470d:	89 04 24             	mov    %eax,(%esp)
c0104710:	e8 1f ff ff ff       	call   c0104634 <pa2page>
}
c0104715:	c9                   	leave  
c0104716:	c3                   	ret    

c0104717 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c0104717:	55                   	push   %ebp
c0104718:	89 e5                	mov    %esp,%ebp
c010471a:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c010471d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104720:	ba 01 00 00 00       	mov    $0x1,%edx
c0104725:	89 c1                	mov    %eax,%ecx
c0104727:	d3 e2                	shl    %cl,%edx
c0104729:	89 d0                	mov    %edx,%eax
c010472b:	89 04 24             	mov    %eax,(%esp)
c010472e:	e8 07 09 00 00       	call   c010503a <alloc_pages>
c0104733:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104736:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010473a:	75 07                	jne    c0104743 <__slob_get_free_pages+0x2c>
    return NULL;
c010473c:	b8 00 00 00 00       	mov    $0x0,%eax
c0104741:	eb 0b                	jmp    c010474e <__slob_get_free_pages+0x37>
  return page2kva(page);
c0104743:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104746:	89 04 24             	mov    %eax,(%esp)
c0104749:	e8 2b ff ff ff       	call   c0104679 <page2kva>
}
c010474e:	c9                   	leave  
c010474f:	c3                   	ret    

c0104750 <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c0104750:	55                   	push   %ebp
c0104751:	89 e5                	mov    %esp,%ebp
c0104753:	53                   	push   %ebx
c0104754:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c0104757:	8b 45 0c             	mov    0xc(%ebp),%eax
c010475a:	ba 01 00 00 00       	mov    $0x1,%edx
c010475f:	89 c1                	mov    %eax,%ecx
c0104761:	d3 e2                	shl    %cl,%edx
c0104763:	89 d0                	mov    %edx,%eax
c0104765:	89 c3                	mov    %eax,%ebx
c0104767:	8b 45 08             	mov    0x8(%ebp),%eax
c010476a:	89 04 24             	mov    %eax,(%esp)
c010476d:	e8 5b ff ff ff       	call   c01046cd <kva2page>
c0104772:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104776:	89 04 24             	mov    %eax,(%esp)
c0104779:	e8 27 09 00 00       	call   c01050a5 <free_pages>
}
c010477e:	83 c4 14             	add    $0x14,%esp
c0104781:	5b                   	pop    %ebx
c0104782:	5d                   	pop    %ebp
c0104783:	c3                   	ret    

c0104784 <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c0104784:	55                   	push   %ebp
c0104785:	89 e5                	mov    %esp,%ebp
c0104787:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c010478a:	8b 45 08             	mov    0x8(%ebp),%eax
c010478d:	83 c0 08             	add    $0x8,%eax
c0104790:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0104795:	76 24                	jbe    c01047bb <slob_alloc+0x37>
c0104797:	c7 44 24 0c c4 c9 10 	movl   $0xc010c9c4,0xc(%esp)
c010479e:	c0 
c010479f:	c7 44 24 08 e3 c9 10 	movl   $0xc010c9e3,0x8(%esp)
c01047a6:	c0 
c01047a7:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01047ae:	00 
c01047af:	c7 04 24 f8 c9 10 c0 	movl   $0xc010c9f8,(%esp)
c01047b6:	e8 1a c6 ff ff       	call   c0100dd5 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c01047bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c01047c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01047c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01047cc:	83 c0 07             	add    $0x7,%eax
c01047cf:	c1 e8 03             	shr    $0x3,%eax
c01047d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c01047d5:	e8 f3 fd ff ff       	call   c01045cd <__intr_save>
c01047da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c01047dd:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c01047e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c01047e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e8:	8b 40 04             	mov    0x4(%eax),%eax
c01047eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c01047ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01047f2:	74 25                	je     c0104819 <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c01047f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01047f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01047fa:	01 d0                	add    %edx,%eax
c01047fc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01047ff:	8b 45 10             	mov    0x10(%ebp),%eax
c0104802:	f7 d8                	neg    %eax
c0104804:	21 d0                	and    %edx,%eax
c0104806:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c0104809:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010480c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010480f:	29 c2                	sub    %eax,%edx
c0104811:	89 d0                	mov    %edx,%eax
c0104813:	c1 f8 03             	sar    $0x3,%eax
c0104816:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c0104819:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010481c:	8b 00                	mov    (%eax),%eax
c010481e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104821:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104824:	01 ca                	add    %ecx,%edx
c0104826:	39 d0                	cmp    %edx,%eax
c0104828:	0f 8c aa 00 00 00    	jl     c01048d8 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c010482e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104832:	74 38                	je     c010486c <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c0104834:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104837:	8b 00                	mov    (%eax),%eax
c0104839:	2b 45 e8             	sub    -0x18(%ebp),%eax
c010483c:	89 c2                	mov    %eax,%edx
c010483e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104841:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104843:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104846:	8b 50 04             	mov    0x4(%eax),%edx
c0104849:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010484c:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c010484f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104852:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104855:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104858:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010485b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010485e:	89 10                	mov    %edx,(%eax)
				prev = cur;
c0104860:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104863:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0104866:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104869:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c010486c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010486f:	8b 00                	mov    (%eax),%eax
c0104871:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104874:	75 0e                	jne    c0104884 <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c0104876:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104879:	8b 50 04             	mov    0x4(%eax),%edx
c010487c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010487f:	89 50 04             	mov    %edx,0x4(%eax)
c0104882:	eb 3c                	jmp    c01048c0 <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c0104884:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104887:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010488e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104891:	01 c2                	add    %eax,%edx
c0104893:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104896:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0104899:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010489c:	8b 40 04             	mov    0x4(%eax),%eax
c010489f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01048a2:	8b 12                	mov    (%edx),%edx
c01048a4:	2b 55 e0             	sub    -0x20(%ebp),%edx
c01048a7:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c01048a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048ac:	8b 40 04             	mov    0x4(%eax),%eax
c01048af:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01048b2:	8b 52 04             	mov    0x4(%edx),%edx
c01048b5:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c01048b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01048be:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c01048c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048c3:	a3 08 aa 12 c0       	mov    %eax,0xc012aa08
			spin_unlock_irqrestore(&slob_lock, flags);
c01048c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048cb:	89 04 24             	mov    %eax,(%esp)
c01048ce:	e8 24 fd ff ff       	call   c01045f7 <__intr_restore>
			return cur;
c01048d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048d6:	eb 7f                	jmp    c0104957 <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c01048d8:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c01048dd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01048e0:	75 61                	jne    c0104943 <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c01048e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048e5:	89 04 24             	mov    %eax,(%esp)
c01048e8:	e8 0a fd ff ff       	call   c01045f7 <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c01048ed:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c01048f4:	75 07                	jne    c01048fd <slob_alloc+0x179>
				return 0;
c01048f6:	b8 00 00 00 00       	mov    $0x0,%eax
c01048fb:	eb 5a                	jmp    c0104957 <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c01048fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104904:	00 
c0104905:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104908:	89 04 24             	mov    %eax,(%esp)
c010490b:	e8 07 fe ff ff       	call   c0104717 <__slob_get_free_pages>
c0104910:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104913:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104917:	75 07                	jne    c0104920 <slob_alloc+0x19c>
				return 0;
c0104919:	b8 00 00 00 00       	mov    $0x0,%eax
c010491e:	eb 37                	jmp    c0104957 <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c0104920:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104927:	00 
c0104928:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010492b:	89 04 24             	mov    %eax,(%esp)
c010492e:	e8 26 00 00 00       	call   c0104959 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c0104933:	e8 95 fc ff ff       	call   c01045cd <__intr_save>
c0104938:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c010493b:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c0104940:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104943:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104946:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104949:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010494c:	8b 40 04             	mov    0x4(%eax),%eax
c010494f:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c0104952:	e9 97 fe ff ff       	jmp    c01047ee <slob_alloc+0x6a>
}
c0104957:	c9                   	leave  
c0104958:	c3                   	ret    

c0104959 <slob_free>:

static void slob_free(void *block, int size)
{
c0104959:	55                   	push   %ebp
c010495a:	89 e5                	mov    %esp,%ebp
c010495c:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c010495f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104962:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104965:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104969:	75 05                	jne    c0104970 <slob_free+0x17>
		return;
c010496b:	e9 ff 00 00 00       	jmp    c0104a6f <slob_free+0x116>

	if (size)
c0104970:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104974:	74 10                	je     c0104986 <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c0104976:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104979:	83 c0 07             	add    $0x7,%eax
c010497c:	c1 e8 03             	shr    $0x3,%eax
c010497f:	89 c2                	mov    %eax,%edx
c0104981:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104984:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104986:	e8 42 fc ff ff       	call   c01045cd <__intr_save>
c010498b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c010498e:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c0104993:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104996:	eb 27                	jmp    c01049bf <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104998:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010499b:	8b 40 04             	mov    0x4(%eax),%eax
c010499e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01049a1:	77 13                	ja     c01049b6 <slob_free+0x5d>
c01049a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01049a9:	77 27                	ja     c01049d2 <slob_free+0x79>
c01049ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049ae:	8b 40 04             	mov    0x4(%eax),%eax
c01049b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049b4:	77 1c                	ja     c01049d2 <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c01049b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049b9:	8b 40 04             	mov    0x4(%eax),%eax
c01049bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01049c5:	76 d1                	jbe    c0104998 <slob_free+0x3f>
c01049c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049ca:	8b 40 04             	mov    0x4(%eax),%eax
c01049cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049d0:	76 c6                	jbe    c0104998 <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c01049d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049d5:	8b 00                	mov    (%eax),%eax
c01049d7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01049de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049e1:	01 c2                	add    %eax,%edx
c01049e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049e6:	8b 40 04             	mov    0x4(%eax),%eax
c01049e9:	39 c2                	cmp    %eax,%edx
c01049eb:	75 25                	jne    c0104a12 <slob_free+0xb9>
		b->units += cur->next->units;
c01049ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049f0:	8b 10                	mov    (%eax),%edx
c01049f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049f5:	8b 40 04             	mov    0x4(%eax),%eax
c01049f8:	8b 00                	mov    (%eax),%eax
c01049fa:	01 c2                	add    %eax,%edx
c01049fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049ff:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a04:	8b 40 04             	mov    0x4(%eax),%eax
c0104a07:	8b 50 04             	mov    0x4(%eax),%edx
c0104a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a0d:	89 50 04             	mov    %edx,0x4(%eax)
c0104a10:	eb 0c                	jmp    c0104a1e <slob_free+0xc5>
	} else
		b->next = cur->next;
c0104a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a15:	8b 50 04             	mov    0x4(%eax),%edx
c0104a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a1b:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c0104a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a21:	8b 00                	mov    (%eax),%eax
c0104a23:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a2d:	01 d0                	add    %edx,%eax
c0104a2f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104a32:	75 1f                	jne    c0104a53 <slob_free+0xfa>
		cur->units += b->units;
c0104a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a37:	8b 10                	mov    (%eax),%edx
c0104a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a3c:	8b 00                	mov    (%eax),%eax
c0104a3e:	01 c2                	add    %eax,%edx
c0104a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a43:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a48:	8b 50 04             	mov    0x4(%eax),%edx
c0104a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a4e:	89 50 04             	mov    %edx,0x4(%eax)
c0104a51:	eb 09                	jmp    c0104a5c <slob_free+0x103>
	} else
		cur->next = b;
c0104a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a56:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104a59:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0104a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a5f:	a3 08 aa 12 c0       	mov    %eax,0xc012aa08

	spin_unlock_irqrestore(&slob_lock, flags);
c0104a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a67:	89 04 24             	mov    %eax,(%esp)
c0104a6a:	e8 88 fb ff ff       	call   c01045f7 <__intr_restore>
}
c0104a6f:	c9                   	leave  
c0104a70:	c3                   	ret    

c0104a71 <slob_init>:



void
slob_init(void) {
c0104a71:	55                   	push   %ebp
c0104a72:	89 e5                	mov    %esp,%ebp
c0104a74:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c0104a77:	c7 04 24 0a ca 10 c0 	movl   $0xc010ca0a,(%esp)
c0104a7e:	e8 d0 b8 ff ff       	call   c0100353 <cprintf>
}
c0104a83:	c9                   	leave  
c0104a84:	c3                   	ret    

c0104a85 <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0104a85:	55                   	push   %ebp
c0104a86:	89 e5                	mov    %esp,%ebp
c0104a88:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c0104a8b:	e8 e1 ff ff ff       	call   c0104a71 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c0104a90:	c7 04 24 1e ca 10 c0 	movl   $0xc010ca1e,(%esp)
c0104a97:	e8 b7 b8 ff ff       	call   c0100353 <cprintf>
}
c0104a9c:	c9                   	leave  
c0104a9d:	c3                   	ret    

c0104a9e <slob_allocated>:

size_t
slob_allocated(void) {
c0104a9e:	55                   	push   %ebp
c0104a9f:	89 e5                	mov    %esp,%ebp
  return 0;
c0104aa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104aa6:	5d                   	pop    %ebp
c0104aa7:	c3                   	ret    

c0104aa8 <kallocated>:

size_t
kallocated(void) {
c0104aa8:	55                   	push   %ebp
c0104aa9:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0104aab:	e8 ee ff ff ff       	call   c0104a9e <slob_allocated>
}
c0104ab0:	5d                   	pop    %ebp
c0104ab1:	c3                   	ret    

c0104ab2 <find_order>:

static int find_order(int size)
{
c0104ab2:	55                   	push   %ebp
c0104ab3:	89 e5                	mov    %esp,%ebp
c0104ab5:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0104ab8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104abf:	eb 07                	jmp    c0104ac8 <find_order+0x16>
		order++;
c0104ac1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0104ac5:	d1 7d 08             	sarl   0x8(%ebp)
c0104ac8:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104acf:	7f f0                	jg     c0104ac1 <find_order+0xf>
		order++;
	return order;
c0104ad1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104ad4:	c9                   	leave  
c0104ad5:	c3                   	ret    

c0104ad6 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0104ad6:	55                   	push   %ebp
c0104ad7:	89 e5                	mov    %esp,%ebp
c0104ad9:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c0104adc:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0104ae3:	77 38                	ja     c0104b1d <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0104ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ae8:	8d 50 08             	lea    0x8(%eax),%edx
c0104aeb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104af2:	00 
c0104af3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104af6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104afa:	89 14 24             	mov    %edx,(%esp)
c0104afd:	e8 82 fc ff ff       	call   c0104784 <slob_alloc>
c0104b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c0104b05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104b09:	74 08                	je     c0104b13 <__kmalloc+0x3d>
c0104b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b0e:	83 c0 08             	add    $0x8,%eax
c0104b11:	eb 05                	jmp    c0104b18 <__kmalloc+0x42>
c0104b13:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b18:	e9 a6 00 00 00       	jmp    c0104bc3 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c0104b1d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b24:	00 
c0104b25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b2c:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104b33:	e8 4c fc ff ff       	call   c0104784 <slob_alloc>
c0104b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c0104b3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b3f:	75 07                	jne    c0104b48 <__kmalloc+0x72>
		return 0;
c0104b41:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b46:	eb 7b                	jmp    c0104bc3 <__kmalloc+0xed>

	bb->order = find_order(size);
c0104b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b4b:	89 04 24             	mov    %eax,(%esp)
c0104b4e:	e8 5f ff ff ff       	call   c0104ab2 <find_order>
c0104b53:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104b56:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b5b:	8b 00                	mov    (%eax),%eax
c0104b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b64:	89 04 24             	mov    %eax,(%esp)
c0104b67:	e8 ab fb ff ff       	call   c0104717 <__slob_get_free_pages>
c0104b6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104b6f:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c0104b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b75:	8b 40 04             	mov    0x4(%eax),%eax
c0104b78:	85 c0                	test   %eax,%eax
c0104b7a:	74 2f                	je     c0104bab <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c0104b7c:	e8 4c fa ff ff       	call   c01045cd <__intr_save>
c0104b81:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c0104b84:	8b 15 c4 ce 19 c0    	mov    0xc019cec4,%edx
c0104b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b8d:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c0104b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b93:	a3 c4 ce 19 c0       	mov    %eax,0xc019cec4
		spin_unlock_irqrestore(&block_lock, flags);
c0104b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b9b:	89 04 24             	mov    %eax,(%esp)
c0104b9e:	e8 54 fa ff ff       	call   c01045f7 <__intr_restore>
		return bb->pages;
c0104ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ba6:	8b 40 04             	mov    0x4(%eax),%eax
c0104ba9:	eb 18                	jmp    c0104bc3 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c0104bab:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104bb2:	00 
c0104bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bb6:	89 04 24             	mov    %eax,(%esp)
c0104bb9:	e8 9b fd ff ff       	call   c0104959 <slob_free>
	return 0;
c0104bbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104bc3:	c9                   	leave  
c0104bc4:	c3                   	ret    

c0104bc5 <kmalloc>:

void *
kmalloc(size_t size)
{
c0104bc5:	55                   	push   %ebp
c0104bc6:	89 e5                	mov    %esp,%ebp
c0104bc8:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c0104bcb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104bd2:	00 
c0104bd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bd6:	89 04 24             	mov    %eax,(%esp)
c0104bd9:	e8 f8 fe ff ff       	call   c0104ad6 <__kmalloc>
}
c0104bde:	c9                   	leave  
c0104bdf:	c3                   	ret    

c0104be0 <kfree>:


void kfree(void *block)
{
c0104be0:	55                   	push   %ebp
c0104be1:	89 e5                	mov    %esp,%ebp
c0104be3:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c0104be6:	c7 45 f0 c4 ce 19 c0 	movl   $0xc019cec4,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104bed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104bf1:	75 05                	jne    c0104bf8 <kfree+0x18>
		return;
c0104bf3:	e9 a2 00 00 00       	jmp    c0104c9a <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104bf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bfb:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104c00:	85 c0                	test   %eax,%eax
c0104c02:	75 7f                	jne    c0104c83 <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0104c04:	e8 c4 f9 ff ff       	call   c01045cd <__intr_save>
c0104c09:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104c0c:	a1 c4 ce 19 c0       	mov    0xc019cec4,%eax
c0104c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c14:	eb 5c                	jmp    c0104c72 <kfree+0x92>
			if (bb->pages == block) {
c0104c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c19:	8b 40 04             	mov    0x4(%eax),%eax
c0104c1c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104c1f:	75 3f                	jne    c0104c60 <kfree+0x80>
				*last = bb->next;
c0104c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c24:	8b 50 08             	mov    0x8(%eax),%edx
c0104c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c2a:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0104c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c2f:	89 04 24             	mov    %eax,(%esp)
c0104c32:	e8 c0 f9 ff ff       	call   c01045f7 <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c3a:	8b 10                	mov    (%eax),%edx
c0104c3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c3f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c43:	89 04 24             	mov    %eax,(%esp)
c0104c46:	e8 05 fb ff ff       	call   c0104750 <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104c4b:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104c52:	00 
c0104c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c56:	89 04 24             	mov    %eax,(%esp)
c0104c59:	e8 fb fc ff ff       	call   c0104959 <slob_free>
				return;
c0104c5e:	eb 3a                	jmp    c0104c9a <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c63:	83 c0 08             	add    $0x8,%eax
c0104c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c6c:	8b 40 08             	mov    0x8(%eax),%eax
c0104c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c76:	75 9e                	jne    c0104c16 <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c7b:	89 04 24             	mov    %eax,(%esp)
c0104c7e:	e8 74 f9 ff ff       	call   c01045f7 <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0104c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c86:	83 e8 08             	sub    $0x8,%eax
c0104c89:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104c90:	00 
c0104c91:	89 04 24             	mov    %eax,(%esp)
c0104c94:	e8 c0 fc ff ff       	call   c0104959 <slob_free>
	return;
c0104c99:	90                   	nop
}
c0104c9a:	c9                   	leave  
c0104c9b:	c3                   	ret    

c0104c9c <ksize>:


unsigned int ksize(const void *block)
{
c0104c9c:	55                   	push   %ebp
c0104c9d:	89 e5                	mov    %esp,%ebp
c0104c9f:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0104ca2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104ca6:	75 07                	jne    c0104caf <ksize+0x13>
		return 0;
c0104ca8:	b8 00 00 00 00       	mov    $0x0,%eax
c0104cad:	eb 6b                	jmp    c0104d1a <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104caf:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cb2:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104cb7:	85 c0                	test   %eax,%eax
c0104cb9:	75 54                	jne    c0104d0f <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c0104cbb:	e8 0d f9 ff ff       	call   c01045cd <__intr_save>
c0104cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104cc3:	a1 c4 ce 19 c0       	mov    0xc019cec4,%eax
c0104cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ccb:	eb 31                	jmp    c0104cfe <ksize+0x62>
			if (bb->pages == block) {
c0104ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cd0:	8b 40 04             	mov    0x4(%eax),%eax
c0104cd3:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104cd6:	75 1d                	jne    c0104cf5 <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cdb:	89 04 24             	mov    %eax,(%esp)
c0104cde:	e8 14 f9 ff ff       	call   c01045f7 <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ce6:	8b 00                	mov    (%eax),%eax
c0104ce8:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104ced:	89 c1                	mov    %eax,%ecx
c0104cef:	d3 e2                	shl    %cl,%edx
c0104cf1:	89 d0                	mov    %edx,%eax
c0104cf3:	eb 25                	jmp    c0104d1a <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cf8:	8b 40 08             	mov    0x8(%eax),%eax
c0104cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104cfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d02:	75 c9                	jne    c0104ccd <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d07:	89 04 24             	mov    %eax,(%esp)
c0104d0a:	e8 e8 f8 ff ff       	call   c01045f7 <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104d0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d12:	83 e8 08             	sub    $0x8,%eax
c0104d15:	8b 00                	mov    (%eax),%eax
c0104d17:	c1 e0 03             	shl    $0x3,%eax
}
c0104d1a:	c9                   	leave  
c0104d1b:	c3                   	ret    

c0104d1c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104d1c:	55                   	push   %ebp
c0104d1d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104d1f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d22:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0104d27:	29 c2                	sub    %eax,%edx
c0104d29:	89 d0                	mov    %edx,%eax
c0104d2b:	c1 f8 05             	sar    $0x5,%eax
}
c0104d2e:	5d                   	pop    %ebp
c0104d2f:	c3                   	ret    

c0104d30 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104d30:	55                   	push   %ebp
c0104d31:	89 e5                	mov    %esp,%ebp
c0104d33:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104d36:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d39:	89 04 24             	mov    %eax,(%esp)
c0104d3c:	e8 db ff ff ff       	call   c0104d1c <page2ppn>
c0104d41:	c1 e0 0c             	shl    $0xc,%eax
}
c0104d44:	c9                   	leave  
c0104d45:	c3                   	ret    

c0104d46 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104d46:	55                   	push   %ebp
c0104d47:	89 e5                	mov    %esp,%ebp
c0104d49:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104d4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d4f:	c1 e8 0c             	shr    $0xc,%eax
c0104d52:	89 c2                	mov    %eax,%edx
c0104d54:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0104d59:	39 c2                	cmp    %eax,%edx
c0104d5b:	72 1c                	jb     c0104d79 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104d5d:	c7 44 24 08 3c ca 10 	movl   $0xc010ca3c,0x8(%esp)
c0104d64:	c0 
c0104d65:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0104d6c:	00 
c0104d6d:	c7 04 24 5b ca 10 c0 	movl   $0xc010ca5b,(%esp)
c0104d74:	e8 5c c0 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0104d79:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0104d7e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d81:	c1 ea 0c             	shr    $0xc,%edx
c0104d84:	c1 e2 05             	shl    $0x5,%edx
c0104d87:	01 d0                	add    %edx,%eax
}
c0104d89:	c9                   	leave  
c0104d8a:	c3                   	ret    

c0104d8b <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104d8b:	55                   	push   %ebp
c0104d8c:	89 e5                	mov    %esp,%ebp
c0104d8e:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104d91:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d94:	89 04 24             	mov    %eax,(%esp)
c0104d97:	e8 94 ff ff ff       	call   c0104d30 <page2pa>
c0104d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104da2:	c1 e8 0c             	shr    $0xc,%eax
c0104da5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104da8:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0104dad:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104db0:	72 23                	jb     c0104dd5 <page2kva+0x4a>
c0104db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104db5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104db9:	c7 44 24 08 6c ca 10 	movl   $0xc010ca6c,0x8(%esp)
c0104dc0:	c0 
c0104dc1:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0104dc8:	00 
c0104dc9:	c7 04 24 5b ca 10 c0 	movl   $0xc010ca5b,(%esp)
c0104dd0:	e8 00 c0 ff ff       	call   c0100dd5 <__panic>
c0104dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dd8:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104ddd:	c9                   	leave  
c0104dde:	c3                   	ret    

c0104ddf <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104ddf:	55                   	push   %ebp
c0104de0:	89 e5                	mov    %esp,%ebp
c0104de2:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104de5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104de8:	83 e0 01             	and    $0x1,%eax
c0104deb:	85 c0                	test   %eax,%eax
c0104ded:	75 1c                	jne    c0104e0b <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104def:	c7 44 24 08 90 ca 10 	movl   $0xc010ca90,0x8(%esp)
c0104df6:	c0 
c0104df7:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0104dfe:	00 
c0104dff:	c7 04 24 5b ca 10 c0 	movl   $0xc010ca5b,(%esp)
c0104e06:	e8 ca bf ff ff       	call   c0100dd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104e0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e0e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e13:	89 04 24             	mov    %eax,(%esp)
c0104e16:	e8 2b ff ff ff       	call   c0104d46 <pa2page>
}
c0104e1b:	c9                   	leave  
c0104e1c:	c3                   	ret    

c0104e1d <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0104e1d:	55                   	push   %ebp
c0104e1e:	89 e5                	mov    %esp,%ebp
c0104e20:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0104e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e2b:	89 04 24             	mov    %eax,(%esp)
c0104e2e:	e8 13 ff ff ff       	call   c0104d46 <pa2page>
}
c0104e33:	c9                   	leave  
c0104e34:	c3                   	ret    

c0104e35 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0104e35:	55                   	push   %ebp
c0104e36:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104e38:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e3b:	8b 00                	mov    (%eax),%eax
}
c0104e3d:	5d                   	pop    %ebp
c0104e3e:	c3                   	ret    

c0104e3f <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104e3f:	55                   	push   %ebp
c0104e40:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104e42:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e45:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e48:	89 10                	mov    %edx,(%eax)
}
c0104e4a:	5d                   	pop    %ebp
c0104e4b:	c3                   	ret    

c0104e4c <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104e4c:	55                   	push   %ebp
c0104e4d:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104e4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e52:	8b 00                	mov    (%eax),%eax
c0104e54:	8d 50 01             	lea    0x1(%eax),%edx
c0104e57:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e5a:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104e5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e5f:	8b 00                	mov    (%eax),%eax
}
c0104e61:	5d                   	pop    %ebp
c0104e62:	c3                   	ret    

c0104e63 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104e63:	55                   	push   %ebp
c0104e64:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104e66:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e69:	8b 00                	mov    (%eax),%eax
c0104e6b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104e6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e71:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104e73:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e76:	8b 00                	mov    (%eax),%eax
}
c0104e78:	5d                   	pop    %ebp
c0104e79:	c3                   	ret    

c0104e7a <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0104e7a:	55                   	push   %ebp
c0104e7b:	89 e5                	mov    %esp,%ebp
c0104e7d:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104e80:	9c                   	pushf  
c0104e81:	58                   	pop    %eax
c0104e82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104e88:	25 00 02 00 00       	and    $0x200,%eax
c0104e8d:	85 c0                	test   %eax,%eax
c0104e8f:	74 0c                	je     c0104e9d <__intr_save+0x23>
        intr_disable();
c0104e91:	e8 97 d1 ff ff       	call   c010202d <intr_disable>
        return 1;
c0104e96:	b8 01 00 00 00       	mov    $0x1,%eax
c0104e9b:	eb 05                	jmp    c0104ea2 <__intr_save+0x28>
    }
    return 0;
c0104e9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ea2:	c9                   	leave  
c0104ea3:	c3                   	ret    

c0104ea4 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104ea4:	55                   	push   %ebp
c0104ea5:	89 e5                	mov    %esp,%ebp
c0104ea7:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104eaa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104eae:	74 05                	je     c0104eb5 <__intr_restore+0x11>
        intr_enable();
c0104eb0:	e8 72 d1 ff ff       	call   c0102027 <intr_enable>
    }
}
c0104eb5:	c9                   	leave  
c0104eb6:	c3                   	ret    

c0104eb7 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104eb7:	55                   	push   %ebp
c0104eb8:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104eba:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ebd:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104ec0:	b8 23 00 00 00       	mov    $0x23,%eax
c0104ec5:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104ec7:	b8 23 00 00 00       	mov    $0x23,%eax
c0104ecc:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104ece:	b8 10 00 00 00       	mov    $0x10,%eax
c0104ed3:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104ed5:	b8 10 00 00 00       	mov    $0x10,%eax
c0104eda:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104edc:	b8 10 00 00 00       	mov    $0x10,%eax
c0104ee1:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104ee3:	ea ea 4e 10 c0 08 00 	ljmp   $0x8,$0xc0104eea
}
c0104eea:	5d                   	pop    %ebp
c0104eeb:	c3                   	ret    

c0104eec <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104eec:	55                   	push   %ebp
c0104eed:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104eef:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ef2:	a3 04 cf 19 c0       	mov    %eax,0xc019cf04
}
c0104ef7:	5d                   	pop    %ebp
c0104ef8:	c3                   	ret    

c0104ef9 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104ef9:	55                   	push   %ebp
c0104efa:	89 e5                	mov    %esp,%ebp
c0104efc:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104eff:	b8 00 a0 12 c0       	mov    $0xc012a000,%eax
c0104f04:	89 04 24             	mov    %eax,(%esp)
c0104f07:	e8 e0 ff ff ff       	call   c0104eec <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104f0c:	66 c7 05 08 cf 19 c0 	movw   $0x10,0xc019cf08
c0104f13:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104f15:	66 c7 05 48 aa 12 c0 	movw   $0x68,0xc012aa48
c0104f1c:	68 00 
c0104f1e:	b8 00 cf 19 c0       	mov    $0xc019cf00,%eax
c0104f23:	66 a3 4a aa 12 c0    	mov    %ax,0xc012aa4a
c0104f29:	b8 00 cf 19 c0       	mov    $0xc019cf00,%eax
c0104f2e:	c1 e8 10             	shr    $0x10,%eax
c0104f31:	a2 4c aa 12 c0       	mov    %al,0xc012aa4c
c0104f36:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0104f3d:	83 e0 f0             	and    $0xfffffff0,%eax
c0104f40:	83 c8 09             	or     $0x9,%eax
c0104f43:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0104f48:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0104f4f:	83 e0 ef             	and    $0xffffffef,%eax
c0104f52:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0104f57:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0104f5e:	83 e0 9f             	and    $0xffffff9f,%eax
c0104f61:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0104f66:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0104f6d:	83 c8 80             	or     $0xffffff80,%eax
c0104f70:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0104f75:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0104f7c:	83 e0 f0             	and    $0xfffffff0,%eax
c0104f7f:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0104f84:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0104f8b:	83 e0 ef             	and    $0xffffffef,%eax
c0104f8e:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0104f93:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0104f9a:	83 e0 df             	and    $0xffffffdf,%eax
c0104f9d:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0104fa2:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0104fa9:	83 c8 40             	or     $0x40,%eax
c0104fac:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0104fb1:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0104fb8:	83 e0 7f             	and    $0x7f,%eax
c0104fbb:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0104fc0:	b8 00 cf 19 c0       	mov    $0xc019cf00,%eax
c0104fc5:	c1 e8 18             	shr    $0x18,%eax
c0104fc8:	a2 4f aa 12 c0       	mov    %al,0xc012aa4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104fcd:	c7 04 24 50 aa 12 c0 	movl   $0xc012aa50,(%esp)
c0104fd4:	e8 de fe ff ff       	call   c0104eb7 <lgdt>
c0104fd9:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104fdf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104fe3:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104fe6:	c9                   	leave  
c0104fe7:	c3                   	ret    

c0104fe8 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104fe8:	55                   	push   %ebp
c0104fe9:	89 e5                	mov    %esp,%ebp
c0104feb:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104fee:	c7 05 c4 ef 19 c0 30 	movl   $0xc010c930,0xc019efc4
c0104ff5:	c9 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104ff8:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0104ffd:	8b 00                	mov    (%eax),%eax
c0104fff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105003:	c7 04 24 bc ca 10 c0 	movl   $0xc010cabc,(%esp)
c010500a:	e8 44 b3 ff ff       	call   c0100353 <cprintf>
    pmm_manager->init();
c010500f:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0105014:	8b 40 04             	mov    0x4(%eax),%eax
c0105017:	ff d0                	call   *%eax
}
c0105019:	c9                   	leave  
c010501a:	c3                   	ret    

c010501b <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c010501b:	55                   	push   %ebp
c010501c:	89 e5                	mov    %esp,%ebp
c010501e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0105021:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0105026:	8b 40 08             	mov    0x8(%eax),%eax
c0105029:	8b 55 0c             	mov    0xc(%ebp),%edx
c010502c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105030:	8b 55 08             	mov    0x8(%ebp),%edx
c0105033:	89 14 24             	mov    %edx,(%esp)
c0105036:	ff d0                	call   *%eax
}
c0105038:	c9                   	leave  
c0105039:	c3                   	ret    

c010503a <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c010503a:	55                   	push   %ebp
c010503b:	89 e5                	mov    %esp,%ebp
c010503d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0105040:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0105047:	e8 2e fe ff ff       	call   c0104e7a <__intr_save>
c010504c:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c010504f:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0105054:	8b 40 0c             	mov    0xc(%eax),%eax
c0105057:	8b 55 08             	mov    0x8(%ebp),%edx
c010505a:	89 14 24             	mov    %edx,(%esp)
c010505d:	ff d0                	call   *%eax
c010505f:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0105062:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105065:	89 04 24             	mov    %eax,(%esp)
c0105068:	e8 37 fe ff ff       	call   c0104ea4 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c010506d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105071:	75 2d                	jne    c01050a0 <alloc_pages+0x66>
c0105073:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0105077:	77 27                	ja     c01050a0 <alloc_pages+0x66>
c0105079:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c010507e:	85 c0                	test   %eax,%eax
c0105080:	74 1e                	je     c01050a0 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0105082:	8b 55 08             	mov    0x8(%ebp),%edx
c0105085:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c010508a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105091:	00 
c0105092:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105096:	89 04 24             	mov    %eax,(%esp)
c0105099:	e8 90 1d 00 00       	call   c0106e2e <swap_out>
    }
c010509e:	eb a7                	jmp    c0105047 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c01050a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01050a3:	c9                   	leave  
c01050a4:	c3                   	ret    

c01050a5 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c01050a5:	55                   	push   %ebp
c01050a6:	89 e5                	mov    %esp,%ebp
c01050a8:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01050ab:	e8 ca fd ff ff       	call   c0104e7a <__intr_save>
c01050b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01050b3:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c01050b8:	8b 40 10             	mov    0x10(%eax),%eax
c01050bb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01050be:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050c2:	8b 55 08             	mov    0x8(%ebp),%edx
c01050c5:	89 14 24             	mov    %edx,(%esp)
c01050c8:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01050ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050cd:	89 04 24             	mov    %eax,(%esp)
c01050d0:	e8 cf fd ff ff       	call   c0104ea4 <__intr_restore>
}
c01050d5:	c9                   	leave  
c01050d6:	c3                   	ret    

c01050d7 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01050d7:	55                   	push   %ebp
c01050d8:	89 e5                	mov    %esp,%ebp
c01050da:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01050dd:	e8 98 fd ff ff       	call   c0104e7a <__intr_save>
c01050e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01050e5:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c01050ea:	8b 40 14             	mov    0x14(%eax),%eax
c01050ed:	ff d0                	call   *%eax
c01050ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01050f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050f5:	89 04 24             	mov    %eax,(%esp)
c01050f8:	e8 a7 fd ff ff       	call   c0104ea4 <__intr_restore>
    return ret;
c01050fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0105100:	c9                   	leave  
c0105101:	c3                   	ret    

c0105102 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0105102:	55                   	push   %ebp
c0105103:	89 e5                	mov    %esp,%ebp
c0105105:	57                   	push   %edi
c0105106:	56                   	push   %esi
c0105107:	53                   	push   %ebx
c0105108:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c010510e:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0105115:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c010511c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0105123:	c7 04 24 d3 ca 10 c0 	movl   $0xc010cad3,(%esp)
c010512a:	e8 24 b2 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010512f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105136:	e9 15 01 00 00       	jmp    c0105250 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010513b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010513e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105141:	89 d0                	mov    %edx,%eax
c0105143:	c1 e0 02             	shl    $0x2,%eax
c0105146:	01 d0                	add    %edx,%eax
c0105148:	c1 e0 02             	shl    $0x2,%eax
c010514b:	01 c8                	add    %ecx,%eax
c010514d:	8b 50 08             	mov    0x8(%eax),%edx
c0105150:	8b 40 04             	mov    0x4(%eax),%eax
c0105153:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0105156:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0105159:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010515c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010515f:	89 d0                	mov    %edx,%eax
c0105161:	c1 e0 02             	shl    $0x2,%eax
c0105164:	01 d0                	add    %edx,%eax
c0105166:	c1 e0 02             	shl    $0x2,%eax
c0105169:	01 c8                	add    %ecx,%eax
c010516b:	8b 48 0c             	mov    0xc(%eax),%ecx
c010516e:	8b 58 10             	mov    0x10(%eax),%ebx
c0105171:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105174:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105177:	01 c8                	add    %ecx,%eax
c0105179:	11 da                	adc    %ebx,%edx
c010517b:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010517e:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0105181:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105184:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105187:	89 d0                	mov    %edx,%eax
c0105189:	c1 e0 02             	shl    $0x2,%eax
c010518c:	01 d0                	add    %edx,%eax
c010518e:	c1 e0 02             	shl    $0x2,%eax
c0105191:	01 c8                	add    %ecx,%eax
c0105193:	83 c0 14             	add    $0x14,%eax
c0105196:	8b 00                	mov    (%eax),%eax
c0105198:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c010519e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01051a1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01051a4:	83 c0 ff             	add    $0xffffffff,%eax
c01051a7:	83 d2 ff             	adc    $0xffffffff,%edx
c01051aa:	89 c6                	mov    %eax,%esi
c01051ac:	89 d7                	mov    %edx,%edi
c01051ae:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051b4:	89 d0                	mov    %edx,%eax
c01051b6:	c1 e0 02             	shl    $0x2,%eax
c01051b9:	01 d0                	add    %edx,%eax
c01051bb:	c1 e0 02             	shl    $0x2,%eax
c01051be:	01 c8                	add    %ecx,%eax
c01051c0:	8b 48 0c             	mov    0xc(%eax),%ecx
c01051c3:	8b 58 10             	mov    0x10(%eax),%ebx
c01051c6:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01051cc:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01051d0:	89 74 24 14          	mov    %esi,0x14(%esp)
c01051d4:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01051d8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01051db:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01051de:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01051e2:	89 54 24 10          	mov    %edx,0x10(%esp)
c01051e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01051ea:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01051ee:	c7 04 24 e0 ca 10 c0 	movl   $0xc010cae0,(%esp)
c01051f5:	e8 59 b1 ff ff       	call   c0100353 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01051fa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105200:	89 d0                	mov    %edx,%eax
c0105202:	c1 e0 02             	shl    $0x2,%eax
c0105205:	01 d0                	add    %edx,%eax
c0105207:	c1 e0 02             	shl    $0x2,%eax
c010520a:	01 c8                	add    %ecx,%eax
c010520c:	83 c0 14             	add    $0x14,%eax
c010520f:	8b 00                	mov    (%eax),%eax
c0105211:	83 f8 01             	cmp    $0x1,%eax
c0105214:	75 36                	jne    c010524c <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0105216:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105219:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010521c:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010521f:	77 2b                	ja     c010524c <page_init+0x14a>
c0105221:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0105224:	72 05                	jb     c010522b <page_init+0x129>
c0105226:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0105229:	73 21                	jae    c010524c <page_init+0x14a>
c010522b:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010522f:	77 1b                	ja     c010524c <page_init+0x14a>
c0105231:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0105235:	72 09                	jb     c0105240 <page_init+0x13e>
c0105237:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c010523e:	77 0c                	ja     c010524c <page_init+0x14a>
                maxpa = end;
c0105240:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105243:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105246:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105249:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010524c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105250:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105253:	8b 00                	mov    (%eax),%eax
c0105255:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105258:	0f 8f dd fe ff ff    	jg     c010513b <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c010525e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105262:	72 1d                	jb     c0105281 <page_init+0x17f>
c0105264:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105268:	77 09                	ja     c0105273 <page_init+0x171>
c010526a:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0105271:	76 0e                	jbe    c0105281 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0105273:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010527a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0105281:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105284:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105287:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010528b:	c1 ea 0c             	shr    $0xc,%edx
c010528e:	a3 e0 ce 19 c0       	mov    %eax,0xc019cee0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0105293:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c010529a:	b8 b8 f0 19 c0       	mov    $0xc019f0b8,%eax
c010529f:	8d 50 ff             	lea    -0x1(%eax),%edx
c01052a2:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01052a5:	01 d0                	add    %edx,%eax
c01052a7:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01052aa:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01052ad:	ba 00 00 00 00       	mov    $0x0,%edx
c01052b2:	f7 75 ac             	divl   -0x54(%ebp)
c01052b5:	89 d0                	mov    %edx,%eax
c01052b7:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01052ba:	29 c2                	sub    %eax,%edx
c01052bc:	89 d0                	mov    %edx,%eax
c01052be:	a3 cc ef 19 c0       	mov    %eax,0xc019efcc

    for (i = 0; i < npage; i ++) {
c01052c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01052ca:	eb 27                	jmp    c01052f3 <page_init+0x1f1>
        SetPageReserved(pages + i);
c01052cc:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01052d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052d4:	c1 e2 05             	shl    $0x5,%edx
c01052d7:	01 d0                	add    %edx,%eax
c01052d9:	83 c0 04             	add    $0x4,%eax
c01052dc:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01052e3:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01052e6:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01052e9:	8b 55 90             	mov    -0x70(%ebp),%edx
c01052ec:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01052ef:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01052f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052f6:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01052fb:	39 c2                	cmp    %eax,%edx
c01052fd:	72 cd                	jb     c01052cc <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01052ff:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0105304:	c1 e0 05             	shl    $0x5,%eax
c0105307:	89 c2                	mov    %eax,%edx
c0105309:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c010530e:	01 d0                	add    %edx,%eax
c0105310:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0105313:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c010531a:	77 23                	ja     c010533f <page_init+0x23d>
c010531c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010531f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105323:	c7 44 24 08 10 cb 10 	movl   $0xc010cb10,0x8(%esp)
c010532a:	c0 
c010532b:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0105332:	00 
c0105333:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c010533a:	e8 96 ba ff ff       	call   c0100dd5 <__panic>
c010533f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105342:	05 00 00 00 40       	add    $0x40000000,%eax
c0105347:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010534a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105351:	e9 74 01 00 00       	jmp    c01054ca <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0105356:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105359:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010535c:	89 d0                	mov    %edx,%eax
c010535e:	c1 e0 02             	shl    $0x2,%eax
c0105361:	01 d0                	add    %edx,%eax
c0105363:	c1 e0 02             	shl    $0x2,%eax
c0105366:	01 c8                	add    %ecx,%eax
c0105368:	8b 50 08             	mov    0x8(%eax),%edx
c010536b:	8b 40 04             	mov    0x4(%eax),%eax
c010536e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105371:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105374:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105377:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010537a:	89 d0                	mov    %edx,%eax
c010537c:	c1 e0 02             	shl    $0x2,%eax
c010537f:	01 d0                	add    %edx,%eax
c0105381:	c1 e0 02             	shl    $0x2,%eax
c0105384:	01 c8                	add    %ecx,%eax
c0105386:	8b 48 0c             	mov    0xc(%eax),%ecx
c0105389:	8b 58 10             	mov    0x10(%eax),%ebx
c010538c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010538f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105392:	01 c8                	add    %ecx,%eax
c0105394:	11 da                	adc    %ebx,%edx
c0105396:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105399:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010539c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010539f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053a2:	89 d0                	mov    %edx,%eax
c01053a4:	c1 e0 02             	shl    $0x2,%eax
c01053a7:	01 d0                	add    %edx,%eax
c01053a9:	c1 e0 02             	shl    $0x2,%eax
c01053ac:	01 c8                	add    %ecx,%eax
c01053ae:	83 c0 14             	add    $0x14,%eax
c01053b1:	8b 00                	mov    (%eax),%eax
c01053b3:	83 f8 01             	cmp    $0x1,%eax
c01053b6:	0f 85 0a 01 00 00    	jne    c01054c6 <page_init+0x3c4>
            if (begin < freemem) {
c01053bc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01053bf:	ba 00 00 00 00       	mov    $0x0,%edx
c01053c4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01053c7:	72 17                	jb     c01053e0 <page_init+0x2de>
c01053c9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01053cc:	77 05                	ja     c01053d3 <page_init+0x2d1>
c01053ce:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01053d1:	76 0d                	jbe    c01053e0 <page_init+0x2de>
                begin = freemem;
c01053d3:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01053d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01053d9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01053e0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01053e4:	72 1d                	jb     c0105403 <page_init+0x301>
c01053e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01053ea:	77 09                	ja     c01053f5 <page_init+0x2f3>
c01053ec:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01053f3:	76 0e                	jbe    c0105403 <page_init+0x301>
                end = KMEMSIZE;
c01053f5:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01053fc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0105403:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105406:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105409:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010540c:	0f 87 b4 00 00 00    	ja     c01054c6 <page_init+0x3c4>
c0105412:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105415:	72 09                	jb     c0105420 <page_init+0x31e>
c0105417:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010541a:	0f 83 a6 00 00 00    	jae    c01054c6 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0105420:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0105427:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010542a:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010542d:	01 d0                	add    %edx,%eax
c010542f:	83 e8 01             	sub    $0x1,%eax
c0105432:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105435:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105438:	ba 00 00 00 00       	mov    $0x0,%edx
c010543d:	f7 75 9c             	divl   -0x64(%ebp)
c0105440:	89 d0                	mov    %edx,%eax
c0105442:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105445:	29 c2                	sub    %eax,%edx
c0105447:	89 d0                	mov    %edx,%eax
c0105449:	ba 00 00 00 00       	mov    $0x0,%edx
c010544e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105451:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0105454:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105457:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010545a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010545d:	ba 00 00 00 00       	mov    $0x0,%edx
c0105462:	89 c7                	mov    %eax,%edi
c0105464:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010546a:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010546d:	89 d0                	mov    %edx,%eax
c010546f:	83 e0 00             	and    $0x0,%eax
c0105472:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0105475:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105478:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010547b:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010547e:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0105481:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105484:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105487:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010548a:	77 3a                	ja     c01054c6 <page_init+0x3c4>
c010548c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010548f:	72 05                	jb     c0105496 <page_init+0x394>
c0105491:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105494:	73 30                	jae    c01054c6 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0105496:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0105499:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010549c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010549f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01054a2:	29 c8                	sub    %ecx,%eax
c01054a4:	19 da                	sbb    %ebx,%edx
c01054a6:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01054aa:	c1 ea 0c             	shr    $0xc,%edx
c01054ad:	89 c3                	mov    %eax,%ebx
c01054af:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054b2:	89 04 24             	mov    %eax,(%esp)
c01054b5:	e8 8c f8 ff ff       	call   c0104d46 <pa2page>
c01054ba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01054be:	89 04 24             	mov    %eax,(%esp)
c01054c1:	e8 55 fb ff ff       	call   c010501b <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01054c6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01054ca:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01054cd:	8b 00                	mov    (%eax),%eax
c01054cf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01054d2:	0f 8f 7e fe ff ff    	jg     c0105356 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01054d8:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01054de:	5b                   	pop    %ebx
c01054df:	5e                   	pop    %esi
c01054e0:	5f                   	pop    %edi
c01054e1:	5d                   	pop    %ebp
c01054e2:	c3                   	ret    

c01054e3 <enable_paging>:

static void
enable_paging(void) {
c01054e3:	55                   	push   %ebp
c01054e4:	89 e5                	mov    %esp,%ebp
c01054e6:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01054e9:	a1 c8 ef 19 c0       	mov    0xc019efc8,%eax
c01054ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01054f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01054f4:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01054f7:	0f 20 c0             	mov    %cr0,%eax
c01054fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01054fd:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0105500:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0105503:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010550a:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c010550e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105511:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0105514:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105517:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010551a:	c9                   	leave  
c010551b:	c3                   	ret    

c010551c <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010551c:	55                   	push   %ebp
c010551d:	89 e5                	mov    %esp,%ebp
c010551f:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0105522:	8b 45 14             	mov    0x14(%ebp),%eax
c0105525:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105528:	31 d0                	xor    %edx,%eax
c010552a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010552f:	85 c0                	test   %eax,%eax
c0105531:	74 24                	je     c0105557 <boot_map_segment+0x3b>
c0105533:	c7 44 24 0c 42 cb 10 	movl   $0xc010cb42,0xc(%esp)
c010553a:	c0 
c010553b:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0105542:	c0 
c0105543:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c010554a:	00 
c010554b:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105552:	e8 7e b8 ff ff       	call   c0100dd5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0105557:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010555e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105561:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105566:	89 c2                	mov    %eax,%edx
c0105568:	8b 45 10             	mov    0x10(%ebp),%eax
c010556b:	01 c2                	add    %eax,%edx
c010556d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105570:	01 d0                	add    %edx,%eax
c0105572:	83 e8 01             	sub    $0x1,%eax
c0105575:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105578:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010557b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105580:	f7 75 f0             	divl   -0x10(%ebp)
c0105583:	89 d0                	mov    %edx,%eax
c0105585:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105588:	29 c2                	sub    %eax,%edx
c010558a:	89 d0                	mov    %edx,%eax
c010558c:	c1 e8 0c             	shr    $0xc,%eax
c010558f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0105592:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105595:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105598:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010559b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01055a0:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01055a3:	8b 45 14             	mov    0x14(%ebp),%eax
c01055a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01055b1:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01055b4:	eb 6b                	jmp    c0105621 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01055b6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01055bd:	00 
c01055be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c8:	89 04 24             	mov    %eax,(%esp)
c01055cb:	e8 d1 01 00 00       	call   c01057a1 <get_pte>
c01055d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01055d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01055d7:	75 24                	jne    c01055fd <boot_map_segment+0xe1>
c01055d9:	c7 44 24 0c 6e cb 10 	movl   $0xc010cb6e,0xc(%esp)
c01055e0:	c0 
c01055e1:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01055e8:	c0 
c01055e9:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01055f0:	00 
c01055f1:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01055f8:	e8 d8 b7 ff ff       	call   c0100dd5 <__panic>
        *ptep = pa | PTE_P | perm;
c01055fd:	8b 45 18             	mov    0x18(%ebp),%eax
c0105600:	8b 55 14             	mov    0x14(%ebp),%edx
c0105603:	09 d0                	or     %edx,%eax
c0105605:	83 c8 01             	or     $0x1,%eax
c0105608:	89 c2                	mov    %eax,%edx
c010560a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010560d:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010560f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0105613:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010561a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0105621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105625:	75 8f                	jne    c01055b6 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0105627:	c9                   	leave  
c0105628:	c3                   	ret    

c0105629 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0105629:	55                   	push   %ebp
c010562a:	89 e5                	mov    %esp,%ebp
c010562c:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010562f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105636:	e8 ff f9 ff ff       	call   c010503a <alloc_pages>
c010563b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010563e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105642:	75 1c                	jne    c0105660 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0105644:	c7 44 24 08 7b cb 10 	movl   $0xc010cb7b,0x8(%esp)
c010564b:	c0 
c010564c:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0105653:	00 
c0105654:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c010565b:	e8 75 b7 ff ff       	call   c0100dd5 <__panic>
    }
    return page2kva(p);
c0105660:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105663:	89 04 24             	mov    %eax,(%esp)
c0105666:	e8 20 f7 ff ff       	call   c0104d8b <page2kva>
}
c010566b:	c9                   	leave  
c010566c:	c3                   	ret    

c010566d <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010566d:	55                   	push   %ebp
c010566e:	89 e5                	mov    %esp,%ebp
c0105670:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105673:	e8 70 f9 ff ff       	call   c0104fe8 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0105678:	e8 85 fa ff ff       	call   c0105102 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010567d:	e8 64 09 00 00       	call   c0105fe6 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0105682:	e8 a2 ff ff ff       	call   c0105629 <boot_alloc_page>
c0105687:	a3 e4 ce 19 c0       	mov    %eax,0xc019cee4
    memset(boot_pgdir, 0, PGSIZE);
c010568c:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0105691:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105698:	00 
c0105699:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01056a0:	00 
c01056a1:	89 04 24             	mov    %eax,(%esp)
c01056a4:	e8 83 64 00 00       	call   c010bb2c <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01056a9:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01056ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056b1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01056b8:	77 23                	ja     c01056dd <pmm_init+0x70>
c01056ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01056c1:	c7 44 24 08 10 cb 10 	movl   $0xc010cb10,0x8(%esp)
c01056c8:	c0 
c01056c9:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c01056d0:	00 
c01056d1:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01056d8:	e8 f8 b6 ff ff       	call   c0100dd5 <__panic>
c01056dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056e0:	05 00 00 00 40       	add    $0x40000000,%eax
c01056e5:	a3 c8 ef 19 c0       	mov    %eax,0xc019efc8

    check_pgdir();
c01056ea:	e8 15 09 00 00       	call   c0106004 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01056ef:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01056f4:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01056fa:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01056ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105702:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105709:	77 23                	ja     c010572e <pmm_init+0xc1>
c010570b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010570e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105712:	c7 44 24 08 10 cb 10 	movl   $0xc010cb10,0x8(%esp)
c0105719:	c0 
c010571a:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c0105721:	00 
c0105722:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105729:	e8 a7 b6 ff ff       	call   c0100dd5 <__panic>
c010572e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105731:	05 00 00 00 40       	add    $0x40000000,%eax
c0105736:	83 c8 03             	or     $0x3,%eax
c0105739:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010573b:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0105740:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0105747:	00 
c0105748:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010574f:	00 
c0105750:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0105757:	38 
c0105758:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010575f:	c0 
c0105760:	89 04 24             	mov    %eax,(%esp)
c0105763:	e8 b4 fd ff ff       	call   c010551c <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0105768:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010576d:	8b 15 e4 ce 19 c0    	mov    0xc019cee4,%edx
c0105773:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0105779:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010577b:	e8 63 fd ff ff       	call   c01054e3 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0105780:	e8 74 f7 ff ff       	call   c0104ef9 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0105785:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010578a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0105790:	e8 0a 0f 00 00       	call   c010669f <check_boot_pgdir>

    print_pgdir();
c0105795:	e8 97 13 00 00       	call   c0106b31 <print_pgdir>
    
    kmalloc_init();
c010579a:	e8 e6 f2 ff ff       	call   c0104a85 <kmalloc_init>

}
c010579f:	c9                   	leave  
c01057a0:	c3                   	ret    

c01057a1 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01057a1:	55                   	push   %ebp
c01057a2:	89 e5                	mov    %esp,%ebp
c01057a4:	83 ec 38             	sub    $0x38,%esp
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */

	// 获取页目录表（一级页表）
	pde_t *pdep = &pgdir[PDX(la)];   // (1) find page directory entry
c01057a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057aa:	c1 e8 16             	shr    $0x16,%eax
c01057ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01057b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b7:	01 d0                	add    %edx,%eax
c01057b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// 页表、页目录表不存在
	if (!(PTE_P & *pdep)) {              // (2) check if entry is not present
c01057bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057bf:	8b 00                	mov    (%eax),%eax
c01057c1:	83 e0 01             	and    $0x1,%eax
c01057c4:	85 c0                	test   %eax,%eax
c01057c6:	0f 85 b6 00 00 00    	jne    c0105882 <get_pte+0xe1>
		struct Page *page = NULL;
c01057cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		// 如果不需要create或者alloc_page失败
		if(!create || (page = alloc_page()) == NULL) {				  // (3) check if creating is needed, then alloc page for page table
c01057d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01057d7:	74 15                	je     c01057ee <get_pte+0x4d>
c01057d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01057e0:	e8 55 f8 ff ff       	call   c010503a <alloc_pages>
c01057e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01057ec:	75 0a                	jne    c01057f8 <get_pte+0x57>
			return NULL;
c01057ee:	b8 00 00 00 00       	mov    $0x0,%eax
c01057f3:	e9 e6 00 00 00       	jmp    c01058de <get_pte+0x13d>
		}                  // CAUTION: this page is used for page table, not for common data page
		// 到这里，如果需要create的话，就已经执行过alloc了
		// 引用数+1
		set_page_ref(page,1);					// (4) set page reference
c01057f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01057ff:	00 
c0105800:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105803:	89 04 24             	mov    %eax,(%esp)
c0105806:	e8 34 f6 ff ff       	call   c0104e3f <set_page_ref>
		// 获得线性地址
		uintptr_t pa = page2pa(page); 			// (5) get linear address of page
c010580b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010580e:	89 04 24             	mov    %eax,(%esp)
c0105811:	e8 1a f5 ff ff       	call   c0104d30 <page2pa>
c0105816:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// If you need to visit a physical address, please use KADDR()
		// KADDR(pa)将物理地址转换为内核虚拟地址，第二个参数将这一页清空，第三个参数是4096也就是一页的大小
		memset(KADDR(pa), 0, PGSIZE);      		// (6) clear page content using memset
c0105819:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010581c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010581f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105822:	c1 e8 0c             	shr    $0xc,%eax
c0105825:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105828:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c010582d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105830:	72 23                	jb     c0105855 <get_pte+0xb4>
c0105832:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105835:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105839:	c7 44 24 08 6c ca 10 	movl   $0xc010ca6c,0x8(%esp)
c0105840:	c0 
c0105841:	c7 44 24 04 94 01 00 	movl   $0x194,0x4(%esp)
c0105848:	00 
c0105849:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105850:	e8 80 b5 ff ff       	call   c0100dd5 <__panic>
c0105855:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105858:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010585d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105864:	00 
c0105865:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010586c:	00 
c010586d:	89 04 24             	mov    %eax,(%esp)
c0105870:	e8 b7 62 00 00       	call   c010bb2c <memset>
		// 页目录项内容 = (页表起始物理地址 &0x0FFF) | PTE_U | PTE_W | PTE_P
		*pdep = pa | PTE_U | PTE_W | PTE_P;		// (7) set page directory entry's permission
c0105875:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105878:	83 c8 07             	or     $0x7,%eax
c010587b:	89 c2                	mov    %eax,%edx
c010587d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105880:	89 10                	mov    %edx,(%eax)
	}
	// 返回pte_t *，页表的地址
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0105882:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105885:	8b 00                	mov    (%eax),%eax
c0105887:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010588c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010588f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105892:	c1 e8 0c             	shr    $0xc,%eax
c0105895:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105898:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c010589d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01058a0:	72 23                	jb     c01058c5 <get_pte+0x124>
c01058a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058a9:	c7 44 24 08 6c ca 10 	movl   $0xc010ca6c,0x8(%esp)
c01058b0:	c0 
c01058b1:	c7 44 24 04 99 01 00 	movl   $0x199,0x4(%esp)
c01058b8:	00 
c01058b9:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01058c0:	e8 10 b5 ff ff       	call   c0100dd5 <__panic>
c01058c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058c8:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01058cd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058d0:	c1 ea 0c             	shr    $0xc,%edx
c01058d3:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01058d9:	c1 e2 02             	shl    $0x2,%edx
c01058dc:	01 d0                	add    %edx,%eax
	// 不用再返回NULL了，前面如果不需要create或者alloc失败就会返回NULL
	//return NULL;          // (8) return page table entry


}
c01058de:	c9                   	leave  
c01058df:	c3                   	ret    

c01058e0 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01058e0:	55                   	push   %ebp
c01058e1:	89 e5                	mov    %esp,%ebp
c01058e3:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01058e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01058ed:	00 
c01058ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f8:	89 04 24             	mov    %eax,(%esp)
c01058fb:	e8 a1 fe ff ff       	call   c01057a1 <get_pte>
c0105900:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0105903:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105907:	74 08                	je     c0105911 <get_page+0x31>
        *ptep_store = ptep;
c0105909:	8b 45 10             	mov    0x10(%ebp),%eax
c010590c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010590f:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0105911:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105915:	74 1b                	je     c0105932 <get_page+0x52>
c0105917:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010591a:	8b 00                	mov    (%eax),%eax
c010591c:	83 e0 01             	and    $0x1,%eax
c010591f:	85 c0                	test   %eax,%eax
c0105921:	74 0f                	je     c0105932 <get_page+0x52>
        return pa2page(*ptep);
c0105923:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105926:	8b 00                	mov    (%eax),%eax
c0105928:	89 04 24             	mov    %eax,(%esp)
c010592b:	e8 16 f4 ff ff       	call   c0104d46 <pa2page>
c0105930:	eb 05                	jmp    c0105937 <get_page+0x57>
    }
    return NULL;
c0105932:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105937:	c9                   	leave  
c0105938:	c3                   	ret    

c0105939 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105939:	55                   	push   %ebp
c010593a:	89 e5                	mov    %esp,%ebp
c010593c:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif

    if (*ptep & PTE_P) {                      //(1) check if this page table entry is present（存在）
c010593f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105942:	8b 00                	mov    (%eax),%eax
c0105944:	83 e0 01             	and    $0x1,%eax
c0105947:	85 c0                	test   %eax,%eax
c0105949:	74 4d                	je     c0105998 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
c010594b:	8b 45 10             	mov    0x10(%ebp),%eax
c010594e:	8b 00                	mov    (%eax),%eax
c0105950:	89 04 24             	mov    %eax,(%esp)
c0105953:	e8 87 f4 ff ff       	call   c0104ddf <pte2page>
c0105958:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {               //(3) decrease page reference
c010595b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010595e:	89 04 24             	mov    %eax,(%esp)
c0105961:	e8 fd f4 ff ff       	call   c0104e63 <page_ref_dec>
c0105966:	85 c0                	test   %eax,%eax
c0105968:	75 13                	jne    c010597d <page_remove_pte+0x44>
        	free_page(page);
c010596a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105971:	00 
c0105972:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105975:	89 04 24             	mov    %eax,(%esp)
c0105978:	e8 28 f7 ff ff       	call   c01050a5 <free_pages>
        }
        *ptep = 0;						  //(4) and free this page when page reference reachs 0
c010597d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105980:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                                  	  	  //(5) clear second page table entry
        tlb_invalidate(pgdir, la);  	  //(6) flush tlb
c0105986:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105989:	89 44 24 04          	mov    %eax,0x4(%esp)
c010598d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105990:	89 04 24             	mov    %eax,(%esp)
c0105993:	e8 1d 05 00 00       	call   c0105eb5 <tlb_invalidate>
    }
}
c0105998:	c9                   	leave  
c0105999:	c3                   	ret    

c010599a <unmap_range>:


void
unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c010599a:	55                   	push   %ebp
c010599b:	89 e5                	mov    %esp,%ebp
c010599d:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c01059a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059a3:	25 ff 0f 00 00       	and    $0xfff,%eax
c01059a8:	85 c0                	test   %eax,%eax
c01059aa:	75 0c                	jne    c01059b8 <unmap_range+0x1e>
c01059ac:	8b 45 10             	mov    0x10(%ebp),%eax
c01059af:	25 ff 0f 00 00       	and    $0xfff,%eax
c01059b4:	85 c0                	test   %eax,%eax
c01059b6:	74 24                	je     c01059dc <unmap_range+0x42>
c01059b8:	c7 44 24 0c 94 cb 10 	movl   $0xc010cb94,0xc(%esp)
c01059bf:	c0 
c01059c0:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01059c7:	c0 
c01059c8:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c01059cf:	00 
c01059d0:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01059d7:	e8 f9 b3 ff ff       	call   c0100dd5 <__panic>
    assert(USER_ACCESS(start, end));
c01059dc:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c01059e3:	76 11                	jbe    c01059f6 <unmap_range+0x5c>
c01059e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e8:	3b 45 10             	cmp    0x10(%ebp),%eax
c01059eb:	73 09                	jae    c01059f6 <unmap_range+0x5c>
c01059ed:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c01059f4:	76 24                	jbe    c0105a1a <unmap_range+0x80>
c01059f6:	c7 44 24 0c bd cb 10 	movl   $0xc010cbbd,0xc(%esp)
c01059fd:	c0 
c01059fe:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0105a05:	c0 
c0105a06:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c0105a0d:	00 
c0105a0e:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105a15:	e8 bb b3 ff ff       	call   c0100dd5 <__panic>

    do {
        pte_t *ptep = get_pte(pgdir, start, 0);
c0105a1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a21:	00 
c0105a22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a2c:	89 04 24             	mov    %eax,(%esp)
c0105a2f:	e8 6d fd ff ff       	call   c01057a1 <get_pte>
c0105a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105a37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105a3b:	75 18                	jne    c0105a55 <unmap_range+0xbb>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a40:	05 00 00 40 00       	add    $0x400000,%eax
c0105a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a4b:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105a50:	89 45 0c             	mov    %eax,0xc(%ebp)
            continue ;
c0105a53:	eb 29                	jmp    c0105a7e <unmap_range+0xe4>
        }
        if (*ptep != 0) {
c0105a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a58:	8b 00                	mov    (%eax),%eax
c0105a5a:	85 c0                	test   %eax,%eax
c0105a5c:	74 19                	je     c0105a77 <unmap_range+0xdd>
            page_remove_pte(pgdir, start, ptep);
c0105a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a61:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a65:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a6f:	89 04 24             	mov    %eax,(%esp)
c0105a72:	e8 c2 fe ff ff       	call   c0105939 <page_remove_pte>
        }
        start += PGSIZE;
c0105a77:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
    } while (start != 0 && start < end);
c0105a7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105a82:	74 08                	je     c0105a8c <unmap_range+0xf2>
c0105a84:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a87:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105a8a:	72 8e                	jb     c0105a1a <unmap_range+0x80>
}
c0105a8c:	c9                   	leave  
c0105a8d:	c3                   	ret    

c0105a8e <exit_range>:

void
exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c0105a8e:	55                   	push   %ebp
c0105a8f:	89 e5                	mov    %esp,%ebp
c0105a91:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105a94:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a97:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105a9c:	85 c0                	test   %eax,%eax
c0105a9e:	75 0c                	jne    c0105aac <exit_range+0x1e>
c0105aa0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aa3:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105aa8:	85 c0                	test   %eax,%eax
c0105aaa:	74 24                	je     c0105ad0 <exit_range+0x42>
c0105aac:	c7 44 24 0c 94 cb 10 	movl   $0xc010cb94,0xc(%esp)
c0105ab3:	c0 
c0105ab4:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0105abb:	c0 
c0105abc:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0105ac3:	00 
c0105ac4:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105acb:	e8 05 b3 ff ff       	call   c0100dd5 <__panic>
    assert(USER_ACCESS(start, end));
c0105ad0:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0105ad7:	76 11                	jbe    c0105aea <exit_range+0x5c>
c0105ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105adc:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105adf:	73 09                	jae    c0105aea <exit_range+0x5c>
c0105ae1:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c0105ae8:	76 24                	jbe    c0105b0e <exit_range+0x80>
c0105aea:	c7 44 24 0c bd cb 10 	movl   $0xc010cbbd,0xc(%esp)
c0105af1:	c0 
c0105af2:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0105af9:	c0 
c0105afa:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0105b01:	00 
c0105b02:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105b09:	e8 c7 b2 ff ff       	call   c0100dd5 <__panic>

    start = ROUNDDOWN(start, PTSIZE);
c0105b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b17:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105b1c:	89 45 0c             	mov    %eax,0xc(%ebp)
    do {
        int pde_idx = PDX(start);
c0105b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b22:	c1 e8 16             	shr    $0x16,%eax
c0105b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (pgdir[pde_idx] & PTE_P) {
c0105b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105b32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b35:	01 d0                	add    %edx,%eax
c0105b37:	8b 00                	mov    (%eax),%eax
c0105b39:	83 e0 01             	and    $0x1,%eax
c0105b3c:	85 c0                	test   %eax,%eax
c0105b3e:	74 3e                	je     c0105b7e <exit_range+0xf0>
            free_page(pde2page(pgdir[pde_idx]));
c0105b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105b4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4d:	01 d0                	add    %edx,%eax
c0105b4f:	8b 00                	mov    (%eax),%eax
c0105b51:	89 04 24             	mov    %eax,(%esp)
c0105b54:	e8 c4 f2 ff ff       	call   c0104e1d <pde2page>
c0105b59:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105b60:	00 
c0105b61:	89 04 24             	mov    %eax,(%esp)
c0105b64:	e8 3c f5 ff ff       	call   c01050a5 <free_pages>
            pgdir[pde_idx] = 0;
c0105b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b6c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b76:	01 d0                	add    %edx,%eax
c0105b78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        }
        start += PTSIZE;
c0105b7e:	81 45 0c 00 00 40 00 	addl   $0x400000,0xc(%ebp)
    } while (start != 0 && start < end);
c0105b85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105b89:	74 08                	je     c0105b93 <exit_range+0x105>
c0105b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b8e:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105b91:	72 8c                	jb     c0105b1f <exit_range+0x91>
}
c0105b93:	c9                   	leave  
c0105b94:	c3                   	ret    

c0105b95 <copy_range>:
 * @share: flags to indicate to dup OR share. We just use dup method, so it didn't be used.
 *
 * CALL GRAPH: copy_mm-->dup_mmap-->copy_range
 */
int
copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end, bool share) {
c0105b95:	55                   	push   %ebp
c0105b96:	89 e5                	mov    %esp,%ebp
c0105b98:	83 ec 48             	sub    $0x48,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105b9b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b9e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105ba3:	85 c0                	test   %eax,%eax
c0105ba5:	75 0c                	jne    c0105bb3 <copy_range+0x1e>
c0105ba7:	8b 45 14             	mov    0x14(%ebp),%eax
c0105baa:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105baf:	85 c0                	test   %eax,%eax
c0105bb1:	74 24                	je     c0105bd7 <copy_range+0x42>
c0105bb3:	c7 44 24 0c 94 cb 10 	movl   $0xc010cb94,0xc(%esp)
c0105bba:	c0 
c0105bbb:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0105bc2:	c0 
c0105bc3:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0105bca:	00 
c0105bcb:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105bd2:	e8 fe b1 ff ff       	call   c0100dd5 <__panic>
    assert(USER_ACCESS(start, end));
c0105bd7:	81 7d 10 ff ff 1f 00 	cmpl   $0x1fffff,0x10(%ebp)
c0105bde:	76 11                	jbe    c0105bf1 <copy_range+0x5c>
c0105be0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105be3:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105be6:	73 09                	jae    c0105bf1 <copy_range+0x5c>
c0105be8:	81 7d 14 00 00 00 b0 	cmpl   $0xb0000000,0x14(%ebp)
c0105bef:	76 24                	jbe    c0105c15 <copy_range+0x80>
c0105bf1:	c7 44 24 0c bd cb 10 	movl   $0xc010cbbd,0xc(%esp)
c0105bf8:	c0 
c0105bf9:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0105c00:	c0 
c0105c01:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0105c08:	00 
c0105c09:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105c10:	e8 c0 b1 ff ff       	call   c0100dd5 <__panic>
    // copy content by page unit.
    do {
        //call get_pte to find process A's pte according to the addr start
        pte_t *ptep = get_pte(from, start, 0), *nptep;
c0105c15:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c1c:	00 
c0105c1d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c27:	89 04 24             	mov    %eax,(%esp)
c0105c2a:	e8 72 fb ff ff       	call   c01057a1 <get_pte>
c0105c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105c36:	75 1b                	jne    c0105c53 <copy_range+0xbe>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105c38:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c3b:	05 00 00 40 00       	add    $0x400000,%eax
c0105c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c46:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105c4b:	89 45 10             	mov    %eax,0x10(%ebp)
            continue ;
c0105c4e:	e9 4c 01 00 00       	jmp    c0105d9f <copy_range+0x20a>
        }
        //call get_pte to find process B's pte according to the addr start. If pte is NULL, just alloc a PT
        if (*ptep & PTE_P) {
c0105c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c56:	8b 00                	mov    (%eax),%eax
c0105c58:	83 e0 01             	and    $0x1,%eax
c0105c5b:	85 c0                	test   %eax,%eax
c0105c5d:	0f 84 35 01 00 00    	je     c0105d98 <copy_range+0x203>
            if ((nptep = get_pte(to, start, 1)) == NULL) {
c0105c63:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105c6a:	00 
c0105c6b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c6e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c75:	89 04 24             	mov    %eax,(%esp)
c0105c78:	e8 24 fb ff ff       	call   c01057a1 <get_pte>
c0105c7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105c84:	75 0a                	jne    c0105c90 <copy_range+0xfb>
                return -E_NO_MEM;
c0105c86:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105c8b:	e9 26 01 00 00       	jmp    c0105db6 <copy_range+0x221>
            }
        uint32_t perm = (*ptep & PTE_USER);				// 本页面权限
c0105c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c93:	8b 00                	mov    (%eax),%eax
c0105c95:	83 e0 07             	and    $0x7,%eax
c0105c98:	89 45 e8             	mov    %eax,-0x18(%ebp)
        //get page from ptep
        struct Page *page = pte2page(*ptep);
c0105c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c9e:	8b 00                	mov    (%eax),%eax
c0105ca0:	89 04 24             	mov    %eax,(%esp)
c0105ca3:	e8 37 f1 ff ff       	call   c0104ddf <pte2page>
c0105ca8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        // alloc a page for process B
        struct Page *npage=alloc_page();
c0105cab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105cb2:	e8 83 f3 ff ff       	call   c010503a <alloc_pages>
c0105cb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(page!=NULL);
c0105cba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105cbe:	75 24                	jne    c0105ce4 <copy_range+0x14f>
c0105cc0:	c7 44 24 0c d5 cb 10 	movl   $0xc010cbd5,0xc(%esp)
c0105cc7:	c0 
c0105cc8:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0105ccf:	c0 
c0105cd0:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0105cd7:	00 
c0105cd8:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105cdf:	e8 f1 b0 ff ff       	call   c0100dd5 <__panic>
        assert(npage!=NULL);
c0105ce4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105ce8:	75 24                	jne    c0105d0e <copy_range+0x179>
c0105cea:	c7 44 24 0c e0 cb 10 	movl   $0xc010cbe0,0xc(%esp)
c0105cf1:	c0 
c0105cf2:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0105cf9:	c0 
c0105cfa:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0105d01:	00 
c0105d02:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105d09:	e8 c7 b0 ff ff       	call   c0100dd5 <__panic>
        int ret=0;
c0105d0e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
         * (1) find src_kvaddr: the kernel virtual address of page
         * (2) find dst_kvaddr: the kernel virtual address of npage
         * (3) memory copy from src_kvaddr to dst_kvaddr, size is PGSIZE
         * (4) build the map of phy addr of  nage with the linear addr start
         */
        char *src_kvaddr = page2kva(page);
c0105d15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d18:	89 04 24             	mov    %eax,(%esp)
c0105d1b:	e8 6b f0 ff ff       	call   c0104d8b <page2kva>
c0105d20:	89 45 d8             	mov    %eax,-0x28(%ebp)
        char *dst_kvaddr = page2kva(npage);
c0105d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d26:	89 04 24             	mov    %eax,(%esp)
c0105d29:	e8 5d f0 ff ff       	call   c0104d8b <page2kva>
c0105d2e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
c0105d31:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105d38:	00 
c0105d39:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105d43:	89 04 24             	mov    %eax,(%esp)
c0105d46:	e8 c3 5e 00 00       	call   c010bc0e <memcpy>
        ret = page_insert(to, npage, start, perm);				// 建立虚拟地址与线性地址映射
c0105d4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d52:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d55:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105d59:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d60:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d63:	89 04 24             	mov    %eax,(%esp)
c0105d66:	e8 91 00 00 00       	call   c0105dfc <page_insert>
c0105d6b:	89 45 dc             	mov    %eax,-0x24(%ebp)

        assert(ret == 0);
c0105d6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105d72:	74 24                	je     c0105d98 <copy_range+0x203>
c0105d74:	c7 44 24 0c ec cb 10 	movl   $0xc010cbec,0xc(%esp)
c0105d7b:	c0 
c0105d7c:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0105d83:	c0 
c0105d84:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0105d8b:	00 
c0105d8c:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105d93:	e8 3d b0 ff ff       	call   c0100dd5 <__panic>
        }
        start += PGSIZE;
c0105d98:	81 45 10 00 10 00 00 	addl   $0x1000,0x10(%ebp)
    } while (start != 0 && start < end);
c0105d9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105da3:	74 0c                	je     c0105db1 <copy_range+0x21c>
c0105da5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105da8:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105dab:	0f 82 64 fe ff ff    	jb     c0105c15 <copy_range+0x80>
    return 0;
c0105db1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105db6:	c9                   	leave  
c0105db7:	c3                   	ret    

c0105db8 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105db8:	55                   	push   %ebp
c0105db9:	89 e5                	mov    %esp,%ebp
c0105dbb:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105dbe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105dc5:	00 
c0105dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105dcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd0:	89 04 24             	mov    %eax,(%esp)
c0105dd3:	e8 c9 f9 ff ff       	call   c01057a1 <get_pte>
c0105dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105ddf:	74 19                	je     c0105dfa <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105de4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105de8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105deb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105def:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df2:	89 04 24             	mov    %eax,(%esp)
c0105df5:	e8 3f fb ff ff       	call   c0105939 <page_remove_pte>
    }
}
c0105dfa:	c9                   	leave  
c0105dfb:	c3                   	ret    

c0105dfc <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105dfc:	55                   	push   %ebp
c0105dfd:	89 e5                	mov    %esp,%ebp
c0105dff:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105e02:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105e09:	00 
c0105e0a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e11:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e14:	89 04 24             	mov    %eax,(%esp)
c0105e17:	e8 85 f9 ff ff       	call   c01057a1 <get_pte>
c0105e1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105e1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105e23:	75 0a                	jne    c0105e2f <page_insert+0x33>
        return -E_NO_MEM;
c0105e25:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105e2a:	e9 84 00 00 00       	jmp    c0105eb3 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e32:	89 04 24             	mov    %eax,(%esp)
c0105e35:	e8 12 f0 ff ff       	call   c0104e4c <page_ref_inc>
    if (*ptep & PTE_P) {
c0105e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e3d:	8b 00                	mov    (%eax),%eax
c0105e3f:	83 e0 01             	and    $0x1,%eax
c0105e42:	85 c0                	test   %eax,%eax
c0105e44:	74 3e                	je     c0105e84 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e49:	8b 00                	mov    (%eax),%eax
c0105e4b:	89 04 24             	mov    %eax,(%esp)
c0105e4e:	e8 8c ef ff ff       	call   c0104ddf <pte2page>
c0105e53:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e59:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105e5c:	75 0d                	jne    c0105e6b <page_insert+0x6f>
            page_ref_dec(page);
c0105e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e61:	89 04 24             	mov    %eax,(%esp)
c0105e64:	e8 fa ef ff ff       	call   c0104e63 <page_ref_dec>
c0105e69:	eb 19                	jmp    c0105e84 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e6e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e72:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e79:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e7c:	89 04 24             	mov    %eax,(%esp)
c0105e7f:	e8 b5 fa ff ff       	call   c0105939 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105e84:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e87:	89 04 24             	mov    %eax,(%esp)
c0105e8a:	e8 a1 ee ff ff       	call   c0104d30 <page2pa>
c0105e8f:	0b 45 14             	or     0x14(%ebp),%eax
c0105e92:	83 c8 01             	or     $0x1,%eax
c0105e95:	89 c2                	mov    %eax,%edx
c0105e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e9a:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105e9c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e9f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ea3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea6:	89 04 24             	mov    %eax,(%esp)
c0105ea9:	e8 07 00 00 00       	call   c0105eb5 <tlb_invalidate>
    return 0;
c0105eae:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105eb3:	c9                   	leave  
c0105eb4:	c3                   	ret    

c0105eb5 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105eb5:	55                   	push   %ebp
c0105eb6:	89 e5                	mov    %esp,%ebp
c0105eb8:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105ebb:	0f 20 d8             	mov    %cr3,%eax
c0105ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105ec4:	89 c2                	mov    %eax,%edx
c0105ec6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ecc:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105ed3:	77 23                	ja     c0105ef8 <tlb_invalidate+0x43>
c0105ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ed8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105edc:	c7 44 24 08 10 cb 10 	movl   $0xc010cb10,0x8(%esp)
c0105ee3:	c0 
c0105ee4:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c0105eeb:	00 
c0105eec:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105ef3:	e8 dd ae ff ff       	call   c0100dd5 <__panic>
c0105ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105efb:	05 00 00 00 40       	add    $0x40000000,%eax
c0105f00:	39 c2                	cmp    %eax,%edx
c0105f02:	75 0c                	jne    c0105f10 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105f04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f07:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f0d:	0f 01 38             	invlpg (%eax)
    }
}
c0105f10:	c9                   	leave  
c0105f11:	c3                   	ret    

c0105f12 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105f12:	55                   	push   %ebp
c0105f13:	89 e5                	mov    %esp,%ebp
c0105f15:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105f18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105f1f:	e8 16 f1 ff ff       	call   c010503a <alloc_pages>
c0105f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105f27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105f2b:	0f 84 b0 00 00 00    	je     c0105fe1 <pgdir_alloc_page+0xcf>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0105f31:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f34:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105f38:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f3b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f46:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f49:	89 04 24             	mov    %eax,(%esp)
c0105f4c:	e8 ab fe ff ff       	call   c0105dfc <page_insert>
c0105f51:	85 c0                	test   %eax,%eax
c0105f53:	74 1a                	je     c0105f6f <pgdir_alloc_page+0x5d>
            free_page(page);
c0105f55:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105f5c:	00 
c0105f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f60:	89 04 24             	mov    %eax,(%esp)
c0105f63:	e8 3d f1 ff ff       	call   c01050a5 <free_pages>
            return NULL;
c0105f68:	b8 00 00 00 00       	mov    $0x0,%eax
c0105f6d:	eb 75                	jmp    c0105fe4 <pgdir_alloc_page+0xd2>
        }
        if (swap_init_ok){
c0105f6f:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c0105f74:	85 c0                	test   %eax,%eax
c0105f76:	74 69                	je     c0105fe1 <pgdir_alloc_page+0xcf>
            if(check_mm_struct!=NULL) {
c0105f78:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0105f7d:	85 c0                	test   %eax,%eax
c0105f7f:	74 60                	je     c0105fe1 <pgdir_alloc_page+0xcf>
                swap_map_swappable(check_mm_struct, la, page, 0);
c0105f81:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0105f86:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105f8d:	00 
c0105f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f91:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105f95:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105f98:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105f9c:	89 04 24             	mov    %eax,(%esp)
c0105f9f:	e8 3e 0e 00 00       	call   c0106de2 <swap_map_swappable>
                page->pra_vaddr=la;
c0105fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105faa:	89 50 1c             	mov    %edx,0x1c(%eax)
                assert(page_ref(page) == 1);
c0105fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fb0:	89 04 24             	mov    %eax,(%esp)
c0105fb3:	e8 7d ee ff ff       	call   c0104e35 <page_ref>
c0105fb8:	83 f8 01             	cmp    $0x1,%eax
c0105fbb:	74 24                	je     c0105fe1 <pgdir_alloc_page+0xcf>
c0105fbd:	c7 44 24 0c f5 cb 10 	movl   $0xc010cbf5,0xc(%esp)
c0105fc4:	c0 
c0105fc5:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0105fcc:	c0 
c0105fcd:	c7 44 24 04 71 02 00 	movl   $0x271,0x4(%esp)
c0105fd4:	00 
c0105fd5:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0105fdc:	e8 f4 ad ff ff       	call   c0100dd5 <__panic>
            }
        }

    }

    return page;
c0105fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105fe4:	c9                   	leave  
c0105fe5:	c3                   	ret    

c0105fe6 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105fe6:	55                   	push   %ebp
c0105fe7:	89 e5                	mov    %esp,%ebp
c0105fe9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105fec:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0105ff1:	8b 40 18             	mov    0x18(%eax),%eax
c0105ff4:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105ff6:	c7 04 24 0c cc 10 c0 	movl   $0xc010cc0c,(%esp)
c0105ffd:	e8 51 a3 ff ff       	call   c0100353 <cprintf>
}
c0106002:	c9                   	leave  
c0106003:	c3                   	ret    

c0106004 <check_pgdir>:

static void
check_pgdir(void) {
c0106004:	55                   	push   %ebp
c0106005:	89 e5                	mov    %esp,%ebp
c0106007:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010600a:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c010600f:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0106014:	76 24                	jbe    c010603a <check_pgdir+0x36>
c0106016:	c7 44 24 0c 2b cc 10 	movl   $0xc010cc2b,0xc(%esp)
c010601d:	c0 
c010601e:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106025:	c0 
c0106026:	c7 44 24 04 89 02 00 	movl   $0x289,0x4(%esp)
c010602d:	00 
c010602e:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106035:	e8 9b ad ff ff       	call   c0100dd5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010603a:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010603f:	85 c0                	test   %eax,%eax
c0106041:	74 0e                	je     c0106051 <check_pgdir+0x4d>
c0106043:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106048:	25 ff 0f 00 00       	and    $0xfff,%eax
c010604d:	85 c0                	test   %eax,%eax
c010604f:	74 24                	je     c0106075 <check_pgdir+0x71>
c0106051:	c7 44 24 0c 48 cc 10 	movl   $0xc010cc48,0xc(%esp)
c0106058:	c0 
c0106059:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106060:	c0 
c0106061:	c7 44 24 04 8a 02 00 	movl   $0x28a,0x4(%esp)
c0106068:	00 
c0106069:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106070:	e8 60 ad ff ff       	call   c0100dd5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0106075:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010607a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106081:	00 
c0106082:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0106089:	00 
c010608a:	89 04 24             	mov    %eax,(%esp)
c010608d:	e8 4e f8 ff ff       	call   c01058e0 <get_page>
c0106092:	85 c0                	test   %eax,%eax
c0106094:	74 24                	je     c01060ba <check_pgdir+0xb6>
c0106096:	c7 44 24 0c 80 cc 10 	movl   $0xc010cc80,0xc(%esp)
c010609d:	c0 
c010609e:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01060a5:	c0 
c01060a6:	c7 44 24 04 8b 02 00 	movl   $0x28b,0x4(%esp)
c01060ad:	00 
c01060ae:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01060b5:	e8 1b ad ff ff       	call   c0100dd5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01060ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01060c1:	e8 74 ef ff ff       	call   c010503a <alloc_pages>
c01060c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01060c9:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01060ce:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01060d5:	00 
c01060d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01060dd:	00 
c01060de:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01060e1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01060e5:	89 04 24             	mov    %eax,(%esp)
c01060e8:	e8 0f fd ff ff       	call   c0105dfc <page_insert>
c01060ed:	85 c0                	test   %eax,%eax
c01060ef:	74 24                	je     c0106115 <check_pgdir+0x111>
c01060f1:	c7 44 24 0c a8 cc 10 	movl   $0xc010cca8,0xc(%esp)
c01060f8:	c0 
c01060f9:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106100:	c0 
c0106101:	c7 44 24 04 8f 02 00 	movl   $0x28f,0x4(%esp)
c0106108:	00 
c0106109:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106110:	e8 c0 ac ff ff       	call   c0100dd5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0106115:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010611a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106121:	00 
c0106122:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0106129:	00 
c010612a:	89 04 24             	mov    %eax,(%esp)
c010612d:	e8 6f f6 ff ff       	call   c01057a1 <get_pte>
c0106132:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106135:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106139:	75 24                	jne    c010615f <check_pgdir+0x15b>
c010613b:	c7 44 24 0c d4 cc 10 	movl   $0xc010ccd4,0xc(%esp)
c0106142:	c0 
c0106143:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c010614a:	c0 
c010614b:	c7 44 24 04 92 02 00 	movl   $0x292,0x4(%esp)
c0106152:	00 
c0106153:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c010615a:	e8 76 ac ff ff       	call   c0100dd5 <__panic>
    assert(pa2page(*ptep) == p1);
c010615f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106162:	8b 00                	mov    (%eax),%eax
c0106164:	89 04 24             	mov    %eax,(%esp)
c0106167:	e8 da eb ff ff       	call   c0104d46 <pa2page>
c010616c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010616f:	74 24                	je     c0106195 <check_pgdir+0x191>
c0106171:	c7 44 24 0c 01 cd 10 	movl   $0xc010cd01,0xc(%esp)
c0106178:	c0 
c0106179:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106180:	c0 
c0106181:	c7 44 24 04 93 02 00 	movl   $0x293,0x4(%esp)
c0106188:	00 
c0106189:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106190:	e8 40 ac ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p1) == 1);
c0106195:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106198:	89 04 24             	mov    %eax,(%esp)
c010619b:	e8 95 ec ff ff       	call   c0104e35 <page_ref>
c01061a0:	83 f8 01             	cmp    $0x1,%eax
c01061a3:	74 24                	je     c01061c9 <check_pgdir+0x1c5>
c01061a5:	c7 44 24 0c 16 cd 10 	movl   $0xc010cd16,0xc(%esp)
c01061ac:	c0 
c01061ad:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01061b4:	c0 
c01061b5:	c7 44 24 04 94 02 00 	movl   $0x294,0x4(%esp)
c01061bc:	00 
c01061bd:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01061c4:	e8 0c ac ff ff       	call   c0100dd5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01061c9:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01061ce:	8b 00                	mov    (%eax),%eax
c01061d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01061d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01061d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061db:	c1 e8 0c             	shr    $0xc,%eax
c01061de:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01061e1:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01061e6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01061e9:	72 23                	jb     c010620e <check_pgdir+0x20a>
c01061eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01061f2:	c7 44 24 08 6c ca 10 	movl   $0xc010ca6c,0x8(%esp)
c01061f9:	c0 
c01061fa:	c7 44 24 04 96 02 00 	movl   $0x296,0x4(%esp)
c0106201:	00 
c0106202:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106209:	e8 c7 ab ff ff       	call   c0100dd5 <__panic>
c010620e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106211:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0106216:	83 c0 04             	add    $0x4,%eax
c0106219:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010621c:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106221:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106228:	00 
c0106229:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106230:	00 
c0106231:	89 04 24             	mov    %eax,(%esp)
c0106234:	e8 68 f5 ff ff       	call   c01057a1 <get_pte>
c0106239:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010623c:	74 24                	je     c0106262 <check_pgdir+0x25e>
c010623e:	c7 44 24 0c 28 cd 10 	movl   $0xc010cd28,0xc(%esp)
c0106245:	c0 
c0106246:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c010624d:	c0 
c010624e:	c7 44 24 04 97 02 00 	movl   $0x297,0x4(%esp)
c0106255:	00 
c0106256:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c010625d:	e8 73 ab ff ff       	call   c0100dd5 <__panic>

    p2 = alloc_page();
c0106262:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106269:	e8 cc ed ff ff       	call   c010503a <alloc_pages>
c010626e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0106271:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106276:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010627d:	00 
c010627e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0106285:	00 
c0106286:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106289:	89 54 24 04          	mov    %edx,0x4(%esp)
c010628d:	89 04 24             	mov    %eax,(%esp)
c0106290:	e8 67 fb ff ff       	call   c0105dfc <page_insert>
c0106295:	85 c0                	test   %eax,%eax
c0106297:	74 24                	je     c01062bd <check_pgdir+0x2b9>
c0106299:	c7 44 24 0c 50 cd 10 	movl   $0xc010cd50,0xc(%esp)
c01062a0:	c0 
c01062a1:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01062a8:	c0 
c01062a9:	c7 44 24 04 9a 02 00 	movl   $0x29a,0x4(%esp)
c01062b0:	00 
c01062b1:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01062b8:	e8 18 ab ff ff       	call   c0100dd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01062bd:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01062c2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01062c9:	00 
c01062ca:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01062d1:	00 
c01062d2:	89 04 24             	mov    %eax,(%esp)
c01062d5:	e8 c7 f4 ff ff       	call   c01057a1 <get_pte>
c01062da:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01062dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01062e1:	75 24                	jne    c0106307 <check_pgdir+0x303>
c01062e3:	c7 44 24 0c 88 cd 10 	movl   $0xc010cd88,0xc(%esp)
c01062ea:	c0 
c01062eb:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01062f2:	c0 
c01062f3:	c7 44 24 04 9b 02 00 	movl   $0x29b,0x4(%esp)
c01062fa:	00 
c01062fb:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106302:	e8 ce aa ff ff       	call   c0100dd5 <__panic>
    assert(*ptep & PTE_U);
c0106307:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010630a:	8b 00                	mov    (%eax),%eax
c010630c:	83 e0 04             	and    $0x4,%eax
c010630f:	85 c0                	test   %eax,%eax
c0106311:	75 24                	jne    c0106337 <check_pgdir+0x333>
c0106313:	c7 44 24 0c b8 cd 10 	movl   $0xc010cdb8,0xc(%esp)
c010631a:	c0 
c010631b:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106322:	c0 
c0106323:	c7 44 24 04 9c 02 00 	movl   $0x29c,0x4(%esp)
c010632a:	00 
c010632b:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106332:	e8 9e aa ff ff       	call   c0100dd5 <__panic>
    assert(*ptep & PTE_W);
c0106337:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010633a:	8b 00                	mov    (%eax),%eax
c010633c:	83 e0 02             	and    $0x2,%eax
c010633f:	85 c0                	test   %eax,%eax
c0106341:	75 24                	jne    c0106367 <check_pgdir+0x363>
c0106343:	c7 44 24 0c c6 cd 10 	movl   $0xc010cdc6,0xc(%esp)
c010634a:	c0 
c010634b:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106352:	c0 
c0106353:	c7 44 24 04 9d 02 00 	movl   $0x29d,0x4(%esp)
c010635a:	00 
c010635b:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106362:	e8 6e aa ff ff       	call   c0100dd5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0106367:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010636c:	8b 00                	mov    (%eax),%eax
c010636e:	83 e0 04             	and    $0x4,%eax
c0106371:	85 c0                	test   %eax,%eax
c0106373:	75 24                	jne    c0106399 <check_pgdir+0x395>
c0106375:	c7 44 24 0c d4 cd 10 	movl   $0xc010cdd4,0xc(%esp)
c010637c:	c0 
c010637d:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106384:	c0 
c0106385:	c7 44 24 04 9e 02 00 	movl   $0x29e,0x4(%esp)
c010638c:	00 
c010638d:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106394:	e8 3c aa ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 1);
c0106399:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010639c:	89 04 24             	mov    %eax,(%esp)
c010639f:	e8 91 ea ff ff       	call   c0104e35 <page_ref>
c01063a4:	83 f8 01             	cmp    $0x1,%eax
c01063a7:	74 24                	je     c01063cd <check_pgdir+0x3c9>
c01063a9:	c7 44 24 0c ea cd 10 	movl   $0xc010cdea,0xc(%esp)
c01063b0:	c0 
c01063b1:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01063b8:	c0 
c01063b9:	c7 44 24 04 9f 02 00 	movl   $0x29f,0x4(%esp)
c01063c0:	00 
c01063c1:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01063c8:	e8 08 aa ff ff       	call   c0100dd5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01063cd:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01063d2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01063d9:	00 
c01063da:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01063e1:	00 
c01063e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01063e5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063e9:	89 04 24             	mov    %eax,(%esp)
c01063ec:	e8 0b fa ff ff       	call   c0105dfc <page_insert>
c01063f1:	85 c0                	test   %eax,%eax
c01063f3:	74 24                	je     c0106419 <check_pgdir+0x415>
c01063f5:	c7 44 24 0c fc cd 10 	movl   $0xc010cdfc,0xc(%esp)
c01063fc:	c0 
c01063fd:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106404:	c0 
c0106405:	c7 44 24 04 a1 02 00 	movl   $0x2a1,0x4(%esp)
c010640c:	00 
c010640d:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106414:	e8 bc a9 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p1) == 2);
c0106419:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010641c:	89 04 24             	mov    %eax,(%esp)
c010641f:	e8 11 ea ff ff       	call   c0104e35 <page_ref>
c0106424:	83 f8 02             	cmp    $0x2,%eax
c0106427:	74 24                	je     c010644d <check_pgdir+0x449>
c0106429:	c7 44 24 0c 28 ce 10 	movl   $0xc010ce28,0xc(%esp)
c0106430:	c0 
c0106431:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106438:	c0 
c0106439:	c7 44 24 04 a2 02 00 	movl   $0x2a2,0x4(%esp)
c0106440:	00 
c0106441:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106448:	e8 88 a9 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 0);
c010644d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106450:	89 04 24             	mov    %eax,(%esp)
c0106453:	e8 dd e9 ff ff       	call   c0104e35 <page_ref>
c0106458:	85 c0                	test   %eax,%eax
c010645a:	74 24                	je     c0106480 <check_pgdir+0x47c>
c010645c:	c7 44 24 0c 3a ce 10 	movl   $0xc010ce3a,0xc(%esp)
c0106463:	c0 
c0106464:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c010646b:	c0 
c010646c:	c7 44 24 04 a3 02 00 	movl   $0x2a3,0x4(%esp)
c0106473:	00 
c0106474:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c010647b:	e8 55 a9 ff ff       	call   c0100dd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0106480:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106485:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010648c:	00 
c010648d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106494:	00 
c0106495:	89 04 24             	mov    %eax,(%esp)
c0106498:	e8 04 f3 ff ff       	call   c01057a1 <get_pte>
c010649d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01064a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01064a4:	75 24                	jne    c01064ca <check_pgdir+0x4c6>
c01064a6:	c7 44 24 0c 88 cd 10 	movl   $0xc010cd88,0xc(%esp)
c01064ad:	c0 
c01064ae:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01064b5:	c0 
c01064b6:	c7 44 24 04 a4 02 00 	movl   $0x2a4,0x4(%esp)
c01064bd:	00 
c01064be:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01064c5:	e8 0b a9 ff ff       	call   c0100dd5 <__panic>
    assert(pa2page(*ptep) == p1);
c01064ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01064cd:	8b 00                	mov    (%eax),%eax
c01064cf:	89 04 24             	mov    %eax,(%esp)
c01064d2:	e8 6f e8 ff ff       	call   c0104d46 <pa2page>
c01064d7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01064da:	74 24                	je     c0106500 <check_pgdir+0x4fc>
c01064dc:	c7 44 24 0c 01 cd 10 	movl   $0xc010cd01,0xc(%esp)
c01064e3:	c0 
c01064e4:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01064eb:	c0 
c01064ec:	c7 44 24 04 a5 02 00 	movl   $0x2a5,0x4(%esp)
c01064f3:	00 
c01064f4:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01064fb:	e8 d5 a8 ff ff       	call   c0100dd5 <__panic>
    assert((*ptep & PTE_U) == 0);
c0106500:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106503:	8b 00                	mov    (%eax),%eax
c0106505:	83 e0 04             	and    $0x4,%eax
c0106508:	85 c0                	test   %eax,%eax
c010650a:	74 24                	je     c0106530 <check_pgdir+0x52c>
c010650c:	c7 44 24 0c 4c ce 10 	movl   $0xc010ce4c,0xc(%esp)
c0106513:	c0 
c0106514:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c010651b:	c0 
c010651c:	c7 44 24 04 a6 02 00 	movl   $0x2a6,0x4(%esp)
c0106523:	00 
c0106524:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c010652b:	e8 a5 a8 ff ff       	call   c0100dd5 <__panic>

    page_remove(boot_pgdir, 0x0);
c0106530:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106535:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010653c:	00 
c010653d:	89 04 24             	mov    %eax,(%esp)
c0106540:	e8 73 f8 ff ff       	call   c0105db8 <page_remove>
    assert(page_ref(p1) == 1);
c0106545:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106548:	89 04 24             	mov    %eax,(%esp)
c010654b:	e8 e5 e8 ff ff       	call   c0104e35 <page_ref>
c0106550:	83 f8 01             	cmp    $0x1,%eax
c0106553:	74 24                	je     c0106579 <check_pgdir+0x575>
c0106555:	c7 44 24 0c 16 cd 10 	movl   $0xc010cd16,0xc(%esp)
c010655c:	c0 
c010655d:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106564:	c0 
c0106565:	c7 44 24 04 a9 02 00 	movl   $0x2a9,0x4(%esp)
c010656c:	00 
c010656d:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106574:	e8 5c a8 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 0);
c0106579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010657c:	89 04 24             	mov    %eax,(%esp)
c010657f:	e8 b1 e8 ff ff       	call   c0104e35 <page_ref>
c0106584:	85 c0                	test   %eax,%eax
c0106586:	74 24                	je     c01065ac <check_pgdir+0x5a8>
c0106588:	c7 44 24 0c 3a ce 10 	movl   $0xc010ce3a,0xc(%esp)
c010658f:	c0 
c0106590:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106597:	c0 
c0106598:	c7 44 24 04 aa 02 00 	movl   $0x2aa,0x4(%esp)
c010659f:	00 
c01065a0:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01065a7:	e8 29 a8 ff ff       	call   c0100dd5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01065ac:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01065b1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01065b8:	00 
c01065b9:	89 04 24             	mov    %eax,(%esp)
c01065bc:	e8 f7 f7 ff ff       	call   c0105db8 <page_remove>
    assert(page_ref(p1) == 0);
c01065c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01065c4:	89 04 24             	mov    %eax,(%esp)
c01065c7:	e8 69 e8 ff ff       	call   c0104e35 <page_ref>
c01065cc:	85 c0                	test   %eax,%eax
c01065ce:	74 24                	je     c01065f4 <check_pgdir+0x5f0>
c01065d0:	c7 44 24 0c 61 ce 10 	movl   $0xc010ce61,0xc(%esp)
c01065d7:	c0 
c01065d8:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01065df:	c0 
c01065e0:	c7 44 24 04 ad 02 00 	movl   $0x2ad,0x4(%esp)
c01065e7:	00 
c01065e8:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01065ef:	e8 e1 a7 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 0);
c01065f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065f7:	89 04 24             	mov    %eax,(%esp)
c01065fa:	e8 36 e8 ff ff       	call   c0104e35 <page_ref>
c01065ff:	85 c0                	test   %eax,%eax
c0106601:	74 24                	je     c0106627 <check_pgdir+0x623>
c0106603:	c7 44 24 0c 3a ce 10 	movl   $0xc010ce3a,0xc(%esp)
c010660a:	c0 
c010660b:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106612:	c0 
c0106613:	c7 44 24 04 ae 02 00 	movl   $0x2ae,0x4(%esp)
c010661a:	00 
c010661b:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106622:	e8 ae a7 ff ff       	call   c0100dd5 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0106627:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010662c:	8b 00                	mov    (%eax),%eax
c010662e:	89 04 24             	mov    %eax,(%esp)
c0106631:	e8 10 e7 ff ff       	call   c0104d46 <pa2page>
c0106636:	89 04 24             	mov    %eax,(%esp)
c0106639:	e8 f7 e7 ff ff       	call   c0104e35 <page_ref>
c010663e:	83 f8 01             	cmp    $0x1,%eax
c0106641:	74 24                	je     c0106667 <check_pgdir+0x663>
c0106643:	c7 44 24 0c 74 ce 10 	movl   $0xc010ce74,0xc(%esp)
c010664a:	c0 
c010664b:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106652:	c0 
c0106653:	c7 44 24 04 b0 02 00 	movl   $0x2b0,0x4(%esp)
c010665a:	00 
c010665b:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106662:	e8 6e a7 ff ff       	call   c0100dd5 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0106667:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010666c:	8b 00                	mov    (%eax),%eax
c010666e:	89 04 24             	mov    %eax,(%esp)
c0106671:	e8 d0 e6 ff ff       	call   c0104d46 <pa2page>
c0106676:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010667d:	00 
c010667e:	89 04 24             	mov    %eax,(%esp)
c0106681:	e8 1f ea ff ff       	call   c01050a5 <free_pages>
    boot_pgdir[0] = 0;
c0106686:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010668b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0106691:	c7 04 24 9a ce 10 c0 	movl   $0xc010ce9a,(%esp)
c0106698:	e8 b6 9c ff ff       	call   c0100353 <cprintf>
}
c010669d:	c9                   	leave  
c010669e:	c3                   	ret    

c010669f <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c010669f:	55                   	push   %ebp
c01066a0:	89 e5                	mov    %esp,%ebp
c01066a2:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01066a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01066ac:	e9 ca 00 00 00       	jmp    c010677b <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01066b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01066b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01066ba:	c1 e8 0c             	shr    $0xc,%eax
c01066bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01066c0:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01066c5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01066c8:	72 23                	jb     c01066ed <check_boot_pgdir+0x4e>
c01066ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01066cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01066d1:	c7 44 24 08 6c ca 10 	movl   $0xc010ca6c,0x8(%esp)
c01066d8:	c0 
c01066d9:	c7 44 24 04 bc 02 00 	movl   $0x2bc,0x4(%esp)
c01066e0:	00 
c01066e1:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01066e8:	e8 e8 a6 ff ff       	call   c0100dd5 <__panic>
c01066ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01066f0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01066f5:	89 c2                	mov    %eax,%edx
c01066f7:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01066fc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106703:	00 
c0106704:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106708:	89 04 24             	mov    %eax,(%esp)
c010670b:	e8 91 f0 ff ff       	call   c01057a1 <get_pte>
c0106710:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106713:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106717:	75 24                	jne    c010673d <check_boot_pgdir+0x9e>
c0106719:	c7 44 24 0c b4 ce 10 	movl   $0xc010ceb4,0xc(%esp)
c0106720:	c0 
c0106721:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106728:	c0 
c0106729:	c7 44 24 04 bc 02 00 	movl   $0x2bc,0x4(%esp)
c0106730:	00 
c0106731:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106738:	e8 98 a6 ff ff       	call   c0100dd5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010673d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106740:	8b 00                	mov    (%eax),%eax
c0106742:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106747:	89 c2                	mov    %eax,%edx
c0106749:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010674c:	39 c2                	cmp    %eax,%edx
c010674e:	74 24                	je     c0106774 <check_boot_pgdir+0xd5>
c0106750:	c7 44 24 0c f1 ce 10 	movl   $0xc010cef1,0xc(%esp)
c0106757:	c0 
c0106758:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c010675f:	c0 
c0106760:	c7 44 24 04 bd 02 00 	movl   $0x2bd,0x4(%esp)
c0106767:	00 
c0106768:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c010676f:	e8 61 a6 ff ff       	call   c0100dd5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106774:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010677b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010677e:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0106783:	39 c2                	cmp    %eax,%edx
c0106785:	0f 82 26 ff ff ff    	jb     c01066b1 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010678b:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106790:	05 ac 0f 00 00       	add    $0xfac,%eax
c0106795:	8b 00                	mov    (%eax),%eax
c0106797:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010679c:	89 c2                	mov    %eax,%edx
c010679e:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01067a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01067a6:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01067ad:	77 23                	ja     c01067d2 <check_boot_pgdir+0x133>
c01067af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01067b6:	c7 44 24 08 10 cb 10 	movl   $0xc010cb10,0x8(%esp)
c01067bd:	c0 
c01067be:	c7 44 24 04 c0 02 00 	movl   $0x2c0,0x4(%esp)
c01067c5:	00 
c01067c6:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01067cd:	e8 03 a6 ff ff       	call   c0100dd5 <__panic>
c01067d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067d5:	05 00 00 00 40       	add    $0x40000000,%eax
c01067da:	39 c2                	cmp    %eax,%edx
c01067dc:	74 24                	je     c0106802 <check_boot_pgdir+0x163>
c01067de:	c7 44 24 0c 08 cf 10 	movl   $0xc010cf08,0xc(%esp)
c01067e5:	c0 
c01067e6:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01067ed:	c0 
c01067ee:	c7 44 24 04 c0 02 00 	movl   $0x2c0,0x4(%esp)
c01067f5:	00 
c01067f6:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01067fd:	e8 d3 a5 ff ff       	call   c0100dd5 <__panic>

    assert(boot_pgdir[0] == 0);
c0106802:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106807:	8b 00                	mov    (%eax),%eax
c0106809:	85 c0                	test   %eax,%eax
c010680b:	74 24                	je     c0106831 <check_boot_pgdir+0x192>
c010680d:	c7 44 24 0c 3c cf 10 	movl   $0xc010cf3c,0xc(%esp)
c0106814:	c0 
c0106815:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c010681c:	c0 
c010681d:	c7 44 24 04 c2 02 00 	movl   $0x2c2,0x4(%esp)
c0106824:	00 
c0106825:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c010682c:	e8 a4 a5 ff ff       	call   c0100dd5 <__panic>

    struct Page *p;
    p = alloc_page();
c0106831:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106838:	e8 fd e7 ff ff       	call   c010503a <alloc_pages>
c010683d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0106840:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106845:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010684c:	00 
c010684d:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0106854:	00 
c0106855:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106858:	89 54 24 04          	mov    %edx,0x4(%esp)
c010685c:	89 04 24             	mov    %eax,(%esp)
c010685f:	e8 98 f5 ff ff       	call   c0105dfc <page_insert>
c0106864:	85 c0                	test   %eax,%eax
c0106866:	74 24                	je     c010688c <check_boot_pgdir+0x1ed>
c0106868:	c7 44 24 0c 50 cf 10 	movl   $0xc010cf50,0xc(%esp)
c010686f:	c0 
c0106870:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106877:	c0 
c0106878:	c7 44 24 04 c6 02 00 	movl   $0x2c6,0x4(%esp)
c010687f:	00 
c0106880:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106887:	e8 49 a5 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p) == 1);
c010688c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010688f:	89 04 24             	mov    %eax,(%esp)
c0106892:	e8 9e e5 ff ff       	call   c0104e35 <page_ref>
c0106897:	83 f8 01             	cmp    $0x1,%eax
c010689a:	74 24                	je     c01068c0 <check_boot_pgdir+0x221>
c010689c:	c7 44 24 0c 7e cf 10 	movl   $0xc010cf7e,0xc(%esp)
c01068a3:	c0 
c01068a4:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01068ab:	c0 
c01068ac:	c7 44 24 04 c7 02 00 	movl   $0x2c7,0x4(%esp)
c01068b3:	00 
c01068b4:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01068bb:	e8 15 a5 ff ff       	call   c0100dd5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01068c0:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01068c5:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01068cc:	00 
c01068cd:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01068d4:	00 
c01068d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01068d8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01068dc:	89 04 24             	mov    %eax,(%esp)
c01068df:	e8 18 f5 ff ff       	call   c0105dfc <page_insert>
c01068e4:	85 c0                	test   %eax,%eax
c01068e6:	74 24                	je     c010690c <check_boot_pgdir+0x26d>
c01068e8:	c7 44 24 0c 90 cf 10 	movl   $0xc010cf90,0xc(%esp)
c01068ef:	c0 
c01068f0:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01068f7:	c0 
c01068f8:	c7 44 24 04 c8 02 00 	movl   $0x2c8,0x4(%esp)
c01068ff:	00 
c0106900:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106907:	e8 c9 a4 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p) == 2);
c010690c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010690f:	89 04 24             	mov    %eax,(%esp)
c0106912:	e8 1e e5 ff ff       	call   c0104e35 <page_ref>
c0106917:	83 f8 02             	cmp    $0x2,%eax
c010691a:	74 24                	je     c0106940 <check_boot_pgdir+0x2a1>
c010691c:	c7 44 24 0c c7 cf 10 	movl   $0xc010cfc7,0xc(%esp)
c0106923:	c0 
c0106924:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c010692b:	c0 
c010692c:	c7 44 24 04 c9 02 00 	movl   $0x2c9,0x4(%esp)
c0106933:	00 
c0106934:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c010693b:	e8 95 a4 ff ff       	call   c0100dd5 <__panic>

    const char *str = "ucore: Hello world!!";
c0106940:	c7 45 dc d8 cf 10 c0 	movl   $0xc010cfd8,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0106947:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010694a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010694e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106955:	e8 fb 4e 00 00       	call   c010b855 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010695a:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0106961:	00 
c0106962:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106969:	e8 60 4f 00 00       	call   c010b8ce <strcmp>
c010696e:	85 c0                	test   %eax,%eax
c0106970:	74 24                	je     c0106996 <check_boot_pgdir+0x2f7>
c0106972:	c7 44 24 0c f0 cf 10 	movl   $0xc010cff0,0xc(%esp)
c0106979:	c0 
c010697a:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c0106981:	c0 
c0106982:	c7 44 24 04 cd 02 00 	movl   $0x2cd,0x4(%esp)
c0106989:	00 
c010698a:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c0106991:	e8 3f a4 ff ff       	call   c0100dd5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0106996:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106999:	89 04 24             	mov    %eax,(%esp)
c010699c:	e8 ea e3 ff ff       	call   c0104d8b <page2kva>
c01069a1:	05 00 01 00 00       	add    $0x100,%eax
c01069a6:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01069a9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01069b0:	e8 48 4e 00 00       	call   c010b7fd <strlen>
c01069b5:	85 c0                	test   %eax,%eax
c01069b7:	74 24                	je     c01069dd <check_boot_pgdir+0x33e>
c01069b9:	c7 44 24 0c 28 d0 10 	movl   $0xc010d028,0xc(%esp)
c01069c0:	c0 
c01069c1:	c7 44 24 08 59 cb 10 	movl   $0xc010cb59,0x8(%esp)
c01069c8:	c0 
c01069c9:	c7 44 24 04 d0 02 00 	movl   $0x2d0,0x4(%esp)
c01069d0:	00 
c01069d1:	c7 04 24 34 cb 10 c0 	movl   $0xc010cb34,(%esp)
c01069d8:	e8 f8 a3 ff ff       	call   c0100dd5 <__panic>

    free_page(p);
c01069dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01069e4:	00 
c01069e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01069e8:	89 04 24             	mov    %eax,(%esp)
c01069eb:	e8 b5 e6 ff ff       	call   c01050a5 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01069f0:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01069f5:	8b 00                	mov    (%eax),%eax
c01069f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01069fc:	89 04 24             	mov    %eax,(%esp)
c01069ff:	e8 42 e3 ff ff       	call   c0104d46 <pa2page>
c0106a04:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106a0b:	00 
c0106a0c:	89 04 24             	mov    %eax,(%esp)
c0106a0f:	e8 91 e6 ff ff       	call   c01050a5 <free_pages>
    boot_pgdir[0] = 0;
c0106a14:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106a19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0106a1f:	c7 04 24 4c d0 10 c0 	movl   $0xc010d04c,(%esp)
c0106a26:	e8 28 99 ff ff       	call   c0100353 <cprintf>
}
c0106a2b:	c9                   	leave  
c0106a2c:	c3                   	ret    

c0106a2d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0106a2d:	55                   	push   %ebp
c0106a2e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0106a30:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a33:	83 e0 04             	and    $0x4,%eax
c0106a36:	85 c0                	test   %eax,%eax
c0106a38:	74 07                	je     c0106a41 <perm2str+0x14>
c0106a3a:	b8 75 00 00 00       	mov    $0x75,%eax
c0106a3f:	eb 05                	jmp    c0106a46 <perm2str+0x19>
c0106a41:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106a46:	a2 68 cf 19 c0       	mov    %al,0xc019cf68
    str[1] = 'r';
c0106a4b:	c6 05 69 cf 19 c0 72 	movb   $0x72,0xc019cf69
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106a52:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a55:	83 e0 02             	and    $0x2,%eax
c0106a58:	85 c0                	test   %eax,%eax
c0106a5a:	74 07                	je     c0106a63 <perm2str+0x36>
c0106a5c:	b8 77 00 00 00       	mov    $0x77,%eax
c0106a61:	eb 05                	jmp    c0106a68 <perm2str+0x3b>
c0106a63:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106a68:	a2 6a cf 19 c0       	mov    %al,0xc019cf6a
    str[3] = '\0';
c0106a6d:	c6 05 6b cf 19 c0 00 	movb   $0x0,0xc019cf6b
    return str;
c0106a74:	b8 68 cf 19 c0       	mov    $0xc019cf68,%eax
}
c0106a79:	5d                   	pop    %ebp
c0106a7a:	c3                   	ret    

c0106a7b <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0106a7b:	55                   	push   %ebp
c0106a7c:	89 e5                	mov    %esp,%ebp
c0106a7e:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0106a81:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a84:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106a87:	72 0a                	jb     c0106a93 <get_pgtable_items+0x18>
        return 0;
c0106a89:	b8 00 00 00 00       	mov    $0x0,%eax
c0106a8e:	e9 9c 00 00 00       	jmp    c0106b2f <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106a93:	eb 04                	jmp    c0106a99 <get_pgtable_items+0x1e>
        start ++;
c0106a95:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106a99:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a9c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106a9f:	73 18                	jae    c0106ab9 <get_pgtable_items+0x3e>
c0106aa1:	8b 45 10             	mov    0x10(%ebp),%eax
c0106aa4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106aab:	8b 45 14             	mov    0x14(%ebp),%eax
c0106aae:	01 d0                	add    %edx,%eax
c0106ab0:	8b 00                	mov    (%eax),%eax
c0106ab2:	83 e0 01             	and    $0x1,%eax
c0106ab5:	85 c0                	test   %eax,%eax
c0106ab7:	74 dc                	je     c0106a95 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0106ab9:	8b 45 10             	mov    0x10(%ebp),%eax
c0106abc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106abf:	73 69                	jae    c0106b2a <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0106ac1:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0106ac5:	74 08                	je     c0106acf <get_pgtable_items+0x54>
            *left_store = start;
c0106ac7:	8b 45 18             	mov    0x18(%ebp),%eax
c0106aca:	8b 55 10             	mov    0x10(%ebp),%edx
c0106acd:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0106acf:	8b 45 10             	mov    0x10(%ebp),%eax
c0106ad2:	8d 50 01             	lea    0x1(%eax),%edx
c0106ad5:	89 55 10             	mov    %edx,0x10(%ebp)
c0106ad8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106adf:	8b 45 14             	mov    0x14(%ebp),%eax
c0106ae2:	01 d0                	add    %edx,%eax
c0106ae4:	8b 00                	mov    (%eax),%eax
c0106ae6:	83 e0 07             	and    $0x7,%eax
c0106ae9:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106aec:	eb 04                	jmp    c0106af2 <get_pgtable_items+0x77>
            start ++;
c0106aee:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106af2:	8b 45 10             	mov    0x10(%ebp),%eax
c0106af5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106af8:	73 1d                	jae    c0106b17 <get_pgtable_items+0x9c>
c0106afa:	8b 45 10             	mov    0x10(%ebp),%eax
c0106afd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106b04:	8b 45 14             	mov    0x14(%ebp),%eax
c0106b07:	01 d0                	add    %edx,%eax
c0106b09:	8b 00                	mov    (%eax),%eax
c0106b0b:	83 e0 07             	and    $0x7,%eax
c0106b0e:	89 c2                	mov    %eax,%edx
c0106b10:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106b13:	39 c2                	cmp    %eax,%edx
c0106b15:	74 d7                	je     c0106aee <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0106b17:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106b1b:	74 08                	je     c0106b25 <get_pgtable_items+0xaa>
            *right_store = start;
c0106b1d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106b20:	8b 55 10             	mov    0x10(%ebp),%edx
c0106b23:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106b28:	eb 05                	jmp    c0106b2f <get_pgtable_items+0xb4>
    }
    return 0;
c0106b2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106b2f:	c9                   	leave  
c0106b30:	c3                   	ret    

c0106b31 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0106b31:	55                   	push   %ebp
c0106b32:	89 e5                	mov    %esp,%ebp
c0106b34:	57                   	push   %edi
c0106b35:	56                   	push   %esi
c0106b36:	53                   	push   %ebx
c0106b37:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0106b3a:	c7 04 24 6c d0 10 c0 	movl   $0xc010d06c,(%esp)
c0106b41:	e8 0d 98 ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
c0106b46:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106b4d:	e9 fa 00 00 00       	jmp    c0106c4c <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b55:	89 04 24             	mov    %eax,(%esp)
c0106b58:	e8 d0 fe ff ff       	call   c0106a2d <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0106b5d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106b60:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106b63:	29 d1                	sub    %edx,%ecx
c0106b65:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106b67:	89 d6                	mov    %edx,%esi
c0106b69:	c1 e6 16             	shl    $0x16,%esi
c0106b6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106b6f:	89 d3                	mov    %edx,%ebx
c0106b71:	c1 e3 16             	shl    $0x16,%ebx
c0106b74:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106b77:	89 d1                	mov    %edx,%ecx
c0106b79:	c1 e1 16             	shl    $0x16,%ecx
c0106b7c:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0106b7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106b82:	29 d7                	sub    %edx,%edi
c0106b84:	89 fa                	mov    %edi,%edx
c0106b86:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106b8a:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106b8e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106b92:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106b96:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106b9a:	c7 04 24 9d d0 10 c0 	movl   $0xc010d09d,(%esp)
c0106ba1:	e8 ad 97 ff ff       	call   c0100353 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0106ba6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ba9:	c1 e0 0a             	shl    $0xa,%eax
c0106bac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106baf:	eb 54                	jmp    c0106c05 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106bb4:	89 04 24             	mov    %eax,(%esp)
c0106bb7:	e8 71 fe ff ff       	call   c0106a2d <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106bbc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0106bbf:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106bc2:	29 d1                	sub    %edx,%ecx
c0106bc4:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106bc6:	89 d6                	mov    %edx,%esi
c0106bc8:	c1 e6 0c             	shl    $0xc,%esi
c0106bcb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106bce:	89 d3                	mov    %edx,%ebx
c0106bd0:	c1 e3 0c             	shl    $0xc,%ebx
c0106bd3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106bd6:	c1 e2 0c             	shl    $0xc,%edx
c0106bd9:	89 d1                	mov    %edx,%ecx
c0106bdb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0106bde:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106be1:	29 d7                	sub    %edx,%edi
c0106be3:	89 fa                	mov    %edi,%edx
c0106be5:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106be9:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106bed:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106bf1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106bf5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106bf9:	c7 04 24 bc d0 10 c0 	movl   $0xc010d0bc,(%esp)
c0106c00:	e8 4e 97 ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106c05:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0106c0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106c0d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106c10:	89 ce                	mov    %ecx,%esi
c0106c12:	c1 e6 0a             	shl    $0xa,%esi
c0106c15:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106c18:	89 cb                	mov    %ecx,%ebx
c0106c1a:	c1 e3 0a             	shl    $0xa,%ebx
c0106c1d:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106c20:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106c24:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0106c27:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106c2b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106c2f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106c33:	89 74 24 04          	mov    %esi,0x4(%esp)
c0106c37:	89 1c 24             	mov    %ebx,(%esp)
c0106c3a:	e8 3c fe ff ff       	call   c0106a7b <get_pgtable_items>
c0106c3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106c42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106c46:	0f 85 65 ff ff ff    	jne    c0106bb1 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106c4c:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106c51:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c54:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0106c57:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106c5b:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0106c5e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106c62:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106c66:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106c6a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106c71:	00 
c0106c72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106c79:	e8 fd fd ff ff       	call   c0106a7b <get_pgtable_items>
c0106c7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106c81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106c85:	0f 85 c7 fe ff ff    	jne    c0106b52 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106c8b:	c7 04 24 e0 d0 10 c0 	movl   $0xc010d0e0,(%esp)
c0106c92:	e8 bc 96 ff ff       	call   c0100353 <cprintf>
}
c0106c97:	83 c4 4c             	add    $0x4c,%esp
c0106c9a:	5b                   	pop    %ebx
c0106c9b:	5e                   	pop    %esi
c0106c9c:	5f                   	pop    %edi
c0106c9d:	5d                   	pop    %ebp
c0106c9e:	c3                   	ret    

c0106c9f <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106c9f:	55                   	push   %ebp
c0106ca0:	89 e5                	mov    %esp,%ebp
c0106ca2:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106ca5:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ca8:	c1 e8 0c             	shr    $0xc,%eax
c0106cab:	89 c2                	mov    %eax,%edx
c0106cad:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0106cb2:	39 c2                	cmp    %eax,%edx
c0106cb4:	72 1c                	jb     c0106cd2 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106cb6:	c7 44 24 08 14 d1 10 	movl   $0xc010d114,0x8(%esp)
c0106cbd:	c0 
c0106cbe:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0106cc5:	00 
c0106cc6:	c7 04 24 33 d1 10 c0 	movl   $0xc010d133,(%esp)
c0106ccd:	e8 03 a1 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0106cd2:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0106cd7:	8b 55 08             	mov    0x8(%ebp),%edx
c0106cda:	c1 ea 0c             	shr    $0xc,%edx
c0106cdd:	c1 e2 05             	shl    $0x5,%edx
c0106ce0:	01 d0                	add    %edx,%eax
}
c0106ce2:	c9                   	leave  
c0106ce3:	c3                   	ret    

c0106ce4 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106ce4:	55                   	push   %ebp
c0106ce5:	89 e5                	mov    %esp,%ebp
c0106ce7:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106cea:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ced:	83 e0 01             	and    $0x1,%eax
c0106cf0:	85 c0                	test   %eax,%eax
c0106cf2:	75 1c                	jne    c0106d10 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106cf4:	c7 44 24 08 44 d1 10 	movl   $0xc010d144,0x8(%esp)
c0106cfb:	c0 
c0106cfc:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0106d03:	00 
c0106d04:	c7 04 24 33 d1 10 c0 	movl   $0xc010d133,(%esp)
c0106d0b:	e8 c5 a0 ff ff       	call   c0100dd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106d10:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d13:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106d18:	89 04 24             	mov    %eax,(%esp)
c0106d1b:	e8 7f ff ff ff       	call   c0106c9f <pa2page>
}
c0106d20:	c9                   	leave  
c0106d21:	c3                   	ret    

c0106d22 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106d22:	55                   	push   %ebp
c0106d23:	89 e5                	mov    %esp,%ebp
c0106d25:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106d28:	e8 ba 22 00 00       	call   c0108fe7 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106d2d:	a1 7c f0 19 c0       	mov    0xc019f07c,%eax
c0106d32:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106d37:	76 0c                	jbe    c0106d45 <swap_init+0x23>
c0106d39:	a1 7c f0 19 c0       	mov    0xc019f07c,%eax
c0106d3e:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106d43:	76 25                	jbe    c0106d6a <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106d45:	a1 7c f0 19 c0       	mov    0xc019f07c,%eax
c0106d4a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106d4e:	c7 44 24 08 65 d1 10 	movl   $0xc010d165,0x8(%esp)
c0106d55:	c0 
c0106d56:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
c0106d5d:	00 
c0106d5e:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c0106d65:	e8 6b a0 ff ff       	call   c0100dd5 <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106d6a:	c7 05 74 cf 19 c0 60 	movl   $0xc012aa60,0xc019cf74
c0106d71:	aa 12 c0 
     int r = sm->init();
c0106d74:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106d79:	8b 40 04             	mov    0x4(%eax),%eax
c0106d7c:	ff d0                	call   *%eax
c0106d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106d81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106d85:	75 26                	jne    c0106dad <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106d87:	c7 05 6c cf 19 c0 01 	movl   $0x1,0xc019cf6c
c0106d8e:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106d91:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106d96:	8b 00                	mov    (%eax),%eax
c0106d98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d9c:	c7 04 24 8f d1 10 c0 	movl   $0xc010d18f,(%esp)
c0106da3:	e8 ab 95 ff ff       	call   c0100353 <cprintf>
          check_swap();
c0106da8:	e8 a4 04 00 00       	call   c0107251 <check_swap>
     }

     return r;
c0106dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106db0:	c9                   	leave  
c0106db1:	c3                   	ret    

c0106db2 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106db2:	55                   	push   %ebp
c0106db3:	89 e5                	mov    %esp,%ebp
c0106db5:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0106db8:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106dbd:	8b 40 08             	mov    0x8(%eax),%eax
c0106dc0:	8b 55 08             	mov    0x8(%ebp),%edx
c0106dc3:	89 14 24             	mov    %edx,(%esp)
c0106dc6:	ff d0                	call   *%eax
}
c0106dc8:	c9                   	leave  
c0106dc9:	c3                   	ret    

c0106dca <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106dca:	55                   	push   %ebp
c0106dcb:	89 e5                	mov    %esp,%ebp
c0106dcd:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106dd0:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106dd5:	8b 40 0c             	mov    0xc(%eax),%eax
c0106dd8:	8b 55 08             	mov    0x8(%ebp),%edx
c0106ddb:	89 14 24             	mov    %edx,(%esp)
c0106dde:	ff d0                	call   *%eax
}
c0106de0:	c9                   	leave  
c0106de1:	c3                   	ret    

c0106de2 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106de2:	55                   	push   %ebp
c0106de3:	89 e5                	mov    %esp,%ebp
c0106de5:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106de8:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106ded:	8b 40 10             	mov    0x10(%eax),%eax
c0106df0:	8b 55 14             	mov    0x14(%ebp),%edx
c0106df3:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106df7:	8b 55 10             	mov    0x10(%ebp),%edx
c0106dfa:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e01:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e05:	8b 55 08             	mov    0x8(%ebp),%edx
c0106e08:	89 14 24             	mov    %edx,(%esp)
c0106e0b:	ff d0                	call   *%eax
}
c0106e0d:	c9                   	leave  
c0106e0e:	c3                   	ret    

c0106e0f <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106e0f:	55                   	push   %ebp
c0106e10:	89 e5                	mov    %esp,%ebp
c0106e12:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106e15:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106e1a:	8b 40 14             	mov    0x14(%eax),%eax
c0106e1d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e20:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e24:	8b 55 08             	mov    0x8(%ebp),%edx
c0106e27:	89 14 24             	mov    %edx,(%esp)
c0106e2a:	ff d0                	call   *%eax
}
c0106e2c:	c9                   	leave  
c0106e2d:	c3                   	ret    

c0106e2e <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106e2e:	55                   	push   %ebp
c0106e2f:	89 e5                	mov    %esp,%ebp
c0106e31:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106e34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106e3b:	e9 5a 01 00 00       	jmp    c0106f9a <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106e40:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106e45:	8b 40 18             	mov    0x18(%eax),%eax
c0106e48:	8b 55 10             	mov    0x10(%ebp),%edx
c0106e4b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106e4f:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106e52:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e56:	8b 55 08             	mov    0x8(%ebp),%edx
c0106e59:	89 14 24             	mov    %edx,(%esp)
c0106e5c:	ff d0                	call   *%eax
c0106e5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106e61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106e65:	74 18                	je     c0106e7f <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e6e:	c7 04 24 a4 d1 10 c0 	movl   $0xc010d1a4,(%esp)
c0106e75:	e8 d9 94 ff ff       	call   c0100353 <cprintf>
c0106e7a:	e9 27 01 00 00       	jmp    c0106fa6 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106e7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e82:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106e85:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106e88:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e8b:	8b 40 0c             	mov    0xc(%eax),%eax
c0106e8e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106e95:	00 
c0106e96:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106e99:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e9d:	89 04 24             	mov    %eax,(%esp)
c0106ea0:	e8 fc e8 ff ff       	call   c01057a1 <get_pte>
c0106ea5:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0106ea8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106eab:	8b 00                	mov    (%eax),%eax
c0106ead:	83 e0 01             	and    $0x1,%eax
c0106eb0:	85 c0                	test   %eax,%eax
c0106eb2:	75 24                	jne    c0106ed8 <swap_out+0xaa>
c0106eb4:	c7 44 24 0c d1 d1 10 	movl   $0xc010d1d1,0xc(%esp)
c0106ebb:	c0 
c0106ebc:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c0106ec3:	c0 
c0106ec4:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106ecb:	00 
c0106ecc:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c0106ed3:	e8 fd 9e ff ff       	call   c0100dd5 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0106ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106edb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106ede:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106ee1:	c1 ea 0c             	shr    $0xc,%edx
c0106ee4:	83 c2 01             	add    $0x1,%edx
c0106ee7:	c1 e2 08             	shl    $0x8,%edx
c0106eea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106eee:	89 14 24             	mov    %edx,(%esp)
c0106ef1:	e8 ab 21 00 00       	call   c01090a1 <swapfs_write>
c0106ef6:	85 c0                	test   %eax,%eax
c0106ef8:	74 34                	je     c0106f2e <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0106efa:	c7 04 24 fb d1 10 c0 	movl   $0xc010d1fb,(%esp)
c0106f01:	e8 4d 94 ff ff       	call   c0100353 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0106f06:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106f0b:	8b 40 10             	mov    0x10(%eax),%eax
c0106f0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106f11:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106f18:	00 
c0106f19:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106f1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106f20:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106f24:	8b 55 08             	mov    0x8(%ebp),%edx
c0106f27:	89 14 24             	mov    %edx,(%esp)
c0106f2a:	ff d0                	call   *%eax
c0106f2c:	eb 68                	jmp    c0106f96 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106f2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f31:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106f34:	c1 e8 0c             	shr    $0xc,%eax
c0106f37:	83 c0 01             	add    $0x1,%eax
c0106f3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f41:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106f4c:	c7 04 24 14 d2 10 c0 	movl   $0xc010d214,(%esp)
c0106f53:	e8 fb 93 ff ff       	call   c0100353 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f5b:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106f5e:	c1 e8 0c             	shr    $0xc,%eax
c0106f61:	83 c0 01             	add    $0x1,%eax
c0106f64:	c1 e0 08             	shl    $0x8,%eax
c0106f67:	89 c2                	mov    %eax,%edx
c0106f69:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106f6c:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0106f6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f71:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106f78:	00 
c0106f79:	89 04 24             	mov    %eax,(%esp)
c0106f7c:	e8 24 e1 ff ff       	call   c01050a5 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106f81:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f84:	8b 40 0c             	mov    0xc(%eax),%eax
c0106f87:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106f8a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106f8e:	89 04 24             	mov    %eax,(%esp)
c0106f91:	e8 1f ef ff ff       	call   c0105eb5 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0106f96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f9d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106fa0:	0f 85 9a fe ff ff    	jne    c0106e40 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0106fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106fa9:	c9                   	leave  
c0106faa:	c3                   	ret    

c0106fab <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106fab:	55                   	push   %ebp
c0106fac:	89 e5                	mov    %esp,%ebp
c0106fae:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106fb1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106fb8:	e8 7d e0 ff ff       	call   c010503a <alloc_pages>
c0106fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106fc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106fc4:	75 24                	jne    c0106fea <swap_in+0x3f>
c0106fc6:	c7 44 24 0c 54 d2 10 	movl   $0xc010d254,0xc(%esp)
c0106fcd:	c0 
c0106fce:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c0106fd5:	c0 
c0106fd6:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0106fdd:	00 
c0106fde:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c0106fe5:	e8 eb 9d ff ff       	call   c0100dd5 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106fea:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fed:	8b 40 0c             	mov    0xc(%eax),%eax
c0106ff0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106ff7:	00 
c0106ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106ffb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106fff:	89 04 24             	mov    %eax,(%esp)
c0107002:	e8 9a e7 ff ff       	call   c01057a1 <get_pte>
c0107007:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c010700a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010700d:	8b 00                	mov    (%eax),%eax
c010700f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107012:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107016:	89 04 24             	mov    %eax,(%esp)
c0107019:	e8 11 20 00 00       	call   c010902f <swapfs_read>
c010701e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107021:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107025:	74 2a                	je     c0107051 <swap_in+0xa6>
     {
        assert(r!=0);
c0107027:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010702b:	75 24                	jne    c0107051 <swap_in+0xa6>
c010702d:	c7 44 24 0c 61 d2 10 	movl   $0xc010d261,0xc(%esp)
c0107034:	c0 
c0107035:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c010703c:	c0 
c010703d:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
c0107044:	00 
c0107045:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c010704c:	e8 84 9d ff ff       	call   c0100dd5 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0107051:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107054:	8b 00                	mov    (%eax),%eax
c0107056:	c1 e8 08             	shr    $0x8,%eax
c0107059:	89 c2                	mov    %eax,%edx
c010705b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010705e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107062:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107066:	c7 04 24 68 d2 10 c0 	movl   $0xc010d268,(%esp)
c010706d:	e8 e1 92 ff ff       	call   c0100353 <cprintf>
     *ptr_result=result;
c0107072:	8b 45 10             	mov    0x10(%ebp),%eax
c0107075:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107078:	89 10                	mov    %edx,(%eax)
     return 0;
c010707a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010707f:	c9                   	leave  
c0107080:	c3                   	ret    

c0107081 <check_content_set>:



static inline void
check_content_set(void)
{
c0107081:	55                   	push   %ebp
c0107082:	89 e5                	mov    %esp,%ebp
c0107084:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0107087:	b8 00 10 00 00       	mov    $0x1000,%eax
c010708c:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c010708f:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107094:	83 f8 01             	cmp    $0x1,%eax
c0107097:	74 24                	je     c01070bd <check_content_set+0x3c>
c0107099:	c7 44 24 0c a6 d2 10 	movl   $0xc010d2a6,0xc(%esp)
c01070a0:	c0 
c01070a1:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c01070a8:	c0 
c01070a9:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c01070b0:	00 
c01070b1:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c01070b8:	e8 18 9d ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01070bd:	b8 10 10 00 00       	mov    $0x1010,%eax
c01070c2:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01070c5:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01070ca:	83 f8 01             	cmp    $0x1,%eax
c01070cd:	74 24                	je     c01070f3 <check_content_set+0x72>
c01070cf:	c7 44 24 0c a6 d2 10 	movl   $0xc010d2a6,0xc(%esp)
c01070d6:	c0 
c01070d7:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c01070de:	c0 
c01070df:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01070e6:	00 
c01070e7:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c01070ee:	e8 e2 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c01070f3:	b8 00 20 00 00       	mov    $0x2000,%eax
c01070f8:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01070fb:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107100:	83 f8 02             	cmp    $0x2,%eax
c0107103:	74 24                	je     c0107129 <check_content_set+0xa8>
c0107105:	c7 44 24 0c b5 d2 10 	movl   $0xc010d2b5,0xc(%esp)
c010710c:	c0 
c010710d:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c0107114:	c0 
c0107115:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c010711c:	00 
c010711d:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c0107124:	e8 ac 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0107129:	b8 10 20 00 00       	mov    $0x2010,%eax
c010712e:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0107131:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107136:	83 f8 02             	cmp    $0x2,%eax
c0107139:	74 24                	je     c010715f <check_content_set+0xde>
c010713b:	c7 44 24 0c b5 d2 10 	movl   $0xc010d2b5,0xc(%esp)
c0107142:	c0 
c0107143:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c010714a:	c0 
c010714b:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0107152:	00 
c0107153:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c010715a:	e8 76 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c010715f:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107164:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0107167:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c010716c:	83 f8 03             	cmp    $0x3,%eax
c010716f:	74 24                	je     c0107195 <check_content_set+0x114>
c0107171:	c7 44 24 0c c4 d2 10 	movl   $0xc010d2c4,0xc(%esp)
c0107178:	c0 
c0107179:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c0107180:	c0 
c0107181:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0107188:	00 
c0107189:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c0107190:	e8 40 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0107195:	b8 10 30 00 00       	mov    $0x3010,%eax
c010719a:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c010719d:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01071a2:	83 f8 03             	cmp    $0x3,%eax
c01071a5:	74 24                	je     c01071cb <check_content_set+0x14a>
c01071a7:	c7 44 24 0c c4 d2 10 	movl   $0xc010d2c4,0xc(%esp)
c01071ae:	c0 
c01071af:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c01071b6:	c0 
c01071b7:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01071be:	00 
c01071bf:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c01071c6:	e8 0a 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01071cb:	b8 00 40 00 00       	mov    $0x4000,%eax
c01071d0:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01071d3:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01071d8:	83 f8 04             	cmp    $0x4,%eax
c01071db:	74 24                	je     c0107201 <check_content_set+0x180>
c01071dd:	c7 44 24 0c d3 d2 10 	movl   $0xc010d2d3,0xc(%esp)
c01071e4:	c0 
c01071e5:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c01071ec:	c0 
c01071ed:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c01071f4:	00 
c01071f5:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c01071fc:	e8 d4 9b ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0107201:	b8 10 40 00 00       	mov    $0x4010,%eax
c0107206:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0107209:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c010720e:	83 f8 04             	cmp    $0x4,%eax
c0107211:	74 24                	je     c0107237 <check_content_set+0x1b6>
c0107213:	c7 44 24 0c d3 d2 10 	movl   $0xc010d2d3,0xc(%esp)
c010721a:	c0 
c010721b:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c0107222:	c0 
c0107223:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c010722a:	00 
c010722b:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c0107232:	e8 9e 9b ff ff       	call   c0100dd5 <__panic>
}
c0107237:	c9                   	leave  
c0107238:	c3                   	ret    

c0107239 <check_content_access>:

static inline int
check_content_access(void)
{
c0107239:	55                   	push   %ebp
c010723a:	89 e5                	mov    %esp,%ebp
c010723c:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c010723f:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0107244:	8b 40 1c             	mov    0x1c(%eax),%eax
c0107247:	ff d0                	call   *%eax
c0107249:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c010724c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010724f:	c9                   	leave  
c0107250:	c3                   	ret    

c0107251 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0107251:	55                   	push   %ebp
c0107252:	89 e5                	mov    %esp,%ebp
c0107254:	53                   	push   %ebx
c0107255:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0107258:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010725f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0107266:	c7 45 e8 b8 ef 19 c0 	movl   $0xc019efb8,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c010726d:	eb 6b                	jmp    c01072da <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c010726f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107272:	83 e8 0c             	sub    $0xc,%eax
c0107275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0107278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010727b:	83 c0 04             	add    $0x4,%eax
c010727e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0107285:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107288:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010728b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010728e:	0f a3 10             	bt     %edx,(%eax)
c0107291:	19 c0                	sbb    %eax,%eax
c0107293:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0107296:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010729a:	0f 95 c0             	setne  %al
c010729d:	0f b6 c0             	movzbl %al,%eax
c01072a0:	85 c0                	test   %eax,%eax
c01072a2:	75 24                	jne    c01072c8 <check_swap+0x77>
c01072a4:	c7 44 24 0c e2 d2 10 	movl   $0xc010d2e2,0xc(%esp)
c01072ab:	c0 
c01072ac:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c01072b3:	c0 
c01072b4:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c01072bb:	00 
c01072bc:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c01072c3:	e8 0d 9b ff ff       	call   c0100dd5 <__panic>
        count ++, total += p->property;
c01072c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01072cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01072cf:	8b 50 08             	mov    0x8(%eax),%edx
c01072d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072d5:	01 d0                	add    %edx,%eax
c01072d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01072da:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072dd:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01072e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01072e3:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01072e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01072e9:	81 7d e8 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x18(%ebp)
c01072f0:	0f 85 79 ff ff ff    	jne    c010726f <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c01072f6:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01072f9:	e8 d9 dd ff ff       	call   c01050d7 <nr_free_pages>
c01072fe:	39 c3                	cmp    %eax,%ebx
c0107300:	74 24                	je     c0107326 <check_swap+0xd5>
c0107302:	c7 44 24 0c f2 d2 10 	movl   $0xc010d2f2,0xc(%esp)
c0107309:	c0 
c010730a:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c0107311:	c0 
c0107312:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0107319:	00 
c010731a:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c0107321:	e8 af 9a ff ff       	call   c0100dd5 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0107326:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107329:	89 44 24 08          	mov    %eax,0x8(%esp)
c010732d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107330:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107334:	c7 04 24 0c d3 10 c0 	movl   $0xc010d30c,(%esp)
c010733b:	e8 13 90 ff ff       	call   c0100353 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0107340:	e8 52 0a 00 00       	call   c0107d97 <mm_create>
c0107345:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0107348:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010734c:	75 24                	jne    c0107372 <check_swap+0x121>
c010734e:	c7 44 24 0c 32 d3 10 	movl   $0xc010d332,0xc(%esp)
c0107355:	c0 
c0107356:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c010735d:	c0 
c010735e:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0107365:	00 
c0107366:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c010736d:	e8 63 9a ff ff       	call   c0100dd5 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0107372:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0107377:	85 c0                	test   %eax,%eax
c0107379:	74 24                	je     c010739f <check_swap+0x14e>
c010737b:	c7 44 24 0c 3d d3 10 	movl   $0xc010d33d,0xc(%esp)
c0107382:	c0 
c0107383:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c010738a:	c0 
c010738b:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0107392:	00 
c0107393:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c010739a:	e8 36 9a ff ff       	call   c0100dd5 <__panic>

     check_mm_struct = mm;
c010739f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073a2:	a3 ac f0 19 c0       	mov    %eax,0xc019f0ac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c01073a7:	8b 15 e4 ce 19 c0    	mov    0xc019cee4,%edx
c01073ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073b0:	89 50 0c             	mov    %edx,0xc(%eax)
c01073b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073b6:	8b 40 0c             	mov    0xc(%eax),%eax
c01073b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c01073bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01073bf:	8b 00                	mov    (%eax),%eax
c01073c1:	85 c0                	test   %eax,%eax
c01073c3:	74 24                	je     c01073e9 <check_swap+0x198>
c01073c5:	c7 44 24 0c 55 d3 10 	movl   $0xc010d355,0xc(%esp)
c01073cc:	c0 
c01073cd:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c01073d4:	c0 
c01073d5:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c01073dc:	00 
c01073dd:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c01073e4:	e8 ec 99 ff ff       	call   c0100dd5 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01073e9:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c01073f0:	00 
c01073f1:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c01073f8:	00 
c01073f9:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0107400:	e8 2b 0a 00 00       	call   c0107e30 <vma_create>
c0107405:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0107408:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010740c:	75 24                	jne    c0107432 <check_swap+0x1e1>
c010740e:	c7 44 24 0c 63 d3 10 	movl   $0xc010d363,0xc(%esp)
c0107415:	c0 
c0107416:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c010741d:	c0 
c010741e:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0107425:	00 
c0107426:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c010742d:	e8 a3 99 ff ff       	call   c0100dd5 <__panic>

     insert_vma_struct(mm, vma);
c0107432:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107435:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107439:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010743c:	89 04 24             	mov    %eax,(%esp)
c010743f:	e8 7c 0b 00 00       	call   c0107fc0 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0107444:	c7 04 24 70 d3 10 c0 	movl   $0xc010d370,(%esp)
c010744b:	e8 03 8f ff ff       	call   c0100353 <cprintf>
     pte_t *temp_ptep=NULL;
c0107450:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0107457:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010745a:	8b 40 0c             	mov    0xc(%eax),%eax
c010745d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107464:	00 
c0107465:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010746c:	00 
c010746d:	89 04 24             	mov    %eax,(%esp)
c0107470:	e8 2c e3 ff ff       	call   c01057a1 <get_pte>
c0107475:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0107478:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010747c:	75 24                	jne    c01074a2 <check_swap+0x251>
c010747e:	c7 44 24 0c a4 d3 10 	movl   $0xc010d3a4,0xc(%esp)
c0107485:	c0 
c0107486:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c010748d:	c0 
c010748e:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0107495:	00 
c0107496:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c010749d:	e8 33 99 ff ff       	call   c0100dd5 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01074a2:	c7 04 24 b8 d3 10 c0 	movl   $0xc010d3b8,(%esp)
c01074a9:	e8 a5 8e ff ff       	call   c0100353 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01074ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01074b5:	e9 a3 00 00 00       	jmp    c010755d <check_swap+0x30c>
          check_rp[i] = alloc_page();
c01074ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01074c1:	e8 74 db ff ff       	call   c010503a <alloc_pages>
c01074c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01074c9:	89 04 95 e0 ef 19 c0 	mov    %eax,-0x3fe61020(,%edx,4)
          assert(check_rp[i] != NULL );
c01074d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074d3:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c01074da:	85 c0                	test   %eax,%eax
c01074dc:	75 24                	jne    c0107502 <check_swap+0x2b1>
c01074de:	c7 44 24 0c dc d3 10 	movl   $0xc010d3dc,0xc(%esp)
c01074e5:	c0 
c01074e6:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c01074ed:	c0 
c01074ee:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01074f5:	00 
c01074f6:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c01074fd:	e8 d3 98 ff ff       	call   c0100dd5 <__panic>
          assert(!PageProperty(check_rp[i]));
c0107502:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107505:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c010750c:	83 c0 04             	add    $0x4,%eax
c010750f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0107516:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107519:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010751c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010751f:	0f a3 10             	bt     %edx,(%eax)
c0107522:	19 c0                	sbb    %eax,%eax
c0107524:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0107527:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c010752b:	0f 95 c0             	setne  %al
c010752e:	0f b6 c0             	movzbl %al,%eax
c0107531:	85 c0                	test   %eax,%eax
c0107533:	74 24                	je     c0107559 <check_swap+0x308>
c0107535:	c7 44 24 0c f0 d3 10 	movl   $0xc010d3f0,0xc(%esp)
c010753c:	c0 
c010753d:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c0107544:	c0 
c0107545:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010754c:	00 
c010754d:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c0107554:	e8 7c 98 ff ff       	call   c0100dd5 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107559:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010755d:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107561:	0f 8e 53 ff ff ff    	jle    c01074ba <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0107567:	a1 b8 ef 19 c0       	mov    0xc019efb8,%eax
c010756c:	8b 15 bc ef 19 c0    	mov    0xc019efbc,%edx
c0107572:	89 45 98             	mov    %eax,-0x68(%ebp)
c0107575:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0107578:	c7 45 a8 b8 ef 19 c0 	movl   $0xc019efb8,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010757f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107582:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0107585:	89 50 04             	mov    %edx,0x4(%eax)
c0107588:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010758b:	8b 50 04             	mov    0x4(%eax),%edx
c010758e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107591:	89 10                	mov    %edx,(%eax)
c0107593:	c7 45 a4 b8 ef 19 c0 	movl   $0xc019efb8,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010759a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010759d:	8b 40 04             	mov    0x4(%eax),%eax
c01075a0:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c01075a3:	0f 94 c0             	sete   %al
c01075a6:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c01075a9:	85 c0                	test   %eax,%eax
c01075ab:	75 24                	jne    c01075d1 <check_swap+0x380>
c01075ad:	c7 44 24 0c 0b d4 10 	movl   $0xc010d40b,0xc(%esp)
c01075b4:	c0 
c01075b5:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c01075bc:	c0 
c01075bd:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c01075c4:	00 
c01075c5:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c01075cc:	e8 04 98 ff ff       	call   c0100dd5 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c01075d1:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01075d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c01075d9:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c01075e0:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01075e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01075ea:	eb 1e                	jmp    c010760a <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c01075ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01075ef:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c01075f6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01075fd:	00 
c01075fe:	89 04 24             	mov    %eax,(%esp)
c0107601:	e8 9f da ff ff       	call   c01050a5 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107606:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010760a:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010760e:	7e dc                	jle    c01075ec <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0107610:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0107615:	83 f8 04             	cmp    $0x4,%eax
c0107618:	74 24                	je     c010763e <check_swap+0x3ed>
c010761a:	c7 44 24 0c 24 d4 10 	movl   $0xc010d424,0xc(%esp)
c0107621:	c0 
c0107622:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c0107629:	c0 
c010762a:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0107631:	00 
c0107632:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c0107639:	e8 97 97 ff ff       	call   c0100dd5 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c010763e:	c7 04 24 48 d4 10 c0 	movl   $0xc010d448,(%esp)
c0107645:	e8 09 8d ff ff       	call   c0100353 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c010764a:	c7 05 78 cf 19 c0 00 	movl   $0x0,0xc019cf78
c0107651:	00 00 00 
     
     check_content_set();
c0107654:	e8 28 fa ff ff       	call   c0107081 <check_content_set>
     assert( nr_free == 0);         
c0107659:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c010765e:	85 c0                	test   %eax,%eax
c0107660:	74 24                	je     c0107686 <check_swap+0x435>
c0107662:	c7 44 24 0c 6f d4 10 	movl   $0xc010d46f,0xc(%esp)
c0107669:	c0 
c010766a:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c0107671:	c0 
c0107672:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0107679:	00 
c010767a:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c0107681:	e8 4f 97 ff ff       	call   c0100dd5 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0107686:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010768d:	eb 26                	jmp    c01076b5 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c010768f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107692:	c7 04 85 00 f0 19 c0 	movl   $0xffffffff,-0x3fe61000(,%eax,4)
c0107699:	ff ff ff ff 
c010769d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076a0:	8b 14 85 00 f0 19 c0 	mov    -0x3fe61000(,%eax,4),%edx
c01076a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076aa:	89 14 85 40 f0 19 c0 	mov    %edx,-0x3fe60fc0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01076b1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01076b5:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c01076b9:	7e d4                	jle    c010768f <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01076bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01076c2:	e9 eb 00 00 00       	jmp    c01077b2 <check_swap+0x561>
         check_ptep[i]=0;
c01076c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076ca:	c7 04 85 94 f0 19 c0 	movl   $0x0,-0x3fe60f6c(,%eax,4)
c01076d1:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c01076d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076d8:	83 c0 01             	add    $0x1,%eax
c01076db:	c1 e0 0c             	shl    $0xc,%eax
c01076de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01076e5:	00 
c01076e6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01076ed:	89 04 24             	mov    %eax,(%esp)
c01076f0:	e8 ac e0 ff ff       	call   c01057a1 <get_pte>
c01076f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01076f8:	89 04 95 94 f0 19 c0 	mov    %eax,-0x3fe60f6c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c01076ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107702:	8b 04 85 94 f0 19 c0 	mov    -0x3fe60f6c(,%eax,4),%eax
c0107709:	85 c0                	test   %eax,%eax
c010770b:	75 24                	jne    c0107731 <check_swap+0x4e0>
c010770d:	c7 44 24 0c 7c d4 10 	movl   $0xc010d47c,0xc(%esp)
c0107714:	c0 
c0107715:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c010771c:	c0 
c010771d:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0107724:	00 
c0107725:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c010772c:	e8 a4 96 ff ff       	call   c0100dd5 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0107731:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107734:	8b 04 85 94 f0 19 c0 	mov    -0x3fe60f6c(,%eax,4),%eax
c010773b:	8b 00                	mov    (%eax),%eax
c010773d:	89 04 24             	mov    %eax,(%esp)
c0107740:	e8 9f f5 ff ff       	call   c0106ce4 <pte2page>
c0107745:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107748:	8b 14 95 e0 ef 19 c0 	mov    -0x3fe61020(,%edx,4),%edx
c010774f:	39 d0                	cmp    %edx,%eax
c0107751:	74 24                	je     c0107777 <check_swap+0x526>
c0107753:	c7 44 24 0c 94 d4 10 	movl   $0xc010d494,0xc(%esp)
c010775a:	c0 
c010775b:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c0107762:	c0 
c0107763:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c010776a:	00 
c010776b:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c0107772:	e8 5e 96 ff ff       	call   c0100dd5 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0107777:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010777a:	8b 04 85 94 f0 19 c0 	mov    -0x3fe60f6c(,%eax,4),%eax
c0107781:	8b 00                	mov    (%eax),%eax
c0107783:	83 e0 01             	and    $0x1,%eax
c0107786:	85 c0                	test   %eax,%eax
c0107788:	75 24                	jne    c01077ae <check_swap+0x55d>
c010778a:	c7 44 24 0c bc d4 10 	movl   $0xc010d4bc,0xc(%esp)
c0107791:	c0 
c0107792:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c0107799:	c0 
c010779a:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01077a1:	00 
c01077a2:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c01077a9:	e8 27 96 ff ff       	call   c0100dd5 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01077ae:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01077b2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01077b6:	0f 8e 0b ff ff ff    	jle    c01076c7 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c01077bc:	c7 04 24 d8 d4 10 c0 	movl   $0xc010d4d8,(%esp)
c01077c3:	e8 8b 8b ff ff       	call   c0100353 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c01077c8:	e8 6c fa ff ff       	call   c0107239 <check_content_access>
c01077cd:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c01077d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01077d4:	74 24                	je     c01077fa <check_swap+0x5a9>
c01077d6:	c7 44 24 0c fe d4 10 	movl   $0xc010d4fe,0xc(%esp)
c01077dd:	c0 
c01077de:	c7 44 24 08 e6 d1 10 	movl   $0xc010d1e6,0x8(%esp)
c01077e5:	c0 
c01077e6:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c01077ed:	00 
c01077ee:	c7 04 24 80 d1 10 c0 	movl   $0xc010d180,(%esp)
c01077f5:	e8 db 95 ff ff       	call   c0100dd5 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01077fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107801:	eb 1e                	jmp    c0107821 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0107803:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107806:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c010780d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107814:	00 
c0107815:	89 04 24             	mov    %eax,(%esp)
c0107818:	e8 88 d8 ff ff       	call   c01050a5 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010781d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107821:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107825:	7e dc                	jle    c0107803 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
    free_page(pa2page(pgdir[0]));
c0107827:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010782a:	8b 00                	mov    (%eax),%eax
c010782c:	89 04 24             	mov    %eax,(%esp)
c010782f:	e8 6b f4 ff ff       	call   c0106c9f <pa2page>
c0107834:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010783b:	00 
c010783c:	89 04 24             	mov    %eax,(%esp)
c010783f:	e8 61 d8 ff ff       	call   c01050a5 <free_pages>
     pgdir[0] = 0;
c0107844:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107847:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     mm->pgdir = NULL;
c010784d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107850:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
     mm_destroy(mm);
c0107857:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010785a:	89 04 24             	mov    %eax,(%esp)
c010785d:	e8 8e 08 00 00       	call   c01080f0 <mm_destroy>
     check_mm_struct = NULL;
c0107862:	c7 05 ac f0 19 c0 00 	movl   $0x0,0xc019f0ac
c0107869:	00 00 00 
     
     nr_free = nr_free_store;
c010786c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010786f:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
     free_list = free_list_store;
c0107874:	8b 45 98             	mov    -0x68(%ebp),%eax
c0107877:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010787a:	a3 b8 ef 19 c0       	mov    %eax,0xc019efb8
c010787f:	89 15 bc ef 19 c0    	mov    %edx,0xc019efbc

     
     le = &free_list;
c0107885:	c7 45 e8 b8 ef 19 c0 	movl   $0xc019efb8,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c010788c:	eb 1d                	jmp    c01078ab <check_swap+0x65a>
         struct Page *p = le2page(le, page_link);
c010788e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107891:	83 e8 0c             	sub    $0xc,%eax
c0107894:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0107897:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010789b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010789e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01078a1:	8b 40 08             	mov    0x8(%eax),%eax
c01078a4:	29 c2                	sub    %eax,%edx
c01078a6:	89 d0                	mov    %edx,%eax
c01078a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01078ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01078ae:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01078b1:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01078b4:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01078b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01078ba:	81 7d e8 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x18(%ebp)
c01078c1:	75 cb                	jne    c010788e <check_swap+0x63d>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c01078c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078c6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01078ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078d1:	c7 04 24 05 d5 10 c0 	movl   $0xc010d505,(%esp)
c01078d8:	e8 76 8a ff ff       	call   c0100353 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c01078dd:	c7 04 24 1f d5 10 c0 	movl   $0xc010d51f,(%esp)
c01078e4:	e8 6a 8a ff ff       	call   c0100353 <cprintf>
}
c01078e9:	83 c4 74             	add    $0x74,%esp
c01078ec:	5b                   	pop    %ebx
c01078ed:	5d                   	pop    %ebp
c01078ee:	c3                   	ret    

c01078ef <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c01078ef:	55                   	push   %ebp
c01078f0:	89 e5                	mov    %esp,%ebp
c01078f2:	83 ec 10             	sub    $0x10,%esp
c01078f5:	c7 45 fc a4 f0 19 c0 	movl   $0xc019f0a4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01078fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01078ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107902:	89 50 04             	mov    %edx,0x4(%eax)
c0107905:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107908:	8b 50 04             	mov    0x4(%eax),%edx
c010790b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010790e:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0107910:	8b 45 08             	mov    0x8(%ebp),%eax
c0107913:	c7 40 14 a4 f0 19 c0 	movl   $0xc019f0a4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c010791a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010791f:	c9                   	leave  
c0107920:	c3                   	ret    

c0107921 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0107921:	55                   	push   %ebp
c0107922:	89 e5                	mov    %esp,%ebp
c0107924:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107927:	8b 45 08             	mov    0x8(%ebp),%eax
c010792a:	8b 40 14             	mov    0x14(%eax),%eax
c010792d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0107930:	8b 45 10             	mov    0x10(%ebp),%eax
c0107933:	83 c0 14             	add    $0x14,%eax
c0107936:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0107939:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010793d:	74 06                	je     c0107945 <_fifo_map_swappable+0x24>
c010793f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107943:	75 24                	jne    c0107969 <_fifo_map_swappable+0x48>
c0107945:	c7 44 24 0c 38 d5 10 	movl   $0xc010d538,0xc(%esp)
c010794c:	c0 
c010794d:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c0107954:	c0 
c0107955:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c010795c:	00 
c010795d:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c0107964:	e8 6c 94 ff ff       	call   c0100dd5 <__panic>
c0107969:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010796c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010796f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107972:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107975:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010797b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010797e:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107984:	8b 40 04             	mov    0x4(%eax),%eax
c0107987:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010798a:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010798d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107990:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0107993:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107996:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107999:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010799c:	89 10                	mov    %edx,(%eax)
c010799e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01079a1:	8b 10                	mov    (%eax),%edx
c01079a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01079a6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01079a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01079ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01079af:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01079b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01079b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01079b8:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    // 在头部插入
    list_add(head, entry);				// 用list_add()和list_add_after()都行，查看下这个双向链表的操作函数（在list.h）就知道了。
    return 0;
c01079ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01079bf:	c9                   	leave  
c01079c0:	c3                   	ret    

c01079c1 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c01079c1:	55                   	push   %ebp
c01079c2:	89 e5                	mov    %esp,%ebp
c01079c4:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01079c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01079ca:	8b 40 14             	mov    0x14(%eax),%eax
c01079cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c01079d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01079d4:	75 24                	jne    c01079fa <_fifo_swap_out_victim+0x39>
c01079d6:	c7 44 24 0c 7f d5 10 	movl   $0xc010d57f,0xc(%esp)
c01079dd:	c0 
c01079de:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c01079e5:	c0 
c01079e6:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c01079ed:	00 
c01079ee:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c01079f5:	e8 db 93 ff ff       	call   c0100dd5 <__panic>
     assert(in_tick==0);
c01079fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01079fe:	74 24                	je     c0107a24 <_fifo_swap_out_victim+0x63>
c0107a00:	c7 44 24 0c 8c d5 10 	movl   $0xc010d58c,0xc(%esp)
c0107a07:	c0 
c0107a08:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c0107a0f:	c0 
c0107a10:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
c0107a17:	00 
c0107a18:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c0107a1f:	e8 b1 93 ff ff       	call   c0100dd5 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     // 尾部删除，因为是双向链表，所以很方便找到尾部
     // tail指向尾部
     list_entry_t *tail = head->prev;
c0107a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a27:	8b 00                	mov    (%eax),%eax
c0107a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page *page = le2page(tail, pra_page_link);
c0107a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a2f:	83 e8 14             	sub    $0x14,%eax
c0107a32:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a38:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107a3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a3e:	8b 40 04             	mov    0x4(%eax),%eax
c0107a41:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107a44:	8b 12                	mov    (%edx),%edx
c0107a46:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107a49:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107a52:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107a55:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107a58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107a5b:	89 10                	mov    %edx,(%eax)
     list_del(tail);
     //(2)  set the addr of addr of this page to ptr_page
     *ptr_page = page;
c0107a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a60:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107a63:	89 10                	mov    %edx,(%eax)
     return 0;
c0107a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107a6a:	c9                   	leave  
c0107a6b:	c3                   	ret    

c0107a6c <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0107a6c:	55                   	push   %ebp
c0107a6d:	89 e5                	mov    %esp,%ebp
c0107a6f:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107a72:	c7 04 24 98 d5 10 c0 	movl   $0xc010d598,(%esp)
c0107a79:	e8 d5 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107a7e:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107a83:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0107a86:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107a8b:	83 f8 04             	cmp    $0x4,%eax
c0107a8e:	74 24                	je     c0107ab4 <_fifo_check_swap+0x48>
c0107a90:	c7 44 24 0c be d5 10 	movl   $0xc010d5be,0xc(%esp)
c0107a97:	c0 
c0107a98:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c0107a9f:	c0 
c0107aa0:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0107aa7:	00 
c0107aa8:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c0107aaf:	e8 21 93 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107ab4:	c7 04 24 d0 d5 10 c0 	movl   $0xc010d5d0,(%esp)
c0107abb:	e8 93 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107ac0:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107ac5:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0107ac8:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107acd:	83 f8 04             	cmp    $0x4,%eax
c0107ad0:	74 24                	je     c0107af6 <_fifo_check_swap+0x8a>
c0107ad2:	c7 44 24 0c be d5 10 	movl   $0xc010d5be,0xc(%esp)
c0107ad9:	c0 
c0107ada:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c0107ae1:	c0 
c0107ae2:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c0107ae9:	00 
c0107aea:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c0107af1:	e8 df 92 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107af6:	c7 04 24 f8 d5 10 c0 	movl   $0xc010d5f8,(%esp)
c0107afd:	e8 51 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107b02:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107b07:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0107b0a:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107b0f:	83 f8 04             	cmp    $0x4,%eax
c0107b12:	74 24                	je     c0107b38 <_fifo_check_swap+0xcc>
c0107b14:	c7 44 24 0c be d5 10 	movl   $0xc010d5be,0xc(%esp)
c0107b1b:	c0 
c0107b1c:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c0107b23:	c0 
c0107b24:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0107b2b:	00 
c0107b2c:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c0107b33:	e8 9d 92 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107b38:	c7 04 24 20 d6 10 c0 	movl   $0xc010d620,(%esp)
c0107b3f:	e8 0f 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107b44:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107b49:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0107b4c:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107b51:	83 f8 04             	cmp    $0x4,%eax
c0107b54:	74 24                	je     c0107b7a <_fifo_check_swap+0x10e>
c0107b56:	c7 44 24 0c be d5 10 	movl   $0xc010d5be,0xc(%esp)
c0107b5d:	c0 
c0107b5e:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c0107b65:	c0 
c0107b66:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107b6d:	00 
c0107b6e:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c0107b75:	e8 5b 92 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107b7a:	c7 04 24 48 d6 10 c0 	movl   $0xc010d648,(%esp)
c0107b81:	e8 cd 87 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107b86:	b8 00 50 00 00       	mov    $0x5000,%eax
c0107b8b:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0107b8e:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107b93:	83 f8 05             	cmp    $0x5,%eax
c0107b96:	74 24                	je     c0107bbc <_fifo_check_swap+0x150>
c0107b98:	c7 44 24 0c 6e d6 10 	movl   $0xc010d66e,0xc(%esp)
c0107b9f:	c0 
c0107ba0:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c0107ba7:	c0 
c0107ba8:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0107baf:	00 
c0107bb0:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c0107bb7:	e8 19 92 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107bbc:	c7 04 24 20 d6 10 c0 	movl   $0xc010d620,(%esp)
c0107bc3:	e8 8b 87 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107bc8:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107bcd:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107bd0:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107bd5:	83 f8 05             	cmp    $0x5,%eax
c0107bd8:	74 24                	je     c0107bfe <_fifo_check_swap+0x192>
c0107bda:	c7 44 24 0c 6e d6 10 	movl   $0xc010d66e,0xc(%esp)
c0107be1:	c0 
c0107be2:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c0107be9:	c0 
c0107bea:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0107bf1:	00 
c0107bf2:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c0107bf9:	e8 d7 91 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107bfe:	c7 04 24 d0 d5 10 c0 	movl   $0xc010d5d0,(%esp)
c0107c05:	e8 49 87 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107c0a:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107c0f:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0107c12:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107c17:	83 f8 06             	cmp    $0x6,%eax
c0107c1a:	74 24                	je     c0107c40 <_fifo_check_swap+0x1d4>
c0107c1c:	c7 44 24 0c 7d d6 10 	movl   $0xc010d67d,0xc(%esp)
c0107c23:	c0 
c0107c24:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c0107c2b:	c0 
c0107c2c:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0107c33:	00 
c0107c34:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c0107c3b:	e8 95 91 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107c40:	c7 04 24 20 d6 10 c0 	movl   $0xc010d620,(%esp)
c0107c47:	e8 07 87 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107c4c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107c51:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0107c54:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107c59:	83 f8 07             	cmp    $0x7,%eax
c0107c5c:	74 24                	je     c0107c82 <_fifo_check_swap+0x216>
c0107c5e:	c7 44 24 0c 8c d6 10 	movl   $0xc010d68c,0xc(%esp)
c0107c65:	c0 
c0107c66:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c0107c6d:	c0 
c0107c6e:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0107c75:	00 
c0107c76:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c0107c7d:	e8 53 91 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107c82:	c7 04 24 98 d5 10 c0 	movl   $0xc010d598,(%esp)
c0107c89:	e8 c5 86 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107c8e:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107c93:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107c96:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107c9b:	83 f8 08             	cmp    $0x8,%eax
c0107c9e:	74 24                	je     c0107cc4 <_fifo_check_swap+0x258>
c0107ca0:	c7 44 24 0c 9b d6 10 	movl   $0xc010d69b,0xc(%esp)
c0107ca7:	c0 
c0107ca8:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c0107caf:	c0 
c0107cb0:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0107cb7:	00 
c0107cb8:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c0107cbf:	e8 11 91 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107cc4:	c7 04 24 f8 d5 10 c0 	movl   $0xc010d5f8,(%esp)
c0107ccb:	e8 83 86 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107cd0:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107cd5:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107cd8:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107cdd:	83 f8 09             	cmp    $0x9,%eax
c0107ce0:	74 24                	je     c0107d06 <_fifo_check_swap+0x29a>
c0107ce2:	c7 44 24 0c aa d6 10 	movl   $0xc010d6aa,0xc(%esp)
c0107ce9:	c0 
c0107cea:	c7 44 24 08 56 d5 10 	movl   $0xc010d556,0x8(%esp)
c0107cf1:	c0 
c0107cf2:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0107cf9:	00 
c0107cfa:	c7 04 24 6b d5 10 c0 	movl   $0xc010d56b,(%esp)
c0107d01:	e8 cf 90 ff ff       	call   c0100dd5 <__panic>
    return 0;
c0107d06:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107d0b:	c9                   	leave  
c0107d0c:	c3                   	ret    

c0107d0d <_fifo_init>:


static int
_fifo_init(void)
{
c0107d0d:	55                   	push   %ebp
c0107d0e:	89 e5                	mov    %esp,%ebp
    return 0;
c0107d10:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107d15:	5d                   	pop    %ebp
c0107d16:	c3                   	ret    

c0107d17 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107d17:	55                   	push   %ebp
c0107d18:	89 e5                	mov    %esp,%ebp
    return 0;
c0107d1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107d1f:	5d                   	pop    %ebp
c0107d20:	c3                   	ret    

c0107d21 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107d21:	55                   	push   %ebp
c0107d22:	89 e5                	mov    %esp,%ebp
c0107d24:	b8 00 00 00 00       	mov    $0x0,%eax
c0107d29:	5d                   	pop    %ebp
c0107d2a:	c3                   	ret    

c0107d2b <lock_init>:
#define local_intr_restore(x)   __intr_restore(x);

typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock) {
c0107d2b:	55                   	push   %ebp
c0107d2c:	89 e5                	mov    %esp,%ebp
    *lock = 0;
c0107d2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c0107d37:	5d                   	pop    %ebp
c0107d38:	c3                   	ret    

c0107d39 <mm_count>:
bool user_mem_check(struct mm_struct *mm, uintptr_t start, size_t len, bool write);
bool copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable);
bool copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len);

static inline int
mm_count(struct mm_struct *mm) {
c0107d39:	55                   	push   %ebp
c0107d3a:	89 e5                	mov    %esp,%ebp
    return mm->mm_count;
c0107d3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d3f:	8b 40 18             	mov    0x18(%eax),%eax
}
c0107d42:	5d                   	pop    %ebp
c0107d43:	c3                   	ret    

c0107d44 <set_mm_count>:

static inline void
set_mm_count(struct mm_struct *mm, int val) {
c0107d44:	55                   	push   %ebp
c0107d45:	89 e5                	mov    %esp,%ebp
    mm->mm_count = val;
c0107d47:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d4a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107d4d:	89 50 18             	mov    %edx,0x18(%eax)
}
c0107d50:	5d                   	pop    %ebp
c0107d51:	c3                   	ret    

c0107d52 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0107d52:	55                   	push   %ebp
c0107d53:	89 e5                	mov    %esp,%ebp
c0107d55:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107d58:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d5b:	c1 e8 0c             	shr    $0xc,%eax
c0107d5e:	89 c2                	mov    %eax,%edx
c0107d60:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0107d65:	39 c2                	cmp    %eax,%edx
c0107d67:	72 1c                	jb     c0107d85 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107d69:	c7 44 24 08 cc d6 10 	movl   $0xc010d6cc,0x8(%esp)
c0107d70:	c0 
c0107d71:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107d78:	00 
c0107d79:	c7 04 24 eb d6 10 c0 	movl   $0xc010d6eb,(%esp)
c0107d80:	e8 50 90 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0107d85:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0107d8a:	8b 55 08             	mov    0x8(%ebp),%edx
c0107d8d:	c1 ea 0c             	shr    $0xc,%edx
c0107d90:	c1 e2 05             	shl    $0x5,%edx
c0107d93:	01 d0                	add    %edx,%eax
}
c0107d95:	c9                   	leave  
c0107d96:	c3                   	ret    

c0107d97 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107d97:	55                   	push   %ebp
c0107d98:	89 e5                	mov    %esp,%ebp
c0107d9a:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0107d9d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0107da4:	e8 1c ce ff ff       	call   c0104bc5 <kmalloc>
c0107da9:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0107dac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107db0:	74 79                	je     c0107e2b <mm_create+0x94>
        list_init(&(mm->mmap_list));
c0107db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107dbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107dbe:	89 50 04             	mov    %edx,0x4(%eax)
c0107dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107dc4:	8b 50 04             	mov    0x4(%eax),%edx
c0107dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107dca:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0107dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dcf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dd9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107de3:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107dea:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c0107def:	85 c0                	test   %eax,%eax
c0107df1:	74 0d                	je     c0107e00 <mm_create+0x69>
c0107df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107df6:	89 04 24             	mov    %eax,(%esp)
c0107df9:	e8 b4 ef ff ff       	call   c0106db2 <swap_init_mm>
c0107dfe:	eb 0a                	jmp    c0107e0a <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e03:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        
        set_mm_count(mm, 0);
c0107e0a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107e11:	00 
c0107e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e15:	89 04 24             	mov    %eax,(%esp)
c0107e18:	e8 27 ff ff ff       	call   c0107d44 <set_mm_count>
        lock_init(&(mm->mm_lock));
c0107e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e20:	83 c0 1c             	add    $0x1c,%eax
c0107e23:	89 04 24             	mov    %eax,(%esp)
c0107e26:	e8 00 ff ff ff       	call   c0107d2b <lock_init>
    }    
    return mm;
c0107e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107e2e:	c9                   	leave  
c0107e2f:	c3                   	ret    

c0107e30 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107e30:	55                   	push   %ebp
c0107e31:	89 e5                	mov    %esp,%ebp
c0107e33:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107e36:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107e3d:	e8 83 cd ff ff       	call   c0104bc5 <kmalloc>
c0107e42:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107e45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107e49:	74 1b                	je     c0107e66 <vma_create+0x36>
        vma->vm_start = vm_start;
c0107e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e4e:	8b 55 08             	mov    0x8(%ebp),%edx
c0107e51:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e57:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107e5a:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e60:	8b 55 10             	mov    0x10(%ebp),%edx
c0107e63:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0107e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107e69:	c9                   	leave  
c0107e6a:	c3                   	ret    

c0107e6b <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107e6b:	55                   	push   %ebp
c0107e6c:	89 e5                	mov    %esp,%ebp
c0107e6e:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107e71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0107e78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107e7c:	0f 84 95 00 00 00    	je     c0107f17 <find_vma+0xac>
        vma = mm->mmap_cache;
c0107e82:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e85:	8b 40 08             	mov    0x8(%eax),%eax
c0107e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0107e8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107e8f:	74 16                	je     c0107ea7 <find_vma+0x3c>
c0107e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107e94:	8b 40 04             	mov    0x4(%eax),%eax
c0107e97:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107e9a:	77 0b                	ja     c0107ea7 <find_vma+0x3c>
c0107e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107e9f:	8b 40 08             	mov    0x8(%eax),%eax
c0107ea2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107ea5:	77 61                	ja     c0107f08 <find_vma+0x9d>
                bool found = 0;
c0107ea7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0107eae:	8b 45 08             	mov    0x8(%ebp),%eax
c0107eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107eba:	eb 28                	jmp    c0107ee4 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0107ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ebf:	83 e8 10             	sub    $0x10,%eax
c0107ec2:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0107ec5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107ec8:	8b 40 04             	mov    0x4(%eax),%eax
c0107ecb:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107ece:	77 14                	ja     c0107ee4 <find_vma+0x79>
c0107ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107ed3:	8b 40 08             	mov    0x8(%eax),%eax
c0107ed6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107ed9:	76 09                	jbe    c0107ee4 <find_vma+0x79>
                        found = 1;
c0107edb:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0107ee2:	eb 17                	jmp    c0107efb <find_vma+0x90>
c0107ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ee7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107eed:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0107ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ef6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107ef9:	75 c1                	jne    c0107ebc <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107efb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107eff:	75 07                	jne    c0107f08 <find_vma+0x9d>
                    vma = NULL;
c0107f01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107f08:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107f0c:	74 09                	je     c0107f17 <find_vma+0xac>
            mm->mmap_cache = vma;
c0107f0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f11:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107f14:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107f1a:	c9                   	leave  
c0107f1b:	c3                   	ret    

c0107f1c <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107f1c:	55                   	push   %ebp
c0107f1d:	89 e5                	mov    %esp,%ebp
c0107f1f:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107f22:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f25:	8b 50 04             	mov    0x4(%eax),%edx
c0107f28:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f2b:	8b 40 08             	mov    0x8(%eax),%eax
c0107f2e:	39 c2                	cmp    %eax,%edx
c0107f30:	72 24                	jb     c0107f56 <check_vma_overlap+0x3a>
c0107f32:	c7 44 24 0c f9 d6 10 	movl   $0xc010d6f9,0xc(%esp)
c0107f39:	c0 
c0107f3a:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0107f41:	c0 
c0107f42:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0107f49:	00 
c0107f4a:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0107f51:	e8 7f 8e ff ff       	call   c0100dd5 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107f56:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f59:	8b 50 08             	mov    0x8(%eax),%edx
c0107f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f5f:	8b 40 04             	mov    0x4(%eax),%eax
c0107f62:	39 c2                	cmp    %eax,%edx
c0107f64:	76 24                	jbe    c0107f8a <check_vma_overlap+0x6e>
c0107f66:	c7 44 24 0c 3c d7 10 	movl   $0xc010d73c,0xc(%esp)
c0107f6d:	c0 
c0107f6e:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0107f75:	c0 
c0107f76:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107f7d:	00 
c0107f7e:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0107f85:	e8 4b 8e ff ff       	call   c0100dd5 <__panic>
    assert(next->vm_start < next->vm_end);
c0107f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f8d:	8b 50 04             	mov    0x4(%eax),%edx
c0107f90:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f93:	8b 40 08             	mov    0x8(%eax),%eax
c0107f96:	39 c2                	cmp    %eax,%edx
c0107f98:	72 24                	jb     c0107fbe <check_vma_overlap+0xa2>
c0107f9a:	c7 44 24 0c 5b d7 10 	movl   $0xc010d75b,0xc(%esp)
c0107fa1:	c0 
c0107fa2:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0107fa9:	c0 
c0107faa:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0107fb1:	00 
c0107fb2:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0107fb9:	e8 17 8e ff ff       	call   c0100dd5 <__panic>
}
c0107fbe:	c9                   	leave  
c0107fbf:	c3                   	ret    

c0107fc0 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0107fc0:	55                   	push   %ebp
c0107fc1:	89 e5                	mov    %esp,%ebp
c0107fc3:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fc9:	8b 50 04             	mov    0x4(%eax),%edx
c0107fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fcf:	8b 40 08             	mov    0x8(%eax),%eax
c0107fd2:	39 c2                	cmp    %eax,%edx
c0107fd4:	72 24                	jb     c0107ffa <insert_vma_struct+0x3a>
c0107fd6:	c7 44 24 0c 79 d7 10 	movl   $0xc010d779,0xc(%esp)
c0107fdd:	c0 
c0107fde:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0107fe5:	c0 
c0107fe6:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0107fed:	00 
c0107fee:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0107ff5:	e8 db 8d ff ff       	call   c0100dd5 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107ffa:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ffd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0108000:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108003:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0108006:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108009:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c010800c:	eb 21                	jmp    c010802f <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c010800e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108011:	83 e8 10             	sub    $0x10,%eax
c0108014:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0108017:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010801a:	8b 50 04             	mov    0x4(%eax),%edx
c010801d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108020:	8b 40 04             	mov    0x4(%eax),%eax
c0108023:	39 c2                	cmp    %eax,%edx
c0108025:	76 02                	jbe    c0108029 <insert_vma_struct+0x69>
                break;
c0108027:	eb 1d                	jmp    c0108046 <insert_vma_struct+0x86>
            }
            le_prev = le;
c0108029:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010802c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010802f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108032:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108035:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108038:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c010803b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010803e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108041:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108044:	75 c8                	jne    c010800e <insert_vma_struct+0x4e>
c0108046:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108049:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010804c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010804f:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0108052:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0108055:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108058:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010805b:	74 15                	je     c0108072 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c010805d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108060:	8d 50 f0             	lea    -0x10(%eax),%edx
c0108063:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108066:	89 44 24 04          	mov    %eax,0x4(%esp)
c010806a:	89 14 24             	mov    %edx,(%esp)
c010806d:	e8 aa fe ff ff       	call   c0107f1c <check_vma_overlap>
    }
    if (le_next != list) {
c0108072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108075:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108078:	74 15                	je     c010808f <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c010807a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010807d:	83 e8 10             	sub    $0x10,%eax
c0108080:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108084:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108087:	89 04 24             	mov    %eax,(%esp)
c010808a:	e8 8d fe ff ff       	call   c0107f1c <check_vma_overlap>
    }

    vma->vm_mm = mm;
c010808f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108092:	8b 55 08             	mov    0x8(%ebp),%edx
c0108095:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0108097:	8b 45 0c             	mov    0xc(%ebp),%eax
c010809a:	8d 50 10             	lea    0x10(%eax),%edx
c010809d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01080a3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01080a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01080a9:	8b 40 04             	mov    0x4(%eax),%eax
c01080ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01080af:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01080b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01080b5:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01080b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01080bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01080be:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01080c1:	89 10                	mov    %edx,(%eax)
c01080c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01080c6:	8b 10                	mov    (%eax),%edx
c01080c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01080cb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01080ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01080d1:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01080d4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01080d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01080da:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01080dd:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c01080df:	8b 45 08             	mov    0x8(%ebp),%eax
c01080e2:	8b 40 10             	mov    0x10(%eax),%eax
c01080e5:	8d 50 01             	lea    0x1(%eax),%edx
c01080e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01080eb:	89 50 10             	mov    %edx,0x10(%eax)
}
c01080ee:	c9                   	leave  
c01080ef:	c3                   	ret    

c01080f0 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c01080f0:	55                   	push   %ebp
c01080f1:	89 e5                	mov    %esp,%ebp
c01080f3:	83 ec 38             	sub    $0x38,%esp
    assert(mm_count(mm) == 0);
c01080f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01080f9:	89 04 24             	mov    %eax,(%esp)
c01080fc:	e8 38 fc ff ff       	call   c0107d39 <mm_count>
c0108101:	85 c0                	test   %eax,%eax
c0108103:	74 24                	je     c0108129 <mm_destroy+0x39>
c0108105:	c7 44 24 0c 95 d7 10 	movl   $0xc010d795,0xc(%esp)
c010810c:	c0 
c010810d:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0108114:	c0 
c0108115:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c010811c:	00 
c010811d:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108124:	e8 ac 8c ff ff       	call   c0100dd5 <__panic>

    list_entry_t *list = &(mm->mmap_list), *le;
c0108129:	8b 45 08             	mov    0x8(%ebp),%eax
c010812c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c010812f:	eb 36                	jmp    c0108167 <mm_destroy+0x77>
c0108131:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108134:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0108137:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010813a:	8b 40 04             	mov    0x4(%eax),%eax
c010813d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108140:	8b 12                	mov    (%edx),%edx
c0108142:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108145:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0108148:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010814b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010814e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0108151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108154:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108157:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0108159:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010815c:	83 e8 10             	sub    $0x10,%eax
c010815f:	89 04 24             	mov    %eax,(%esp)
c0108162:	e8 79 ca ff ff       	call   c0104be0 <kfree>
c0108167:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010816a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010816d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108170:	8b 40 04             	mov    0x4(%eax),%eax
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0108173:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108176:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108179:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010817c:	75 b3                	jne    c0108131 <mm_destroy+0x41>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c010817e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108181:	89 04 24             	mov    %eax,(%esp)
c0108184:	e8 57 ca ff ff       	call   c0104be0 <kfree>
    mm=NULL;
c0108189:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0108190:	c9                   	leave  
c0108191:	c3                   	ret    

c0108192 <mm_map>:

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
c0108192:	55                   	push   %ebp
c0108193:	89 e5                	mov    %esp,%ebp
c0108195:	83 ec 38             	sub    $0x38,%esp
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
c0108198:	8b 45 0c             	mov    0xc(%ebp),%eax
c010819b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010819e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01081a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01081a9:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
c01081b0:	8b 45 10             	mov    0x10(%ebp),%eax
c01081b3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01081b6:	01 c2                	add    %eax,%edx
c01081b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081bb:	01 d0                	add    %edx,%eax
c01081bd:	83 e8 01             	sub    $0x1,%eax
c01081c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01081c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081c6:	ba 00 00 00 00       	mov    $0x0,%edx
c01081cb:	f7 75 e8             	divl   -0x18(%ebp)
c01081ce:	89 d0                	mov    %edx,%eax
c01081d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01081d3:	29 c2                	sub    %eax,%edx
c01081d5:	89 d0                	mov    %edx,%eax
c01081d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!USER_ACCESS(start, end)) {
c01081da:	81 7d ec ff ff 1f 00 	cmpl   $0x1fffff,-0x14(%ebp)
c01081e1:	76 11                	jbe    c01081f4 <mm_map+0x62>
c01081e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081e6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01081e9:	73 09                	jae    c01081f4 <mm_map+0x62>
c01081eb:	81 7d e0 00 00 00 b0 	cmpl   $0xb0000000,-0x20(%ebp)
c01081f2:	76 0a                	jbe    c01081fe <mm_map+0x6c>
        return -E_INVAL;
c01081f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01081f9:	e9 ae 00 00 00       	jmp    c01082ac <mm_map+0x11a>
    }

    assert(mm != NULL);
c01081fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108202:	75 24                	jne    c0108228 <mm_map+0x96>
c0108204:	c7 44 24 0c a7 d7 10 	movl   $0xc010d7a7,0xc(%esp)
c010820b:	c0 
c010820c:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0108213:	c0 
c0108214:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c010821b:	00 
c010821c:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108223:	e8 ad 8b ff ff       	call   c0100dd5 <__panic>

    int ret = -E_INVAL;
c0108228:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
c010822f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108232:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108236:	8b 45 08             	mov    0x8(%ebp),%eax
c0108239:	89 04 24             	mov    %eax,(%esp)
c010823c:	e8 2a fc ff ff       	call   c0107e6b <find_vma>
c0108241:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108244:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108248:	74 0d                	je     c0108257 <mm_map+0xc5>
c010824a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010824d:	8b 40 04             	mov    0x4(%eax),%eax
c0108250:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108253:	73 02                	jae    c0108257 <mm_map+0xc5>
        goto out;
c0108255:	eb 52                	jmp    c01082a9 <mm_map+0x117>
    }
    ret = -E_NO_MEM;
c0108257:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
c010825e:	8b 45 14             	mov    0x14(%ebp),%eax
c0108261:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108265:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108268:	89 44 24 04          	mov    %eax,0x4(%esp)
c010826c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010826f:	89 04 24             	mov    %eax,(%esp)
c0108272:	e8 b9 fb ff ff       	call   c0107e30 <vma_create>
c0108277:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010827a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010827e:	75 02                	jne    c0108282 <mm_map+0xf0>
        goto out;
c0108280:	eb 27                	jmp    c01082a9 <mm_map+0x117>
    }
    insert_vma_struct(mm, vma);
c0108282:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108285:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108289:	8b 45 08             	mov    0x8(%ebp),%eax
c010828c:	89 04 24             	mov    %eax,(%esp)
c010828f:	e8 2c fd ff ff       	call   c0107fc0 <insert_vma_struct>
    if (vma_store != NULL) {
c0108294:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0108298:	74 08                	je     c01082a2 <mm_map+0x110>
        *vma_store = vma;
c010829a:	8b 45 18             	mov    0x18(%ebp),%eax
c010829d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01082a0:	89 10                	mov    %edx,(%eax)
    }
    ret = 0;
c01082a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

out:
    return ret;
c01082a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01082ac:	c9                   	leave  
c01082ad:	c3                   	ret    

c01082ae <dup_mmap>:

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
c01082ae:	55                   	push   %ebp
c01082af:	89 e5                	mov    %esp,%ebp
c01082b1:	56                   	push   %esi
c01082b2:	53                   	push   %ebx
c01082b3:	83 ec 40             	sub    $0x40,%esp
    assert(to != NULL && from != NULL);
c01082b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01082ba:	74 06                	je     c01082c2 <dup_mmap+0x14>
c01082bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01082c0:	75 24                	jne    c01082e6 <dup_mmap+0x38>
c01082c2:	c7 44 24 0c b2 d7 10 	movl   $0xc010d7b2,0xc(%esp)
c01082c9:	c0 
c01082ca:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c01082d1:	c0 
c01082d2:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01082d9:	00 
c01082da:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c01082e1:	e8 ef 8a ff ff       	call   c0100dd5 <__panic>
    list_entry_t *list = &(from->mmap_list), *le = list;
c01082e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01082ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_prev(le)) != list) {
c01082f2:	e9 92 00 00 00       	jmp    c0108389 <dup_mmap+0xdb>
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
c01082f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082fa:	83 e8 10             	sub    $0x10,%eax
c01082fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
c0108300:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108303:	8b 48 0c             	mov    0xc(%eax),%ecx
c0108306:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108309:	8b 50 08             	mov    0x8(%eax),%edx
c010830c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010830f:	8b 40 04             	mov    0x4(%eax),%eax
c0108312:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108316:	89 54 24 04          	mov    %edx,0x4(%esp)
c010831a:	89 04 24             	mov    %eax,(%esp)
c010831d:	e8 0e fb ff ff       	call   c0107e30 <vma_create>
c0108322:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (nvma == NULL) {
c0108325:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108329:	75 07                	jne    c0108332 <dup_mmap+0x84>
            return -E_NO_MEM;
c010832b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0108330:	eb 76                	jmp    c01083a8 <dup_mmap+0xfa>
        }

        insert_vma_struct(to, nvma);
c0108332:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108335:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108339:	8b 45 08             	mov    0x8(%ebp),%eax
c010833c:	89 04 24             	mov    %eax,(%esp)
c010833f:	e8 7c fc ff ff       	call   c0107fc0 <insert_vma_struct>

        bool share = 0;
c0108344:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
c010834b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010834e:	8b 58 08             	mov    0x8(%eax),%ebx
c0108351:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108354:	8b 48 04             	mov    0x4(%eax),%ecx
c0108357:	8b 45 0c             	mov    0xc(%ebp),%eax
c010835a:	8b 50 0c             	mov    0xc(%eax),%edx
c010835d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108360:	8b 40 0c             	mov    0xc(%eax),%eax
c0108363:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c0108366:	89 74 24 10          	mov    %esi,0x10(%esp)
c010836a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010836e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108372:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108376:	89 04 24             	mov    %eax,(%esp)
c0108379:	e8 17 d8 ff ff       	call   c0105b95 <copy_range>
c010837e:	85 c0                	test   %eax,%eax
c0108380:	74 07                	je     c0108389 <dup_mmap+0xdb>
            return -E_NO_MEM;
c0108382:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0108387:	eb 1f                	jmp    c01083a8 <dup_mmap+0xfa>
c0108389:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010838c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010838f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108392:	8b 00                	mov    (%eax),%eax

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
    assert(to != NULL && from != NULL);
    list_entry_t *list = &(from->mmap_list), *le = list;
    while ((le = list_prev(le)) != list) {
c0108394:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108397:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010839a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010839d:	0f 85 54 ff ff ff    	jne    c01082f7 <dup_mmap+0x49>
        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
            return -E_NO_MEM;
        }
    }
    return 0;
c01083a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01083a8:	83 c4 40             	add    $0x40,%esp
c01083ab:	5b                   	pop    %ebx
c01083ac:	5e                   	pop    %esi
c01083ad:	5d                   	pop    %ebp
c01083ae:	c3                   	ret    

c01083af <exit_mmap>:

void
exit_mmap(struct mm_struct *mm) {
c01083af:	55                   	push   %ebp
c01083b0:	89 e5                	mov    %esp,%ebp
c01083b2:	83 ec 38             	sub    $0x38,%esp
    assert(mm != NULL && mm_count(mm) == 0);
c01083b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01083b9:	74 0f                	je     c01083ca <exit_mmap+0x1b>
c01083bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01083be:	89 04 24             	mov    %eax,(%esp)
c01083c1:	e8 73 f9 ff ff       	call   c0107d39 <mm_count>
c01083c6:	85 c0                	test   %eax,%eax
c01083c8:	74 24                	je     c01083ee <exit_mmap+0x3f>
c01083ca:	c7 44 24 0c d0 d7 10 	movl   $0xc010d7d0,0xc(%esp)
c01083d1:	c0 
c01083d2:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c01083d9:	c0 
c01083da:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01083e1:	00 
c01083e2:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c01083e9:	e8 e7 89 ff ff       	call   c0100dd5 <__panic>
    pde_t *pgdir = mm->pgdir;
c01083ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01083f1:	8b 40 0c             	mov    0xc(%eax),%eax
c01083f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *list = &(mm->mmap_list), *le = list;
c01083f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01083fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01083fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108400:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != list) {
c0108403:	eb 28                	jmp    c010842d <exit_mmap+0x7e>
        struct vma_struct *vma = le2vma(le, list_link);
c0108405:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108408:	83 e8 10             	sub    $0x10,%eax
c010840b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
c010840e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108411:	8b 50 08             	mov    0x8(%eax),%edx
c0108414:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108417:	8b 40 04             	mov    0x4(%eax),%eax
c010841a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010841e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108422:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108425:	89 04 24             	mov    %eax,(%esp)
c0108428:	e8 6d d5 ff ff       	call   c010599a <unmap_range>
c010842d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108430:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108433:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108436:	8b 40 04             	mov    0x4(%eax),%eax
void
exit_mmap(struct mm_struct *mm) {
    assert(mm != NULL && mm_count(mm) == 0);
    pde_t *pgdir = mm->pgdir;
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
c0108439:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010843c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010843f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108442:	75 c1                	jne    c0108405 <exit_mmap+0x56>
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c0108444:	eb 28                	jmp    c010846e <exit_mmap+0xbf>
        struct vma_struct *vma = le2vma(le, list_link);
c0108446:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108449:	83 e8 10             	sub    $0x10,%eax
c010844c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        exit_range(pgdir, vma->vm_start, vma->vm_end);
c010844f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108452:	8b 50 08             	mov    0x8(%eax),%edx
c0108455:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108458:	8b 40 04             	mov    0x4(%eax),%eax
c010845b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010845f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108463:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108466:	89 04 24             	mov    %eax,(%esp)
c0108469:	e8 20 d6 ff ff       	call   c0105a8e <exit_range>
c010846e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108471:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108474:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108477:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c010847a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010847d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108480:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108483:	75 c1                	jne    c0108446 <exit_mmap+0x97>
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
    }
}
c0108485:	c9                   	leave  
c0108486:	c3                   	ret    

c0108487 <copy_from_user>:

bool
copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable) {
c0108487:	55                   	push   %ebp
c0108488:	89 e5                	mov    %esp,%ebp
c010848a:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)src, len, writable)) {
c010848d:	8b 45 10             	mov    0x10(%ebp),%eax
c0108490:	8b 55 18             	mov    0x18(%ebp),%edx
c0108493:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108497:	8b 55 14             	mov    0x14(%ebp),%edx
c010849a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010849e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01084a5:	89 04 24             	mov    %eax,(%esp)
c01084a8:	e8 99 09 00 00       	call   c0108e46 <user_mem_check>
c01084ad:	85 c0                	test   %eax,%eax
c01084af:	75 07                	jne    c01084b8 <copy_from_user+0x31>
        return 0;
c01084b1:	b8 00 00 00 00       	mov    $0x0,%eax
c01084b6:	eb 1e                	jmp    c01084d6 <copy_from_user+0x4f>
    }
    memcpy(dst, src, len);
c01084b8:	8b 45 14             	mov    0x14(%ebp),%eax
c01084bb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01084bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01084c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084c9:	89 04 24             	mov    %eax,(%esp)
c01084cc:	e8 3d 37 00 00       	call   c010bc0e <memcpy>
    return 1;
c01084d1:	b8 01 00 00 00       	mov    $0x1,%eax
}
c01084d6:	c9                   	leave  
c01084d7:	c3                   	ret    

c01084d8 <copy_to_user>:

bool
copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len) {
c01084d8:	55                   	push   %ebp
c01084d9:	89 e5                	mov    %esp,%ebp
c01084db:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)dst, len, 1)) {
c01084de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084e1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c01084e8:	00 
c01084e9:	8b 55 14             	mov    0x14(%ebp),%edx
c01084ec:	89 54 24 08          	mov    %edx,0x8(%esp)
c01084f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01084f7:	89 04 24             	mov    %eax,(%esp)
c01084fa:	e8 47 09 00 00       	call   c0108e46 <user_mem_check>
c01084ff:	85 c0                	test   %eax,%eax
c0108501:	75 07                	jne    c010850a <copy_to_user+0x32>
        return 0;
c0108503:	b8 00 00 00 00       	mov    $0x0,%eax
c0108508:	eb 1e                	jmp    c0108528 <copy_to_user+0x50>
    }
    memcpy(dst, src, len);
c010850a:	8b 45 14             	mov    0x14(%ebp),%eax
c010850d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108511:	8b 45 10             	mov    0x10(%ebp),%eax
c0108514:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108518:	8b 45 0c             	mov    0xc(%ebp),%eax
c010851b:	89 04 24             	mov    %eax,(%esp)
c010851e:	e8 eb 36 00 00       	call   c010bc0e <memcpy>
    return 1;
c0108523:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0108528:	c9                   	leave  
c0108529:	c3                   	ret    

c010852a <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c010852a:	55                   	push   %ebp
c010852b:	89 e5                	mov    %esp,%ebp
c010852d:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0108530:	e8 02 00 00 00       	call   c0108537 <check_vmm>
}
c0108535:	c9                   	leave  
c0108536:	c3                   	ret    

c0108537 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0108537:	55                   	push   %ebp
c0108538:	89 e5                	mov    %esp,%ebp
c010853a:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010853d:	e8 95 cb ff ff       	call   c01050d7 <nr_free_pages>
c0108542:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0108545:	e8 13 00 00 00       	call   c010855d <check_vma_struct>
    check_pgfault();
c010854a:	e8 a7 04 00 00       	call   c01089f6 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c010854f:	c7 04 24 f0 d7 10 c0 	movl   $0xc010d7f0,(%esp)
c0108556:	e8 f8 7d ff ff       	call   c0100353 <cprintf>
}
c010855b:	c9                   	leave  
c010855c:	c3                   	ret    

c010855d <check_vma_struct>:

static void
check_vma_struct(void) {
c010855d:	55                   	push   %ebp
c010855e:	89 e5                	mov    %esp,%ebp
c0108560:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108563:	e8 6f cb ff ff       	call   c01050d7 <nr_free_pages>
c0108568:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c010856b:	e8 27 f8 ff ff       	call   c0107d97 <mm_create>
c0108570:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0108573:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108577:	75 24                	jne    c010859d <check_vma_struct+0x40>
c0108579:	c7 44 24 0c a7 d7 10 	movl   $0xc010d7a7,0xc(%esp)
c0108580:	c0 
c0108581:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0108588:	c0 
c0108589:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0108590:	00 
c0108591:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108598:	e8 38 88 ff ff       	call   c0100dd5 <__panic>

    int step1 = 10, step2 = step1 * 10;
c010859d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c01085a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01085a7:	89 d0                	mov    %edx,%eax
c01085a9:	c1 e0 02             	shl    $0x2,%eax
c01085ac:	01 d0                	add    %edx,%eax
c01085ae:	01 c0                	add    %eax,%eax
c01085b0:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c01085b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01085b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085b9:	eb 70                	jmp    c010862b <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01085bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01085be:	89 d0                	mov    %edx,%eax
c01085c0:	c1 e0 02             	shl    $0x2,%eax
c01085c3:	01 d0                	add    %edx,%eax
c01085c5:	83 c0 02             	add    $0x2,%eax
c01085c8:	89 c1                	mov    %eax,%ecx
c01085ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01085cd:	89 d0                	mov    %edx,%eax
c01085cf:	c1 e0 02             	shl    $0x2,%eax
c01085d2:	01 d0                	add    %edx,%eax
c01085d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01085db:	00 
c01085dc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01085e0:	89 04 24             	mov    %eax,(%esp)
c01085e3:	e8 48 f8 ff ff       	call   c0107e30 <vma_create>
c01085e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c01085eb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01085ef:	75 24                	jne    c0108615 <check_vma_struct+0xb8>
c01085f1:	c7 44 24 0c 08 d8 10 	movl   $0xc010d808,0xc(%esp)
c01085f8:	c0 
c01085f9:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0108600:	c0 
c0108601:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0108608:	00 
c0108609:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108610:	e8 c0 87 ff ff       	call   c0100dd5 <__panic>
        insert_vma_struct(mm, vma);
c0108615:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108618:	89 44 24 04          	mov    %eax,0x4(%esp)
c010861c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010861f:	89 04 24             	mov    %eax,(%esp)
c0108622:	e8 99 f9 ff ff       	call   c0107fc0 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0108627:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010862b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010862f:	7f 8a                	jg     c01085bb <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0108631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108634:	83 c0 01             	add    $0x1,%eax
c0108637:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010863a:	eb 70                	jmp    c01086ac <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c010863c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010863f:	89 d0                	mov    %edx,%eax
c0108641:	c1 e0 02             	shl    $0x2,%eax
c0108644:	01 d0                	add    %edx,%eax
c0108646:	83 c0 02             	add    $0x2,%eax
c0108649:	89 c1                	mov    %eax,%ecx
c010864b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010864e:	89 d0                	mov    %edx,%eax
c0108650:	c1 e0 02             	shl    $0x2,%eax
c0108653:	01 d0                	add    %edx,%eax
c0108655:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010865c:	00 
c010865d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0108661:	89 04 24             	mov    %eax,(%esp)
c0108664:	e8 c7 f7 ff ff       	call   c0107e30 <vma_create>
c0108669:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c010866c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0108670:	75 24                	jne    c0108696 <check_vma_struct+0x139>
c0108672:	c7 44 24 0c 08 d8 10 	movl   $0xc010d808,0xc(%esp)
c0108679:	c0 
c010867a:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0108681:	c0 
c0108682:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0108689:	00 
c010868a:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108691:	e8 3f 87 ff ff       	call   c0100dd5 <__panic>
        insert_vma_struct(mm, vma);
c0108696:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108699:	89 44 24 04          	mov    %eax,0x4(%esp)
c010869d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086a0:	89 04 24             	mov    %eax,(%esp)
c01086a3:	e8 18 f9 ff ff       	call   c0107fc0 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01086a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01086ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086af:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01086b2:	7e 88                	jle    c010863c <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c01086b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086b7:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01086ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01086bd:	8b 40 04             	mov    0x4(%eax),%eax
c01086c0:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c01086c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c01086ca:	e9 97 00 00 00       	jmp    c0108766 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c01086cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01086d5:	75 24                	jne    c01086fb <check_vma_struct+0x19e>
c01086d7:	c7 44 24 0c 14 d8 10 	movl   $0xc010d814,0xc(%esp)
c01086de:	c0 
c01086df:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c01086e6:	c0 
c01086e7:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c01086ee:	00 
c01086ef:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c01086f6:	e8 da 86 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c01086fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086fe:	83 e8 10             	sub    $0x10,%eax
c0108701:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0108704:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108707:	8b 48 04             	mov    0x4(%eax),%ecx
c010870a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010870d:	89 d0                	mov    %edx,%eax
c010870f:	c1 e0 02             	shl    $0x2,%eax
c0108712:	01 d0                	add    %edx,%eax
c0108714:	39 c1                	cmp    %eax,%ecx
c0108716:	75 17                	jne    c010872f <check_vma_struct+0x1d2>
c0108718:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010871b:	8b 48 08             	mov    0x8(%eax),%ecx
c010871e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108721:	89 d0                	mov    %edx,%eax
c0108723:	c1 e0 02             	shl    $0x2,%eax
c0108726:	01 d0                	add    %edx,%eax
c0108728:	83 c0 02             	add    $0x2,%eax
c010872b:	39 c1                	cmp    %eax,%ecx
c010872d:	74 24                	je     c0108753 <check_vma_struct+0x1f6>
c010872f:	c7 44 24 0c 2c d8 10 	movl   $0xc010d82c,0xc(%esp)
c0108736:	c0 
c0108737:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c010873e:	c0 
c010873f:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c0108746:	00 
c0108747:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c010874e:	e8 82 86 ff ff       	call   c0100dd5 <__panic>
c0108753:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108756:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0108759:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010875c:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010875f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0108762:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108766:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108769:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010876c:	0f 8e 5d ff ff ff    	jle    c01086cf <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0108772:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0108779:	e9 cd 01 00 00       	jmp    c010894b <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c010877e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108781:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108785:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108788:	89 04 24             	mov    %eax,(%esp)
c010878b:	e8 db f6 ff ff       	call   c0107e6b <find_vma>
c0108790:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0108793:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0108797:	75 24                	jne    c01087bd <check_vma_struct+0x260>
c0108799:	c7 44 24 0c 61 d8 10 	movl   $0xc010d861,0xc(%esp)
c01087a0:	c0 
c01087a1:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c01087a8:	c0 
c01087a9:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c01087b0:	00 
c01087b1:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c01087b8:	e8 18 86 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c01087bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087c0:	83 c0 01             	add    $0x1,%eax
c01087c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01087c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01087ca:	89 04 24             	mov    %eax,(%esp)
c01087cd:	e8 99 f6 ff ff       	call   c0107e6b <find_vma>
c01087d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c01087d5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01087d9:	75 24                	jne    c01087ff <check_vma_struct+0x2a2>
c01087db:	c7 44 24 0c 6e d8 10 	movl   $0xc010d86e,0xc(%esp)
c01087e2:	c0 
c01087e3:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c01087ea:	c0 
c01087eb:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c01087f2:	00 
c01087f3:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c01087fa:	e8 d6 85 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c01087ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108802:	83 c0 02             	add    $0x2,%eax
c0108805:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108809:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010880c:	89 04 24             	mov    %eax,(%esp)
c010880f:	e8 57 f6 ff ff       	call   c0107e6b <find_vma>
c0108814:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0108817:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010881b:	74 24                	je     c0108841 <check_vma_struct+0x2e4>
c010881d:	c7 44 24 0c 7b d8 10 	movl   $0xc010d87b,0xc(%esp)
c0108824:	c0 
c0108825:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c010882c:	c0 
c010882d:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0108834:	00 
c0108835:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c010883c:	e8 94 85 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0108841:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108844:	83 c0 03             	add    $0x3,%eax
c0108847:	89 44 24 04          	mov    %eax,0x4(%esp)
c010884b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010884e:	89 04 24             	mov    %eax,(%esp)
c0108851:	e8 15 f6 ff ff       	call   c0107e6b <find_vma>
c0108856:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0108859:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c010885d:	74 24                	je     c0108883 <check_vma_struct+0x326>
c010885f:	c7 44 24 0c 88 d8 10 	movl   $0xc010d888,0xc(%esp)
c0108866:	c0 
c0108867:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c010886e:	c0 
c010886f:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0108876:	00 
c0108877:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c010887e:	e8 52 85 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0108883:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108886:	83 c0 04             	add    $0x4,%eax
c0108889:	89 44 24 04          	mov    %eax,0x4(%esp)
c010888d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108890:	89 04 24             	mov    %eax,(%esp)
c0108893:	e8 d3 f5 ff ff       	call   c0107e6b <find_vma>
c0108898:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c010889b:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c010889f:	74 24                	je     c01088c5 <check_vma_struct+0x368>
c01088a1:	c7 44 24 0c 95 d8 10 	movl   $0xc010d895,0xc(%esp)
c01088a8:	c0 
c01088a9:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c01088b0:	c0 
c01088b1:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01088b8:	00 
c01088b9:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c01088c0:	e8 10 85 ff ff       	call   c0100dd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c01088c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01088c8:	8b 50 04             	mov    0x4(%eax),%edx
c01088cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088ce:	39 c2                	cmp    %eax,%edx
c01088d0:	75 10                	jne    c01088e2 <check_vma_struct+0x385>
c01088d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01088d5:	8b 50 08             	mov    0x8(%eax),%edx
c01088d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088db:	83 c0 02             	add    $0x2,%eax
c01088de:	39 c2                	cmp    %eax,%edx
c01088e0:	74 24                	je     c0108906 <check_vma_struct+0x3a9>
c01088e2:	c7 44 24 0c a4 d8 10 	movl   $0xc010d8a4,0xc(%esp)
c01088e9:	c0 
c01088ea:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c01088f1:	c0 
c01088f2:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c01088f9:	00 
c01088fa:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108901:	e8 cf 84 ff ff       	call   c0100dd5 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0108906:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108909:	8b 50 04             	mov    0x4(%eax),%edx
c010890c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010890f:	39 c2                	cmp    %eax,%edx
c0108911:	75 10                	jne    c0108923 <check_vma_struct+0x3c6>
c0108913:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108916:	8b 50 08             	mov    0x8(%eax),%edx
c0108919:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010891c:	83 c0 02             	add    $0x2,%eax
c010891f:	39 c2                	cmp    %eax,%edx
c0108921:	74 24                	je     c0108947 <check_vma_struct+0x3ea>
c0108923:	c7 44 24 0c d4 d8 10 	movl   $0xc010d8d4,0xc(%esp)
c010892a:	c0 
c010892b:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0108932:	c0 
c0108933:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c010893a:	00 
c010893b:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108942:	e8 8e 84 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0108947:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c010894b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010894e:	89 d0                	mov    %edx,%eax
c0108950:	c1 e0 02             	shl    $0x2,%eax
c0108953:	01 d0                	add    %edx,%eax
c0108955:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0108958:	0f 8d 20 fe ff ff    	jge    c010877e <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c010895e:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0108965:	eb 70                	jmp    c01089d7 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0108967:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010896a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010896e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108971:	89 04 24             	mov    %eax,(%esp)
c0108974:	e8 f2 f4 ff ff       	call   c0107e6b <find_vma>
c0108979:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c010897c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0108980:	74 27                	je     c01089a9 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0108982:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0108985:	8b 50 08             	mov    0x8(%eax),%edx
c0108988:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010898b:	8b 40 04             	mov    0x4(%eax),%eax
c010898e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108992:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108996:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108999:	89 44 24 04          	mov    %eax,0x4(%esp)
c010899d:	c7 04 24 04 d9 10 c0 	movl   $0xc010d904,(%esp)
c01089a4:	e8 aa 79 ff ff       	call   c0100353 <cprintf>
        }
        assert(vma_below_5 == NULL);
c01089a9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01089ad:	74 24                	je     c01089d3 <check_vma_struct+0x476>
c01089af:	c7 44 24 0c 29 d9 10 	movl   $0xc010d929,0xc(%esp)
c01089b6:	c0 
c01089b7:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c01089be:	c0 
c01089bf:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c01089c6:	00 
c01089c7:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c01089ce:	e8 02 84 ff ff       	call   c0100dd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01089d3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01089d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01089db:	79 8a                	jns    c0108967 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c01089dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089e0:	89 04 24             	mov    %eax,(%esp)
c01089e3:	e8 08 f7 ff ff       	call   c01080f0 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c01089e8:	c7 04 24 40 d9 10 c0 	movl   $0xc010d940,(%esp)
c01089ef:	e8 5f 79 ff ff       	call   c0100353 <cprintf>
}
c01089f4:	c9                   	leave  
c01089f5:	c3                   	ret    

c01089f6 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c01089f6:	55                   	push   %ebp
c01089f7:	89 e5                	mov    %esp,%ebp
c01089f9:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01089fc:	e8 d6 c6 ff ff       	call   c01050d7 <nr_free_pages>
c0108a01:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0108a04:	e8 8e f3 ff ff       	call   c0107d97 <mm_create>
c0108a09:	a3 ac f0 19 c0       	mov    %eax,0xc019f0ac
    assert(check_mm_struct != NULL);
c0108a0e:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0108a13:	85 c0                	test   %eax,%eax
c0108a15:	75 24                	jne    c0108a3b <check_pgfault+0x45>
c0108a17:	c7 44 24 0c 5f d9 10 	movl   $0xc010d95f,0xc(%esp)
c0108a1e:	c0 
c0108a1f:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0108a26:	c0 
c0108a27:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c0108a2e:	00 
c0108a2f:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108a36:	e8 9a 83 ff ff       	call   c0100dd5 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0108a3b:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0108a40:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0108a43:	8b 15 e4 ce 19 c0    	mov    0xc019cee4,%edx
c0108a49:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a4c:	89 50 0c             	mov    %edx,0xc(%eax)
c0108a4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a52:	8b 40 0c             	mov    0xc(%eax),%eax
c0108a55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0108a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a5b:	8b 00                	mov    (%eax),%eax
c0108a5d:	85 c0                	test   %eax,%eax
c0108a5f:	74 24                	je     c0108a85 <check_pgfault+0x8f>
c0108a61:	c7 44 24 0c 77 d9 10 	movl   $0xc010d977,0xc(%esp)
c0108a68:	c0 
c0108a69:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0108a70:	c0 
c0108a71:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
c0108a78:	00 
c0108a79:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108a80:	e8 50 83 ff ff       	call   c0100dd5 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0108a85:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0108a8c:	00 
c0108a8d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0108a94:	00 
c0108a95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0108a9c:	e8 8f f3 ff ff       	call   c0107e30 <vma_create>
c0108aa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0108aa4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0108aa8:	75 24                	jne    c0108ace <check_pgfault+0xd8>
c0108aaa:	c7 44 24 0c 08 d8 10 	movl   $0xc010d808,0xc(%esp)
c0108ab1:	c0 
c0108ab2:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0108ab9:	c0 
c0108aba:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0108ac1:	00 
c0108ac2:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108ac9:	e8 07 83 ff ff       	call   c0100dd5 <__panic>

    insert_vma_struct(mm, vma);
c0108ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ad5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108ad8:	89 04 24             	mov    %eax,(%esp)
c0108adb:	e8 e0 f4 ff ff       	call   c0107fc0 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0108ae0:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0108ae7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108aea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108af1:	89 04 24             	mov    %eax,(%esp)
c0108af4:	e8 72 f3 ff ff       	call   c0107e6b <find_vma>
c0108af9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108afc:	74 24                	je     c0108b22 <check_pgfault+0x12c>
c0108afe:	c7 44 24 0c 85 d9 10 	movl   $0xc010d985,0xc(%esp)
c0108b05:	c0 
c0108b06:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0108b0d:	c0 
c0108b0e:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c0108b15:	00 
c0108b16:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108b1d:	e8 b3 82 ff ff       	call   c0100dd5 <__panic>

    int i, sum = 0;
c0108b22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0108b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108b30:	eb 17                	jmp    c0108b49 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0108b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108b35:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b38:	01 d0                	add    %edx,%eax
c0108b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108b3d:	88 10                	mov    %dl,(%eax)
        sum += i;
c0108b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b42:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0108b45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108b49:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108b4d:	7e e3                	jle    c0108b32 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108b4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108b56:	eb 15                	jmp    c0108b6d <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0108b58:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108b5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b5e:	01 d0                	add    %edx,%eax
c0108b60:	0f b6 00             	movzbl (%eax),%eax
c0108b63:	0f be c0             	movsbl %al,%eax
c0108b66:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108b69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108b6d:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108b71:	7e e5                	jle    c0108b58 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0108b73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108b77:	74 24                	je     c0108b9d <check_pgfault+0x1a7>
c0108b79:	c7 44 24 0c 9f d9 10 	movl   $0xc010d99f,0xc(%esp)
c0108b80:	c0 
c0108b81:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0108b88:	c0 
c0108b89:	c7 44 24 04 61 01 00 	movl   $0x161,0x4(%esp)
c0108b90:	00 
c0108b91:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108b98:	e8 38 82 ff ff       	call   c0100dd5 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0108b9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108ba0:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108ba3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108ba6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108bab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108baf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108bb2:	89 04 24             	mov    %eax,(%esp)
c0108bb5:	e8 fe d1 ff ff       	call   c0105db8 <page_remove>
    free_page(pa2page(pgdir[0]));
c0108bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108bbd:	8b 00                	mov    (%eax),%eax
c0108bbf:	89 04 24             	mov    %eax,(%esp)
c0108bc2:	e8 8b f1 ff ff       	call   c0107d52 <pa2page>
c0108bc7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108bce:	00 
c0108bcf:	89 04 24             	mov    %eax,(%esp)
c0108bd2:	e8 ce c4 ff ff       	call   c01050a5 <free_pages>
    pgdir[0] = 0;
c0108bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108bda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0108be0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108be3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0108bea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bed:	89 04 24             	mov    %eax,(%esp)
c0108bf0:	e8 fb f4 ff ff       	call   c01080f0 <mm_destroy>
    check_mm_struct = NULL;
c0108bf5:	c7 05 ac f0 19 c0 00 	movl   $0x0,0xc019f0ac
c0108bfc:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0108bff:	e8 d3 c4 ff ff       	call   c01050d7 <nr_free_pages>
c0108c04:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108c07:	74 24                	je     c0108c2d <check_pgfault+0x237>
c0108c09:	c7 44 24 0c a8 d9 10 	movl   $0xc010d9a8,0xc(%esp)
c0108c10:	c0 
c0108c11:	c7 44 24 08 17 d7 10 	movl   $0xc010d717,0x8(%esp)
c0108c18:	c0 
c0108c19:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
c0108c20:	00 
c0108c21:	c7 04 24 2c d7 10 c0 	movl   $0xc010d72c,(%esp)
c0108c28:	e8 a8 81 ff ff       	call   c0100dd5 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0108c2d:	c7 04 24 cf d9 10 c0 	movl   $0xc010d9cf,(%esp)
c0108c34:	e8 1a 77 ff ff       	call   c0100353 <cprintf>
}
c0108c39:	c9                   	leave  
c0108c3a:	c3                   	ret    

c0108c3b <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0108c3b:	55                   	push   %ebp
c0108c3c:	89 e5                	mov    %esp,%ebp
c0108c3e:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0108c41:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0108c48:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c52:	89 04 24             	mov    %eax,(%esp)
c0108c55:	e8 11 f2 ff ff       	call   c0107e6b <find_vma>
c0108c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0108c5d:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0108c62:	83 c0 01             	add    $0x1,%eax
c0108c65:	a3 78 cf 19 c0       	mov    %eax,0xc019cf78
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0108c6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108c6e:	74 0b                	je     c0108c7b <do_pgfault+0x40>
c0108c70:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c73:	8b 40 04             	mov    0x4(%eax),%eax
c0108c76:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108c79:	76 18                	jbe    c0108c93 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0108c7b:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c82:	c7 04 24 ec d9 10 c0 	movl   $0xc010d9ec,(%esp)
c0108c89:	e8 c5 76 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108c8e:	e9 ae 01 00 00       	jmp    c0108e41 <do_pgfault+0x206>
    }
    //check the error_code
    switch (error_code & 3) {
c0108c93:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c96:	83 e0 03             	and    $0x3,%eax
c0108c99:	85 c0                	test   %eax,%eax
c0108c9b:	74 36                	je     c0108cd3 <do_pgfault+0x98>
c0108c9d:	83 f8 01             	cmp    $0x1,%eax
c0108ca0:	74 20                	je     c0108cc2 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0108ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ca5:	8b 40 0c             	mov    0xc(%eax),%eax
c0108ca8:	83 e0 02             	and    $0x2,%eax
c0108cab:	85 c0                	test   %eax,%eax
c0108cad:	75 11                	jne    c0108cc0 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0108caf:	c7 04 24 1c da 10 c0 	movl   $0xc010da1c,(%esp)
c0108cb6:	e8 98 76 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108cbb:	e9 81 01 00 00       	jmp    c0108e41 <do_pgfault+0x206>
        }
        break;
c0108cc0:	eb 2f                	jmp    c0108cf1 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108cc2:	c7 04 24 7c da 10 c0 	movl   $0xc010da7c,(%esp)
c0108cc9:	e8 85 76 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108cce:	e9 6e 01 00 00       	jmp    c0108e41 <do_pgfault+0x206>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0108cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108cd6:	8b 40 0c             	mov    0xc(%eax),%eax
c0108cd9:	83 e0 05             	and    $0x5,%eax
c0108cdc:	85 c0                	test   %eax,%eax
c0108cde:	75 11                	jne    c0108cf1 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108ce0:	c7 04 24 b4 da 10 c0 	movl   $0xc010dab4,(%esp)
c0108ce7:	e8 67 76 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108cec:	e9 50 01 00 00       	jmp    c0108e41 <do_pgfault+0x206>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0108cf1:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0108cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108cfb:	8b 40 0c             	mov    0xc(%eax),%eax
c0108cfe:	83 e0 02             	and    $0x2,%eax
c0108d01:	85 c0                	test   %eax,%eax
c0108d03:	74 04                	je     c0108d09 <do_pgfault+0xce>
        perm |= PTE_W;
c0108d05:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0108d09:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108d17:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0108d1a:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0108d21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    *
    */

    /*LAB3 EXERCISE 1: YOUR CODE*/
    // 通过addr这个线性地址返回对应的虚拟页pte 如果没有get_pte会创建一个虚拟页 同时ptep等于0
    ptep = get_pte(mm->pgdir, addr, 1);             //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
c0108d28:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d2b:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d2e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0108d35:	00 
c0108d36:	8b 55 10             	mov    0x10(%ebp),%edx
c0108d39:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108d3d:	89 04 24             	mov    %eax,(%esp)
c0108d40:	e8 5c ca ff ff       	call   c01057a1 <get_pte>
c0108d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // ptep等于NULL代表alloc_page创建虚拟页失败
    if (ptep == NULL) {
c0108d48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108d4c:	75 11                	jne    c0108d5f <do_pgfault+0x124>
    	cprintf("ptep == NULL");		// 方便调试
c0108d4e:	c7 04 24 17 db 10 c0 	movl   $0xc010db17,(%esp)
c0108d55:	e8 f9 75 ff ff       	call   c0100353 <cprintf>
    	goto failed;
c0108d5a:	e9 e2 00 00 00       	jmp    c0108e41 <do_pgfault+0x206>
    }
    // 等于0是创建好虚拟页后还没有物理页与之对应
    if (*ptep == 0) {
c0108d5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108d62:	8b 00                	mov    (%eax),%eax
c0108d64:	85 c0                	test   %eax,%eax
c0108d66:	75 35                	jne    c0108d9d <do_pgfault+0x162>
    	// 尝试分配物理页
    	if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {     //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
c0108d68:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d6b:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108d71:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108d75:	8b 55 10             	mov    0x10(%ebp),%edx
c0108d78:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108d7c:	89 04 24             	mov    %eax,(%esp)
c0108d7f:	e8 8e d1 ff ff       	call   c0105f12 <pgdir_alloc_page>
c0108d84:	85 c0                	test   %eax,%eax
c0108d86:	0f 85 ae 00 00 00    	jne    c0108e3a <do_pgfault+0x1ff>
    		cprintf("pgdir_alloc_page(mm->pgdir, addr, perm) == NULL");
c0108d8c:	c7 04 24 24 db 10 c0 	movl   $0xc010db24,(%esp)
c0108d93:	e8 bb 75 ff ff       	call   c0100353 <cprintf>
    		goto failed;
c0108d98:	e9 a4 00 00 00       	jmp    c0108e41 <do_pgfault+0x206>
		     This method could be used to implement the Copy on Write (COW) thchnology(a fast fork process method).
		  2) *ptep & PTE_P == 0 & but *ptep!=0, it means this pte is a  swap entry.
		     We should add the LAB3's results here.
     */

        if(swap_init_ok) {
c0108d9d:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c0108da2:	85 c0                	test   %eax,%eax
c0108da4:	74 7d                	je     c0108e23 <do_pgfault+0x1e8>
        	// 将磁盘中的页换入到内存
            struct Page *page=NULL;
c0108da6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            ret = swap_in(mm, addr, &page);                        //(1）According to the mm AND addr, try to load the content of right disk page
c0108dad:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0108db0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108db4:	8b 45 10             	mov    0x10(%ebp),%eax
c0108db7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108dbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dbe:	89 04 24             	mov    %eax,(%esp)
c0108dc1:	e8 e5 e1 ff ff       	call   c0106fab <swap_in>
c0108dc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c0108dc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108dcd:	74 0e                	je     c0108ddd <do_pgfault+0x1a2>
            	cprintf("swap_in in do_pgfault failed\n");
c0108dcf:	c7 04 24 54 db 10 c0 	movl   $0xc010db54,(%esp)
c0108dd6:	e8 78 75 ff ff       	call   c0100353 <cprintf>
c0108ddb:	eb 64                	jmp    c0108e41 <do_pgfault+0x206>
            	goto failed;
            }
            // 建立虚拟地址和物理地址之间的对应关系                         						 //    into the memory which page managed.
            page_insert(mm->pgdir, page, addr, perm);              //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
c0108ddd:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108de0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108de3:	8b 40 0c             	mov    0xc(%eax),%eax
c0108de6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108de9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0108ded:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0108df0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108df4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108df8:	89 04 24             	mov    %eax,(%esp)
c0108dfb:	e8 fc cf ff ff       	call   c0105dfc <page_insert>
            // 最后的swap_in等于1使页面可替换
            swap_map_swappable(mm, addr, page, 1);     //(3) make the page swappable.
c0108e00:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108e03:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108e0a:	00 
c0108e0b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108e0f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e16:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e19:	89 04 24             	mov    %eax,(%esp)
c0108e1c:	e8 c1 df ff ff       	call   c0106de2 <swap_map_swappable>
c0108e21:	eb 17                	jmp    c0108e3a <do_pgfault+0x1ff>
            //page->pra_vaddr = addr;
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0108e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108e26:	8b 00                	mov    (%eax),%eax
c0108e28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e2c:	c7 04 24 74 db 10 c0 	movl   $0xc010db74,(%esp)
c0108e33:	e8 1b 75 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108e38:	eb 07                	jmp    c0108e41 <do_pgfault+0x206>
        }
   }

   ret = 0;
c0108e3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0108e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108e44:	c9                   	leave  
c0108e45:	c3                   	ret    

c0108e46 <user_mem_check>:

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
c0108e46:	55                   	push   %ebp
c0108e47:	89 e5                	mov    %esp,%ebp
c0108e49:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c0108e4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108e50:	0f 84 e0 00 00 00    	je     c0108f36 <user_mem_check+0xf0>
        if (!USER_ACCESS(addr, addr + len)) {
c0108e56:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0108e5d:	76 1c                	jbe    c0108e7b <user_mem_check+0x35>
c0108e5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e62:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108e65:	01 d0                	add    %edx,%eax
c0108e67:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108e6a:	76 0f                	jbe    c0108e7b <user_mem_check+0x35>
c0108e6c:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108e72:	01 d0                	add    %edx,%eax
c0108e74:	3d 00 00 00 b0       	cmp    $0xb0000000,%eax
c0108e79:	76 0a                	jbe    c0108e85 <user_mem_check+0x3f>
            return 0;
c0108e7b:	b8 00 00 00 00       	mov    $0x0,%eax
c0108e80:	e9 e2 00 00 00       	jmp    c0108f67 <user_mem_check+0x121>
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
c0108e85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0108e8b:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108e91:	01 d0                	add    %edx,%eax
c0108e93:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (start < end) {
c0108e96:	e9 88 00 00 00       	jmp    c0108f23 <user_mem_check+0xdd>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
c0108e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ea2:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ea5:	89 04 24             	mov    %eax,(%esp)
c0108ea8:	e8 be ef ff ff       	call   c0107e6b <find_vma>
c0108ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108eb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108eb4:	74 0b                	je     c0108ec1 <user_mem_check+0x7b>
c0108eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108eb9:	8b 40 04             	mov    0x4(%eax),%eax
c0108ebc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0108ebf:	76 0a                	jbe    c0108ecb <user_mem_check+0x85>
                return 0;
c0108ec1:	b8 00 00 00 00       	mov    $0x0,%eax
c0108ec6:	e9 9c 00 00 00       	jmp    c0108f67 <user_mem_check+0x121>
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
c0108ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ece:	8b 50 0c             	mov    0xc(%eax),%edx
c0108ed1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0108ed5:	74 07                	je     c0108ede <user_mem_check+0x98>
c0108ed7:	b8 02 00 00 00       	mov    $0x2,%eax
c0108edc:	eb 05                	jmp    c0108ee3 <user_mem_check+0x9d>
c0108ede:	b8 01 00 00 00       	mov    $0x1,%eax
c0108ee3:	21 d0                	and    %edx,%eax
c0108ee5:	85 c0                	test   %eax,%eax
c0108ee7:	75 07                	jne    c0108ef0 <user_mem_check+0xaa>
                return 0;
c0108ee9:	b8 00 00 00 00       	mov    $0x0,%eax
c0108eee:	eb 77                	jmp    c0108f67 <user_mem_check+0x121>
            }
            if (write && (vma->vm_flags & VM_STACK)) {
c0108ef0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0108ef4:	74 24                	je     c0108f1a <user_mem_check+0xd4>
c0108ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ef9:	8b 40 0c             	mov    0xc(%eax),%eax
c0108efc:	83 e0 08             	and    $0x8,%eax
c0108eff:	85 c0                	test   %eax,%eax
c0108f01:	74 17                	je     c0108f1a <user_mem_check+0xd4>
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
c0108f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f06:	8b 40 04             	mov    0x4(%eax),%eax
c0108f09:	05 00 10 00 00       	add    $0x1000,%eax
c0108f0e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0108f11:	76 07                	jbe    c0108f1a <user_mem_check+0xd4>
                    return 0;
c0108f13:	b8 00 00 00 00       	mov    $0x0,%eax
c0108f18:	eb 4d                	jmp    c0108f67 <user_mem_check+0x121>
                }
            }
            start = vma->vm_end;
c0108f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f1d:	8b 40 08             	mov    0x8(%eax),%eax
c0108f20:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!USER_ACCESS(addr, addr + len)) {
            return 0;
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
        while (start < end) {
c0108f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108f26:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108f29:	0f 82 6c ff ff ff    	jb     c0108e9b <user_mem_check+0x55>
                    return 0;
                }
            }
            start = vma->vm_end;
        }
        return 1;
c0108f2f:	b8 01 00 00 00       	mov    $0x1,%eax
c0108f34:	eb 31                	jmp    c0108f67 <user_mem_check+0x121>
    }
    return KERN_ACCESS(addr, addr + len);
c0108f36:	81 7d 0c ff ff ff bf 	cmpl   $0xbfffffff,0xc(%ebp)
c0108f3d:	76 23                	jbe    c0108f62 <user_mem_check+0x11c>
c0108f3f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108f42:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108f45:	01 d0                	add    %edx,%eax
c0108f47:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108f4a:	76 16                	jbe    c0108f62 <user_mem_check+0x11c>
c0108f4c:	8b 45 10             	mov    0x10(%ebp),%eax
c0108f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108f52:	01 d0                	add    %edx,%eax
c0108f54:	3d 00 00 00 f8       	cmp    $0xf8000000,%eax
c0108f59:	77 07                	ja     c0108f62 <user_mem_check+0x11c>
c0108f5b:	b8 01 00 00 00       	mov    $0x1,%eax
c0108f60:	eb 05                	jmp    c0108f67 <user_mem_check+0x121>
c0108f62:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108f67:	c9                   	leave  
c0108f68:	c3                   	ret    

c0108f69 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108f69:	55                   	push   %ebp
c0108f6a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108f6c:	8b 55 08             	mov    0x8(%ebp),%edx
c0108f6f:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0108f74:	29 c2                	sub    %eax,%edx
c0108f76:	89 d0                	mov    %edx,%eax
c0108f78:	c1 f8 05             	sar    $0x5,%eax
}
c0108f7b:	5d                   	pop    %ebp
c0108f7c:	c3                   	ret    

c0108f7d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108f7d:	55                   	push   %ebp
c0108f7e:	89 e5                	mov    %esp,%ebp
c0108f80:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108f83:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f86:	89 04 24             	mov    %eax,(%esp)
c0108f89:	e8 db ff ff ff       	call   c0108f69 <page2ppn>
c0108f8e:	c1 e0 0c             	shl    $0xc,%eax
}
c0108f91:	c9                   	leave  
c0108f92:	c3                   	ret    

c0108f93 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0108f93:	55                   	push   %ebp
c0108f94:	89 e5                	mov    %esp,%ebp
c0108f96:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108f99:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f9c:	89 04 24             	mov    %eax,(%esp)
c0108f9f:	e8 d9 ff ff ff       	call   c0108f7d <page2pa>
c0108fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108faa:	c1 e8 0c             	shr    $0xc,%eax
c0108fad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108fb0:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0108fb5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108fb8:	72 23                	jb     c0108fdd <page2kva+0x4a>
c0108fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108fbd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108fc1:	c7 44 24 08 9c db 10 	movl   $0xc010db9c,0x8(%esp)
c0108fc8:	c0 
c0108fc9:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0108fd0:	00 
c0108fd1:	c7 04 24 bf db 10 c0 	movl   $0xc010dbbf,(%esp)
c0108fd8:	e8 f8 7d ff ff       	call   c0100dd5 <__panic>
c0108fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108fe0:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108fe5:	c9                   	leave  
c0108fe6:	c3                   	ret    

c0108fe7 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108fe7:	55                   	push   %ebp
c0108fe8:	89 e5                	mov    %esp,%ebp
c0108fea:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0108fed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108ff4:	e8 2c 8b ff ff       	call   c0101b25 <ide_device_valid>
c0108ff9:	85 c0                	test   %eax,%eax
c0108ffb:	75 1c                	jne    c0109019 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0108ffd:	c7 44 24 08 cd db 10 	movl   $0xc010dbcd,0x8(%esp)
c0109004:	c0 
c0109005:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c010900c:	00 
c010900d:	c7 04 24 e7 db 10 c0 	movl   $0xc010dbe7,(%esp)
c0109014:	e8 bc 7d ff ff       	call   c0100dd5 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0109019:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109020:	e8 3f 8b ff ff       	call   c0101b64 <ide_device_size>
c0109025:	c1 e8 03             	shr    $0x3,%eax
c0109028:	a3 7c f0 19 c0       	mov    %eax,0xc019f07c
}
c010902d:	c9                   	leave  
c010902e:	c3                   	ret    

c010902f <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c010902f:	55                   	push   %ebp
c0109030:	89 e5                	mov    %esp,%ebp
c0109032:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0109035:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109038:	89 04 24             	mov    %eax,(%esp)
c010903b:	e8 53 ff ff ff       	call   c0108f93 <page2kva>
c0109040:	8b 55 08             	mov    0x8(%ebp),%edx
c0109043:	c1 ea 08             	shr    $0x8,%edx
c0109046:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0109049:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010904d:	74 0b                	je     c010905a <swapfs_read+0x2b>
c010904f:	8b 15 7c f0 19 c0    	mov    0xc019f07c,%edx
c0109055:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0109058:	72 23                	jb     c010907d <swapfs_read+0x4e>
c010905a:	8b 45 08             	mov    0x8(%ebp),%eax
c010905d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109061:	c7 44 24 08 f8 db 10 	movl   $0xc010dbf8,0x8(%esp)
c0109068:	c0 
c0109069:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0109070:	00 
c0109071:	c7 04 24 e7 db 10 c0 	movl   $0xc010dbe7,(%esp)
c0109078:	e8 58 7d ff ff       	call   c0100dd5 <__panic>
c010907d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109080:	c1 e2 03             	shl    $0x3,%edx
c0109083:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010908a:	00 
c010908b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010908f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109093:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010909a:	e8 04 8b ff ff       	call   c0101ba3 <ide_read_secs>
}
c010909f:	c9                   	leave  
c01090a0:	c3                   	ret    

c01090a1 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c01090a1:	55                   	push   %ebp
c01090a2:	89 e5                	mov    %esp,%ebp
c01090a4:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01090a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090aa:	89 04 24             	mov    %eax,(%esp)
c01090ad:	e8 e1 fe ff ff       	call   c0108f93 <page2kva>
c01090b2:	8b 55 08             	mov    0x8(%ebp),%edx
c01090b5:	c1 ea 08             	shr    $0x8,%edx
c01090b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01090bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01090bf:	74 0b                	je     c01090cc <swapfs_write+0x2b>
c01090c1:	8b 15 7c f0 19 c0    	mov    0xc019f07c,%edx
c01090c7:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01090ca:	72 23                	jb     c01090ef <swapfs_write+0x4e>
c01090cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01090cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01090d3:	c7 44 24 08 f8 db 10 	movl   $0xc010dbf8,0x8(%esp)
c01090da:	c0 
c01090db:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c01090e2:	00 
c01090e3:	c7 04 24 e7 db 10 c0 	movl   $0xc010dbe7,(%esp)
c01090ea:	e8 e6 7c ff ff       	call   c0100dd5 <__panic>
c01090ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01090f2:	c1 e2 03             	shl    $0x3,%edx
c01090f5:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01090fc:	00 
c01090fd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109101:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109105:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010910c:	e8 d4 8c ff ff       	call   c0101de5 <ide_write_secs>
}
c0109111:	c9                   	leave  
c0109112:	c3                   	ret    

c0109113 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c0109113:	52                   	push   %edx
    call *%ebx              # call fn
c0109114:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c0109116:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c0109117:	e8 40 0c 00 00       	call   c0109d5c <do_exit>

c010911c <test_and_set_bit>:
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool
test_and_set_bit(int nr, volatile void *addr) {
c010911c:	55                   	push   %ebp
c010911d:	89 e5                	mov    %esp,%ebp
c010911f:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btsl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c0109122:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109125:	8b 45 08             	mov    0x8(%ebp),%eax
c0109128:	0f ab 02             	bts    %eax,(%edx)
c010912b:	19 c0                	sbb    %eax,%eax
c010912d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
c0109130:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109134:	0f 95 c0             	setne  %al
c0109137:	0f b6 c0             	movzbl %al,%eax
}
c010913a:	c9                   	leave  
c010913b:	c3                   	ret    

c010913c <test_and_clear_bit>:
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool
test_and_clear_bit(int nr, volatile void *addr) {
c010913c:	55                   	push   %ebp
c010913d:	89 e5                	mov    %esp,%ebp
c010913f:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btrl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c0109142:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109145:	8b 45 08             	mov    0x8(%ebp),%eax
c0109148:	0f b3 02             	btr    %eax,(%edx)
c010914b:	19 c0                	sbb    %eax,%eax
c010914d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
c0109150:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109154:	0f 95 c0             	setne  %al
c0109157:	0f b6 c0             	movzbl %al,%eax
}
c010915a:	c9                   	leave  
c010915b:	c3                   	ret    

c010915c <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c010915c:	55                   	push   %ebp
c010915d:	89 e5                	mov    %esp,%ebp
c010915f:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0109162:	9c                   	pushf  
c0109163:	58                   	pop    %eax
c0109164:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0109167:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010916a:	25 00 02 00 00       	and    $0x200,%eax
c010916f:	85 c0                	test   %eax,%eax
c0109171:	74 0c                	je     c010917f <__intr_save+0x23>
        intr_disable();
c0109173:	e8 b5 8e ff ff       	call   c010202d <intr_disable>
        return 1;
c0109178:	b8 01 00 00 00       	mov    $0x1,%eax
c010917d:	eb 05                	jmp    c0109184 <__intr_save+0x28>
    }
    return 0;
c010917f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109184:	c9                   	leave  
c0109185:	c3                   	ret    

c0109186 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0109186:	55                   	push   %ebp
c0109187:	89 e5                	mov    %esp,%ebp
c0109189:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010918c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109190:	74 05                	je     c0109197 <__intr_restore+0x11>
        intr_enable();
c0109192:	e8 90 8e ff ff       	call   c0102027 <intr_enable>
    }
}
c0109197:	c9                   	leave  
c0109198:	c3                   	ret    

c0109199 <try_lock>:
lock_init(lock_t *lock) {
    *lock = 0;
}

static inline bool
try_lock(lock_t *lock) {
c0109199:	55                   	push   %ebp
c010919a:	89 e5                	mov    %esp,%ebp
c010919c:	83 ec 08             	sub    $0x8,%esp
    return !test_and_set_bit(0, lock);
c010919f:	8b 45 08             	mov    0x8(%ebp),%eax
c01091a2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01091a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01091ad:	e8 6a ff ff ff       	call   c010911c <test_and_set_bit>
c01091b2:	85 c0                	test   %eax,%eax
c01091b4:	0f 94 c0             	sete   %al
c01091b7:	0f b6 c0             	movzbl %al,%eax
}
c01091ba:	c9                   	leave  
c01091bb:	c3                   	ret    

c01091bc <lock>:

static inline void
lock(lock_t *lock) {
c01091bc:	55                   	push   %ebp
c01091bd:	89 e5                	mov    %esp,%ebp
c01091bf:	83 ec 18             	sub    $0x18,%esp
    while (!try_lock(lock)) {
c01091c2:	eb 05                	jmp    c01091c9 <lock+0xd>
        schedule();
c01091c4:	e8 f8 1b 00 00       	call   c010adc1 <schedule>
    return !test_and_set_bit(0, lock);
}

static inline void
lock(lock_t *lock) {
    while (!try_lock(lock)) {
c01091c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01091cc:	89 04 24             	mov    %eax,(%esp)
c01091cf:	e8 c5 ff ff ff       	call   c0109199 <try_lock>
c01091d4:	85 c0                	test   %eax,%eax
c01091d6:	74 ec                	je     c01091c4 <lock+0x8>
        schedule();
    }
}
c01091d8:	c9                   	leave  
c01091d9:	c3                   	ret    

c01091da <unlock>:

static inline void
unlock(lock_t *lock) {
c01091da:	55                   	push   %ebp
c01091db:	89 e5                	mov    %esp,%ebp
c01091dd:	83 ec 18             	sub    $0x18,%esp
    if (!test_and_clear_bit(0, lock)) {
c01091e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01091e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01091e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01091ee:	e8 49 ff ff ff       	call   c010913c <test_and_clear_bit>
c01091f3:	85 c0                	test   %eax,%eax
c01091f5:	75 1c                	jne    c0109213 <unlock+0x39>
        panic("Unlock failed.\n");
c01091f7:	c7 44 24 08 18 dc 10 	movl   $0xc010dc18,0x8(%esp)
c01091fe:	c0 
c01091ff:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
c0109206:	00 
c0109207:	c7 04 24 28 dc 10 c0 	movl   $0xc010dc28,(%esp)
c010920e:	e8 c2 7b ff ff       	call   c0100dd5 <__panic>
    }
}
c0109213:	c9                   	leave  
c0109214:	c3                   	ret    

c0109215 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0109215:	55                   	push   %ebp
c0109216:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0109218:	8b 55 08             	mov    0x8(%ebp),%edx
c010921b:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0109220:	29 c2                	sub    %eax,%edx
c0109222:	89 d0                	mov    %edx,%eax
c0109224:	c1 f8 05             	sar    $0x5,%eax
}
c0109227:	5d                   	pop    %ebp
c0109228:	c3                   	ret    

c0109229 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0109229:	55                   	push   %ebp
c010922a:	89 e5                	mov    %esp,%ebp
c010922c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010922f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109232:	89 04 24             	mov    %eax,(%esp)
c0109235:	e8 db ff ff ff       	call   c0109215 <page2ppn>
c010923a:	c1 e0 0c             	shl    $0xc,%eax
}
c010923d:	c9                   	leave  
c010923e:	c3                   	ret    

c010923f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010923f:	55                   	push   %ebp
c0109240:	89 e5                	mov    %esp,%ebp
c0109242:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0109245:	8b 45 08             	mov    0x8(%ebp),%eax
c0109248:	c1 e8 0c             	shr    $0xc,%eax
c010924b:	89 c2                	mov    %eax,%edx
c010924d:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0109252:	39 c2                	cmp    %eax,%edx
c0109254:	72 1c                	jb     c0109272 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0109256:	c7 44 24 08 3c dc 10 	movl   $0xc010dc3c,0x8(%esp)
c010925d:	c0 
c010925e:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0109265:	00 
c0109266:	c7 04 24 5b dc 10 c0 	movl   $0xc010dc5b,(%esp)
c010926d:	e8 63 7b ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0109272:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0109277:	8b 55 08             	mov    0x8(%ebp),%edx
c010927a:	c1 ea 0c             	shr    $0xc,%edx
c010927d:	c1 e2 05             	shl    $0x5,%edx
c0109280:	01 d0                	add    %edx,%eax
}
c0109282:	c9                   	leave  
c0109283:	c3                   	ret    

c0109284 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0109284:	55                   	push   %ebp
c0109285:	89 e5                	mov    %esp,%ebp
c0109287:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010928a:	8b 45 08             	mov    0x8(%ebp),%eax
c010928d:	89 04 24             	mov    %eax,(%esp)
c0109290:	e8 94 ff ff ff       	call   c0109229 <page2pa>
c0109295:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109298:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010929b:	c1 e8 0c             	shr    $0xc,%eax
c010929e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01092a1:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01092a6:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01092a9:	72 23                	jb     c01092ce <page2kva+0x4a>
c01092ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01092b2:	c7 44 24 08 6c dc 10 	movl   $0xc010dc6c,0x8(%esp)
c01092b9:	c0 
c01092ba:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01092c1:	00 
c01092c2:	c7 04 24 5b dc 10 c0 	movl   $0xc010dc5b,(%esp)
c01092c9:	e8 07 7b ff ff       	call   c0100dd5 <__panic>
c01092ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092d1:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01092d6:	c9                   	leave  
c01092d7:	c3                   	ret    

c01092d8 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01092d8:	55                   	push   %ebp
c01092d9:	89 e5                	mov    %esp,%ebp
c01092db:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01092de:	8b 45 08             	mov    0x8(%ebp),%eax
c01092e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01092e4:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01092eb:	77 23                	ja     c0109310 <kva2page+0x38>
c01092ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01092f4:	c7 44 24 08 90 dc 10 	movl   $0xc010dc90,0x8(%esp)
c01092fb:	c0 
c01092fc:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0109303:	00 
c0109304:	c7 04 24 5b dc 10 c0 	movl   $0xc010dc5b,(%esp)
c010930b:	e8 c5 7a ff ff       	call   c0100dd5 <__panic>
c0109310:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109313:	05 00 00 00 40       	add    $0x40000000,%eax
c0109318:	89 04 24             	mov    %eax,(%esp)
c010931b:	e8 1f ff ff ff       	call   c010923f <pa2page>
}
c0109320:	c9                   	leave  
c0109321:	c3                   	ret    

c0109322 <mm_count_inc>:

static inline int
mm_count_inc(struct mm_struct *mm) {
c0109322:	55                   	push   %ebp
c0109323:	89 e5                	mov    %esp,%ebp
    mm->mm_count += 1;
c0109325:	8b 45 08             	mov    0x8(%ebp),%eax
c0109328:	8b 40 18             	mov    0x18(%eax),%eax
c010932b:	8d 50 01             	lea    0x1(%eax),%edx
c010932e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109331:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c0109334:	8b 45 08             	mov    0x8(%ebp),%eax
c0109337:	8b 40 18             	mov    0x18(%eax),%eax
}
c010933a:	5d                   	pop    %ebp
c010933b:	c3                   	ret    

c010933c <mm_count_dec>:

static inline int
mm_count_dec(struct mm_struct *mm) {
c010933c:	55                   	push   %ebp
c010933d:	89 e5                	mov    %esp,%ebp
    mm->mm_count -= 1;
c010933f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109342:	8b 40 18             	mov    0x18(%eax),%eax
c0109345:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109348:	8b 45 08             	mov    0x8(%ebp),%eax
c010934b:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c010934e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109351:	8b 40 18             	mov    0x18(%eax),%eax
}
c0109354:	5d                   	pop    %ebp
c0109355:	c3                   	ret    

c0109356 <lock_mm>:

static inline void
lock_mm(struct mm_struct *mm) {
c0109356:	55                   	push   %ebp
c0109357:	89 e5                	mov    %esp,%ebp
c0109359:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c010935c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109360:	74 0e                	je     c0109370 <lock_mm+0x1a>
        lock(&(mm->mm_lock));
c0109362:	8b 45 08             	mov    0x8(%ebp),%eax
c0109365:	83 c0 1c             	add    $0x1c,%eax
c0109368:	89 04 24             	mov    %eax,(%esp)
c010936b:	e8 4c fe ff ff       	call   c01091bc <lock>
    }
}
c0109370:	c9                   	leave  
c0109371:	c3                   	ret    

c0109372 <unlock_mm>:

static inline void
unlock_mm(struct mm_struct *mm) {
c0109372:	55                   	push   %ebp
c0109373:	89 e5                	mov    %esp,%ebp
c0109375:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c0109378:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010937c:	74 0e                	je     c010938c <unlock_mm+0x1a>
        unlock(&(mm->mm_lock));
c010937e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109381:	83 c0 1c             	add    $0x1c,%eax
c0109384:	89 04 24             	mov    %eax,(%esp)
c0109387:	e8 4e fe ff ff       	call   c01091da <unlock>
    }
}
c010938c:	c9                   	leave  
c010938d:	c3                   	ret    

c010938e <alloc_proc>:
void forkrets(struct trapframe *tf);						// 调用 trap/trapentry.S 中的 forkrets:
void switch_to(struct context *from, struct context *to);	// 调用switch.S

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c010938e:	55                   	push   %ebp
c010938f:	89 e5                	mov    %esp,%ebp
c0109391:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c0109394:	c7 04 24 7c 00 00 00 	movl   $0x7c,(%esp)
c010939b:	e8 25 b8 ff ff       	call   c0104bc5 <kmalloc>
c01093a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c01093a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01093a7:	0f 84 cd 00 00 00    	je     c010947a <alloc_proc+0xec>

    	/*
    	 * 执行的是第一步初始化工作
    	 */

    	proc->state = PROC_UNINIT;							// 设置了进程的状态为“初始”态，这表示进程已经 “出生”了，正在获取资源茁壮成长中；
c01093ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01093b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    	proc->pid = -1;										// 未分配的进程pid是-1 先设置pid为无效值-1，用户调完alloc_proc函数后再根据实际情况设置pid。
c01093b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01093b9:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
															// 设置了进程的pid为-1，这表示进程的“身份证号”还没有办好；

    	proc->cr3 = boot_cr3;								// boot_cr3指向了uCore启动时建立好的内核虚拟空间的页目录表首地址
c01093c0:	8b 15 c8 ef 19 c0    	mov    0xc019efc8,%edx
c01093c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01093c9:	89 50 40             	mov    %edx,0x40(%eax)
															// 表明由于该内核线程在内核中运行，故采用为uCore内核已经建立的页表，即设置为在uCore内核页表的起始地址boot_cr3。

    	proc->runs = 0;
c01093cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01093cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		proc->kstack = 0;									// 记录了分配给该进程/线程的内核栈的位置
c01093d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01093d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		proc->need_resched = 0;								// 是否需要调度
c01093e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01093e3:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
		proc->parent = NULL;								// 父进程
c01093ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01093ed:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
		proc->mm = 0;									// 虚拟内存结构体（lab4实验可忽略）
c01093f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01093f7:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
		 * 该函数用于清空一个结构体中所有的成员变量，下面解释三个参数：
		 * 第一个参数：位置指针，例如数组名、结构体首地址
		 * 第二个参数：替换为什么
		 * memset 函数的第三个参数 n 的值一般用 sizeof() 获取
		 */
		memset(&(proc->context), 0, sizeof(struct context)); 	// 上下文结构体
c01093fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109401:	83 c0 1c             	add    $0x1c,%eax
c0109404:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c010940b:	00 
c010940c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109413:	00 
c0109414:	89 04 24             	mov    %eax,(%esp)
c0109417:	e8 10 27 00 00       	call   c010bb2c <memset>
		proc->tf = NULL;
c010941c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010941f:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)

		proc->flags = 0;
c0109426:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109429:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
		// 清空数组就不用sizeof了，第三个参数直接写数组的大小-1即可
		memset(proc->name, 0, PROC_NAME_LEN);
c0109430:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109433:	83 c0 48             	add    $0x48,%eax
c0109436:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c010943d:	00 
c010943e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109445:	00 
c0109446:	89 04 24             	mov    %eax,(%esp)
c0109449:	e8 de 26 00 00       	call   c010bb2c <memset>

		// LAB5新增的
		proc->wait_state = 0;							// 进程刚开始创建，都是等待状态。原因是因为需要调度。
c010944e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109451:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
		proc->cptr = proc->yptr = proc->optr = NULL;
c0109458:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010945b:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
c0109462:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109465:	8b 50 78             	mov    0x78(%eax),%edx
c0109468:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010946b:	89 50 74             	mov    %edx,0x74(%eax)
c010946e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109471:	8b 50 74             	mov    0x74(%eax),%edx
c0109474:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109477:	89 50 70             	mov    %edx,0x70(%eax)


    }
    return proc;
c010947a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010947d:	c9                   	leave  
c010947e:	c3                   	ret    

c010947f <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c010947f:	55                   	push   %ebp
c0109480:	89 e5                	mov    %esp,%ebp
c0109482:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c0109485:	8b 45 08             	mov    0x8(%ebp),%eax
c0109488:	83 c0 48             	add    $0x48,%eax
c010948b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0109492:	00 
c0109493:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010949a:	00 
c010949b:	89 04 24             	mov    %eax,(%esp)
c010949e:	e8 89 26 00 00       	call   c010bb2c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c01094a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01094a6:	8d 50 48             	lea    0x48(%eax),%edx
c01094a9:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01094b0:	00 
c01094b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094b8:	89 14 24             	mov    %edx,(%esp)
c01094bb:	e8 4e 27 00 00       	call   c010bc0e <memcpy>
}
c01094c0:	c9                   	leave  
c01094c1:	c3                   	ret    

c01094c2 <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c01094c2:	55                   	push   %ebp
c01094c3:	89 e5                	mov    %esp,%ebp
c01094c5:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c01094c8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01094cf:	00 
c01094d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01094d7:	00 
c01094d8:	c7 04 24 a4 ef 19 c0 	movl   $0xc019efa4,(%esp)
c01094df:	e8 48 26 00 00       	call   c010bb2c <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c01094e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01094e7:	83 c0 48             	add    $0x48,%eax
c01094ea:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01094f1:	00 
c01094f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094f6:	c7 04 24 a4 ef 19 c0 	movl   $0xc019efa4,(%esp)
c01094fd:	e8 0c 27 00 00       	call   c010bc0e <memcpy>
}
c0109502:	c9                   	leave  
c0109503:	c3                   	ret    

c0109504 <set_links>:

// set_links - set the relation links of process
static void
set_links(struct proc_struct *proc) {
c0109504:	55                   	push   %ebp
c0109505:	89 e5                	mov    %esp,%ebp
c0109507:	83 ec 20             	sub    $0x20,%esp
    list_add(&proc_list, &(proc->list_link));
c010950a:	8b 45 08             	mov    0x8(%ebp),%eax
c010950d:	83 c0 58             	add    $0x58,%eax
c0109510:	c7 45 fc b0 f0 19 c0 	movl   $0xc019f0b0,-0x4(%ebp)
c0109517:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010951a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010951d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109520:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109523:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0109526:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109529:	8b 40 04             	mov    0x4(%eax),%eax
c010952c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010952f:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109532:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109535:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0109538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010953b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010953e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109541:	89 10                	mov    %edx,(%eax)
c0109543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109546:	8b 10                	mov    (%eax),%edx
c0109548:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010954b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010954e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109551:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109554:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0109557:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010955a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010955d:	89 10                	mov    %edx,(%eax)
    proc->yptr = NULL;
c010955f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109562:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
    if ((proc->optr = proc->parent->cptr) != NULL) {
c0109569:	8b 45 08             	mov    0x8(%ebp),%eax
c010956c:	8b 40 14             	mov    0x14(%eax),%eax
c010956f:	8b 50 70             	mov    0x70(%eax),%edx
c0109572:	8b 45 08             	mov    0x8(%ebp),%eax
c0109575:	89 50 78             	mov    %edx,0x78(%eax)
c0109578:	8b 45 08             	mov    0x8(%ebp),%eax
c010957b:	8b 40 78             	mov    0x78(%eax),%eax
c010957e:	85 c0                	test   %eax,%eax
c0109580:	74 0c                	je     c010958e <set_links+0x8a>
        proc->optr->yptr = proc;
c0109582:	8b 45 08             	mov    0x8(%ebp),%eax
c0109585:	8b 40 78             	mov    0x78(%eax),%eax
c0109588:	8b 55 08             	mov    0x8(%ebp),%edx
c010958b:	89 50 74             	mov    %edx,0x74(%eax)
    }
    proc->parent->cptr = proc;
c010958e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109591:	8b 40 14             	mov    0x14(%eax),%eax
c0109594:	8b 55 08             	mov    0x8(%ebp),%edx
c0109597:	89 50 70             	mov    %edx,0x70(%eax)
    nr_process ++;
c010959a:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c010959f:	83 c0 01             	add    $0x1,%eax
c01095a2:	a3 a0 ef 19 c0       	mov    %eax,0xc019efa0
}
c01095a7:	c9                   	leave  
c01095a8:	c3                   	ret    

c01095a9 <remove_links>:

// remove_links - clean the relation links of process
static void
remove_links(struct proc_struct *proc) {
c01095a9:	55                   	push   %ebp
c01095aa:	89 e5                	mov    %esp,%ebp
c01095ac:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->list_link));
c01095af:	8b 45 08             	mov    0x8(%ebp),%eax
c01095b2:	83 c0 58             	add    $0x58,%eax
c01095b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01095b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01095bb:	8b 40 04             	mov    0x4(%eax),%eax
c01095be:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01095c1:	8b 12                	mov    (%edx),%edx
c01095c3:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01095c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01095c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01095cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01095cf:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01095d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01095d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01095d8:	89 10                	mov    %edx,(%eax)
    if (proc->optr != NULL) {
c01095da:	8b 45 08             	mov    0x8(%ebp),%eax
c01095dd:	8b 40 78             	mov    0x78(%eax),%eax
c01095e0:	85 c0                	test   %eax,%eax
c01095e2:	74 0f                	je     c01095f3 <remove_links+0x4a>
        proc->optr->yptr = proc->yptr;
c01095e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01095e7:	8b 40 78             	mov    0x78(%eax),%eax
c01095ea:	8b 55 08             	mov    0x8(%ebp),%edx
c01095ed:	8b 52 74             	mov    0x74(%edx),%edx
c01095f0:	89 50 74             	mov    %edx,0x74(%eax)
    }
    if (proc->yptr != NULL) {
c01095f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01095f6:	8b 40 74             	mov    0x74(%eax),%eax
c01095f9:	85 c0                	test   %eax,%eax
c01095fb:	74 11                	je     c010960e <remove_links+0x65>
        proc->yptr->optr = proc->optr;
c01095fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0109600:	8b 40 74             	mov    0x74(%eax),%eax
c0109603:	8b 55 08             	mov    0x8(%ebp),%edx
c0109606:	8b 52 78             	mov    0x78(%edx),%edx
c0109609:	89 50 78             	mov    %edx,0x78(%eax)
c010960c:	eb 0f                	jmp    c010961d <remove_links+0x74>
    }
    else {
       proc->parent->cptr = proc->optr;
c010960e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109611:	8b 40 14             	mov    0x14(%eax),%eax
c0109614:	8b 55 08             	mov    0x8(%ebp),%edx
c0109617:	8b 52 78             	mov    0x78(%edx),%edx
c010961a:	89 50 70             	mov    %edx,0x70(%eax)
    }
    nr_process --;
c010961d:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c0109622:	83 e8 01             	sub    $0x1,%eax
c0109625:	a3 a0 ef 19 c0       	mov    %eax,0xc019efa0
}
c010962a:	c9                   	leave  
c010962b:	c3                   	ret    

c010962c <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c010962c:	55                   	push   %ebp
c010962d:	89 e5                	mov    %esp,%ebp
c010962f:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c0109632:	c7 45 f8 b0 f0 19 c0 	movl   $0xc019f0b0,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c0109639:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c010963e:	83 c0 01             	add    $0x1,%eax
c0109641:	a3 80 aa 12 c0       	mov    %eax,0xc012aa80
c0109646:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c010964b:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0109650:	7e 0c                	jle    c010965e <get_pid+0x32>
        last_pid = 1;
c0109652:	c7 05 80 aa 12 c0 01 	movl   $0x1,0xc012aa80
c0109659:	00 00 00 
        goto inside;
c010965c:	eb 13                	jmp    c0109671 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c010965e:	8b 15 80 aa 12 c0    	mov    0xc012aa80,%edx
c0109664:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c0109669:	39 c2                	cmp    %eax,%edx
c010966b:	0f 8c ac 00 00 00    	jl     c010971d <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c0109671:	c7 05 84 aa 12 c0 00 	movl   $0x2000,0xc012aa84
c0109678:	20 00 00 
    repeat:
        le = list;
c010967b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010967e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c0109681:	eb 7f                	jmp    c0109702 <get_pid+0xd6>
            proc = le2proc(le, list_link);
c0109683:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109686:	83 e8 58             	sub    $0x58,%eax
c0109689:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c010968c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010968f:	8b 50 04             	mov    0x4(%eax),%edx
c0109692:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c0109697:	39 c2                	cmp    %eax,%edx
c0109699:	75 3e                	jne    c01096d9 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c010969b:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c01096a0:	83 c0 01             	add    $0x1,%eax
c01096a3:	a3 80 aa 12 c0       	mov    %eax,0xc012aa80
c01096a8:	8b 15 80 aa 12 c0    	mov    0xc012aa80,%edx
c01096ae:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c01096b3:	39 c2                	cmp    %eax,%edx
c01096b5:	7c 4b                	jl     c0109702 <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c01096b7:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c01096bc:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c01096c1:	7e 0a                	jle    c01096cd <get_pid+0xa1>
                        last_pid = 1;
c01096c3:	c7 05 80 aa 12 c0 01 	movl   $0x1,0xc012aa80
c01096ca:	00 00 00 
                    }
                    next_safe = MAX_PID;
c01096cd:	c7 05 84 aa 12 c0 00 	movl   $0x2000,0xc012aa84
c01096d4:	20 00 00 
                    goto repeat;
c01096d7:	eb a2                	jmp    c010967b <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c01096d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096dc:	8b 50 04             	mov    0x4(%eax),%edx
c01096df:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c01096e4:	39 c2                	cmp    %eax,%edx
c01096e6:	7e 1a                	jle    c0109702 <get_pid+0xd6>
c01096e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096eb:	8b 50 04             	mov    0x4(%eax),%edx
c01096ee:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c01096f3:	39 c2                	cmp    %eax,%edx
c01096f5:	7d 0b                	jge    c0109702 <get_pid+0xd6>
                next_safe = proc->pid;
c01096f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096fa:	8b 40 04             	mov    0x4(%eax),%eax
c01096fd:	a3 84 aa 12 c0       	mov    %eax,0xc012aa84
c0109702:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109705:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0109708:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010970b:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c010970e:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0109711:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109714:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0109717:	0f 85 66 ff ff ff    	jne    c0109683 <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c010971d:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
}
c0109722:	c9                   	leave  
c0109723:	c3                   	ret    

c0109724 <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c0109724:	55                   	push   %ebp
c0109725:	89 e5                	mov    %esp,%ebp
c0109727:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c010972a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010972f:	39 45 08             	cmp    %eax,0x8(%ebp)
c0109732:	74 63                	je     c0109797 <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c0109734:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109739:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010973c:	8b 45 08             	mov    0x8(%ebp),%eax
c010973f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c0109742:	e8 15 fa ff ff       	call   c010915c <__intr_save>
c0109747:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c010974a:	8b 45 08             	mov    0x8(%ebp),%eax
c010974d:	a3 88 cf 19 c0       	mov    %eax,0xc019cf88
            // 切换栈
            load_esp0(next->kstack + KSTACKSIZE);
c0109752:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109755:	8b 40 0c             	mov    0xc(%eax),%eax
c0109758:	05 00 20 00 00       	add    $0x2000,%eax
c010975d:	89 04 24             	mov    %eax,(%esp)
c0109760:	e8 87 b7 ff ff       	call   c0104eec <load_esp0>
            // 切换目录表
            lcr3(next->cr3);
c0109765:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109768:	8b 40 40             	mov    0x40(%eax),%eax
c010976b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010976e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109771:	0f 22 d8             	mov    %eax,%cr3
            // 切换context; context函数是由汇编语言实现的（switch.S）
            switch_to(&(prev->context), &(next->context));
c0109774:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109777:	8d 50 1c             	lea    0x1c(%eax),%edx
c010977a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010977d:	83 c0 1c             	add    $0x1c,%eax
c0109780:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109784:	89 04 24             	mov    %eax,(%esp)
c0109787:	e8 3d 15 00 00       	call   c010acc9 <switch_to>
        }
        local_intr_restore(intr_flag);
c010978c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010978f:	89 04 24             	mov    %eax,(%esp)
c0109792:	e8 ef f9 ff ff       	call   c0109186 <__intr_restore>
    }
}
c0109797:	c9                   	leave  
c0109798:	c3                   	ret    

c0109799 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0109799:	55                   	push   %ebp
c010979a:	89 e5                	mov    %esp,%ebp
c010979c:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c010979f:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01097a4:	8b 40 3c             	mov    0x3c(%eax),%eax
c01097a7:	89 04 24             	mov    %eax,(%esp)
c01097aa:	e8 b5 92 ff ff       	call   c0102a64 <forkrets>
}
c01097af:	c9                   	leave  
c01097b0:	c3                   	ret    

c01097b1 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c01097b1:	55                   	push   %ebp
c01097b2:	89 e5                	mov    %esp,%ebp
c01097b4:	53                   	push   %ebx
c01097b5:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c01097b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01097bb:	8d 58 60             	lea    0x60(%eax),%ebx
c01097be:	8b 45 08             	mov    0x8(%ebp),%eax
c01097c1:	8b 40 04             	mov    0x4(%eax),%eax
c01097c4:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c01097cb:	00 
c01097cc:	89 04 24             	mov    %eax,(%esp)
c01097cf:	e8 ab 18 00 00       	call   c010b07f <hash32>
c01097d4:	c1 e0 03             	shl    $0x3,%eax
c01097d7:	05 a0 cf 19 c0       	add    $0xc019cfa0,%eax
c01097dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01097df:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c01097e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01097e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01097e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01097ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01097f1:	8b 40 04             	mov    0x4(%eax),%eax
c01097f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01097f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01097fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01097fd:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0109800:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0109803:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109806:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109809:	89 10                	mov    %edx,(%eax)
c010980b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010980e:	8b 10                	mov    (%eax),%edx
c0109810:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109813:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0109816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109819:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010981c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010981f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109822:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0109825:	89 10                	mov    %edx,(%eax)
}
c0109827:	83 c4 34             	add    $0x34,%esp
c010982a:	5b                   	pop    %ebx
c010982b:	5d                   	pop    %ebp
c010982c:	c3                   	ret    

c010982d <unhash_proc>:

// unhash_proc - delete proc from proc hash_list
static void
unhash_proc(struct proc_struct *proc) {
c010982d:	55                   	push   %ebp
c010982e:	89 e5                	mov    %esp,%ebp
c0109830:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->hash_link));
c0109833:	8b 45 08             	mov    0x8(%ebp),%eax
c0109836:	83 c0 60             	add    $0x60,%eax
c0109839:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010983c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010983f:	8b 40 04             	mov    0x4(%eax),%eax
c0109842:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109845:	8b 12                	mov    (%edx),%edx
c0109847:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010984a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010984d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109850:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109853:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0109856:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109859:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010985c:	89 10                	mov    %edx,(%eax)
}
c010985e:	c9                   	leave  
c010985f:	c3                   	ret    

c0109860 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0109860:	55                   	push   %ebp
c0109861:	89 e5                	mov    %esp,%ebp
c0109863:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c0109866:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010986a:	7e 5f                	jle    c01098cb <find_proc+0x6b>
c010986c:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0109873:	7f 56                	jg     c01098cb <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0109875:	8b 45 08             	mov    0x8(%ebp),%eax
c0109878:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c010987f:	00 
c0109880:	89 04 24             	mov    %eax,(%esp)
c0109883:	e8 f7 17 00 00       	call   c010b07f <hash32>
c0109888:	c1 e0 03             	shl    $0x3,%eax
c010988b:	05 a0 cf 19 c0       	add    $0xc019cfa0,%eax
c0109890:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109893:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109896:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0109899:	eb 19                	jmp    c01098b4 <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c010989b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010989e:	83 e8 60             	sub    $0x60,%eax
c01098a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c01098a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01098a7:	8b 40 04             	mov    0x4(%eax),%eax
c01098aa:	3b 45 08             	cmp    0x8(%ebp),%eax
c01098ad:	75 05                	jne    c01098b4 <find_proc+0x54>
                return proc;
c01098af:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01098b2:	eb 1c                	jmp    c01098d0 <find_proc+0x70>
c01098b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01098b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01098ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01098bd:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c01098c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01098c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01098c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01098c9:	75 d0                	jne    c010989b <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c01098cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01098d0:	c9                   	leave  
c01098d1:	c3                   	ret    

c01098d2 <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c01098d2:	55                   	push   %ebp
c01098d3:	89 e5                	mov    %esp,%ebp
c01098d5:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c01098d8:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c01098df:	00 
c01098e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01098e7:	00 
c01098e8:	8d 45 ac             	lea    -0x54(%ebp),%eax
c01098eb:	89 04 24             	mov    %eax,(%esp)
c01098ee:	e8 39 22 00 00       	call   c010bb2c <memset>
    tf.tf_cs = KERNEL_CS;
c01098f3:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c01098f9:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c01098ff:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0109903:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0109907:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c010990b:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c010990f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109912:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0109915:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109918:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c010991b:	b8 13 91 10 c0       	mov    $0xc0109113,%eax
c0109920:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0109923:	8b 45 10             	mov    0x10(%ebp),%eax
c0109926:	80 cc 01             	or     $0x1,%ah
c0109929:	89 c2                	mov    %eax,%edx
c010992b:	8d 45 ac             	lea    -0x54(%ebp),%eax
c010992e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109932:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109939:	00 
c010993a:	89 14 24             	mov    %edx,(%esp)
c010993d:	e8 25 03 00 00       	call   c0109c67 <do_fork>
}
c0109942:	c9                   	leave  
c0109943:	c3                   	ret    

c0109944 <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0109944:	55                   	push   %ebp
c0109945:	89 e5                	mov    %esp,%ebp
c0109947:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c010994a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0109951:	e8 e4 b6 ff ff       	call   c010503a <alloc_pages>
c0109956:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0109959:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010995d:	74 1a                	je     c0109979 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c010995f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109962:	89 04 24             	mov    %eax,(%esp)
c0109965:	e8 1a f9 ff ff       	call   c0109284 <page2kva>
c010996a:	89 c2                	mov    %eax,%edx
c010996c:	8b 45 08             	mov    0x8(%ebp),%eax
c010996f:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0109972:	b8 00 00 00 00       	mov    $0x0,%eax
c0109977:	eb 05                	jmp    c010997e <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0109979:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c010997e:	c9                   	leave  
c010997f:	c3                   	ret    

c0109980 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0109980:	55                   	push   %ebp
c0109981:	89 e5                	mov    %esp,%ebp
c0109983:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0109986:	8b 45 08             	mov    0x8(%ebp),%eax
c0109989:	8b 40 0c             	mov    0xc(%eax),%eax
c010998c:	89 04 24             	mov    %eax,(%esp)
c010998f:	e8 44 f9 ff ff       	call   c01092d8 <kva2page>
c0109994:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010999b:	00 
c010999c:	89 04 24             	mov    %eax,(%esp)
c010999f:	e8 01 b7 ff ff       	call   c01050a5 <free_pages>
}
c01099a4:	c9                   	leave  
c01099a5:	c3                   	ret    

c01099a6 <setup_pgdir>:

// setup_pgdir - alloc one page as PDT
static int
setup_pgdir(struct mm_struct *mm) {
c01099a6:	55                   	push   %ebp
c01099a7:	89 e5                	mov    %esp,%ebp
c01099a9:	83 ec 28             	sub    $0x28,%esp
    struct Page *page;
    if ((page = alloc_page()) == NULL) {
c01099ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01099b3:	e8 82 b6 ff ff       	call   c010503a <alloc_pages>
c01099b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01099bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01099bf:	75 0a                	jne    c01099cb <setup_pgdir+0x25>
        return -E_NO_MEM;
c01099c1:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01099c6:	e9 80 00 00 00       	jmp    c0109a4b <setup_pgdir+0xa5>
    }
    pde_t *pgdir = page2kva(page);
c01099cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01099ce:	89 04 24             	mov    %eax,(%esp)
c01099d1:	e8 ae f8 ff ff       	call   c0109284 <page2kva>
c01099d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memcpy(pgdir, boot_pgdir, PGSIZE);
c01099d9:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01099de:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01099e5:	00 
c01099e6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01099ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01099ed:	89 04 24             	mov    %eax,(%esp)
c01099f0:	e8 19 22 00 00       	call   c010bc0e <memcpy>
    pgdir[PDX(VPT)] = PADDR(pgdir) | PTE_P | PTE_W;
c01099f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01099f8:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01099fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a01:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109a04:	81 7d ec ff ff ff bf 	cmpl   $0xbfffffff,-0x14(%ebp)
c0109a0b:	77 23                	ja     c0109a30 <setup_pgdir+0x8a>
c0109a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109a10:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109a14:	c7 44 24 08 90 dc 10 	movl   $0xc010dc90,0x8(%esp)
c0109a1b:	c0 
c0109a1c:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
c0109a23:	00 
c0109a24:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c0109a2b:	e8 a5 73 ff ff       	call   c0100dd5 <__panic>
c0109a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109a33:	05 00 00 00 40       	add    $0x40000000,%eax
c0109a38:	83 c8 03             	or     $0x3,%eax
c0109a3b:	89 02                	mov    %eax,(%edx)
    mm->pgdir = pgdir;
c0109a3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a40:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109a43:	89 50 0c             	mov    %edx,0xc(%eax)
    return 0;
c0109a46:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109a4b:	c9                   	leave  
c0109a4c:	c3                   	ret    

c0109a4d <put_pgdir>:

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm) {
c0109a4d:	55                   	push   %ebp
c0109a4e:	89 e5                	mov    %esp,%ebp
c0109a50:	83 ec 18             	sub    $0x18,%esp
    free_page(kva2page(mm->pgdir));
c0109a53:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a56:	8b 40 0c             	mov    0xc(%eax),%eax
c0109a59:	89 04 24             	mov    %eax,(%esp)
c0109a5c:	e8 77 f8 ff ff       	call   c01092d8 <kva2page>
c0109a61:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0109a68:	00 
c0109a69:	89 04 24             	mov    %eax,(%esp)
c0109a6c:	e8 34 b6 ff ff       	call   c01050a5 <free_pages>
}
c0109a71:	c9                   	leave  
c0109a72:	c3                   	ret    

c0109a73 <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0109a73:	55                   	push   %ebp
c0109a74:	89 e5                	mov    %esp,%ebp
c0109a76:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm, *oldmm = current->mm;
c0109a79:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109a7e:	8b 40 18             	mov    0x18(%eax),%eax
c0109a81:	89 45 ec             	mov    %eax,-0x14(%ebp)

    /* current is a kernel thread */
    if (oldmm == NULL) {
c0109a84:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0109a88:	75 0a                	jne    c0109a94 <copy_mm+0x21>
        return 0;
c0109a8a:	b8 00 00 00 00       	mov    $0x0,%eax
c0109a8f:	e9 f9 00 00 00       	jmp    c0109b8d <copy_mm+0x11a>
    }
    if (clone_flags & CLONE_VM) {
c0109a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a97:	25 00 01 00 00       	and    $0x100,%eax
c0109a9c:	85 c0                	test   %eax,%eax
c0109a9e:	74 08                	je     c0109aa8 <copy_mm+0x35>
        mm = oldmm;
c0109aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        goto good_mm;
c0109aa6:	eb 78                	jmp    c0109b20 <copy_mm+0xad>
    }

    int ret = -E_NO_MEM;
c0109aa8:	c7 45 f0 fc ff ff ff 	movl   $0xfffffffc,-0x10(%ebp)
    if ((mm = mm_create()) == NULL) {
c0109aaf:	e8 e3 e2 ff ff       	call   c0107d97 <mm_create>
c0109ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109ab7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109abb:	75 05                	jne    c0109ac2 <copy_mm+0x4f>
        goto bad_mm;
c0109abd:	e9 c8 00 00 00       	jmp    c0109b8a <copy_mm+0x117>
    }
    if (setup_pgdir(mm) != 0) {
c0109ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109ac5:	89 04 24             	mov    %eax,(%esp)
c0109ac8:	e8 d9 fe ff ff       	call   c01099a6 <setup_pgdir>
c0109acd:	85 c0                	test   %eax,%eax
c0109acf:	74 05                	je     c0109ad6 <copy_mm+0x63>
        goto bad_pgdir_cleanup_mm;
c0109ad1:	e9 a9 00 00 00       	jmp    c0109b7f <copy_mm+0x10c>
    }

    lock_mm(oldmm);
c0109ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ad9:	89 04 24             	mov    %eax,(%esp)
c0109adc:	e8 75 f8 ff ff       	call   c0109356 <lock_mm>
    {
        ret = dup_mmap(mm, oldmm);
c0109ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109aeb:	89 04 24             	mov    %eax,(%esp)
c0109aee:	e8 bb e7 ff ff       	call   c01082ae <dup_mmap>
c0109af3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    unlock_mm(oldmm);
c0109af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109af9:	89 04 24             	mov    %eax,(%esp)
c0109afc:	e8 71 f8 ff ff       	call   c0109372 <unlock_mm>

    if (ret != 0) {
c0109b01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109b05:	74 19                	je     c0109b20 <copy_mm+0xad>
        goto bad_dup_cleanup_mmap;
c0109b07:	90                   	nop
    mm_count_inc(mm);
    proc->mm = mm;
    proc->cr3 = PADDR(mm->pgdir);
    return 0;
bad_dup_cleanup_mmap:
    exit_mmap(mm);
c0109b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b0b:	89 04 24             	mov    %eax,(%esp)
c0109b0e:	e8 9c e8 ff ff       	call   c01083af <exit_mmap>
    put_pgdir(mm);
c0109b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b16:	89 04 24             	mov    %eax,(%esp)
c0109b19:	e8 2f ff ff ff       	call   c0109a4d <put_pgdir>
c0109b1e:	eb 5f                	jmp    c0109b7f <copy_mm+0x10c>
    if (ret != 0) {
        goto bad_dup_cleanup_mmap;
    }

good_mm:
    mm_count_inc(mm);
c0109b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b23:	89 04 24             	mov    %eax,(%esp)
c0109b26:	e8 f7 f7 ff ff       	call   c0109322 <mm_count_inc>
    proc->mm = mm;
c0109b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109b31:	89 50 18             	mov    %edx,0x18(%eax)
    proc->cr3 = PADDR(mm->pgdir);
c0109b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b37:	8b 40 0c             	mov    0xc(%eax),%eax
c0109b3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109b3d:	81 7d e8 ff ff ff bf 	cmpl   $0xbfffffff,-0x18(%ebp)
c0109b44:	77 23                	ja     c0109b69 <copy_mm+0xf6>
c0109b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b49:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109b4d:	c7 44 24 08 90 dc 10 	movl   $0xc010dc90,0x8(%esp)
c0109b54:	c0 
c0109b55:	c7 44 24 04 78 01 00 	movl   $0x178,0x4(%esp)
c0109b5c:	00 
c0109b5d:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c0109b64:	e8 6c 72 ff ff       	call   c0100dd5 <__panic>
c0109b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b6c:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0109b72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b75:	89 50 40             	mov    %edx,0x40(%eax)
    return 0;
c0109b78:	b8 00 00 00 00       	mov    $0x0,%eax
c0109b7d:	eb 0e                	jmp    c0109b8d <copy_mm+0x11a>
bad_dup_cleanup_mmap:
    exit_mmap(mm);
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c0109b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b82:	89 04 24             	mov    %eax,(%esp)
c0109b85:	e8 66 e5 ff ff       	call   c01080f0 <mm_destroy>
bad_mm:
    return ret;
c0109b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0109b8d:	c9                   	leave  
c0109b8e:	c3                   	ret    

c0109b8f <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0109b8f:	55                   	push   %ebp
c0109b90:	89 e5                	mov    %esp,%ebp
c0109b92:	57                   	push   %edi
c0109b93:	56                   	push   %esi
c0109b94:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0109b95:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b98:	8b 40 0c             	mov    0xc(%eax),%eax
c0109b9b:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0109ba0:	89 c2                	mov    %eax,%edx
c0109ba2:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ba5:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0109ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bab:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109bae:	8b 55 10             	mov    0x10(%ebp),%edx
c0109bb1:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0109bb6:	89 c1                	mov    %eax,%ecx
c0109bb8:	83 e1 01             	and    $0x1,%ecx
c0109bbb:	85 c9                	test   %ecx,%ecx
c0109bbd:	74 0e                	je     c0109bcd <copy_thread+0x3e>
c0109bbf:	0f b6 0a             	movzbl (%edx),%ecx
c0109bc2:	88 08                	mov    %cl,(%eax)
c0109bc4:	83 c0 01             	add    $0x1,%eax
c0109bc7:	83 c2 01             	add    $0x1,%edx
c0109bca:	83 eb 01             	sub    $0x1,%ebx
c0109bcd:	89 c1                	mov    %eax,%ecx
c0109bcf:	83 e1 02             	and    $0x2,%ecx
c0109bd2:	85 c9                	test   %ecx,%ecx
c0109bd4:	74 0f                	je     c0109be5 <copy_thread+0x56>
c0109bd6:	0f b7 0a             	movzwl (%edx),%ecx
c0109bd9:	66 89 08             	mov    %cx,(%eax)
c0109bdc:	83 c0 02             	add    $0x2,%eax
c0109bdf:	83 c2 02             	add    $0x2,%edx
c0109be2:	83 eb 02             	sub    $0x2,%ebx
c0109be5:	89 d9                	mov    %ebx,%ecx
c0109be7:	c1 e9 02             	shr    $0x2,%ecx
c0109bea:	89 c7                	mov    %eax,%edi
c0109bec:	89 d6                	mov    %edx,%esi
c0109bee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109bf0:	89 f2                	mov    %esi,%edx
c0109bf2:	89 f8                	mov    %edi,%eax
c0109bf4:	b9 00 00 00 00       	mov    $0x0,%ecx
c0109bf9:	89 de                	mov    %ebx,%esi
c0109bfb:	83 e6 02             	and    $0x2,%esi
c0109bfe:	85 f6                	test   %esi,%esi
c0109c00:	74 0b                	je     c0109c0d <copy_thread+0x7e>
c0109c02:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0109c06:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0109c0a:	83 c1 02             	add    $0x2,%ecx
c0109c0d:	83 e3 01             	and    $0x1,%ebx
c0109c10:	85 db                	test   %ebx,%ebx
c0109c12:	74 07                	je     c0109c1b <copy_thread+0x8c>
c0109c14:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0109c18:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0109c1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c1e:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109c21:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0109c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c2b:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109c31:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0109c34:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c37:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109c3a:	8b 55 08             	mov    0x8(%ebp),%edx
c0109c3d:	8b 52 3c             	mov    0x3c(%edx),%edx
c0109c40:	8b 52 40             	mov    0x40(%edx),%edx
c0109c43:	80 ce 02             	or     $0x2,%dh
c0109c46:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0109c49:	ba 99 97 10 c0       	mov    $0xc0109799,%edx
c0109c4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c51:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0109c54:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c57:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109c5a:	89 c2                	mov    %eax,%edx
c0109c5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c5f:	89 50 20             	mov    %edx,0x20(%eax)
}
c0109c62:	5b                   	pop    %ebx
c0109c63:	5e                   	pop    %esi
c0109c64:	5f                   	pop    %edi
c0109c65:	5d                   	pop    %ebp
c0109c66:	c3                   	ret    

c0109c67 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0109c67:	55                   	push   %ebp
c0109c68:	89 e5                	mov    %esp,%ebp
c0109c6a:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_NO_FREE_PROC;
c0109c6d:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0109c74:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c0109c79:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0109c7e:	7e 05                	jle    c0109c85 <do_fork+0x1e>
        goto fork_out;
c0109c80:	e9 d2 00 00 00       	jmp    c0109d57 <do_fork+0xf0>
    }
    ret = -E_NO_MEM;
c0109c85:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    /*
	 * 想干的事：创建当前内核线程的一个副本，它们的执行上下文、代码、数据都一样，但是存储位置不同，PID不同。
	 */
	// 调用alloc_proc() 为要创建的线程分配空间
	// 如果第一步 alloc 都失败的话，应该来说是比较严重的错误。直接退出。
	if ((proc = alloc_proc()) == NULL) {
c0109c8c:	e8 fd f6 ff ff       	call   c010938e <alloc_proc>
c0109c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109c98:	75 05                	jne    c0109c9f <do_fork+0x38>
		goto fork_out;
c0109c9a:	e9 b8 00 00 00       	jmp    c0109d57 <do_fork+0xf0>
	}


	proc->parent = current;
c0109c9f:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c0109ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109ca8:	89 50 14             	mov    %edx,0x14(%eax)
	assert(proc->wait_state == 0);
c0109cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109cae:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109cb1:	85 c0                	test   %eax,%eax
c0109cb3:	74 24                	je     c0109cd9 <do_fork+0x72>
c0109cb5:	c7 44 24 0c c8 dc 10 	movl   $0xc010dcc8,0xc(%esp)
c0109cbc:	c0 
c0109cbd:	c7 44 24 08 de dc 10 	movl   $0xc010dcde,0x8(%esp)
c0109cc4:	c0 
c0109cc5:	c7 44 24 04 cb 01 00 	movl   $0x1cb,0x4(%esp)
c0109ccc:	00 
c0109ccd:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c0109cd4:	e8 fc 70 ff ff       	call   c0100dd5 <__panic>

	// 获取被拷贝的进程的pid号 即父进程的pid
	//proc->parent = current;
	// 分配大小为 KSTACKPAGE 的页面作为进程内核堆栈
	setup_kstack(proc);
c0109cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109cdc:	89 04 24             	mov    %eax,(%esp)
c0109cdf:	e8 60 fc ff ff       	call   c0109944 <setup_kstack>
	// 为新进程创建新的虚存空间
	// 注意！copy还调用了copy_range函数。
	// copy_range函数：拷贝父进程的内存到新进程（LAB5 练习2）
	copy_mm(clone_flags, proc);
c0109ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109ce7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cee:	89 04 24             	mov    %eax,(%esp)
c0109cf1:	e8 7d fd ff ff       	call   c0109a73 <copy_mm>
	// 拷贝原进程上下文到新进程
	copy_thread(proc, stack, tf);
c0109cf6:	8b 45 10             	mov    0x10(%ebp),%eax
c0109cf9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d07:	89 04 24             	mov    %eax,(%esp)
c0109d0a:	e8 80 fe ff ff       	call   c0109b8f <copy_thread>


	bool intr_flag;
	// 停止中断
	local_intr_save(intr_flag);
c0109d0f:	e8 48 f4 ff ff       	call   c010915c <__intr_save>
c0109d14:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// {} 用来限定花括号中变量的作用域，使其不影响外面。
	{
		proc->pid = get_pid();
c0109d17:	e8 10 f9 ff ff       	call   c010962c <get_pid>
c0109d1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109d1f:	89 42 04             	mov    %eax,0x4(%edx)
		// 新进程添加到 hash方式组织的的进程链表，以便于以后对某个指定的线程的查找（速度更快）
		hash_proc(proc);
c0109d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d25:	89 04 24             	mov    %eax,(%esp)
c0109d28:	e8 84 fa ff ff       	call   c01097b1 <hash_proc>
		// 将线程加入到所有线程的链表中，以便于调度
		//list_add(&proc_list, &(proc->list_link));
		// 将全局线程的数目加1
		//nr_process ++;
		set_links(proc);
c0109d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d30:	89 04 24             	mov    %eax,(%esp)
c0109d33:	e8 cc f7 ff ff       	call   c0109504 <set_links>
	}
	// 允许中断
	local_intr_restore(intr_flag);
c0109d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d3b:	89 04 24             	mov    %eax,(%esp)
c0109d3e:	e8 43 f4 ff ff       	call   c0109186 <__intr_restore>


	// 唤醒新进程
	wakeup_proc(proc);
c0109d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d46:	89 04 24             	mov    %eax,(%esp)
c0109d49:	e8 ef 0f 00 00       	call   c010ad3d <wakeup_proc>
	// 新进程号
	ret = proc->pid;
c0109d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d51:	8b 40 04             	mov    0x4(%eax),%eax
c0109d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
fork_out:
    return ret;
c0109d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
c0109d5a:	c9                   	leave  
c0109d5b:	c3                   	ret    

c0109d5c <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0109d5c:	55                   	push   %ebp
c0109d5d:	89 e5                	mov    %esp,%ebp
c0109d5f:	83 ec 28             	sub    $0x28,%esp
    if (current == idleproc) {
c0109d62:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c0109d68:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c0109d6d:	39 c2                	cmp    %eax,%edx
c0109d6f:	75 1c                	jne    c0109d8d <do_exit+0x31>
        panic("idleproc exit.\n");
c0109d71:	c7 44 24 08 f3 dc 10 	movl   $0xc010dcf3,0x8(%esp)
c0109d78:	c0 
c0109d79:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0109d80:	00 
c0109d81:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c0109d88:	e8 48 70 ff ff       	call   c0100dd5 <__panic>
    }
    if (current == initproc) {
c0109d8d:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c0109d93:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109d98:	39 c2                	cmp    %eax,%edx
c0109d9a:	75 1c                	jne    c0109db8 <do_exit+0x5c>
        panic("initproc exit.\n");
c0109d9c:	c7 44 24 08 03 dd 10 	movl   $0xc010dd03,0x8(%esp)
c0109da3:	c0 
c0109da4:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0109dab:	00 
c0109dac:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c0109db3:	e8 1d 70 ff ff       	call   c0100dd5 <__panic>
    }
    
    struct mm_struct *mm = current->mm;
c0109db8:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109dbd:	8b 40 18             	mov    0x18(%eax),%eax
c0109dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (mm != NULL) {
c0109dc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109dc7:	74 4a                	je     c0109e13 <do_exit+0xb7>
        lcr3(boot_cr3);
c0109dc9:	a1 c8 ef 19 c0       	mov    0xc019efc8,%eax
c0109dce:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109dd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109dd4:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c0109dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109dda:	89 04 24             	mov    %eax,(%esp)
c0109ddd:	e8 5a f5 ff ff       	call   c010933c <mm_count_dec>
c0109de2:	85 c0                	test   %eax,%eax
c0109de4:	75 21                	jne    c0109e07 <do_exit+0xab>
            exit_mmap(mm);
c0109de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109de9:	89 04 24             	mov    %eax,(%esp)
c0109dec:	e8 be e5 ff ff       	call   c01083af <exit_mmap>
            put_pgdir(mm);
c0109df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109df4:	89 04 24             	mov    %eax,(%esp)
c0109df7:	e8 51 fc ff ff       	call   c0109a4d <put_pgdir>
            mm_destroy(mm);
c0109dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109dff:	89 04 24             	mov    %eax,(%esp)
c0109e02:	e8 e9 e2 ff ff       	call   c01080f0 <mm_destroy>
        }
        current->mm = NULL;
c0109e07:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109e0c:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    current->state = PROC_ZOMBIE;
c0109e13:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109e18:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    current->exit_code = error_code;
c0109e1e:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109e23:	8b 55 08             	mov    0x8(%ebp),%edx
c0109e26:	89 50 68             	mov    %edx,0x68(%eax)
    
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
c0109e29:	e8 2e f3 ff ff       	call   c010915c <__intr_save>
c0109e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        proc = current->parent;
c0109e31:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109e36:	8b 40 14             	mov    0x14(%eax),%eax
c0109e39:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (proc->wait_state == WT_CHILD) {
c0109e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e3f:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109e42:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c0109e47:	75 10                	jne    c0109e59 <do_exit+0xfd>
            wakeup_proc(proc);
c0109e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e4c:	89 04 24             	mov    %eax,(%esp)
c0109e4f:	e8 e9 0e 00 00       	call   c010ad3d <wakeup_proc>
        }
        while (current->cptr != NULL) {
c0109e54:	e9 8b 00 00 00       	jmp    c0109ee4 <do_exit+0x188>
c0109e59:	e9 86 00 00 00       	jmp    c0109ee4 <do_exit+0x188>
            proc = current->cptr;
c0109e5e:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109e63:	8b 40 70             	mov    0x70(%eax),%eax
c0109e66:	89 45 ec             	mov    %eax,-0x14(%ebp)
            current->cptr = proc->optr;
c0109e69:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109e6e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109e71:	8b 52 78             	mov    0x78(%edx),%edx
c0109e74:	89 50 70             	mov    %edx,0x70(%eax)
    
            proc->yptr = NULL;
c0109e77:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e7a:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
            if ((proc->optr = initproc->cptr) != NULL) {
c0109e81:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109e86:	8b 50 70             	mov    0x70(%eax),%edx
c0109e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e8c:	89 50 78             	mov    %edx,0x78(%eax)
c0109e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e92:	8b 40 78             	mov    0x78(%eax),%eax
c0109e95:	85 c0                	test   %eax,%eax
c0109e97:	74 0e                	je     c0109ea7 <do_exit+0x14b>
                initproc->cptr->yptr = proc;
c0109e99:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109e9e:	8b 40 70             	mov    0x70(%eax),%eax
c0109ea1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109ea4:	89 50 74             	mov    %edx,0x74(%eax)
            }
            proc->parent = initproc;
c0109ea7:	8b 15 84 cf 19 c0    	mov    0xc019cf84,%edx
c0109ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109eb0:	89 50 14             	mov    %edx,0x14(%eax)
            initproc->cptr = proc;
c0109eb3:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109eb8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109ebb:	89 50 70             	mov    %edx,0x70(%eax)
            if (proc->state == PROC_ZOMBIE) {
c0109ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ec1:	8b 00                	mov    (%eax),%eax
c0109ec3:	83 f8 03             	cmp    $0x3,%eax
c0109ec6:	75 1c                	jne    c0109ee4 <do_exit+0x188>
                if (initproc->wait_state == WT_CHILD) {
c0109ec8:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109ecd:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109ed0:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c0109ed5:	75 0d                	jne    c0109ee4 <do_exit+0x188>
                    wakeup_proc(initproc);
c0109ed7:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109edc:	89 04 24             	mov    %eax,(%esp)
c0109edf:	e8 59 0e 00 00       	call   c010ad3d <wakeup_proc>
    {
        proc = current->parent;
        if (proc->wait_state == WT_CHILD) {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL) {
c0109ee4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109ee9:	8b 40 70             	mov    0x70(%eax),%eax
c0109eec:	85 c0                	test   %eax,%eax
c0109eee:	0f 85 6a ff ff ff    	jne    c0109e5e <do_exit+0x102>
                    wakeup_proc(initproc);
                }
            }
        }
    }
    local_intr_restore(intr_flag);
c0109ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109ef7:	89 04 24             	mov    %eax,(%esp)
c0109efa:	e8 87 f2 ff ff       	call   c0109186 <__intr_restore>
    
    schedule();
c0109eff:	e8 bd 0e 00 00       	call   c010adc1 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
c0109f04:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109f09:	8b 40 04             	mov    0x4(%eax),%eax
c0109f0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109f10:	c7 44 24 08 14 dd 10 	movl   $0xc010dd14,0x8(%esp)
c0109f17:	c0 
c0109f18:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0109f1f:	00 
c0109f20:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c0109f27:	e8 a9 6e ff ff       	call   c0100dd5 <__panic>

c0109f2c <load_icode>:
/* load_icode - load the content of binary program(ELF format) as the new content of current process
 * @binary:  the memory addr of the content of binary program
 * @size:  the size of the content of binary program
 */
static int
load_icode(unsigned char *binary, size_t size) {
c0109f2c:	55                   	push   %ebp
c0109f2d:	89 e5                	mov    %esp,%ebp
c0109f2f:	83 ec 78             	sub    $0x78,%esp
    // 检查寄居蟹本身有没有肉，没肉才正常。后面可以分配新的内存结构体，新的页表等。
	if (current->mm != NULL) {
c0109f32:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109f37:	8b 40 18             	mov    0x18(%eax),%eax
c0109f3a:	85 c0                	test   %eax,%eax
c0109f3c:	74 1c                	je     c0109f5a <load_icode+0x2e>
    	// 如果当前进程的内存不为空，debug的时候会将其打印输出
        panic("load_icode: current->mm must be empty.\n");
c0109f3e:	c7 44 24 08 34 dd 10 	movl   $0xc010dd34,0x8(%esp)
c0109f45:	c0 
c0109f46:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0109f4d:	00 
c0109f4e:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c0109f55:	e8 7b 6e ff ff       	call   c0100dd5 <__panic>
    }

    int ret = -E_NO_MEM;
c0109f5a:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    struct mm_struct *mm;
    //(1) 为当前进程建立新的内存管理结构体
    if ((mm = mm_create()) == NULL) {
c0109f61:	e8 31 de ff ff       	call   c0107d97 <mm_create>
c0109f66:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109f69:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0109f6d:	75 06                	jne    c0109f75 <load_icode+0x49>
        goto bad_mm;
c0109f6f:	90                   	nop
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    goto out;
c0109f70:	e9 ef 05 00 00       	jmp    c010a564 <load_icode+0x638>
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT；
    // 创建新的页表
    if (setup_pgdir(mm) != 0) {
c0109f75:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109f78:	89 04 24             	mov    %eax,(%esp)
c0109f7b:	e8 26 fa ff ff       	call   c01099a6 <setup_pgdir>
c0109f80:	85 c0                	test   %eax,%eax
c0109f82:	74 05                	je     c0109f89 <load_icode+0x5d>
        goto bad_pgdir_cleanup_mm;
c0109f84:	e9 f6 05 00 00       	jmp    c010a57f <load_icode+0x653>
    }
    //(3) copy TEXT/DATA section, build BSS parts in binary to memory space of process
    // 通过解析elf格式的文件得到代码段，数据段等格式在哪。
    struct Page *page;
    //(3.1) get the file header of the bianry program (ELF format)
    struct elfhdr *elf = (struct elfhdr *)binary;
c0109f89:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f8c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    //(3.2) get the entry of the program section headers of the bianry program (ELF format)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
c0109f8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0109f92:	8b 50 1c             	mov    0x1c(%eax),%edx
c0109f95:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f98:	01 d0                	add    %edx,%eax
c0109f9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //(3.3) This program is valid?
    if (elf->e_magic != ELF_MAGIC) {
c0109f9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0109fa0:	8b 00                	mov    (%eax),%eax
c0109fa2:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0109fa7:	74 0c                	je     c0109fb5 <load_icode+0x89>
        ret = -E_INVAL_ELF;
c0109fa9:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
        goto bad_elf_cleanup_pgdir;
c0109fb0:	e9 bf 05 00 00       	jmp    c010a574 <load_icode+0x648>
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
c0109fb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0109fb8:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0109fbc:	0f b7 c0             	movzwl %ax,%eax
c0109fbf:	c1 e0 05             	shl    $0x5,%eax
c0109fc2:	89 c2                	mov    %eax,%edx
c0109fc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109fc7:	01 d0                	add    %edx,%eax
c0109fc9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; ph < ph_end; ph ++) {
c0109fcc:	e9 13 03 00 00       	jmp    c010a2e4 <load_icode+0x3b8>
    //(3.4) find every program section headers
        if (ph->p_type != ELF_PT_LOAD) {
c0109fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109fd4:	8b 00                	mov    (%eax),%eax
c0109fd6:	83 f8 01             	cmp    $0x1,%eax
c0109fd9:	74 05                	je     c0109fe0 <load_icode+0xb4>
            continue ;
c0109fdb:	e9 00 03 00 00       	jmp    c010a2e0 <load_icode+0x3b4>
        }
        if (ph->p_filesz > ph->p_memsz) {
c0109fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109fe3:	8b 50 10             	mov    0x10(%eax),%edx
c0109fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109fe9:	8b 40 14             	mov    0x14(%eax),%eax
c0109fec:	39 c2                	cmp    %eax,%edx
c0109fee:	76 0c                	jbe    c0109ffc <load_icode+0xd0>
            ret = -E_INVAL_ELF;
c0109ff0:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
            goto bad_cleanup_mmap;
c0109ff7:	e9 6d 05 00 00       	jmp    c010a569 <load_icode+0x63d>
        }
        if (ph->p_filesz == 0) {
c0109ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109fff:	8b 40 10             	mov    0x10(%eax),%eax
c010a002:	85 c0                	test   %eax,%eax
c010a004:	75 05                	jne    c010a00b <load_icode+0xdf>
            continue ;
c010a006:	e9 d5 02 00 00       	jmp    c010a2e0 <load_icode+0x3b4>
        }
    //(3.5) call mm_map fun to setup the new vma ( ph->p_va, ph->p_memsz)
    // 建立VMA
        vm_flags = 0, perm = PTE_U;
c010a00b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010a012:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;			// 如果是代码段，拥有可执行属性
c010a019:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a01c:	8b 40 18             	mov    0x18(%eax),%eax
c010a01f:	83 e0 01             	and    $0x1,%eax
c010a022:	85 c0                	test   %eax,%eax
c010a024:	74 04                	je     c010a02a <load_icode+0xfe>
c010a026:	83 4d e8 04          	orl    $0x4,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;			// 如果是数据段，拥有可写属性
c010a02a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a02d:	8b 40 18             	mov    0x18(%eax),%eax
c010a030:	83 e0 02             	and    $0x2,%eax
c010a033:	85 c0                	test   %eax,%eax
c010a035:	74 04                	je     c010a03b <load_icode+0x10f>
c010a037:	83 4d e8 02          	orl    $0x2,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;			// 如果是数据段，拥有可读属性
c010a03b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a03e:	8b 40 18             	mov    0x18(%eax),%eax
c010a041:	83 e0 04             	and    $0x4,%eax
c010a044:	85 c0                	test   %eax,%eax
c010a046:	74 04                	je     c010a04c <load_icode+0x120>
c010a048:	83 4d e8 01          	orl    $0x1,-0x18(%ebp)
        if (vm_flags & VM_WRITE) perm |= PTE_W;
c010a04c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a04f:	83 e0 02             	and    $0x2,%eax
c010a052:	85 c0                	test   %eax,%eax
c010a054:	74 04                	je     c010a05a <load_icode+0x12e>
c010a056:	83 4d e4 02          	orl    $0x2,-0x1c(%ebp)
        // 通过 mm_map 函数完成对合法空间的建立，但还没有建立页表。
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
c010a05a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a05d:	8b 50 14             	mov    0x14(%eax),%edx
c010a060:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a063:	8b 40 08             	mov    0x8(%eax),%eax
c010a066:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c010a06d:	00 
c010a06e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010a071:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010a075:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a079:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a07d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a080:	89 04 24             	mov    %eax,(%esp)
c010a083:	e8 0a e1 ff ff       	call   c0108192 <mm_map>
c010a088:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a08b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a08f:	74 05                	je     c010a096 <load_icode+0x16a>
            goto bad_cleanup_mmap;
c010a091:	e9 d3 04 00 00       	jmp    c010a569 <load_icode+0x63d>
        }
        unsigned char *from = binary + ph->p_offset;
c010a096:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a099:	8b 50 04             	mov    0x4(%eax),%edx
c010a09c:	8b 45 08             	mov    0x8(%ebp),%eax
c010a09f:	01 d0                	add    %edx,%eax
c010a0a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
c010a0a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0a7:	8b 40 08             	mov    0x8(%eax),%eax
c010a0aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010a0ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a0b0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010a0b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010a0b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010a0bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

        ret = -E_NO_MEM;
c010a0be:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
c010a0c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0c8:	8b 50 08             	mov    0x8(%eax),%edx
c010a0cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0ce:	8b 40 10             	mov    0x10(%eax),%eax
c010a0d1:	01 d0                	add    %edx,%eax
c010a0d3:	89 45 c0             	mov    %eax,-0x40(%ebp)
     //(3.6.1) copy TEXT/DATA section of bianry program
     // 拷贝，建立虚地址和物理地址的映射关系
        while (start < end) {
c010a0d6:	e9 90 00 00 00       	jmp    c010a16b <load_icode+0x23f>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c010a0db:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a0de:	8b 40 0c             	mov    0xc(%eax),%eax
c010a0e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010a0e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a0e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010a0eb:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a0ef:	89 04 24             	mov    %eax,(%esp)
c010a0f2:	e8 1b be ff ff       	call   c0105f12 <pgdir_alloc_page>
c010a0f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a0fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a0fe:	75 05                	jne    c010a105 <load_icode+0x1d9>
                goto bad_cleanup_mmap;
c010a100:	e9 64 04 00 00       	jmp    c010a569 <load_icode+0x63d>
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c010a105:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a108:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a10b:	29 c2                	sub    %eax,%edx
c010a10d:	89 d0                	mov    %edx,%eax
c010a10f:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a112:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a117:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a11a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010a11d:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c010a124:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a127:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a12a:	73 0d                	jae    c010a139 <load_icode+0x20d>
                size -= la - end;
c010a12c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a12f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a132:	29 c2                	sub    %eax,%edx
c010a134:	89 d0                	mov    %edx,%eax
c010a136:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memcpy(page2kva(page) + off, from, size);
c010a139:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a13c:	89 04 24             	mov    %eax,(%esp)
c010a13f:	e8 40 f1 ff ff       	call   c0109284 <page2kva>
c010a144:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a147:	01 c2                	add    %eax,%edx
c010a149:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a14c:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a150:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010a153:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a157:	89 14 24             	mov    %edx,(%esp)
c010a15a:	e8 af 1a 00 00       	call   c010bc0e <memcpy>
            start += size, from += size;
c010a15f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a162:	01 45 d8             	add    %eax,-0x28(%ebp)
c010a165:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a168:	01 45 e0             	add    %eax,-0x20(%ebp)

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
     //(3.6.1) copy TEXT/DATA section of bianry program
     // 拷贝，建立虚地址和物理地址的映射关系
        while (start < end) {
c010a16b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a16e:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a171:	0f 82 64 ff ff ff    	jb     c010a0db <load_icode+0x1af>
            memcpy(page2kva(page) + off, from, size);
            start += size, from += size;
        }

      //(3.6.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
c010a177:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a17a:	8b 50 08             	mov    0x8(%eax),%edx
c010a17d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a180:	8b 40 14             	mov    0x14(%eax),%eax
c010a183:	01 d0                	add    %edx,%eax
c010a185:	89 45 c0             	mov    %eax,-0x40(%ebp)
        if (start < la) {
c010a188:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a18b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a18e:	0f 83 b0 00 00 00    	jae    c010a244 <load_icode+0x318>
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
c010a194:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a197:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a19a:	75 05                	jne    c010a1a1 <load_icode+0x275>
                continue ;
c010a19c:	e9 3f 01 00 00       	jmp    c010a2e0 <load_icode+0x3b4>
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
c010a1a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a1a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a1a7:	29 c2                	sub    %eax,%edx
c010a1a9:	89 d0                	mov    %edx,%eax
c010a1ab:	05 00 10 00 00       	add    $0x1000,%eax
c010a1b0:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a1b3:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a1b8:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a1bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
            if (end < la) {
c010a1be:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a1c1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a1c4:	73 0d                	jae    c010a1d3 <load_icode+0x2a7>
                size -= la - end;
c010a1c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a1c9:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a1cc:	29 c2                	sub    %eax,%edx
c010a1ce:	89 d0                	mov    %edx,%eax
c010a1d0:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c010a1d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a1d6:	89 04 24             	mov    %eax,(%esp)
c010a1d9:	e8 a6 f0 ff ff       	call   c0109284 <page2kva>
c010a1de:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a1e1:	01 c2                	add    %eax,%edx
c010a1e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a1e6:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a1ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a1f1:	00 
c010a1f2:	89 14 24             	mov    %edx,(%esp)
c010a1f5:	e8 32 19 00 00       	call   c010bb2c <memset>
            start += size;
c010a1fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a1fd:	01 45 d8             	add    %eax,-0x28(%ebp)
            assert((end < la && start == end) || (end >= la && start == la));
c010a200:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a203:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a206:	73 08                	jae    c010a210 <load_icode+0x2e4>
c010a208:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a20b:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a20e:	74 34                	je     c010a244 <load_icode+0x318>
c010a210:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a216:	72 08                	jb     c010a220 <load_icode+0x2f4>
c010a218:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a21b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a21e:	74 24                	je     c010a244 <load_icode+0x318>
c010a220:	c7 44 24 0c 5c dd 10 	movl   $0xc010dd5c,0xc(%esp)
c010a227:	c0 
c010a228:	c7 44 24 08 de dc 10 	movl   $0xc010dcde,0x8(%esp)
c010a22f:	c0 
c010a230:	c7 44 24 04 93 02 00 	movl   $0x293,0x4(%esp)
c010a237:	00 
c010a238:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010a23f:	e8 91 6b ff ff       	call   c0100dd5 <__panic>
        }
        while (start < end) {
c010a244:	e9 8b 00 00 00       	jmp    c010a2d4 <load_icode+0x3a8>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c010a249:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a24c:	8b 40 0c             	mov    0xc(%eax),%eax
c010a24f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010a252:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a256:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010a259:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a25d:	89 04 24             	mov    %eax,(%esp)
c010a260:	e8 ad bc ff ff       	call   c0105f12 <pgdir_alloc_page>
c010a265:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a268:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a26c:	75 05                	jne    c010a273 <load_icode+0x347>
                goto bad_cleanup_mmap;
c010a26e:	e9 f6 02 00 00       	jmp    c010a569 <load_icode+0x63d>
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c010a273:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a276:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a279:	29 c2                	sub    %eax,%edx
c010a27b:	89 d0                	mov    %edx,%eax
c010a27d:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a280:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a285:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a288:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010a28b:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c010a292:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a295:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a298:	73 0d                	jae    c010a2a7 <load_icode+0x37b>
                size -= la - end;
c010a29a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a29d:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a2a0:	29 c2                	sub    %eax,%edx
c010a2a2:	89 d0                	mov    %edx,%eax
c010a2a4:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c010a2a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a2aa:	89 04 24             	mov    %eax,(%esp)
c010a2ad:	e8 d2 ef ff ff       	call   c0109284 <page2kva>
c010a2b2:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a2b5:	01 c2                	add    %eax,%edx
c010a2b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a2ba:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a2be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a2c5:	00 
c010a2c6:	89 14 24             	mov    %edx,(%esp)
c010a2c9:	e8 5e 18 00 00       	call   c010bb2c <memset>
            start += size;
c010a2ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a2d1:	01 45 d8             	add    %eax,-0x28(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end) {
c010a2d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a2d7:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a2da:	0f 82 69 ff ff ff    	jb     c010a249 <load_icode+0x31d>
        goto bad_elf_cleanup_pgdir;
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
    for (; ph < ph_end; ph ++) {
c010a2e0:	83 45 ec 20          	addl   $0x20,-0x14(%ebp)
c010a2e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a2e7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010a2ea:	0f 82 e1 fc ff ff    	jb     c0109fd1 <load_icode+0xa5>
            start += size;
        }
    }
    //(4) build user stack memory
    // 建立用户栈
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
c010a2f0:	c7 45 e8 0b 00 00 00 	movl   $0xb,-0x18(%ebp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
c010a2f7:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c010a2fe:	00 
c010a2ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a302:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a306:	c7 44 24 08 00 00 10 	movl   $0x100000,0x8(%esp)
c010a30d:	00 
c010a30e:	c7 44 24 04 00 00 f0 	movl   $0xaff00000,0x4(%esp)
c010a315:	af 
c010a316:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a319:	89 04 24             	mov    %eax,(%esp)
c010a31c:	e8 71 de ff ff       	call   c0108192 <mm_map>
c010a321:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a328:	74 05                	je     c010a32f <load_icode+0x403>
        goto bad_cleanup_mmap;
c010a32a:	e9 3a 02 00 00       	jmp    c010a569 <load_icode+0x63d>
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
c010a32f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a332:	8b 40 0c             	mov    0xc(%eax),%eax
c010a335:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a33c:	00 
c010a33d:	c7 44 24 04 00 f0 ff 	movl   $0xaffff000,0x4(%esp)
c010a344:	af 
c010a345:	89 04 24             	mov    %eax,(%esp)
c010a348:	e8 c5 bb ff ff       	call   c0105f12 <pgdir_alloc_page>
c010a34d:	85 c0                	test   %eax,%eax
c010a34f:	75 24                	jne    c010a375 <load_icode+0x449>
c010a351:	c7 44 24 0c 98 dd 10 	movl   $0xc010dd98,0xc(%esp)
c010a358:	c0 
c010a359:	c7 44 24 08 de dc 10 	movl   $0xc010dcde,0x8(%esp)
c010a360:	c0 
c010a361:	c7 44 24 04 a7 02 00 	movl   $0x2a7,0x4(%esp)
c010a368:	00 
c010a369:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010a370:	e8 60 6a ff ff       	call   c0100dd5 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
c010a375:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a378:	8b 40 0c             	mov    0xc(%eax),%eax
c010a37b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a382:	00 
c010a383:	c7 44 24 04 00 e0 ff 	movl   $0xafffe000,0x4(%esp)
c010a38a:	af 
c010a38b:	89 04 24             	mov    %eax,(%esp)
c010a38e:	e8 7f bb ff ff       	call   c0105f12 <pgdir_alloc_page>
c010a393:	85 c0                	test   %eax,%eax
c010a395:	75 24                	jne    c010a3bb <load_icode+0x48f>
c010a397:	c7 44 24 0c dc dd 10 	movl   $0xc010dddc,0xc(%esp)
c010a39e:	c0 
c010a39f:	c7 44 24 08 de dc 10 	movl   $0xc010dcde,0x8(%esp)
c010a3a6:	c0 
c010a3a7:	c7 44 24 04 a8 02 00 	movl   $0x2a8,0x4(%esp)
c010a3ae:	00 
c010a3af:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010a3b6:	e8 1a 6a ff ff       	call   c0100dd5 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
c010a3bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a3be:	8b 40 0c             	mov    0xc(%eax),%eax
c010a3c1:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a3c8:	00 
c010a3c9:	c7 44 24 04 00 d0 ff 	movl   $0xafffd000,0x4(%esp)
c010a3d0:	af 
c010a3d1:	89 04 24             	mov    %eax,(%esp)
c010a3d4:	e8 39 bb ff ff       	call   c0105f12 <pgdir_alloc_page>
c010a3d9:	85 c0                	test   %eax,%eax
c010a3db:	75 24                	jne    c010a401 <load_icode+0x4d5>
c010a3dd:	c7 44 24 0c 20 de 10 	movl   $0xc010de20,0xc(%esp)
c010a3e4:	c0 
c010a3e5:	c7 44 24 08 de dc 10 	movl   $0xc010dcde,0x8(%esp)
c010a3ec:	c0 
c010a3ed:	c7 44 24 04 a9 02 00 	movl   $0x2a9,0x4(%esp)
c010a3f4:	00 
c010a3f5:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010a3fc:	e8 d4 69 ff ff       	call   c0100dd5 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
c010a401:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a404:	8b 40 0c             	mov    0xc(%eax),%eax
c010a407:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a40e:	00 
c010a40f:	c7 44 24 04 00 c0 ff 	movl   $0xafffc000,0x4(%esp)
c010a416:	af 
c010a417:	89 04 24             	mov    %eax,(%esp)
c010a41a:	e8 f3 ba ff ff       	call   c0105f12 <pgdir_alloc_page>
c010a41f:	85 c0                	test   %eax,%eax
c010a421:	75 24                	jne    c010a447 <load_icode+0x51b>
c010a423:	c7 44 24 0c 64 de 10 	movl   $0xc010de64,0xc(%esp)
c010a42a:	c0 
c010a42b:	c7 44 24 08 de dc 10 	movl   $0xc010dcde,0x8(%esp)
c010a432:	c0 
c010a433:	c7 44 24 04 aa 02 00 	movl   $0x2aa,0x4(%esp)
c010a43a:	00 
c010a43b:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010a442:	e8 8e 69 ff ff       	call   c0100dd5 <__panic>
    
    //(5) set current process's mm, sr3, and set CR3 reg = physical addr of Page Directory
    mm_count_inc(mm);
c010a447:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a44a:	89 04 24             	mov    %eax,(%esp)
c010a44d:	e8 d0 ee ff ff       	call   c0109322 <mm_count_inc>
    current->mm = mm;
c010a452:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a457:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a45a:	89 50 18             	mov    %edx,0x18(%eax)
    current->cr3 = PADDR(mm->pgdir);
c010a45d:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a462:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a465:	8b 52 0c             	mov    0xc(%edx),%edx
c010a468:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010a46b:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c010a472:	77 23                	ja     c010a497 <load_icode+0x56b>
c010a474:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010a477:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a47b:	c7 44 24 08 90 dc 10 	movl   $0xc010dc90,0x8(%esp)
c010a482:	c0 
c010a483:	c7 44 24 04 af 02 00 	movl   $0x2af,0x4(%esp)
c010a48a:	00 
c010a48b:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010a492:	e8 3e 69 ff ff       	call   c0100dd5 <__panic>
c010a497:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010a49a:	81 c2 00 00 00 40    	add    $0x40000000,%edx
c010a4a0:	89 50 40             	mov    %edx,0x40(%eax)
    lcr3(PADDR(mm->pgdir));
c010a4a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a4a6:	8b 40 0c             	mov    0xc(%eax),%eax
c010a4a9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010a4ac:	81 7d b4 ff ff ff bf 	cmpl   $0xbfffffff,-0x4c(%ebp)
c010a4b3:	77 23                	ja     c010a4d8 <load_icode+0x5ac>
c010a4b5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a4b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a4bc:	c7 44 24 08 90 dc 10 	movl   $0xc010dc90,0x8(%esp)
c010a4c3:	c0 
c010a4c4:	c7 44 24 04 b0 02 00 	movl   $0x2b0,0x4(%esp)
c010a4cb:	00 
c010a4cc:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010a4d3:	e8 fd 68 ff ff       	call   c0100dd5 <__panic>
c010a4d8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a4db:	05 00 00 00 40       	add    $0x40000000,%eax
c010a4e0:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010a4e3:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010a4e6:	0f 22 d8             	mov    %eax,%cr3

    //(6) setup trapframe for user environment
    // 这里是很大的一部分，涉及到特权级转换。同时也时lab1 challenge部分内容。
    // 我们知道特权级转换是通过中断完成的。
    struct trapframe *tf = current->tf;
c010a4e9:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a4ee:	8b 40 3c             	mov    0x3c(%eax),%eax
c010a4f1:	89 45 b0             	mov    %eax,-0x50(%ebp)
    memset(tf, 0, sizeof(struct trapframe));
c010a4f4:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c010a4fb:	00 
c010a4fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a503:	00 
c010a504:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a507:	89 04 24             	mov    %eax,(%esp)
c010a50a:	e8 1d 16 00 00       	call   c010bb2c <memset>
     *          tf_ds=tf_es=tf_ss should be USER_DS segment
     *          tf_esp should be the top addr of user stack (USTACKTOP)
     *          tf_eip should be the entry point of this binary program (elf->e_entry)
     *          tf_eflags should be set to enable computer to produce Interrupt
     */
    tf->tf_cs = USER_CS;
c010a50f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a512:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c010a518:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a51b:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c010a521:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a524:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c010a528:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a52b:	66 89 50 28          	mov    %dx,0x28(%eax)
c010a52f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a532:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010a536:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a539:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    tf->tf_esp = USTACKTOP;
c010a53d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a540:	c7 40 44 00 00 00 b0 	movl   $0xb0000000,0x44(%eax)
    tf->tf_eip = elf->e_entry;			// 中断返回现场。可以执行elf文件的开始部分。即第6部分的作用就是伪造中断返回现场。
c010a547:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a54a:	8b 50 18             	mov    0x18(%eax),%edx
c010a54d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a550:	89 50 38             	mov    %edx,0x38(%eax)
    tf->tf_eflags = FL_IF;				// 允许中断
c010a553:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a556:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)


    ret = 0;
c010a55d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
out:
    return ret;
c010a564:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a567:	eb 23                	jmp    c010a58c <load_icode+0x660>
bad_cleanup_mmap:
    exit_mmap(mm);
c010a569:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a56c:	89 04 24             	mov    %eax,(%esp)
c010a56f:	e8 3b de ff ff       	call   c01083af <exit_mmap>
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
c010a574:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a577:	89 04 24             	mov    %eax,(%esp)
c010a57a:	e8 ce f4 ff ff       	call   c0109a4d <put_pgdir>
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c010a57f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a582:	89 04 24             	mov    %eax,(%esp)
c010a585:	e8 66 db ff ff       	call   c01080f0 <mm_destroy>
bad_mm:
    goto out;
c010a58a:	eb d8                	jmp    c010a564 <load_icode+0x638>
}
c010a58c:	c9                   	leave  
c010a58d:	c3                   	ret    

c010a58e <do_execve>:

// do_execve - call exit_mmap(mm)&pug_pgdir(mm) to reclaim memory space of current process
//           - call load_icode to setup new memory space accroding binary prog.
int
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
c010a58e:	55                   	push   %ebp
c010a58f:	89 e5                	mov    %esp,%ebp
c010a591:	83 ec 38             	sub    $0x38,%esp
	// 本函数所干的事跟寄居蟹差不多

    struct mm_struct *mm = current->mm;
c010a594:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a599:	8b 40 18             	mov    0x18(%eax),%eax
c010a59c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
c010a59f:	8b 45 08             	mov    0x8(%ebp),%eax
c010a5a2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010a5a9:	00 
c010a5aa:	8b 55 0c             	mov    0xc(%ebp),%edx
c010a5ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a5b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a5b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a5b8:	89 04 24             	mov    %eax,(%esp)
c010a5bb:	e8 86 e8 ff ff       	call   c0108e46 <user_mem_check>
c010a5c0:	85 c0                	test   %eax,%eax
c010a5c2:	75 0a                	jne    c010a5ce <do_execve+0x40>
        return -E_INVAL;
c010a5c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a5c9:	e9 f4 00 00 00       	jmp    c010a6c2 <do_execve+0x134>
    }
    if (len > PROC_NAME_LEN) {
c010a5ce:	83 7d 0c 0f          	cmpl   $0xf,0xc(%ebp)
c010a5d2:	76 07                	jbe    c010a5db <do_execve+0x4d>
        len = PROC_NAME_LEN;
c010a5d4:	c7 45 0c 0f 00 00 00 	movl   $0xf,0xc(%ebp)
    }

    char local_name[PROC_NAME_LEN + 1];
    memset(local_name, 0, sizeof(local_name));
c010a5db:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c010a5e2:	00 
c010a5e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a5ea:	00 
c010a5eb:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a5ee:	89 04 24             	mov    %eax,(%esp)
c010a5f1:	e8 36 15 00 00       	call   c010bb2c <memset>
    memcpy(local_name, name, len);
c010a5f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a5f9:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a5fd:	8b 45 08             	mov    0x8(%ebp),%eax
c010a600:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a604:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a607:	89 04 24             	mov    %eax,(%esp)
c010a60a:	e8 ff 15 00 00       	call   c010bc0e <memcpy>

    // 寄居蟹首先把之前海螺的肉去掉
    if (mm != NULL) {
c010a60f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a613:	74 4a                	je     c010a65f <do_execve+0xd1>
        lcr3(boot_cr3);
c010a615:	a1 c8 ef 19 c0       	mov    0xc019efc8,%eax
c010a61a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010a61d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a620:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c010a623:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a626:	89 04 24             	mov    %eax,(%esp)
c010a629:	e8 0e ed ff ff       	call   c010933c <mm_count_dec>
c010a62e:	85 c0                	test   %eax,%eax
c010a630:	75 21                	jne    c010a653 <do_execve+0xc5>
        	// 清除原来进程内存管理部分
            exit_mmap(mm);
c010a632:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a635:	89 04 24             	mov    %eax,(%esp)
c010a638:	e8 72 dd ff ff       	call   c01083af <exit_mmap>
            // 页表清空
            put_pgdir(mm);
c010a63d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a640:	89 04 24             	mov    %eax,(%esp)
c010a643:	e8 05 f4 ff ff       	call   c0109a4d <put_pgdir>
            mm_destroy(mm);
c010a648:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a64b:	89 04 24             	mov    %eax,(%esp)
c010a64e:	e8 9d da ff ff       	call   c01080f0 <mm_destroy>
        }
        current->mm = NULL;
c010a653:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a658:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    int ret;

    // 然后寄居蟹自己住进去
    // load_icode 函数的功能则在于为执行新的程序初始化好内存空间（一系列的准备工作，内存初始化啊，伪造中断返回现场以便于跳转到elf文件开始处去执行啊）。
    if ((ret = load_icode(binary, size)) != 0) {
c010a65f:	8b 45 14             	mov    0x14(%ebp),%eax
c010a662:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a666:	8b 45 10             	mov    0x10(%ebp),%eax
c010a669:	89 04 24             	mov    %eax,(%esp)
c010a66c:	e8 bb f8 ff ff       	call   c0109f2c <load_icode>
c010a671:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a674:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a678:	74 2f                	je     c010a6a9 <do_execve+0x11b>
        goto execve_exit;
c010a67a:	90                   	nop
    }
    set_proc_name(current, local_name);
    return 0;

execve_exit:
    do_exit(ret);
c010a67b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a67e:	89 04 24             	mov    %eax,(%esp)
c010a681:	e8 d6 f6 ff ff       	call   c0109d5c <do_exit>
    panic("already exit: %e.\n", ret);
c010a686:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a689:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a68d:	c7 44 24 08 a7 de 10 	movl   $0xc010dea7,0x8(%esp)
c010a694:	c0 
c010a695:	c7 44 24 04 fe 02 00 	movl   $0x2fe,0x4(%esp)
c010a69c:	00 
c010a69d:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010a6a4:	e8 2c 67 ff ff       	call   c0100dd5 <__panic>
    // 然后寄居蟹自己住进去
    // load_icode 函数的功能则在于为执行新的程序初始化好内存空间（一系列的准备工作，内存初始化啊，伪造中断返回现场以便于跳转到elf文件开始处去执行啊）。
    if ((ret = load_icode(binary, size)) != 0) {
        goto execve_exit;
    }
    set_proc_name(current, local_name);
c010a6a9:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a6ae:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010a6b1:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a6b5:	89 04 24             	mov    %eax,(%esp)
c010a6b8:	e8 c2 ed ff ff       	call   c010947f <set_proc_name>
    return 0;
c010a6bd:	b8 00 00 00 00       	mov    $0x0,%eax

execve_exit:
    do_exit(ret);
    panic("already exit: %e.\n", ret);
}
c010a6c2:	c9                   	leave  
c010a6c3:	c3                   	ret    

c010a6c4 <do_yield>:

// do_yield - ask the scheduler to reschedule
int
do_yield(void) {
c010a6c4:	55                   	push   %ebp
c010a6c5:	89 e5                	mov    %esp,%ebp
    current->need_resched = 1;
c010a6c7:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a6cc:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    return 0;
c010a6d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a6d8:	5d                   	pop    %ebp
c010a6d9:	c3                   	ret    

c010a6da <do_wait>:

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int
do_wait(int pid, int *code_store) {
c010a6da:	55                   	push   %ebp
c010a6db:	89 e5                	mov    %esp,%ebp
c010a6dd:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = current->mm;
c010a6e0:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a6e5:	8b 40 18             	mov    0x18(%eax),%eax
c010a6e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (code_store != NULL) {
c010a6eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010a6ef:	74 30                	je     c010a721 <do_wait+0x47>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
c010a6f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a6f4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c010a6fb:	00 
c010a6fc:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
c010a703:	00 
c010a704:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a708:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a70b:	89 04 24             	mov    %eax,(%esp)
c010a70e:	e8 33 e7 ff ff       	call   c0108e46 <user_mem_check>
c010a713:	85 c0                	test   %eax,%eax
c010a715:	75 0a                	jne    c010a721 <do_wait+0x47>
            return -E_INVAL;
c010a717:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a71c:	e9 4b 01 00 00       	jmp    c010a86c <do_wait+0x192>
    }

    struct proc_struct *proc;
    bool intr_flag, haskid;
repeat:
    haskid = 0;
c010a721:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    if (pid != 0) {
c010a728:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010a72c:	74 39                	je     c010a767 <do_wait+0x8d>
        proc = find_proc(pid);
c010a72e:	8b 45 08             	mov    0x8(%ebp),%eax
c010a731:	89 04 24             	mov    %eax,(%esp)
c010a734:	e8 27 f1 ff ff       	call   c0109860 <find_proc>
c010a739:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (proc != NULL && proc->parent == current) {
c010a73c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a740:	74 54                	je     c010a796 <do_wait+0xbc>
c010a742:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a745:	8b 50 14             	mov    0x14(%eax),%edx
c010a748:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a74d:	39 c2                	cmp    %eax,%edx
c010a74f:	75 45                	jne    c010a796 <do_wait+0xbc>
            haskid = 1;
c010a751:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010a758:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a75b:	8b 00                	mov    (%eax),%eax
c010a75d:	83 f8 03             	cmp    $0x3,%eax
c010a760:	75 34                	jne    c010a796 <do_wait+0xbc>
                goto found;
c010a762:	e9 80 00 00 00       	jmp    c010a7e7 <do_wait+0x10d>
            }
        }
    }
    else {
        proc = current->cptr;
c010a767:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a76c:	8b 40 70             	mov    0x70(%eax),%eax
c010a76f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        for (; proc != NULL; proc = proc->optr) {
c010a772:	eb 1c                	jmp    c010a790 <do_wait+0xb6>
            haskid = 1;
c010a774:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010a77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a77e:	8b 00                	mov    (%eax),%eax
c010a780:	83 f8 03             	cmp    $0x3,%eax
c010a783:	75 02                	jne    c010a787 <do_wait+0xad>
                goto found;
c010a785:	eb 60                	jmp    c010a7e7 <do_wait+0x10d>
            }
        }
    }
    else {
        proc = current->cptr;
        for (; proc != NULL; proc = proc->optr) {
c010a787:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a78a:	8b 40 78             	mov    0x78(%eax),%eax
c010a78d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a790:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a794:	75 de                	jne    c010a774 <do_wait+0x9a>
            if (proc->state == PROC_ZOMBIE) {
                goto found;
            }
        }
    }
    if (haskid) {
c010a796:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a79a:	74 41                	je     c010a7dd <do_wait+0x103>
        current->state = PROC_SLEEPING;
c010a79c:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a7a1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        current->wait_state = WT_CHILD;
c010a7a7:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a7ac:	c7 40 6c 01 00 00 80 	movl   $0x80000001,0x6c(%eax)
        schedule();
c010a7b3:	e8 09 06 00 00       	call   c010adc1 <schedule>
        if (current->flags & PF_EXITING) {
c010a7b8:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a7bd:	8b 40 44             	mov    0x44(%eax),%eax
c010a7c0:	83 e0 01             	and    $0x1,%eax
c010a7c3:	85 c0                	test   %eax,%eax
c010a7c5:	74 11                	je     c010a7d8 <do_wait+0xfe>
            do_exit(-E_KILLED);
c010a7c7:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c010a7ce:	e8 89 f5 ff ff       	call   c0109d5c <do_exit>
        }
        goto repeat;
c010a7d3:	e9 49 ff ff ff       	jmp    c010a721 <do_wait+0x47>
c010a7d8:	e9 44 ff ff ff       	jmp    c010a721 <do_wait+0x47>
    }
    return -E_BAD_PROC;
c010a7dd:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
c010a7e2:	e9 85 00 00 00       	jmp    c010a86c <do_wait+0x192>

found:
    if (proc == idleproc || proc == initproc) {
c010a7e7:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010a7ec:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010a7ef:	74 0a                	je     c010a7fb <do_wait+0x121>
c010a7f1:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010a7f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010a7f9:	75 1c                	jne    c010a817 <do_wait+0x13d>
        panic("wait idleproc or initproc.\n");
c010a7fb:	c7 44 24 08 ba de 10 	movl   $0xc010deba,0x8(%esp)
c010a802:	c0 
c010a803:	c7 44 24 04 37 03 00 	movl   $0x337,0x4(%esp)
c010a80a:	00 
c010a80b:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010a812:	e8 be 65 ff ff       	call   c0100dd5 <__panic>
    }
    if (code_store != NULL) {
c010a817:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010a81b:	74 0b                	je     c010a828 <do_wait+0x14e>
        *code_store = proc->exit_code;
c010a81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a820:	8b 50 68             	mov    0x68(%eax),%edx
c010a823:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a826:	89 10                	mov    %edx,(%eax)
    }
    local_intr_save(intr_flag);
c010a828:	e8 2f e9 ff ff       	call   c010915c <__intr_save>
c010a82d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    {
        unhash_proc(proc);
c010a830:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a833:	89 04 24             	mov    %eax,(%esp)
c010a836:	e8 f2 ef ff ff       	call   c010982d <unhash_proc>
        remove_links(proc);
c010a83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a83e:	89 04 24             	mov    %eax,(%esp)
c010a841:	e8 63 ed ff ff       	call   c01095a9 <remove_links>
    }
    local_intr_restore(intr_flag);
c010a846:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a849:	89 04 24             	mov    %eax,(%esp)
c010a84c:	e8 35 e9 ff ff       	call   c0109186 <__intr_restore>
    put_kstack(proc);
c010a851:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a854:	89 04 24             	mov    %eax,(%esp)
c010a857:	e8 24 f1 ff ff       	call   c0109980 <put_kstack>
    kfree(proc);
c010a85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a85f:	89 04 24             	mov    %eax,(%esp)
c010a862:	e8 79 a3 ff ff       	call   c0104be0 <kfree>
    return 0;
c010a867:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a86c:	c9                   	leave  
c010a86d:	c3                   	ret    

c010a86e <do_kill>:

// do_kill - kill process with pid by set this process's flags with PF_EXITING
int
do_kill(int pid) {
c010a86e:	55                   	push   %ebp
c010a86f:	89 e5                	mov    %esp,%ebp
c010a871:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc;
    if ((proc = find_proc(pid)) != NULL) {
c010a874:	8b 45 08             	mov    0x8(%ebp),%eax
c010a877:	89 04 24             	mov    %eax,(%esp)
c010a87a:	e8 e1 ef ff ff       	call   c0109860 <find_proc>
c010a87f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a882:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a886:	74 41                	je     c010a8c9 <do_kill+0x5b>
        if (!(proc->flags & PF_EXITING)) {
c010a888:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a88b:	8b 40 44             	mov    0x44(%eax),%eax
c010a88e:	83 e0 01             	and    $0x1,%eax
c010a891:	85 c0                	test   %eax,%eax
c010a893:	75 2d                	jne    c010a8c2 <do_kill+0x54>
            proc->flags |= PF_EXITING;
c010a895:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a898:	8b 40 44             	mov    0x44(%eax),%eax
c010a89b:	83 c8 01             	or     $0x1,%eax
c010a89e:	89 c2                	mov    %eax,%edx
c010a8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8a3:	89 50 44             	mov    %edx,0x44(%eax)
            if (proc->wait_state & WT_INTERRUPTED) {
c010a8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8a9:	8b 40 6c             	mov    0x6c(%eax),%eax
c010a8ac:	85 c0                	test   %eax,%eax
c010a8ae:	79 0b                	jns    c010a8bb <do_kill+0x4d>
                wakeup_proc(proc);
c010a8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8b3:	89 04 24             	mov    %eax,(%esp)
c010a8b6:	e8 82 04 00 00       	call   c010ad3d <wakeup_proc>
            }
            return 0;
c010a8bb:	b8 00 00 00 00       	mov    $0x0,%eax
c010a8c0:	eb 0c                	jmp    c010a8ce <do_kill+0x60>
        }
        return -E_KILLED;
c010a8c2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
c010a8c7:	eb 05                	jmp    c010a8ce <do_kill+0x60>
    }
    return -E_INVAL;
c010a8c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
c010a8ce:	c9                   	leave  
c010a8cf:	c3                   	ret    

c010a8d0 <kernel_execve>:

// kernel_execve - do SYS_exec syscall to exec a user program called by user_main kernel_thread
static int
kernel_execve(const char *name, unsigned char *binary, size_t size) {
c010a8d0:	55                   	push   %ebp
c010a8d1:	89 e5                	mov    %esp,%ebp
c010a8d3:	57                   	push   %edi
c010a8d4:	56                   	push   %esi
c010a8d5:	53                   	push   %ebx
c010a8d6:	83 ec 2c             	sub    $0x2c,%esp
    int ret, len = strlen(name);
c010a8d9:	8b 45 08             	mov    0x8(%ebp),%eax
c010a8dc:	89 04 24             	mov    %eax,(%esp)
c010a8df:	e8 19 0f 00 00       	call   c010b7fd <strlen>
c010a8e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile (
c010a8e7:	b8 04 00 00 00       	mov    $0x4,%eax
c010a8ec:	8b 55 08             	mov    0x8(%ebp),%edx
c010a8ef:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c010a8f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
c010a8f5:	8b 75 10             	mov    0x10(%ebp),%esi
c010a8f8:	89 f7                	mov    %esi,%edi
c010a8fa:	cd 80                	int    $0x80
c010a8fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL), "0" (SYS_exec), "d" (name), "c" (len), "b" (binary), "D" (size)
        : "memory");
    return ret;
c010a8ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
c010a902:	83 c4 2c             	add    $0x2c,%esp
c010a905:	5b                   	pop    %ebx
c010a906:	5e                   	pop    %esi
c010a907:	5f                   	pop    %edi
c010a908:	5d                   	pop    %ebp
c010a909:	c3                   	ret    

c010a90a <user_main>:

#define KERNEL_EXECVE2(x, xstart, xsize)        __KERNEL_EXECVE2(x, xstart, xsize)

// user_main - kernel thread used to exec a user program
static int
user_main(void *arg) {
c010a90a:	55                   	push   %ebp
c010a90b:	89 e5                	mov    %esp,%ebp
c010a90d:	83 ec 18             	sub    $0x18,%esp
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
#else
    KERNEL_EXECVE(exit);
c010a910:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a915:	8b 40 04             	mov    0x4(%eax),%eax
c010a918:	c7 44 24 08 d6 de 10 	movl   $0xc010ded6,0x8(%esp)
c010a91f:	c0 
c010a920:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a924:	c7 04 24 dc de 10 c0 	movl   $0xc010dedc,(%esp)
c010a92b:	e8 23 5a ff ff       	call   c0100353 <cprintf>
c010a930:	b8 c5 78 00 00       	mov    $0x78c5,%eax
c010a935:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a939:	c7 44 24 04 85 15 14 	movl   $0xc0141585,0x4(%esp)
c010a940:	c0 
c010a941:	c7 04 24 d6 de 10 c0 	movl   $0xc010ded6,(%esp)
c010a948:	e8 83 ff ff ff       	call   c010a8d0 <kernel_execve>
#endif
    panic("user_main execve failed.\n");
c010a94d:	c7 44 24 08 03 df 10 	movl   $0xc010df03,0x8(%esp)
c010a954:	c0 
c010a955:	c7 44 24 04 80 03 00 	movl   $0x380,0x4(%esp)
c010a95c:	00 
c010a95d:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010a964:	e8 6c 64 ff ff       	call   c0100dd5 <__panic>

c010a969 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c010a969:	55                   	push   %ebp
c010a96a:	89 e5                	mov    %esp,%ebp
c010a96c:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010a96f:	e8 63 a7 ff ff       	call   c01050d7 <nr_free_pages>
c010a974:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t kernel_allocated_store = kallocated();
c010a977:	e8 2c a1 ff ff       	call   c0104aa8 <kallocated>
c010a97c:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int pid = kernel_thread(user_main, NULL, 0);
c010a97f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010a986:	00 
c010a987:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a98e:	00 
c010a98f:	c7 04 24 0a a9 10 c0 	movl   $0xc010a90a,(%esp)
c010a996:	e8 37 ef ff ff       	call   c01098d2 <kernel_thread>
c010a99b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pid <= 0) {
c010a99e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010a9a2:	7f 1c                	jg     c010a9c0 <init_main+0x57>
        panic("create user_main failed.\n");
c010a9a4:	c7 44 24 08 1d df 10 	movl   $0xc010df1d,0x8(%esp)
c010a9ab:	c0 
c010a9ac:	c7 44 24 04 8b 03 00 	movl   $0x38b,0x4(%esp)
c010a9b3:	00 
c010a9b4:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010a9bb:	e8 15 64 ff ff       	call   c0100dd5 <__panic>
    }

    while (do_wait(0, NULL) == 0) {
c010a9c0:	eb 05                	jmp    c010a9c7 <init_main+0x5e>
        schedule();
c010a9c2:	e8 fa 03 00 00       	call   c010adc1 <schedule>
    int pid = kernel_thread(user_main, NULL, 0);
    if (pid <= 0) {
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
c010a9c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a9ce:	00 
c010a9cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010a9d6:	e8 ff fc ff ff       	call   c010a6da <do_wait>
c010a9db:	85 c0                	test   %eax,%eax
c010a9dd:	74 e3                	je     c010a9c2 <init_main+0x59>
        schedule();
    }

    cprintf("all user-mode processes have quit.\n");
c010a9df:	c7 04 24 38 df 10 c0 	movl   $0xc010df38,(%esp)
c010a9e6:	e8 68 59 ff ff       	call   c0100353 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
c010a9eb:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010a9f0:	8b 40 70             	mov    0x70(%eax),%eax
c010a9f3:	85 c0                	test   %eax,%eax
c010a9f5:	75 18                	jne    c010aa0f <init_main+0xa6>
c010a9f7:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010a9fc:	8b 40 74             	mov    0x74(%eax),%eax
c010a9ff:	85 c0                	test   %eax,%eax
c010aa01:	75 0c                	jne    c010aa0f <init_main+0xa6>
c010aa03:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010aa08:	8b 40 78             	mov    0x78(%eax),%eax
c010aa0b:	85 c0                	test   %eax,%eax
c010aa0d:	74 24                	je     c010aa33 <init_main+0xca>
c010aa0f:	c7 44 24 0c 5c df 10 	movl   $0xc010df5c,0xc(%esp)
c010aa16:	c0 
c010aa17:	c7 44 24 08 de dc 10 	movl   $0xc010dcde,0x8(%esp)
c010aa1e:	c0 
c010aa1f:	c7 44 24 04 93 03 00 	movl   $0x393,0x4(%esp)
c010aa26:	00 
c010aa27:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010aa2e:	e8 a2 63 ff ff       	call   c0100dd5 <__panic>
    assert(nr_process == 2);
c010aa33:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c010aa38:	83 f8 02             	cmp    $0x2,%eax
c010aa3b:	74 24                	je     c010aa61 <init_main+0xf8>
c010aa3d:	c7 44 24 0c a7 df 10 	movl   $0xc010dfa7,0xc(%esp)
c010aa44:	c0 
c010aa45:	c7 44 24 08 de dc 10 	movl   $0xc010dcde,0x8(%esp)
c010aa4c:	c0 
c010aa4d:	c7 44 24 04 94 03 00 	movl   $0x394,0x4(%esp)
c010aa54:	00 
c010aa55:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010aa5c:	e8 74 63 ff ff       	call   c0100dd5 <__panic>
c010aa61:	c7 45 e8 b0 f0 19 c0 	movl   $0xc019f0b0,-0x18(%ebp)
c010aa68:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010aa6b:	8b 40 04             	mov    0x4(%eax),%eax
    assert(list_next(&proc_list) == &(initproc->list_link));
c010aa6e:	8b 15 84 cf 19 c0    	mov    0xc019cf84,%edx
c010aa74:	83 c2 58             	add    $0x58,%edx
c010aa77:	39 d0                	cmp    %edx,%eax
c010aa79:	74 24                	je     c010aa9f <init_main+0x136>
c010aa7b:	c7 44 24 0c b8 df 10 	movl   $0xc010dfb8,0xc(%esp)
c010aa82:	c0 
c010aa83:	c7 44 24 08 de dc 10 	movl   $0xc010dcde,0x8(%esp)
c010aa8a:	c0 
c010aa8b:	c7 44 24 04 95 03 00 	movl   $0x395,0x4(%esp)
c010aa92:	00 
c010aa93:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010aa9a:	e8 36 63 ff ff       	call   c0100dd5 <__panic>
c010aa9f:	c7 45 e4 b0 f0 19 c0 	movl   $0xc019f0b0,-0x1c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010aaa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010aaa9:	8b 00                	mov    (%eax),%eax
    assert(list_prev(&proc_list) == &(initproc->list_link));
c010aaab:	8b 15 84 cf 19 c0    	mov    0xc019cf84,%edx
c010aab1:	83 c2 58             	add    $0x58,%edx
c010aab4:	39 d0                	cmp    %edx,%eax
c010aab6:	74 24                	je     c010aadc <init_main+0x173>
c010aab8:	c7 44 24 0c e8 df 10 	movl   $0xc010dfe8,0xc(%esp)
c010aabf:	c0 
c010aac0:	c7 44 24 08 de dc 10 	movl   $0xc010dcde,0x8(%esp)
c010aac7:	c0 
c010aac8:	c7 44 24 04 96 03 00 	movl   $0x396,0x4(%esp)
c010aacf:	00 
c010aad0:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010aad7:	e8 f9 62 ff ff       	call   c0100dd5 <__panic>

    cprintf("init check memory pass.\n");
c010aadc:	c7 04 24 18 e0 10 c0 	movl   $0xc010e018,(%esp)
c010aae3:	e8 6b 58 ff ff       	call   c0100353 <cprintf>
    return 0;
c010aae8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010aaed:	c9                   	leave  
c010aaee:	c3                   	ret    

c010aaef <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c010aaef:	55                   	push   %ebp
c010aaf0:	89 e5                	mov    %esp,%ebp
c010aaf2:	83 ec 28             	sub    $0x28,%esp
c010aaf5:	c7 45 ec b0 f0 19 c0 	movl   $0xc019f0b0,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010aafc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010aaff:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010ab02:	89 50 04             	mov    %edx,0x4(%eax)
c010ab05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ab08:	8b 50 04             	mov    0x4(%eax),%edx
c010ab0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ab0e:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010ab10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010ab17:	eb 26                	jmp    c010ab3f <proc_init+0x50>
        list_init(hash_list + i);
c010ab19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab1c:	c1 e0 03             	shl    $0x3,%eax
c010ab1f:	05 a0 cf 19 c0       	add    $0xc019cfa0,%eax
c010ab24:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010ab27:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ab2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010ab2d:	89 50 04             	mov    %edx,0x4(%eax)
c010ab30:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ab33:	8b 50 04             	mov    0x4(%eax),%edx
c010ab36:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ab39:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010ab3b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010ab3f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c010ab46:	7e d1                	jle    c010ab19 <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c010ab48:	e8 41 e8 ff ff       	call   c010938e <alloc_proc>
c010ab4d:	a3 80 cf 19 c0       	mov    %eax,0xc019cf80
c010ab52:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ab57:	85 c0                	test   %eax,%eax
c010ab59:	75 1c                	jne    c010ab77 <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c010ab5b:	c7 44 24 08 31 e0 10 	movl   $0xc010e031,0x8(%esp)
c010ab62:	c0 
c010ab63:	c7 44 24 04 a8 03 00 	movl   $0x3a8,0x4(%esp)
c010ab6a:	00 
c010ab6b:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010ab72:	e8 5e 62 ff ff       	call   c0100dd5 <__panic>
    }

    idleproc->pid = 0;
c010ab77:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ab7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c010ab83:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ab88:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c010ab8e:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ab93:	ba 00 80 12 c0       	mov    $0xc0128000,%edx
c010ab98:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c010ab9b:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010aba0:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c010aba7:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010abac:	c7 44 24 04 49 e0 10 	movl   $0xc010e049,0x4(%esp)
c010abb3:	c0 
c010abb4:	89 04 24             	mov    %eax,(%esp)
c010abb7:	e8 c3 e8 ff ff       	call   c010947f <set_proc_name>
    nr_process ++;
c010abbc:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c010abc1:	83 c0 01             	add    $0x1,%eax
c010abc4:	a3 a0 ef 19 c0       	mov    %eax,0xc019efa0

    current = idleproc;
c010abc9:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010abce:	a3 88 cf 19 c0       	mov    %eax,0xc019cf88

    int pid = kernel_thread(init_main, NULL, 0);
c010abd3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010abda:	00 
c010abdb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010abe2:	00 
c010abe3:	c7 04 24 69 a9 10 c0 	movl   $0xc010a969,(%esp)
c010abea:	e8 e3 ec ff ff       	call   c01098d2 <kernel_thread>
c010abef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c010abf2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010abf6:	7f 1c                	jg     c010ac14 <proc_init+0x125>
        panic("create init_main failed.\n");
c010abf8:	c7 44 24 08 4e e0 10 	movl   $0xc010e04e,0x8(%esp)
c010abff:	c0 
c010ac00:	c7 44 24 04 b6 03 00 	movl   $0x3b6,0x4(%esp)
c010ac07:	00 
c010ac08:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010ac0f:	e8 c1 61 ff ff       	call   c0100dd5 <__panic>
    }

    initproc = find_proc(pid);
c010ac14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ac17:	89 04 24             	mov    %eax,(%esp)
c010ac1a:	e8 41 ec ff ff       	call   c0109860 <find_proc>
c010ac1f:	a3 84 cf 19 c0       	mov    %eax,0xc019cf84
    set_proc_name(initproc, "init");
c010ac24:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010ac29:	c7 44 24 04 68 e0 10 	movl   $0xc010e068,0x4(%esp)
c010ac30:	c0 
c010ac31:	89 04 24             	mov    %eax,(%esp)
c010ac34:	e8 46 e8 ff ff       	call   c010947f <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c010ac39:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac3e:	85 c0                	test   %eax,%eax
c010ac40:	74 0c                	je     c010ac4e <proc_init+0x15f>
c010ac42:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac47:	8b 40 04             	mov    0x4(%eax),%eax
c010ac4a:	85 c0                	test   %eax,%eax
c010ac4c:	74 24                	je     c010ac72 <proc_init+0x183>
c010ac4e:	c7 44 24 0c 70 e0 10 	movl   $0xc010e070,0xc(%esp)
c010ac55:	c0 
c010ac56:	c7 44 24 08 de dc 10 	movl   $0xc010dcde,0x8(%esp)
c010ac5d:	c0 
c010ac5e:	c7 44 24 04 bc 03 00 	movl   $0x3bc,0x4(%esp)
c010ac65:	00 
c010ac66:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010ac6d:	e8 63 61 ff ff       	call   c0100dd5 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c010ac72:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010ac77:	85 c0                	test   %eax,%eax
c010ac79:	74 0d                	je     c010ac88 <proc_init+0x199>
c010ac7b:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010ac80:	8b 40 04             	mov    0x4(%eax),%eax
c010ac83:	83 f8 01             	cmp    $0x1,%eax
c010ac86:	74 24                	je     c010acac <proc_init+0x1bd>
c010ac88:	c7 44 24 0c 98 e0 10 	movl   $0xc010e098,0xc(%esp)
c010ac8f:	c0 
c010ac90:	c7 44 24 08 de dc 10 	movl   $0xc010dcde,0x8(%esp)
c010ac97:	c0 
c010ac98:	c7 44 24 04 bd 03 00 	movl   $0x3bd,0x4(%esp)
c010ac9f:	00 
c010aca0:	c7 04 24 b4 dc 10 c0 	movl   $0xc010dcb4,(%esp)
c010aca7:	e8 29 61 ff ff       	call   c0100dd5 <__panic>
}
c010acac:	c9                   	leave  
c010acad:	c3                   	ret    

c010acae <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c010acae:	55                   	push   %ebp
c010acaf:	89 e5                	mov    %esp,%ebp
c010acb1:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c010acb4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010acb9:	8b 40 10             	mov    0x10(%eax),%eax
c010acbc:	85 c0                	test   %eax,%eax
c010acbe:	74 07                	je     c010acc7 <cpu_idle+0x19>
            schedule();
c010acc0:	e8 fc 00 00 00       	call   c010adc1 <schedule>
        }
    }
c010acc5:	eb ed                	jmp    c010acb4 <cpu_idle+0x6>
c010acc7:	eb eb                	jmp    c010acb4 <cpu_idle+0x6>

c010acc9 <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from 	# 向上4个字节存放的是“from”这个参数
c010acc9:	8b 44 24 04          	mov    0x4(%esp),%eax

    popl 0(%eax)                # save eip !popl
c010accd:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c010accf:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c010acd2:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c010acd5:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c010acd8:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c010acdb:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c010acde:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c010ace1:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c010ace4:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c010ace8:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c010aceb:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c010acee:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c010acf1:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c010acf4:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c010acf7:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c010acfa:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c010acfd:	ff 30                	pushl  (%eax)

    ret
c010acff:	c3                   	ret    

c010ad00 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c010ad00:	55                   	push   %ebp
c010ad01:	89 e5                	mov    %esp,%ebp
c010ad03:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010ad06:	9c                   	pushf  
c010ad07:	58                   	pop    %eax
c010ad08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010ad0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010ad0e:	25 00 02 00 00       	and    $0x200,%eax
c010ad13:	85 c0                	test   %eax,%eax
c010ad15:	74 0c                	je     c010ad23 <__intr_save+0x23>
        intr_disable();
c010ad17:	e8 11 73 ff ff       	call   c010202d <intr_disable>
        return 1;
c010ad1c:	b8 01 00 00 00       	mov    $0x1,%eax
c010ad21:	eb 05                	jmp    c010ad28 <__intr_save+0x28>
    }
    return 0;
c010ad23:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ad28:	c9                   	leave  
c010ad29:	c3                   	ret    

c010ad2a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010ad2a:	55                   	push   %ebp
c010ad2b:	89 e5                	mov    %esp,%ebp
c010ad2d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010ad30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010ad34:	74 05                	je     c010ad3b <__intr_restore+0x11>
        intr_enable();
c010ad36:	e8 ec 72 ff ff       	call   c0102027 <intr_enable>
    }
}
c010ad3b:	c9                   	leave  
c010ad3c:	c3                   	ret    

c010ad3d <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c010ad3d:	55                   	push   %ebp
c010ad3e:	89 e5                	mov    %esp,%ebp
c010ad40:	83 ec 28             	sub    $0x28,%esp
    assert(proc->state != PROC_ZOMBIE);
c010ad43:	8b 45 08             	mov    0x8(%ebp),%eax
c010ad46:	8b 00                	mov    (%eax),%eax
c010ad48:	83 f8 03             	cmp    $0x3,%eax
c010ad4b:	75 24                	jne    c010ad71 <wakeup_proc+0x34>
c010ad4d:	c7 44 24 0c bf e0 10 	movl   $0xc010e0bf,0xc(%esp)
c010ad54:	c0 
c010ad55:	c7 44 24 08 da e0 10 	movl   $0xc010e0da,0x8(%esp)
c010ad5c:	c0 
c010ad5d:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c010ad64:	00 
c010ad65:	c7 04 24 ef e0 10 c0 	movl   $0xc010e0ef,(%esp)
c010ad6c:	e8 64 60 ff ff       	call   c0100dd5 <__panic>
    bool intr_flag;
    local_intr_save(intr_flag);
c010ad71:	e8 8a ff ff ff       	call   c010ad00 <__intr_save>
c010ad76:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        if (proc->state != PROC_RUNNABLE) {
c010ad79:	8b 45 08             	mov    0x8(%ebp),%eax
c010ad7c:	8b 00                	mov    (%eax),%eax
c010ad7e:	83 f8 02             	cmp    $0x2,%eax
c010ad81:	74 15                	je     c010ad98 <wakeup_proc+0x5b>
            proc->state = PROC_RUNNABLE;
c010ad83:	8b 45 08             	mov    0x8(%ebp),%eax
c010ad86:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
            proc->wait_state = 0;
c010ad8c:	8b 45 08             	mov    0x8(%ebp),%eax
c010ad8f:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
c010ad96:	eb 1c                	jmp    c010adb4 <wakeup_proc+0x77>
        }
        else {
            warn("wakeup runnable process.\n");
c010ad98:	c7 44 24 08 05 e1 10 	movl   $0xc010e105,0x8(%esp)
c010ad9f:	c0 
c010ada0:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c010ada7:	00 
c010ada8:	c7 04 24 ef e0 10 c0 	movl   $0xc010e0ef,(%esp)
c010adaf:	e8 8d 60 ff ff       	call   c0100e41 <__warn>
        }
    }
    local_intr_restore(intr_flag);
c010adb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010adb7:	89 04 24             	mov    %eax,(%esp)
c010adba:	e8 6b ff ff ff       	call   c010ad2a <__intr_restore>
}
c010adbf:	c9                   	leave  
c010adc0:	c3                   	ret    

c010adc1 <schedule>:

void
schedule(void) {
c010adc1:	55                   	push   %ebp
c010adc2:	89 e5                	mov    %esp,%ebp
c010adc4:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c010adc7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c010adce:	e8 2d ff ff ff       	call   c010ad00 <__intr_save>
c010add3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c010add6:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010addb:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c010ade2:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c010ade8:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010aded:	39 c2                	cmp    %eax,%edx
c010adef:	74 0a                	je     c010adfb <schedule+0x3a>
c010adf1:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010adf6:	83 c0 58             	add    $0x58,%eax
c010adf9:	eb 05                	jmp    c010ae00 <schedule+0x3f>
c010adfb:	b8 b0 f0 19 c0       	mov    $0xc019f0b0,%eax
c010ae00:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c010ae03:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ae06:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010ae09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ae0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010ae0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010ae12:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c010ae15:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010ae18:	81 7d f4 b0 f0 19 c0 	cmpl   $0xc019f0b0,-0xc(%ebp)
c010ae1f:	74 15                	je     c010ae36 <schedule+0x75>
                next = le2proc(le, list_link);
c010ae21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ae24:	83 e8 58             	sub    $0x58,%eax
c010ae27:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c010ae2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ae2d:	8b 00                	mov    (%eax),%eax
c010ae2f:	83 f8 02             	cmp    $0x2,%eax
c010ae32:	75 02                	jne    c010ae36 <schedule+0x75>
                    break;
c010ae34:	eb 08                	jmp    c010ae3e <schedule+0x7d>
                }
            }
        } while (le != last);
c010ae36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ae39:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010ae3c:	75 cb                	jne    c010ae09 <schedule+0x48>
        if (next == NULL || next->state != PROC_RUNNABLE) {
c010ae3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010ae42:	74 0a                	je     c010ae4e <schedule+0x8d>
c010ae44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ae47:	8b 00                	mov    (%eax),%eax
c010ae49:	83 f8 02             	cmp    $0x2,%eax
c010ae4c:	74 08                	je     c010ae56 <schedule+0x95>
            next = idleproc;
c010ae4e:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ae53:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c010ae56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ae59:	8b 40 08             	mov    0x8(%eax),%eax
c010ae5c:	8d 50 01             	lea    0x1(%eax),%edx
c010ae5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ae62:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c010ae65:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010ae6a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010ae6d:	74 0b                	je     c010ae7a <schedule+0xb9>
            proc_run(next);
c010ae6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ae72:	89 04 24             	mov    %eax,(%esp)
c010ae75:	e8 aa e8 ff ff       	call   c0109724 <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c010ae7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ae7d:	89 04 24             	mov    %eax,(%esp)
c010ae80:	e8 a5 fe ff ff       	call   c010ad2a <__intr_restore>
}
c010ae85:	c9                   	leave  
c010ae86:	c3                   	ret    

c010ae87 <sys_exit>:
#include <stdio.h>
#include <pmm.h>
#include <assert.h>

static int
sys_exit(uint32_t arg[]) {
c010ae87:	55                   	push   %ebp
c010ae88:	89 e5                	mov    %esp,%ebp
c010ae8a:	83 ec 28             	sub    $0x28,%esp
    int error_code = (int)arg[0];
c010ae8d:	8b 45 08             	mov    0x8(%ebp),%eax
c010ae90:	8b 00                	mov    (%eax),%eax
c010ae92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_exit(error_code);
c010ae95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ae98:	89 04 24             	mov    %eax,(%esp)
c010ae9b:	e8 bc ee ff ff       	call   c0109d5c <do_exit>
}
c010aea0:	c9                   	leave  
c010aea1:	c3                   	ret    

c010aea2 <sys_fork>:

static int
sys_fork(uint32_t arg[]) {
c010aea2:	55                   	push   %ebp
c010aea3:	89 e5                	mov    %esp,%ebp
c010aea5:	83 ec 28             	sub    $0x28,%esp
    struct trapframe *tf = current->tf;
c010aea8:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010aead:	8b 40 3c             	mov    0x3c(%eax),%eax
c010aeb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t stack = tf->tf_esp;
c010aeb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aeb6:	8b 40 44             	mov    0x44(%eax),%eax
c010aeb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_fork(0, stack, tf);
c010aebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aebf:	89 44 24 08          	mov    %eax,0x8(%esp)
c010aec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aec6:	89 44 24 04          	mov    %eax,0x4(%esp)
c010aeca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010aed1:	e8 91 ed ff ff       	call   c0109c67 <do_fork>
}
c010aed6:	c9                   	leave  
c010aed7:	c3                   	ret    

c010aed8 <sys_wait>:

static int
sys_wait(uint32_t arg[]) {
c010aed8:	55                   	push   %ebp
c010aed9:	89 e5                	mov    %esp,%ebp
c010aedb:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010aede:	8b 45 08             	mov    0x8(%ebp),%eax
c010aee1:	8b 00                	mov    (%eax),%eax
c010aee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int *store = (int *)arg[1];
c010aee6:	8b 45 08             	mov    0x8(%ebp),%eax
c010aee9:	83 c0 04             	add    $0x4,%eax
c010aeec:	8b 00                	mov    (%eax),%eax
c010aeee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_wait(pid, store);
c010aef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aef4:	89 44 24 04          	mov    %eax,0x4(%esp)
c010aef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aefb:	89 04 24             	mov    %eax,(%esp)
c010aefe:	e8 d7 f7 ff ff       	call   c010a6da <do_wait>
}
c010af03:	c9                   	leave  
c010af04:	c3                   	ret    

c010af05 <sys_exec>:

static int
sys_exec(uint32_t arg[]) {
c010af05:	55                   	push   %ebp
c010af06:	89 e5                	mov    %esp,%ebp
c010af08:	83 ec 28             	sub    $0x28,%esp
    const char *name = (const char *)arg[0];
c010af0b:	8b 45 08             	mov    0x8(%ebp),%eax
c010af0e:	8b 00                	mov    (%eax),%eax
c010af10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t len = (size_t)arg[1];
c010af13:	8b 45 08             	mov    0x8(%ebp),%eax
c010af16:	8b 40 04             	mov    0x4(%eax),%eax
c010af19:	89 45 f0             	mov    %eax,-0x10(%ebp)
    unsigned char *binary = (unsigned char *)arg[2];
c010af1c:	8b 45 08             	mov    0x8(%ebp),%eax
c010af1f:	83 c0 08             	add    $0x8,%eax
c010af22:	8b 00                	mov    (%eax),%eax
c010af24:	89 45 ec             	mov    %eax,-0x14(%ebp)
    size_t size = (size_t)arg[3];
c010af27:	8b 45 08             	mov    0x8(%ebp),%eax
c010af2a:	8b 40 0c             	mov    0xc(%eax),%eax
c010af2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return do_execve(name, len, binary, size);
c010af30:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010af33:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010af37:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010af3a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010af3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010af41:	89 44 24 04          	mov    %eax,0x4(%esp)
c010af45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010af48:	89 04 24             	mov    %eax,(%esp)
c010af4b:	e8 3e f6 ff ff       	call   c010a58e <do_execve>
}
c010af50:	c9                   	leave  
c010af51:	c3                   	ret    

c010af52 <sys_yield>:

static int
sys_yield(uint32_t arg[]) {
c010af52:	55                   	push   %ebp
c010af53:	89 e5                	mov    %esp,%ebp
c010af55:	83 ec 08             	sub    $0x8,%esp
    return do_yield();
c010af58:	e8 67 f7 ff ff       	call   c010a6c4 <do_yield>
}
c010af5d:	c9                   	leave  
c010af5e:	c3                   	ret    

c010af5f <sys_kill>:

static int
sys_kill(uint32_t arg[]) {
c010af5f:	55                   	push   %ebp
c010af60:	89 e5                	mov    %esp,%ebp
c010af62:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010af65:	8b 45 08             	mov    0x8(%ebp),%eax
c010af68:	8b 00                	mov    (%eax),%eax
c010af6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_kill(pid);
c010af6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010af70:	89 04 24             	mov    %eax,(%esp)
c010af73:	e8 f6 f8 ff ff       	call   c010a86e <do_kill>
}
c010af78:	c9                   	leave  
c010af79:	c3                   	ret    

c010af7a <sys_getpid>:

static int
sys_getpid(uint32_t arg[]) {
c010af7a:	55                   	push   %ebp
c010af7b:	89 e5                	mov    %esp,%ebp
    return current->pid;
c010af7d:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010af82:	8b 40 04             	mov    0x4(%eax),%eax
}
c010af85:	5d                   	pop    %ebp
c010af86:	c3                   	ret    

c010af87 <sys_putc>:

static int
sys_putc(uint32_t arg[]) {
c010af87:	55                   	push   %ebp
c010af88:	89 e5                	mov    %esp,%ebp
c010af8a:	83 ec 28             	sub    $0x28,%esp
    int c = (int)arg[0];
c010af8d:	8b 45 08             	mov    0x8(%ebp),%eax
c010af90:	8b 00                	mov    (%eax),%eax
c010af92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cputchar(c);
c010af95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010af98:	89 04 24             	mov    %eax,(%esp)
c010af9b:	e8 d9 53 ff ff       	call   c0100379 <cputchar>
    return 0;
c010afa0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010afa5:	c9                   	leave  
c010afa6:	c3                   	ret    

c010afa7 <sys_pgdir>:

static int
sys_pgdir(uint32_t arg[]) {
c010afa7:	55                   	push   %ebp
c010afa8:	89 e5                	mov    %esp,%ebp
c010afaa:	83 ec 08             	sub    $0x8,%esp
    print_pgdir();
c010afad:	e8 7f bb ff ff       	call   c0106b31 <print_pgdir>
    return 0;
c010afb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010afb7:	c9                   	leave  
c010afb8:	c3                   	ret    

c010afb9 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
c010afb9:	55                   	push   %ebp
c010afba:	89 e5                	mov    %esp,%ebp
c010afbc:	83 ec 48             	sub    $0x48,%esp
    struct trapframe *tf = current->tf;
c010afbf:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010afc4:	8b 40 3c             	mov    0x3c(%eax),%eax
c010afc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t arg[5];
    int num = tf->tf_regs.reg_eax;
c010afca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010afcd:	8b 40 1c             	mov    0x1c(%eax),%eax
c010afd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (num >= 0 && num < NUM_SYSCALLS) {
c010afd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010afd7:	78 5e                	js     c010b037 <syscall+0x7e>
c010afd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010afdc:	83 f8 1f             	cmp    $0x1f,%eax
c010afdf:	77 56                	ja     c010b037 <syscall+0x7e>
        if (syscalls[num] != NULL) {
c010afe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010afe4:	8b 04 85 a0 aa 12 c0 	mov    -0x3fed5560(,%eax,4),%eax
c010afeb:	85 c0                	test   %eax,%eax
c010afed:	74 48                	je     c010b037 <syscall+0x7e>
            arg[0] = tf->tf_regs.reg_edx;
c010afef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aff2:	8b 40 14             	mov    0x14(%eax),%eax
c010aff5:	89 45 dc             	mov    %eax,-0x24(%ebp)
            arg[1] = tf->tf_regs.reg_ecx;
c010aff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010affb:	8b 40 18             	mov    0x18(%eax),%eax
c010affe:	89 45 e0             	mov    %eax,-0x20(%ebp)
            arg[2] = tf->tf_regs.reg_ebx;
c010b001:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b004:	8b 40 10             	mov    0x10(%eax),%eax
c010b007:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            arg[3] = tf->tf_regs.reg_edi;
c010b00a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b00d:	8b 00                	mov    (%eax),%eax
c010b00f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            arg[4] = tf->tf_regs.reg_esi;
c010b012:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b015:	8b 40 04             	mov    0x4(%eax),%eax
c010b018:	89 45 ec             	mov    %eax,-0x14(%ebp)
            tf->tf_regs.reg_eax = syscalls[num](arg);
c010b01b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b01e:	8b 04 85 a0 aa 12 c0 	mov    -0x3fed5560(,%eax,4),%eax
c010b025:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010b028:	89 14 24             	mov    %edx,(%esp)
c010b02b:	ff d0                	call   *%eax
c010b02d:	89 c2                	mov    %eax,%edx
c010b02f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b032:	89 50 1c             	mov    %edx,0x1c(%eax)
            return ;
c010b035:	eb 46                	jmp    c010b07d <syscall+0xc4>
        }
    }
    print_trapframe(tf);
c010b037:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b03a:	89 04 24             	mov    %eax,(%esp)
c010b03d:	e8 83 73 ff ff       	call   c01023c5 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
c010b042:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b047:	8d 50 48             	lea    0x48(%eax),%edx
c010b04a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b04f:	8b 40 04             	mov    0x4(%eax),%eax
c010b052:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b056:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b05a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b05d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b061:	c7 44 24 08 20 e1 10 	movl   $0xc010e120,0x8(%esp)
c010b068:	c0 
c010b069:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c010b070:	00 
c010b071:	c7 04 24 4c e1 10 c0 	movl   $0xc010e14c,(%esp)
c010b078:	e8 58 5d ff ff       	call   c0100dd5 <__panic>
            num, current->pid, current->name);
}
c010b07d:	c9                   	leave  
c010b07e:	c3                   	ret    

c010b07f <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c010b07f:	55                   	push   %ebp
c010b080:	89 e5                	mov    %esp,%ebp
c010b082:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c010b085:	8b 45 08             	mov    0x8(%ebp),%eax
c010b088:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c010b08e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c010b091:	b8 20 00 00 00       	mov    $0x20,%eax
c010b096:	2b 45 0c             	sub    0xc(%ebp),%eax
c010b099:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010b09c:	89 c1                	mov    %eax,%ecx
c010b09e:	d3 ea                	shr    %cl,%edx
c010b0a0:	89 d0                	mov    %edx,%eax
}
c010b0a2:	c9                   	leave  
c010b0a3:	c3                   	ret    

c010b0a4 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010b0a4:	55                   	push   %ebp
c010b0a5:	89 e5                	mov    %esp,%ebp
c010b0a7:	83 ec 58             	sub    $0x58,%esp
c010b0aa:	8b 45 10             	mov    0x10(%ebp),%eax
c010b0ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010b0b0:	8b 45 14             	mov    0x14(%ebp),%eax
c010b0b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010b0b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010b0b9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010b0bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b0bf:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010b0c2:	8b 45 18             	mov    0x18(%ebp),%eax
c010b0c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010b0c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b0cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b0ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b0d1:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010b0d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b0d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b0da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b0de:	74 1c                	je     c010b0fc <printnum+0x58>
c010b0e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b0e3:	ba 00 00 00 00       	mov    $0x0,%edx
c010b0e8:	f7 75 e4             	divl   -0x1c(%ebp)
c010b0eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010b0ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b0f1:	ba 00 00 00 00       	mov    $0x0,%edx
c010b0f6:	f7 75 e4             	divl   -0x1c(%ebp)
c010b0f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b0fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b0ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b102:	f7 75 e4             	divl   -0x1c(%ebp)
c010b105:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b108:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010b10b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b10e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010b111:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b114:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010b117:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b11a:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010b11d:	8b 45 18             	mov    0x18(%ebp),%eax
c010b120:	ba 00 00 00 00       	mov    $0x0,%edx
c010b125:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010b128:	77 56                	ja     c010b180 <printnum+0xdc>
c010b12a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010b12d:	72 05                	jb     c010b134 <printnum+0x90>
c010b12f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010b132:	77 4c                	ja     c010b180 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010b134:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010b137:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b13a:	8b 45 20             	mov    0x20(%ebp),%eax
c010b13d:	89 44 24 18          	mov    %eax,0x18(%esp)
c010b141:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b145:	8b 45 18             	mov    0x18(%ebp),%eax
c010b148:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b14c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b14f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b152:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b156:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b15a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b15d:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b161:	8b 45 08             	mov    0x8(%ebp),%eax
c010b164:	89 04 24             	mov    %eax,(%esp)
c010b167:	e8 38 ff ff ff       	call   c010b0a4 <printnum>
c010b16c:	eb 1c                	jmp    c010b18a <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010b16e:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b171:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b175:	8b 45 20             	mov    0x20(%ebp),%eax
c010b178:	89 04 24             	mov    %eax,(%esp)
c010b17b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b17e:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010b180:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010b184:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010b188:	7f e4                	jg     c010b16e <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010b18a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b18d:	05 84 e2 10 c0       	add    $0xc010e284,%eax
c010b192:	0f b6 00             	movzbl (%eax),%eax
c010b195:	0f be c0             	movsbl %al,%eax
c010b198:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b19b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b19f:	89 04 24             	mov    %eax,(%esp)
c010b1a2:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1a5:	ff d0                	call   *%eax
}
c010b1a7:	c9                   	leave  
c010b1a8:	c3                   	ret    

c010b1a9 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010b1a9:	55                   	push   %ebp
c010b1aa:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010b1ac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010b1b0:	7e 14                	jle    c010b1c6 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010b1b2:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1b5:	8b 00                	mov    (%eax),%eax
c010b1b7:	8d 48 08             	lea    0x8(%eax),%ecx
c010b1ba:	8b 55 08             	mov    0x8(%ebp),%edx
c010b1bd:	89 0a                	mov    %ecx,(%edx)
c010b1bf:	8b 50 04             	mov    0x4(%eax),%edx
c010b1c2:	8b 00                	mov    (%eax),%eax
c010b1c4:	eb 30                	jmp    c010b1f6 <getuint+0x4d>
    }
    else if (lflag) {
c010b1c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b1ca:	74 16                	je     c010b1e2 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010b1cc:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1cf:	8b 00                	mov    (%eax),%eax
c010b1d1:	8d 48 04             	lea    0x4(%eax),%ecx
c010b1d4:	8b 55 08             	mov    0x8(%ebp),%edx
c010b1d7:	89 0a                	mov    %ecx,(%edx)
c010b1d9:	8b 00                	mov    (%eax),%eax
c010b1db:	ba 00 00 00 00       	mov    $0x0,%edx
c010b1e0:	eb 14                	jmp    c010b1f6 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010b1e2:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1e5:	8b 00                	mov    (%eax),%eax
c010b1e7:	8d 48 04             	lea    0x4(%eax),%ecx
c010b1ea:	8b 55 08             	mov    0x8(%ebp),%edx
c010b1ed:	89 0a                	mov    %ecx,(%edx)
c010b1ef:	8b 00                	mov    (%eax),%eax
c010b1f1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010b1f6:	5d                   	pop    %ebp
c010b1f7:	c3                   	ret    

c010b1f8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010b1f8:	55                   	push   %ebp
c010b1f9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010b1fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010b1ff:	7e 14                	jle    c010b215 <getint+0x1d>
        return va_arg(*ap, long long);
c010b201:	8b 45 08             	mov    0x8(%ebp),%eax
c010b204:	8b 00                	mov    (%eax),%eax
c010b206:	8d 48 08             	lea    0x8(%eax),%ecx
c010b209:	8b 55 08             	mov    0x8(%ebp),%edx
c010b20c:	89 0a                	mov    %ecx,(%edx)
c010b20e:	8b 50 04             	mov    0x4(%eax),%edx
c010b211:	8b 00                	mov    (%eax),%eax
c010b213:	eb 28                	jmp    c010b23d <getint+0x45>
    }
    else if (lflag) {
c010b215:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b219:	74 12                	je     c010b22d <getint+0x35>
        return va_arg(*ap, long);
c010b21b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b21e:	8b 00                	mov    (%eax),%eax
c010b220:	8d 48 04             	lea    0x4(%eax),%ecx
c010b223:	8b 55 08             	mov    0x8(%ebp),%edx
c010b226:	89 0a                	mov    %ecx,(%edx)
c010b228:	8b 00                	mov    (%eax),%eax
c010b22a:	99                   	cltd   
c010b22b:	eb 10                	jmp    c010b23d <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010b22d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b230:	8b 00                	mov    (%eax),%eax
c010b232:	8d 48 04             	lea    0x4(%eax),%ecx
c010b235:	8b 55 08             	mov    0x8(%ebp),%edx
c010b238:	89 0a                	mov    %ecx,(%edx)
c010b23a:	8b 00                	mov    (%eax),%eax
c010b23c:	99                   	cltd   
    }
}
c010b23d:	5d                   	pop    %ebp
c010b23e:	c3                   	ret    

c010b23f <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010b23f:	55                   	push   %ebp
c010b240:	89 e5                	mov    %esp,%ebp
c010b242:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010b245:	8d 45 14             	lea    0x14(%ebp),%eax
c010b248:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010b24b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b24e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b252:	8b 45 10             	mov    0x10(%ebp),%eax
c010b255:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b259:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b25c:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b260:	8b 45 08             	mov    0x8(%ebp),%eax
c010b263:	89 04 24             	mov    %eax,(%esp)
c010b266:	e8 02 00 00 00       	call   c010b26d <vprintfmt>
    va_end(ap);
}
c010b26b:	c9                   	leave  
c010b26c:	c3                   	ret    

c010b26d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010b26d:	55                   	push   %ebp
c010b26e:	89 e5                	mov    %esp,%ebp
c010b270:	56                   	push   %esi
c010b271:	53                   	push   %ebx
c010b272:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b275:	eb 18                	jmp    c010b28f <vprintfmt+0x22>
            if (ch == '\0') {
c010b277:	85 db                	test   %ebx,%ebx
c010b279:	75 05                	jne    c010b280 <vprintfmt+0x13>
                return;
c010b27b:	e9 d1 03 00 00       	jmp    c010b651 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010b280:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b283:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b287:	89 1c 24             	mov    %ebx,(%esp)
c010b28a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b28d:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b28f:	8b 45 10             	mov    0x10(%ebp),%eax
c010b292:	8d 50 01             	lea    0x1(%eax),%edx
c010b295:	89 55 10             	mov    %edx,0x10(%ebp)
c010b298:	0f b6 00             	movzbl (%eax),%eax
c010b29b:	0f b6 d8             	movzbl %al,%ebx
c010b29e:	83 fb 25             	cmp    $0x25,%ebx
c010b2a1:	75 d4                	jne    c010b277 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010b2a3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010b2a7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010b2ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b2b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010b2b4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010b2bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b2be:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010b2c1:	8b 45 10             	mov    0x10(%ebp),%eax
c010b2c4:	8d 50 01             	lea    0x1(%eax),%edx
c010b2c7:	89 55 10             	mov    %edx,0x10(%ebp)
c010b2ca:	0f b6 00             	movzbl (%eax),%eax
c010b2cd:	0f b6 d8             	movzbl %al,%ebx
c010b2d0:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010b2d3:	83 f8 55             	cmp    $0x55,%eax
c010b2d6:	0f 87 44 03 00 00    	ja     c010b620 <vprintfmt+0x3b3>
c010b2dc:	8b 04 85 a8 e2 10 c0 	mov    -0x3fef1d58(,%eax,4),%eax
c010b2e3:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010b2e5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010b2e9:	eb d6                	jmp    c010b2c1 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010b2eb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010b2ef:	eb d0                	jmp    c010b2c1 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b2f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010b2f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b2fb:	89 d0                	mov    %edx,%eax
c010b2fd:	c1 e0 02             	shl    $0x2,%eax
c010b300:	01 d0                	add    %edx,%eax
c010b302:	01 c0                	add    %eax,%eax
c010b304:	01 d8                	add    %ebx,%eax
c010b306:	83 e8 30             	sub    $0x30,%eax
c010b309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010b30c:	8b 45 10             	mov    0x10(%ebp),%eax
c010b30f:	0f b6 00             	movzbl (%eax),%eax
c010b312:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010b315:	83 fb 2f             	cmp    $0x2f,%ebx
c010b318:	7e 0b                	jle    c010b325 <vprintfmt+0xb8>
c010b31a:	83 fb 39             	cmp    $0x39,%ebx
c010b31d:	7f 06                	jg     c010b325 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b31f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010b323:	eb d3                	jmp    c010b2f8 <vprintfmt+0x8b>
            goto process_precision;
c010b325:	eb 33                	jmp    c010b35a <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010b327:	8b 45 14             	mov    0x14(%ebp),%eax
c010b32a:	8d 50 04             	lea    0x4(%eax),%edx
c010b32d:	89 55 14             	mov    %edx,0x14(%ebp)
c010b330:	8b 00                	mov    (%eax),%eax
c010b332:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010b335:	eb 23                	jmp    c010b35a <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010b337:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b33b:	79 0c                	jns    c010b349 <vprintfmt+0xdc>
                width = 0;
c010b33d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010b344:	e9 78 ff ff ff       	jmp    c010b2c1 <vprintfmt+0x54>
c010b349:	e9 73 ff ff ff       	jmp    c010b2c1 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010b34e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010b355:	e9 67 ff ff ff       	jmp    c010b2c1 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010b35a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b35e:	79 12                	jns    c010b372 <vprintfmt+0x105>
                width = precision, precision = -1;
c010b360:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b363:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b366:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010b36d:	e9 4f ff ff ff       	jmp    c010b2c1 <vprintfmt+0x54>
c010b372:	e9 4a ff ff ff       	jmp    c010b2c1 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010b377:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010b37b:	e9 41 ff ff ff       	jmp    c010b2c1 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010b380:	8b 45 14             	mov    0x14(%ebp),%eax
c010b383:	8d 50 04             	lea    0x4(%eax),%edx
c010b386:	89 55 14             	mov    %edx,0x14(%ebp)
c010b389:	8b 00                	mov    (%eax),%eax
c010b38b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b38e:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b392:	89 04 24             	mov    %eax,(%esp)
c010b395:	8b 45 08             	mov    0x8(%ebp),%eax
c010b398:	ff d0                	call   *%eax
            break;
c010b39a:	e9 ac 02 00 00       	jmp    c010b64b <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010b39f:	8b 45 14             	mov    0x14(%ebp),%eax
c010b3a2:	8d 50 04             	lea    0x4(%eax),%edx
c010b3a5:	89 55 14             	mov    %edx,0x14(%ebp)
c010b3a8:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010b3aa:	85 db                	test   %ebx,%ebx
c010b3ac:	79 02                	jns    c010b3b0 <vprintfmt+0x143>
                err = -err;
c010b3ae:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010b3b0:	83 fb 18             	cmp    $0x18,%ebx
c010b3b3:	7f 0b                	jg     c010b3c0 <vprintfmt+0x153>
c010b3b5:	8b 34 9d 20 e2 10 c0 	mov    -0x3fef1de0(,%ebx,4),%esi
c010b3bc:	85 f6                	test   %esi,%esi
c010b3be:	75 23                	jne    c010b3e3 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010b3c0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010b3c4:	c7 44 24 08 95 e2 10 	movl   $0xc010e295,0x8(%esp)
c010b3cb:	c0 
c010b3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b3cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b3d3:	8b 45 08             	mov    0x8(%ebp),%eax
c010b3d6:	89 04 24             	mov    %eax,(%esp)
c010b3d9:	e8 61 fe ff ff       	call   c010b23f <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010b3de:	e9 68 02 00 00       	jmp    c010b64b <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010b3e3:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010b3e7:	c7 44 24 08 9e e2 10 	movl   $0xc010e29e,0x8(%esp)
c010b3ee:	c0 
c010b3ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b3f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b3f6:	8b 45 08             	mov    0x8(%ebp),%eax
c010b3f9:	89 04 24             	mov    %eax,(%esp)
c010b3fc:	e8 3e fe ff ff       	call   c010b23f <printfmt>
            }
            break;
c010b401:	e9 45 02 00 00       	jmp    c010b64b <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010b406:	8b 45 14             	mov    0x14(%ebp),%eax
c010b409:	8d 50 04             	lea    0x4(%eax),%edx
c010b40c:	89 55 14             	mov    %edx,0x14(%ebp)
c010b40f:	8b 30                	mov    (%eax),%esi
c010b411:	85 f6                	test   %esi,%esi
c010b413:	75 05                	jne    c010b41a <vprintfmt+0x1ad>
                p = "(null)";
c010b415:	be a1 e2 10 c0       	mov    $0xc010e2a1,%esi
            }
            if (width > 0 && padc != '-') {
c010b41a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b41e:	7e 3e                	jle    c010b45e <vprintfmt+0x1f1>
c010b420:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010b424:	74 38                	je     c010b45e <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b426:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010b429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b42c:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b430:	89 34 24             	mov    %esi,(%esp)
c010b433:	e8 ed 03 00 00       	call   c010b825 <strnlen>
c010b438:	29 c3                	sub    %eax,%ebx
c010b43a:	89 d8                	mov    %ebx,%eax
c010b43c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b43f:	eb 17                	jmp    c010b458 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010b441:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010b445:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b448:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b44c:	89 04 24             	mov    %eax,(%esp)
c010b44f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b452:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b454:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b458:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b45c:	7f e3                	jg     c010b441 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b45e:	eb 38                	jmp    c010b498 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010b460:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010b464:	74 1f                	je     c010b485 <vprintfmt+0x218>
c010b466:	83 fb 1f             	cmp    $0x1f,%ebx
c010b469:	7e 05                	jle    c010b470 <vprintfmt+0x203>
c010b46b:	83 fb 7e             	cmp    $0x7e,%ebx
c010b46e:	7e 15                	jle    c010b485 <vprintfmt+0x218>
                    putch('?', putdat);
c010b470:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b473:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b477:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010b47e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b481:	ff d0                	call   *%eax
c010b483:	eb 0f                	jmp    c010b494 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010b485:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b488:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b48c:	89 1c 24             	mov    %ebx,(%esp)
c010b48f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b492:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b494:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b498:	89 f0                	mov    %esi,%eax
c010b49a:	8d 70 01             	lea    0x1(%eax),%esi
c010b49d:	0f b6 00             	movzbl (%eax),%eax
c010b4a0:	0f be d8             	movsbl %al,%ebx
c010b4a3:	85 db                	test   %ebx,%ebx
c010b4a5:	74 10                	je     c010b4b7 <vprintfmt+0x24a>
c010b4a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b4ab:	78 b3                	js     c010b460 <vprintfmt+0x1f3>
c010b4ad:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010b4b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b4b5:	79 a9                	jns    c010b460 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b4b7:	eb 17                	jmp    c010b4d0 <vprintfmt+0x263>
                putch(' ', putdat);
c010b4b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b4bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b4c0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010b4c7:	8b 45 08             	mov    0x8(%ebp),%eax
c010b4ca:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b4cc:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b4d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b4d4:	7f e3                	jg     c010b4b9 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010b4d6:	e9 70 01 00 00       	jmp    c010b64b <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010b4db:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b4de:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b4e2:	8d 45 14             	lea    0x14(%ebp),%eax
c010b4e5:	89 04 24             	mov    %eax,(%esp)
c010b4e8:	e8 0b fd ff ff       	call   c010b1f8 <getint>
c010b4ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b4f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010b4f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b4f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b4f9:	85 d2                	test   %edx,%edx
c010b4fb:	79 26                	jns    c010b523 <vprintfmt+0x2b6>
                putch('-', putdat);
c010b4fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b500:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b504:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010b50b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b50e:	ff d0                	call   *%eax
                num = -(long long)num;
c010b510:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b513:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b516:	f7 d8                	neg    %eax
c010b518:	83 d2 00             	adc    $0x0,%edx
c010b51b:	f7 da                	neg    %edx
c010b51d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b520:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010b523:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b52a:	e9 a8 00 00 00       	jmp    c010b5d7 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010b52f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b532:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b536:	8d 45 14             	lea    0x14(%ebp),%eax
c010b539:	89 04 24             	mov    %eax,(%esp)
c010b53c:	e8 68 fc ff ff       	call   c010b1a9 <getuint>
c010b541:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b544:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010b547:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b54e:	e9 84 00 00 00       	jmp    c010b5d7 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010b553:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b556:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b55a:	8d 45 14             	lea    0x14(%ebp),%eax
c010b55d:	89 04 24             	mov    %eax,(%esp)
c010b560:	e8 44 fc ff ff       	call   c010b1a9 <getuint>
c010b565:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b568:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010b56b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010b572:	eb 63                	jmp    c010b5d7 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010b574:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b577:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b57b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010b582:	8b 45 08             	mov    0x8(%ebp),%eax
c010b585:	ff d0                	call   *%eax
            putch('x', putdat);
c010b587:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b58a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b58e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010b595:	8b 45 08             	mov    0x8(%ebp),%eax
c010b598:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010b59a:	8b 45 14             	mov    0x14(%ebp),%eax
c010b59d:	8d 50 04             	lea    0x4(%eax),%edx
c010b5a0:	89 55 14             	mov    %edx,0x14(%ebp)
c010b5a3:	8b 00                	mov    (%eax),%eax
c010b5a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b5a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010b5af:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010b5b6:	eb 1f                	jmp    c010b5d7 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010b5b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b5bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b5bf:	8d 45 14             	lea    0x14(%ebp),%eax
c010b5c2:	89 04 24             	mov    %eax,(%esp)
c010b5c5:	e8 df fb ff ff       	call   c010b1a9 <getuint>
c010b5ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b5cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010b5d0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010b5d7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010b5db:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b5de:	89 54 24 18          	mov    %edx,0x18(%esp)
c010b5e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010b5e5:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b5e9:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b5ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b5f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b5f3:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b5f7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b5fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b5fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b602:	8b 45 08             	mov    0x8(%ebp),%eax
c010b605:	89 04 24             	mov    %eax,(%esp)
c010b608:	e8 97 fa ff ff       	call   c010b0a4 <printnum>
            break;
c010b60d:	eb 3c                	jmp    c010b64b <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010b60f:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b612:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b616:	89 1c 24             	mov    %ebx,(%esp)
c010b619:	8b 45 08             	mov    0x8(%ebp),%eax
c010b61c:	ff d0                	call   *%eax
            break;
c010b61e:	eb 2b                	jmp    c010b64b <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010b620:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b623:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b627:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010b62e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b631:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010b633:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b637:	eb 04                	jmp    c010b63d <vprintfmt+0x3d0>
c010b639:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b63d:	8b 45 10             	mov    0x10(%ebp),%eax
c010b640:	83 e8 01             	sub    $0x1,%eax
c010b643:	0f b6 00             	movzbl (%eax),%eax
c010b646:	3c 25                	cmp    $0x25,%al
c010b648:	75 ef                	jne    c010b639 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010b64a:	90                   	nop
        }
    }
c010b64b:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b64c:	e9 3e fc ff ff       	jmp    c010b28f <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010b651:	83 c4 40             	add    $0x40,%esp
c010b654:	5b                   	pop    %ebx
c010b655:	5e                   	pop    %esi
c010b656:	5d                   	pop    %ebp
c010b657:	c3                   	ret    

c010b658 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010b658:	55                   	push   %ebp
c010b659:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010b65b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b65e:	8b 40 08             	mov    0x8(%eax),%eax
c010b661:	8d 50 01             	lea    0x1(%eax),%edx
c010b664:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b667:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010b66a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b66d:	8b 10                	mov    (%eax),%edx
c010b66f:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b672:	8b 40 04             	mov    0x4(%eax),%eax
c010b675:	39 c2                	cmp    %eax,%edx
c010b677:	73 12                	jae    c010b68b <sprintputch+0x33>
        *b->buf ++ = ch;
c010b679:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b67c:	8b 00                	mov    (%eax),%eax
c010b67e:	8d 48 01             	lea    0x1(%eax),%ecx
c010b681:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b684:	89 0a                	mov    %ecx,(%edx)
c010b686:	8b 55 08             	mov    0x8(%ebp),%edx
c010b689:	88 10                	mov    %dl,(%eax)
    }
}
c010b68b:	5d                   	pop    %ebp
c010b68c:	c3                   	ret    

c010b68d <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010b68d:	55                   	push   %ebp
c010b68e:	89 e5                	mov    %esp,%ebp
c010b690:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010b693:	8d 45 14             	lea    0x14(%ebp),%eax
c010b696:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010b699:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b69c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b6a0:	8b 45 10             	mov    0x10(%ebp),%eax
c010b6a3:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b6a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b6ae:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6b1:	89 04 24             	mov    %eax,(%esp)
c010b6b4:	e8 08 00 00 00       	call   c010b6c1 <vsnprintf>
c010b6b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010b6bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b6bf:	c9                   	leave  
c010b6c0:	c3                   	ret    

c010b6c1 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010b6c1:	55                   	push   %ebp
c010b6c2:	89 e5                	mov    %esp,%ebp
c010b6c4:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010b6c7:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b6cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6d0:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b6d3:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6d6:	01 d0                	add    %edx,%eax
c010b6d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b6db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010b6e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010b6e6:	74 0a                	je     c010b6f2 <vsnprintf+0x31>
c010b6e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b6eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b6ee:	39 c2                	cmp    %eax,%edx
c010b6f0:	76 07                	jbe    c010b6f9 <vsnprintf+0x38>
        return -E_INVAL;
c010b6f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010b6f7:	eb 2a                	jmp    c010b723 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010b6f9:	8b 45 14             	mov    0x14(%ebp),%eax
c010b6fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b700:	8b 45 10             	mov    0x10(%ebp),%eax
c010b703:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b707:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010b70a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b70e:	c7 04 24 58 b6 10 c0 	movl   $0xc010b658,(%esp)
c010b715:	e8 53 fb ff ff       	call   c010b26d <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010b71a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b71d:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010b720:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b723:	c9                   	leave  
c010b724:	c3                   	ret    

c010b725 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c010b725:	55                   	push   %ebp
c010b726:	89 e5                	mov    %esp,%ebp
c010b728:	57                   	push   %edi
c010b729:	56                   	push   %esi
c010b72a:	53                   	push   %ebx
c010b72b:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010b72e:	a1 20 ab 12 c0       	mov    0xc012ab20,%eax
c010b733:	8b 15 24 ab 12 c0    	mov    0xc012ab24,%edx
c010b739:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010b73f:	6b f0 05             	imul   $0x5,%eax,%esi
c010b742:	01 f7                	add    %esi,%edi
c010b744:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010b749:	f7 e6                	mul    %esi
c010b74b:	8d 34 17             	lea    (%edi,%edx,1),%esi
c010b74e:	89 f2                	mov    %esi,%edx
c010b750:	83 c0 0b             	add    $0xb,%eax
c010b753:	83 d2 00             	adc    $0x0,%edx
c010b756:	89 c7                	mov    %eax,%edi
c010b758:	83 e7 ff             	and    $0xffffffff,%edi
c010b75b:	89 f9                	mov    %edi,%ecx
c010b75d:	0f b7 da             	movzwl %dx,%ebx
c010b760:	89 0d 20 ab 12 c0    	mov    %ecx,0xc012ab20
c010b766:	89 1d 24 ab 12 c0    	mov    %ebx,0xc012ab24
    unsigned long long result = (next >> 12);
c010b76c:	a1 20 ab 12 c0       	mov    0xc012ab20,%eax
c010b771:	8b 15 24 ab 12 c0    	mov    0xc012ab24,%edx
c010b777:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010b77b:	c1 ea 0c             	shr    $0xc,%edx
c010b77e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b781:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c010b784:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010b78b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b78e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b791:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010b794:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010b797:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b79a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b79d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b7a1:	74 1c                	je     c010b7bf <rand+0x9a>
c010b7a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b7a6:	ba 00 00 00 00       	mov    $0x0,%edx
c010b7ab:	f7 75 dc             	divl   -0x24(%ebp)
c010b7ae:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010b7b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b7b4:	ba 00 00 00 00       	mov    $0x0,%edx
c010b7b9:	f7 75 dc             	divl   -0x24(%ebp)
c010b7bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b7bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b7c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b7c5:	f7 75 dc             	divl   -0x24(%ebp)
c010b7c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010b7cb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010b7ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b7d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010b7d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b7d7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010b7da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c010b7dd:	83 c4 24             	add    $0x24,%esp
c010b7e0:	5b                   	pop    %ebx
c010b7e1:	5e                   	pop    %esi
c010b7e2:	5f                   	pop    %edi
c010b7e3:	5d                   	pop    %ebp
c010b7e4:	c3                   	ret    

c010b7e5 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c010b7e5:	55                   	push   %ebp
c010b7e6:	89 e5                	mov    %esp,%ebp
    next = seed;
c010b7e8:	8b 45 08             	mov    0x8(%ebp),%eax
c010b7eb:	ba 00 00 00 00       	mov    $0x0,%edx
c010b7f0:	a3 20 ab 12 c0       	mov    %eax,0xc012ab20
c010b7f5:	89 15 24 ab 12 c0    	mov    %edx,0xc012ab24
}
c010b7fb:	5d                   	pop    %ebp
c010b7fc:	c3                   	ret    

c010b7fd <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010b7fd:	55                   	push   %ebp
c010b7fe:	89 e5                	mov    %esp,%ebp
c010b800:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010b803:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010b80a:	eb 04                	jmp    c010b810 <strlen+0x13>
        cnt ++;
c010b80c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010b810:	8b 45 08             	mov    0x8(%ebp),%eax
c010b813:	8d 50 01             	lea    0x1(%eax),%edx
c010b816:	89 55 08             	mov    %edx,0x8(%ebp)
c010b819:	0f b6 00             	movzbl (%eax),%eax
c010b81c:	84 c0                	test   %al,%al
c010b81e:	75 ec                	jne    c010b80c <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010b820:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010b823:	c9                   	leave  
c010b824:	c3                   	ret    

c010b825 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010b825:	55                   	push   %ebp
c010b826:	89 e5                	mov    %esp,%ebp
c010b828:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010b82b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010b832:	eb 04                	jmp    c010b838 <strnlen+0x13>
        cnt ++;
c010b834:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010b838:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010b83b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010b83e:	73 10                	jae    c010b850 <strnlen+0x2b>
c010b840:	8b 45 08             	mov    0x8(%ebp),%eax
c010b843:	8d 50 01             	lea    0x1(%eax),%edx
c010b846:	89 55 08             	mov    %edx,0x8(%ebp)
c010b849:	0f b6 00             	movzbl (%eax),%eax
c010b84c:	84 c0                	test   %al,%al
c010b84e:	75 e4                	jne    c010b834 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010b850:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010b853:	c9                   	leave  
c010b854:	c3                   	ret    

c010b855 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010b855:	55                   	push   %ebp
c010b856:	89 e5                	mov    %esp,%ebp
c010b858:	57                   	push   %edi
c010b859:	56                   	push   %esi
c010b85a:	83 ec 20             	sub    $0x20,%esp
c010b85d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b860:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b863:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b866:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010b869:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010b86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b86f:	89 d1                	mov    %edx,%ecx
c010b871:	89 c2                	mov    %eax,%edx
c010b873:	89 ce                	mov    %ecx,%esi
c010b875:	89 d7                	mov    %edx,%edi
c010b877:	ac                   	lods   %ds:(%esi),%al
c010b878:	aa                   	stos   %al,%es:(%edi)
c010b879:	84 c0                	test   %al,%al
c010b87b:	75 fa                	jne    c010b877 <strcpy+0x22>
c010b87d:	89 fa                	mov    %edi,%edx
c010b87f:	89 f1                	mov    %esi,%ecx
c010b881:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010b884:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010b887:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010b88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010b88d:	83 c4 20             	add    $0x20,%esp
c010b890:	5e                   	pop    %esi
c010b891:	5f                   	pop    %edi
c010b892:	5d                   	pop    %ebp
c010b893:	c3                   	ret    

c010b894 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010b894:	55                   	push   %ebp
c010b895:	89 e5                	mov    %esp,%ebp
c010b897:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010b89a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b89d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010b8a0:	eb 21                	jmp    c010b8c3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010b8a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b8a5:	0f b6 10             	movzbl (%eax),%edx
c010b8a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010b8ab:	88 10                	mov    %dl,(%eax)
c010b8ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010b8b0:	0f b6 00             	movzbl (%eax),%eax
c010b8b3:	84 c0                	test   %al,%al
c010b8b5:	74 04                	je     c010b8bb <strncpy+0x27>
            src ++;
c010b8b7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010b8bb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010b8bf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010b8c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b8c7:	75 d9                	jne    c010b8a2 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010b8c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010b8cc:	c9                   	leave  
c010b8cd:	c3                   	ret    

c010b8ce <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010b8ce:	55                   	push   %ebp
c010b8cf:	89 e5                	mov    %esp,%ebp
c010b8d1:	57                   	push   %edi
c010b8d2:	56                   	push   %esi
c010b8d3:	83 ec 20             	sub    $0x20,%esp
c010b8d6:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b8dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b8df:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010b8e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b8e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b8e8:	89 d1                	mov    %edx,%ecx
c010b8ea:	89 c2                	mov    %eax,%edx
c010b8ec:	89 ce                	mov    %ecx,%esi
c010b8ee:	89 d7                	mov    %edx,%edi
c010b8f0:	ac                   	lods   %ds:(%esi),%al
c010b8f1:	ae                   	scas   %es:(%edi),%al
c010b8f2:	75 08                	jne    c010b8fc <strcmp+0x2e>
c010b8f4:	84 c0                	test   %al,%al
c010b8f6:	75 f8                	jne    c010b8f0 <strcmp+0x22>
c010b8f8:	31 c0                	xor    %eax,%eax
c010b8fa:	eb 04                	jmp    c010b900 <strcmp+0x32>
c010b8fc:	19 c0                	sbb    %eax,%eax
c010b8fe:	0c 01                	or     $0x1,%al
c010b900:	89 fa                	mov    %edi,%edx
c010b902:	89 f1                	mov    %esi,%ecx
c010b904:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b907:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010b90a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c010b90d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010b910:	83 c4 20             	add    $0x20,%esp
c010b913:	5e                   	pop    %esi
c010b914:	5f                   	pop    %edi
c010b915:	5d                   	pop    %ebp
c010b916:	c3                   	ret    

c010b917 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010b917:	55                   	push   %ebp
c010b918:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010b91a:	eb 0c                	jmp    c010b928 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010b91c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b920:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010b924:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010b928:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b92c:	74 1a                	je     c010b948 <strncmp+0x31>
c010b92e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b931:	0f b6 00             	movzbl (%eax),%eax
c010b934:	84 c0                	test   %al,%al
c010b936:	74 10                	je     c010b948 <strncmp+0x31>
c010b938:	8b 45 08             	mov    0x8(%ebp),%eax
c010b93b:	0f b6 10             	movzbl (%eax),%edx
c010b93e:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b941:	0f b6 00             	movzbl (%eax),%eax
c010b944:	38 c2                	cmp    %al,%dl
c010b946:	74 d4                	je     c010b91c <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010b948:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b94c:	74 18                	je     c010b966 <strncmp+0x4f>
c010b94e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b951:	0f b6 00             	movzbl (%eax),%eax
c010b954:	0f b6 d0             	movzbl %al,%edx
c010b957:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b95a:	0f b6 00             	movzbl (%eax),%eax
c010b95d:	0f b6 c0             	movzbl %al,%eax
c010b960:	29 c2                	sub    %eax,%edx
c010b962:	89 d0                	mov    %edx,%eax
c010b964:	eb 05                	jmp    c010b96b <strncmp+0x54>
c010b966:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b96b:	5d                   	pop    %ebp
c010b96c:	c3                   	ret    

c010b96d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010b96d:	55                   	push   %ebp
c010b96e:	89 e5                	mov    %esp,%ebp
c010b970:	83 ec 04             	sub    $0x4,%esp
c010b973:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b976:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010b979:	eb 14                	jmp    c010b98f <strchr+0x22>
        if (*s == c) {
c010b97b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b97e:	0f b6 00             	movzbl (%eax),%eax
c010b981:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010b984:	75 05                	jne    c010b98b <strchr+0x1e>
            return (char *)s;
c010b986:	8b 45 08             	mov    0x8(%ebp),%eax
c010b989:	eb 13                	jmp    c010b99e <strchr+0x31>
        }
        s ++;
c010b98b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010b98f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b992:	0f b6 00             	movzbl (%eax),%eax
c010b995:	84 c0                	test   %al,%al
c010b997:	75 e2                	jne    c010b97b <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010b999:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b99e:	c9                   	leave  
c010b99f:	c3                   	ret    

c010b9a0 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010b9a0:	55                   	push   %ebp
c010b9a1:	89 e5                	mov    %esp,%ebp
c010b9a3:	83 ec 04             	sub    $0x4,%esp
c010b9a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b9a9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010b9ac:	eb 11                	jmp    c010b9bf <strfind+0x1f>
        if (*s == c) {
c010b9ae:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9b1:	0f b6 00             	movzbl (%eax),%eax
c010b9b4:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010b9b7:	75 02                	jne    c010b9bb <strfind+0x1b>
            break;
c010b9b9:	eb 0e                	jmp    c010b9c9 <strfind+0x29>
        }
        s ++;
c010b9bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010b9bf:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9c2:	0f b6 00             	movzbl (%eax),%eax
c010b9c5:	84 c0                	test   %al,%al
c010b9c7:	75 e5                	jne    c010b9ae <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010b9c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010b9cc:	c9                   	leave  
c010b9cd:	c3                   	ret    

c010b9ce <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010b9ce:	55                   	push   %ebp
c010b9cf:	89 e5                	mov    %esp,%ebp
c010b9d1:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010b9d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010b9db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010b9e2:	eb 04                	jmp    c010b9e8 <strtol+0x1a>
        s ++;
c010b9e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010b9e8:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9eb:	0f b6 00             	movzbl (%eax),%eax
c010b9ee:	3c 20                	cmp    $0x20,%al
c010b9f0:	74 f2                	je     c010b9e4 <strtol+0x16>
c010b9f2:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9f5:	0f b6 00             	movzbl (%eax),%eax
c010b9f8:	3c 09                	cmp    $0x9,%al
c010b9fa:	74 e8                	je     c010b9e4 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c010b9fc:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9ff:	0f b6 00             	movzbl (%eax),%eax
c010ba02:	3c 2b                	cmp    $0x2b,%al
c010ba04:	75 06                	jne    c010ba0c <strtol+0x3e>
        s ++;
c010ba06:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010ba0a:	eb 15                	jmp    c010ba21 <strtol+0x53>
    }
    else if (*s == '-') {
c010ba0c:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba0f:	0f b6 00             	movzbl (%eax),%eax
c010ba12:	3c 2d                	cmp    $0x2d,%al
c010ba14:	75 0b                	jne    c010ba21 <strtol+0x53>
        s ++, neg = 1;
c010ba16:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010ba1a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010ba21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010ba25:	74 06                	je     c010ba2d <strtol+0x5f>
c010ba27:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010ba2b:	75 24                	jne    c010ba51 <strtol+0x83>
c010ba2d:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba30:	0f b6 00             	movzbl (%eax),%eax
c010ba33:	3c 30                	cmp    $0x30,%al
c010ba35:	75 1a                	jne    c010ba51 <strtol+0x83>
c010ba37:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba3a:	83 c0 01             	add    $0x1,%eax
c010ba3d:	0f b6 00             	movzbl (%eax),%eax
c010ba40:	3c 78                	cmp    $0x78,%al
c010ba42:	75 0d                	jne    c010ba51 <strtol+0x83>
        s += 2, base = 16;
c010ba44:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010ba48:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010ba4f:	eb 2a                	jmp    c010ba7b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010ba51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010ba55:	75 17                	jne    c010ba6e <strtol+0xa0>
c010ba57:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba5a:	0f b6 00             	movzbl (%eax),%eax
c010ba5d:	3c 30                	cmp    $0x30,%al
c010ba5f:	75 0d                	jne    c010ba6e <strtol+0xa0>
        s ++, base = 8;
c010ba61:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010ba65:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010ba6c:	eb 0d                	jmp    c010ba7b <strtol+0xad>
    }
    else if (base == 0) {
c010ba6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010ba72:	75 07                	jne    c010ba7b <strtol+0xad>
        base = 10;
c010ba74:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010ba7b:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba7e:	0f b6 00             	movzbl (%eax),%eax
c010ba81:	3c 2f                	cmp    $0x2f,%al
c010ba83:	7e 1b                	jle    c010baa0 <strtol+0xd2>
c010ba85:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba88:	0f b6 00             	movzbl (%eax),%eax
c010ba8b:	3c 39                	cmp    $0x39,%al
c010ba8d:	7f 11                	jg     c010baa0 <strtol+0xd2>
            dig = *s - '0';
c010ba8f:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba92:	0f b6 00             	movzbl (%eax),%eax
c010ba95:	0f be c0             	movsbl %al,%eax
c010ba98:	83 e8 30             	sub    $0x30,%eax
c010ba9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010ba9e:	eb 48                	jmp    c010bae8 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010baa0:	8b 45 08             	mov    0x8(%ebp),%eax
c010baa3:	0f b6 00             	movzbl (%eax),%eax
c010baa6:	3c 60                	cmp    $0x60,%al
c010baa8:	7e 1b                	jle    c010bac5 <strtol+0xf7>
c010baaa:	8b 45 08             	mov    0x8(%ebp),%eax
c010baad:	0f b6 00             	movzbl (%eax),%eax
c010bab0:	3c 7a                	cmp    $0x7a,%al
c010bab2:	7f 11                	jg     c010bac5 <strtol+0xf7>
            dig = *s - 'a' + 10;
c010bab4:	8b 45 08             	mov    0x8(%ebp),%eax
c010bab7:	0f b6 00             	movzbl (%eax),%eax
c010baba:	0f be c0             	movsbl %al,%eax
c010babd:	83 e8 57             	sub    $0x57,%eax
c010bac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bac3:	eb 23                	jmp    c010bae8 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010bac5:	8b 45 08             	mov    0x8(%ebp),%eax
c010bac8:	0f b6 00             	movzbl (%eax),%eax
c010bacb:	3c 40                	cmp    $0x40,%al
c010bacd:	7e 3d                	jle    c010bb0c <strtol+0x13e>
c010bacf:	8b 45 08             	mov    0x8(%ebp),%eax
c010bad2:	0f b6 00             	movzbl (%eax),%eax
c010bad5:	3c 5a                	cmp    $0x5a,%al
c010bad7:	7f 33                	jg     c010bb0c <strtol+0x13e>
            dig = *s - 'A' + 10;
c010bad9:	8b 45 08             	mov    0x8(%ebp),%eax
c010badc:	0f b6 00             	movzbl (%eax),%eax
c010badf:	0f be c0             	movsbl %al,%eax
c010bae2:	83 e8 37             	sub    $0x37,%eax
c010bae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010bae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010baeb:	3b 45 10             	cmp    0x10(%ebp),%eax
c010baee:	7c 02                	jl     c010baf2 <strtol+0x124>
            break;
c010baf0:	eb 1a                	jmp    c010bb0c <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c010baf2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010baf6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010baf9:	0f af 45 10          	imul   0x10(%ebp),%eax
c010bafd:	89 c2                	mov    %eax,%edx
c010baff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010bb02:	01 d0                	add    %edx,%eax
c010bb04:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010bb07:	e9 6f ff ff ff       	jmp    c010ba7b <strtol+0xad>

    if (endptr) {
c010bb0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010bb10:	74 08                	je     c010bb1a <strtol+0x14c>
        *endptr = (char *) s;
c010bb12:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bb15:	8b 55 08             	mov    0x8(%ebp),%edx
c010bb18:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010bb1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010bb1e:	74 07                	je     c010bb27 <strtol+0x159>
c010bb20:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bb23:	f7 d8                	neg    %eax
c010bb25:	eb 03                	jmp    c010bb2a <strtol+0x15c>
c010bb27:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010bb2a:	c9                   	leave  
c010bb2b:	c3                   	ret    

c010bb2c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010bb2c:	55                   	push   %ebp
c010bb2d:	89 e5                	mov    %esp,%ebp
c010bb2f:	57                   	push   %edi
c010bb30:	83 ec 24             	sub    $0x24,%esp
c010bb33:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bb36:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010bb39:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010bb3d:	8b 55 08             	mov    0x8(%ebp),%edx
c010bb40:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010bb43:	88 45 f7             	mov    %al,-0x9(%ebp)
c010bb46:	8b 45 10             	mov    0x10(%ebp),%eax
c010bb49:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010bb4c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010bb4f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010bb53:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010bb56:	89 d7                	mov    %edx,%edi
c010bb58:	f3 aa                	rep stos %al,%es:(%edi)
c010bb5a:	89 fa                	mov    %edi,%edx
c010bb5c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010bb5f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010bb62:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010bb65:	83 c4 24             	add    $0x24,%esp
c010bb68:	5f                   	pop    %edi
c010bb69:	5d                   	pop    %ebp
c010bb6a:	c3                   	ret    

c010bb6b <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010bb6b:	55                   	push   %ebp
c010bb6c:	89 e5                	mov    %esp,%ebp
c010bb6e:	57                   	push   %edi
c010bb6f:	56                   	push   %esi
c010bb70:	53                   	push   %ebx
c010bb71:	83 ec 30             	sub    $0x30,%esp
c010bb74:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb77:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010bb7a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bb7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010bb80:	8b 45 10             	mov    0x10(%ebp),%eax
c010bb83:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010bb86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bb89:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010bb8c:	73 42                	jae    c010bbd0 <memmove+0x65>
c010bb8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bb91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010bb94:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bb97:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010bb9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bb9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010bba0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010bba3:	c1 e8 02             	shr    $0x2,%eax
c010bba6:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010bba8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010bbab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010bbae:	89 d7                	mov    %edx,%edi
c010bbb0:	89 c6                	mov    %eax,%esi
c010bbb2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010bbb4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010bbb7:	83 e1 03             	and    $0x3,%ecx
c010bbba:	74 02                	je     c010bbbe <memmove+0x53>
c010bbbc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bbbe:	89 f0                	mov    %esi,%eax
c010bbc0:	89 fa                	mov    %edi,%edx
c010bbc2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010bbc5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010bbc8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010bbcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010bbce:	eb 36                	jmp    c010bc06 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010bbd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bbd3:	8d 50 ff             	lea    -0x1(%eax),%edx
c010bbd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bbd9:	01 c2                	add    %eax,%edx
c010bbdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bbde:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010bbe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bbe4:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c010bbe7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bbea:	89 c1                	mov    %eax,%ecx
c010bbec:	89 d8                	mov    %ebx,%eax
c010bbee:	89 d6                	mov    %edx,%esi
c010bbf0:	89 c7                	mov    %eax,%edi
c010bbf2:	fd                   	std    
c010bbf3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bbf5:	fc                   	cld    
c010bbf6:	89 f8                	mov    %edi,%eax
c010bbf8:	89 f2                	mov    %esi,%edx
c010bbfa:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010bbfd:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010bc00:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010bc03:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010bc06:	83 c4 30             	add    $0x30,%esp
c010bc09:	5b                   	pop    %ebx
c010bc0a:	5e                   	pop    %esi
c010bc0b:	5f                   	pop    %edi
c010bc0c:	5d                   	pop    %ebp
c010bc0d:	c3                   	ret    

c010bc0e <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010bc0e:	55                   	push   %ebp
c010bc0f:	89 e5                	mov    %esp,%ebp
c010bc11:	57                   	push   %edi
c010bc12:	56                   	push   %esi
c010bc13:	83 ec 20             	sub    $0x20,%esp
c010bc16:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc19:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bc1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bc1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010bc22:	8b 45 10             	mov    0x10(%ebp),%eax
c010bc25:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010bc28:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bc2b:	c1 e8 02             	shr    $0x2,%eax
c010bc2e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010bc30:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010bc33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bc36:	89 d7                	mov    %edx,%edi
c010bc38:	89 c6                	mov    %eax,%esi
c010bc3a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010bc3c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010bc3f:	83 e1 03             	and    $0x3,%ecx
c010bc42:	74 02                	je     c010bc46 <memcpy+0x38>
c010bc44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bc46:	89 f0                	mov    %esi,%eax
c010bc48:	89 fa                	mov    %edi,%edx
c010bc4a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010bc4d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010bc50:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010bc53:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010bc56:	83 c4 20             	add    $0x20,%esp
c010bc59:	5e                   	pop    %esi
c010bc5a:	5f                   	pop    %edi
c010bc5b:	5d                   	pop    %ebp
c010bc5c:	c3                   	ret    

c010bc5d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010bc5d:	55                   	push   %ebp
c010bc5e:	89 e5                	mov    %esp,%ebp
c010bc60:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010bc63:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc66:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010bc69:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bc6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010bc6f:	eb 30                	jmp    c010bca1 <memcmp+0x44>
        if (*s1 != *s2) {
c010bc71:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bc74:	0f b6 10             	movzbl (%eax),%edx
c010bc77:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bc7a:	0f b6 00             	movzbl (%eax),%eax
c010bc7d:	38 c2                	cmp    %al,%dl
c010bc7f:	74 18                	je     c010bc99 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010bc81:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bc84:	0f b6 00             	movzbl (%eax),%eax
c010bc87:	0f b6 d0             	movzbl %al,%edx
c010bc8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bc8d:	0f b6 00             	movzbl (%eax),%eax
c010bc90:	0f b6 c0             	movzbl %al,%eax
c010bc93:	29 c2                	sub    %eax,%edx
c010bc95:	89 d0                	mov    %edx,%eax
c010bc97:	eb 1a                	jmp    c010bcb3 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010bc99:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010bc9d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010bca1:	8b 45 10             	mov    0x10(%ebp),%eax
c010bca4:	8d 50 ff             	lea    -0x1(%eax),%edx
c010bca7:	89 55 10             	mov    %edx,0x10(%ebp)
c010bcaa:	85 c0                	test   %eax,%eax
c010bcac:	75 c3                	jne    c010bc71 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010bcae:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010bcb3:	c9                   	leave  
c010bcb4:	c3                   	ret    
