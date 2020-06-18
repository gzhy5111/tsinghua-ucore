
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 40 12 00 	lgdtl  0x124018
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
c010001e:	bc 00 40 12 c0       	mov    $0xc0124000,%esp
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
c0100030:	ba 18 7c 12 c0       	mov    $0xc0127c18,%edx
c0100035:	b8 90 4a 12 c0       	mov    $0xc0124a90,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 90 4a 12 c0 	movl   $0xc0124a90,(%esp)
c0100051:	e8 db 9a 00 00       	call   c0109b31 <memset>

    cons_init();                // init the console
c0100056:	e8 88 15 00 00       	call   c01015e3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 c0 9c 10 c0 	movl   $0xc0109cc0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 dc 9c 10 c0 	movl   $0xc0109cdc,(%esp)
c0100070:	e8 de 02 00 00       	call   c0100353 <cprintf>

    print_kerninfo();
c0100075:	e8 0d 08 00 00       	call   c0100887 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 9d 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 11 53 00 00       	call   c0105395 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 38 1f 00 00       	call   c0101fc1 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 8a 20 00 00       	call   c0102118 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 4b 79 00 00       	call   c01079de <vmm_init>

    // proc_init函数启动了创建内核线程的步骤。
    proc_init();                // init process table
c0100093:	e8 8f 8c 00 00       	call   c0108d27 <proc_init>
    
    ide_init();                 // init ide devices
c0100098:	e8 77 16 00 00       	call   c0101714 <ide_init>
    swap_init();                // init swap
c010009d:	e8 81 65 00 00       	call   c0106623 <swap_init>

    clock_init();               // init clock interrupt
c01000a2:	e8 f2 0c 00 00       	call   c0100d99 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a7:	e8 83 1e 00 00       	call   c0101f2f <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    // 执行线程
    cpu_idle();                 // run idle process
c01000ac:	e8 35 8e 00 00       	call   c0108ee6 <cpu_idle>

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
c01000ce:	e8 f8 0b 00 00       	call   c0100ccb <mon_backtrace>
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
c010015f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 e1 9c 10 c0 	movl   $0xc0109ce1,(%esp)
c0100173:	e8 db 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	0f b7 d0             	movzwl %ax,%edx
c010017f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100184:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100188:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018c:	c7 04 24 ef 9c 10 c0 	movl   $0xc0109cef,(%esp)
c0100193:	e8 bb 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100198:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ac:	c7 04 24 fd 9c 10 c0 	movl   $0xc0109cfd,(%esp)
c01001b3:	e8 9b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bc:	0f b7 d0             	movzwl %ax,%edx
c01001bf:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001cc:	c7 04 24 0b 9d 10 c0 	movl   $0xc0109d0b,(%esp)
c01001d3:	e8 7b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001dc:	0f b7 d0             	movzwl %ax,%edx
c01001df:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ec:	c7 04 24 19 9d 10 c0 	movl   $0xc0109d19,(%esp)
c01001f3:	e8 5b 01 00 00       	call   c0100353 <cprintf>
    round ++;
c01001f8:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001fd:	83 c0 01             	add    $0x1,%eax
c0100200:	a3 a0 4a 12 c0       	mov    %eax,0xc0124aa0
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
c010021c:	c7 04 24 28 9d 10 c0 	movl   $0xc0109d28,(%esp)
c0100223:	e8 2b 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_user();
c0100228:	e8 da ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 0f ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 48 9d 10 c0 	movl   $0xc0109d48,(%esp)
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
c010025d:	c7 04 24 67 9d 10 c0 	movl   $0xc0109d67,(%esp)
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
c01002ab:	88 90 c0 4a 12 c0    	mov    %dl,-0x3fedb540(%eax)
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
c01002ea:	05 c0 4a 12 c0       	add    $0xc0124ac0,%eax
c01002ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f2:	b8 c0 4a 12 c0       	mov    $0xc0124ac0,%eax
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
c010030c:	e8 fe 12 00 00       	call   c010160f <cons_putc>
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
c0100349:	e8 24 8f 00 00       	call   c0109272 <vprintfmt>
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
c0100385:	e8 85 12 00 00       	call   c010160f <cons_putc>
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
c01003e1:	e8 65 12 00 00       	call   c010164b <cons_getc>
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
c0100553:	c7 00 6c 9d 10 c0    	movl   $0xc0109d6c,(%eax)
    info->eip_line = 0;
c0100559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 08 6c 9d 10 c0 	movl   $0xc0109d6c,0x8(%eax)
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

    stabs = __STAB_BEGIN__;
c010058a:	c7 45 f4 dc be 10 c0 	movl   $0xc010bedc,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100591:	c7 45 f0 14 d1 11 c0 	movl   $0xc011d114,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100598:	c7 45 ec 15 d1 11 c0 	movl   $0xc011d115,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010059f:	c7 45 e8 db 18 12 c0 	movl   $0xc01218db,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005ac:	76 0d                	jbe    c01005bb <debuginfo_eip+0x71>
c01005ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b1:	83 e8 01             	sub    $0x1,%eax
c01005b4:	0f b6 00             	movzbl (%eax),%eax
c01005b7:	84 c0                	test   %al,%al
c01005b9:	74 0a                	je     c01005c5 <debuginfo_eip+0x7b>
        return -1;
c01005bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c0:	e9 c0 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005d2:	29 c2                	sub    %eax,%edx
c01005d4:	89 d0                	mov    %edx,%eax
c01005d6:	c1 f8 02             	sar    $0x2,%eax
c01005d9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005df:	83 e8 01             	sub    $0x1,%eax
c01005e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005ec:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f3:	00 
c01005f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100602:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100605:	89 04 24             	mov    %eax,(%esp)
c0100608:	e8 e7 fd ff ff       	call   c01003f4 <stab_binsearch>
    if (lfile == 0)
c010060d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100610:	85 c0                	test   %eax,%eax
c0100612:	75 0a                	jne    c010061e <debuginfo_eip+0xd4>
        return -1;
c0100614:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100619:	e9 67 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010061e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100621:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100624:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100627:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010062a:	8b 45 08             	mov    0x8(%ebp),%eax
c010062d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100631:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100638:	00 
c0100639:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010063c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100640:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100643:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100647:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010064a:	89 04 24             	mov    %eax,(%esp)
c010064d:	e8 a2 fd ff ff       	call   c01003f4 <stab_binsearch>

    if (lfun <= rfun) {
c0100652:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100655:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100658:	39 c2                	cmp    %eax,%edx
c010065a:	7f 7c                	jg     c01006d8 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010065c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	89 d0                	mov    %edx,%eax
c0100663:	01 c0                	add    %eax,%eax
c0100665:	01 d0                	add    %edx,%eax
c0100667:	c1 e0 02             	shl    $0x2,%eax
c010066a:	89 c2                	mov    %eax,%edx
c010066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066f:	01 d0                	add    %edx,%eax
c0100671:	8b 10                	mov    (%eax),%edx
c0100673:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100676:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100679:	29 c1                	sub    %eax,%ecx
c010067b:	89 c8                	mov    %ecx,%eax
c010067d:	39 c2                	cmp    %eax,%edx
c010067f:	73 22                	jae    c01006a3 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100681:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	89 d0                	mov    %edx,%eax
c0100688:	01 c0                	add    %eax,%eax
c010068a:	01 d0                	add    %edx,%eax
c010068c:	c1 e0 02             	shl    $0x2,%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100694:	01 d0                	add    %edx,%eax
c0100696:	8b 10                	mov    (%eax),%edx
c0100698:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010069b:	01 c2                	add    %eax,%edx
c010069d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a0:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	89 d0                	mov    %edx,%eax
c01006aa:	01 c0                	add    %eax,%eax
c01006ac:	01 d0                	add    %edx,%eax
c01006ae:	c1 e0 02             	shl    $0x2,%eax
c01006b1:	89 c2                	mov    %eax,%edx
c01006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b6:	01 d0                	add    %edx,%eax
c01006b8:	8b 50 08             	mov    0x8(%eax),%edx
c01006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006be:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 40 10             	mov    0x10(%eax),%eax
c01006c7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006d6:	eb 15                	jmp    c01006ed <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006db:	8b 55 08             	mov    0x8(%ebp),%edx
c01006de:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f0:	8b 40 08             	mov    0x8(%eax),%eax
c01006f3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006fa:	00 
c01006fb:	89 04 24             	mov    %eax,(%esp)
c01006fe:	e8 a2 92 00 00       	call   c01099a5 <strfind>
c0100703:	89 c2                	mov    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	8b 40 08             	mov    0x8(%eax),%eax
c010070b:	29 c2                	sub    %eax,%edx
c010070d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100710:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100713:	8b 45 08             	mov    0x8(%ebp),%eax
c0100716:	89 44 24 10          	mov    %eax,0x10(%esp)
c010071a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100721:	00 
c0100722:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100725:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100729:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010072c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100733:	89 04 24             	mov    %eax,(%esp)
c0100736:	e8 b9 fc ff ff       	call   c01003f4 <stab_binsearch>
    if (lline <= rline) {
c010073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010073e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100741:	39 c2                	cmp    %eax,%edx
c0100743:	7f 24                	jg     c0100769 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100745:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	89 d0                	mov    %edx,%eax
c010074c:	01 c0                	add    %eax,%eax
c010074e:	01 d0                	add    %edx,%eax
c0100750:	c1 e0 02             	shl    $0x2,%eax
c0100753:	89 c2                	mov    %eax,%edx
c0100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100758:	01 d0                	add    %edx,%eax
c010075a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010075e:	0f b7 d0             	movzwl %ax,%edx
c0100761:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100764:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100767:	eb 13                	jmp    c010077c <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100769:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010076e:	e9 12 01 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100773:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100776:	83 e8 01             	sub    $0x1,%eax
c0100779:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010077c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010077f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100782:	39 c2                	cmp    %eax,%edx
c0100784:	7c 56                	jl     c01007dc <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100786:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	89 d0                	mov    %edx,%eax
c010078d:	01 c0                	add    %eax,%eax
c010078f:	01 d0                	add    %edx,%eax
c0100791:	c1 e0 02             	shl    $0x2,%eax
c0100794:	89 c2                	mov    %eax,%edx
c0100796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100799:	01 d0                	add    %edx,%eax
c010079b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010079f:	3c 84                	cmp    $0x84,%al
c01007a1:	74 39                	je     c01007dc <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01007a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	89 d0                	mov    %edx,%eax
c01007aa:	01 c0                	add    %eax,%eax
c01007ac:	01 d0                	add    %edx,%eax
c01007ae:	c1 e0 02             	shl    $0x2,%eax
c01007b1:	89 c2                	mov    %eax,%edx
c01007b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b6:	01 d0                	add    %edx,%eax
c01007b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007bc:	3c 64                	cmp    $0x64,%al
c01007be:	75 b3                	jne    c0100773 <debuginfo_eip+0x229>
c01007c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	89 d0                	mov    %edx,%eax
c01007c7:	01 c0                	add    %eax,%eax
c01007c9:	01 d0                	add    %edx,%eax
c01007cb:	c1 e0 02             	shl    $0x2,%eax
c01007ce:	89 c2                	mov    %eax,%edx
c01007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d3:	01 d0                	add    %edx,%eax
c01007d5:	8b 40 08             	mov    0x8(%eax),%eax
c01007d8:	85 c0                	test   %eax,%eax
c01007da:	74 97                	je     c0100773 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e2:	39 c2                	cmp    %eax,%edx
c01007e4:	7c 46                	jl     c010082c <debuginfo_eip+0x2e2>
c01007e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	89 d0                	mov    %edx,%eax
c01007ed:	01 c0                	add    %eax,%eax
c01007ef:	01 d0                	add    %edx,%eax
c01007f1:	c1 e0 02             	shl    $0x2,%eax
c01007f4:	89 c2                	mov    %eax,%edx
c01007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f9:	01 d0                	add    %edx,%eax
c01007fb:	8b 10                	mov    (%eax),%edx
c01007fd:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100800:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100803:	29 c1                	sub    %eax,%ecx
c0100805:	89 c8                	mov    %ecx,%eax
c0100807:	39 c2                	cmp    %eax,%edx
c0100809:	73 21                	jae    c010082c <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	89 d0                	mov    %edx,%eax
c0100812:	01 c0                	add    %eax,%eax
c0100814:	01 d0                	add    %edx,%eax
c0100816:	c1 e0 02             	shl    $0x2,%eax
c0100819:	89 c2                	mov    %eax,%edx
c010081b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081e:	01 d0                	add    %edx,%eax
c0100820:	8b 10                	mov    (%eax),%edx
c0100822:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100825:	01 c2                	add    %eax,%edx
c0100827:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010082c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010082f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100832:	39 c2                	cmp    %eax,%edx
c0100834:	7d 4a                	jge    c0100880 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c0100836:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100839:	83 c0 01             	add    $0x1,%eax
c010083c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010083f:	eb 18                	jmp    c0100859 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100841:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100844:	8b 40 14             	mov    0x14(%eax),%eax
c0100847:	8d 50 01             	lea    0x1(%eax),%edx
c010084a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010084d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100853:	83 c0 01             	add    $0x1,%eax
c0100856:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100859:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010085c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010085f:	39 c2                	cmp    %eax,%edx
c0100861:	7d 1d                	jge    c0100880 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100863:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	89 d0                	mov    %edx,%eax
c010086a:	01 c0                	add    %eax,%eax
c010086c:	01 d0                	add    %edx,%eax
c010086e:	c1 e0 02             	shl    $0x2,%eax
c0100871:	89 c2                	mov    %eax,%edx
c0100873:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100876:	01 d0                	add    %edx,%eax
c0100878:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010087c:	3c a0                	cmp    $0xa0,%al
c010087e:	74 c1                	je     c0100841 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100880:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100885:	c9                   	leave  
c0100886:	c3                   	ret    

c0100887 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100887:	55                   	push   %ebp
c0100888:	89 e5                	mov    %esp,%ebp
c010088a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010088d:	c7 04 24 76 9d 10 c0 	movl   $0xc0109d76,(%esp)
c0100894:	e8 ba fa ff ff       	call   c0100353 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100899:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c01008a0:	c0 
c01008a1:	c7 04 24 8f 9d 10 c0 	movl   $0xc0109d8f,(%esp)
c01008a8:	e8 a6 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ad:	c7 44 24 04 ba 9c 10 	movl   $0xc0109cba,0x4(%esp)
c01008b4:	c0 
c01008b5:	c7 04 24 a7 9d 10 c0 	movl   $0xc0109da7,(%esp)
c01008bc:	e8 92 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c1:	c7 44 24 04 90 4a 12 	movl   $0xc0124a90,0x4(%esp)
c01008c8:	c0 
c01008c9:	c7 04 24 bf 9d 10 c0 	movl   $0xc0109dbf,(%esp)
c01008d0:	e8 7e fa ff ff       	call   c0100353 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d5:	c7 44 24 04 18 7c 12 	movl   $0xc0127c18,0x4(%esp)
c01008dc:	c0 
c01008dd:	c7 04 24 d7 9d 10 c0 	movl   $0xc0109dd7,(%esp)
c01008e4:	e8 6a fa ff ff       	call   c0100353 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e9:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c01008ee:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f9:	29 c2                	sub    %eax,%edx
c01008fb:	89 d0                	mov    %edx,%eax
c01008fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100903:	85 c0                	test   %eax,%eax
c0100905:	0f 48 c2             	cmovs  %edx,%eax
c0100908:	c1 f8 0a             	sar    $0xa,%eax
c010090b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090f:	c7 04 24 f0 9d 10 c0 	movl   $0xc0109df0,(%esp)
c0100916:	e8 38 fa ff ff       	call   c0100353 <cprintf>
}
c010091b:	c9                   	leave  
c010091c:	c3                   	ret    

c010091d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010091d:	55                   	push   %ebp
c010091e:	89 e5                	mov    %esp,%ebp
c0100920:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100926:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100929:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100930:	89 04 24             	mov    %eax,(%esp)
c0100933:	e8 12 fc ff ff       	call   c010054a <debuginfo_eip>
c0100938:	85 c0                	test   %eax,%eax
c010093a:	74 15                	je     c0100951 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010093c:	8b 45 08             	mov    0x8(%ebp),%eax
c010093f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100943:	c7 04 24 1a 9e 10 c0 	movl   $0xc0109e1a,(%esp)
c010094a:	e8 04 fa ff ff       	call   c0100353 <cprintf>
c010094f:	eb 6d                	jmp    c01009be <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100958:	eb 1c                	jmp    c0100976 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010095a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010095d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100960:	01 d0                	add    %edx,%eax
c0100962:	0f b6 00             	movzbl (%eax),%eax
c0100965:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010096b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010096e:	01 ca                	add    %ecx,%edx
c0100970:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100972:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100976:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100979:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010097c:	7f dc                	jg     c010095a <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c010097e:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100984:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100987:	01 d0                	add    %edx,%eax
c0100989:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c010098c:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010098f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100992:	89 d1                	mov    %edx,%ecx
c0100994:	29 c1                	sub    %eax,%ecx
c0100996:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100999:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010099c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01009a0:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009a6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009aa:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b2:	c7 04 24 36 9e 10 c0 	movl   $0xc0109e36,(%esp)
c01009b9:	e8 95 f9 ff ff       	call   c0100353 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009be:	c9                   	leave  
c01009bf:	c3                   	ret    

c01009c0 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009c0:	55                   	push   %ebp
c01009c1:	89 e5                	mov    %esp,%ebp
c01009c3:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009c6:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009cf:	c9                   	leave  
c01009d0:	c3                   	ret    

c01009d1 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009d1:	55                   	push   %ebp
c01009d2:	89 e5                	mov    %esp,%ebp
c01009d4:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009d7:	89 e8                	mov    %ebp,%eax
c01009d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c01009df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009e2:	e8 d9 ff ff ff       	call   c01009c0 <read_eip>
c01009e7:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// 循环打印，直到 STACKFRAME_DEPTH 栈的深度已经最大，并且还要满足ebp ！= 0
	int i;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
c01009ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f1:	e9 88 00 00 00       	jmp    c0100a7e <print_stackframe+0xad>
		cprintf("ebp: 0x%08x eip: 0x%08x args: ", ebp, eip);
c01009f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a04:	c7 04 24 48 9e 10 c0 	movl   $0xc0109e48,(%esp)
c0100a0b:	e8 43 f9 ff ff       	call   c0100353 <cprintf>

		// ebp + 2才是第一个参数的地址，具体可以看笔记
		uint32_t *args = (uint32_t *)ebp + 2;
c0100a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a13:	83 c0 08             	add    $0x8,%eax
c0100a16:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		// 循环打印4个args
		int j;
		for (j = 0; j < 4; j++) {
c0100a19:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a20:	eb 25                	jmp    c0100a47 <print_stackframe+0x76>
			cprintf("0x%08x ", args[j]);
c0100a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a2f:	01 d0                	add    %edx,%eax
c0100a31:	8b 00                	mov    (%eax),%eax
c0100a33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a37:	c7 04 24 67 9e 10 c0 	movl   $0xc0109e67,(%esp)
c0100a3e:	e8 10 f9 ff ff       	call   c0100353 <cprintf>
		// ebp + 2才是第一个参数的地址，具体可以看笔记
		uint32_t *args = (uint32_t *)ebp + 2;

		// 循环打印4个args
		int j;
		for (j = 0; j < 4; j++) {
c0100a43:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a47:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4b:	7e d5                	jle    c0100a22 <print_stackframe+0x51>
			cprintf("0x%08x ", args[j]);
		}
		cprintf("\n");
c0100a4d:	c7 04 24 6f 9e 10 c0 	movl   $0xc0109e6f,(%esp)
c0100a54:	e8 fa f8 ff ff       	call   c0100353 <cprintf>

		// 打印 kern/debug/kdebug.c:305: print_stackframe+22 类似这行的东西，应该是调试信息
		print_debuginfo(eip-1);
c0100a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a5c:	83 e8 01             	sub    $0x1,%eax
c0100a5f:	89 04 24             	mov    %eax,(%esp)
c0100a62:	e8 b6 fe ff ff       	call   c010091d <print_debuginfo>

		// 先把eip指向ebp+1的位置，即函数的返回地址（Return Address）
		eip = *((uint32_t *)ebp + 1);
c0100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6a:	83 c0 04             	add    $0x4,%eax
c0100a6d:	8b 00                	mov    (%eax),%eax
c0100a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)

		// ebp的内容给ebp回到上层调用函数
		ebp = *((uint32_t *)ebp);
c0100a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a75:	8b 00                	mov    (%eax),%eax
c0100a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();

	// 循环打印，直到 STACKFRAME_DEPTH 栈的深度已经最大，并且还要满足ebp ！= 0
	int i;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
c0100a7a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a7e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a82:	7f 0a                	jg     c0100a8e <print_stackframe+0xbd>
c0100a84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a88:	0f 85 68 ff ff ff    	jne    c01009f6 <print_stackframe+0x25>
		eip = *((uint32_t *)ebp + 1);

		// ebp的内容给ebp回到上层调用函数
		ebp = *((uint32_t *)ebp);
	}
}
c0100a8e:	c9                   	leave  
c0100a8f:	c3                   	ret    

c0100a90 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a90:	55                   	push   %ebp
c0100a91:	89 e5                	mov    %esp,%ebp
c0100a93:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9d:	eb 0c                	jmp    c0100aab <parse+0x1b>
            *buf ++ = '\0';
c0100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa2:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa5:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa8:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aae:	0f b6 00             	movzbl (%eax),%eax
c0100ab1:	84 c0                	test   %al,%al
c0100ab3:	74 1d                	je     c0100ad2 <parse+0x42>
c0100ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab8:	0f b6 00             	movzbl (%eax),%eax
c0100abb:	0f be c0             	movsbl %al,%eax
c0100abe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac2:	c7 04 24 f4 9e 10 c0 	movl   $0xc0109ef4,(%esp)
c0100ac9:	e8 a4 8e 00 00       	call   c0109972 <strchr>
c0100ace:	85 c0                	test   %eax,%eax
c0100ad0:	75 cd                	jne    c0100a9f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad5:	0f b6 00             	movzbl (%eax),%eax
c0100ad8:	84 c0                	test   %al,%al
c0100ada:	75 02                	jne    c0100ade <parse+0x4e>
            break;
c0100adc:	eb 67                	jmp    c0100b45 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ade:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae2:	75 14                	jne    c0100af8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aeb:	00 
c0100aec:	c7 04 24 f9 9e 10 c0 	movl   $0xc0109ef9,(%esp)
c0100af3:	e8 5b f8 ff ff       	call   c0100353 <cprintf>
        }
        argv[argc ++] = buf;
c0100af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afb:	8d 50 01             	lea    0x1(%eax),%edx
c0100afe:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0b:	01 c2                	add    %eax,%edx
c0100b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b10:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b12:	eb 04                	jmp    c0100b18 <parse+0x88>
            buf ++;
c0100b14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1b:	0f b6 00             	movzbl (%eax),%eax
c0100b1e:	84 c0                	test   %al,%al
c0100b20:	74 1d                	je     c0100b3f <parse+0xaf>
c0100b22:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b25:	0f b6 00             	movzbl (%eax),%eax
c0100b28:	0f be c0             	movsbl %al,%eax
c0100b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2f:	c7 04 24 f4 9e 10 c0 	movl   $0xc0109ef4,(%esp)
c0100b36:	e8 37 8e 00 00       	call   c0109972 <strchr>
c0100b3b:	85 c0                	test   %eax,%eax
c0100b3d:	74 d5                	je     c0100b14 <parse+0x84>
            buf ++;
        }
    }
c0100b3f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b40:	e9 66 ff ff ff       	jmp    c0100aab <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b48:	c9                   	leave  
c0100b49:	c3                   	ret    

c0100b4a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b4a:	55                   	push   %ebp
c0100b4b:	89 e5                	mov    %esp,%ebp
c0100b4d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b50:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b57:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5a:	89 04 24             	mov    %eax,(%esp)
c0100b5d:	e8 2e ff ff ff       	call   c0100a90 <parse>
c0100b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b69:	75 0a                	jne    c0100b75 <runcmd+0x2b>
        return 0;
c0100b6b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b70:	e9 85 00 00 00       	jmp    c0100bfa <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b7c:	eb 5c                	jmp    c0100bda <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b7e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b84:	89 d0                	mov    %edx,%eax
c0100b86:	01 c0                	add    %eax,%eax
c0100b88:	01 d0                	add    %edx,%eax
c0100b8a:	c1 e0 02             	shl    $0x2,%eax
c0100b8d:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100b92:	8b 00                	mov    (%eax),%eax
c0100b94:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b98:	89 04 24             	mov    %eax,(%esp)
c0100b9b:	e8 33 8d 00 00       	call   c01098d3 <strcmp>
c0100ba0:	85 c0                	test   %eax,%eax
c0100ba2:	75 32                	jne    c0100bd6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ba7:	89 d0                	mov    %edx,%eax
c0100ba9:	01 c0                	add    %eax,%eax
c0100bab:	01 d0                	add    %edx,%eax
c0100bad:	c1 e0 02             	shl    $0x2,%eax
c0100bb0:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100bb5:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bbb:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bc1:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bc5:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc8:	83 c2 04             	add    $0x4,%edx
c0100bcb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bcf:	89 0c 24             	mov    %ecx,(%esp)
c0100bd2:	ff d0                	call   *%eax
c0100bd4:	eb 24                	jmp    c0100bfa <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bdd:	83 f8 02             	cmp    $0x2,%eax
c0100be0:	76 9c                	jbe    c0100b7e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be9:	c7 04 24 17 9f 10 c0 	movl   $0xc0109f17,(%esp)
c0100bf0:	e8 5e f7 ff ff       	call   c0100353 <cprintf>
    return 0;
c0100bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bfa:	c9                   	leave  
c0100bfb:	c3                   	ret    

c0100bfc <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bfc:	55                   	push   %ebp
c0100bfd:	89 e5                	mov    %esp,%ebp
c0100bff:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c02:	c7 04 24 30 9f 10 c0 	movl   $0xc0109f30,(%esp)
c0100c09:	e8 45 f7 ff ff       	call   c0100353 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c0e:	c7 04 24 58 9f 10 c0 	movl   $0xc0109f58,(%esp)
c0100c15:	e8 39 f7 ff ff       	call   c0100353 <cprintf>

    if (tf != NULL) {
c0100c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c1e:	74 0b                	je     c0100c2b <kmonitor+0x2f>
        print_trapframe(tf);
c0100c20:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c23:	89 04 24             	mov    %eax,(%esp)
c0100c26:	e8 a5 16 00 00       	call   c01022d0 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c2b:	c7 04 24 7d 9f 10 c0 	movl   $0xc0109f7d,(%esp)
c0100c32:	e8 13 f6 ff ff       	call   c010024a <readline>
c0100c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c3e:	74 18                	je     c0100c58 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c40:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c4a:	89 04 24             	mov    %eax,(%esp)
c0100c4d:	e8 f8 fe ff ff       	call   c0100b4a <runcmd>
c0100c52:	85 c0                	test   %eax,%eax
c0100c54:	79 02                	jns    c0100c58 <kmonitor+0x5c>
                break;
c0100c56:	eb 02                	jmp    c0100c5a <kmonitor+0x5e>
            }
        }
    }
c0100c58:	eb d1                	jmp    c0100c2b <kmonitor+0x2f>
}
c0100c5a:	c9                   	leave  
c0100c5b:	c3                   	ret    

c0100c5c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c5c:	55                   	push   %ebp
c0100c5d:	89 e5                	mov    %esp,%ebp
c0100c5f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c69:	eb 3f                	jmp    c0100caa <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6e:	89 d0                	mov    %edx,%eax
c0100c70:	01 c0                	add    %eax,%eax
c0100c72:	01 d0                	add    %edx,%eax
c0100c74:	c1 e0 02             	shl    $0x2,%eax
c0100c77:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c7c:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c82:	89 d0                	mov    %edx,%eax
c0100c84:	01 c0                	add    %eax,%eax
c0100c86:	01 d0                	add    %edx,%eax
c0100c88:	c1 e0 02             	shl    $0x2,%eax
c0100c8b:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c90:	8b 00                	mov    (%eax),%eax
c0100c92:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c9a:	c7 04 24 81 9f 10 c0 	movl   $0xc0109f81,(%esp)
c0100ca1:	e8 ad f6 ff ff       	call   c0100353 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cad:	83 f8 02             	cmp    $0x2,%eax
c0100cb0:	76 b9                	jbe    c0100c6b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb7:	c9                   	leave  
c0100cb8:	c3                   	ret    

c0100cb9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb9:	55                   	push   %ebp
c0100cba:	89 e5                	mov    %esp,%ebp
c0100cbc:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cbf:	e8 c3 fb ff ff       	call   c0100887 <print_kerninfo>
    return 0;
c0100cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc9:	c9                   	leave  
c0100cca:	c3                   	ret    

c0100ccb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ccb:	55                   	push   %ebp
c0100ccc:	89 e5                	mov    %esp,%ebp
c0100cce:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cd1:	e8 fb fc ff ff       	call   c01009d1 <print_stackframe>
    return 0;
c0100cd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cdb:	c9                   	leave  
c0100cdc:	c3                   	ret    

c0100cdd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cdd:	55                   	push   %ebp
c0100cde:	89 e5                	mov    %esp,%ebp
c0100ce0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce3:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
c0100ce8:	85 c0                	test   %eax,%eax
c0100cea:	74 02                	je     c0100cee <__panic+0x11>
        goto panic_dead;
c0100cec:	eb 48                	jmp    c0100d36 <__panic+0x59>
    }
    is_panic = 1;
c0100cee:	c7 05 c0 4e 12 c0 01 	movl   $0x1,0xc0124ec0
c0100cf5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf8:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d01:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0c:	c7 04 24 8a 9f 10 c0 	movl   $0xc0109f8a,(%esp)
c0100d13:	e8 3b f6 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d22:	89 04 24             	mov    %eax,(%esp)
c0100d25:	e8 f6 f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d2a:	c7 04 24 a6 9f 10 c0 	movl   $0xc0109fa6,(%esp)
c0100d31:	e8 1d f6 ff ff       	call   c0100353 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d36:	e8 fa 11 00 00       	call   c0101f35 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d42:	e8 b5 fe ff ff       	call   c0100bfc <kmonitor>
    }
c0100d47:	eb f2                	jmp    c0100d3b <__panic+0x5e>

c0100d49 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d49:	55                   	push   %ebp
c0100d4a:	89 e5                	mov    %esp,%ebp
c0100d4c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d4f:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d58:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d63:	c7 04 24 a8 9f 10 c0 	movl   $0xc0109fa8,(%esp)
c0100d6a:	e8 e4 f5 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d76:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d79:	89 04 24             	mov    %eax,(%esp)
c0100d7c:	e8 9f f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d81:	c7 04 24 a6 9f 10 c0 	movl   $0xc0109fa6,(%esp)
c0100d88:	e8 c6 f5 ff ff       	call   c0100353 <cprintf>
    va_end(ap);
}
c0100d8d:	c9                   	leave  
c0100d8e:	c3                   	ret    

c0100d8f <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d8f:	55                   	push   %ebp
c0100d90:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d92:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
}
c0100d97:	5d                   	pop    %ebp
c0100d98:	c3                   	ret    

c0100d99 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d99:	55                   	push   %ebp
c0100d9a:	89 e5                	mov    %esp,%ebp
c0100d9c:	83 ec 28             	sub    $0x28,%esp
c0100d9f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100da5:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dad:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db1:	ee                   	out    %al,(%dx)
c0100db2:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db8:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dbc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dc4:	ee                   	out    %al,(%dx)
c0100dc5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dcb:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dcf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd8:	c7 05 14 7b 12 c0 00 	movl   $0x0,0xc0127b14
c0100ddf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de2:	c7 04 24 c6 9f 10 c0 	movl   $0xc0109fc6,(%esp)
c0100de9:	e8 65 f5 ff ff       	call   c0100353 <cprintf>
    pic_enable(IRQ_TIMER);
c0100dee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df5:	e8 99 11 00 00       	call   c0101f93 <pic_enable>
}
c0100dfa:	c9                   	leave  
c0100dfb:	c3                   	ret    

c0100dfc <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dfc:	55                   	push   %ebp
c0100dfd:	89 e5                	mov    %esp,%ebp
c0100dff:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e02:	9c                   	pushf  
c0100e03:	58                   	pop    %eax
c0100e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e0a:	25 00 02 00 00       	and    $0x200,%eax
c0100e0f:	85 c0                	test   %eax,%eax
c0100e11:	74 0c                	je     c0100e1f <__intr_save+0x23>
        intr_disable();
c0100e13:	e8 1d 11 00 00       	call   c0101f35 <intr_disable>
        return 1;
c0100e18:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e1d:	eb 05                	jmp    c0100e24 <__intr_save+0x28>
    }
    return 0;
c0100e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e24:	c9                   	leave  
c0100e25:	c3                   	ret    

c0100e26 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e26:	55                   	push   %ebp
c0100e27:	89 e5                	mov    %esp,%ebp
c0100e29:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e30:	74 05                	je     c0100e37 <__intr_restore+0x11>
        intr_enable();
c0100e32:	e8 f8 10 00 00       	call   c0101f2f <intr_enable>
    }
}
c0100e37:	c9                   	leave  
c0100e38:	c3                   	ret    

c0100e39 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e39:	55                   	push   %ebp
c0100e3a:	89 e5                	mov    %esp,%ebp
c0100e3c:	83 ec 10             	sub    $0x10,%esp
c0100e3f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e45:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e49:	89 c2                	mov    %eax,%edx
c0100e4b:	ec                   	in     (%dx),%al
c0100e4c:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e4f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e55:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e59:	89 c2                	mov    %eax,%edx
c0100e5b:	ec                   	in     (%dx),%al
c0100e5c:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e5f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e65:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e69:	89 c2                	mov    %eax,%edx
c0100e6b:	ec                   	in     (%dx),%al
c0100e6c:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e6f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e75:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e79:	89 c2                	mov    %eax,%edx
c0100e7b:	ec                   	in     (%dx),%al
c0100e7c:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e7f:	c9                   	leave  
c0100e80:	c3                   	ret    

c0100e81 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e81:	55                   	push   %ebp
c0100e82:	89 e5                	mov    %esp,%ebp
c0100e84:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e87:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e91:	0f b7 00             	movzwl (%eax),%eax
c0100e94:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea3:	0f b7 00             	movzwl (%eax),%eax
c0100ea6:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100eaa:	74 12                	je     c0100ebe <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eac:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eb3:	66 c7 05 e6 4e 12 c0 	movw   $0x3b4,0xc0124ee6
c0100eba:	b4 03 
c0100ebc:	eb 13                	jmp    c0100ed1 <cga_init+0x50>
    } else {
        *cp = was;
c0100ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ec5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec8:	66 c7 05 e6 4e 12 c0 	movw   $0x3d4,0xc0124ee6
c0100ecf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed1:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100ed8:	0f b7 c0             	movzwl %ax,%eax
c0100edb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100edf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ee7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eeb:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eec:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100ef3:	83 c0 01             	add    $0x1,%eax
c0100ef6:	0f b7 c0             	movzwl %ax,%eax
c0100ef9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100efd:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f01:	89 c2                	mov    %eax,%edx
c0100f03:	ec                   	in     (%dx),%al
c0100f04:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f07:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0b:	0f b6 c0             	movzbl %al,%eax
c0100f0e:	c1 e0 08             	shl    $0x8,%eax
c0100f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f14:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f1b:	0f b7 c0             	movzwl %ax,%eax
c0100f1e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f22:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f26:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f2a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f2e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2f:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f36:	83 c0 01             	add    $0x1,%eax
c0100f39:	0f b7 c0             	movzwl %ax,%eax
c0100f3c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f40:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f44:	89 c2                	mov    %eax,%edx
c0100f46:	ec                   	in     (%dx),%al
c0100f47:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f4a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f4e:	0f b6 c0             	movzbl %al,%eax
c0100f51:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f57:	a3 e0 4e 12 c0       	mov    %eax,0xc0124ee0
    crt_pos = pos;
c0100f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f5f:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
}
c0100f65:	c9                   	leave  
c0100f66:	c3                   	ret    

c0100f67 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f67:	55                   	push   %ebp
c0100f68:	89 e5                	mov    %esp,%ebp
c0100f6a:	83 ec 48             	sub    $0x48,%esp
c0100f6d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f73:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f77:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f7b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f7f:	ee                   	out    %al,(%dx)
c0100f80:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f86:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f8a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f8e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f92:	ee                   	out    %al,(%dx)
c0100f93:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f99:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f9d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fa1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa5:	ee                   	out    %al,(%dx)
c0100fa6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fac:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fb0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fb4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb8:	ee                   	out    %al,(%dx)
c0100fb9:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fbf:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fc3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fcb:	ee                   	out    %al,(%dx)
c0100fcc:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fd2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fd6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fda:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fde:	ee                   	out    %al,(%dx)
c0100fdf:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe5:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fed:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff1:	ee                   	out    %al,(%dx)
c0100ff2:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff8:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ffc:	89 c2                	mov    %eax,%edx
c0100ffe:	ec                   	in     (%dx),%al
c0100fff:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101002:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101006:	3c ff                	cmp    $0xff,%al
c0101008:	0f 95 c0             	setne  %al
c010100b:	0f b6 c0             	movzbl %al,%eax
c010100e:	a3 e8 4e 12 c0       	mov    %eax,0xc0124ee8
c0101013:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101019:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010101d:	89 c2                	mov    %eax,%edx
c010101f:	ec                   	in     (%dx),%al
c0101020:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101023:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101029:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010102d:	89 c2                	mov    %eax,%edx
c010102f:	ec                   	in     (%dx),%al
c0101030:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101033:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c0101038:	85 c0                	test   %eax,%eax
c010103a:	74 0c                	je     c0101048 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010103c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101043:	e8 4b 0f 00 00       	call   c0101f93 <pic_enable>
    }
}
c0101048:	c9                   	leave  
c0101049:	c3                   	ret    

c010104a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010104a:	55                   	push   %ebp
c010104b:	89 e5                	mov    %esp,%ebp
c010104d:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101050:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101057:	eb 09                	jmp    c0101062 <lpt_putc_sub+0x18>
        delay();
c0101059:	e8 db fd ff ff       	call   c0100e39 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010105e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101062:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101068:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010106c:	89 c2                	mov    %eax,%edx
c010106e:	ec                   	in     (%dx),%al
c010106f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101072:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101076:	84 c0                	test   %al,%al
c0101078:	78 09                	js     c0101083 <lpt_putc_sub+0x39>
c010107a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101081:	7e d6                	jle    c0101059 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101083:	8b 45 08             	mov    0x8(%ebp),%eax
c0101086:	0f b6 c0             	movzbl %al,%eax
c0101089:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010108f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101092:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101096:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010109a:	ee                   	out    %al,(%dx)
c010109b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010a1:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010ad:	ee                   	out    %al,(%dx)
c01010ae:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010b4:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010bc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010c0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010c1:	c9                   	leave  
c01010c2:	c3                   	ret    

c01010c3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c3:	55                   	push   %ebp
c01010c4:	89 e5                	mov    %esp,%ebp
c01010c6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010cd:	74 0d                	je     c01010dc <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d2:	89 04 24             	mov    %eax,(%esp)
c01010d5:	e8 70 ff ff ff       	call   c010104a <lpt_putc_sub>
c01010da:	eb 24                	jmp    c0101100 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010dc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e3:	e8 62 ff ff ff       	call   c010104a <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010ef:	e8 56 ff ff ff       	call   c010104a <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010fb:	e8 4a ff ff ff       	call   c010104a <lpt_putc_sub>
    }
}
c0101100:	c9                   	leave  
c0101101:	c3                   	ret    

c0101102 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101102:	55                   	push   %ebp
c0101103:	89 e5                	mov    %esp,%ebp
c0101105:	53                   	push   %ebx
c0101106:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101109:	8b 45 08             	mov    0x8(%ebp),%eax
c010110c:	b0 00                	mov    $0x0,%al
c010110e:	85 c0                	test   %eax,%eax
c0101110:	75 07                	jne    c0101119 <cga_putc+0x17>
        c |= 0x0700;
c0101112:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101119:	8b 45 08             	mov    0x8(%ebp),%eax
c010111c:	0f b6 c0             	movzbl %al,%eax
c010111f:	83 f8 0a             	cmp    $0xa,%eax
c0101122:	74 4c                	je     c0101170 <cga_putc+0x6e>
c0101124:	83 f8 0d             	cmp    $0xd,%eax
c0101127:	74 57                	je     c0101180 <cga_putc+0x7e>
c0101129:	83 f8 08             	cmp    $0x8,%eax
c010112c:	0f 85 88 00 00 00    	jne    c01011ba <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101132:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101139:	66 85 c0             	test   %ax,%ax
c010113c:	74 30                	je     c010116e <cga_putc+0x6c>
            crt_pos --;
c010113e:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101145:	83 e8 01             	sub    $0x1,%eax
c0101148:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010114e:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c0101153:	0f b7 15 e4 4e 12 c0 	movzwl 0xc0124ee4,%edx
c010115a:	0f b7 d2             	movzwl %dx,%edx
c010115d:	01 d2                	add    %edx,%edx
c010115f:	01 c2                	add    %eax,%edx
c0101161:	8b 45 08             	mov    0x8(%ebp),%eax
c0101164:	b0 00                	mov    $0x0,%al
c0101166:	83 c8 20             	or     $0x20,%eax
c0101169:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010116c:	eb 72                	jmp    c01011e0 <cga_putc+0xde>
c010116e:	eb 70                	jmp    c01011e0 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101170:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101177:	83 c0 50             	add    $0x50,%eax
c010117a:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101180:	0f b7 1d e4 4e 12 c0 	movzwl 0xc0124ee4,%ebx
c0101187:	0f b7 0d e4 4e 12 c0 	movzwl 0xc0124ee4,%ecx
c010118e:	0f b7 c1             	movzwl %cx,%eax
c0101191:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101197:	c1 e8 10             	shr    $0x10,%eax
c010119a:	89 c2                	mov    %eax,%edx
c010119c:	66 c1 ea 06          	shr    $0x6,%dx
c01011a0:	89 d0                	mov    %edx,%eax
c01011a2:	c1 e0 02             	shl    $0x2,%eax
c01011a5:	01 d0                	add    %edx,%eax
c01011a7:	c1 e0 04             	shl    $0x4,%eax
c01011aa:	29 c1                	sub    %eax,%ecx
c01011ac:	89 ca                	mov    %ecx,%edx
c01011ae:	89 d8                	mov    %ebx,%eax
c01011b0:	29 d0                	sub    %edx,%eax
c01011b2:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
        break;
c01011b8:	eb 26                	jmp    c01011e0 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011ba:	8b 0d e0 4e 12 c0    	mov    0xc0124ee0,%ecx
c01011c0:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011c7:	8d 50 01             	lea    0x1(%eax),%edx
c01011ca:	66 89 15 e4 4e 12 c0 	mov    %dx,0xc0124ee4
c01011d1:	0f b7 c0             	movzwl %ax,%eax
c01011d4:	01 c0                	add    %eax,%eax
c01011d6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01011dc:	66 89 02             	mov    %ax,(%edx)
        break;
c01011df:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011e0:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011e7:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011eb:	76 5b                	jbe    c0101248 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ed:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c01011f2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f8:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c01011fd:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101204:	00 
c0101205:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101209:	89 04 24             	mov    %eax,(%esp)
c010120c:	e8 5f 89 00 00       	call   c0109b70 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101211:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101218:	eb 15                	jmp    c010122f <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010121a:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c010121f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101222:	01 d2                	add    %edx,%edx
c0101224:	01 d0                	add    %edx,%eax
c0101226:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010122b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010122f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101236:	7e e2                	jle    c010121a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101238:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c010123f:	83 e8 50             	sub    $0x50,%eax
c0101242:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101248:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c010124f:	0f b7 c0             	movzwl %ax,%eax
c0101252:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101256:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010125a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010125e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101262:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101263:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c010126a:	66 c1 e8 08          	shr    $0x8,%ax
c010126e:	0f b6 c0             	movzbl %al,%eax
c0101271:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c0101278:	83 c2 01             	add    $0x1,%edx
c010127b:	0f b7 d2             	movzwl %dx,%edx
c010127e:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101282:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101285:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101289:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010128d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010128e:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0101295:	0f b7 c0             	movzwl %ax,%eax
c0101298:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010129c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012a0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012a4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a9:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01012b0:	0f b6 c0             	movzbl %al,%eax
c01012b3:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c01012ba:	83 c2 01             	add    $0x1,%edx
c01012bd:	0f b7 d2             	movzwl %dx,%edx
c01012c0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012c4:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012cb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012cf:	ee                   	out    %al,(%dx)
}
c01012d0:	83 c4 34             	add    $0x34,%esp
c01012d3:	5b                   	pop    %ebx
c01012d4:	5d                   	pop    %ebp
c01012d5:	c3                   	ret    

c01012d6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d6:	55                   	push   %ebp
c01012d7:	89 e5                	mov    %esp,%ebp
c01012d9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e3:	eb 09                	jmp    c01012ee <serial_putc_sub+0x18>
        delay();
c01012e5:	e8 4f fb ff ff       	call   c0100e39 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012ee:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f8:	89 c2                	mov    %eax,%edx
c01012fa:	ec                   	in     (%dx),%al
c01012fb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101302:	0f b6 c0             	movzbl %al,%eax
c0101305:	83 e0 20             	and    $0x20,%eax
c0101308:	85 c0                	test   %eax,%eax
c010130a:	75 09                	jne    c0101315 <serial_putc_sub+0x3f>
c010130c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101313:	7e d0                	jle    c01012e5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101315:	8b 45 08             	mov    0x8(%ebp),%eax
c0101318:	0f b6 c0             	movzbl %al,%eax
c010131b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101321:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101324:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101328:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010132c:	ee                   	out    %al,(%dx)
}
c010132d:	c9                   	leave  
c010132e:	c3                   	ret    

c010132f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010132f:	55                   	push   %ebp
c0101330:	89 e5                	mov    %esp,%ebp
c0101332:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101335:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101339:	74 0d                	je     c0101348 <serial_putc+0x19>
        serial_putc_sub(c);
c010133b:	8b 45 08             	mov    0x8(%ebp),%eax
c010133e:	89 04 24             	mov    %eax,(%esp)
c0101341:	e8 90 ff ff ff       	call   c01012d6 <serial_putc_sub>
c0101346:	eb 24                	jmp    c010136c <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101348:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134f:	e8 82 ff ff ff       	call   c01012d6 <serial_putc_sub>
        serial_putc_sub(' ');
c0101354:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010135b:	e8 76 ff ff ff       	call   c01012d6 <serial_putc_sub>
        serial_putc_sub('\b');
c0101360:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101367:	e8 6a ff ff ff       	call   c01012d6 <serial_putc_sub>
    }
}
c010136c:	c9                   	leave  
c010136d:	c3                   	ret    

c010136e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010136e:	55                   	push   %ebp
c010136f:	89 e5                	mov    %esp,%ebp
c0101371:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101374:	eb 33                	jmp    c01013a9 <cons_intr+0x3b>
        if (c != 0) {
c0101376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010137a:	74 2d                	je     c01013a9 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010137c:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101381:	8d 50 01             	lea    0x1(%eax),%edx
c0101384:	89 15 04 51 12 c0    	mov    %edx,0xc0125104
c010138a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010138d:	88 90 00 4f 12 c0    	mov    %dl,-0x3fedb100(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101393:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101398:	3d 00 02 00 00       	cmp    $0x200,%eax
c010139d:	75 0a                	jne    c01013a9 <cons_intr+0x3b>
                cons.wpos = 0;
c010139f:	c7 05 04 51 12 c0 00 	movl   $0x0,0xc0125104
c01013a6:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ac:	ff d0                	call   *%eax
c01013ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013b1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013b5:	75 bf                	jne    c0101376 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013b7:	c9                   	leave  
c01013b8:	c3                   	ret    

c01013b9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b9:	55                   	push   %ebp
c01013ba:	89 e5                	mov    %esp,%ebp
c01013bc:	83 ec 10             	sub    $0x10,%esp
c01013bf:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c9:	89 c2                	mov    %eax,%edx
c01013cb:	ec                   	in     (%dx),%al
c01013cc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013cf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013d3:	0f b6 c0             	movzbl %al,%eax
c01013d6:	83 e0 01             	and    $0x1,%eax
c01013d9:	85 c0                	test   %eax,%eax
c01013db:	75 07                	jne    c01013e4 <serial_proc_data+0x2b>
        return -1;
c01013dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013e2:	eb 2a                	jmp    c010140e <serial_proc_data+0x55>
c01013e4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ea:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013ee:	89 c2                	mov    %eax,%edx
c01013f0:	ec                   	in     (%dx),%al
c01013f1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013f4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f8:	0f b6 c0             	movzbl %al,%eax
c01013fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013fe:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101402:	75 07                	jne    c010140b <serial_proc_data+0x52>
        c = '\b';
c0101404:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010140e:	c9                   	leave  
c010140f:	c3                   	ret    

c0101410 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101410:	55                   	push   %ebp
c0101411:	89 e5                	mov    %esp,%ebp
c0101413:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101416:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c010141b:	85 c0                	test   %eax,%eax
c010141d:	74 0c                	je     c010142b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010141f:	c7 04 24 b9 13 10 c0 	movl   $0xc01013b9,(%esp)
c0101426:	e8 43 ff ff ff       	call   c010136e <cons_intr>
    }
}
c010142b:	c9                   	leave  
c010142c:	c3                   	ret    

c010142d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010142d:	55                   	push   %ebp
c010142e:	89 e5                	mov    %esp,%ebp
c0101430:	83 ec 38             	sub    $0x38,%esp
c0101433:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101439:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010143d:	89 c2                	mov    %eax,%edx
c010143f:	ec                   	in     (%dx),%al
c0101440:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101443:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101447:	0f b6 c0             	movzbl %al,%eax
c010144a:	83 e0 01             	and    $0x1,%eax
c010144d:	85 c0                	test   %eax,%eax
c010144f:	75 0a                	jne    c010145b <kbd_proc_data+0x2e>
        return -1;
c0101451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101456:	e9 59 01 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
c010145b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101461:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101465:	89 c2                	mov    %eax,%edx
c0101467:	ec                   	in     (%dx),%al
c0101468:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010146b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010146f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101472:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101476:	75 17                	jne    c010148f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101478:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010147d:	83 c8 40             	or     $0x40,%eax
c0101480:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c0101485:	b8 00 00 00 00       	mov    $0x0,%eax
c010148a:	e9 25 01 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101493:	84 c0                	test   %al,%al
c0101495:	79 47                	jns    c01014de <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101497:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010149c:	83 e0 40             	and    $0x40,%eax
c010149f:	85 c0                	test   %eax,%eax
c01014a1:	75 09                	jne    c01014ac <kbd_proc_data+0x7f>
c01014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a7:	83 e0 7f             	and    $0x7f,%eax
c01014aa:	eb 04                	jmp    c01014b0 <kbd_proc_data+0x83>
c01014ac:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b7:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c01014be:	83 c8 40             	or     $0x40,%eax
c01014c1:	0f b6 c0             	movzbl %al,%eax
c01014c4:	f7 d0                	not    %eax
c01014c6:	89 c2                	mov    %eax,%edx
c01014c8:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014cd:	21 d0                	and    %edx,%eax
c01014cf:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c01014d4:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d9:	e9 d6 00 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014de:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014e3:	83 e0 40             	and    $0x40,%eax
c01014e6:	85 c0                	test   %eax,%eax
c01014e8:	74 11                	je     c01014fb <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014ea:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014ee:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014f3:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f6:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    }

    shift |= shiftcode[data];
c01014fb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ff:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c0101506:	0f b6 d0             	movzbl %al,%edx
c0101509:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010150e:	09 d0                	or     %edx,%eax
c0101510:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    shift ^= togglecode[data];
c0101515:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101519:	0f b6 80 60 41 12 c0 	movzbl -0x3fedbea0(%eax),%eax
c0101520:	0f b6 d0             	movzbl %al,%edx
c0101523:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101528:	31 d0                	xor    %edx,%eax
c010152a:	a3 08 51 12 c0       	mov    %eax,0xc0125108

    c = charcode[shift & (CTL | SHIFT)][data];
c010152f:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101534:	83 e0 03             	and    $0x3,%eax
c0101537:	8b 14 85 60 45 12 c0 	mov    -0x3fedbaa0(,%eax,4),%edx
c010153e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101542:	01 d0                	add    %edx,%eax
c0101544:	0f b6 00             	movzbl (%eax),%eax
c0101547:	0f b6 c0             	movzbl %al,%eax
c010154a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010154d:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101552:	83 e0 08             	and    $0x8,%eax
c0101555:	85 c0                	test   %eax,%eax
c0101557:	74 22                	je     c010157b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101559:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010155d:	7e 0c                	jle    c010156b <kbd_proc_data+0x13e>
c010155f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101563:	7f 06                	jg     c010156b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101565:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101569:	eb 10                	jmp    c010157b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010156b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010156f:	7e 0a                	jle    c010157b <kbd_proc_data+0x14e>
c0101571:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101575:	7f 04                	jg     c010157b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101577:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010157b:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101580:	f7 d0                	not    %eax
c0101582:	83 e0 06             	and    $0x6,%eax
c0101585:	85 c0                	test   %eax,%eax
c0101587:	75 28                	jne    c01015b1 <kbd_proc_data+0x184>
c0101589:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101590:	75 1f                	jne    c01015b1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101592:	c7 04 24 e1 9f 10 c0 	movl   $0xc0109fe1,(%esp)
c0101599:	e8 b5 ed ff ff       	call   c0100353 <cprintf>
c010159e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015a4:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a8:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015ac:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015b0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015b4:	c9                   	leave  
c01015b5:	c3                   	ret    

c01015b6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b6:	55                   	push   %ebp
c01015b7:	89 e5                	mov    %esp,%ebp
c01015b9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015bc:	c7 04 24 2d 14 10 c0 	movl   $0xc010142d,(%esp)
c01015c3:	e8 a6 fd ff ff       	call   c010136e <cons_intr>
}
c01015c8:	c9                   	leave  
c01015c9:	c3                   	ret    

c01015ca <kbd_init>:

static void
kbd_init(void) {
c01015ca:	55                   	push   %ebp
c01015cb:	89 e5                	mov    %esp,%ebp
c01015cd:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015d0:	e8 e1 ff ff ff       	call   c01015b6 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015dc:	e8 b2 09 00 00       	call   c0101f93 <pic_enable>
}
c01015e1:	c9                   	leave  
c01015e2:	c3                   	ret    

c01015e3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e3:	55                   	push   %ebp
c01015e4:	89 e5                	mov    %esp,%ebp
c01015e6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e9:	e8 93 f8 ff ff       	call   c0100e81 <cga_init>
    serial_init();
c01015ee:	e8 74 f9 ff ff       	call   c0100f67 <serial_init>
    kbd_init();
c01015f3:	e8 d2 ff ff ff       	call   c01015ca <kbd_init>
    if (!serial_exists) {
c01015f8:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c01015fd:	85 c0                	test   %eax,%eax
c01015ff:	75 0c                	jne    c010160d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101601:	c7 04 24 ed 9f 10 c0 	movl   $0xc0109fed,(%esp)
c0101608:	e8 46 ed ff ff       	call   c0100353 <cprintf>
    }
}
c010160d:	c9                   	leave  
c010160e:	c3                   	ret    

c010160f <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010160f:	55                   	push   %ebp
c0101610:	89 e5                	mov    %esp,%ebp
c0101612:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101615:	e8 e2 f7 ff ff       	call   c0100dfc <__intr_save>
c010161a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010161d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101620:	89 04 24             	mov    %eax,(%esp)
c0101623:	e8 9b fa ff ff       	call   c01010c3 <lpt_putc>
        cga_putc(c);
c0101628:	8b 45 08             	mov    0x8(%ebp),%eax
c010162b:	89 04 24             	mov    %eax,(%esp)
c010162e:	e8 cf fa ff ff       	call   c0101102 <cga_putc>
        serial_putc(c);
c0101633:	8b 45 08             	mov    0x8(%ebp),%eax
c0101636:	89 04 24             	mov    %eax,(%esp)
c0101639:	e8 f1 fc ff ff       	call   c010132f <serial_putc>
    }
    local_intr_restore(intr_flag);
c010163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101641:	89 04 24             	mov    %eax,(%esp)
c0101644:	e8 dd f7 ff ff       	call   c0100e26 <__intr_restore>
}
c0101649:	c9                   	leave  
c010164a:	c3                   	ret    

c010164b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010164b:	55                   	push   %ebp
c010164c:	89 e5                	mov    %esp,%ebp
c010164e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101658:	e8 9f f7 ff ff       	call   c0100dfc <__intr_save>
c010165d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101660:	e8 ab fd ff ff       	call   c0101410 <serial_intr>
        kbd_intr();
c0101665:	e8 4c ff ff ff       	call   c01015b6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010166a:	8b 15 00 51 12 c0    	mov    0xc0125100,%edx
c0101670:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101675:	39 c2                	cmp    %eax,%edx
c0101677:	74 31                	je     c01016aa <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101679:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c010167e:	8d 50 01             	lea    0x1(%eax),%edx
c0101681:	89 15 00 51 12 c0    	mov    %edx,0xc0125100
c0101687:	0f b6 80 00 4f 12 c0 	movzbl -0x3fedb100(%eax),%eax
c010168e:	0f b6 c0             	movzbl %al,%eax
c0101691:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101694:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c0101699:	3d 00 02 00 00       	cmp    $0x200,%eax
c010169e:	75 0a                	jne    c01016aa <cons_getc+0x5f>
                cons.rpos = 0;
c01016a0:	c7 05 00 51 12 c0 00 	movl   $0x0,0xc0125100
c01016a7:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016ad:	89 04 24             	mov    %eax,(%esp)
c01016b0:	e8 71 f7 ff ff       	call   c0100e26 <__intr_restore>
    return c;
c01016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b8:	c9                   	leave  
c01016b9:	c3                   	ret    

c01016ba <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016ba:	55                   	push   %ebp
c01016bb:	89 e5                	mov    %esp,%ebp
c01016bd:	83 ec 14             	sub    $0x14,%esp
c01016c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016c7:	90                   	nop
c01016c8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016cc:	83 c0 07             	add    $0x7,%eax
c01016cf:	0f b7 c0             	movzwl %ax,%eax
c01016d2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016d6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016da:	89 c2                	mov    %eax,%edx
c01016dc:	ec                   	in     (%dx),%al
c01016dd:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016e0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016e4:	0f b6 c0             	movzbl %al,%eax
c01016e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ed:	25 80 00 00 00       	and    $0x80,%eax
c01016f2:	85 c0                	test   %eax,%eax
c01016f4:	75 d2                	jne    c01016c8 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016fa:	74 11                	je     c010170d <ide_wait_ready+0x53>
c01016fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ff:	83 e0 21             	and    $0x21,%eax
c0101702:	85 c0                	test   %eax,%eax
c0101704:	74 07                	je     c010170d <ide_wait_ready+0x53>
        return -1;
c0101706:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010170b:	eb 05                	jmp    c0101712 <ide_wait_ready+0x58>
    }
    return 0;
c010170d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101712:	c9                   	leave  
c0101713:	c3                   	ret    

c0101714 <ide_init>:

void
ide_init(void) {
c0101714:	55                   	push   %ebp
c0101715:	89 e5                	mov    %esp,%ebp
c0101717:	57                   	push   %edi
c0101718:	53                   	push   %ebx
c0101719:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010171f:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101725:	e9 d6 02 00 00       	jmp    c0101a00 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c010172a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010172e:	c1 e0 03             	shl    $0x3,%eax
c0101731:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101738:	29 c2                	sub    %eax,%edx
c010173a:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101740:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101743:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101747:	66 d1 e8             	shr    %ax
c010174a:	0f b7 c0             	movzwl %ax,%eax
c010174d:	0f b7 04 85 0c a0 10 	movzwl -0x3fef5ff4(,%eax,4),%eax
c0101754:	c0 
c0101755:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101759:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010175d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101764:	00 
c0101765:	89 04 24             	mov    %eax,(%esp)
c0101768:	e8 4d ff ff ff       	call   c01016ba <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c010176d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101771:	83 e0 01             	and    $0x1,%eax
c0101774:	c1 e0 04             	shl    $0x4,%eax
c0101777:	83 c8 e0             	or     $0xffffffe0,%eax
c010177a:	0f b6 c0             	movzbl %al,%eax
c010177d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101781:	83 c2 06             	add    $0x6,%edx
c0101784:	0f b7 d2             	movzwl %dx,%edx
c0101787:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c010178b:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010178e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101792:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101796:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101797:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010179b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017a2:	00 
c01017a3:	89 04 24             	mov    %eax,(%esp)
c01017a6:	e8 0f ff ff ff       	call   c01016ba <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017ab:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017af:	83 c0 07             	add    $0x7,%eax
c01017b2:	0f b7 c0             	movzwl %ax,%eax
c01017b5:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017b9:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017bd:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017c1:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017c5:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017c6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017d1:	00 
c01017d2:	89 04 24             	mov    %eax,(%esp)
c01017d5:	e8 e0 fe ff ff       	call   c01016ba <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017da:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017de:	83 c0 07             	add    $0x7,%eax
c01017e1:	0f b7 c0             	movzwl %ax,%eax
c01017e4:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017e8:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017ec:	89 c2                	mov    %eax,%edx
c01017ee:	ec                   	in     (%dx),%al
c01017ef:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017f2:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017f6:	84 c0                	test   %al,%al
c01017f8:	0f 84 f7 01 00 00    	je     c01019f5 <ide_init+0x2e1>
c01017fe:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101802:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101809:	00 
c010180a:	89 04 24             	mov    %eax,(%esp)
c010180d:	e8 a8 fe ff ff       	call   c01016ba <ide_wait_ready>
c0101812:	85 c0                	test   %eax,%eax
c0101814:	0f 85 db 01 00 00    	jne    c01019f5 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c010181a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010181e:	c1 e0 03             	shl    $0x3,%eax
c0101821:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101828:	29 c2                	sub    %eax,%edx
c010182a:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101830:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101833:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101837:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010183a:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101840:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101843:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c010184a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010184d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101850:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101853:	89 cb                	mov    %ecx,%ebx
c0101855:	89 df                	mov    %ebx,%edi
c0101857:	89 c1                	mov    %eax,%ecx
c0101859:	fc                   	cld    
c010185a:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010185c:	89 c8                	mov    %ecx,%eax
c010185e:	89 fb                	mov    %edi,%ebx
c0101860:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101863:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101866:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010186c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c010186f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101872:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101878:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c010187b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010187e:	25 00 00 00 04       	and    $0x4000000,%eax
c0101883:	85 c0                	test   %eax,%eax
c0101885:	74 0e                	je     c0101895 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010188a:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101890:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101893:	eb 09                	jmp    c010189e <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101898:	8b 40 78             	mov    0x78(%eax),%eax
c010189b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c010189e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018a2:	c1 e0 03             	shl    $0x3,%eax
c01018a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018ac:	29 c2                	sub    %eax,%edx
c01018ae:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018b7:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018ba:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018be:	c1 e0 03             	shl    $0x3,%eax
c01018c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c8:	29 c2                	sub    %eax,%edx
c01018ca:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018d3:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018d9:	83 c0 62             	add    $0x62,%eax
c01018dc:	0f b7 00             	movzwl (%eax),%eax
c01018df:	0f b7 c0             	movzwl %ax,%eax
c01018e2:	25 00 02 00 00       	and    $0x200,%eax
c01018e7:	85 c0                	test   %eax,%eax
c01018e9:	75 24                	jne    c010190f <ide_init+0x1fb>
c01018eb:	c7 44 24 0c 14 a0 10 	movl   $0xc010a014,0xc(%esp)
c01018f2:	c0 
c01018f3:	c7 44 24 08 57 a0 10 	movl   $0xc010a057,0x8(%esp)
c01018fa:	c0 
c01018fb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101902:	00 
c0101903:	c7 04 24 6c a0 10 c0 	movl   $0xc010a06c,(%esp)
c010190a:	e8 ce f3 ff ff       	call   c0100cdd <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c010190f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101913:	c1 e0 03             	shl    $0x3,%eax
c0101916:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010191d:	29 c2                	sub    %eax,%edx
c010191f:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101925:	83 c0 0c             	add    $0xc,%eax
c0101928:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010192b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010192e:	83 c0 36             	add    $0x36,%eax
c0101931:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101934:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c010193b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101942:	eb 34                	jmp    c0101978 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101944:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101947:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010194a:	01 c2                	add    %eax,%edx
c010194c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010194f:	8d 48 01             	lea    0x1(%eax),%ecx
c0101952:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101955:	01 c8                	add    %ecx,%eax
c0101957:	0f b6 00             	movzbl (%eax),%eax
c010195a:	88 02                	mov    %al,(%edx)
c010195c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010195f:	8d 50 01             	lea    0x1(%eax),%edx
c0101962:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101965:	01 c2                	add    %eax,%edx
c0101967:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010196a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c010196d:	01 c8                	add    %ecx,%eax
c010196f:	0f b6 00             	movzbl (%eax),%eax
c0101972:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101974:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101978:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010197e:	72 c4                	jb     c0101944 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101980:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101983:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101986:	01 d0                	add    %edx,%eax
c0101988:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010198b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010198e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101991:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101994:	85 c0                	test   %eax,%eax
c0101996:	74 0f                	je     c01019a7 <ide_init+0x293>
c0101998:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010199b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010199e:	01 d0                	add    %edx,%eax
c01019a0:	0f b6 00             	movzbl (%eax),%eax
c01019a3:	3c 20                	cmp    $0x20,%al
c01019a5:	74 d9                	je     c0101980 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01019a7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019ab:	c1 e0 03             	shl    $0x3,%eax
c01019ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019b5:	29 c2                	sub    %eax,%edx
c01019b7:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019bd:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019c0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019c4:	c1 e0 03             	shl    $0x3,%eax
c01019c7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019ce:	29 c2                	sub    %eax,%edx
c01019d0:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019d6:	8b 50 08             	mov    0x8(%eax),%edx
c01019d9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019dd:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019e1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e9:	c7 04 24 7e a0 10 c0 	movl   $0xc010a07e,(%esp)
c01019f0:	e8 5e e9 ff ff       	call   c0100353 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019f5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f9:	83 c0 01             	add    $0x1,%eax
c01019fc:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101a00:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101a05:	0f 86 1f fd ff ff    	jbe    c010172a <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a0b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a12:	e8 7c 05 00 00       	call   c0101f93 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a17:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a1e:	e8 70 05 00 00       	call   c0101f93 <pic_enable>
}
c0101a23:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a29:	5b                   	pop    %ebx
c0101a2a:	5f                   	pop    %edi
c0101a2b:	5d                   	pop    %ebp
c0101a2c:	c3                   	ret    

c0101a2d <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a2d:	55                   	push   %ebp
c0101a2e:	89 e5                	mov    %esp,%ebp
c0101a30:	83 ec 04             	sub    $0x4,%esp
c0101a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a36:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a3a:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a3f:	77 24                	ja     c0101a65 <ide_device_valid+0x38>
c0101a41:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a45:	c1 e0 03             	shl    $0x3,%eax
c0101a48:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a4f:	29 c2                	sub    %eax,%edx
c0101a51:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a57:	0f b6 00             	movzbl (%eax),%eax
c0101a5a:	84 c0                	test   %al,%al
c0101a5c:	74 07                	je     c0101a65 <ide_device_valid+0x38>
c0101a5e:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a63:	eb 05                	jmp    c0101a6a <ide_device_valid+0x3d>
c0101a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a6a:	c9                   	leave  
c0101a6b:	c3                   	ret    

c0101a6c <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a6c:	55                   	push   %ebp
c0101a6d:	89 e5                	mov    %esp,%ebp
c0101a6f:	83 ec 08             	sub    $0x8,%esp
c0101a72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a75:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a79:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a7d:	89 04 24             	mov    %eax,(%esp)
c0101a80:	e8 a8 ff ff ff       	call   c0101a2d <ide_device_valid>
c0101a85:	85 c0                	test   %eax,%eax
c0101a87:	74 1b                	je     c0101aa4 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a89:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a8d:	c1 e0 03             	shl    $0x3,%eax
c0101a90:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a97:	29 c2                	sub    %eax,%edx
c0101a99:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a9f:	8b 40 08             	mov    0x8(%eax),%eax
c0101aa2:	eb 05                	jmp    c0101aa9 <ide_device_size+0x3d>
    }
    return 0;
c0101aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101aa9:	c9                   	leave  
c0101aaa:	c3                   	ret    

c0101aab <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101aab:	55                   	push   %ebp
c0101aac:	89 e5                	mov    %esp,%ebp
c0101aae:	57                   	push   %edi
c0101aaf:	53                   	push   %ebx
c0101ab0:	83 ec 50             	sub    $0x50,%esp
c0101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab6:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101aba:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ac1:	77 24                	ja     c0101ae7 <ide_read_secs+0x3c>
c0101ac3:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101ac8:	77 1d                	ja     c0101ae7 <ide_read_secs+0x3c>
c0101aca:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ace:	c1 e0 03             	shl    $0x3,%eax
c0101ad1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ad8:	29 c2                	sub    %eax,%edx
c0101ada:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101ae0:	0f b6 00             	movzbl (%eax),%eax
c0101ae3:	84 c0                	test   %al,%al
c0101ae5:	75 24                	jne    c0101b0b <ide_read_secs+0x60>
c0101ae7:	c7 44 24 0c 9c a0 10 	movl   $0xc010a09c,0xc(%esp)
c0101aee:	c0 
c0101aef:	c7 44 24 08 57 a0 10 	movl   $0xc010a057,0x8(%esp)
c0101af6:	c0 
c0101af7:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101afe:	00 
c0101aff:	c7 04 24 6c a0 10 c0 	movl   $0xc010a06c,(%esp)
c0101b06:	e8 d2 f1 ff ff       	call   c0100cdd <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b0b:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b12:	77 0f                	ja     c0101b23 <ide_read_secs+0x78>
c0101b14:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b17:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b1a:	01 d0                	add    %edx,%eax
c0101b1c:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b21:	76 24                	jbe    c0101b47 <ide_read_secs+0x9c>
c0101b23:	c7 44 24 0c c4 a0 10 	movl   $0xc010a0c4,0xc(%esp)
c0101b2a:	c0 
c0101b2b:	c7 44 24 08 57 a0 10 	movl   $0xc010a057,0x8(%esp)
c0101b32:	c0 
c0101b33:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b3a:	00 
c0101b3b:	c7 04 24 6c a0 10 c0 	movl   $0xc010a06c,(%esp)
c0101b42:	e8 96 f1 ff ff       	call   c0100cdd <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b47:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b4b:	66 d1 e8             	shr    %ax
c0101b4e:	0f b7 c0             	movzwl %ax,%eax
c0101b51:	0f b7 04 85 0c a0 10 	movzwl -0x3fef5ff4(,%eax,4),%eax
c0101b58:	c0 
c0101b59:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b5d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b61:	66 d1 e8             	shr    %ax
c0101b64:	0f b7 c0             	movzwl %ax,%eax
c0101b67:	0f b7 04 85 0e a0 10 	movzwl -0x3fef5ff2(,%eax,4),%eax
c0101b6e:	c0 
c0101b6f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b73:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b77:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b7e:	00 
c0101b7f:	89 04 24             	mov    %eax,(%esp)
c0101b82:	e8 33 fb ff ff       	call   c01016ba <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b87:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b8b:	83 c0 02             	add    $0x2,%eax
c0101b8e:	0f b7 c0             	movzwl %ax,%eax
c0101b91:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b95:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b99:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b9d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ba1:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ba2:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ba5:	0f b6 c0             	movzbl %al,%eax
c0101ba8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bac:	83 c2 02             	add    $0x2,%edx
c0101baf:	0f b7 d2             	movzwl %dx,%edx
c0101bb2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bb6:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bb9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bbd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bc1:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bc5:	0f b6 c0             	movzbl %al,%eax
c0101bc8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bcc:	83 c2 03             	add    $0x3,%edx
c0101bcf:	0f b7 d2             	movzwl %dx,%edx
c0101bd2:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bd6:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bd9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bdd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101be1:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101be2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101be5:	c1 e8 08             	shr    $0x8,%eax
c0101be8:	0f b6 c0             	movzbl %al,%eax
c0101beb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bef:	83 c2 04             	add    $0x4,%edx
c0101bf2:	0f b7 d2             	movzwl %dx,%edx
c0101bf5:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101bf9:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bfc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101c00:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c04:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c08:	c1 e8 10             	shr    $0x10,%eax
c0101c0b:	0f b6 c0             	movzbl %al,%eax
c0101c0e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c12:	83 c2 05             	add    $0x5,%edx
c0101c15:	0f b7 d2             	movzwl %dx,%edx
c0101c18:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c1c:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c1f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c23:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c27:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c28:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c2c:	83 e0 01             	and    $0x1,%eax
c0101c2f:	c1 e0 04             	shl    $0x4,%eax
c0101c32:	89 c2                	mov    %eax,%edx
c0101c34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c37:	c1 e8 18             	shr    $0x18,%eax
c0101c3a:	83 e0 0f             	and    $0xf,%eax
c0101c3d:	09 d0                	or     %edx,%eax
c0101c3f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c42:	0f b6 c0             	movzbl %al,%eax
c0101c45:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c49:	83 c2 06             	add    $0x6,%edx
c0101c4c:	0f b7 d2             	movzwl %dx,%edx
c0101c4f:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c53:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c56:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c5a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c5e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c5f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c63:	83 c0 07             	add    $0x7,%eax
c0101c66:	0f b7 c0             	movzwl %ax,%eax
c0101c69:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c6d:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c71:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c75:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c79:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c81:	eb 5a                	jmp    c0101cdd <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c83:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c87:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c8e:	00 
c0101c8f:	89 04 24             	mov    %eax,(%esp)
c0101c92:	e8 23 fa ff ff       	call   c01016ba <ide_wait_ready>
c0101c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c9e:	74 02                	je     c0101ca2 <ide_read_secs+0x1f7>
            goto out;
c0101ca0:	eb 41                	jmp    c0101ce3 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101ca2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ca6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ca9:	8b 45 10             	mov    0x10(%ebp),%eax
c0101cac:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101caf:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cb6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cb9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cbc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cbf:	89 cb                	mov    %ecx,%ebx
c0101cc1:	89 df                	mov    %ebx,%edi
c0101cc3:	89 c1                	mov    %eax,%ecx
c0101cc5:	fc                   	cld    
c0101cc6:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cc8:	89 c8                	mov    %ecx,%eax
c0101cca:	89 fb                	mov    %edi,%ebx
c0101ccc:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101ccf:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cd2:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cd6:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cdd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101ce1:	75 a0                	jne    c0101c83 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101ce6:	83 c4 50             	add    $0x50,%esp
c0101ce9:	5b                   	pop    %ebx
c0101cea:	5f                   	pop    %edi
c0101ceb:	5d                   	pop    %ebp
c0101cec:	c3                   	ret    

c0101ced <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101ced:	55                   	push   %ebp
c0101cee:	89 e5                	mov    %esp,%ebp
c0101cf0:	56                   	push   %esi
c0101cf1:	53                   	push   %ebx
c0101cf2:	83 ec 50             	sub    $0x50,%esp
c0101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf8:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cfc:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d03:	77 24                	ja     c0101d29 <ide_write_secs+0x3c>
c0101d05:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d0a:	77 1d                	ja     c0101d29 <ide_write_secs+0x3c>
c0101d0c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d10:	c1 e0 03             	shl    $0x3,%eax
c0101d13:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d1a:	29 c2                	sub    %eax,%edx
c0101d1c:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101d22:	0f b6 00             	movzbl (%eax),%eax
c0101d25:	84 c0                	test   %al,%al
c0101d27:	75 24                	jne    c0101d4d <ide_write_secs+0x60>
c0101d29:	c7 44 24 0c 9c a0 10 	movl   $0xc010a09c,0xc(%esp)
c0101d30:	c0 
c0101d31:	c7 44 24 08 57 a0 10 	movl   $0xc010a057,0x8(%esp)
c0101d38:	c0 
c0101d39:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d40:	00 
c0101d41:	c7 04 24 6c a0 10 c0 	movl   $0xc010a06c,(%esp)
c0101d48:	e8 90 ef ff ff       	call   c0100cdd <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d4d:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d54:	77 0f                	ja     c0101d65 <ide_write_secs+0x78>
c0101d56:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d59:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d5c:	01 d0                	add    %edx,%eax
c0101d5e:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d63:	76 24                	jbe    c0101d89 <ide_write_secs+0x9c>
c0101d65:	c7 44 24 0c c4 a0 10 	movl   $0xc010a0c4,0xc(%esp)
c0101d6c:	c0 
c0101d6d:	c7 44 24 08 57 a0 10 	movl   $0xc010a057,0x8(%esp)
c0101d74:	c0 
c0101d75:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d7c:	00 
c0101d7d:	c7 04 24 6c a0 10 c0 	movl   $0xc010a06c,(%esp)
c0101d84:	e8 54 ef ff ff       	call   c0100cdd <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d89:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d8d:	66 d1 e8             	shr    %ax
c0101d90:	0f b7 c0             	movzwl %ax,%eax
c0101d93:	0f b7 04 85 0c a0 10 	movzwl -0x3fef5ff4(,%eax,4),%eax
c0101d9a:	c0 
c0101d9b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d9f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101da3:	66 d1 e8             	shr    %ax
c0101da6:	0f b7 c0             	movzwl %ax,%eax
c0101da9:	0f b7 04 85 0e a0 10 	movzwl -0x3fef5ff2(,%eax,4),%eax
c0101db0:	c0 
c0101db1:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101db5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101db9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101dc0:	00 
c0101dc1:	89 04 24             	mov    %eax,(%esp)
c0101dc4:	e8 f1 f8 ff ff       	call   c01016ba <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dc9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dcd:	83 c0 02             	add    $0x2,%eax
c0101dd0:	0f b7 c0             	movzwl %ax,%eax
c0101dd3:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dd7:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ddb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101ddf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101de3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101de4:	8b 45 14             	mov    0x14(%ebp),%eax
c0101de7:	0f b6 c0             	movzbl %al,%eax
c0101dea:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101dee:	83 c2 02             	add    $0x2,%edx
c0101df1:	0f b7 d2             	movzwl %dx,%edx
c0101df4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101df8:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101dfb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101dff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101e03:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e07:	0f b6 c0             	movzbl %al,%eax
c0101e0a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e0e:	83 c2 03             	add    $0x3,%edx
c0101e11:	0f b7 d2             	movzwl %dx,%edx
c0101e14:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e18:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e1b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e1f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e23:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e27:	c1 e8 08             	shr    $0x8,%eax
c0101e2a:	0f b6 c0             	movzbl %al,%eax
c0101e2d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e31:	83 c2 04             	add    $0x4,%edx
c0101e34:	0f b7 d2             	movzwl %dx,%edx
c0101e37:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e3b:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e3e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e42:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e46:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e4a:	c1 e8 10             	shr    $0x10,%eax
c0101e4d:	0f b6 c0             	movzbl %al,%eax
c0101e50:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e54:	83 c2 05             	add    $0x5,%edx
c0101e57:	0f b7 d2             	movzwl %dx,%edx
c0101e5a:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e5e:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e61:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e65:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e69:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e6a:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e6e:	83 e0 01             	and    $0x1,%eax
c0101e71:	c1 e0 04             	shl    $0x4,%eax
c0101e74:	89 c2                	mov    %eax,%edx
c0101e76:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e79:	c1 e8 18             	shr    $0x18,%eax
c0101e7c:	83 e0 0f             	and    $0xf,%eax
c0101e7f:	09 d0                	or     %edx,%eax
c0101e81:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e84:	0f b6 c0             	movzbl %al,%eax
c0101e87:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e8b:	83 c2 06             	add    $0x6,%edx
c0101e8e:	0f b7 d2             	movzwl %dx,%edx
c0101e91:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e95:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e98:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e9c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101ea0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101ea1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ea5:	83 c0 07             	add    $0x7,%eax
c0101ea8:	0f b7 c0             	movzwl %ax,%eax
c0101eab:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101eaf:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101eb3:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eb7:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101ebb:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101ebc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ec3:	eb 5a                	jmp    c0101f1f <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ec5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ed0:	00 
c0101ed1:	89 04 24             	mov    %eax,(%esp)
c0101ed4:	e8 e1 f7 ff ff       	call   c01016ba <ide_wait_ready>
c0101ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101ee0:	74 02                	je     c0101ee4 <ide_write_secs+0x1f7>
            goto out;
c0101ee2:	eb 41                	jmp    c0101f25 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101ee4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ee8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101eeb:	8b 45 10             	mov    0x10(%ebp),%eax
c0101eee:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ef1:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ef8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101efb:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101efe:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f01:	89 cb                	mov    %ecx,%ebx
c0101f03:	89 de                	mov    %ebx,%esi
c0101f05:	89 c1                	mov    %eax,%ecx
c0101f07:	fc                   	cld    
c0101f08:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f0a:	89 c8                	mov    %ecx,%eax
c0101f0c:	89 f3                	mov    %esi,%ebx
c0101f0e:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f11:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f14:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f18:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f1f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f23:	75 a0                	jne    c0101ec5 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f28:	83 c4 50             	add    $0x50,%esp
c0101f2b:	5b                   	pop    %ebx
c0101f2c:	5e                   	pop    %esi
c0101f2d:	5d                   	pop    %ebp
c0101f2e:	c3                   	ret    

c0101f2f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f2f:	55                   	push   %ebp
c0101f30:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f32:	fb                   	sti    
    sti();
}
c0101f33:	5d                   	pop    %ebp
c0101f34:	c3                   	ret    

c0101f35 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f35:	55                   	push   %ebp
c0101f36:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f38:	fa                   	cli    
    cli();
}
c0101f39:	5d                   	pop    %ebp
c0101f3a:	c3                   	ret    

c0101f3b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f3b:	55                   	push   %ebp
c0101f3c:	89 e5                	mov    %esp,%ebp
c0101f3e:	83 ec 14             	sub    $0x14,%esp
c0101f41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f44:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f48:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f4c:	66 a3 70 45 12 c0    	mov    %ax,0xc0124570
    if (did_init) {
c0101f52:	a1 00 52 12 c0       	mov    0xc0125200,%eax
c0101f57:	85 c0                	test   %eax,%eax
c0101f59:	74 36                	je     c0101f91 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f5b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f5f:	0f b6 c0             	movzbl %al,%eax
c0101f62:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f68:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f6b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f6f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f73:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f74:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f78:	66 c1 e8 08          	shr    $0x8,%ax
c0101f7c:	0f b6 c0             	movzbl %al,%eax
c0101f7f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f85:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f88:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f8c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f90:	ee                   	out    %al,(%dx)
    }
}
c0101f91:	c9                   	leave  
c0101f92:	c3                   	ret    

c0101f93 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f93:	55                   	push   %ebp
c0101f94:	89 e5                	mov    %esp,%ebp
c0101f96:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9c:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fa1:	89 c1                	mov    %eax,%ecx
c0101fa3:	d3 e2                	shl    %cl,%edx
c0101fa5:	89 d0                	mov    %edx,%eax
c0101fa7:	f7 d0                	not    %eax
c0101fa9:	89 c2                	mov    %eax,%edx
c0101fab:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c0101fb2:	21 d0                	and    %edx,%eax
c0101fb4:	0f b7 c0             	movzwl %ax,%eax
c0101fb7:	89 04 24             	mov    %eax,(%esp)
c0101fba:	e8 7c ff ff ff       	call   c0101f3b <pic_setmask>
}
c0101fbf:	c9                   	leave  
c0101fc0:	c3                   	ret    

c0101fc1 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fc1:	55                   	push   %ebp
c0101fc2:	89 e5                	mov    %esp,%ebp
c0101fc4:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fc7:	c7 05 00 52 12 c0 01 	movl   $0x1,0xc0125200
c0101fce:	00 00 00 
c0101fd1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fd7:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fdb:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fdf:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fe3:	ee                   	out    %al,(%dx)
c0101fe4:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fea:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101ff2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101ff6:	ee                   	out    %al,(%dx)
c0101ff7:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101ffd:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0102001:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0102005:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102009:	ee                   	out    %al,(%dx)
c010200a:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102010:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102014:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102018:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010201c:	ee                   	out    %al,(%dx)
c010201d:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102023:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102027:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010202b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010202f:	ee                   	out    %al,(%dx)
c0102030:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102036:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c010203a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010203e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102042:	ee                   	out    %al,(%dx)
c0102043:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102049:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c010204d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102051:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102055:	ee                   	out    %al,(%dx)
c0102056:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010205c:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102060:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102064:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102068:	ee                   	out    %al,(%dx)
c0102069:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010206f:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102073:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102077:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010207b:	ee                   	out    %al,(%dx)
c010207c:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102082:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102086:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010208a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010208e:	ee                   	out    %al,(%dx)
c010208f:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0102095:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102099:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010209d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020a1:	ee                   	out    %al,(%dx)
c01020a2:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020a8:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020ac:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020b0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020b4:	ee                   	out    %al,(%dx)
c01020b5:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020bb:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020bf:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020c3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020c7:	ee                   	out    %al,(%dx)
c01020c8:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020ce:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020d2:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020d6:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020da:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020db:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020e2:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020e6:	74 12                	je     c01020fa <pic_init+0x139>
        pic_setmask(irq_mask);
c01020e8:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020ef:	0f b7 c0             	movzwl %ax,%eax
c01020f2:	89 04 24             	mov    %eax,(%esp)
c01020f5:	e8 41 fe ff ff       	call   c0101f3b <pic_setmask>
    }
}
c01020fa:	c9                   	leave  
c01020fb:	c3                   	ret    

c01020fc <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020fc:	55                   	push   %ebp
c01020fd:	89 e5                	mov    %esp,%ebp
c01020ff:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102102:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102109:	00 
c010210a:	c7 04 24 00 a1 10 c0 	movl   $0xc010a100,(%esp)
c0102111:	e8 3d e2 ff ff       	call   c0100353 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0102116:	c9                   	leave  
c0102117:	c3                   	ret    

c0102118 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102118:	55                   	push   %ebp
c0102119:	89 e5                	mov    %esp,%ebp
c010211b:	83 ec 10             	sub    $0x10,%esp
      */
	extern uintptr_t __vectors[];

	// 计算出有多少个IDT，依次遍历他们
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
c010211e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102125:	e9 c3 00 00 00       	jmp    c01021ed <idt_init+0xd5>

		// 初始化若干IDT
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010212a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010212d:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c0102134:	89 c2                	mov    %eax,%edx
c0102136:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102139:	66 89 14 c5 20 52 12 	mov    %dx,-0x3fedade0(,%eax,8)
c0102140:	c0 
c0102141:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102144:	66 c7 04 c5 22 52 12 	movw   $0x8,-0x3fedadde(,%eax,8)
c010214b:	c0 08 00 
c010214e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102151:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c0102158:	c0 
c0102159:	83 e2 e0             	and    $0xffffffe0,%edx
c010215c:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c0102163:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102166:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c010216d:	c0 
c010216e:	83 e2 1f             	and    $0x1f,%edx
c0102171:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c0102178:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010217b:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c0102182:	c0 
c0102183:	83 e2 f0             	and    $0xfffffff0,%edx
c0102186:	83 ca 0e             	or     $0xe,%edx
c0102189:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c0102190:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102193:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c010219a:	c0 
c010219b:	83 e2 ef             	and    $0xffffffef,%edx
c010219e:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a8:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021af:	c0 
c01021b0:	83 e2 9f             	and    $0xffffff9f,%edx
c01021b3:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021bd:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021c4:	c0 
c01021c5:	83 ca 80             	or     $0xffffff80,%edx
c01021c8:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d2:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c01021d9:	c1 e8 10             	shr    $0x10,%eax
c01021dc:	89 c2                	mov    %eax,%edx
c01021de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e1:	66 89 14 c5 26 52 12 	mov    %dx,-0x3fedadda(,%eax,8)
c01021e8:	c0 
      */
	extern uintptr_t __vectors[];

	// 计算出有多少个IDT，依次遍历他们
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
c01021e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01021ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f0:	3d ff 00 00 00       	cmp    $0xff,%eax
c01021f5:	0f 86 2f ff ff ff    	jbe    c010212a <idt_init+0x12>
		// 初始化若干IDT
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	}

	// T_SWITCH_TOK 的发生时机是在用户空间的，所以对应的dpl需要修改为DPL_USER。
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01021fb:	a1 e4 47 12 c0       	mov    0xc01247e4,%eax
c0102200:	66 a3 e8 55 12 c0    	mov    %ax,0xc01255e8
c0102206:	66 c7 05 ea 55 12 c0 	movw   $0x8,0xc01255ea
c010220d:	08 00 
c010220f:	0f b6 05 ec 55 12 c0 	movzbl 0xc01255ec,%eax
c0102216:	83 e0 e0             	and    $0xffffffe0,%eax
c0102219:	a2 ec 55 12 c0       	mov    %al,0xc01255ec
c010221e:	0f b6 05 ec 55 12 c0 	movzbl 0xc01255ec,%eax
c0102225:	83 e0 1f             	and    $0x1f,%eax
c0102228:	a2 ec 55 12 c0       	mov    %al,0xc01255ec
c010222d:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c0102234:	83 e0 f0             	and    $0xfffffff0,%eax
c0102237:	83 c8 0e             	or     $0xe,%eax
c010223a:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c010223f:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c0102246:	83 e0 ef             	and    $0xffffffef,%eax
c0102249:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c010224e:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c0102255:	83 c8 60             	or     $0x60,%eax
c0102258:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c010225d:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c0102264:	83 c8 80             	or     $0xffffff80,%eax
c0102267:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c010226c:	a1 e4 47 12 c0       	mov    0xc01247e4,%eax
c0102271:	c1 e8 10             	shr    $0x10,%eax
c0102274:	66 a3 ee 55 12 c0    	mov    %ax,0xc01255ee
c010227a:	c7 45 f8 80 45 12 c0 	movl   $0xc0124580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102281:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102284:	0f 01 18             	lidtl  (%eax)

	// 加载IDT，只有特权级为0才允许执行
	lidt(&idt_pd);
}
c0102287:	c9                   	leave  
c0102288:	c3                   	ret    

c0102289 <trapname>:

static const char *
trapname(int trapno) {
c0102289:	55                   	push   %ebp
c010228a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c010228c:	8b 45 08             	mov    0x8(%ebp),%eax
c010228f:	83 f8 13             	cmp    $0x13,%eax
c0102292:	77 0c                	ja     c01022a0 <trapname+0x17>
        return excnames[trapno];
c0102294:	8b 45 08             	mov    0x8(%ebp),%eax
c0102297:	8b 04 85 e0 a4 10 c0 	mov    -0x3fef5b20(,%eax,4),%eax
c010229e:	eb 18                	jmp    c01022b8 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01022a0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01022a4:	7e 0d                	jle    c01022b3 <trapname+0x2a>
c01022a6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022aa:	7f 07                	jg     c01022b3 <trapname+0x2a>
        return "Hardware Interrupt";
c01022ac:	b8 0a a1 10 c0       	mov    $0xc010a10a,%eax
c01022b1:	eb 05                	jmp    c01022b8 <trapname+0x2f>
    }
    return "(unknown trap)";
c01022b3:	b8 1d a1 10 c0       	mov    $0xc010a11d,%eax
}
c01022b8:	5d                   	pop    %ebp
c01022b9:	c3                   	ret    

c01022ba <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022ba:	55                   	push   %ebp
c01022bb:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01022c0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022c4:	66 83 f8 08          	cmp    $0x8,%ax
c01022c8:	0f 94 c0             	sete   %al
c01022cb:	0f b6 c0             	movzbl %al,%eax
}
c01022ce:	5d                   	pop    %ebp
c01022cf:	c3                   	ret    

c01022d0 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01022d0:	55                   	push   %ebp
c01022d1:	89 e5                	mov    %esp,%ebp
c01022d3:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01022d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022dd:	c7 04 24 5e a1 10 c0 	movl   $0xc010a15e,(%esp)
c01022e4:	e8 6a e0 ff ff       	call   c0100353 <cprintf>
    print_regs(&tf->tf_regs);
c01022e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ec:	89 04 24             	mov    %eax,(%esp)
c01022ef:	e8 a1 01 00 00       	call   c0102495 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01022f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f7:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01022fb:	0f b7 c0             	movzwl %ax,%eax
c01022fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102302:	c7 04 24 6f a1 10 c0 	movl   $0xc010a16f,(%esp)
c0102309:	e8 45 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c010230e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102311:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102315:	0f b7 c0             	movzwl %ax,%eax
c0102318:	89 44 24 04          	mov    %eax,0x4(%esp)
c010231c:	c7 04 24 82 a1 10 c0 	movl   $0xc010a182,(%esp)
c0102323:	e8 2b e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102328:	8b 45 08             	mov    0x8(%ebp),%eax
c010232b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010232f:	0f b7 c0             	movzwl %ax,%eax
c0102332:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102336:	c7 04 24 95 a1 10 c0 	movl   $0xc010a195,(%esp)
c010233d:	e8 11 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102342:	8b 45 08             	mov    0x8(%ebp),%eax
c0102345:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102349:	0f b7 c0             	movzwl %ax,%eax
c010234c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102350:	c7 04 24 a8 a1 10 c0 	movl   $0xc010a1a8,(%esp)
c0102357:	e8 f7 df ff ff       	call   c0100353 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010235c:	8b 45 08             	mov    0x8(%ebp),%eax
c010235f:	8b 40 30             	mov    0x30(%eax),%eax
c0102362:	89 04 24             	mov    %eax,(%esp)
c0102365:	e8 1f ff ff ff       	call   c0102289 <trapname>
c010236a:	8b 55 08             	mov    0x8(%ebp),%edx
c010236d:	8b 52 30             	mov    0x30(%edx),%edx
c0102370:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102374:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102378:	c7 04 24 bb a1 10 c0 	movl   $0xc010a1bb,(%esp)
c010237f:	e8 cf df ff ff       	call   c0100353 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102384:	8b 45 08             	mov    0x8(%ebp),%eax
c0102387:	8b 40 34             	mov    0x34(%eax),%eax
c010238a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010238e:	c7 04 24 cd a1 10 c0 	movl   $0xc010a1cd,(%esp)
c0102395:	e8 b9 df ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c010239a:	8b 45 08             	mov    0x8(%ebp),%eax
c010239d:	8b 40 38             	mov    0x38(%eax),%eax
c01023a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023a4:	c7 04 24 dc a1 10 c0 	movl   $0xc010a1dc,(%esp)
c01023ab:	e8 a3 df ff ff       	call   c0100353 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023b7:	0f b7 c0             	movzwl %ax,%eax
c01023ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023be:	c7 04 24 eb a1 10 c0 	movl   $0xc010a1eb,(%esp)
c01023c5:	e8 89 df ff ff       	call   c0100353 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01023cd:	8b 40 40             	mov    0x40(%eax),%eax
c01023d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023d4:	c7 04 24 fe a1 10 c0 	movl   $0xc010a1fe,(%esp)
c01023db:	e8 73 df ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01023ee:	eb 3e                	jmp    c010242e <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01023f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f3:	8b 50 40             	mov    0x40(%eax),%edx
c01023f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023f9:	21 d0                	and    %edx,%eax
c01023fb:	85 c0                	test   %eax,%eax
c01023fd:	74 28                	je     c0102427 <print_trapframe+0x157>
c01023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102402:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c0102409:	85 c0                	test   %eax,%eax
c010240b:	74 1a                	je     c0102427 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c010240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102410:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c0102417:	89 44 24 04          	mov    %eax,0x4(%esp)
c010241b:	c7 04 24 0d a2 10 c0 	movl   $0xc010a20d,(%esp)
c0102422:	e8 2c df ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102427:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010242b:	d1 65 f0             	shll   -0x10(%ebp)
c010242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102431:	83 f8 17             	cmp    $0x17,%eax
c0102434:	76 ba                	jbe    c01023f0 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102436:	8b 45 08             	mov    0x8(%ebp),%eax
c0102439:	8b 40 40             	mov    0x40(%eax),%eax
c010243c:	25 00 30 00 00       	and    $0x3000,%eax
c0102441:	c1 e8 0c             	shr    $0xc,%eax
c0102444:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102448:	c7 04 24 11 a2 10 c0 	movl   $0xc010a211,(%esp)
c010244f:	e8 ff de ff ff       	call   c0100353 <cprintf>

    if (!trap_in_kernel(tf)) {
c0102454:	8b 45 08             	mov    0x8(%ebp),%eax
c0102457:	89 04 24             	mov    %eax,(%esp)
c010245a:	e8 5b fe ff ff       	call   c01022ba <trap_in_kernel>
c010245f:	85 c0                	test   %eax,%eax
c0102461:	75 30                	jne    c0102493 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102463:	8b 45 08             	mov    0x8(%ebp),%eax
c0102466:	8b 40 44             	mov    0x44(%eax),%eax
c0102469:	89 44 24 04          	mov    %eax,0x4(%esp)
c010246d:	c7 04 24 1a a2 10 c0 	movl   $0xc010a21a,(%esp)
c0102474:	e8 da de ff ff       	call   c0100353 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102479:	8b 45 08             	mov    0x8(%ebp),%eax
c010247c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102480:	0f b7 c0             	movzwl %ax,%eax
c0102483:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102487:	c7 04 24 29 a2 10 c0 	movl   $0xc010a229,(%esp)
c010248e:	e8 c0 de ff ff       	call   c0100353 <cprintf>
    }
}
c0102493:	c9                   	leave  
c0102494:	c3                   	ret    

c0102495 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102495:	55                   	push   %ebp
c0102496:	89 e5                	mov    %esp,%ebp
c0102498:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c010249b:	8b 45 08             	mov    0x8(%ebp),%eax
c010249e:	8b 00                	mov    (%eax),%eax
c01024a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a4:	c7 04 24 3c a2 10 c0 	movl   $0xc010a23c,(%esp)
c01024ab:	e8 a3 de ff ff       	call   c0100353 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b3:	8b 40 04             	mov    0x4(%eax),%eax
c01024b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024ba:	c7 04 24 4b a2 10 c0 	movl   $0xc010a24b,(%esp)
c01024c1:	e8 8d de ff ff       	call   c0100353 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c9:	8b 40 08             	mov    0x8(%eax),%eax
c01024cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024d0:	c7 04 24 5a a2 10 c0 	movl   $0xc010a25a,(%esp)
c01024d7:	e8 77 de ff ff       	call   c0100353 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01024dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01024df:	8b 40 0c             	mov    0xc(%eax),%eax
c01024e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024e6:	c7 04 24 69 a2 10 c0 	movl   $0xc010a269,(%esp)
c01024ed:	e8 61 de ff ff       	call   c0100353 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01024f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f5:	8b 40 10             	mov    0x10(%eax),%eax
c01024f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024fc:	c7 04 24 78 a2 10 c0 	movl   $0xc010a278,(%esp)
c0102503:	e8 4b de ff ff       	call   c0100353 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102508:	8b 45 08             	mov    0x8(%ebp),%eax
c010250b:	8b 40 14             	mov    0x14(%eax),%eax
c010250e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102512:	c7 04 24 87 a2 10 c0 	movl   $0xc010a287,(%esp)
c0102519:	e8 35 de ff ff       	call   c0100353 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c010251e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102521:	8b 40 18             	mov    0x18(%eax),%eax
c0102524:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102528:	c7 04 24 96 a2 10 c0 	movl   $0xc010a296,(%esp)
c010252f:	e8 1f de ff ff       	call   c0100353 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102534:	8b 45 08             	mov    0x8(%ebp),%eax
c0102537:	8b 40 1c             	mov    0x1c(%eax),%eax
c010253a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010253e:	c7 04 24 a5 a2 10 c0 	movl   $0xc010a2a5,(%esp)
c0102545:	e8 09 de ff ff       	call   c0100353 <cprintf>
}
c010254a:	c9                   	leave  
c010254b:	c3                   	ret    

c010254c <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c010254c:	55                   	push   %ebp
c010254d:	89 e5                	mov    %esp,%ebp
c010254f:	53                   	push   %ebx
c0102550:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102553:	8b 45 08             	mov    0x8(%ebp),%eax
c0102556:	8b 40 34             	mov    0x34(%eax),%eax
c0102559:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010255c:	85 c0                	test   %eax,%eax
c010255e:	74 07                	je     c0102567 <print_pgfault+0x1b>
c0102560:	b9 b4 a2 10 c0       	mov    $0xc010a2b4,%ecx
c0102565:	eb 05                	jmp    c010256c <print_pgfault+0x20>
c0102567:	b9 c5 a2 10 c0       	mov    $0xc010a2c5,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c010256c:	8b 45 08             	mov    0x8(%ebp),%eax
c010256f:	8b 40 34             	mov    0x34(%eax),%eax
c0102572:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102575:	85 c0                	test   %eax,%eax
c0102577:	74 07                	je     c0102580 <print_pgfault+0x34>
c0102579:	ba 57 00 00 00       	mov    $0x57,%edx
c010257e:	eb 05                	jmp    c0102585 <print_pgfault+0x39>
c0102580:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102585:	8b 45 08             	mov    0x8(%ebp),%eax
c0102588:	8b 40 34             	mov    0x34(%eax),%eax
c010258b:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010258e:	85 c0                	test   %eax,%eax
c0102590:	74 07                	je     c0102599 <print_pgfault+0x4d>
c0102592:	b8 55 00 00 00       	mov    $0x55,%eax
c0102597:	eb 05                	jmp    c010259e <print_pgfault+0x52>
c0102599:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010259e:	0f 20 d3             	mov    %cr2,%ebx
c01025a1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c01025a4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c01025a7:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01025ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01025af:	89 44 24 08          	mov    %eax,0x8(%esp)
c01025b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01025b7:	c7 04 24 d4 a2 10 c0 	movl   $0xc010a2d4,(%esp)
c01025be:	e8 90 dd ff ff       	call   c0100353 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01025c3:	83 c4 34             	add    $0x34,%esp
c01025c6:	5b                   	pop    %ebx
c01025c7:	5d                   	pop    %ebp
c01025c8:	c3                   	ret    

c01025c9 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025c9:	55                   	push   %ebp
c01025ca:	89 e5                	mov    %esp,%ebp
c01025cc:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01025d2:	89 04 24             	mov    %eax,(%esp)
c01025d5:	e8 72 ff ff ff       	call   c010254c <print_pgfault>
    if (check_mm_struct != NULL) {
c01025da:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c01025df:	85 c0                	test   %eax,%eax
c01025e1:	74 28                	je     c010260b <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025e3:	0f 20 d0             	mov    %cr2,%eax
c01025e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01025ec:	89 c1                	mov    %eax,%ecx
c01025ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f1:	8b 50 34             	mov    0x34(%eax),%edx
c01025f4:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c01025f9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01025fd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102601:	89 04 24             	mov    %eax,(%esp)
c0102604:	e8 e6 5a 00 00       	call   c01080ef <do_pgfault>
c0102609:	eb 1c                	jmp    c0102627 <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c010260b:	c7 44 24 08 f7 a2 10 	movl   $0xc010a2f7,0x8(%esp)
c0102612:	c0 
c0102613:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c010261a:	00 
c010261b:	c7 04 24 0e a3 10 c0 	movl   $0xc010a30e,(%esp)
c0102622:	e8 b6 e6 ff ff       	call   c0100cdd <__panic>
}
c0102627:	c9                   	leave  
c0102628:	c3                   	ret    

c0102629 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102629:	55                   	push   %ebp
c010262a:	89 e5                	mov    %esp,%ebp
c010262c:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c010262f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102632:	8b 40 30             	mov    0x30(%eax),%eax
c0102635:	83 f8 24             	cmp    $0x24,%eax
c0102638:	0f 84 8b 00 00 00    	je     c01026c9 <trap_dispatch+0xa0>
c010263e:	83 f8 24             	cmp    $0x24,%eax
c0102641:	77 1c                	ja     c010265f <trap_dispatch+0x36>
c0102643:	83 f8 20             	cmp    $0x20,%eax
c0102646:	0f 84 1d 01 00 00    	je     c0102769 <trap_dispatch+0x140>
c010264c:	83 f8 21             	cmp    $0x21,%eax
c010264f:	0f 84 9a 00 00 00    	je     c01026ef <trap_dispatch+0xc6>
c0102655:	83 f8 0e             	cmp    $0xe,%eax
c0102658:	74 28                	je     c0102682 <trap_dispatch+0x59>
c010265a:	e9 d2 00 00 00       	jmp    c0102731 <trap_dispatch+0x108>
c010265f:	83 f8 2e             	cmp    $0x2e,%eax
c0102662:	0f 82 c9 00 00 00    	jb     c0102731 <trap_dispatch+0x108>
c0102668:	83 f8 2f             	cmp    $0x2f,%eax
c010266b:	0f 86 fb 00 00 00    	jbe    c010276c <trap_dispatch+0x143>
c0102671:	83 e8 78             	sub    $0x78,%eax
c0102674:	83 f8 01             	cmp    $0x1,%eax
c0102677:	0f 87 b4 00 00 00    	ja     c0102731 <trap_dispatch+0x108>
c010267d:	e9 93 00 00 00       	jmp    c0102715 <trap_dispatch+0xec>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102682:	8b 45 08             	mov    0x8(%ebp),%eax
c0102685:	89 04 24             	mov    %eax,(%esp)
c0102688:	e8 3c ff ff ff       	call   c01025c9 <pgfault_handler>
c010268d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102690:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102694:	74 2e                	je     c01026c4 <trap_dispatch+0x9b>
            print_trapframe(tf);
c0102696:	8b 45 08             	mov    0x8(%ebp),%eax
c0102699:	89 04 24             	mov    %eax,(%esp)
c010269c:	e8 2f fc ff ff       	call   c01022d0 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c01026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01026a8:	c7 44 24 08 1f a3 10 	movl   $0xc010a31f,0x8(%esp)
c01026af:	c0 
c01026b0:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c01026b7:	00 
c01026b8:	c7 04 24 0e a3 10 c0 	movl   $0xc010a30e,(%esp)
c01026bf:	e8 19 e6 ff ff       	call   c0100cdd <__panic>
        }
        break;
c01026c4:	e9 a4 00 00 00       	jmp    c010276d <trap_dispatch+0x144>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01026c9:	e8 7d ef ff ff       	call   c010164b <cons_getc>
c01026ce:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01026d1:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026d5:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026e1:	c7 04 24 3a a3 10 c0 	movl   $0xc010a33a,(%esp)
c01026e8:	e8 66 dc ff ff       	call   c0100353 <cprintf>
        break;
c01026ed:	eb 7e                	jmp    c010276d <trap_dispatch+0x144>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01026ef:	e8 57 ef ff ff       	call   c010164b <cons_getc>
c01026f4:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01026f7:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026fb:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026ff:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102703:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102707:	c7 04 24 4c a3 10 c0 	movl   $0xc010a34c,(%esp)
c010270e:	e8 40 dc ff ff       	call   c0100353 <cprintf>
        break;
c0102713:	eb 58                	jmp    c010276d <trap_dispatch+0x144>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102715:	c7 44 24 08 5b a3 10 	movl   $0xc010a35b,0x8(%esp)
c010271c:	c0 
c010271d:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0102724:	00 
c0102725:	c7 04 24 0e a3 10 c0 	movl   $0xc010a30e,(%esp)
c010272c:	e8 ac e5 ff ff       	call   c0100cdd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102731:	8b 45 08             	mov    0x8(%ebp),%eax
c0102734:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102738:	0f b7 c0             	movzwl %ax,%eax
c010273b:	83 e0 03             	and    $0x3,%eax
c010273e:	85 c0                	test   %eax,%eax
c0102740:	75 2b                	jne    c010276d <trap_dispatch+0x144>
            print_trapframe(tf);
c0102742:	8b 45 08             	mov    0x8(%ebp),%eax
c0102745:	89 04 24             	mov    %eax,(%esp)
c0102748:	e8 83 fb ff ff       	call   c01022d0 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010274d:	c7 44 24 08 6b a3 10 	movl   $0xc010a36b,0x8(%esp)
c0102754:	c0 
c0102755:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c010275c:	00 
c010275d:	c7 04 24 0e a3 10 c0 	movl   $0xc010a30e,(%esp)
c0102764:	e8 74 e5 ff ff       	call   c0100cdd <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c0102769:	90                   	nop
c010276a:	eb 01                	jmp    c010276d <trap_dispatch+0x144>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c010276c:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c010276d:	c9                   	leave  
c010276e:	c3                   	ret    

c010276f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010276f:	55                   	push   %ebp
c0102770:	89 e5                	mov    %esp,%ebp
c0102772:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102775:	8b 45 08             	mov    0x8(%ebp),%eax
c0102778:	89 04 24             	mov    %eax,(%esp)
c010277b:	e8 a9 fe ff ff       	call   c0102629 <trap_dispatch>
}
c0102780:	c9                   	leave  
c0102781:	c3                   	ret    

c0102782 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102782:	1e                   	push   %ds
    pushl %es
c0102783:	06                   	push   %es
    pushl %fs
c0102784:	0f a0                	push   %fs
    pushl %gs
c0102786:	0f a8                	push   %gs
    pushal
c0102788:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102789:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010278e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102790:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102792:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102793:	e8 d7 ff ff ff       	call   c010276f <trap>

    # pop the pushed stack pointer
    popl %esp
c0102798:	5c                   	pop    %esp

c0102799 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102799:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c010279a:	0f a9                	pop    %gs
    popl %fs
c010279c:	0f a1                	pop    %fs
    popl %es
c010279e:	07                   	pop    %es
    popl %ds
c010279f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01027a0:	83 c4 08             	add    $0x8,%esp
    iret
c01027a3:	cf                   	iret   

c01027a4 <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c01027a4:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c01027a8:	e9 ec ff ff ff       	jmp    c0102799 <__trapret>

c01027ad <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $0
c01027af:	6a 00                	push   $0x0
  jmp __alltraps
c01027b1:	e9 cc ff ff ff       	jmp    c0102782 <__alltraps>

c01027b6 <vector1>:
.globl vector1
vector1:
  pushl $0
c01027b6:	6a 00                	push   $0x0
  pushl $1
c01027b8:	6a 01                	push   $0x1
  jmp __alltraps
c01027ba:	e9 c3 ff ff ff       	jmp    c0102782 <__alltraps>

c01027bf <vector2>:
.globl vector2
vector2:
  pushl $0
c01027bf:	6a 00                	push   $0x0
  pushl $2
c01027c1:	6a 02                	push   $0x2
  jmp __alltraps
c01027c3:	e9 ba ff ff ff       	jmp    c0102782 <__alltraps>

c01027c8 <vector3>:
.globl vector3
vector3:
  pushl $0
c01027c8:	6a 00                	push   $0x0
  pushl $3
c01027ca:	6a 03                	push   $0x3
  jmp __alltraps
c01027cc:	e9 b1 ff ff ff       	jmp    c0102782 <__alltraps>

c01027d1 <vector4>:
.globl vector4
vector4:
  pushl $0
c01027d1:	6a 00                	push   $0x0
  pushl $4
c01027d3:	6a 04                	push   $0x4
  jmp __alltraps
c01027d5:	e9 a8 ff ff ff       	jmp    c0102782 <__alltraps>

c01027da <vector5>:
.globl vector5
vector5:
  pushl $0
c01027da:	6a 00                	push   $0x0
  pushl $5
c01027dc:	6a 05                	push   $0x5
  jmp __alltraps
c01027de:	e9 9f ff ff ff       	jmp    c0102782 <__alltraps>

c01027e3 <vector6>:
.globl vector6
vector6:
  pushl $0
c01027e3:	6a 00                	push   $0x0
  pushl $6
c01027e5:	6a 06                	push   $0x6
  jmp __alltraps
c01027e7:	e9 96 ff ff ff       	jmp    c0102782 <__alltraps>

c01027ec <vector7>:
.globl vector7
vector7:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $7
c01027ee:	6a 07                	push   $0x7
  jmp __alltraps
c01027f0:	e9 8d ff ff ff       	jmp    c0102782 <__alltraps>

c01027f5 <vector8>:
.globl vector8
vector8:
  pushl $8
c01027f5:	6a 08                	push   $0x8
  jmp __alltraps
c01027f7:	e9 86 ff ff ff       	jmp    c0102782 <__alltraps>

c01027fc <vector9>:
.globl vector9
vector9:
  pushl $9
c01027fc:	6a 09                	push   $0x9
  jmp __alltraps
c01027fe:	e9 7f ff ff ff       	jmp    c0102782 <__alltraps>

c0102803 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102803:	6a 0a                	push   $0xa
  jmp __alltraps
c0102805:	e9 78 ff ff ff       	jmp    c0102782 <__alltraps>

c010280a <vector11>:
.globl vector11
vector11:
  pushl $11
c010280a:	6a 0b                	push   $0xb
  jmp __alltraps
c010280c:	e9 71 ff ff ff       	jmp    c0102782 <__alltraps>

c0102811 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102811:	6a 0c                	push   $0xc
  jmp __alltraps
c0102813:	e9 6a ff ff ff       	jmp    c0102782 <__alltraps>

c0102818 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102818:	6a 0d                	push   $0xd
  jmp __alltraps
c010281a:	e9 63 ff ff ff       	jmp    c0102782 <__alltraps>

c010281f <vector14>:
.globl vector14
vector14:
  pushl $14
c010281f:	6a 0e                	push   $0xe
  jmp __alltraps
c0102821:	e9 5c ff ff ff       	jmp    c0102782 <__alltraps>

c0102826 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $15
c0102828:	6a 0f                	push   $0xf
  jmp __alltraps
c010282a:	e9 53 ff ff ff       	jmp    c0102782 <__alltraps>

c010282f <vector16>:
.globl vector16
vector16:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $16
c0102831:	6a 10                	push   $0x10
  jmp __alltraps
c0102833:	e9 4a ff ff ff       	jmp    c0102782 <__alltraps>

c0102838 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102838:	6a 11                	push   $0x11
  jmp __alltraps
c010283a:	e9 43 ff ff ff       	jmp    c0102782 <__alltraps>

c010283f <vector18>:
.globl vector18
vector18:
  pushl $0
c010283f:	6a 00                	push   $0x0
  pushl $18
c0102841:	6a 12                	push   $0x12
  jmp __alltraps
c0102843:	e9 3a ff ff ff       	jmp    c0102782 <__alltraps>

c0102848 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102848:	6a 00                	push   $0x0
  pushl $19
c010284a:	6a 13                	push   $0x13
  jmp __alltraps
c010284c:	e9 31 ff ff ff       	jmp    c0102782 <__alltraps>

c0102851 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102851:	6a 00                	push   $0x0
  pushl $20
c0102853:	6a 14                	push   $0x14
  jmp __alltraps
c0102855:	e9 28 ff ff ff       	jmp    c0102782 <__alltraps>

c010285a <vector21>:
.globl vector21
vector21:
  pushl $0
c010285a:	6a 00                	push   $0x0
  pushl $21
c010285c:	6a 15                	push   $0x15
  jmp __alltraps
c010285e:	e9 1f ff ff ff       	jmp    c0102782 <__alltraps>

c0102863 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102863:	6a 00                	push   $0x0
  pushl $22
c0102865:	6a 16                	push   $0x16
  jmp __alltraps
c0102867:	e9 16 ff ff ff       	jmp    c0102782 <__alltraps>

c010286c <vector23>:
.globl vector23
vector23:
  pushl $0
c010286c:	6a 00                	push   $0x0
  pushl $23
c010286e:	6a 17                	push   $0x17
  jmp __alltraps
c0102870:	e9 0d ff ff ff       	jmp    c0102782 <__alltraps>

c0102875 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102875:	6a 00                	push   $0x0
  pushl $24
c0102877:	6a 18                	push   $0x18
  jmp __alltraps
c0102879:	e9 04 ff ff ff       	jmp    c0102782 <__alltraps>

c010287e <vector25>:
.globl vector25
vector25:
  pushl $0
c010287e:	6a 00                	push   $0x0
  pushl $25
c0102880:	6a 19                	push   $0x19
  jmp __alltraps
c0102882:	e9 fb fe ff ff       	jmp    c0102782 <__alltraps>

c0102887 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102887:	6a 00                	push   $0x0
  pushl $26
c0102889:	6a 1a                	push   $0x1a
  jmp __alltraps
c010288b:	e9 f2 fe ff ff       	jmp    c0102782 <__alltraps>

c0102890 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102890:	6a 00                	push   $0x0
  pushl $27
c0102892:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102894:	e9 e9 fe ff ff       	jmp    c0102782 <__alltraps>

c0102899 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102899:	6a 00                	push   $0x0
  pushl $28
c010289b:	6a 1c                	push   $0x1c
  jmp __alltraps
c010289d:	e9 e0 fe ff ff       	jmp    c0102782 <__alltraps>

c01028a2 <vector29>:
.globl vector29
vector29:
  pushl $0
c01028a2:	6a 00                	push   $0x0
  pushl $29
c01028a4:	6a 1d                	push   $0x1d
  jmp __alltraps
c01028a6:	e9 d7 fe ff ff       	jmp    c0102782 <__alltraps>

c01028ab <vector30>:
.globl vector30
vector30:
  pushl $0
c01028ab:	6a 00                	push   $0x0
  pushl $30
c01028ad:	6a 1e                	push   $0x1e
  jmp __alltraps
c01028af:	e9 ce fe ff ff       	jmp    c0102782 <__alltraps>

c01028b4 <vector31>:
.globl vector31
vector31:
  pushl $0
c01028b4:	6a 00                	push   $0x0
  pushl $31
c01028b6:	6a 1f                	push   $0x1f
  jmp __alltraps
c01028b8:	e9 c5 fe ff ff       	jmp    c0102782 <__alltraps>

c01028bd <vector32>:
.globl vector32
vector32:
  pushl $0
c01028bd:	6a 00                	push   $0x0
  pushl $32
c01028bf:	6a 20                	push   $0x20
  jmp __alltraps
c01028c1:	e9 bc fe ff ff       	jmp    c0102782 <__alltraps>

c01028c6 <vector33>:
.globl vector33
vector33:
  pushl $0
c01028c6:	6a 00                	push   $0x0
  pushl $33
c01028c8:	6a 21                	push   $0x21
  jmp __alltraps
c01028ca:	e9 b3 fe ff ff       	jmp    c0102782 <__alltraps>

c01028cf <vector34>:
.globl vector34
vector34:
  pushl $0
c01028cf:	6a 00                	push   $0x0
  pushl $34
c01028d1:	6a 22                	push   $0x22
  jmp __alltraps
c01028d3:	e9 aa fe ff ff       	jmp    c0102782 <__alltraps>

c01028d8 <vector35>:
.globl vector35
vector35:
  pushl $0
c01028d8:	6a 00                	push   $0x0
  pushl $35
c01028da:	6a 23                	push   $0x23
  jmp __alltraps
c01028dc:	e9 a1 fe ff ff       	jmp    c0102782 <__alltraps>

c01028e1 <vector36>:
.globl vector36
vector36:
  pushl $0
c01028e1:	6a 00                	push   $0x0
  pushl $36
c01028e3:	6a 24                	push   $0x24
  jmp __alltraps
c01028e5:	e9 98 fe ff ff       	jmp    c0102782 <__alltraps>

c01028ea <vector37>:
.globl vector37
vector37:
  pushl $0
c01028ea:	6a 00                	push   $0x0
  pushl $37
c01028ec:	6a 25                	push   $0x25
  jmp __alltraps
c01028ee:	e9 8f fe ff ff       	jmp    c0102782 <__alltraps>

c01028f3 <vector38>:
.globl vector38
vector38:
  pushl $0
c01028f3:	6a 00                	push   $0x0
  pushl $38
c01028f5:	6a 26                	push   $0x26
  jmp __alltraps
c01028f7:	e9 86 fe ff ff       	jmp    c0102782 <__alltraps>

c01028fc <vector39>:
.globl vector39
vector39:
  pushl $0
c01028fc:	6a 00                	push   $0x0
  pushl $39
c01028fe:	6a 27                	push   $0x27
  jmp __alltraps
c0102900:	e9 7d fe ff ff       	jmp    c0102782 <__alltraps>

c0102905 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102905:	6a 00                	push   $0x0
  pushl $40
c0102907:	6a 28                	push   $0x28
  jmp __alltraps
c0102909:	e9 74 fe ff ff       	jmp    c0102782 <__alltraps>

c010290e <vector41>:
.globl vector41
vector41:
  pushl $0
c010290e:	6a 00                	push   $0x0
  pushl $41
c0102910:	6a 29                	push   $0x29
  jmp __alltraps
c0102912:	e9 6b fe ff ff       	jmp    c0102782 <__alltraps>

c0102917 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102917:	6a 00                	push   $0x0
  pushl $42
c0102919:	6a 2a                	push   $0x2a
  jmp __alltraps
c010291b:	e9 62 fe ff ff       	jmp    c0102782 <__alltraps>

c0102920 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102920:	6a 00                	push   $0x0
  pushl $43
c0102922:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102924:	e9 59 fe ff ff       	jmp    c0102782 <__alltraps>

c0102929 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102929:	6a 00                	push   $0x0
  pushl $44
c010292b:	6a 2c                	push   $0x2c
  jmp __alltraps
c010292d:	e9 50 fe ff ff       	jmp    c0102782 <__alltraps>

c0102932 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102932:	6a 00                	push   $0x0
  pushl $45
c0102934:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102936:	e9 47 fe ff ff       	jmp    c0102782 <__alltraps>

c010293b <vector46>:
.globl vector46
vector46:
  pushl $0
c010293b:	6a 00                	push   $0x0
  pushl $46
c010293d:	6a 2e                	push   $0x2e
  jmp __alltraps
c010293f:	e9 3e fe ff ff       	jmp    c0102782 <__alltraps>

c0102944 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102944:	6a 00                	push   $0x0
  pushl $47
c0102946:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102948:	e9 35 fe ff ff       	jmp    c0102782 <__alltraps>

c010294d <vector48>:
.globl vector48
vector48:
  pushl $0
c010294d:	6a 00                	push   $0x0
  pushl $48
c010294f:	6a 30                	push   $0x30
  jmp __alltraps
c0102951:	e9 2c fe ff ff       	jmp    c0102782 <__alltraps>

c0102956 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102956:	6a 00                	push   $0x0
  pushl $49
c0102958:	6a 31                	push   $0x31
  jmp __alltraps
c010295a:	e9 23 fe ff ff       	jmp    c0102782 <__alltraps>

c010295f <vector50>:
.globl vector50
vector50:
  pushl $0
c010295f:	6a 00                	push   $0x0
  pushl $50
c0102961:	6a 32                	push   $0x32
  jmp __alltraps
c0102963:	e9 1a fe ff ff       	jmp    c0102782 <__alltraps>

c0102968 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102968:	6a 00                	push   $0x0
  pushl $51
c010296a:	6a 33                	push   $0x33
  jmp __alltraps
c010296c:	e9 11 fe ff ff       	jmp    c0102782 <__alltraps>

c0102971 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102971:	6a 00                	push   $0x0
  pushl $52
c0102973:	6a 34                	push   $0x34
  jmp __alltraps
c0102975:	e9 08 fe ff ff       	jmp    c0102782 <__alltraps>

c010297a <vector53>:
.globl vector53
vector53:
  pushl $0
c010297a:	6a 00                	push   $0x0
  pushl $53
c010297c:	6a 35                	push   $0x35
  jmp __alltraps
c010297e:	e9 ff fd ff ff       	jmp    c0102782 <__alltraps>

c0102983 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102983:	6a 00                	push   $0x0
  pushl $54
c0102985:	6a 36                	push   $0x36
  jmp __alltraps
c0102987:	e9 f6 fd ff ff       	jmp    c0102782 <__alltraps>

c010298c <vector55>:
.globl vector55
vector55:
  pushl $0
c010298c:	6a 00                	push   $0x0
  pushl $55
c010298e:	6a 37                	push   $0x37
  jmp __alltraps
c0102990:	e9 ed fd ff ff       	jmp    c0102782 <__alltraps>

c0102995 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102995:	6a 00                	push   $0x0
  pushl $56
c0102997:	6a 38                	push   $0x38
  jmp __alltraps
c0102999:	e9 e4 fd ff ff       	jmp    c0102782 <__alltraps>

c010299e <vector57>:
.globl vector57
vector57:
  pushl $0
c010299e:	6a 00                	push   $0x0
  pushl $57
c01029a0:	6a 39                	push   $0x39
  jmp __alltraps
c01029a2:	e9 db fd ff ff       	jmp    c0102782 <__alltraps>

c01029a7 <vector58>:
.globl vector58
vector58:
  pushl $0
c01029a7:	6a 00                	push   $0x0
  pushl $58
c01029a9:	6a 3a                	push   $0x3a
  jmp __alltraps
c01029ab:	e9 d2 fd ff ff       	jmp    c0102782 <__alltraps>

c01029b0 <vector59>:
.globl vector59
vector59:
  pushl $0
c01029b0:	6a 00                	push   $0x0
  pushl $59
c01029b2:	6a 3b                	push   $0x3b
  jmp __alltraps
c01029b4:	e9 c9 fd ff ff       	jmp    c0102782 <__alltraps>

c01029b9 <vector60>:
.globl vector60
vector60:
  pushl $0
c01029b9:	6a 00                	push   $0x0
  pushl $60
c01029bb:	6a 3c                	push   $0x3c
  jmp __alltraps
c01029bd:	e9 c0 fd ff ff       	jmp    c0102782 <__alltraps>

c01029c2 <vector61>:
.globl vector61
vector61:
  pushl $0
c01029c2:	6a 00                	push   $0x0
  pushl $61
c01029c4:	6a 3d                	push   $0x3d
  jmp __alltraps
c01029c6:	e9 b7 fd ff ff       	jmp    c0102782 <__alltraps>

c01029cb <vector62>:
.globl vector62
vector62:
  pushl $0
c01029cb:	6a 00                	push   $0x0
  pushl $62
c01029cd:	6a 3e                	push   $0x3e
  jmp __alltraps
c01029cf:	e9 ae fd ff ff       	jmp    c0102782 <__alltraps>

c01029d4 <vector63>:
.globl vector63
vector63:
  pushl $0
c01029d4:	6a 00                	push   $0x0
  pushl $63
c01029d6:	6a 3f                	push   $0x3f
  jmp __alltraps
c01029d8:	e9 a5 fd ff ff       	jmp    c0102782 <__alltraps>

c01029dd <vector64>:
.globl vector64
vector64:
  pushl $0
c01029dd:	6a 00                	push   $0x0
  pushl $64
c01029df:	6a 40                	push   $0x40
  jmp __alltraps
c01029e1:	e9 9c fd ff ff       	jmp    c0102782 <__alltraps>

c01029e6 <vector65>:
.globl vector65
vector65:
  pushl $0
c01029e6:	6a 00                	push   $0x0
  pushl $65
c01029e8:	6a 41                	push   $0x41
  jmp __alltraps
c01029ea:	e9 93 fd ff ff       	jmp    c0102782 <__alltraps>

c01029ef <vector66>:
.globl vector66
vector66:
  pushl $0
c01029ef:	6a 00                	push   $0x0
  pushl $66
c01029f1:	6a 42                	push   $0x42
  jmp __alltraps
c01029f3:	e9 8a fd ff ff       	jmp    c0102782 <__alltraps>

c01029f8 <vector67>:
.globl vector67
vector67:
  pushl $0
c01029f8:	6a 00                	push   $0x0
  pushl $67
c01029fa:	6a 43                	push   $0x43
  jmp __alltraps
c01029fc:	e9 81 fd ff ff       	jmp    c0102782 <__alltraps>

c0102a01 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a01:	6a 00                	push   $0x0
  pushl $68
c0102a03:	6a 44                	push   $0x44
  jmp __alltraps
c0102a05:	e9 78 fd ff ff       	jmp    c0102782 <__alltraps>

c0102a0a <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a0a:	6a 00                	push   $0x0
  pushl $69
c0102a0c:	6a 45                	push   $0x45
  jmp __alltraps
c0102a0e:	e9 6f fd ff ff       	jmp    c0102782 <__alltraps>

c0102a13 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a13:	6a 00                	push   $0x0
  pushl $70
c0102a15:	6a 46                	push   $0x46
  jmp __alltraps
c0102a17:	e9 66 fd ff ff       	jmp    c0102782 <__alltraps>

c0102a1c <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a1c:	6a 00                	push   $0x0
  pushl $71
c0102a1e:	6a 47                	push   $0x47
  jmp __alltraps
c0102a20:	e9 5d fd ff ff       	jmp    c0102782 <__alltraps>

c0102a25 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102a25:	6a 00                	push   $0x0
  pushl $72
c0102a27:	6a 48                	push   $0x48
  jmp __alltraps
c0102a29:	e9 54 fd ff ff       	jmp    c0102782 <__alltraps>

c0102a2e <vector73>:
.globl vector73
vector73:
  pushl $0
c0102a2e:	6a 00                	push   $0x0
  pushl $73
c0102a30:	6a 49                	push   $0x49
  jmp __alltraps
c0102a32:	e9 4b fd ff ff       	jmp    c0102782 <__alltraps>

c0102a37 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102a37:	6a 00                	push   $0x0
  pushl $74
c0102a39:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102a3b:	e9 42 fd ff ff       	jmp    c0102782 <__alltraps>

c0102a40 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102a40:	6a 00                	push   $0x0
  pushl $75
c0102a42:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102a44:	e9 39 fd ff ff       	jmp    c0102782 <__alltraps>

c0102a49 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102a49:	6a 00                	push   $0x0
  pushl $76
c0102a4b:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102a4d:	e9 30 fd ff ff       	jmp    c0102782 <__alltraps>

c0102a52 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a52:	6a 00                	push   $0x0
  pushl $77
c0102a54:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a56:	e9 27 fd ff ff       	jmp    c0102782 <__alltraps>

c0102a5b <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a5b:	6a 00                	push   $0x0
  pushl $78
c0102a5d:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a5f:	e9 1e fd ff ff       	jmp    c0102782 <__alltraps>

c0102a64 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a64:	6a 00                	push   $0x0
  pushl $79
c0102a66:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a68:	e9 15 fd ff ff       	jmp    c0102782 <__alltraps>

c0102a6d <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a6d:	6a 00                	push   $0x0
  pushl $80
c0102a6f:	6a 50                	push   $0x50
  jmp __alltraps
c0102a71:	e9 0c fd ff ff       	jmp    c0102782 <__alltraps>

c0102a76 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a76:	6a 00                	push   $0x0
  pushl $81
c0102a78:	6a 51                	push   $0x51
  jmp __alltraps
c0102a7a:	e9 03 fd ff ff       	jmp    c0102782 <__alltraps>

c0102a7f <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a7f:	6a 00                	push   $0x0
  pushl $82
c0102a81:	6a 52                	push   $0x52
  jmp __alltraps
c0102a83:	e9 fa fc ff ff       	jmp    c0102782 <__alltraps>

c0102a88 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102a88:	6a 00                	push   $0x0
  pushl $83
c0102a8a:	6a 53                	push   $0x53
  jmp __alltraps
c0102a8c:	e9 f1 fc ff ff       	jmp    c0102782 <__alltraps>

c0102a91 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102a91:	6a 00                	push   $0x0
  pushl $84
c0102a93:	6a 54                	push   $0x54
  jmp __alltraps
c0102a95:	e9 e8 fc ff ff       	jmp    c0102782 <__alltraps>

c0102a9a <vector85>:
.globl vector85
vector85:
  pushl $0
c0102a9a:	6a 00                	push   $0x0
  pushl $85
c0102a9c:	6a 55                	push   $0x55
  jmp __alltraps
c0102a9e:	e9 df fc ff ff       	jmp    c0102782 <__alltraps>

c0102aa3 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102aa3:	6a 00                	push   $0x0
  pushl $86
c0102aa5:	6a 56                	push   $0x56
  jmp __alltraps
c0102aa7:	e9 d6 fc ff ff       	jmp    c0102782 <__alltraps>

c0102aac <vector87>:
.globl vector87
vector87:
  pushl $0
c0102aac:	6a 00                	push   $0x0
  pushl $87
c0102aae:	6a 57                	push   $0x57
  jmp __alltraps
c0102ab0:	e9 cd fc ff ff       	jmp    c0102782 <__alltraps>

c0102ab5 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102ab5:	6a 00                	push   $0x0
  pushl $88
c0102ab7:	6a 58                	push   $0x58
  jmp __alltraps
c0102ab9:	e9 c4 fc ff ff       	jmp    c0102782 <__alltraps>

c0102abe <vector89>:
.globl vector89
vector89:
  pushl $0
c0102abe:	6a 00                	push   $0x0
  pushl $89
c0102ac0:	6a 59                	push   $0x59
  jmp __alltraps
c0102ac2:	e9 bb fc ff ff       	jmp    c0102782 <__alltraps>

c0102ac7 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102ac7:	6a 00                	push   $0x0
  pushl $90
c0102ac9:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102acb:	e9 b2 fc ff ff       	jmp    c0102782 <__alltraps>

c0102ad0 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102ad0:	6a 00                	push   $0x0
  pushl $91
c0102ad2:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102ad4:	e9 a9 fc ff ff       	jmp    c0102782 <__alltraps>

c0102ad9 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102ad9:	6a 00                	push   $0x0
  pushl $92
c0102adb:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102add:	e9 a0 fc ff ff       	jmp    c0102782 <__alltraps>

c0102ae2 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102ae2:	6a 00                	push   $0x0
  pushl $93
c0102ae4:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102ae6:	e9 97 fc ff ff       	jmp    c0102782 <__alltraps>

c0102aeb <vector94>:
.globl vector94
vector94:
  pushl $0
c0102aeb:	6a 00                	push   $0x0
  pushl $94
c0102aed:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102aef:	e9 8e fc ff ff       	jmp    c0102782 <__alltraps>

c0102af4 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102af4:	6a 00                	push   $0x0
  pushl $95
c0102af6:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102af8:	e9 85 fc ff ff       	jmp    c0102782 <__alltraps>

c0102afd <vector96>:
.globl vector96
vector96:
  pushl $0
c0102afd:	6a 00                	push   $0x0
  pushl $96
c0102aff:	6a 60                	push   $0x60
  jmp __alltraps
c0102b01:	e9 7c fc ff ff       	jmp    c0102782 <__alltraps>

c0102b06 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b06:	6a 00                	push   $0x0
  pushl $97
c0102b08:	6a 61                	push   $0x61
  jmp __alltraps
c0102b0a:	e9 73 fc ff ff       	jmp    c0102782 <__alltraps>

c0102b0f <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b0f:	6a 00                	push   $0x0
  pushl $98
c0102b11:	6a 62                	push   $0x62
  jmp __alltraps
c0102b13:	e9 6a fc ff ff       	jmp    c0102782 <__alltraps>

c0102b18 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b18:	6a 00                	push   $0x0
  pushl $99
c0102b1a:	6a 63                	push   $0x63
  jmp __alltraps
c0102b1c:	e9 61 fc ff ff       	jmp    c0102782 <__alltraps>

c0102b21 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102b21:	6a 00                	push   $0x0
  pushl $100
c0102b23:	6a 64                	push   $0x64
  jmp __alltraps
c0102b25:	e9 58 fc ff ff       	jmp    c0102782 <__alltraps>

c0102b2a <vector101>:
.globl vector101
vector101:
  pushl $0
c0102b2a:	6a 00                	push   $0x0
  pushl $101
c0102b2c:	6a 65                	push   $0x65
  jmp __alltraps
c0102b2e:	e9 4f fc ff ff       	jmp    c0102782 <__alltraps>

c0102b33 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102b33:	6a 00                	push   $0x0
  pushl $102
c0102b35:	6a 66                	push   $0x66
  jmp __alltraps
c0102b37:	e9 46 fc ff ff       	jmp    c0102782 <__alltraps>

c0102b3c <vector103>:
.globl vector103
vector103:
  pushl $0
c0102b3c:	6a 00                	push   $0x0
  pushl $103
c0102b3e:	6a 67                	push   $0x67
  jmp __alltraps
c0102b40:	e9 3d fc ff ff       	jmp    c0102782 <__alltraps>

c0102b45 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102b45:	6a 00                	push   $0x0
  pushl $104
c0102b47:	6a 68                	push   $0x68
  jmp __alltraps
c0102b49:	e9 34 fc ff ff       	jmp    c0102782 <__alltraps>

c0102b4e <vector105>:
.globl vector105
vector105:
  pushl $0
c0102b4e:	6a 00                	push   $0x0
  pushl $105
c0102b50:	6a 69                	push   $0x69
  jmp __alltraps
c0102b52:	e9 2b fc ff ff       	jmp    c0102782 <__alltraps>

c0102b57 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b57:	6a 00                	push   $0x0
  pushl $106
c0102b59:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b5b:	e9 22 fc ff ff       	jmp    c0102782 <__alltraps>

c0102b60 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b60:	6a 00                	push   $0x0
  pushl $107
c0102b62:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b64:	e9 19 fc ff ff       	jmp    c0102782 <__alltraps>

c0102b69 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b69:	6a 00                	push   $0x0
  pushl $108
c0102b6b:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b6d:	e9 10 fc ff ff       	jmp    c0102782 <__alltraps>

c0102b72 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b72:	6a 00                	push   $0x0
  pushl $109
c0102b74:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b76:	e9 07 fc ff ff       	jmp    c0102782 <__alltraps>

c0102b7b <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b7b:	6a 00                	push   $0x0
  pushl $110
c0102b7d:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b7f:	e9 fe fb ff ff       	jmp    c0102782 <__alltraps>

c0102b84 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102b84:	6a 00                	push   $0x0
  pushl $111
c0102b86:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102b88:	e9 f5 fb ff ff       	jmp    c0102782 <__alltraps>

c0102b8d <vector112>:
.globl vector112
vector112:
  pushl $0
c0102b8d:	6a 00                	push   $0x0
  pushl $112
c0102b8f:	6a 70                	push   $0x70
  jmp __alltraps
c0102b91:	e9 ec fb ff ff       	jmp    c0102782 <__alltraps>

c0102b96 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102b96:	6a 00                	push   $0x0
  pushl $113
c0102b98:	6a 71                	push   $0x71
  jmp __alltraps
c0102b9a:	e9 e3 fb ff ff       	jmp    c0102782 <__alltraps>

c0102b9f <vector114>:
.globl vector114
vector114:
  pushl $0
c0102b9f:	6a 00                	push   $0x0
  pushl $114
c0102ba1:	6a 72                	push   $0x72
  jmp __alltraps
c0102ba3:	e9 da fb ff ff       	jmp    c0102782 <__alltraps>

c0102ba8 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102ba8:	6a 00                	push   $0x0
  pushl $115
c0102baa:	6a 73                	push   $0x73
  jmp __alltraps
c0102bac:	e9 d1 fb ff ff       	jmp    c0102782 <__alltraps>

c0102bb1 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102bb1:	6a 00                	push   $0x0
  pushl $116
c0102bb3:	6a 74                	push   $0x74
  jmp __alltraps
c0102bb5:	e9 c8 fb ff ff       	jmp    c0102782 <__alltraps>

c0102bba <vector117>:
.globl vector117
vector117:
  pushl $0
c0102bba:	6a 00                	push   $0x0
  pushl $117
c0102bbc:	6a 75                	push   $0x75
  jmp __alltraps
c0102bbe:	e9 bf fb ff ff       	jmp    c0102782 <__alltraps>

c0102bc3 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102bc3:	6a 00                	push   $0x0
  pushl $118
c0102bc5:	6a 76                	push   $0x76
  jmp __alltraps
c0102bc7:	e9 b6 fb ff ff       	jmp    c0102782 <__alltraps>

c0102bcc <vector119>:
.globl vector119
vector119:
  pushl $0
c0102bcc:	6a 00                	push   $0x0
  pushl $119
c0102bce:	6a 77                	push   $0x77
  jmp __alltraps
c0102bd0:	e9 ad fb ff ff       	jmp    c0102782 <__alltraps>

c0102bd5 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102bd5:	6a 00                	push   $0x0
  pushl $120
c0102bd7:	6a 78                	push   $0x78
  jmp __alltraps
c0102bd9:	e9 a4 fb ff ff       	jmp    c0102782 <__alltraps>

c0102bde <vector121>:
.globl vector121
vector121:
  pushl $0
c0102bde:	6a 00                	push   $0x0
  pushl $121
c0102be0:	6a 79                	push   $0x79
  jmp __alltraps
c0102be2:	e9 9b fb ff ff       	jmp    c0102782 <__alltraps>

c0102be7 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102be7:	6a 00                	push   $0x0
  pushl $122
c0102be9:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102beb:	e9 92 fb ff ff       	jmp    c0102782 <__alltraps>

c0102bf0 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102bf0:	6a 00                	push   $0x0
  pushl $123
c0102bf2:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102bf4:	e9 89 fb ff ff       	jmp    c0102782 <__alltraps>

c0102bf9 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102bf9:	6a 00                	push   $0x0
  pushl $124
c0102bfb:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102bfd:	e9 80 fb ff ff       	jmp    c0102782 <__alltraps>

c0102c02 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c02:	6a 00                	push   $0x0
  pushl $125
c0102c04:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c06:	e9 77 fb ff ff       	jmp    c0102782 <__alltraps>

c0102c0b <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c0b:	6a 00                	push   $0x0
  pushl $126
c0102c0d:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c0f:	e9 6e fb ff ff       	jmp    c0102782 <__alltraps>

c0102c14 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c14:	6a 00                	push   $0x0
  pushl $127
c0102c16:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c18:	e9 65 fb ff ff       	jmp    c0102782 <__alltraps>

c0102c1d <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c1d:	6a 00                	push   $0x0
  pushl $128
c0102c1f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102c24:	e9 59 fb ff ff       	jmp    c0102782 <__alltraps>

c0102c29 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102c29:	6a 00                	push   $0x0
  pushl $129
c0102c2b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102c30:	e9 4d fb ff ff       	jmp    c0102782 <__alltraps>

c0102c35 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102c35:	6a 00                	push   $0x0
  pushl $130
c0102c37:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102c3c:	e9 41 fb ff ff       	jmp    c0102782 <__alltraps>

c0102c41 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102c41:	6a 00                	push   $0x0
  pushl $131
c0102c43:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102c48:	e9 35 fb ff ff       	jmp    c0102782 <__alltraps>

c0102c4d <vector132>:
.globl vector132
vector132:
  pushl $0
c0102c4d:	6a 00                	push   $0x0
  pushl $132
c0102c4f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c54:	e9 29 fb ff ff       	jmp    c0102782 <__alltraps>

c0102c59 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c59:	6a 00                	push   $0x0
  pushl $133
c0102c5b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c60:	e9 1d fb ff ff       	jmp    c0102782 <__alltraps>

c0102c65 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c65:	6a 00                	push   $0x0
  pushl $134
c0102c67:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c6c:	e9 11 fb ff ff       	jmp    c0102782 <__alltraps>

c0102c71 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c71:	6a 00                	push   $0x0
  pushl $135
c0102c73:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c78:	e9 05 fb ff ff       	jmp    c0102782 <__alltraps>

c0102c7d <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c7d:	6a 00                	push   $0x0
  pushl $136
c0102c7f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102c84:	e9 f9 fa ff ff       	jmp    c0102782 <__alltraps>

c0102c89 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102c89:	6a 00                	push   $0x0
  pushl $137
c0102c8b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102c90:	e9 ed fa ff ff       	jmp    c0102782 <__alltraps>

c0102c95 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102c95:	6a 00                	push   $0x0
  pushl $138
c0102c97:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102c9c:	e9 e1 fa ff ff       	jmp    c0102782 <__alltraps>

c0102ca1 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102ca1:	6a 00                	push   $0x0
  pushl $139
c0102ca3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102ca8:	e9 d5 fa ff ff       	jmp    c0102782 <__alltraps>

c0102cad <vector140>:
.globl vector140
vector140:
  pushl $0
c0102cad:	6a 00                	push   $0x0
  pushl $140
c0102caf:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102cb4:	e9 c9 fa ff ff       	jmp    c0102782 <__alltraps>

c0102cb9 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102cb9:	6a 00                	push   $0x0
  pushl $141
c0102cbb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102cc0:	e9 bd fa ff ff       	jmp    c0102782 <__alltraps>

c0102cc5 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102cc5:	6a 00                	push   $0x0
  pushl $142
c0102cc7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102ccc:	e9 b1 fa ff ff       	jmp    c0102782 <__alltraps>

c0102cd1 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102cd1:	6a 00                	push   $0x0
  pushl $143
c0102cd3:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102cd8:	e9 a5 fa ff ff       	jmp    c0102782 <__alltraps>

c0102cdd <vector144>:
.globl vector144
vector144:
  pushl $0
c0102cdd:	6a 00                	push   $0x0
  pushl $144
c0102cdf:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102ce4:	e9 99 fa ff ff       	jmp    c0102782 <__alltraps>

c0102ce9 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102ce9:	6a 00                	push   $0x0
  pushl $145
c0102ceb:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102cf0:	e9 8d fa ff ff       	jmp    c0102782 <__alltraps>

c0102cf5 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102cf5:	6a 00                	push   $0x0
  pushl $146
c0102cf7:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102cfc:	e9 81 fa ff ff       	jmp    c0102782 <__alltraps>

c0102d01 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d01:	6a 00                	push   $0x0
  pushl $147
c0102d03:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d08:	e9 75 fa ff ff       	jmp    c0102782 <__alltraps>

c0102d0d <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d0d:	6a 00                	push   $0x0
  pushl $148
c0102d0f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d14:	e9 69 fa ff ff       	jmp    c0102782 <__alltraps>

c0102d19 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d19:	6a 00                	push   $0x0
  pushl $149
c0102d1b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102d20:	e9 5d fa ff ff       	jmp    c0102782 <__alltraps>

c0102d25 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102d25:	6a 00                	push   $0x0
  pushl $150
c0102d27:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102d2c:	e9 51 fa ff ff       	jmp    c0102782 <__alltraps>

c0102d31 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102d31:	6a 00                	push   $0x0
  pushl $151
c0102d33:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102d38:	e9 45 fa ff ff       	jmp    c0102782 <__alltraps>

c0102d3d <vector152>:
.globl vector152
vector152:
  pushl $0
c0102d3d:	6a 00                	push   $0x0
  pushl $152
c0102d3f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102d44:	e9 39 fa ff ff       	jmp    c0102782 <__alltraps>

c0102d49 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102d49:	6a 00                	push   $0x0
  pushl $153
c0102d4b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d50:	e9 2d fa ff ff       	jmp    c0102782 <__alltraps>

c0102d55 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d55:	6a 00                	push   $0x0
  pushl $154
c0102d57:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d5c:	e9 21 fa ff ff       	jmp    c0102782 <__alltraps>

c0102d61 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d61:	6a 00                	push   $0x0
  pushl $155
c0102d63:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d68:	e9 15 fa ff ff       	jmp    c0102782 <__alltraps>

c0102d6d <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d6d:	6a 00                	push   $0x0
  pushl $156
c0102d6f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d74:	e9 09 fa ff ff       	jmp    c0102782 <__alltraps>

c0102d79 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d79:	6a 00                	push   $0x0
  pushl $157
c0102d7b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102d80:	e9 fd f9 ff ff       	jmp    c0102782 <__alltraps>

c0102d85 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102d85:	6a 00                	push   $0x0
  pushl $158
c0102d87:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102d8c:	e9 f1 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102d91 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102d91:	6a 00                	push   $0x0
  pushl $159
c0102d93:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102d98:	e9 e5 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102d9d <vector160>:
.globl vector160
vector160:
  pushl $0
c0102d9d:	6a 00                	push   $0x0
  pushl $160
c0102d9f:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102da4:	e9 d9 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102da9 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102da9:	6a 00                	push   $0x0
  pushl $161
c0102dab:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102db0:	e9 cd f9 ff ff       	jmp    c0102782 <__alltraps>

c0102db5 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102db5:	6a 00                	push   $0x0
  pushl $162
c0102db7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102dbc:	e9 c1 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102dc1 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102dc1:	6a 00                	push   $0x0
  pushl $163
c0102dc3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102dc8:	e9 b5 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102dcd <vector164>:
.globl vector164
vector164:
  pushl $0
c0102dcd:	6a 00                	push   $0x0
  pushl $164
c0102dcf:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102dd4:	e9 a9 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102dd9 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102dd9:	6a 00                	push   $0x0
  pushl $165
c0102ddb:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102de0:	e9 9d f9 ff ff       	jmp    c0102782 <__alltraps>

c0102de5 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102de5:	6a 00                	push   $0x0
  pushl $166
c0102de7:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102dec:	e9 91 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102df1 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102df1:	6a 00                	push   $0x0
  pushl $167
c0102df3:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102df8:	e9 85 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102dfd <vector168>:
.globl vector168
vector168:
  pushl $0
c0102dfd:	6a 00                	push   $0x0
  pushl $168
c0102dff:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e04:	e9 79 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102e09 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e09:	6a 00                	push   $0x0
  pushl $169
c0102e0b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e10:	e9 6d f9 ff ff       	jmp    c0102782 <__alltraps>

c0102e15 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e15:	6a 00                	push   $0x0
  pushl $170
c0102e17:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e1c:	e9 61 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102e21 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102e21:	6a 00                	push   $0x0
  pushl $171
c0102e23:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102e28:	e9 55 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102e2d <vector172>:
.globl vector172
vector172:
  pushl $0
c0102e2d:	6a 00                	push   $0x0
  pushl $172
c0102e2f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102e34:	e9 49 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102e39 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102e39:	6a 00                	push   $0x0
  pushl $173
c0102e3b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102e40:	e9 3d f9 ff ff       	jmp    c0102782 <__alltraps>

c0102e45 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102e45:	6a 00                	push   $0x0
  pushl $174
c0102e47:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e4c:	e9 31 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102e51 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e51:	6a 00                	push   $0x0
  pushl $175
c0102e53:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e58:	e9 25 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102e5d <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e5d:	6a 00                	push   $0x0
  pushl $176
c0102e5f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e64:	e9 19 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102e69 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e69:	6a 00                	push   $0x0
  pushl $177
c0102e6b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e70:	e9 0d f9 ff ff       	jmp    c0102782 <__alltraps>

c0102e75 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e75:	6a 00                	push   $0x0
  pushl $178
c0102e77:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e7c:	e9 01 f9 ff ff       	jmp    c0102782 <__alltraps>

c0102e81 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102e81:	6a 00                	push   $0x0
  pushl $179
c0102e83:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102e88:	e9 f5 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102e8d <vector180>:
.globl vector180
vector180:
  pushl $0
c0102e8d:	6a 00                	push   $0x0
  pushl $180
c0102e8f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102e94:	e9 e9 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102e99 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102e99:	6a 00                	push   $0x0
  pushl $181
c0102e9b:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102ea0:	e9 dd f8 ff ff       	jmp    c0102782 <__alltraps>

c0102ea5 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102ea5:	6a 00                	push   $0x0
  pushl $182
c0102ea7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102eac:	e9 d1 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102eb1 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102eb1:	6a 00                	push   $0x0
  pushl $183
c0102eb3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102eb8:	e9 c5 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102ebd <vector184>:
.globl vector184
vector184:
  pushl $0
c0102ebd:	6a 00                	push   $0x0
  pushl $184
c0102ebf:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102ec4:	e9 b9 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102ec9 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102ec9:	6a 00                	push   $0x0
  pushl $185
c0102ecb:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102ed0:	e9 ad f8 ff ff       	jmp    c0102782 <__alltraps>

c0102ed5 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102ed5:	6a 00                	push   $0x0
  pushl $186
c0102ed7:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102edc:	e9 a1 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102ee1 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102ee1:	6a 00                	push   $0x0
  pushl $187
c0102ee3:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102ee8:	e9 95 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102eed <vector188>:
.globl vector188
vector188:
  pushl $0
c0102eed:	6a 00                	push   $0x0
  pushl $188
c0102eef:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102ef4:	e9 89 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102ef9 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102ef9:	6a 00                	push   $0x0
  pushl $189
c0102efb:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102f00:	e9 7d f8 ff ff       	jmp    c0102782 <__alltraps>

c0102f05 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f05:	6a 00                	push   $0x0
  pushl $190
c0102f07:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f0c:	e9 71 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102f11 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f11:	6a 00                	push   $0x0
  pushl $191
c0102f13:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f18:	e9 65 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102f1d <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f1d:	6a 00                	push   $0x0
  pushl $192
c0102f1f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102f24:	e9 59 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102f29 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102f29:	6a 00                	push   $0x0
  pushl $193
c0102f2b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102f30:	e9 4d f8 ff ff       	jmp    c0102782 <__alltraps>

c0102f35 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102f35:	6a 00                	push   $0x0
  pushl $194
c0102f37:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102f3c:	e9 41 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102f41 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102f41:	6a 00                	push   $0x0
  pushl $195
c0102f43:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102f48:	e9 35 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102f4d <vector196>:
.globl vector196
vector196:
  pushl $0
c0102f4d:	6a 00                	push   $0x0
  pushl $196
c0102f4f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f54:	e9 29 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102f59 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f59:	6a 00                	push   $0x0
  pushl $197
c0102f5b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f60:	e9 1d f8 ff ff       	jmp    c0102782 <__alltraps>

c0102f65 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f65:	6a 00                	push   $0x0
  pushl $198
c0102f67:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f6c:	e9 11 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102f71 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f71:	6a 00                	push   $0x0
  pushl $199
c0102f73:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f78:	e9 05 f8 ff ff       	jmp    c0102782 <__alltraps>

c0102f7d <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f7d:	6a 00                	push   $0x0
  pushl $200
c0102f7f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102f84:	e9 f9 f7 ff ff       	jmp    c0102782 <__alltraps>

c0102f89 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102f89:	6a 00                	push   $0x0
  pushl $201
c0102f8b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102f90:	e9 ed f7 ff ff       	jmp    c0102782 <__alltraps>

c0102f95 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102f95:	6a 00                	push   $0x0
  pushl $202
c0102f97:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102f9c:	e9 e1 f7 ff ff       	jmp    c0102782 <__alltraps>

c0102fa1 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102fa1:	6a 00                	push   $0x0
  pushl $203
c0102fa3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102fa8:	e9 d5 f7 ff ff       	jmp    c0102782 <__alltraps>

c0102fad <vector204>:
.globl vector204
vector204:
  pushl $0
c0102fad:	6a 00                	push   $0x0
  pushl $204
c0102faf:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102fb4:	e9 c9 f7 ff ff       	jmp    c0102782 <__alltraps>

c0102fb9 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102fb9:	6a 00                	push   $0x0
  pushl $205
c0102fbb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102fc0:	e9 bd f7 ff ff       	jmp    c0102782 <__alltraps>

c0102fc5 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102fc5:	6a 00                	push   $0x0
  pushl $206
c0102fc7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102fcc:	e9 b1 f7 ff ff       	jmp    c0102782 <__alltraps>

c0102fd1 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102fd1:	6a 00                	push   $0x0
  pushl $207
c0102fd3:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102fd8:	e9 a5 f7 ff ff       	jmp    c0102782 <__alltraps>

c0102fdd <vector208>:
.globl vector208
vector208:
  pushl $0
c0102fdd:	6a 00                	push   $0x0
  pushl $208
c0102fdf:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102fe4:	e9 99 f7 ff ff       	jmp    c0102782 <__alltraps>

c0102fe9 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102fe9:	6a 00                	push   $0x0
  pushl $209
c0102feb:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102ff0:	e9 8d f7 ff ff       	jmp    c0102782 <__alltraps>

c0102ff5 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102ff5:	6a 00                	push   $0x0
  pushl $210
c0102ff7:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102ffc:	e9 81 f7 ff ff       	jmp    c0102782 <__alltraps>

c0103001 <vector211>:
.globl vector211
vector211:
  pushl $0
c0103001:	6a 00                	push   $0x0
  pushl $211
c0103003:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0103008:	e9 75 f7 ff ff       	jmp    c0102782 <__alltraps>

c010300d <vector212>:
.globl vector212
vector212:
  pushl $0
c010300d:	6a 00                	push   $0x0
  pushl $212
c010300f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103014:	e9 69 f7 ff ff       	jmp    c0102782 <__alltraps>

c0103019 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103019:	6a 00                	push   $0x0
  pushl $213
c010301b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0103020:	e9 5d f7 ff ff       	jmp    c0102782 <__alltraps>

c0103025 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103025:	6a 00                	push   $0x0
  pushl $214
c0103027:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010302c:	e9 51 f7 ff ff       	jmp    c0102782 <__alltraps>

c0103031 <vector215>:
.globl vector215
vector215:
  pushl $0
c0103031:	6a 00                	push   $0x0
  pushl $215
c0103033:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0103038:	e9 45 f7 ff ff       	jmp    c0102782 <__alltraps>

c010303d <vector216>:
.globl vector216
vector216:
  pushl $0
c010303d:	6a 00                	push   $0x0
  pushl $216
c010303f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103044:	e9 39 f7 ff ff       	jmp    c0102782 <__alltraps>

c0103049 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103049:	6a 00                	push   $0x0
  pushl $217
c010304b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103050:	e9 2d f7 ff ff       	jmp    c0102782 <__alltraps>

c0103055 <vector218>:
.globl vector218
vector218:
  pushl $0
c0103055:	6a 00                	push   $0x0
  pushl $218
c0103057:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010305c:	e9 21 f7 ff ff       	jmp    c0102782 <__alltraps>

c0103061 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103061:	6a 00                	push   $0x0
  pushl $219
c0103063:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0103068:	e9 15 f7 ff ff       	jmp    c0102782 <__alltraps>

c010306d <vector220>:
.globl vector220
vector220:
  pushl $0
c010306d:	6a 00                	push   $0x0
  pushl $220
c010306f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103074:	e9 09 f7 ff ff       	jmp    c0102782 <__alltraps>

c0103079 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103079:	6a 00                	push   $0x0
  pushl $221
c010307b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103080:	e9 fd f6 ff ff       	jmp    c0102782 <__alltraps>

c0103085 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103085:	6a 00                	push   $0x0
  pushl $222
c0103087:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010308c:	e9 f1 f6 ff ff       	jmp    c0102782 <__alltraps>

c0103091 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103091:	6a 00                	push   $0x0
  pushl $223
c0103093:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103098:	e9 e5 f6 ff ff       	jmp    c0102782 <__alltraps>

c010309d <vector224>:
.globl vector224
vector224:
  pushl $0
c010309d:	6a 00                	push   $0x0
  pushl $224
c010309f:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01030a4:	e9 d9 f6 ff ff       	jmp    c0102782 <__alltraps>

c01030a9 <vector225>:
.globl vector225
vector225:
  pushl $0
c01030a9:	6a 00                	push   $0x0
  pushl $225
c01030ab:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01030b0:	e9 cd f6 ff ff       	jmp    c0102782 <__alltraps>

c01030b5 <vector226>:
.globl vector226
vector226:
  pushl $0
c01030b5:	6a 00                	push   $0x0
  pushl $226
c01030b7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01030bc:	e9 c1 f6 ff ff       	jmp    c0102782 <__alltraps>

c01030c1 <vector227>:
.globl vector227
vector227:
  pushl $0
c01030c1:	6a 00                	push   $0x0
  pushl $227
c01030c3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01030c8:	e9 b5 f6 ff ff       	jmp    c0102782 <__alltraps>

c01030cd <vector228>:
.globl vector228
vector228:
  pushl $0
c01030cd:	6a 00                	push   $0x0
  pushl $228
c01030cf:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01030d4:	e9 a9 f6 ff ff       	jmp    c0102782 <__alltraps>

c01030d9 <vector229>:
.globl vector229
vector229:
  pushl $0
c01030d9:	6a 00                	push   $0x0
  pushl $229
c01030db:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01030e0:	e9 9d f6 ff ff       	jmp    c0102782 <__alltraps>

c01030e5 <vector230>:
.globl vector230
vector230:
  pushl $0
c01030e5:	6a 00                	push   $0x0
  pushl $230
c01030e7:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01030ec:	e9 91 f6 ff ff       	jmp    c0102782 <__alltraps>

c01030f1 <vector231>:
.globl vector231
vector231:
  pushl $0
c01030f1:	6a 00                	push   $0x0
  pushl $231
c01030f3:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01030f8:	e9 85 f6 ff ff       	jmp    c0102782 <__alltraps>

c01030fd <vector232>:
.globl vector232
vector232:
  pushl $0
c01030fd:	6a 00                	push   $0x0
  pushl $232
c01030ff:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103104:	e9 79 f6 ff ff       	jmp    c0102782 <__alltraps>

c0103109 <vector233>:
.globl vector233
vector233:
  pushl $0
c0103109:	6a 00                	push   $0x0
  pushl $233
c010310b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103110:	e9 6d f6 ff ff       	jmp    c0102782 <__alltraps>

c0103115 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103115:	6a 00                	push   $0x0
  pushl $234
c0103117:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010311c:	e9 61 f6 ff ff       	jmp    c0102782 <__alltraps>

c0103121 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103121:	6a 00                	push   $0x0
  pushl $235
c0103123:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103128:	e9 55 f6 ff ff       	jmp    c0102782 <__alltraps>

c010312d <vector236>:
.globl vector236
vector236:
  pushl $0
c010312d:	6a 00                	push   $0x0
  pushl $236
c010312f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103134:	e9 49 f6 ff ff       	jmp    c0102782 <__alltraps>

c0103139 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103139:	6a 00                	push   $0x0
  pushl $237
c010313b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103140:	e9 3d f6 ff ff       	jmp    c0102782 <__alltraps>

c0103145 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103145:	6a 00                	push   $0x0
  pushl $238
c0103147:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010314c:	e9 31 f6 ff ff       	jmp    c0102782 <__alltraps>

c0103151 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103151:	6a 00                	push   $0x0
  pushl $239
c0103153:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0103158:	e9 25 f6 ff ff       	jmp    c0102782 <__alltraps>

c010315d <vector240>:
.globl vector240
vector240:
  pushl $0
c010315d:	6a 00                	push   $0x0
  pushl $240
c010315f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103164:	e9 19 f6 ff ff       	jmp    c0102782 <__alltraps>

c0103169 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103169:	6a 00                	push   $0x0
  pushl $241
c010316b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103170:	e9 0d f6 ff ff       	jmp    c0102782 <__alltraps>

c0103175 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103175:	6a 00                	push   $0x0
  pushl $242
c0103177:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010317c:	e9 01 f6 ff ff       	jmp    c0102782 <__alltraps>

c0103181 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103181:	6a 00                	push   $0x0
  pushl $243
c0103183:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103188:	e9 f5 f5 ff ff       	jmp    c0102782 <__alltraps>

c010318d <vector244>:
.globl vector244
vector244:
  pushl $0
c010318d:	6a 00                	push   $0x0
  pushl $244
c010318f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103194:	e9 e9 f5 ff ff       	jmp    c0102782 <__alltraps>

c0103199 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103199:	6a 00                	push   $0x0
  pushl $245
c010319b:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01031a0:	e9 dd f5 ff ff       	jmp    c0102782 <__alltraps>

c01031a5 <vector246>:
.globl vector246
vector246:
  pushl $0
c01031a5:	6a 00                	push   $0x0
  pushl $246
c01031a7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01031ac:	e9 d1 f5 ff ff       	jmp    c0102782 <__alltraps>

c01031b1 <vector247>:
.globl vector247
vector247:
  pushl $0
c01031b1:	6a 00                	push   $0x0
  pushl $247
c01031b3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01031b8:	e9 c5 f5 ff ff       	jmp    c0102782 <__alltraps>

c01031bd <vector248>:
.globl vector248
vector248:
  pushl $0
c01031bd:	6a 00                	push   $0x0
  pushl $248
c01031bf:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01031c4:	e9 b9 f5 ff ff       	jmp    c0102782 <__alltraps>

c01031c9 <vector249>:
.globl vector249
vector249:
  pushl $0
c01031c9:	6a 00                	push   $0x0
  pushl $249
c01031cb:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01031d0:	e9 ad f5 ff ff       	jmp    c0102782 <__alltraps>

c01031d5 <vector250>:
.globl vector250
vector250:
  pushl $0
c01031d5:	6a 00                	push   $0x0
  pushl $250
c01031d7:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01031dc:	e9 a1 f5 ff ff       	jmp    c0102782 <__alltraps>

c01031e1 <vector251>:
.globl vector251
vector251:
  pushl $0
c01031e1:	6a 00                	push   $0x0
  pushl $251
c01031e3:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01031e8:	e9 95 f5 ff ff       	jmp    c0102782 <__alltraps>

c01031ed <vector252>:
.globl vector252
vector252:
  pushl $0
c01031ed:	6a 00                	push   $0x0
  pushl $252
c01031ef:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01031f4:	e9 89 f5 ff ff       	jmp    c0102782 <__alltraps>

c01031f9 <vector253>:
.globl vector253
vector253:
  pushl $0
c01031f9:	6a 00                	push   $0x0
  pushl $253
c01031fb:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103200:	e9 7d f5 ff ff       	jmp    c0102782 <__alltraps>

c0103205 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103205:	6a 00                	push   $0x0
  pushl $254
c0103207:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010320c:	e9 71 f5 ff ff       	jmp    c0102782 <__alltraps>

c0103211 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103211:	6a 00                	push   $0x0
  pushl $255
c0103213:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103218:	e9 65 f5 ff ff       	jmp    c0102782 <__alltraps>

c010321d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010321d:	55                   	push   %ebp
c010321e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103220:	8b 55 08             	mov    0x8(%ebp),%edx
c0103223:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0103228:	29 c2                	sub    %eax,%edx
c010322a:	89 d0                	mov    %edx,%eax
c010322c:	c1 f8 05             	sar    $0x5,%eax
}
c010322f:	5d                   	pop    %ebp
c0103230:	c3                   	ret    

c0103231 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103231:	55                   	push   %ebp
c0103232:	89 e5                	mov    %esp,%ebp
c0103234:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103237:	8b 45 08             	mov    0x8(%ebp),%eax
c010323a:	89 04 24             	mov    %eax,(%esp)
c010323d:	e8 db ff ff ff       	call   c010321d <page2ppn>
c0103242:	c1 e0 0c             	shl    $0xc,%eax
}
c0103245:	c9                   	leave  
c0103246:	c3                   	ret    

c0103247 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103247:	55                   	push   %ebp
c0103248:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010324a:	8b 45 08             	mov    0x8(%ebp),%eax
c010324d:	8b 00                	mov    (%eax),%eax
}
c010324f:	5d                   	pop    %ebp
c0103250:	c3                   	ret    

c0103251 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103251:	55                   	push   %ebp
c0103252:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103254:	8b 45 08             	mov    0x8(%ebp),%eax
c0103257:	8b 55 0c             	mov    0xc(%ebp),%edx
c010325a:	89 10                	mov    %edx,(%eax)
}
c010325c:	5d                   	pop    %ebp
c010325d:	c3                   	ret    

c010325e <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010325e:	55                   	push   %ebp
c010325f:	89 e5                	mov    %esp,%ebp
c0103261:	83 ec 10             	sub    $0x10,%esp
c0103264:	c7 45 fc 18 7b 12 c0 	movl   $0xc0127b18,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010326b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010326e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103271:	89 50 04             	mov    %edx,0x4(%eax)
c0103274:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103277:	8b 50 04             	mov    0x4(%eax),%edx
c010327a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010327d:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010327f:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103286:	00 00 00 
}
c0103289:	c9                   	leave  
c010328a:	c3                   	ret    

c010328b <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010328b:	55                   	push   %ebp
c010328c:	89 e5                	mov    %esp,%ebp
c010328e:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103291:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103295:	75 24                	jne    c01032bb <default_init_memmap+0x30>
c0103297:	c7 44 24 0c 30 a5 10 	movl   $0xc010a530,0xc(%esp)
c010329e:	c0 
c010329f:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01032a6:	c0 
c01032a7:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01032ae:	00 
c01032af:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01032b6:	e8 22 da ff ff       	call   c0100cdd <__panic>
    struct Page *p = base;
c01032bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01032be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01032c1:	e9 de 00 00 00       	jmp    c01033a4 <default_init_memmap+0x119>
        assert(PageReserved(p));
c01032c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032c9:	83 c0 04             	add    $0x4,%eax
c01032cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01032d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01032d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01032dc:	0f a3 10             	bt     %edx,(%eax)
c01032df:	19 c0                	sbb    %eax,%eax
c01032e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01032e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01032e8:	0f 95 c0             	setne  %al
c01032eb:	0f b6 c0             	movzbl %al,%eax
c01032ee:	85 c0                	test   %eax,%eax
c01032f0:	75 24                	jne    c0103316 <default_init_memmap+0x8b>
c01032f2:	c7 44 24 0c 61 a5 10 	movl   $0xc010a561,0xc(%esp)
c01032f9:	c0 
c01032fa:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103301:	c0 
c0103302:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0103309:	00 
c010330a:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103311:	e8 c7 d9 ff ff       	call   c0100cdd <__panic>
        p->flags = p->property = 0;
c0103316:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103319:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0103320:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103323:	8b 50 08             	mov    0x8(%eax),%edx
c0103326:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103329:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010332c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103333:	00 
c0103334:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103337:	89 04 24             	mov    %eax,(%esp)
c010333a:	e8 12 ff ff ff       	call   c0103251 <set_page_ref>
        SetPageProperty(p);
c010333f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103342:	83 c0 04             	add    $0x4,%eax
c0103345:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010334c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010334f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103352:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103355:	0f ab 10             	bts    %edx,(%eax)
        list_add_before(&free_list, &(p->page_link));
c0103358:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010335b:	83 c0 0c             	add    $0xc,%eax
c010335e:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
c0103365:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103368:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010336b:	8b 00                	mov    (%eax),%eax
c010336d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103370:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103373:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103376:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103379:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010337c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010337f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103382:	89 10                	mov    %edx,(%eax)
c0103384:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103387:	8b 10                	mov    (%eax),%edx
c0103389:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010338c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010338f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103392:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103395:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010339b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010339e:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01033a0:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01033a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033a7:	c1 e0 05             	shl    $0x5,%eax
c01033aa:	89 c2                	mov    %eax,%edx
c01033ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01033af:	01 d0                	add    %edx,%eax
c01033b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01033b4:	0f 85 0c ff ff ff    	jne    c01032c6 <default_init_memmap+0x3b>
        p->flags = p->property = 0;
        set_page_ref(p, 0);
        SetPageProperty(p);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c01033ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01033bd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01033c0:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c01033c3:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c01033c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033cc:	01 d0                	add    %edx,%eax
c01033ce:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
}
c01033d3:	c9                   	leave  
c01033d4:	c3                   	ret    

c01033d5 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01033d5:	55                   	push   %ebp
c01033d6:	89 e5                	mov    %esp,%ebp
c01033d8:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01033db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01033df:	75 24                	jne    c0103405 <default_alloc_pages+0x30>
c01033e1:	c7 44 24 0c 30 a5 10 	movl   $0xc010a530,0xc(%esp)
c01033e8:	c0 
c01033e9:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01033f0:	c0 
c01033f1:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c01033f8:	00 
c01033f9:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103400:	e8 d8 d8 ff ff       	call   c0100cdd <__panic>
    if (n > nr_free) {
c0103405:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c010340a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010340d:	73 0a                	jae    c0103419 <default_alloc_pages+0x44>
        return NULL;
c010340f:	b8 00 00 00 00       	mov    $0x0,%eax
c0103414:	e9 37 01 00 00       	jmp    c0103550 <default_alloc_pages+0x17b>
    }

    list_entry_t *len;			// 跟以前的p和q双指针差不多，le相当于前指针，len后指针
    list_entry_t *le = &free_list;
c0103419:	c7 45 f4 18 7b 12 c0 	movl   $0xc0127b18,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103420:	e9 0a 01 00 00       	jmp    c010352f <default_alloc_pages+0x15a>
        struct Page *p = le2page(le, page_link);
c0103425:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103428:	83 e8 0c             	sub    $0xc,%eax
c010342b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c010342e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103431:	8b 40 08             	mov    0x8(%eax),%eax
c0103434:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103437:	0f 82 f2 00 00 00    	jb     c010352f <default_alloc_pages+0x15a>
            // 分配页数
            int i;
            for (i = 0; i < n; i++) {
c010343d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103444:	eb 7c                	jmp    c01034c2 <default_alloc_pages+0xed>
c0103446:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103449:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010344c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010344f:	8b 40 04             	mov    0x4(%eax),%eax
            	len = list_next(le);
c0103452:	89 45 e8             	mov    %eax,-0x18(%ebp)
            	struct Page *pp = le2page(le, page_link);
c0103455:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103458:	83 e8 0c             	sub    $0xc,%eax
c010345b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            	// 每一页的标志位改写
            	// 被内核所保留
            	SetPageReserved(pp);
c010345e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103461:	83 c0 04             	add    $0x4,%eax
c0103464:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010346b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010346e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103471:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103474:	0f ab 10             	bts    %edx,(%eax)
            	// 不是头页
            	ClearPageProperty(pp);
c0103477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010347a:	83 c0 04             	add    $0x4,%eax
c010347d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103484:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103487:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010348a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010348d:	0f b3 10             	btr    %edx,(%eax)
c0103490:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103493:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103496:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103499:	8b 40 04             	mov    0x4(%eax),%eax
c010349c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010349f:	8b 12                	mov    (%edx),%edx
c01034a1:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01034a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01034a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01034aa:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01034ad:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01034b0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01034b3:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01034b6:	89 10                	mov    %edx,(%eax)
            	// 既然分配好了，下一步就将其从freelist中删除
            	list_del(le);
            	le = len;
c01034b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            // 分配页数
            int i;
            for (i = 0; i < n; i++) {
c01034be:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01034c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034c5:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034c8:	0f 82 78 ff ff ff    	jb     c0103446 <default_alloc_pages+0x71>
            	ClearPageProperty(pp);
            	// 既然分配好了，下一步就将其从freelist中删除
            	list_del(le);
            	le = len;
            }
            if (p->property > n) {
c01034ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034d1:	8b 40 08             	mov    0x8(%eax),%eax
c01034d4:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034d7:	76 12                	jbe    c01034eb <default_alloc_pages+0x116>
				// p指针移动到顶部（这里好象是反着的，其实到了头页）
				// 修改头页的标志位，可参考高书8.3.2
				//struct Page *p = le2page(le, page_link);
				le2page(le, page_link)->property = p->property - n;
c01034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034dc:	8d 50 f4             	lea    -0xc(%eax),%edx
c01034df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034e2:	8b 40 08             	mov    0x8(%eax),%eax
c01034e5:	2b 45 08             	sub    0x8(%ebp),%eax
c01034e8:	89 42 08             	mov    %eax,0x8(%edx)
			}
            // 修改头页的标志位
            ClearPageProperty(p);
c01034eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034ee:	83 c0 04             	add    $0x4,%eax
c01034f1:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01034f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01034fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034fe:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103501:	0f b3 10             	btr    %edx,(%eax)
            SetPageReserved(p);
c0103504:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103507:	83 c0 04             	add    $0x4,%eax
c010350a:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c0103511:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103514:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103517:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010351a:	0f ab 10             	bts    %edx,(%eax)
            nr_free -= n;
c010351d:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103522:	2b 45 08             	sub    0x8(%ebp),%eax
c0103525:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
            return p;
c010352a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010352d:	eb 21                	jmp    c0103550 <default_alloc_pages+0x17b>
c010352f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103532:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103535:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103538:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }

    list_entry_t *len;			// 跟以前的p和q双指针差不多，le相当于前指针，len后指针
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010353b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010353e:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c0103545:	0f 85 da fe ff ff    	jne    c0103425 <default_alloc_pages+0x50>
            SetPageReserved(p);
            nr_free -= n;
            return p;
        }
    }
    return NULL;
c010354b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103550:	c9                   	leave  
c0103551:	c3                   	ret    

c0103552 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103552:	55                   	push   %ebp
c0103553:	89 e5                	mov    %esp,%ebp
c0103555:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0103558:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010355c:	75 24                	jne    c0103582 <default_free_pages+0x30>
c010355e:	c7 44 24 0c 30 a5 10 	movl   $0xc010a530,0xc(%esp)
c0103565:	c0 
c0103566:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c010356d:	c0 
c010356e:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
c0103575:	00 
c0103576:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c010357d:	e8 5b d7 ff ff       	call   c0100cdd <__panic>
    // 断言是被内核保留页
    // 这里我不明白为什么申请和释放都标记为“内核保留”？？？
    assert(PageReserved(base));
c0103582:	8b 45 08             	mov    0x8(%ebp),%eax
c0103585:	83 c0 04             	add    $0x4,%eax
c0103588:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010358f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103592:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103595:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103598:	0f a3 10             	bt     %edx,(%eax)
c010359b:	19 c0                	sbb    %eax,%eax
c010359d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c01035a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01035a4:	0f 95 c0             	setne  %al
c01035a7:	0f b6 c0             	movzbl %al,%eax
c01035aa:	85 c0                	test   %eax,%eax
c01035ac:	75 24                	jne    c01035d2 <default_free_pages+0x80>
c01035ae:	c7 44 24 0c 71 a5 10 	movl   $0xc010a571,0xc(%esp)
c01035b5:	c0 
c01035b6:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01035bd:	c0 
c01035be:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c01035c5:	00 
c01035c6:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01035cd:	e8 0b d7 ff ff       	call   c0100cdd <__panic>
    struct Page *p;
    list_entry_t *le = &free_list;
c01035d2:	c7 45 f0 18 7b 12 c0 	movl   $0xc0127b18,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01035d9:	eb 13                	jmp    c01035ee <default_free_pages+0x9c>
    	p = le2page(le, page_link);
c01035db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035de:	83 e8 0c             	sub    $0xc,%eax
c01035e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (p>base) {
c01035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01035ea:	76 02                	jbe    c01035ee <default_free_pages+0x9c>
			break;
c01035ec:	eb 18                	jmp    c0103606 <default_free_pages+0xb4>
c01035ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01035f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035f7:	8b 40 04             	mov    0x4(%eax),%eax
    // 断言是被内核保留页
    // 这里我不明白为什么申请和释放都标记为“内核保留”？？？
    assert(PageReserved(base));
    struct Page *p;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01035fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035fd:	81 7d f0 18 7b 12 c0 	cmpl   $0xc0127b18,-0x10(%ebp)
c0103604:	75 d5                	jne    c01035db <default_free_pages+0x89>
    	p = le2page(le, page_link);
		if (p>base) {
			break;
		}
    }
    for (p=base; p < base + n; p ++) {
c0103606:	8b 45 08             	mov    0x8(%ebp),%eax
c0103609:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010360c:	eb 4b                	jmp    c0103659 <default_free_pages+0x107>
    	// 因为被释放了，所以重新加回到freelist中
    	list_add_before(le, &(p->page_link));
c010360e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103611:	8d 50 0c             	lea    0xc(%eax),%edx
c0103614:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103617:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010361a:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010361d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103620:	8b 00                	mov    (%eax),%eax
c0103622:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103625:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103628:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010362b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010362e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103631:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103634:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103637:	89 10                	mov    %edx,(%eax)
c0103639:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010363c:	8b 10                	mov    (%eax),%edx
c010363e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103641:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103644:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103647:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010364a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010364d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103650:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103653:	89 10                	mov    %edx,(%eax)
    	p = le2page(le, page_link);
		if (p>base) {
			break;
		}
    }
    for (p=base; p < base + n; p ++) {
c0103655:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103659:	8b 45 0c             	mov    0xc(%ebp),%eax
c010365c:	c1 e0 05             	shl    $0x5,%eax
c010365f:	89 c2                	mov    %eax,%edx
c0103661:	8b 45 08             	mov    0x8(%ebp),%eax
c0103664:	01 d0                	add    %edx,%eax
c0103666:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103669:	77 a3                	ja     c010360e <default_free_pages+0xbc>
    	list_add_before(le, &(p->page_link));
    	// 每一页的标志位不用改了，改下头页就行了
    }

    // 下面这几句话是有顺序的？？？
    base->flags = 0;
c010366b:	8b 45 08             	mov    0x8(%ebp),%eax
c010366e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0103675:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010367c:	00 
c010367d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103680:	89 04 24             	mov    %eax,(%esp)
c0103683:	e8 c9 fb ff ff       	call   c0103251 <set_page_ref>
    // 声明是头页
    SetPageProperty(base);
c0103688:	8b 45 08             	mov    0x8(%ebp),%eax
c010368b:	83 c0 04             	add    $0x4,%eax
c010368e:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0103695:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103698:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010369b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010369e:	0f ab 10             	bts    %edx,(%eax)
    // 记录空闲页的数目n
    base->property = n;
c01036a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01036a4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01036a7:	89 50 08             	mov    %edx,0x8(%eax)



    // 向高位合并
    p = le2page(le, page_link);
c01036aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036ad:	83 e8 0c             	sub    $0xc,%eax
c01036b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // p在高地址，base在低地址
    if (p == base + n) {
c01036b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036b6:	c1 e0 05             	shl    $0x5,%eax
c01036b9:	89 c2                	mov    %eax,%edx
c01036bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01036be:	01 d0                	add    %edx,%eax
c01036c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036c3:	75 1e                	jne    c01036e3 <default_free_pages+0x191>
    	// 下面的base的property改下
    	base->property = base->property + p->property;
c01036c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01036c8:	8b 50 08             	mov    0x8(%eax),%edx
c01036cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ce:	8b 40 08             	mov    0x8(%eax),%eax
c01036d1:	01 c2                	add    %eax,%edx
c01036d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01036d6:	89 50 08             	mov    %edx,0x8(%eax)
    	// 中间那层打掉了，参考高书图8-5
    	p->property = 0;
c01036d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }

    // 向低位合并，参考高书图8-6
    // 现在是在空闲结点（高书中间下面的那个），指针先往前移一个结点，就是高书图8-6(a)最中间的结点（p指向的那个）
    le = list_prev(&base->page_link);
c01036e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01036e6:	83 c0 0c             	add    $0xc,%eax
c01036e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01036ec:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01036ef:	8b 00                	mov    (%eax),%eax
c01036f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(le, page_link);
c01036f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036f7:	83 e8 0c             	sub    $0xc,%eax
c01036fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // p指向中间上面结点的头页，base指向中间下面的结点的头页
    if (le != &free_list && p == base - 1) {
c01036fd:	81 7d f0 18 7b 12 c0 	cmpl   $0xc0127b18,-0x10(%ebp)
c0103704:	74 57                	je     c010375d <default_free_pages+0x20b>
c0103706:	8b 45 08             	mov    0x8(%ebp),%eax
c0103709:	83 e8 20             	sub    $0x20,%eax
c010370c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010370f:	75 4c                	jne    c010375d <default_free_pages+0x20b>
    	// 直到找到右边的空闲页
    	while (le != &free_list) {
c0103711:	eb 41                	jmp    c0103754 <default_free_pages+0x202>
    		// 中间上面的结点非空
    		if (p->property > 0) {
c0103713:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103716:	8b 40 08             	mov    0x8(%eax),%eax
c0103719:	85 c0                	test   %eax,%eax
c010371b:	74 20                	je     c010373d <default_free_pages+0x1eb>
    			p->property = base->property + p->property;
c010371d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103720:	8b 50 08             	mov    0x8(%eax),%edx
c0103723:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103726:	8b 40 08             	mov    0x8(%eax),%eax
c0103729:	01 c2                	add    %eax,%edx
c010372b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010372e:	89 50 08             	mov    %edx,0x8(%eax)
    			base->property = 0;
c0103731:	8b 45 08             	mov    0x8(%ebp),%eax
c0103734:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    			break;
c010373b:	eb 20                	jmp    c010375d <default_free_pages+0x20b>
c010373d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103740:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103743:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103746:	8b 00                	mov    (%eax),%eax
    		}
    		// 那没找到右边空间页，就往前走
    		le = list_prev(le);
c0103748:	89 45 f0             	mov    %eax,-0x10(%ebp)
    		p = le2page(le, page_link);
c010374b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010374e:	83 e8 0c             	sub    $0xc,%eax
c0103751:	89 45 f4             	mov    %eax,-0xc(%ebp)
    le = list_prev(&base->page_link);
    p = le2page(le, page_link);
    // p指向中间上面结点的头页，base指向中间下面的结点的头页
    if (le != &free_list && p == base - 1) {
    	// 直到找到右边的空闲页
    	while (le != &free_list) {
c0103754:	81 7d f0 18 7b 12 c0 	cmpl   $0xc0127b18,-0x10(%ebp)
c010375b:	75 b6                	jne    c0103713 <default_free_pages+0x1c1>
    		le = list_prev(le);
    		p = le2page(le, page_link);

    	}
    }
    nr_free += n;
c010375d:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c0103763:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103766:	01 d0                	add    %edx,%eax
c0103768:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
}
c010376d:	c9                   	leave  
c010376e:	c3                   	ret    

c010376f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010376f:	55                   	push   %ebp
c0103770:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103772:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
}
c0103777:	5d                   	pop    %ebp
c0103778:	c3                   	ret    

c0103779 <basic_check>:

static void
basic_check(void) {
c0103779:	55                   	push   %ebp
c010377a:	89 e5                	mov    %esp,%ebp
c010377c:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010377f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103786:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103789:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010378c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010378f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103792:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103799:	e8 c4 15 00 00       	call   c0104d62 <alloc_pages>
c010379e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01037a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01037a5:	75 24                	jne    c01037cb <basic_check+0x52>
c01037a7:	c7 44 24 0c 84 a5 10 	movl   $0xc010a584,0xc(%esp)
c01037ae:	c0 
c01037af:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01037b6:	c0 
c01037b7:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c01037be:	00 
c01037bf:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01037c6:	e8 12 d5 ff ff       	call   c0100cdd <__panic>
    assert((p1 = alloc_page()) != NULL);
c01037cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037d2:	e8 8b 15 00 00       	call   c0104d62 <alloc_pages>
c01037d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01037da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01037de:	75 24                	jne    c0103804 <basic_check+0x8b>
c01037e0:	c7 44 24 0c a0 a5 10 	movl   $0xc010a5a0,0xc(%esp)
c01037e7:	c0 
c01037e8:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01037ef:	c0 
c01037f0:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c01037f7:	00 
c01037f8:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01037ff:	e8 d9 d4 ff ff       	call   c0100cdd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103804:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010380b:	e8 52 15 00 00       	call   c0104d62 <alloc_pages>
c0103810:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103813:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103817:	75 24                	jne    c010383d <basic_check+0xc4>
c0103819:	c7 44 24 0c bc a5 10 	movl   $0xc010a5bc,0xc(%esp)
c0103820:	c0 
c0103821:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103828:	c0 
c0103829:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103830:	00 
c0103831:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103838:	e8 a0 d4 ff ff       	call   c0100cdd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010383d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103840:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103843:	74 10                	je     c0103855 <basic_check+0xdc>
c0103845:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103848:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010384b:	74 08                	je     c0103855 <basic_check+0xdc>
c010384d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103850:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103853:	75 24                	jne    c0103879 <basic_check+0x100>
c0103855:	c7 44 24 0c d8 a5 10 	movl   $0xc010a5d8,0xc(%esp)
c010385c:	c0 
c010385d:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103864:	c0 
c0103865:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c010386c:	00 
c010386d:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103874:	e8 64 d4 ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103879:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010387c:	89 04 24             	mov    %eax,(%esp)
c010387f:	e8 c3 f9 ff ff       	call   c0103247 <page_ref>
c0103884:	85 c0                	test   %eax,%eax
c0103886:	75 1e                	jne    c01038a6 <basic_check+0x12d>
c0103888:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010388b:	89 04 24             	mov    %eax,(%esp)
c010388e:	e8 b4 f9 ff ff       	call   c0103247 <page_ref>
c0103893:	85 c0                	test   %eax,%eax
c0103895:	75 0f                	jne    c01038a6 <basic_check+0x12d>
c0103897:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010389a:	89 04 24             	mov    %eax,(%esp)
c010389d:	e8 a5 f9 ff ff       	call   c0103247 <page_ref>
c01038a2:	85 c0                	test   %eax,%eax
c01038a4:	74 24                	je     c01038ca <basic_check+0x151>
c01038a6:	c7 44 24 0c fc a5 10 	movl   $0xc010a5fc,0xc(%esp)
c01038ad:	c0 
c01038ae:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01038b5:	c0 
c01038b6:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c01038bd:	00 
c01038be:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01038c5:	e8 13 d4 ff ff       	call   c0100cdd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01038ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038cd:	89 04 24             	mov    %eax,(%esp)
c01038d0:	e8 5c f9 ff ff       	call   c0103231 <page2pa>
c01038d5:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c01038db:	c1 e2 0c             	shl    $0xc,%edx
c01038de:	39 d0                	cmp    %edx,%eax
c01038e0:	72 24                	jb     c0103906 <basic_check+0x18d>
c01038e2:	c7 44 24 0c 38 a6 10 	movl   $0xc010a638,0xc(%esp)
c01038e9:	c0 
c01038ea:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01038f1:	c0 
c01038f2:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c01038f9:	00 
c01038fa:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103901:	e8 d7 d3 ff ff       	call   c0100cdd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103906:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103909:	89 04 24             	mov    %eax,(%esp)
c010390c:	e8 20 f9 ff ff       	call   c0103231 <page2pa>
c0103911:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103917:	c1 e2 0c             	shl    $0xc,%edx
c010391a:	39 d0                	cmp    %edx,%eax
c010391c:	72 24                	jb     c0103942 <basic_check+0x1c9>
c010391e:	c7 44 24 0c 55 a6 10 	movl   $0xc010a655,0xc(%esp)
c0103925:	c0 
c0103926:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c010392d:	c0 
c010392e:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103935:	00 
c0103936:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c010393d:	e8 9b d3 ff ff       	call   c0100cdd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103942:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103945:	89 04 24             	mov    %eax,(%esp)
c0103948:	e8 e4 f8 ff ff       	call   c0103231 <page2pa>
c010394d:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103953:	c1 e2 0c             	shl    $0xc,%edx
c0103956:	39 d0                	cmp    %edx,%eax
c0103958:	72 24                	jb     c010397e <basic_check+0x205>
c010395a:	c7 44 24 0c 72 a6 10 	movl   $0xc010a672,0xc(%esp)
c0103961:	c0 
c0103962:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103969:	c0 
c010396a:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103971:	00 
c0103972:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103979:	e8 5f d3 ff ff       	call   c0100cdd <__panic>

    list_entry_t free_list_store = free_list;
c010397e:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0103983:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103989:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010398c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010398f:	c7 45 e0 18 7b 12 c0 	movl   $0xc0127b18,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103996:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103999:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010399c:	89 50 04             	mov    %edx,0x4(%eax)
c010399f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039a2:	8b 50 04             	mov    0x4(%eax),%edx
c01039a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039a8:	89 10                	mov    %edx,(%eax)
c01039aa:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01039b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039b4:	8b 40 04             	mov    0x4(%eax),%eax
c01039b7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01039ba:	0f 94 c0             	sete   %al
c01039bd:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01039c0:	85 c0                	test   %eax,%eax
c01039c2:	75 24                	jne    c01039e8 <basic_check+0x26f>
c01039c4:	c7 44 24 0c 8f a6 10 	movl   $0xc010a68f,0xc(%esp)
c01039cb:	c0 
c01039cc:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01039d3:	c0 
c01039d4:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01039db:	00 
c01039dc:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01039e3:	e8 f5 d2 ff ff       	call   c0100cdd <__panic>

    unsigned int nr_free_store = nr_free;
c01039e8:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01039ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01039f0:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c01039f7:	00 00 00 

    assert(alloc_page() == NULL);
c01039fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a01:	e8 5c 13 00 00       	call   c0104d62 <alloc_pages>
c0103a06:	85 c0                	test   %eax,%eax
c0103a08:	74 24                	je     c0103a2e <basic_check+0x2b5>
c0103a0a:	c7 44 24 0c a6 a6 10 	movl   $0xc010a6a6,0xc(%esp)
c0103a11:	c0 
c0103a12:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103a19:	c0 
c0103a1a:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103a21:	00 
c0103a22:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103a29:	e8 af d2 ff ff       	call   c0100cdd <__panic>

    free_page(p0);
c0103a2e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a35:	00 
c0103a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a39:	89 04 24             	mov    %eax,(%esp)
c0103a3c:	e8 8c 13 00 00       	call   c0104dcd <free_pages>
    free_page(p1);
c0103a41:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a48:	00 
c0103a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a4c:	89 04 24             	mov    %eax,(%esp)
c0103a4f:	e8 79 13 00 00       	call   c0104dcd <free_pages>
    free_page(p2);
c0103a54:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a5b:	00 
c0103a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a5f:	89 04 24             	mov    %eax,(%esp)
c0103a62:	e8 66 13 00 00       	call   c0104dcd <free_pages>
    assert(nr_free == 3);
c0103a67:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103a6c:	83 f8 03             	cmp    $0x3,%eax
c0103a6f:	74 24                	je     c0103a95 <basic_check+0x31c>
c0103a71:	c7 44 24 0c bb a6 10 	movl   $0xc010a6bb,0xc(%esp)
c0103a78:	c0 
c0103a79:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103a80:	c0 
c0103a81:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103a88:	00 
c0103a89:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103a90:	e8 48 d2 ff ff       	call   c0100cdd <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103a95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a9c:	e8 c1 12 00 00       	call   c0104d62 <alloc_pages>
c0103aa1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103aa4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103aa8:	75 24                	jne    c0103ace <basic_check+0x355>
c0103aaa:	c7 44 24 0c 84 a5 10 	movl   $0xc010a584,0xc(%esp)
c0103ab1:	c0 
c0103ab2:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103ab9:	c0 
c0103aba:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0103ac1:	00 
c0103ac2:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103ac9:	e8 0f d2 ff ff       	call   c0100cdd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103ace:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ad5:	e8 88 12 00 00       	call   c0104d62 <alloc_pages>
c0103ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103add:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103ae1:	75 24                	jne    c0103b07 <basic_check+0x38e>
c0103ae3:	c7 44 24 0c a0 a5 10 	movl   $0xc010a5a0,0xc(%esp)
c0103aea:	c0 
c0103aeb:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103af2:	c0 
c0103af3:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0103afa:	00 
c0103afb:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103b02:	e8 d6 d1 ff ff       	call   c0100cdd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103b07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b0e:	e8 4f 12 00 00       	call   c0104d62 <alloc_pages>
c0103b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103b16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b1a:	75 24                	jne    c0103b40 <basic_check+0x3c7>
c0103b1c:	c7 44 24 0c bc a5 10 	movl   $0xc010a5bc,0xc(%esp)
c0103b23:	c0 
c0103b24:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103b2b:	c0 
c0103b2c:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0103b33:	00 
c0103b34:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103b3b:	e8 9d d1 ff ff       	call   c0100cdd <__panic>

    assert(alloc_page() == NULL);
c0103b40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b47:	e8 16 12 00 00       	call   c0104d62 <alloc_pages>
c0103b4c:	85 c0                	test   %eax,%eax
c0103b4e:	74 24                	je     c0103b74 <basic_check+0x3fb>
c0103b50:	c7 44 24 0c a6 a6 10 	movl   $0xc010a6a6,0xc(%esp)
c0103b57:	c0 
c0103b58:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103b5f:	c0 
c0103b60:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103b67:	00 
c0103b68:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103b6f:	e8 69 d1 ff ff       	call   c0100cdd <__panic>

    free_page(p0);
c0103b74:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b7b:	00 
c0103b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b7f:	89 04 24             	mov    %eax,(%esp)
c0103b82:	e8 46 12 00 00       	call   c0104dcd <free_pages>
c0103b87:	c7 45 d8 18 7b 12 c0 	movl   $0xc0127b18,-0x28(%ebp)
c0103b8e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b91:	8b 40 04             	mov    0x4(%eax),%eax
c0103b94:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103b97:	0f 94 c0             	sete   %al
c0103b9a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103b9d:	85 c0                	test   %eax,%eax
c0103b9f:	74 24                	je     c0103bc5 <basic_check+0x44c>
c0103ba1:	c7 44 24 0c c8 a6 10 	movl   $0xc010a6c8,0xc(%esp)
c0103ba8:	c0 
c0103ba9:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103bb0:	c0 
c0103bb1:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103bb8:	00 
c0103bb9:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103bc0:	e8 18 d1 ff ff       	call   c0100cdd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103bc5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bcc:	e8 91 11 00 00       	call   c0104d62 <alloc_pages>
c0103bd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103bd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bd7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103bda:	74 24                	je     c0103c00 <basic_check+0x487>
c0103bdc:	c7 44 24 0c e0 a6 10 	movl   $0xc010a6e0,0xc(%esp)
c0103be3:	c0 
c0103be4:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103beb:	c0 
c0103bec:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0103bf3:	00 
c0103bf4:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103bfb:	e8 dd d0 ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c0103c00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c07:	e8 56 11 00 00       	call   c0104d62 <alloc_pages>
c0103c0c:	85 c0                	test   %eax,%eax
c0103c0e:	74 24                	je     c0103c34 <basic_check+0x4bb>
c0103c10:	c7 44 24 0c a6 a6 10 	movl   $0xc010a6a6,0xc(%esp)
c0103c17:	c0 
c0103c18:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103c1f:	c0 
c0103c20:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0103c27:	00 
c0103c28:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103c2f:	e8 a9 d0 ff ff       	call   c0100cdd <__panic>

    assert(nr_free == 0);
c0103c34:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103c39:	85 c0                	test   %eax,%eax
c0103c3b:	74 24                	je     c0103c61 <basic_check+0x4e8>
c0103c3d:	c7 44 24 0c f9 a6 10 	movl   $0xc010a6f9,0xc(%esp)
c0103c44:	c0 
c0103c45:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103c4c:	c0 
c0103c4d:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103c54:	00 
c0103c55:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103c5c:	e8 7c d0 ff ff       	call   c0100cdd <__panic>
    free_list = free_list_store;
c0103c61:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103c64:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103c67:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0103c6c:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    nr_free = nr_free_store;
c0103c72:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c75:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_page(p);
c0103c7a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c81:	00 
c0103c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c85:	89 04 24             	mov    %eax,(%esp)
c0103c88:	e8 40 11 00 00       	call   c0104dcd <free_pages>
    free_page(p1);
c0103c8d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c94:	00 
c0103c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c98:	89 04 24             	mov    %eax,(%esp)
c0103c9b:	e8 2d 11 00 00       	call   c0104dcd <free_pages>
    free_page(p2);
c0103ca0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ca7:	00 
c0103ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cab:	89 04 24             	mov    %eax,(%esp)
c0103cae:	e8 1a 11 00 00       	call   c0104dcd <free_pages>
}
c0103cb3:	c9                   	leave  
c0103cb4:	c3                   	ret    

c0103cb5 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103cb5:	55                   	push   %ebp
c0103cb6:	89 e5                	mov    %esp,%ebp
c0103cb8:	53                   	push   %ebx
c0103cb9:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103cc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103ccd:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103cd4:	eb 6b                	jmp    c0103d41 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cd9:	83 e8 0c             	sub    $0xc,%eax
c0103cdc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ce2:	83 c0 04             	add    $0x4,%eax
c0103ce5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103cec:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103cef:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103cf2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103cf5:	0f a3 10             	bt     %edx,(%eax)
c0103cf8:	19 c0                	sbb    %eax,%eax
c0103cfa:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103cfd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103d01:	0f 95 c0             	setne  %al
c0103d04:	0f b6 c0             	movzbl %al,%eax
c0103d07:	85 c0                	test   %eax,%eax
c0103d09:	75 24                	jne    c0103d2f <default_check+0x7a>
c0103d0b:	c7 44 24 0c 06 a7 10 	movl   $0xc010a706,0xc(%esp)
c0103d12:	c0 
c0103d13:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103d1a:	c0 
c0103d1b:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103d22:	00 
c0103d23:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103d2a:	e8 ae cf ff ff       	call   c0100cdd <__panic>
        count ++, total += p->property;
c0103d2f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103d33:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d36:	8b 50 08             	mov    0x8(%eax),%edx
c0103d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d3c:	01 d0                	add    %edx,%eax
c0103d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d44:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103d47:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103d4a:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103d4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d50:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c0103d57:	0f 85 79 ff ff ff    	jne    c0103cd6 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103d5d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103d60:	e8 9a 10 00 00       	call   c0104dff <nr_free_pages>
c0103d65:	39 c3                	cmp    %eax,%ebx
c0103d67:	74 24                	je     c0103d8d <default_check+0xd8>
c0103d69:	c7 44 24 0c 16 a7 10 	movl   $0xc010a716,0xc(%esp)
c0103d70:	c0 
c0103d71:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103d78:	c0 
c0103d79:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0103d80:	00 
c0103d81:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103d88:	e8 50 cf ff ff       	call   c0100cdd <__panic>

    basic_check();
c0103d8d:	e8 e7 f9 ff ff       	call   c0103779 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103d92:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103d99:	e8 c4 0f 00 00       	call   c0104d62 <alloc_pages>
c0103d9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103da1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103da5:	75 24                	jne    c0103dcb <default_check+0x116>
c0103da7:	c7 44 24 0c 2f a7 10 	movl   $0xc010a72f,0xc(%esp)
c0103dae:	c0 
c0103daf:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103db6:	c0 
c0103db7:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103dbe:	00 
c0103dbf:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103dc6:	e8 12 cf ff ff       	call   c0100cdd <__panic>
    assert(!PageProperty(p0));
c0103dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dce:	83 c0 04             	add    $0x4,%eax
c0103dd1:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103dd8:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ddb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103dde:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103de1:	0f a3 10             	bt     %edx,(%eax)
c0103de4:	19 c0                	sbb    %eax,%eax
c0103de6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103de9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103ded:	0f 95 c0             	setne  %al
c0103df0:	0f b6 c0             	movzbl %al,%eax
c0103df3:	85 c0                	test   %eax,%eax
c0103df5:	74 24                	je     c0103e1b <default_check+0x166>
c0103df7:	c7 44 24 0c 3a a7 10 	movl   $0xc010a73a,0xc(%esp)
c0103dfe:	c0 
c0103dff:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103e06:	c0 
c0103e07:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0103e0e:	00 
c0103e0f:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103e16:	e8 c2 ce ff ff       	call   c0100cdd <__panic>

    list_entry_t free_list_store = free_list;
c0103e1b:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0103e20:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103e26:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103e29:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103e2c:	c7 45 b4 18 7b 12 c0 	movl   $0xc0127b18,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103e33:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e36:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e39:	89 50 04             	mov    %edx,0x4(%eax)
c0103e3c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e3f:	8b 50 04             	mov    0x4(%eax),%edx
c0103e42:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e45:	89 10                	mov    %edx,(%eax)
c0103e47:	c7 45 b0 18 7b 12 c0 	movl   $0xc0127b18,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103e4e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e51:	8b 40 04             	mov    0x4(%eax),%eax
c0103e54:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103e57:	0f 94 c0             	sete   %al
c0103e5a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103e5d:	85 c0                	test   %eax,%eax
c0103e5f:	75 24                	jne    c0103e85 <default_check+0x1d0>
c0103e61:	c7 44 24 0c 8f a6 10 	movl   $0xc010a68f,0xc(%esp)
c0103e68:	c0 
c0103e69:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103e70:	c0 
c0103e71:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0103e78:	00 
c0103e79:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103e80:	e8 58 ce ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c0103e85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e8c:	e8 d1 0e 00 00       	call   c0104d62 <alloc_pages>
c0103e91:	85 c0                	test   %eax,%eax
c0103e93:	74 24                	je     c0103eb9 <default_check+0x204>
c0103e95:	c7 44 24 0c a6 a6 10 	movl   $0xc010a6a6,0xc(%esp)
c0103e9c:	c0 
c0103e9d:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103ea4:	c0 
c0103ea5:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0103eac:	00 
c0103ead:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103eb4:	e8 24 ce ff ff       	call   c0100cdd <__panic>

    unsigned int nr_free_store = nr_free;
c0103eb9:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103ebe:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103ec1:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103ec8:	00 00 00 

    free_pages(p0 + 2, 3);
c0103ecb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ece:	83 c0 40             	add    $0x40,%eax
c0103ed1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103ed8:	00 
c0103ed9:	89 04 24             	mov    %eax,(%esp)
c0103edc:	e8 ec 0e 00 00       	call   c0104dcd <free_pages>
    assert(alloc_pages(4) == NULL);
c0103ee1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103ee8:	e8 75 0e 00 00       	call   c0104d62 <alloc_pages>
c0103eed:	85 c0                	test   %eax,%eax
c0103eef:	74 24                	je     c0103f15 <default_check+0x260>
c0103ef1:	c7 44 24 0c 4c a7 10 	movl   $0xc010a74c,0xc(%esp)
c0103ef8:	c0 
c0103ef9:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103f00:	c0 
c0103f01:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0103f08:	00 
c0103f09:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103f10:	e8 c8 cd ff ff       	call   c0100cdd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103f15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f18:	83 c0 40             	add    $0x40,%eax
c0103f1b:	83 c0 04             	add    $0x4,%eax
c0103f1e:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103f25:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103f28:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f2b:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103f2e:	0f a3 10             	bt     %edx,(%eax)
c0103f31:	19 c0                	sbb    %eax,%eax
c0103f33:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103f36:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103f3a:	0f 95 c0             	setne  %al
c0103f3d:	0f b6 c0             	movzbl %al,%eax
c0103f40:	85 c0                	test   %eax,%eax
c0103f42:	74 0e                	je     c0103f52 <default_check+0x29d>
c0103f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f47:	83 c0 40             	add    $0x40,%eax
c0103f4a:	8b 40 08             	mov    0x8(%eax),%eax
c0103f4d:	83 f8 03             	cmp    $0x3,%eax
c0103f50:	74 24                	je     c0103f76 <default_check+0x2c1>
c0103f52:	c7 44 24 0c 64 a7 10 	movl   $0xc010a764,0xc(%esp)
c0103f59:	c0 
c0103f5a:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103f61:	c0 
c0103f62:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0103f69:	00 
c0103f6a:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103f71:	e8 67 cd ff ff       	call   c0100cdd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103f76:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103f7d:	e8 e0 0d 00 00       	call   c0104d62 <alloc_pages>
c0103f82:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103f85:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103f89:	75 24                	jne    c0103faf <default_check+0x2fa>
c0103f8b:	c7 44 24 0c 90 a7 10 	movl   $0xc010a790,0xc(%esp)
c0103f92:	c0 
c0103f93:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103f9a:	c0 
c0103f9b:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0103fa2:	00 
c0103fa3:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103faa:	e8 2e cd ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c0103faf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fb6:	e8 a7 0d 00 00       	call   c0104d62 <alloc_pages>
c0103fbb:	85 c0                	test   %eax,%eax
c0103fbd:	74 24                	je     c0103fe3 <default_check+0x32e>
c0103fbf:	c7 44 24 0c a6 a6 10 	movl   $0xc010a6a6,0xc(%esp)
c0103fc6:	c0 
c0103fc7:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103fce:	c0 
c0103fcf:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0103fd6:	00 
c0103fd7:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103fde:	e8 fa cc ff ff       	call   c0100cdd <__panic>
    assert(p0 + 2 == p1);
c0103fe3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fe6:	83 c0 40             	add    $0x40,%eax
c0103fe9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103fec:	74 24                	je     c0104012 <default_check+0x35d>
c0103fee:	c7 44 24 0c ae a7 10 	movl   $0xc010a7ae,0xc(%esp)
c0103ff5:	c0 
c0103ff6:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103ffd:	c0 
c0103ffe:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0104005:	00 
c0104006:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c010400d:	e8 cb cc ff ff       	call   c0100cdd <__panic>

    p2 = p0 + 1;
c0104012:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104015:	83 c0 20             	add    $0x20,%eax
c0104018:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010401b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104022:	00 
c0104023:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104026:	89 04 24             	mov    %eax,(%esp)
c0104029:	e8 9f 0d 00 00       	call   c0104dcd <free_pages>
    free_pages(p1, 3);
c010402e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104035:	00 
c0104036:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104039:	89 04 24             	mov    %eax,(%esp)
c010403c:	e8 8c 0d 00 00       	call   c0104dcd <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104044:	83 c0 04             	add    $0x4,%eax
c0104047:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010404e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104051:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104054:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104057:	0f a3 10             	bt     %edx,(%eax)
c010405a:	19 c0                	sbb    %eax,%eax
c010405c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010405f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104063:	0f 95 c0             	setne  %al
c0104066:	0f b6 c0             	movzbl %al,%eax
c0104069:	85 c0                	test   %eax,%eax
c010406b:	74 0b                	je     c0104078 <default_check+0x3c3>
c010406d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104070:	8b 40 08             	mov    0x8(%eax),%eax
c0104073:	83 f8 01             	cmp    $0x1,%eax
c0104076:	74 24                	je     c010409c <default_check+0x3e7>
c0104078:	c7 44 24 0c bc a7 10 	movl   $0xc010a7bc,0xc(%esp)
c010407f:	c0 
c0104080:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0104087:	c0 
c0104088:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c010408f:	00 
c0104090:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0104097:	e8 41 cc ff ff       	call   c0100cdd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010409c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010409f:	83 c0 04             	add    $0x4,%eax
c01040a2:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01040a9:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01040ac:	8b 45 90             	mov    -0x70(%ebp),%eax
c01040af:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01040b2:	0f a3 10             	bt     %edx,(%eax)
c01040b5:	19 c0                	sbb    %eax,%eax
c01040b7:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01040ba:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01040be:	0f 95 c0             	setne  %al
c01040c1:	0f b6 c0             	movzbl %al,%eax
c01040c4:	85 c0                	test   %eax,%eax
c01040c6:	74 0b                	je     c01040d3 <default_check+0x41e>
c01040c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040cb:	8b 40 08             	mov    0x8(%eax),%eax
c01040ce:	83 f8 03             	cmp    $0x3,%eax
c01040d1:	74 24                	je     c01040f7 <default_check+0x442>
c01040d3:	c7 44 24 0c e4 a7 10 	movl   $0xc010a7e4,0xc(%esp)
c01040da:	c0 
c01040db:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01040e2:	c0 
c01040e3:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01040ea:	00 
c01040eb:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01040f2:	e8 e6 cb ff ff       	call   c0100cdd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01040f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040fe:	e8 5f 0c 00 00       	call   c0104d62 <alloc_pages>
c0104103:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104106:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104109:	83 e8 20             	sub    $0x20,%eax
c010410c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010410f:	74 24                	je     c0104135 <default_check+0x480>
c0104111:	c7 44 24 0c 0a a8 10 	movl   $0xc010a80a,0xc(%esp)
c0104118:	c0 
c0104119:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0104120:	c0 
c0104121:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0104128:	00 
c0104129:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0104130:	e8 a8 cb ff ff       	call   c0100cdd <__panic>
    free_page(p0);
c0104135:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010413c:	00 
c010413d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104140:	89 04 24             	mov    %eax,(%esp)
c0104143:	e8 85 0c 00 00       	call   c0104dcd <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104148:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010414f:	e8 0e 0c 00 00       	call   c0104d62 <alloc_pages>
c0104154:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104157:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010415a:	83 c0 20             	add    $0x20,%eax
c010415d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104160:	74 24                	je     c0104186 <default_check+0x4d1>
c0104162:	c7 44 24 0c 28 a8 10 	movl   $0xc010a828,0xc(%esp)
c0104169:	c0 
c010416a:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0104171:	c0 
c0104172:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0104179:	00 
c010417a:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0104181:	e8 57 cb ff ff       	call   c0100cdd <__panic>

    free_pages(p0, 2);
c0104186:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010418d:	00 
c010418e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104191:	89 04 24             	mov    %eax,(%esp)
c0104194:	e8 34 0c 00 00       	call   c0104dcd <free_pages>
    free_page(p2);
c0104199:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01041a0:	00 
c01041a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041a4:	89 04 24             	mov    %eax,(%esp)
c01041a7:	e8 21 0c 00 00       	call   c0104dcd <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01041ac:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01041b3:	e8 aa 0b 00 00       	call   c0104d62 <alloc_pages>
c01041b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01041bf:	75 24                	jne    c01041e5 <default_check+0x530>
c01041c1:	c7 44 24 0c 48 a8 10 	movl   $0xc010a848,0xc(%esp)
c01041c8:	c0 
c01041c9:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01041d0:	c0 
c01041d1:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01041d8:	00 
c01041d9:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01041e0:	e8 f8 ca ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c01041e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041ec:	e8 71 0b 00 00       	call   c0104d62 <alloc_pages>
c01041f1:	85 c0                	test   %eax,%eax
c01041f3:	74 24                	je     c0104219 <default_check+0x564>
c01041f5:	c7 44 24 0c a6 a6 10 	movl   $0xc010a6a6,0xc(%esp)
c01041fc:	c0 
c01041fd:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0104204:	c0 
c0104205:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010420c:	00 
c010420d:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0104214:	e8 c4 ca ff ff       	call   c0100cdd <__panic>

    assert(nr_free == 0);
c0104219:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c010421e:	85 c0                	test   %eax,%eax
c0104220:	74 24                	je     c0104246 <default_check+0x591>
c0104222:	c7 44 24 0c f9 a6 10 	movl   $0xc010a6f9,0xc(%esp)
c0104229:	c0 
c010422a:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0104231:	c0 
c0104232:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c0104239:	00 
c010423a:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0104241:	e8 97 ca ff ff       	call   c0100cdd <__panic>
    nr_free = nr_free_store;
c0104246:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104249:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_list = free_list_store;
c010424e:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104251:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104254:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0104259:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    free_pages(p0, 5);
c010425f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104266:	00 
c0104267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010426a:	89 04 24             	mov    %eax,(%esp)
c010426d:	e8 5b 0b 00 00       	call   c0104dcd <free_pages>

    le = &free_list;
c0104272:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104279:	eb 1d                	jmp    c0104298 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010427b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010427e:	83 e8 0c             	sub    $0xc,%eax
c0104281:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104284:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104288:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010428b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010428e:	8b 40 08             	mov    0x8(%eax),%eax
c0104291:	29 c2                	sub    %eax,%edx
c0104293:	89 d0                	mov    %edx,%eax
c0104295:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104298:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010429b:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010429e:	8b 45 88             	mov    -0x78(%ebp),%eax
c01042a1:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01042a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01042a7:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c01042ae:	75 cb                	jne    c010427b <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01042b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042b4:	74 24                	je     c01042da <default_check+0x625>
c01042b6:	c7 44 24 0c 66 a8 10 	movl   $0xc010a866,0xc(%esp)
c01042bd:	c0 
c01042be:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01042c5:	c0 
c01042c6:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c01042cd:	00 
c01042ce:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01042d5:	e8 03 ca ff ff       	call   c0100cdd <__panic>
    assert(total == 0);
c01042da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01042de:	74 24                	je     c0104304 <default_check+0x64f>
c01042e0:	c7 44 24 0c 71 a8 10 	movl   $0xc010a871,0xc(%esp)
c01042e7:	c0 
c01042e8:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01042ef:	c0 
c01042f0:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c01042f7:	00 
c01042f8:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01042ff:	e8 d9 c9 ff ff       	call   c0100cdd <__panic>
}
c0104304:	81 c4 94 00 00 00    	add    $0x94,%esp
c010430a:	5b                   	pop    %ebx
c010430b:	5d                   	pop    %ebp
c010430c:	c3                   	ret    

c010430d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010430d:	55                   	push   %ebp
c010430e:	89 e5                	mov    %esp,%ebp
c0104310:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104313:	9c                   	pushf  
c0104314:	58                   	pop    %eax
c0104315:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104318:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010431b:	25 00 02 00 00       	and    $0x200,%eax
c0104320:	85 c0                	test   %eax,%eax
c0104322:	74 0c                	je     c0104330 <__intr_save+0x23>
        intr_disable();
c0104324:	e8 0c dc ff ff       	call   c0101f35 <intr_disable>
        return 1;
c0104329:	b8 01 00 00 00       	mov    $0x1,%eax
c010432e:	eb 05                	jmp    c0104335 <__intr_save+0x28>
    }
    return 0;
c0104330:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104335:	c9                   	leave  
c0104336:	c3                   	ret    

c0104337 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104337:	55                   	push   %ebp
c0104338:	89 e5                	mov    %esp,%ebp
c010433a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010433d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104341:	74 05                	je     c0104348 <__intr_restore+0x11>
        intr_enable();
c0104343:	e8 e7 db ff ff       	call   c0101f2f <intr_enable>
    }
}
c0104348:	c9                   	leave  
c0104349:	c3                   	ret    

c010434a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010434a:	55                   	push   %ebp
c010434b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010434d:	8b 55 08             	mov    0x8(%ebp),%edx
c0104350:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104355:	29 c2                	sub    %eax,%edx
c0104357:	89 d0                	mov    %edx,%eax
c0104359:	c1 f8 05             	sar    $0x5,%eax
}
c010435c:	5d                   	pop    %ebp
c010435d:	c3                   	ret    

c010435e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010435e:	55                   	push   %ebp
c010435f:	89 e5                	mov    %esp,%ebp
c0104361:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104364:	8b 45 08             	mov    0x8(%ebp),%eax
c0104367:	89 04 24             	mov    %eax,(%esp)
c010436a:	e8 db ff ff ff       	call   c010434a <page2ppn>
c010436f:	c1 e0 0c             	shl    $0xc,%eax
}
c0104372:	c9                   	leave  
c0104373:	c3                   	ret    

c0104374 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104374:	55                   	push   %ebp
c0104375:	89 e5                	mov    %esp,%ebp
c0104377:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010437a:	8b 45 08             	mov    0x8(%ebp),%eax
c010437d:	c1 e8 0c             	shr    $0xc,%eax
c0104380:	89 c2                	mov    %eax,%edx
c0104382:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104387:	39 c2                	cmp    %eax,%edx
c0104389:	72 1c                	jb     c01043a7 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010438b:	c7 44 24 08 ac a8 10 	movl   $0xc010a8ac,0x8(%esp)
c0104392:	c0 
c0104393:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c010439a:	00 
c010439b:	c7 04 24 cb a8 10 c0 	movl   $0xc010a8cb,(%esp)
c01043a2:	e8 36 c9 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c01043a7:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01043ac:	8b 55 08             	mov    0x8(%ebp),%edx
c01043af:	c1 ea 0c             	shr    $0xc,%edx
c01043b2:	c1 e2 05             	shl    $0x5,%edx
c01043b5:	01 d0                	add    %edx,%eax
}
c01043b7:	c9                   	leave  
c01043b8:	c3                   	ret    

c01043b9 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01043b9:	55                   	push   %ebp
c01043ba:	89 e5                	mov    %esp,%ebp
c01043bc:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01043bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01043c2:	89 04 24             	mov    %eax,(%esp)
c01043c5:	e8 94 ff ff ff       	call   c010435e <page2pa>
c01043ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043d0:	c1 e8 0c             	shr    $0xc,%eax
c01043d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043d6:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01043db:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01043de:	72 23                	jb     c0104403 <page2kva+0x4a>
c01043e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043e7:	c7 44 24 08 dc a8 10 	movl   $0xc010a8dc,0x8(%esp)
c01043ee:	c0 
c01043ef:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c01043f6:	00 
c01043f7:	c7 04 24 cb a8 10 c0 	movl   $0xc010a8cb,(%esp)
c01043fe:	e8 da c8 ff ff       	call   c0100cdd <__panic>
c0104403:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104406:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010440b:	c9                   	leave  
c010440c:	c3                   	ret    

c010440d <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010440d:	55                   	push   %ebp
c010440e:	89 e5                	mov    %esp,%ebp
c0104410:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104413:	8b 45 08             	mov    0x8(%ebp),%eax
c0104416:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104419:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104420:	77 23                	ja     c0104445 <kva2page+0x38>
c0104422:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104425:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104429:	c7 44 24 08 00 a9 10 	movl   $0xc010a900,0x8(%esp)
c0104430:	c0 
c0104431:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0104438:	00 
c0104439:	c7 04 24 cb a8 10 c0 	movl   $0xc010a8cb,(%esp)
c0104440:	e8 98 c8 ff ff       	call   c0100cdd <__panic>
c0104445:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104448:	05 00 00 00 40       	add    $0x40000000,%eax
c010444d:	89 04 24             	mov    %eax,(%esp)
c0104450:	e8 1f ff ff ff       	call   c0104374 <pa2page>
}
c0104455:	c9                   	leave  
c0104456:	c3                   	ret    

c0104457 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c0104457:	55                   	push   %ebp
c0104458:	89 e5                	mov    %esp,%ebp
c010445a:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c010445d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104460:	ba 01 00 00 00       	mov    $0x1,%edx
c0104465:	89 c1                	mov    %eax,%ecx
c0104467:	d3 e2                	shl    %cl,%edx
c0104469:	89 d0                	mov    %edx,%eax
c010446b:	89 04 24             	mov    %eax,(%esp)
c010446e:	e8 ef 08 00 00       	call   c0104d62 <alloc_pages>
c0104473:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104476:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010447a:	75 07                	jne    c0104483 <__slob_get_free_pages+0x2c>
    return NULL;
c010447c:	b8 00 00 00 00       	mov    $0x0,%eax
c0104481:	eb 0b                	jmp    c010448e <__slob_get_free_pages+0x37>
  return page2kva(page);
c0104483:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104486:	89 04 24             	mov    %eax,(%esp)
c0104489:	e8 2b ff ff ff       	call   c01043b9 <page2kva>
}
c010448e:	c9                   	leave  
c010448f:	c3                   	ret    

c0104490 <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c0104490:	55                   	push   %ebp
c0104491:	89 e5                	mov    %esp,%ebp
c0104493:	53                   	push   %ebx
c0104494:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c0104497:	8b 45 0c             	mov    0xc(%ebp),%eax
c010449a:	ba 01 00 00 00       	mov    $0x1,%edx
c010449f:	89 c1                	mov    %eax,%ecx
c01044a1:	d3 e2                	shl    %cl,%edx
c01044a3:	89 d0                	mov    %edx,%eax
c01044a5:	89 c3                	mov    %eax,%ebx
c01044a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01044aa:	89 04 24             	mov    %eax,(%esp)
c01044ad:	e8 5b ff ff ff       	call   c010440d <kva2page>
c01044b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01044b6:	89 04 24             	mov    %eax,(%esp)
c01044b9:	e8 0f 09 00 00       	call   c0104dcd <free_pages>
}
c01044be:	83 c4 14             	add    $0x14,%esp
c01044c1:	5b                   	pop    %ebx
c01044c2:	5d                   	pop    %ebp
c01044c3:	c3                   	ret    

c01044c4 <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c01044c4:	55                   	push   %ebp
c01044c5:	89 e5                	mov    %esp,%ebp
c01044c7:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c01044ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01044cd:	83 c0 08             	add    $0x8,%eax
c01044d0:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c01044d5:	76 24                	jbe    c01044fb <slob_alloc+0x37>
c01044d7:	c7 44 24 0c 24 a9 10 	movl   $0xc010a924,0xc(%esp)
c01044de:	c0 
c01044df:	c7 44 24 08 43 a9 10 	movl   $0xc010a943,0x8(%esp)
c01044e6:	c0 
c01044e7:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01044ee:	00 
c01044ef:	c7 04 24 58 a9 10 c0 	movl   $0xc010a958,(%esp)
c01044f6:	e8 e2 c7 ff ff       	call   c0100cdd <__panic>

	slob_t *prev, *cur, *aligned = 0;
c01044fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c0104502:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104509:	8b 45 08             	mov    0x8(%ebp),%eax
c010450c:	83 c0 07             	add    $0x7,%eax
c010450f:	c1 e8 03             	shr    $0x3,%eax
c0104512:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c0104515:	e8 f3 fd ff ff       	call   c010430d <__intr_save>
c010451a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c010451d:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c0104522:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104525:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104528:	8b 40 04             	mov    0x4(%eax),%eax
c010452b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c010452e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104532:	74 25                	je     c0104559 <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c0104534:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104537:	8b 45 10             	mov    0x10(%ebp),%eax
c010453a:	01 d0                	add    %edx,%eax
c010453c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010453f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104542:	f7 d8                	neg    %eax
c0104544:	21 d0                	and    %edx,%eax
c0104546:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c0104549:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010454c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010454f:	29 c2                	sub    %eax,%edx
c0104551:	89 d0                	mov    %edx,%eax
c0104553:	c1 f8 03             	sar    $0x3,%eax
c0104556:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c0104559:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010455c:	8b 00                	mov    (%eax),%eax
c010455e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104561:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104564:	01 ca                	add    %ecx,%edx
c0104566:	39 d0                	cmp    %edx,%eax
c0104568:	0f 8c aa 00 00 00    	jl     c0104618 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c010456e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104572:	74 38                	je     c01045ac <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c0104574:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104577:	8b 00                	mov    (%eax),%eax
c0104579:	2b 45 e8             	sub    -0x18(%ebp),%eax
c010457c:	89 c2                	mov    %eax,%edx
c010457e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104581:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104583:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104586:	8b 50 04             	mov    0x4(%eax),%edx
c0104589:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010458c:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c010458f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104592:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104595:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104598:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010459b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010459e:	89 10                	mov    %edx,(%eax)
				prev = cur;
c01045a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c01045a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c01045ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045af:	8b 00                	mov    (%eax),%eax
c01045b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01045b4:	75 0e                	jne    c01045c4 <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c01045b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045b9:	8b 50 04             	mov    0x4(%eax),%edx
c01045bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045bf:	89 50 04             	mov    %edx,0x4(%eax)
c01045c2:	eb 3c                	jmp    c0104600 <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c01045c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045c7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01045ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045d1:	01 c2                	add    %eax,%edx
c01045d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045d6:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c01045d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045dc:	8b 40 04             	mov    0x4(%eax),%eax
c01045df:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01045e2:	8b 12                	mov    (%edx),%edx
c01045e4:	2b 55 e0             	sub    -0x20(%ebp),%edx
c01045e7:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c01045e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ec:	8b 40 04             	mov    0x4(%eax),%eax
c01045ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01045f2:	8b 52 04             	mov    0x4(%edx),%edx
c01045f5:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c01045f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01045fe:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c0104600:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104603:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08
			spin_unlock_irqrestore(&slob_lock, flags);
c0104608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010460b:	89 04 24             	mov    %eax,(%esp)
c010460e:	e8 24 fd ff ff       	call   c0104337 <__intr_restore>
			return cur;
c0104613:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104616:	eb 7f                	jmp    c0104697 <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c0104618:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c010461d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104620:	75 61                	jne    c0104683 <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c0104622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104625:	89 04 24             	mov    %eax,(%esp)
c0104628:	e8 0a fd ff ff       	call   c0104337 <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c010462d:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104634:	75 07                	jne    c010463d <slob_alloc+0x179>
				return 0;
c0104636:	b8 00 00 00 00       	mov    $0x0,%eax
c010463b:	eb 5a                	jmp    c0104697 <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c010463d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104644:	00 
c0104645:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104648:	89 04 24             	mov    %eax,(%esp)
c010464b:	e8 07 fe ff ff       	call   c0104457 <__slob_get_free_pages>
c0104650:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104653:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104657:	75 07                	jne    c0104660 <slob_alloc+0x19c>
				return 0;
c0104659:	b8 00 00 00 00       	mov    $0x0,%eax
c010465e:	eb 37                	jmp    c0104697 <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c0104660:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104667:	00 
c0104668:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010466b:	89 04 24             	mov    %eax,(%esp)
c010466e:	e8 26 00 00 00       	call   c0104699 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c0104673:	e8 95 fc ff ff       	call   c010430d <__intr_save>
c0104678:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c010467b:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c0104680:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104683:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104686:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104689:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010468c:	8b 40 04             	mov    0x4(%eax),%eax
c010468f:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c0104692:	e9 97 fe ff ff       	jmp    c010452e <slob_alloc+0x6a>
}
c0104697:	c9                   	leave  
c0104698:	c3                   	ret    

c0104699 <slob_free>:

static void slob_free(void *block, int size)
{
c0104699:	55                   	push   %ebp
c010469a:	89 e5                	mov    %esp,%ebp
c010469c:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c010469f:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01046a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01046a9:	75 05                	jne    c01046b0 <slob_free+0x17>
		return;
c01046ab:	e9 ff 00 00 00       	jmp    c01047af <slob_free+0x116>

	if (size)
c01046b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01046b4:	74 10                	je     c01046c6 <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c01046b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046b9:	83 c0 07             	add    $0x7,%eax
c01046bc:	c1 e8 03             	shr    $0x3,%eax
c01046bf:	89 c2                	mov    %eax,%edx
c01046c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046c4:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c01046c6:	e8 42 fc ff ff       	call   c010430d <__intr_save>
c01046cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c01046ce:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c01046d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046d6:	eb 27                	jmp    c01046ff <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c01046d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046db:	8b 40 04             	mov    0x4(%eax),%eax
c01046de:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01046e1:	77 13                	ja     c01046f6 <slob_free+0x5d>
c01046e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01046e9:	77 27                	ja     c0104712 <slob_free+0x79>
c01046eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ee:	8b 40 04             	mov    0x4(%eax),%eax
c01046f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01046f4:	77 1c                	ja     c0104712 <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c01046f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046f9:	8b 40 04             	mov    0x4(%eax),%eax
c01046fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104702:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104705:	76 d1                	jbe    c01046d8 <slob_free+0x3f>
c0104707:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010470a:	8b 40 04             	mov    0x4(%eax),%eax
c010470d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104710:	76 c6                	jbe    c01046d8 <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c0104712:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104715:	8b 00                	mov    (%eax),%eax
c0104717:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010471e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104721:	01 c2                	add    %eax,%edx
c0104723:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104726:	8b 40 04             	mov    0x4(%eax),%eax
c0104729:	39 c2                	cmp    %eax,%edx
c010472b:	75 25                	jne    c0104752 <slob_free+0xb9>
		b->units += cur->next->units;
c010472d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104730:	8b 10                	mov    (%eax),%edx
c0104732:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104735:	8b 40 04             	mov    0x4(%eax),%eax
c0104738:	8b 00                	mov    (%eax),%eax
c010473a:	01 c2                	add    %eax,%edx
c010473c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010473f:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104741:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104744:	8b 40 04             	mov    0x4(%eax),%eax
c0104747:	8b 50 04             	mov    0x4(%eax),%edx
c010474a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010474d:	89 50 04             	mov    %edx,0x4(%eax)
c0104750:	eb 0c                	jmp    c010475e <slob_free+0xc5>
	} else
		b->next = cur->next;
c0104752:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104755:	8b 50 04             	mov    0x4(%eax),%edx
c0104758:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010475b:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c010475e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104761:	8b 00                	mov    (%eax),%eax
c0104763:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010476a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010476d:	01 d0                	add    %edx,%eax
c010476f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104772:	75 1f                	jne    c0104793 <slob_free+0xfa>
		cur->units += b->units;
c0104774:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104777:	8b 10                	mov    (%eax),%edx
c0104779:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010477c:	8b 00                	mov    (%eax),%eax
c010477e:	01 c2                	add    %eax,%edx
c0104780:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104783:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104785:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104788:	8b 50 04             	mov    0x4(%eax),%edx
c010478b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010478e:	89 50 04             	mov    %edx,0x4(%eax)
c0104791:	eb 09                	jmp    c010479c <slob_free+0x103>
	} else
		cur->next = b;
c0104793:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104796:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104799:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c010479c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010479f:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08

	spin_unlock_irqrestore(&slob_lock, flags);
c01047a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047a7:	89 04 24             	mov    %eax,(%esp)
c01047aa:	e8 88 fb ff ff       	call   c0104337 <__intr_restore>
}
c01047af:	c9                   	leave  
c01047b0:	c3                   	ret    

c01047b1 <slob_init>:



void
slob_init(void) {
c01047b1:	55                   	push   %ebp
c01047b2:	89 e5                	mov    %esp,%ebp
c01047b4:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c01047b7:	c7 04 24 6a a9 10 c0 	movl   $0xc010a96a,(%esp)
c01047be:	e8 90 bb ff ff       	call   c0100353 <cprintf>
}
c01047c3:	c9                   	leave  
c01047c4:	c3                   	ret    

c01047c5 <kmalloc_init>:

inline void 
kmalloc_init(void) {
c01047c5:	55                   	push   %ebp
c01047c6:	89 e5                	mov    %esp,%ebp
c01047c8:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c01047cb:	e8 e1 ff ff ff       	call   c01047b1 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c01047d0:	c7 04 24 7e a9 10 c0 	movl   $0xc010a97e,(%esp)
c01047d7:	e8 77 bb ff ff       	call   c0100353 <cprintf>
}
c01047dc:	c9                   	leave  
c01047dd:	c3                   	ret    

c01047de <slob_allocated>:

size_t
slob_allocated(void) {
c01047de:	55                   	push   %ebp
c01047df:	89 e5                	mov    %esp,%ebp
  return 0;
c01047e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047e6:	5d                   	pop    %ebp
c01047e7:	c3                   	ret    

c01047e8 <kallocated>:

size_t
kallocated(void) {
c01047e8:	55                   	push   %ebp
c01047e9:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c01047eb:	e8 ee ff ff ff       	call   c01047de <slob_allocated>
}
c01047f0:	5d                   	pop    %ebp
c01047f1:	c3                   	ret    

c01047f2 <find_order>:

static int find_order(int size)
{
c01047f2:	55                   	push   %ebp
c01047f3:	89 e5                	mov    %esp,%ebp
c01047f5:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c01047f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c01047ff:	eb 07                	jmp    c0104808 <find_order+0x16>
		order++;
c0104801:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0104805:	d1 7d 08             	sarl   0x8(%ebp)
c0104808:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c010480f:	7f f0                	jg     c0104801 <find_order+0xf>
		order++;
	return order;
c0104811:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104814:	c9                   	leave  
c0104815:	c3                   	ret    

c0104816 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0104816:	55                   	push   %ebp
c0104817:	89 e5                	mov    %esp,%ebp
c0104819:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c010481c:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0104823:	77 38                	ja     c010485d <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0104825:	8b 45 08             	mov    0x8(%ebp),%eax
c0104828:	8d 50 08             	lea    0x8(%eax),%edx
c010482b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104832:	00 
c0104833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104836:	89 44 24 04          	mov    %eax,0x4(%esp)
c010483a:	89 14 24             	mov    %edx,(%esp)
c010483d:	e8 82 fc ff ff       	call   c01044c4 <slob_alloc>
c0104842:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c0104845:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104849:	74 08                	je     c0104853 <__kmalloc+0x3d>
c010484b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010484e:	83 c0 08             	add    $0x8,%eax
c0104851:	eb 05                	jmp    c0104858 <__kmalloc+0x42>
c0104853:	b8 00 00 00 00       	mov    $0x0,%eax
c0104858:	e9 a6 00 00 00       	jmp    c0104903 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c010485d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104864:	00 
c0104865:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104868:	89 44 24 04          	mov    %eax,0x4(%esp)
c010486c:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104873:	e8 4c fc ff ff       	call   c01044c4 <slob_alloc>
c0104878:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c010487b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010487f:	75 07                	jne    c0104888 <__kmalloc+0x72>
		return 0;
c0104881:	b8 00 00 00 00       	mov    $0x0,%eax
c0104886:	eb 7b                	jmp    c0104903 <__kmalloc+0xed>

	bb->order = find_order(size);
c0104888:	8b 45 08             	mov    0x8(%ebp),%eax
c010488b:	89 04 24             	mov    %eax,(%esp)
c010488e:	e8 5f ff ff ff       	call   c01047f2 <find_order>
c0104893:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104896:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104898:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010489b:	8b 00                	mov    (%eax),%eax
c010489d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048a4:	89 04 24             	mov    %eax,(%esp)
c01048a7:	e8 ab fb ff ff       	call   c0104457 <__slob_get_free_pages>
c01048ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01048af:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c01048b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048b5:	8b 40 04             	mov    0x4(%eax),%eax
c01048b8:	85 c0                	test   %eax,%eax
c01048ba:	74 2f                	je     c01048eb <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c01048bc:	e8 4c fa ff ff       	call   c010430d <__intr_save>
c01048c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c01048c4:	8b 15 24 5a 12 c0    	mov    0xc0125a24,%edx
c01048ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048cd:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c01048d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048d3:	a3 24 5a 12 c0       	mov    %eax,0xc0125a24
		spin_unlock_irqrestore(&block_lock, flags);
c01048d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048db:	89 04 24             	mov    %eax,(%esp)
c01048de:	e8 54 fa ff ff       	call   c0104337 <__intr_restore>
		return bb->pages;
c01048e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048e6:	8b 40 04             	mov    0x4(%eax),%eax
c01048e9:	eb 18                	jmp    c0104903 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c01048eb:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c01048f2:	00 
c01048f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048f6:	89 04 24             	mov    %eax,(%esp)
c01048f9:	e8 9b fd ff ff       	call   c0104699 <slob_free>
	return 0;
c01048fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104903:	c9                   	leave  
c0104904:	c3                   	ret    

c0104905 <kmalloc>:

void *
kmalloc(size_t size)
{
c0104905:	55                   	push   %ebp
c0104906:	89 e5                	mov    %esp,%ebp
c0104908:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c010490b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104912:	00 
c0104913:	8b 45 08             	mov    0x8(%ebp),%eax
c0104916:	89 04 24             	mov    %eax,(%esp)
c0104919:	e8 f8 fe ff ff       	call   c0104816 <__kmalloc>
}
c010491e:	c9                   	leave  
c010491f:	c3                   	ret    

c0104920 <kfree>:


void kfree(void *block)
{
c0104920:	55                   	push   %ebp
c0104921:	89 e5                	mov    %esp,%ebp
c0104923:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c0104926:	c7 45 f0 24 5a 12 c0 	movl   $0xc0125a24,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c010492d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104931:	75 05                	jne    c0104938 <kfree+0x18>
		return;
c0104933:	e9 a2 00 00 00       	jmp    c01049da <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104938:	8b 45 08             	mov    0x8(%ebp),%eax
c010493b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104940:	85 c0                	test   %eax,%eax
c0104942:	75 7f                	jne    c01049c3 <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0104944:	e8 c4 f9 ff ff       	call   c010430d <__intr_save>
c0104949:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c010494c:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c0104951:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104954:	eb 5c                	jmp    c01049b2 <kfree+0x92>
			if (bb->pages == block) {
c0104956:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104959:	8b 40 04             	mov    0x4(%eax),%eax
c010495c:	3b 45 08             	cmp    0x8(%ebp),%eax
c010495f:	75 3f                	jne    c01049a0 <kfree+0x80>
				*last = bb->next;
c0104961:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104964:	8b 50 08             	mov    0x8(%eax),%edx
c0104967:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010496a:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c010496c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010496f:	89 04 24             	mov    %eax,(%esp)
c0104972:	e8 c0 f9 ff ff       	call   c0104337 <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104977:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010497a:	8b 10                	mov    (%eax),%edx
c010497c:	8b 45 08             	mov    0x8(%ebp),%eax
c010497f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104983:	89 04 24             	mov    %eax,(%esp)
c0104986:	e8 05 fb ff ff       	call   c0104490 <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c010498b:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104992:	00 
c0104993:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104996:	89 04 24             	mov    %eax,(%esp)
c0104999:	e8 fb fc ff ff       	call   c0104699 <slob_free>
				return;
c010499e:	eb 3a                	jmp    c01049da <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c01049a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049a3:	83 c0 08             	add    $0x8,%eax
c01049a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01049a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049ac:	8b 40 08             	mov    0x8(%eax),%eax
c01049af:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01049b6:	75 9e                	jne    c0104956 <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c01049b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049bb:	89 04 24             	mov    %eax,(%esp)
c01049be:	e8 74 f9 ff ff       	call   c0104337 <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c01049c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01049c6:	83 e8 08             	sub    $0x8,%eax
c01049c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01049d0:	00 
c01049d1:	89 04 24             	mov    %eax,(%esp)
c01049d4:	e8 c0 fc ff ff       	call   c0104699 <slob_free>
	return;
c01049d9:	90                   	nop
}
c01049da:	c9                   	leave  
c01049db:	c3                   	ret    

c01049dc <ksize>:


unsigned int ksize(const void *block)
{
c01049dc:	55                   	push   %ebp
c01049dd:	89 e5                	mov    %esp,%ebp
c01049df:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c01049e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01049e6:	75 07                	jne    c01049ef <ksize+0x13>
		return 0;
c01049e8:	b8 00 00 00 00       	mov    $0x0,%eax
c01049ed:	eb 6b                	jmp    c0104a5a <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c01049ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01049f2:	25 ff 0f 00 00       	and    $0xfff,%eax
c01049f7:	85 c0                	test   %eax,%eax
c01049f9:	75 54                	jne    c0104a4f <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c01049fb:	e8 0d f9 ff ff       	call   c010430d <__intr_save>
c0104a00:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104a03:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c0104a08:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a0b:	eb 31                	jmp    c0104a3e <ksize+0x62>
			if (bb->pages == block) {
c0104a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a10:	8b 40 04             	mov    0x4(%eax),%eax
c0104a13:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104a16:	75 1d                	jne    c0104a35 <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a1b:	89 04 24             	mov    %eax,(%esp)
c0104a1e:	e8 14 f9 ff ff       	call   c0104337 <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a26:	8b 00                	mov    (%eax),%eax
c0104a28:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104a2d:	89 c1                	mov    %eax,%ecx
c0104a2f:	d3 e2                	shl    %cl,%edx
c0104a31:	89 d0                	mov    %edx,%eax
c0104a33:	eb 25                	jmp    c0104a5a <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a38:	8b 40 08             	mov    0x8(%eax),%eax
c0104a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a42:	75 c9                	jne    c0104a0d <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a47:	89 04 24             	mov    %eax,(%esp)
c0104a4a:	e8 e8 f8 ff ff       	call   c0104337 <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104a4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a52:	83 e8 08             	sub    $0x8,%eax
c0104a55:	8b 00                	mov    (%eax),%eax
c0104a57:	c1 e0 03             	shl    $0x3,%eax
}
c0104a5a:	c9                   	leave  
c0104a5b:	c3                   	ret    

c0104a5c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104a5c:	55                   	push   %ebp
c0104a5d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104a5f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104a62:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104a67:	29 c2                	sub    %eax,%edx
c0104a69:	89 d0                	mov    %edx,%eax
c0104a6b:	c1 f8 05             	sar    $0x5,%eax
}
c0104a6e:	5d                   	pop    %ebp
c0104a6f:	c3                   	ret    

c0104a70 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104a70:	55                   	push   %ebp
c0104a71:	89 e5                	mov    %esp,%ebp
c0104a73:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104a76:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a79:	89 04 24             	mov    %eax,(%esp)
c0104a7c:	e8 db ff ff ff       	call   c0104a5c <page2ppn>
c0104a81:	c1 e0 0c             	shl    $0xc,%eax
}
c0104a84:	c9                   	leave  
c0104a85:	c3                   	ret    

c0104a86 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104a86:	55                   	push   %ebp
c0104a87:	89 e5                	mov    %esp,%ebp
c0104a89:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104a8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a8f:	c1 e8 0c             	shr    $0xc,%eax
c0104a92:	89 c2                	mov    %eax,%edx
c0104a94:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104a99:	39 c2                	cmp    %eax,%edx
c0104a9b:	72 1c                	jb     c0104ab9 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104a9d:	c7 44 24 08 9c a9 10 	movl   $0xc010a99c,0x8(%esp)
c0104aa4:	c0 
c0104aa5:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104aac:	00 
c0104aad:	c7 04 24 bb a9 10 c0 	movl   $0xc010a9bb,(%esp)
c0104ab4:	e8 24 c2 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c0104ab9:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104abe:	8b 55 08             	mov    0x8(%ebp),%edx
c0104ac1:	c1 ea 0c             	shr    $0xc,%edx
c0104ac4:	c1 e2 05             	shl    $0x5,%edx
c0104ac7:	01 d0                	add    %edx,%eax
}
c0104ac9:	c9                   	leave  
c0104aca:	c3                   	ret    

c0104acb <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104acb:	55                   	push   %ebp
c0104acc:	89 e5                	mov    %esp,%ebp
c0104ace:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104ad1:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ad4:	89 04 24             	mov    %eax,(%esp)
c0104ad7:	e8 94 ff ff ff       	call   c0104a70 <page2pa>
c0104adc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ae2:	c1 e8 0c             	shr    $0xc,%eax
c0104ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ae8:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104aed:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104af0:	72 23                	jb     c0104b15 <page2kva+0x4a>
c0104af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104af5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104af9:	c7 44 24 08 cc a9 10 	movl   $0xc010a9cc,0x8(%esp)
c0104b00:	c0 
c0104b01:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104b08:	00 
c0104b09:	c7 04 24 bb a9 10 c0 	movl   $0xc010a9bb,(%esp)
c0104b10:	e8 c8 c1 ff ff       	call   c0100cdd <__panic>
c0104b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b18:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104b1d:	c9                   	leave  
c0104b1e:	c3                   	ret    

c0104b1f <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104b1f:	55                   	push   %ebp
c0104b20:	89 e5                	mov    %esp,%ebp
c0104b22:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b28:	83 e0 01             	and    $0x1,%eax
c0104b2b:	85 c0                	test   %eax,%eax
c0104b2d:	75 1c                	jne    c0104b4b <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104b2f:	c7 44 24 08 f0 a9 10 	movl   $0xc010a9f0,0x8(%esp)
c0104b36:	c0 
c0104b37:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0104b3e:	00 
c0104b3f:	c7 04 24 bb a9 10 c0 	movl   $0xc010a9bb,(%esp)
c0104b46:	e8 92 c1 ff ff       	call   c0100cdd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b53:	89 04 24             	mov    %eax,(%esp)
c0104b56:	e8 2b ff ff ff       	call   c0104a86 <pa2page>
}
c0104b5b:	c9                   	leave  
c0104b5c:	c3                   	ret    

c0104b5d <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104b5d:	55                   	push   %ebp
c0104b5e:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104b60:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b63:	8b 00                	mov    (%eax),%eax
}
c0104b65:	5d                   	pop    %ebp
c0104b66:	c3                   	ret    

c0104b67 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104b67:	55                   	push   %ebp
c0104b68:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104b70:	89 10                	mov    %edx,(%eax)
}
c0104b72:	5d                   	pop    %ebp
c0104b73:	c3                   	ret    

c0104b74 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104b74:	55                   	push   %ebp
c0104b75:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104b77:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b7a:	8b 00                	mov    (%eax),%eax
c0104b7c:	8d 50 01             	lea    0x1(%eax),%edx
c0104b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b82:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104b84:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b87:	8b 00                	mov    (%eax),%eax
}
c0104b89:	5d                   	pop    %ebp
c0104b8a:	c3                   	ret    

c0104b8b <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104b8b:	55                   	push   %ebp
c0104b8c:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104b8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b91:	8b 00                	mov    (%eax),%eax
c0104b93:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104b96:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b99:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104b9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b9e:	8b 00                	mov    (%eax),%eax
}
c0104ba0:	5d                   	pop    %ebp
c0104ba1:	c3                   	ret    

c0104ba2 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104ba2:	55                   	push   %ebp
c0104ba3:	89 e5                	mov    %esp,%ebp
c0104ba5:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104ba8:	9c                   	pushf  
c0104ba9:	58                   	pop    %eax
c0104baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104bb0:	25 00 02 00 00       	and    $0x200,%eax
c0104bb5:	85 c0                	test   %eax,%eax
c0104bb7:	74 0c                	je     c0104bc5 <__intr_save+0x23>
        intr_disable();
c0104bb9:	e8 77 d3 ff ff       	call   c0101f35 <intr_disable>
        return 1;
c0104bbe:	b8 01 00 00 00       	mov    $0x1,%eax
c0104bc3:	eb 05                	jmp    c0104bca <__intr_save+0x28>
    }
    return 0;
c0104bc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104bca:	c9                   	leave  
c0104bcb:	c3                   	ret    

c0104bcc <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104bcc:	55                   	push   %ebp
c0104bcd:	89 e5                	mov    %esp,%ebp
c0104bcf:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104bd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104bd6:	74 05                	je     c0104bdd <__intr_restore+0x11>
        intr_enable();
c0104bd8:	e8 52 d3 ff ff       	call   c0101f2f <intr_enable>
    }
}
c0104bdd:	c9                   	leave  
c0104bde:	c3                   	ret    

c0104bdf <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104bdf:	55                   	push   %ebp
c0104be0:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104be2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104be5:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104be8:	b8 23 00 00 00       	mov    $0x23,%eax
c0104bed:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104bef:	b8 23 00 00 00       	mov    $0x23,%eax
c0104bf4:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104bf6:	b8 10 00 00 00       	mov    $0x10,%eax
c0104bfb:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104bfd:	b8 10 00 00 00       	mov    $0x10,%eax
c0104c02:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104c04:	b8 10 00 00 00       	mov    $0x10,%eax
c0104c09:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104c0b:	ea 12 4c 10 c0 08 00 	ljmp   $0x8,$0xc0104c12
}
c0104c12:	5d                   	pop    %ebp
c0104c13:	c3                   	ret    

c0104c14 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104c14:	55                   	push   %ebp
c0104c15:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104c17:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c1a:	a3 64 5a 12 c0       	mov    %eax,0xc0125a64
}
c0104c1f:	5d                   	pop    %ebp
c0104c20:	c3                   	ret    

c0104c21 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104c21:	55                   	push   %ebp
c0104c22:	89 e5                	mov    %esp,%ebp
c0104c24:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104c27:	b8 00 40 12 c0       	mov    $0xc0124000,%eax
c0104c2c:	89 04 24             	mov    %eax,(%esp)
c0104c2f:	e8 e0 ff ff ff       	call   c0104c14 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104c34:	66 c7 05 68 5a 12 c0 	movw   $0x10,0xc0125a68
c0104c3b:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104c3d:	66 c7 05 48 4a 12 c0 	movw   $0x68,0xc0124a48
c0104c44:	68 00 
c0104c46:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104c4b:	66 a3 4a 4a 12 c0    	mov    %ax,0xc0124a4a
c0104c51:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104c56:	c1 e8 10             	shr    $0x10,%eax
c0104c59:	a2 4c 4a 12 c0       	mov    %al,0xc0124a4c
c0104c5e:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c65:	83 e0 f0             	and    $0xfffffff0,%eax
c0104c68:	83 c8 09             	or     $0x9,%eax
c0104c6b:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c70:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c77:	83 e0 ef             	and    $0xffffffef,%eax
c0104c7a:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c7f:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c86:	83 e0 9f             	and    $0xffffff9f,%eax
c0104c89:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c8e:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c95:	83 c8 80             	or     $0xffffff80,%eax
c0104c98:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c9d:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104ca4:	83 e0 f0             	and    $0xfffffff0,%eax
c0104ca7:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104cac:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104cb3:	83 e0 ef             	and    $0xffffffef,%eax
c0104cb6:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104cbb:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104cc2:	83 e0 df             	and    $0xffffffdf,%eax
c0104cc5:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104cca:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104cd1:	83 c8 40             	or     $0x40,%eax
c0104cd4:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104cd9:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104ce0:	83 e0 7f             	and    $0x7f,%eax
c0104ce3:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104ce8:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104ced:	c1 e8 18             	shr    $0x18,%eax
c0104cf0:	a2 4f 4a 12 c0       	mov    %al,0xc0124a4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104cf5:	c7 04 24 50 4a 12 c0 	movl   $0xc0124a50,(%esp)
c0104cfc:	e8 de fe ff ff       	call   c0104bdf <lgdt>
c0104d01:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104d07:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104d0b:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104d0e:	c9                   	leave  
c0104d0f:	c3                   	ret    

c0104d10 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104d10:	55                   	push   %ebp
c0104d11:	89 e5                	mov    %esp,%ebp
c0104d13:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104d16:	c7 05 24 7b 12 c0 90 	movl   $0xc010a890,0xc0127b24
c0104d1d:	a8 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104d20:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d25:	8b 00                	mov    (%eax),%eax
c0104d27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d2b:	c7 04 24 1c aa 10 c0 	movl   $0xc010aa1c,(%esp)
c0104d32:	e8 1c b6 ff ff       	call   c0100353 <cprintf>
    pmm_manager->init();
c0104d37:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d3c:	8b 40 04             	mov    0x4(%eax),%eax
c0104d3f:	ff d0                	call   *%eax
}
c0104d41:	c9                   	leave  
c0104d42:	c3                   	ret    

c0104d43 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104d43:	55                   	push   %ebp
c0104d44:	89 e5                	mov    %esp,%ebp
c0104d46:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104d49:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d4e:	8b 40 08             	mov    0x8(%eax),%eax
c0104d51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104d54:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d58:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d5b:	89 14 24             	mov    %edx,(%esp)
c0104d5e:	ff d0                	call   *%eax
}
c0104d60:	c9                   	leave  
c0104d61:	c3                   	ret    

c0104d62 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104d62:	55                   	push   %ebp
c0104d63:	89 e5                	mov    %esp,%ebp
c0104d65:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104d68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104d6f:	e8 2e fe ff ff       	call   c0104ba2 <__intr_save>
c0104d74:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104d77:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d7c:	8b 40 0c             	mov    0xc(%eax),%eax
c0104d7f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d82:	89 14 24             	mov    %edx,(%esp)
c0104d85:	ff d0                	call   *%eax
c0104d87:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d8d:	89 04 24             	mov    %eax,(%esp)
c0104d90:	e8 37 fe ff ff       	call   c0104bcc <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104d95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d99:	75 2d                	jne    c0104dc8 <alloc_pages+0x66>
c0104d9b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104d9f:	77 27                	ja     c0104dc8 <alloc_pages+0x66>
c0104da1:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0104da6:	85 c0                	test   %eax,%eax
c0104da8:	74 1e                	je     c0104dc8 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104daa:	8b 55 08             	mov    0x8(%ebp),%edx
c0104dad:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0104db2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104db9:	00 
c0104dba:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104dbe:	89 04 24             	mov    %eax,(%esp)
c0104dc1:	e8 69 19 00 00       	call   c010672f <swap_out>
    }
c0104dc6:	eb a7                	jmp    c0104d6f <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104dcb:	c9                   	leave  
c0104dcc:	c3                   	ret    

c0104dcd <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104dcd:	55                   	push   %ebp
c0104dce:	89 e5                	mov    %esp,%ebp
c0104dd0:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104dd3:	e8 ca fd ff ff       	call   c0104ba2 <__intr_save>
c0104dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104ddb:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104de0:	8b 40 10             	mov    0x10(%eax),%eax
c0104de3:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104de6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104dea:	8b 55 08             	mov    0x8(%ebp),%edx
c0104ded:	89 14 24             	mov    %edx,(%esp)
c0104df0:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104df5:	89 04 24             	mov    %eax,(%esp)
c0104df8:	e8 cf fd ff ff       	call   c0104bcc <__intr_restore>
}
c0104dfd:	c9                   	leave  
c0104dfe:	c3                   	ret    

c0104dff <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104dff:	55                   	push   %ebp
c0104e00:	89 e5                	mov    %esp,%ebp
c0104e02:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104e05:	e8 98 fd ff ff       	call   c0104ba2 <__intr_save>
c0104e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104e0d:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104e12:	8b 40 14             	mov    0x14(%eax),%eax
c0104e15:	ff d0                	call   *%eax
c0104e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e1d:	89 04 24             	mov    %eax,(%esp)
c0104e20:	e8 a7 fd ff ff       	call   c0104bcc <__intr_restore>
    return ret;
c0104e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104e28:	c9                   	leave  
c0104e29:	c3                   	ret    

c0104e2a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104e2a:	55                   	push   %ebp
c0104e2b:	89 e5                	mov    %esp,%ebp
c0104e2d:	57                   	push   %edi
c0104e2e:	56                   	push   %esi
c0104e2f:	53                   	push   %ebx
c0104e30:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104e36:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104e3d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104e44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104e4b:	c7 04 24 33 aa 10 c0 	movl   $0xc010aa33,(%esp)
c0104e52:	e8 fc b4 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104e57:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104e5e:	e9 15 01 00 00       	jmp    c0104f78 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104e63:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e66:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e69:	89 d0                	mov    %edx,%eax
c0104e6b:	c1 e0 02             	shl    $0x2,%eax
c0104e6e:	01 d0                	add    %edx,%eax
c0104e70:	c1 e0 02             	shl    $0x2,%eax
c0104e73:	01 c8                	add    %ecx,%eax
c0104e75:	8b 50 08             	mov    0x8(%eax),%edx
c0104e78:	8b 40 04             	mov    0x4(%eax),%eax
c0104e7b:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104e7e:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104e81:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e84:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e87:	89 d0                	mov    %edx,%eax
c0104e89:	c1 e0 02             	shl    $0x2,%eax
c0104e8c:	01 d0                	add    %edx,%eax
c0104e8e:	c1 e0 02             	shl    $0x2,%eax
c0104e91:	01 c8                	add    %ecx,%eax
c0104e93:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104e96:	8b 58 10             	mov    0x10(%eax),%ebx
c0104e99:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104e9c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104e9f:	01 c8                	add    %ecx,%eax
c0104ea1:	11 da                	adc    %ebx,%edx
c0104ea3:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104ea6:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104ea9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104eac:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104eaf:	89 d0                	mov    %edx,%eax
c0104eb1:	c1 e0 02             	shl    $0x2,%eax
c0104eb4:	01 d0                	add    %edx,%eax
c0104eb6:	c1 e0 02             	shl    $0x2,%eax
c0104eb9:	01 c8                	add    %ecx,%eax
c0104ebb:	83 c0 14             	add    $0x14,%eax
c0104ebe:	8b 00                	mov    (%eax),%eax
c0104ec0:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104ec6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104ec9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104ecc:	83 c0 ff             	add    $0xffffffff,%eax
c0104ecf:	83 d2 ff             	adc    $0xffffffff,%edx
c0104ed2:	89 c6                	mov    %eax,%esi
c0104ed4:	89 d7                	mov    %edx,%edi
c0104ed6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ed9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104edc:	89 d0                	mov    %edx,%eax
c0104ede:	c1 e0 02             	shl    $0x2,%eax
c0104ee1:	01 d0                	add    %edx,%eax
c0104ee3:	c1 e0 02             	shl    $0x2,%eax
c0104ee6:	01 c8                	add    %ecx,%eax
c0104ee8:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104eeb:	8b 58 10             	mov    0x10(%eax),%ebx
c0104eee:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104ef4:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104ef8:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104efc:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104f00:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104f03:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104f06:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f0a:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104f0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104f12:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104f16:	c7 04 24 40 aa 10 c0 	movl   $0xc010aa40,(%esp)
c0104f1d:	e8 31 b4 ff ff       	call   c0100353 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104f22:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104f25:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f28:	89 d0                	mov    %edx,%eax
c0104f2a:	c1 e0 02             	shl    $0x2,%eax
c0104f2d:	01 d0                	add    %edx,%eax
c0104f2f:	c1 e0 02             	shl    $0x2,%eax
c0104f32:	01 c8                	add    %ecx,%eax
c0104f34:	83 c0 14             	add    $0x14,%eax
c0104f37:	8b 00                	mov    (%eax),%eax
c0104f39:	83 f8 01             	cmp    $0x1,%eax
c0104f3c:	75 36                	jne    c0104f74 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0104f3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104f44:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104f47:	77 2b                	ja     c0104f74 <page_init+0x14a>
c0104f49:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104f4c:	72 05                	jb     c0104f53 <page_init+0x129>
c0104f4e:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104f51:	73 21                	jae    c0104f74 <page_init+0x14a>
c0104f53:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104f57:	77 1b                	ja     c0104f74 <page_init+0x14a>
c0104f59:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104f5d:	72 09                	jb     c0104f68 <page_init+0x13e>
c0104f5f:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104f66:	77 0c                	ja     c0104f74 <page_init+0x14a>
                maxpa = end;
c0104f68:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f6b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104f6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f71:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104f74:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104f78:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104f7b:	8b 00                	mov    (%eax),%eax
c0104f7d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104f80:	0f 8f dd fe ff ff    	jg     c0104e63 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104f86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f8a:	72 1d                	jb     c0104fa9 <page_init+0x17f>
c0104f8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f90:	77 09                	ja     c0104f9b <page_init+0x171>
c0104f92:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104f99:	76 0e                	jbe    c0104fa9 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104f9b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104fa2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104faf:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104fb3:	c1 ea 0c             	shr    $0xc,%edx
c0104fb6:	a3 40 5a 12 c0       	mov    %eax,0xc0125a40
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104fbb:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104fc2:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c0104fc7:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104fca:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104fcd:	01 d0                	add    %edx,%eax
c0104fcf:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104fd2:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104fd5:	ba 00 00 00 00       	mov    $0x0,%edx
c0104fda:	f7 75 ac             	divl   -0x54(%ebp)
c0104fdd:	89 d0                	mov    %edx,%eax
c0104fdf:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104fe2:	29 c2                	sub    %eax,%edx
c0104fe4:	89 d0                	mov    %edx,%eax
c0104fe6:	a3 2c 7b 12 c0       	mov    %eax,0xc0127b2c

    for (i = 0; i < npage; i ++) {
c0104feb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104ff2:	eb 27                	jmp    c010501b <page_init+0x1f1>
        SetPageReserved(pages + i);
c0104ff4:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104ff9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ffc:	c1 e2 05             	shl    $0x5,%edx
c0104fff:	01 d0                	add    %edx,%eax
c0105001:	83 c0 04             	add    $0x4,%eax
c0105004:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010500b:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010500e:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105011:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105014:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0105017:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010501b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010501e:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105023:	39 c2                	cmp    %eax,%edx
c0105025:	72 cd                	jb     c0104ff4 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0105027:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010502c:	c1 e0 05             	shl    $0x5,%eax
c010502f:	89 c2                	mov    %eax,%edx
c0105031:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0105036:	01 d0                	add    %edx,%eax
c0105038:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010503b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0105042:	77 23                	ja     c0105067 <page_init+0x23d>
c0105044:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105047:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010504b:	c7 44 24 08 70 aa 10 	movl   $0xc010aa70,0x8(%esp)
c0105052:	c0 
c0105053:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010505a:	00 
c010505b:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105062:	e8 76 bc ff ff       	call   c0100cdd <__panic>
c0105067:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010506a:	05 00 00 00 40       	add    $0x40000000,%eax
c010506f:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0105072:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105079:	e9 74 01 00 00       	jmp    c01051f2 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010507e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105081:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105084:	89 d0                	mov    %edx,%eax
c0105086:	c1 e0 02             	shl    $0x2,%eax
c0105089:	01 d0                	add    %edx,%eax
c010508b:	c1 e0 02             	shl    $0x2,%eax
c010508e:	01 c8                	add    %ecx,%eax
c0105090:	8b 50 08             	mov    0x8(%eax),%edx
c0105093:	8b 40 04             	mov    0x4(%eax),%eax
c0105096:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105099:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010509c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010509f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01050a2:	89 d0                	mov    %edx,%eax
c01050a4:	c1 e0 02             	shl    $0x2,%eax
c01050a7:	01 d0                	add    %edx,%eax
c01050a9:	c1 e0 02             	shl    $0x2,%eax
c01050ac:	01 c8                	add    %ecx,%eax
c01050ae:	8b 48 0c             	mov    0xc(%eax),%ecx
c01050b1:	8b 58 10             	mov    0x10(%eax),%ebx
c01050b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01050b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01050ba:	01 c8                	add    %ecx,%eax
c01050bc:	11 da                	adc    %ebx,%edx
c01050be:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01050c1:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01050c4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01050c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01050ca:	89 d0                	mov    %edx,%eax
c01050cc:	c1 e0 02             	shl    $0x2,%eax
c01050cf:	01 d0                	add    %edx,%eax
c01050d1:	c1 e0 02             	shl    $0x2,%eax
c01050d4:	01 c8                	add    %ecx,%eax
c01050d6:	83 c0 14             	add    $0x14,%eax
c01050d9:	8b 00                	mov    (%eax),%eax
c01050db:	83 f8 01             	cmp    $0x1,%eax
c01050de:	0f 85 0a 01 00 00    	jne    c01051ee <page_init+0x3c4>
            if (begin < freemem) {
c01050e4:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01050e7:	ba 00 00 00 00       	mov    $0x0,%edx
c01050ec:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01050ef:	72 17                	jb     c0105108 <page_init+0x2de>
c01050f1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01050f4:	77 05                	ja     c01050fb <page_init+0x2d1>
c01050f6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01050f9:	76 0d                	jbe    c0105108 <page_init+0x2de>
                begin = freemem;
c01050fb:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01050fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105101:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0105108:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010510c:	72 1d                	jb     c010512b <page_init+0x301>
c010510e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105112:	77 09                	ja     c010511d <page_init+0x2f3>
c0105114:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010511b:	76 0e                	jbe    c010512b <page_init+0x301>
                end = KMEMSIZE;
c010511d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0105124:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010512b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010512e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105131:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105134:	0f 87 b4 00 00 00    	ja     c01051ee <page_init+0x3c4>
c010513a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010513d:	72 09                	jb     c0105148 <page_init+0x31e>
c010513f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105142:	0f 83 a6 00 00 00    	jae    c01051ee <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0105148:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010514f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105152:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105155:	01 d0                	add    %edx,%eax
c0105157:	83 e8 01             	sub    $0x1,%eax
c010515a:	89 45 98             	mov    %eax,-0x68(%ebp)
c010515d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105160:	ba 00 00 00 00       	mov    $0x0,%edx
c0105165:	f7 75 9c             	divl   -0x64(%ebp)
c0105168:	89 d0                	mov    %edx,%eax
c010516a:	8b 55 98             	mov    -0x68(%ebp),%edx
c010516d:	29 c2                	sub    %eax,%edx
c010516f:	89 d0                	mov    %edx,%eax
c0105171:	ba 00 00 00 00       	mov    $0x0,%edx
c0105176:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105179:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010517c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010517f:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105182:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105185:	ba 00 00 00 00       	mov    $0x0,%edx
c010518a:	89 c7                	mov    %eax,%edi
c010518c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0105192:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0105195:	89 d0                	mov    %edx,%eax
c0105197:	83 e0 00             	and    $0x0,%eax
c010519a:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010519d:	8b 45 80             	mov    -0x80(%ebp),%eax
c01051a0:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01051a3:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01051a6:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01051a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01051ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01051af:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01051b2:	77 3a                	ja     c01051ee <page_init+0x3c4>
c01051b4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01051b7:	72 05                	jb     c01051be <page_init+0x394>
c01051b9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01051bc:	73 30                	jae    c01051ee <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01051be:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01051c1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01051c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01051c7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01051ca:	29 c8                	sub    %ecx,%eax
c01051cc:	19 da                	sbb    %ebx,%edx
c01051ce:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01051d2:	c1 ea 0c             	shr    $0xc,%edx
c01051d5:	89 c3                	mov    %eax,%ebx
c01051d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01051da:	89 04 24             	mov    %eax,(%esp)
c01051dd:	e8 a4 f8 ff ff       	call   c0104a86 <pa2page>
c01051e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01051e6:	89 04 24             	mov    %eax,(%esp)
c01051e9:	e8 55 fb ff ff       	call   c0104d43 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01051ee:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01051f2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01051f5:	8b 00                	mov    (%eax),%eax
c01051f7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01051fa:	0f 8f 7e fe ff ff    	jg     c010507e <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0105200:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0105206:	5b                   	pop    %ebx
c0105207:	5e                   	pop    %esi
c0105208:	5f                   	pop    %edi
c0105209:	5d                   	pop    %ebp
c010520a:	c3                   	ret    

c010520b <enable_paging>:

static void
enable_paging(void) {
c010520b:	55                   	push   %ebp
c010520c:	89 e5                	mov    %esp,%ebp
c010520e:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0105211:	a1 28 7b 12 c0       	mov    0xc0127b28,%eax
c0105216:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0105219:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010521c:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010521f:	0f 20 c0             	mov    %cr0,%eax
c0105222:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0105225:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0105228:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010522b:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0105232:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0105236:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105239:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010523c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010523f:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0105242:	c9                   	leave  
c0105243:	c3                   	ret    

c0105244 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0105244:	55                   	push   %ebp
c0105245:	89 e5                	mov    %esp,%ebp
c0105247:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010524a:	8b 45 14             	mov    0x14(%ebp),%eax
c010524d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105250:	31 d0                	xor    %edx,%eax
c0105252:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105257:	85 c0                	test   %eax,%eax
c0105259:	74 24                	je     c010527f <boot_map_segment+0x3b>
c010525b:	c7 44 24 0c a2 aa 10 	movl   $0xc010aaa2,0xc(%esp)
c0105262:	c0 
c0105263:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c010526a:	c0 
c010526b:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0105272:	00 
c0105273:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c010527a:	e8 5e ba ff ff       	call   c0100cdd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010527f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105286:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105289:	25 ff 0f 00 00       	and    $0xfff,%eax
c010528e:	89 c2                	mov    %eax,%edx
c0105290:	8b 45 10             	mov    0x10(%ebp),%eax
c0105293:	01 c2                	add    %eax,%edx
c0105295:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105298:	01 d0                	add    %edx,%eax
c010529a:	83 e8 01             	sub    $0x1,%eax
c010529d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01052a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052a3:	ba 00 00 00 00       	mov    $0x0,%edx
c01052a8:	f7 75 f0             	divl   -0x10(%ebp)
c01052ab:	89 d0                	mov    %edx,%eax
c01052ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01052b0:	29 c2                	sub    %eax,%edx
c01052b2:	89 d0                	mov    %edx,%eax
c01052b4:	c1 e8 0c             	shr    $0xc,%eax
c01052b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01052ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01052c8:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01052cb:	8b 45 14             	mov    0x14(%ebp),%eax
c01052ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01052d9:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01052dc:	eb 6b                	jmp    c0105349 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01052de:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01052e5:	00 
c01052e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01052ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01052f0:	89 04 24             	mov    %eax,(%esp)
c01052f3:	e8 d1 01 00 00       	call   c01054c9 <get_pte>
c01052f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01052fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01052ff:	75 24                	jne    c0105325 <boot_map_segment+0xe1>
c0105301:	c7 44 24 0c ce aa 10 	movl   $0xc010aace,0xc(%esp)
c0105308:	c0 
c0105309:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105310:	c0 
c0105311:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0105318:	00 
c0105319:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105320:	e8 b8 b9 ff ff       	call   c0100cdd <__panic>
        *ptep = pa | PTE_P | perm;
c0105325:	8b 45 18             	mov    0x18(%ebp),%eax
c0105328:	8b 55 14             	mov    0x14(%ebp),%edx
c010532b:	09 d0                	or     %edx,%eax
c010532d:	83 c8 01             	or     $0x1,%eax
c0105330:	89 c2                	mov    %eax,%edx
c0105332:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105335:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105337:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010533b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0105342:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0105349:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010534d:	75 8f                	jne    c01052de <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010534f:	c9                   	leave  
c0105350:	c3                   	ret    

c0105351 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0105351:	55                   	push   %ebp
c0105352:	89 e5                	mov    %esp,%ebp
c0105354:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0105357:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010535e:	e8 ff f9 ff ff       	call   c0104d62 <alloc_pages>
c0105363:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010536a:	75 1c                	jne    c0105388 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010536c:	c7 44 24 08 db aa 10 	movl   $0xc010aadb,0x8(%esp)
c0105373:	c0 
c0105374:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010537b:	00 
c010537c:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105383:	e8 55 b9 ff ff       	call   c0100cdd <__panic>
    }
    return page2kva(p);
c0105388:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010538b:	89 04 24             	mov    %eax,(%esp)
c010538e:	e8 38 f7 ff ff       	call   c0104acb <page2kva>
}
c0105393:	c9                   	leave  
c0105394:	c3                   	ret    

c0105395 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0105395:	55                   	push   %ebp
c0105396:	89 e5                	mov    %esp,%ebp
c0105398:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010539b:	e8 70 f9 ff ff       	call   c0104d10 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01053a0:	e8 85 fa ff ff       	call   c0104e2a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01053a5:	e8 3d 05 00 00       	call   c01058e7 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01053aa:	e8 a2 ff ff ff       	call   c0105351 <boot_alloc_page>
c01053af:	a3 44 5a 12 c0       	mov    %eax,0xc0125a44
    memset(boot_pgdir, 0, PGSIZE);
c01053b4:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01053b9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01053c0:	00 
c01053c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01053c8:	00 
c01053c9:	89 04 24             	mov    %eax,(%esp)
c01053cc:	e8 60 47 00 00       	call   c0109b31 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01053d1:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01053d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053d9:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01053e0:	77 23                	ja     c0105405 <pmm_init+0x70>
c01053e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01053e9:	c7 44 24 08 70 aa 10 	movl   $0xc010aa70,0x8(%esp)
c01053f0:	c0 
c01053f1:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c01053f8:	00 
c01053f9:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105400:	e8 d8 b8 ff ff       	call   c0100cdd <__panic>
c0105405:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105408:	05 00 00 00 40       	add    $0x40000000,%eax
c010540d:	a3 28 7b 12 c0       	mov    %eax,0xc0127b28

    check_pgdir();
c0105412:	e8 ee 04 00 00       	call   c0105905 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0105417:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010541c:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0105422:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105427:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010542a:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105431:	77 23                	ja     c0105456 <pmm_init+0xc1>
c0105433:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105436:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010543a:	c7 44 24 08 70 aa 10 	movl   $0xc010aa70,0x8(%esp)
c0105441:	c0 
c0105442:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c0105449:	00 
c010544a:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105451:	e8 87 b8 ff ff       	call   c0100cdd <__panic>
c0105456:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105459:	05 00 00 00 40       	add    $0x40000000,%eax
c010545e:	83 c8 03             	or     $0x3,%eax
c0105461:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0105463:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105468:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010546f:	00 
c0105470:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105477:	00 
c0105478:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010547f:	38 
c0105480:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105487:	c0 
c0105488:	89 04 24             	mov    %eax,(%esp)
c010548b:	e8 b4 fd ff ff       	call   c0105244 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0105490:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105495:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c010549b:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01054a1:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01054a3:	e8 63 fd ff ff       	call   c010520b <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01054a8:	e8 74 f7 ff ff       	call   c0104c21 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01054ad:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01054b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01054b8:	e8 e3 0a 00 00       	call   c0105fa0 <check_boot_pgdir>

    print_pgdir();
c01054bd:	e8 70 0f 00 00       	call   c0106432 <print_pgdir>
    
    kmalloc_init();
c01054c2:	e8 fe f2 ff ff       	call   c01047c5 <kmalloc_init>

}
c01054c7:	c9                   	leave  
c01054c8:	c3                   	ret    

c01054c9 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01054c9:	55                   	push   %ebp
c01054ca:	89 e5                	mov    %esp,%ebp
c01054cc:	83 ec 38             	sub    $0x38,%esp
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */

	// 获取页目录表（一级页表）
	pde_t *pdep = &pgdir[PDX(la)];   // (1) find page directory entry
c01054cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054d2:	c1 e8 16             	shr    $0x16,%eax
c01054d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01054dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01054df:	01 d0                	add    %edx,%eax
c01054e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// 页表、页目录表不存在
	if (!(PTE_P & *pdep)) {              // (2) check if entry is not present
c01054e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054e7:	8b 00                	mov    (%eax),%eax
c01054e9:	83 e0 01             	and    $0x1,%eax
c01054ec:	85 c0                	test   %eax,%eax
c01054ee:	0f 85 b6 00 00 00    	jne    c01055aa <get_pte+0xe1>
		struct Page *page = NULL;
c01054f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		// 如果不需要create或者alloc_page失败
		if(!create || (page = alloc_page()) == NULL) {				  // (3) check if creating is needed, then alloc page for page table
c01054fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01054ff:	74 15                	je     c0105516 <get_pte+0x4d>
c0105501:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105508:	e8 55 f8 ff ff       	call   c0104d62 <alloc_pages>
c010550d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105514:	75 0a                	jne    c0105520 <get_pte+0x57>
			return NULL;
c0105516:	b8 00 00 00 00       	mov    $0x0,%eax
c010551b:	e9 e6 00 00 00       	jmp    c0105606 <get_pte+0x13d>
		}                  // CAUTION: this page is used for page table, not for common data page
		// 到这里，如果需要create的话，就已经执行过alloc了
		// 引用数+1
		set_page_ref(page,1);					// (4) set page reference
c0105520:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105527:	00 
c0105528:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010552b:	89 04 24             	mov    %eax,(%esp)
c010552e:	e8 34 f6 ff ff       	call   c0104b67 <set_page_ref>
		// 获得线性地址
		uintptr_t pa = page2pa(page); 			// (5) get linear address of page
c0105533:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105536:	89 04 24             	mov    %eax,(%esp)
c0105539:	e8 32 f5 ff ff       	call   c0104a70 <page2pa>
c010553e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// If you need to visit a physical address, please use KADDR()
		// KADDR(pa)将物理地址转换为内核虚拟地址，第二个参数将这一页清空，第三个参数是4096也就是一页的大小
		memset(KADDR(pa), 0, PGSIZE);      		// (6) clear page content using memset
c0105541:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105544:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105547:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010554a:	c1 e8 0c             	shr    $0xc,%eax
c010554d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105550:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105555:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105558:	72 23                	jb     c010557d <get_pte+0xb4>
c010555a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010555d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105561:	c7 44 24 08 cc a9 10 	movl   $0xc010a9cc,0x8(%esp)
c0105568:	c0 
c0105569:	c7 44 24 04 94 01 00 	movl   $0x194,0x4(%esp)
c0105570:	00 
c0105571:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105578:	e8 60 b7 ff ff       	call   c0100cdd <__panic>
c010557d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105580:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105585:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010558c:	00 
c010558d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105594:	00 
c0105595:	89 04 24             	mov    %eax,(%esp)
c0105598:	e8 94 45 00 00       	call   c0109b31 <memset>
		// 页目录项内容 = (页表起始物理地址 &0x0FFF) | PTE_U | PTE_W | PTE_P
		*pdep = pa | PTE_U | PTE_W | PTE_P;		// (7) set page directory entry's permission
c010559d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055a0:	83 c8 07             	or     $0x7,%eax
c01055a3:	89 c2                	mov    %eax,%edx
c01055a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055a8:	89 10                	mov    %edx,(%eax)
	}
	// 返回pte_t *，页表的地址
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01055aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055ad:	8b 00                	mov    (%eax),%eax
c01055af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01055b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01055b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055ba:	c1 e8 0c             	shr    $0xc,%eax
c01055bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01055c0:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01055c5:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01055c8:	72 23                	jb     c01055ed <get_pte+0x124>
c01055ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055d1:	c7 44 24 08 cc a9 10 	movl   $0xc010a9cc,0x8(%esp)
c01055d8:	c0 
c01055d9:	c7 44 24 04 99 01 00 	movl   $0x199,0x4(%esp)
c01055e0:	00 
c01055e1:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01055e8:	e8 f0 b6 ff ff       	call   c0100cdd <__panic>
c01055ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055f0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01055f5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055f8:	c1 ea 0c             	shr    $0xc,%edx
c01055fb:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0105601:	c1 e2 02             	shl    $0x2,%edx
c0105604:	01 d0                	add    %edx,%eax
	// 不用再返回NULL了，前面如果不需要create或者alloc失败就会返回NULL
	//return NULL;          // (8) return page table entry


}
c0105606:	c9                   	leave  
c0105607:	c3                   	ret    

c0105608 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0105608:	55                   	push   %ebp
c0105609:	89 e5                	mov    %esp,%ebp
c010560b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010560e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105615:	00 
c0105616:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105619:	89 44 24 04          	mov    %eax,0x4(%esp)
c010561d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105620:	89 04 24             	mov    %eax,(%esp)
c0105623:	e8 a1 fe ff ff       	call   c01054c9 <get_pte>
c0105628:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010562b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010562f:	74 08                	je     c0105639 <get_page+0x31>
        *ptep_store = ptep;
c0105631:	8b 45 10             	mov    0x10(%ebp),%eax
c0105634:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105637:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0105639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010563d:	74 1b                	je     c010565a <get_page+0x52>
c010563f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105642:	8b 00                	mov    (%eax),%eax
c0105644:	83 e0 01             	and    $0x1,%eax
c0105647:	85 c0                	test   %eax,%eax
c0105649:	74 0f                	je     c010565a <get_page+0x52>
        return pa2page(*ptep);
c010564b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010564e:	8b 00                	mov    (%eax),%eax
c0105650:	89 04 24             	mov    %eax,(%esp)
c0105653:	e8 2e f4 ff ff       	call   c0104a86 <pa2page>
c0105658:	eb 05                	jmp    c010565f <get_page+0x57>
    }
    return NULL;
c010565a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010565f:	c9                   	leave  
c0105660:	c3                   	ret    

c0105661 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105661:	55                   	push   %ebp
c0105662:	89 e5                	mov    %esp,%ebp
c0105664:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */

    if (*ptep & PTE_P) {                      //(1) check if this page table entry is present（存在）
c0105667:	8b 45 10             	mov    0x10(%ebp),%eax
c010566a:	8b 00                	mov    (%eax),%eax
c010566c:	83 e0 01             	and    $0x1,%eax
c010566f:	85 c0                	test   %eax,%eax
c0105671:	74 4d                	je     c01056c0 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
c0105673:	8b 45 10             	mov    0x10(%ebp),%eax
c0105676:	8b 00                	mov    (%eax),%eax
c0105678:	89 04 24             	mov    %eax,(%esp)
c010567b:	e8 9f f4 ff ff       	call   c0104b1f <pte2page>
c0105680:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {               //(3) decrease page reference
c0105683:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105686:	89 04 24             	mov    %eax,(%esp)
c0105689:	e8 fd f4 ff ff       	call   c0104b8b <page_ref_dec>
c010568e:	85 c0                	test   %eax,%eax
c0105690:	75 13                	jne    c01056a5 <page_remove_pte+0x44>
        	free_page(page);
c0105692:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105699:	00 
c010569a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010569d:	89 04 24             	mov    %eax,(%esp)
c01056a0:	e8 28 f7 ff ff       	call   c0104dcd <free_pages>
        }
        *ptep = 0;						  //(4) and free this page when page reference reachs 0
c01056a5:	8b 45 10             	mov    0x10(%ebp),%eax
c01056a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                                  	  	  //(5) clear second page table entry
        tlb_invalidate(pgdir, la);  	  //(6) flush tlb
c01056ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b8:	89 04 24             	mov    %eax,(%esp)
c01056bb:	e8 ff 00 00 00       	call   c01057bf <tlb_invalidate>
    }

}
c01056c0:	c9                   	leave  
c01056c1:	c3                   	ret    

c01056c2 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01056c2:	55                   	push   %ebp
c01056c3:	89 e5                	mov    %esp,%ebp
c01056c5:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01056c8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01056cf:	00 
c01056d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056da:	89 04 24             	mov    %eax,(%esp)
c01056dd:	e8 e7 fd ff ff       	call   c01054c9 <get_pte>
c01056e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01056e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01056e9:	74 19                	je     c0105704 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01056eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056ee:	89 44 24 08          	mov    %eax,0x8(%esp)
c01056f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01056fc:	89 04 24             	mov    %eax,(%esp)
c01056ff:	e8 5d ff ff ff       	call   c0105661 <page_remove_pte>
    }
}
c0105704:	c9                   	leave  
c0105705:	c3                   	ret    

c0105706 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105706:	55                   	push   %ebp
c0105707:	89 e5                	mov    %esp,%ebp
c0105709:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010570c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105713:	00 
c0105714:	8b 45 10             	mov    0x10(%ebp),%eax
c0105717:	89 44 24 04          	mov    %eax,0x4(%esp)
c010571b:	8b 45 08             	mov    0x8(%ebp),%eax
c010571e:	89 04 24             	mov    %eax,(%esp)
c0105721:	e8 a3 fd ff ff       	call   c01054c9 <get_pte>
c0105726:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010572d:	75 0a                	jne    c0105739 <page_insert+0x33>
        return -E_NO_MEM;
c010572f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105734:	e9 84 00 00 00       	jmp    c01057bd <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105739:	8b 45 0c             	mov    0xc(%ebp),%eax
c010573c:	89 04 24             	mov    %eax,(%esp)
c010573f:	e8 30 f4 ff ff       	call   c0104b74 <page_ref_inc>
    if (*ptep & PTE_P) {
c0105744:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105747:	8b 00                	mov    (%eax),%eax
c0105749:	83 e0 01             	and    $0x1,%eax
c010574c:	85 c0                	test   %eax,%eax
c010574e:	74 3e                	je     c010578e <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105750:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105753:	8b 00                	mov    (%eax),%eax
c0105755:	89 04 24             	mov    %eax,(%esp)
c0105758:	e8 c2 f3 ff ff       	call   c0104b1f <pte2page>
c010575d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105760:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105763:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105766:	75 0d                	jne    c0105775 <page_insert+0x6f>
            page_ref_dec(page);
c0105768:	8b 45 0c             	mov    0xc(%ebp),%eax
c010576b:	89 04 24             	mov    %eax,(%esp)
c010576e:	e8 18 f4 ff ff       	call   c0104b8b <page_ref_dec>
c0105773:	eb 19                	jmp    c010578e <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105775:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105778:	89 44 24 08          	mov    %eax,0x8(%esp)
c010577c:	8b 45 10             	mov    0x10(%ebp),%eax
c010577f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105783:	8b 45 08             	mov    0x8(%ebp),%eax
c0105786:	89 04 24             	mov    %eax,(%esp)
c0105789:	e8 d3 fe ff ff       	call   c0105661 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010578e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105791:	89 04 24             	mov    %eax,(%esp)
c0105794:	e8 d7 f2 ff ff       	call   c0104a70 <page2pa>
c0105799:	0b 45 14             	or     0x14(%ebp),%eax
c010579c:	83 c8 01             	or     $0x1,%eax
c010579f:	89 c2                	mov    %eax,%edx
c01057a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057a4:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01057a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01057a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b0:	89 04 24             	mov    %eax,(%esp)
c01057b3:	e8 07 00 00 00       	call   c01057bf <tlb_invalidate>
    return 0;
c01057b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01057bd:	c9                   	leave  
c01057be:	c3                   	ret    

c01057bf <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01057bf:	55                   	push   %ebp
c01057c0:	89 e5                	mov    %esp,%ebp
c01057c2:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01057c5:	0f 20 d8             	mov    %cr3,%eax
c01057c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01057cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01057ce:	89 c2                	mov    %eax,%edx
c01057d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01057d6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01057dd:	77 23                	ja     c0105802 <tlb_invalidate+0x43>
c01057df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01057e6:	c7 44 24 08 70 aa 10 	movl   $0xc010aa70,0x8(%esp)
c01057ed:	c0 
c01057ee:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c01057f5:	00 
c01057f6:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01057fd:	e8 db b4 ff ff       	call   c0100cdd <__panic>
c0105802:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105805:	05 00 00 00 40       	add    $0x40000000,%eax
c010580a:	39 c2                	cmp    %eax,%edx
c010580c:	75 0c                	jne    c010581a <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010580e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105811:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105814:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105817:	0f 01 38             	invlpg (%eax)
    }
}
c010581a:	c9                   	leave  
c010581b:	c3                   	ret    

c010581c <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c010581c:	55                   	push   %ebp
c010581d:	89 e5                	mov    %esp,%ebp
c010581f:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105822:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105829:	e8 34 f5 ff ff       	call   c0104d62 <alloc_pages>
c010582e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105835:	0f 84 a7 00 00 00    	je     c01058e2 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c010583b:	8b 45 10             	mov    0x10(%ebp),%eax
c010583e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105845:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105849:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010584c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105850:	8b 45 08             	mov    0x8(%ebp),%eax
c0105853:	89 04 24             	mov    %eax,(%esp)
c0105856:	e8 ab fe ff ff       	call   c0105706 <page_insert>
c010585b:	85 c0                	test   %eax,%eax
c010585d:	74 1a                	je     c0105879 <pgdir_alloc_page+0x5d>
            free_page(page);
c010585f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105866:	00 
c0105867:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010586a:	89 04 24             	mov    %eax,(%esp)
c010586d:	e8 5b f5 ff ff       	call   c0104dcd <free_pages>
            return NULL;
c0105872:	b8 00 00 00 00       	mov    $0x0,%eax
c0105877:	eb 6c                	jmp    c01058e5 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0105879:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c010587e:	85 c0                	test   %eax,%eax
c0105880:	74 60                	je     c01058e2 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0105882:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0105887:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010588e:	00 
c010588f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105892:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105896:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105899:	89 54 24 04          	mov    %edx,0x4(%esp)
c010589d:	89 04 24             	mov    %eax,(%esp)
c01058a0:	e8 3e 0e 00 00       	call   c01066e3 <swap_map_swappable>
            page->pra_vaddr=la;
c01058a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058a8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058ab:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01058ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058b1:	89 04 24             	mov    %eax,(%esp)
c01058b4:	e8 a4 f2 ff ff       	call   c0104b5d <page_ref>
c01058b9:	83 f8 01             	cmp    $0x1,%eax
c01058bc:	74 24                	je     c01058e2 <pgdir_alloc_page+0xc6>
c01058be:	c7 44 24 0c f4 aa 10 	movl   $0xc010aaf4,0xc(%esp)
c01058c5:	c0 
c01058c6:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c01058cd:	c0 
c01058ce:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c01058d5:	00 
c01058d6:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01058dd:	e8 fb b3 ff ff       	call   c0100cdd <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c01058e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01058e5:	c9                   	leave  
c01058e6:	c3                   	ret    

c01058e7 <check_alloc_page>:

static void
check_alloc_page(void) {
c01058e7:	55                   	push   %ebp
c01058e8:	89 e5                	mov    %esp,%ebp
c01058ea:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01058ed:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c01058f2:	8b 40 18             	mov    0x18(%eax),%eax
c01058f5:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01058f7:	c7 04 24 08 ab 10 c0 	movl   $0xc010ab08,(%esp)
c01058fe:	e8 50 aa ff ff       	call   c0100353 <cprintf>
}
c0105903:	c9                   	leave  
c0105904:	c3                   	ret    

c0105905 <check_pgdir>:

static void
check_pgdir(void) {
c0105905:	55                   	push   %ebp
c0105906:	89 e5                	mov    %esp,%ebp
c0105908:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010590b:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105910:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105915:	76 24                	jbe    c010593b <check_pgdir+0x36>
c0105917:	c7 44 24 0c 27 ab 10 	movl   $0xc010ab27,0xc(%esp)
c010591e:	c0 
c010591f:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105926:	c0 
c0105927:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c010592e:	00 
c010592f:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105936:	e8 a2 b3 ff ff       	call   c0100cdd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010593b:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105940:	85 c0                	test   %eax,%eax
c0105942:	74 0e                	je     c0105952 <check_pgdir+0x4d>
c0105944:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105949:	25 ff 0f 00 00       	and    $0xfff,%eax
c010594e:	85 c0                	test   %eax,%eax
c0105950:	74 24                	je     c0105976 <check_pgdir+0x71>
c0105952:	c7 44 24 0c 44 ab 10 	movl   $0xc010ab44,0xc(%esp)
c0105959:	c0 
c010595a:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105961:	c0 
c0105962:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0105969:	00 
c010596a:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105971:	e8 67 b3 ff ff       	call   c0100cdd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105976:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010597b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105982:	00 
c0105983:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010598a:	00 
c010598b:	89 04 24             	mov    %eax,(%esp)
c010598e:	e8 75 fc ff ff       	call   c0105608 <get_page>
c0105993:	85 c0                	test   %eax,%eax
c0105995:	74 24                	je     c01059bb <check_pgdir+0xb6>
c0105997:	c7 44 24 0c 7c ab 10 	movl   $0xc010ab7c,0xc(%esp)
c010599e:	c0 
c010599f:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c01059a6:	c0 
c01059a7:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c01059ae:	00 
c01059af:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01059b6:	e8 22 b3 ff ff       	call   c0100cdd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01059bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01059c2:	e8 9b f3 ff ff       	call   c0104d62 <alloc_pages>
c01059c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01059ca:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01059cf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01059d6:	00 
c01059d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059de:	00 
c01059df:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059e2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059e6:	89 04 24             	mov    %eax,(%esp)
c01059e9:	e8 18 fd ff ff       	call   c0105706 <page_insert>
c01059ee:	85 c0                	test   %eax,%eax
c01059f0:	74 24                	je     c0105a16 <check_pgdir+0x111>
c01059f2:	c7 44 24 0c a4 ab 10 	movl   $0xc010aba4,0xc(%esp)
c01059f9:	c0 
c01059fa:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105a01:	c0 
c0105a02:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0105a09:	00 
c0105a0a:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105a11:	e8 c7 b2 ff ff       	call   c0100cdd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105a16:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105a1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a22:	00 
c0105a23:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105a2a:	00 
c0105a2b:	89 04 24             	mov    %eax,(%esp)
c0105a2e:	e8 96 fa ff ff       	call   c01054c9 <get_pte>
c0105a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105a3a:	75 24                	jne    c0105a60 <check_pgdir+0x15b>
c0105a3c:	c7 44 24 0c d0 ab 10 	movl   $0xc010abd0,0xc(%esp)
c0105a43:	c0 
c0105a44:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105a4b:	c0 
c0105a4c:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0105a53:	00 
c0105a54:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105a5b:	e8 7d b2 ff ff       	call   c0100cdd <__panic>
    assert(pa2page(*ptep) == p1);
c0105a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a63:	8b 00                	mov    (%eax),%eax
c0105a65:	89 04 24             	mov    %eax,(%esp)
c0105a68:	e8 19 f0 ff ff       	call   c0104a86 <pa2page>
c0105a6d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105a70:	74 24                	je     c0105a96 <check_pgdir+0x191>
c0105a72:	c7 44 24 0c fd ab 10 	movl   $0xc010abfd,0xc(%esp)
c0105a79:	c0 
c0105a7a:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105a81:	c0 
c0105a82:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0105a89:	00 
c0105a8a:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105a91:	e8 47 b2 ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p1) == 1);
c0105a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a99:	89 04 24             	mov    %eax,(%esp)
c0105a9c:	e8 bc f0 ff ff       	call   c0104b5d <page_ref>
c0105aa1:	83 f8 01             	cmp    $0x1,%eax
c0105aa4:	74 24                	je     c0105aca <check_pgdir+0x1c5>
c0105aa6:	c7 44 24 0c 12 ac 10 	movl   $0xc010ac12,0xc(%esp)
c0105aad:	c0 
c0105aae:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105ab5:	c0 
c0105ab6:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0105abd:	00 
c0105abe:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105ac5:	e8 13 b2 ff ff       	call   c0100cdd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105aca:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105acf:	8b 00                	mov    (%eax),%eax
c0105ad1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105ad6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105adc:	c1 e8 0c             	shr    $0xc,%eax
c0105adf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105ae2:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105ae7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105aea:	72 23                	jb     c0105b0f <check_pgdir+0x20a>
c0105aec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105aef:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105af3:	c7 44 24 08 cc a9 10 	movl   $0xc010a9cc,0x8(%esp)
c0105afa:	c0 
c0105afb:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0105b02:	00 
c0105b03:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105b0a:	e8 ce b1 ff ff       	call   c0100cdd <__panic>
c0105b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b12:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105b17:	83 c0 04             	add    $0x4,%eax
c0105b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105b1d:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b22:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105b29:	00 
c0105b2a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105b31:	00 
c0105b32:	89 04 24             	mov    %eax,(%esp)
c0105b35:	e8 8f f9 ff ff       	call   c01054c9 <get_pte>
c0105b3a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105b3d:	74 24                	je     c0105b63 <check_pgdir+0x25e>
c0105b3f:	c7 44 24 0c 24 ac 10 	movl   $0xc010ac24,0xc(%esp)
c0105b46:	c0 
c0105b47:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105b4e:	c0 
c0105b4f:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105b56:	00 
c0105b57:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105b5e:	e8 7a b1 ff ff       	call   c0100cdd <__panic>

    p2 = alloc_page();
c0105b63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105b6a:	e8 f3 f1 ff ff       	call   c0104d62 <alloc_pages>
c0105b6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105b72:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b77:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105b7e:	00 
c0105b7f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105b86:	00 
c0105b87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b8a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b8e:	89 04 24             	mov    %eax,(%esp)
c0105b91:	e8 70 fb ff ff       	call   c0105706 <page_insert>
c0105b96:	85 c0                	test   %eax,%eax
c0105b98:	74 24                	je     c0105bbe <check_pgdir+0x2b9>
c0105b9a:	c7 44 24 0c 4c ac 10 	movl   $0xc010ac4c,0xc(%esp)
c0105ba1:	c0 
c0105ba2:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105ba9:	c0 
c0105baa:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0105bb1:	00 
c0105bb2:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105bb9:	e8 1f b1 ff ff       	call   c0100cdd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105bbe:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105bc3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105bca:	00 
c0105bcb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105bd2:	00 
c0105bd3:	89 04 24             	mov    %eax,(%esp)
c0105bd6:	e8 ee f8 ff ff       	call   c01054c9 <get_pte>
c0105bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105be2:	75 24                	jne    c0105c08 <check_pgdir+0x303>
c0105be4:	c7 44 24 0c 84 ac 10 	movl   $0xc010ac84,0xc(%esp)
c0105beb:	c0 
c0105bec:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105bf3:	c0 
c0105bf4:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0105bfb:	00 
c0105bfc:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105c03:	e8 d5 b0 ff ff       	call   c0100cdd <__panic>
    assert(*ptep & PTE_U);
c0105c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c0b:	8b 00                	mov    (%eax),%eax
c0105c0d:	83 e0 04             	and    $0x4,%eax
c0105c10:	85 c0                	test   %eax,%eax
c0105c12:	75 24                	jne    c0105c38 <check_pgdir+0x333>
c0105c14:	c7 44 24 0c b4 ac 10 	movl   $0xc010acb4,0xc(%esp)
c0105c1b:	c0 
c0105c1c:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105c23:	c0 
c0105c24:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0105c2b:	00 
c0105c2c:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105c33:	e8 a5 b0 ff ff       	call   c0100cdd <__panic>
    assert(*ptep & PTE_W);
c0105c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c3b:	8b 00                	mov    (%eax),%eax
c0105c3d:	83 e0 02             	and    $0x2,%eax
c0105c40:	85 c0                	test   %eax,%eax
c0105c42:	75 24                	jne    c0105c68 <check_pgdir+0x363>
c0105c44:	c7 44 24 0c c2 ac 10 	movl   $0xc010acc2,0xc(%esp)
c0105c4b:	c0 
c0105c4c:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105c53:	c0 
c0105c54:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0105c5b:	00 
c0105c5c:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105c63:	e8 75 b0 ff ff       	call   c0100cdd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105c68:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105c6d:	8b 00                	mov    (%eax),%eax
c0105c6f:	83 e0 04             	and    $0x4,%eax
c0105c72:	85 c0                	test   %eax,%eax
c0105c74:	75 24                	jne    c0105c9a <check_pgdir+0x395>
c0105c76:	c7 44 24 0c d0 ac 10 	movl   $0xc010acd0,0xc(%esp)
c0105c7d:	c0 
c0105c7e:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105c85:	c0 
c0105c86:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105c8d:	00 
c0105c8e:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105c95:	e8 43 b0 ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 1);
c0105c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c9d:	89 04 24             	mov    %eax,(%esp)
c0105ca0:	e8 b8 ee ff ff       	call   c0104b5d <page_ref>
c0105ca5:	83 f8 01             	cmp    $0x1,%eax
c0105ca8:	74 24                	je     c0105cce <check_pgdir+0x3c9>
c0105caa:	c7 44 24 0c e6 ac 10 	movl   $0xc010ace6,0xc(%esp)
c0105cb1:	c0 
c0105cb2:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105cb9:	c0 
c0105cba:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105cc1:	00 
c0105cc2:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105cc9:	e8 0f b0 ff ff       	call   c0100cdd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105cce:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105cd3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105cda:	00 
c0105cdb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105ce2:	00 
c0105ce3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ce6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105cea:	89 04 24             	mov    %eax,(%esp)
c0105ced:	e8 14 fa ff ff       	call   c0105706 <page_insert>
c0105cf2:	85 c0                	test   %eax,%eax
c0105cf4:	74 24                	je     c0105d1a <check_pgdir+0x415>
c0105cf6:	c7 44 24 0c f8 ac 10 	movl   $0xc010acf8,0xc(%esp)
c0105cfd:	c0 
c0105cfe:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105d05:	c0 
c0105d06:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105d0d:	00 
c0105d0e:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105d15:	e8 c3 af ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p1) == 2);
c0105d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d1d:	89 04 24             	mov    %eax,(%esp)
c0105d20:	e8 38 ee ff ff       	call   c0104b5d <page_ref>
c0105d25:	83 f8 02             	cmp    $0x2,%eax
c0105d28:	74 24                	je     c0105d4e <check_pgdir+0x449>
c0105d2a:	c7 44 24 0c 24 ad 10 	movl   $0xc010ad24,0xc(%esp)
c0105d31:	c0 
c0105d32:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105d39:	c0 
c0105d3a:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105d41:	00 
c0105d42:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105d49:	e8 8f af ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 0);
c0105d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d51:	89 04 24             	mov    %eax,(%esp)
c0105d54:	e8 04 ee ff ff       	call   c0104b5d <page_ref>
c0105d59:	85 c0                	test   %eax,%eax
c0105d5b:	74 24                	je     c0105d81 <check_pgdir+0x47c>
c0105d5d:	c7 44 24 0c 36 ad 10 	movl   $0xc010ad36,0xc(%esp)
c0105d64:	c0 
c0105d65:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105d6c:	c0 
c0105d6d:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105d74:	00 
c0105d75:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105d7c:	e8 5c af ff ff       	call   c0100cdd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105d81:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105d86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105d8d:	00 
c0105d8e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105d95:	00 
c0105d96:	89 04 24             	mov    %eax,(%esp)
c0105d99:	e8 2b f7 ff ff       	call   c01054c9 <get_pte>
c0105d9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105da1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105da5:	75 24                	jne    c0105dcb <check_pgdir+0x4c6>
c0105da7:	c7 44 24 0c 84 ac 10 	movl   $0xc010ac84,0xc(%esp)
c0105dae:	c0 
c0105daf:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105db6:	c0 
c0105db7:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105dbe:	00 
c0105dbf:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105dc6:	e8 12 af ff ff       	call   c0100cdd <__panic>
    assert(pa2page(*ptep) == p1);
c0105dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dce:	8b 00                	mov    (%eax),%eax
c0105dd0:	89 04 24             	mov    %eax,(%esp)
c0105dd3:	e8 ae ec ff ff       	call   c0104a86 <pa2page>
c0105dd8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105ddb:	74 24                	je     c0105e01 <check_pgdir+0x4fc>
c0105ddd:	c7 44 24 0c fd ab 10 	movl   $0xc010abfd,0xc(%esp)
c0105de4:	c0 
c0105de5:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105dec:	c0 
c0105ded:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105df4:	00 
c0105df5:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105dfc:	e8 dc ae ff ff       	call   c0100cdd <__panic>
    assert((*ptep & PTE_U) == 0);
c0105e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e04:	8b 00                	mov    (%eax),%eax
c0105e06:	83 e0 04             	and    $0x4,%eax
c0105e09:	85 c0                	test   %eax,%eax
c0105e0b:	74 24                	je     c0105e31 <check_pgdir+0x52c>
c0105e0d:	c7 44 24 0c 48 ad 10 	movl   $0xc010ad48,0xc(%esp)
c0105e14:	c0 
c0105e15:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105e1c:	c0 
c0105e1d:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105e24:	00 
c0105e25:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105e2c:	e8 ac ae ff ff       	call   c0100cdd <__panic>

    page_remove(boot_pgdir, 0x0);
c0105e31:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105e36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105e3d:	00 
c0105e3e:	89 04 24             	mov    %eax,(%esp)
c0105e41:	e8 7c f8 ff ff       	call   c01056c2 <page_remove>
    assert(page_ref(p1) == 1);
c0105e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e49:	89 04 24             	mov    %eax,(%esp)
c0105e4c:	e8 0c ed ff ff       	call   c0104b5d <page_ref>
c0105e51:	83 f8 01             	cmp    $0x1,%eax
c0105e54:	74 24                	je     c0105e7a <check_pgdir+0x575>
c0105e56:	c7 44 24 0c 12 ac 10 	movl   $0xc010ac12,0xc(%esp)
c0105e5d:	c0 
c0105e5e:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105e65:	c0 
c0105e66:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105e6d:	00 
c0105e6e:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105e75:	e8 63 ae ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 0);
c0105e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e7d:	89 04 24             	mov    %eax,(%esp)
c0105e80:	e8 d8 ec ff ff       	call   c0104b5d <page_ref>
c0105e85:	85 c0                	test   %eax,%eax
c0105e87:	74 24                	je     c0105ead <check_pgdir+0x5a8>
c0105e89:	c7 44 24 0c 36 ad 10 	movl   $0xc010ad36,0xc(%esp)
c0105e90:	c0 
c0105e91:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105e98:	c0 
c0105e99:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105ea0:	00 
c0105ea1:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105ea8:	e8 30 ae ff ff       	call   c0100cdd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105ead:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105eb2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105eb9:	00 
c0105eba:	89 04 24             	mov    %eax,(%esp)
c0105ebd:	e8 00 f8 ff ff       	call   c01056c2 <page_remove>
    assert(page_ref(p1) == 0);
c0105ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ec5:	89 04 24             	mov    %eax,(%esp)
c0105ec8:	e8 90 ec ff ff       	call   c0104b5d <page_ref>
c0105ecd:	85 c0                	test   %eax,%eax
c0105ecf:	74 24                	je     c0105ef5 <check_pgdir+0x5f0>
c0105ed1:	c7 44 24 0c 5d ad 10 	movl   $0xc010ad5d,0xc(%esp)
c0105ed8:	c0 
c0105ed9:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105ee0:	c0 
c0105ee1:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105ee8:	00 
c0105ee9:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105ef0:	e8 e8 ad ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 0);
c0105ef5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ef8:	89 04 24             	mov    %eax,(%esp)
c0105efb:	e8 5d ec ff ff       	call   c0104b5d <page_ref>
c0105f00:	85 c0                	test   %eax,%eax
c0105f02:	74 24                	je     c0105f28 <check_pgdir+0x623>
c0105f04:	c7 44 24 0c 36 ad 10 	movl   $0xc010ad36,0xc(%esp)
c0105f0b:	c0 
c0105f0c:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105f13:	c0 
c0105f14:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0105f1b:	00 
c0105f1c:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105f23:	e8 b5 ad ff ff       	call   c0100cdd <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0105f28:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105f2d:	8b 00                	mov    (%eax),%eax
c0105f2f:	89 04 24             	mov    %eax,(%esp)
c0105f32:	e8 4f eb ff ff       	call   c0104a86 <pa2page>
c0105f37:	89 04 24             	mov    %eax,(%esp)
c0105f3a:	e8 1e ec ff ff       	call   c0104b5d <page_ref>
c0105f3f:	83 f8 01             	cmp    $0x1,%eax
c0105f42:	74 24                	je     c0105f68 <check_pgdir+0x663>
c0105f44:	c7 44 24 0c 70 ad 10 	movl   $0xc010ad70,0xc(%esp)
c0105f4b:	c0 
c0105f4c:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105f53:	c0 
c0105f54:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c0105f5b:	00 
c0105f5c:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105f63:	e8 75 ad ff ff       	call   c0100cdd <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0105f68:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105f6d:	8b 00                	mov    (%eax),%eax
c0105f6f:	89 04 24             	mov    %eax,(%esp)
c0105f72:	e8 0f eb ff ff       	call   c0104a86 <pa2page>
c0105f77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105f7e:	00 
c0105f7f:	89 04 24             	mov    %eax,(%esp)
c0105f82:	e8 46 ee ff ff       	call   c0104dcd <free_pages>
    boot_pgdir[0] = 0;
c0105f87:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105f8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105f92:	c7 04 24 96 ad 10 c0 	movl   $0xc010ad96,(%esp)
c0105f99:	e8 b5 a3 ff ff       	call   c0100353 <cprintf>
}
c0105f9e:	c9                   	leave  
c0105f9f:	c3                   	ret    

c0105fa0 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105fa0:	55                   	push   %ebp
c0105fa1:	89 e5                	mov    %esp,%ebp
c0105fa3:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105fa6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105fad:	e9 ca 00 00 00       	jmp    c010607c <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fbb:	c1 e8 0c             	shr    $0xc,%eax
c0105fbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105fc1:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105fc6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105fc9:	72 23                	jb     c0105fee <check_boot_pgdir+0x4e>
c0105fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fce:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105fd2:	c7 44 24 08 cc a9 10 	movl   $0xc010a9cc,0x8(%esp)
c0105fd9:	c0 
c0105fda:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
c0105fe1:	00 
c0105fe2:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105fe9:	e8 ef ac ff ff       	call   c0100cdd <__panic>
c0105fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ff1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105ff6:	89 c2                	mov    %eax,%edx
c0105ff8:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105ffd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106004:	00 
c0106005:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106009:	89 04 24             	mov    %eax,(%esp)
c010600c:	e8 b8 f4 ff ff       	call   c01054c9 <get_pte>
c0106011:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106014:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106018:	75 24                	jne    c010603e <check_boot_pgdir+0x9e>
c010601a:	c7 44 24 0c b0 ad 10 	movl   $0xc010adb0,0xc(%esp)
c0106021:	c0 
c0106022:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0106029:	c0 
c010602a:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
c0106031:	00 
c0106032:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0106039:	e8 9f ac ff ff       	call   c0100cdd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010603e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106041:	8b 00                	mov    (%eax),%eax
c0106043:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106048:	89 c2                	mov    %eax,%edx
c010604a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010604d:	39 c2                	cmp    %eax,%edx
c010604f:	74 24                	je     c0106075 <check_boot_pgdir+0xd5>
c0106051:	c7 44 24 0c ed ad 10 	movl   $0xc010aded,0xc(%esp)
c0106058:	c0 
c0106059:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0106060:	c0 
c0106061:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
c0106068:	00 
c0106069:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0106070:	e8 68 ac ff ff       	call   c0100cdd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106075:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010607c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010607f:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0106084:	39 c2                	cmp    %eax,%edx
c0106086:	0f 82 26 ff ff ff    	jb     c0105fb2 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010608c:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106091:	05 ac 0f 00 00       	add    $0xfac,%eax
c0106096:	8b 00                	mov    (%eax),%eax
c0106098:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010609d:	89 c2                	mov    %eax,%edx
c010609f:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01060a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01060a7:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01060ae:	77 23                	ja     c01060d3 <check_boot_pgdir+0x133>
c01060b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01060b7:	c7 44 24 08 70 aa 10 	movl   $0xc010aa70,0x8(%esp)
c01060be:	c0 
c01060bf:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c01060c6:	00 
c01060c7:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01060ce:	e8 0a ac ff ff       	call   c0100cdd <__panic>
c01060d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060d6:	05 00 00 00 40       	add    $0x40000000,%eax
c01060db:	39 c2                	cmp    %eax,%edx
c01060dd:	74 24                	je     c0106103 <check_boot_pgdir+0x163>
c01060df:	c7 44 24 0c 04 ae 10 	movl   $0xc010ae04,0xc(%esp)
c01060e6:	c0 
c01060e7:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c01060ee:	c0 
c01060ef:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c01060f6:	00 
c01060f7:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01060fe:	e8 da ab ff ff       	call   c0100cdd <__panic>

    assert(boot_pgdir[0] == 0);
c0106103:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106108:	8b 00                	mov    (%eax),%eax
c010610a:	85 c0                	test   %eax,%eax
c010610c:	74 24                	je     c0106132 <check_boot_pgdir+0x192>
c010610e:	c7 44 24 0c 38 ae 10 	movl   $0xc010ae38,0xc(%esp)
c0106115:	c0 
c0106116:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c010611d:	c0 
c010611e:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c0106125:	00 
c0106126:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c010612d:	e8 ab ab ff ff       	call   c0100cdd <__panic>

    struct Page *p;
    p = alloc_page();
c0106132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106139:	e8 24 ec ff ff       	call   c0104d62 <alloc_pages>
c010613e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0106141:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106146:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010614d:	00 
c010614e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0106155:	00 
c0106156:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106159:	89 54 24 04          	mov    %edx,0x4(%esp)
c010615d:	89 04 24             	mov    %eax,(%esp)
c0106160:	e8 a1 f5 ff ff       	call   c0105706 <page_insert>
c0106165:	85 c0                	test   %eax,%eax
c0106167:	74 24                	je     c010618d <check_boot_pgdir+0x1ed>
c0106169:	c7 44 24 0c 4c ae 10 	movl   $0xc010ae4c,0xc(%esp)
c0106170:	c0 
c0106171:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0106178:	c0 
c0106179:	c7 44 24 04 5a 02 00 	movl   $0x25a,0x4(%esp)
c0106180:	00 
c0106181:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0106188:	e8 50 ab ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p) == 1);
c010618d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106190:	89 04 24             	mov    %eax,(%esp)
c0106193:	e8 c5 e9 ff ff       	call   c0104b5d <page_ref>
c0106198:	83 f8 01             	cmp    $0x1,%eax
c010619b:	74 24                	je     c01061c1 <check_boot_pgdir+0x221>
c010619d:	c7 44 24 0c 7a ae 10 	movl   $0xc010ae7a,0xc(%esp)
c01061a4:	c0 
c01061a5:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c01061ac:	c0 
c01061ad:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c01061b4:	00 
c01061b5:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01061bc:	e8 1c ab ff ff       	call   c0100cdd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01061c1:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01061c6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01061cd:	00 
c01061ce:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01061d5:	00 
c01061d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01061d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061dd:	89 04 24             	mov    %eax,(%esp)
c01061e0:	e8 21 f5 ff ff       	call   c0105706 <page_insert>
c01061e5:	85 c0                	test   %eax,%eax
c01061e7:	74 24                	je     c010620d <check_boot_pgdir+0x26d>
c01061e9:	c7 44 24 0c 8c ae 10 	movl   $0xc010ae8c,0xc(%esp)
c01061f0:	c0 
c01061f1:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c01061f8:	c0 
c01061f9:	c7 44 24 04 5c 02 00 	movl   $0x25c,0x4(%esp)
c0106200:	00 
c0106201:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0106208:	e8 d0 aa ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p) == 2);
c010620d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106210:	89 04 24             	mov    %eax,(%esp)
c0106213:	e8 45 e9 ff ff       	call   c0104b5d <page_ref>
c0106218:	83 f8 02             	cmp    $0x2,%eax
c010621b:	74 24                	je     c0106241 <check_boot_pgdir+0x2a1>
c010621d:	c7 44 24 0c c3 ae 10 	movl   $0xc010aec3,0xc(%esp)
c0106224:	c0 
c0106225:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c010622c:	c0 
c010622d:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c0106234:	00 
c0106235:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c010623c:	e8 9c aa ff ff       	call   c0100cdd <__panic>

    const char *str = "ucore: Hello world!!";
c0106241:	c7 45 dc d4 ae 10 c0 	movl   $0xc010aed4,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0106248:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010624b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010624f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106256:	e8 ff 35 00 00       	call   c010985a <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010625b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0106262:	00 
c0106263:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010626a:	e8 64 36 00 00       	call   c01098d3 <strcmp>
c010626f:	85 c0                	test   %eax,%eax
c0106271:	74 24                	je     c0106297 <check_boot_pgdir+0x2f7>
c0106273:	c7 44 24 0c ec ae 10 	movl   $0xc010aeec,0xc(%esp)
c010627a:	c0 
c010627b:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0106282:	c0 
c0106283:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c010628a:	00 
c010628b:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0106292:	e8 46 aa ff ff       	call   c0100cdd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0106297:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010629a:	89 04 24             	mov    %eax,(%esp)
c010629d:	e8 29 e8 ff ff       	call   c0104acb <page2kva>
c01062a2:	05 00 01 00 00       	add    $0x100,%eax
c01062a7:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01062aa:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01062b1:	e8 4c 35 00 00       	call   c0109802 <strlen>
c01062b6:	85 c0                	test   %eax,%eax
c01062b8:	74 24                	je     c01062de <check_boot_pgdir+0x33e>
c01062ba:	c7 44 24 0c 24 af 10 	movl   $0xc010af24,0xc(%esp)
c01062c1:	c0 
c01062c2:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c01062c9:	c0 
c01062ca:	c7 44 24 04 64 02 00 	movl   $0x264,0x4(%esp)
c01062d1:	00 
c01062d2:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01062d9:	e8 ff a9 ff ff       	call   c0100cdd <__panic>

    free_page(p);
c01062de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062e5:	00 
c01062e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01062e9:	89 04 24             	mov    %eax,(%esp)
c01062ec:	e8 dc ea ff ff       	call   c0104dcd <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01062f1:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01062f6:	8b 00                	mov    (%eax),%eax
c01062f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01062fd:	89 04 24             	mov    %eax,(%esp)
c0106300:	e8 81 e7 ff ff       	call   c0104a86 <pa2page>
c0106305:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010630c:	00 
c010630d:	89 04 24             	mov    %eax,(%esp)
c0106310:	e8 b8 ea ff ff       	call   c0104dcd <free_pages>
    boot_pgdir[0] = 0;
c0106315:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010631a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0106320:	c7 04 24 48 af 10 c0 	movl   $0xc010af48,(%esp)
c0106327:	e8 27 a0 ff ff       	call   c0100353 <cprintf>
}
c010632c:	c9                   	leave  
c010632d:	c3                   	ret    

c010632e <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010632e:	55                   	push   %ebp
c010632f:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0106331:	8b 45 08             	mov    0x8(%ebp),%eax
c0106334:	83 e0 04             	and    $0x4,%eax
c0106337:	85 c0                	test   %eax,%eax
c0106339:	74 07                	je     c0106342 <perm2str+0x14>
c010633b:	b8 75 00 00 00       	mov    $0x75,%eax
c0106340:	eb 05                	jmp    c0106347 <perm2str+0x19>
c0106342:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106347:	a2 c8 5a 12 c0       	mov    %al,0xc0125ac8
    str[1] = 'r';
c010634c:	c6 05 c9 5a 12 c0 72 	movb   $0x72,0xc0125ac9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106353:	8b 45 08             	mov    0x8(%ebp),%eax
c0106356:	83 e0 02             	and    $0x2,%eax
c0106359:	85 c0                	test   %eax,%eax
c010635b:	74 07                	je     c0106364 <perm2str+0x36>
c010635d:	b8 77 00 00 00       	mov    $0x77,%eax
c0106362:	eb 05                	jmp    c0106369 <perm2str+0x3b>
c0106364:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106369:	a2 ca 5a 12 c0       	mov    %al,0xc0125aca
    str[3] = '\0';
c010636e:	c6 05 cb 5a 12 c0 00 	movb   $0x0,0xc0125acb
    return str;
c0106375:	b8 c8 5a 12 c0       	mov    $0xc0125ac8,%eax
}
c010637a:	5d                   	pop    %ebp
c010637b:	c3                   	ret    

c010637c <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010637c:	55                   	push   %ebp
c010637d:	89 e5                	mov    %esp,%ebp
c010637f:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0106382:	8b 45 10             	mov    0x10(%ebp),%eax
c0106385:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106388:	72 0a                	jb     c0106394 <get_pgtable_items+0x18>
        return 0;
c010638a:	b8 00 00 00 00       	mov    $0x0,%eax
c010638f:	e9 9c 00 00 00       	jmp    c0106430 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106394:	eb 04                	jmp    c010639a <get_pgtable_items+0x1e>
        start ++;
c0106396:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010639a:	8b 45 10             	mov    0x10(%ebp),%eax
c010639d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01063a0:	73 18                	jae    c01063ba <get_pgtable_items+0x3e>
c01063a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01063a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01063ac:	8b 45 14             	mov    0x14(%ebp),%eax
c01063af:	01 d0                	add    %edx,%eax
c01063b1:	8b 00                	mov    (%eax),%eax
c01063b3:	83 e0 01             	and    $0x1,%eax
c01063b6:	85 c0                	test   %eax,%eax
c01063b8:	74 dc                	je     c0106396 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01063ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01063bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01063c0:	73 69                	jae    c010642b <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01063c2:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01063c6:	74 08                	je     c01063d0 <get_pgtable_items+0x54>
            *left_store = start;
c01063c8:	8b 45 18             	mov    0x18(%ebp),%eax
c01063cb:	8b 55 10             	mov    0x10(%ebp),%edx
c01063ce:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01063d0:	8b 45 10             	mov    0x10(%ebp),%eax
c01063d3:	8d 50 01             	lea    0x1(%eax),%edx
c01063d6:	89 55 10             	mov    %edx,0x10(%ebp)
c01063d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01063e0:	8b 45 14             	mov    0x14(%ebp),%eax
c01063e3:	01 d0                	add    %edx,%eax
c01063e5:	8b 00                	mov    (%eax),%eax
c01063e7:	83 e0 07             	and    $0x7,%eax
c01063ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01063ed:	eb 04                	jmp    c01063f3 <get_pgtable_items+0x77>
            start ++;
c01063ef:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01063f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01063f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01063f9:	73 1d                	jae    c0106418 <get_pgtable_items+0x9c>
c01063fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01063fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106405:	8b 45 14             	mov    0x14(%ebp),%eax
c0106408:	01 d0                	add    %edx,%eax
c010640a:	8b 00                	mov    (%eax),%eax
c010640c:	83 e0 07             	and    $0x7,%eax
c010640f:	89 c2                	mov    %eax,%edx
c0106411:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106414:	39 c2                	cmp    %eax,%edx
c0106416:	74 d7                	je     c01063ef <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0106418:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010641c:	74 08                	je     c0106426 <get_pgtable_items+0xaa>
            *right_store = start;
c010641e:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106421:	8b 55 10             	mov    0x10(%ebp),%edx
c0106424:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106426:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106429:	eb 05                	jmp    c0106430 <get_pgtable_items+0xb4>
    }
    return 0;
c010642b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106430:	c9                   	leave  
c0106431:	c3                   	ret    

c0106432 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0106432:	55                   	push   %ebp
c0106433:	89 e5                	mov    %esp,%ebp
c0106435:	57                   	push   %edi
c0106436:	56                   	push   %esi
c0106437:	53                   	push   %ebx
c0106438:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010643b:	c7 04 24 68 af 10 c0 	movl   $0xc010af68,(%esp)
c0106442:	e8 0c 9f ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
c0106447:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010644e:	e9 fa 00 00 00       	jmp    c010654d <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106456:	89 04 24             	mov    %eax,(%esp)
c0106459:	e8 d0 fe ff ff       	call   c010632e <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010645e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106461:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106464:	29 d1                	sub    %edx,%ecx
c0106466:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106468:	89 d6                	mov    %edx,%esi
c010646a:	c1 e6 16             	shl    $0x16,%esi
c010646d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106470:	89 d3                	mov    %edx,%ebx
c0106472:	c1 e3 16             	shl    $0x16,%ebx
c0106475:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106478:	89 d1                	mov    %edx,%ecx
c010647a:	c1 e1 16             	shl    $0x16,%ecx
c010647d:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0106480:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106483:	29 d7                	sub    %edx,%edi
c0106485:	89 fa                	mov    %edi,%edx
c0106487:	89 44 24 14          	mov    %eax,0x14(%esp)
c010648b:	89 74 24 10          	mov    %esi,0x10(%esp)
c010648f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106493:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106497:	89 54 24 04          	mov    %edx,0x4(%esp)
c010649b:	c7 04 24 99 af 10 c0 	movl   $0xc010af99,(%esp)
c01064a2:	e8 ac 9e ff ff       	call   c0100353 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01064a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01064aa:	c1 e0 0a             	shl    $0xa,%eax
c01064ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01064b0:	eb 54                	jmp    c0106506 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01064b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064b5:	89 04 24             	mov    %eax,(%esp)
c01064b8:	e8 71 fe ff ff       	call   c010632e <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01064bd:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01064c0:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01064c3:	29 d1                	sub    %edx,%ecx
c01064c5:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01064c7:	89 d6                	mov    %edx,%esi
c01064c9:	c1 e6 0c             	shl    $0xc,%esi
c01064cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01064cf:	89 d3                	mov    %edx,%ebx
c01064d1:	c1 e3 0c             	shl    $0xc,%ebx
c01064d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01064d7:	c1 e2 0c             	shl    $0xc,%edx
c01064da:	89 d1                	mov    %edx,%ecx
c01064dc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01064df:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01064e2:	29 d7                	sub    %edx,%edi
c01064e4:	89 fa                	mov    %edi,%edx
c01064e6:	89 44 24 14          	mov    %eax,0x14(%esp)
c01064ea:	89 74 24 10          	mov    %esi,0x10(%esp)
c01064ee:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01064f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01064f6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01064fa:	c7 04 24 b8 af 10 c0 	movl   $0xc010afb8,(%esp)
c0106501:	e8 4d 9e ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106506:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010650b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010650e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106511:	89 ce                	mov    %ecx,%esi
c0106513:	c1 e6 0a             	shl    $0xa,%esi
c0106516:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106519:	89 cb                	mov    %ecx,%ebx
c010651b:	c1 e3 0a             	shl    $0xa,%ebx
c010651e:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106521:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106525:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0106528:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010652c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106530:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106534:	89 74 24 04          	mov    %esi,0x4(%esp)
c0106538:	89 1c 24             	mov    %ebx,(%esp)
c010653b:	e8 3c fe ff ff       	call   c010637c <get_pgtable_items>
c0106540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106543:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106547:	0f 85 65 ff ff ff    	jne    c01064b2 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010654d:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106552:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106555:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0106558:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010655c:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010655f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106563:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106567:	89 44 24 08          	mov    %eax,0x8(%esp)
c010656b:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106572:	00 
c0106573:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010657a:	e8 fd fd ff ff       	call   c010637c <get_pgtable_items>
c010657f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106582:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106586:	0f 85 c7 fe ff ff    	jne    c0106453 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010658c:	c7 04 24 dc af 10 c0 	movl   $0xc010afdc,(%esp)
c0106593:	e8 bb 9d ff ff       	call   c0100353 <cprintf>
}
c0106598:	83 c4 4c             	add    $0x4c,%esp
c010659b:	5b                   	pop    %ebx
c010659c:	5e                   	pop    %esi
c010659d:	5f                   	pop    %edi
c010659e:	5d                   	pop    %ebp
c010659f:	c3                   	ret    

c01065a0 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01065a0:	55                   	push   %ebp
c01065a1:	89 e5                	mov    %esp,%ebp
c01065a3:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01065a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01065a9:	c1 e8 0c             	shr    $0xc,%eax
c01065ac:	89 c2                	mov    %eax,%edx
c01065ae:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01065b3:	39 c2                	cmp    %eax,%edx
c01065b5:	72 1c                	jb     c01065d3 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01065b7:	c7 44 24 08 10 b0 10 	movl   $0xc010b010,0x8(%esp)
c01065be:	c0 
c01065bf:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c01065c6:	00 
c01065c7:	c7 04 24 2f b0 10 c0 	movl   $0xc010b02f,(%esp)
c01065ce:	e8 0a a7 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c01065d3:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01065d8:	8b 55 08             	mov    0x8(%ebp),%edx
c01065db:	c1 ea 0c             	shr    $0xc,%edx
c01065de:	c1 e2 05             	shl    $0x5,%edx
c01065e1:	01 d0                	add    %edx,%eax
}
c01065e3:	c9                   	leave  
c01065e4:	c3                   	ret    

c01065e5 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01065e5:	55                   	push   %ebp
c01065e6:	89 e5                	mov    %esp,%ebp
c01065e8:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01065eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01065ee:	83 e0 01             	and    $0x1,%eax
c01065f1:	85 c0                	test   %eax,%eax
c01065f3:	75 1c                	jne    c0106611 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01065f5:	c7 44 24 08 40 b0 10 	movl   $0xc010b040,0x8(%esp)
c01065fc:	c0 
c01065fd:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0106604:	00 
c0106605:	c7 04 24 2f b0 10 c0 	movl   $0xc010b02f,(%esp)
c010660c:	e8 cc a6 ff ff       	call   c0100cdd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106611:	8b 45 08             	mov    0x8(%ebp),%eax
c0106614:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106619:	89 04 24             	mov    %eax,(%esp)
c010661c:	e8 7f ff ff ff       	call   c01065a0 <pa2page>
}
c0106621:	c9                   	leave  
c0106622:	c3                   	ret    

c0106623 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106623:	55                   	push   %ebp
c0106624:	89 e5                	mov    %esp,%ebp
c0106626:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106629:	e8 4a 1d 00 00       	call   c0108378 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c010662e:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c0106633:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106638:	76 0c                	jbe    c0106646 <swap_init+0x23>
c010663a:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c010663f:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106644:	76 25                	jbe    c010666b <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106646:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c010664b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010664f:	c7 44 24 08 61 b0 10 	movl   $0xc010b061,0x8(%esp)
c0106656:	c0 
c0106657:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c010665e:	00 
c010665f:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106666:	e8 72 a6 ff ff       	call   c0100cdd <__panic>
     }
     

     sm = &swap_manager_fifo;
c010666b:	c7 05 d4 5a 12 c0 60 	movl   $0xc0124a60,0xc0125ad4
c0106672:	4a 12 c0 
     int r = sm->init();
c0106675:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010667a:	8b 40 04             	mov    0x4(%eax),%eax
c010667d:	ff d0                	call   *%eax
c010667f:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106686:	75 26                	jne    c01066ae <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106688:	c7 05 cc 5a 12 c0 01 	movl   $0x1,0xc0125acc
c010668f:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106692:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106697:	8b 00                	mov    (%eax),%eax
c0106699:	89 44 24 04          	mov    %eax,0x4(%esp)
c010669d:	c7 04 24 8b b0 10 c0 	movl   $0xc010b08b,(%esp)
c01066a4:	e8 aa 9c ff ff       	call   c0100353 <cprintf>
          check_swap();
c01066a9:	e8 a4 04 00 00       	call   c0106b52 <check_swap>
     }

     return r;
c01066ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01066b1:	c9                   	leave  
c01066b2:	c3                   	ret    

c01066b3 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c01066b3:	55                   	push   %ebp
c01066b4:	89 e5                	mov    %esp,%ebp
c01066b6:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c01066b9:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01066be:	8b 40 08             	mov    0x8(%eax),%eax
c01066c1:	8b 55 08             	mov    0x8(%ebp),%edx
c01066c4:	89 14 24             	mov    %edx,(%esp)
c01066c7:	ff d0                	call   *%eax
}
c01066c9:	c9                   	leave  
c01066ca:	c3                   	ret    

c01066cb <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c01066cb:	55                   	push   %ebp
c01066cc:	89 e5                	mov    %esp,%ebp
c01066ce:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c01066d1:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01066d6:	8b 40 0c             	mov    0xc(%eax),%eax
c01066d9:	8b 55 08             	mov    0x8(%ebp),%edx
c01066dc:	89 14 24             	mov    %edx,(%esp)
c01066df:	ff d0                	call   *%eax
}
c01066e1:	c9                   	leave  
c01066e2:	c3                   	ret    

c01066e3 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01066e3:	55                   	push   %ebp
c01066e4:	89 e5                	mov    %esp,%ebp
c01066e6:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c01066e9:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01066ee:	8b 40 10             	mov    0x10(%eax),%eax
c01066f1:	8b 55 14             	mov    0x14(%ebp),%edx
c01066f4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01066f8:	8b 55 10             	mov    0x10(%ebp),%edx
c01066fb:	89 54 24 08          	mov    %edx,0x8(%esp)
c01066ff:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106702:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106706:	8b 55 08             	mov    0x8(%ebp),%edx
c0106709:	89 14 24             	mov    %edx,(%esp)
c010670c:	ff d0                	call   *%eax
}
c010670e:	c9                   	leave  
c010670f:	c3                   	ret    

c0106710 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106710:	55                   	push   %ebp
c0106711:	89 e5                	mov    %esp,%ebp
c0106713:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106716:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010671b:	8b 40 14             	mov    0x14(%eax),%eax
c010671e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106721:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106725:	8b 55 08             	mov    0x8(%ebp),%edx
c0106728:	89 14 24             	mov    %edx,(%esp)
c010672b:	ff d0                	call   *%eax
}
c010672d:	c9                   	leave  
c010672e:	c3                   	ret    

c010672f <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c010672f:	55                   	push   %ebp
c0106730:	89 e5                	mov    %esp,%ebp
c0106732:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106735:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010673c:	e9 5a 01 00 00       	jmp    c010689b <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106741:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106746:	8b 40 18             	mov    0x18(%eax),%eax
c0106749:	8b 55 10             	mov    0x10(%ebp),%edx
c010674c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106750:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106753:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106757:	8b 55 08             	mov    0x8(%ebp),%edx
c010675a:	89 14 24             	mov    %edx,(%esp)
c010675d:	ff d0                	call   *%eax
c010675f:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106762:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106766:	74 18                	je     c0106780 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106768:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010676b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010676f:	c7 04 24 a0 b0 10 c0 	movl   $0xc010b0a0,(%esp)
c0106776:	e8 d8 9b ff ff       	call   c0100353 <cprintf>
c010677b:	e9 27 01 00 00       	jmp    c01068a7 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106783:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106786:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106789:	8b 45 08             	mov    0x8(%ebp),%eax
c010678c:	8b 40 0c             	mov    0xc(%eax),%eax
c010678f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106796:	00 
c0106797:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010679a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010679e:	89 04 24             	mov    %eax,(%esp)
c01067a1:	e8 23 ed ff ff       	call   c01054c9 <get_pte>
c01067a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01067a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01067ac:	8b 00                	mov    (%eax),%eax
c01067ae:	83 e0 01             	and    $0x1,%eax
c01067b1:	85 c0                	test   %eax,%eax
c01067b3:	75 24                	jne    c01067d9 <swap_out+0xaa>
c01067b5:	c7 44 24 0c cd b0 10 	movl   $0xc010b0cd,0xc(%esp)
c01067bc:	c0 
c01067bd:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c01067c4:	c0 
c01067c5:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01067cc:	00 
c01067cd:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01067d4:	e8 04 a5 ff ff       	call   c0100cdd <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c01067d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01067df:	8b 52 1c             	mov    0x1c(%edx),%edx
c01067e2:	c1 ea 0c             	shr    $0xc,%edx
c01067e5:	83 c2 01             	add    $0x1,%edx
c01067e8:	c1 e2 08             	shl    $0x8,%edx
c01067eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067ef:	89 14 24             	mov    %edx,(%esp)
c01067f2:	e8 3b 1c 00 00       	call   c0108432 <swapfs_write>
c01067f7:	85 c0                	test   %eax,%eax
c01067f9:	74 34                	je     c010682f <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c01067fb:	c7 04 24 f7 b0 10 c0 	movl   $0xc010b0f7,(%esp)
c0106802:	e8 4c 9b ff ff       	call   c0100353 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0106807:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010680c:	8b 40 10             	mov    0x10(%eax),%eax
c010680f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106812:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106819:	00 
c010681a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010681e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106821:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106825:	8b 55 08             	mov    0x8(%ebp),%edx
c0106828:	89 14 24             	mov    %edx,(%esp)
c010682b:	ff d0                	call   *%eax
c010682d:	eb 68                	jmp    c0106897 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c010682f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106832:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106835:	c1 e8 0c             	shr    $0xc,%eax
c0106838:	83 c0 01             	add    $0x1,%eax
c010683b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010683f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106842:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106846:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106849:	89 44 24 04          	mov    %eax,0x4(%esp)
c010684d:	c7 04 24 10 b1 10 c0 	movl   $0xc010b110,(%esp)
c0106854:	e8 fa 9a ff ff       	call   c0100353 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010685c:	8b 40 1c             	mov    0x1c(%eax),%eax
c010685f:	c1 e8 0c             	shr    $0xc,%eax
c0106862:	83 c0 01             	add    $0x1,%eax
c0106865:	c1 e0 08             	shl    $0x8,%eax
c0106868:	89 c2                	mov    %eax,%edx
c010686a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010686d:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c010686f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106872:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106879:	00 
c010687a:	89 04 24             	mov    %eax,(%esp)
c010687d:	e8 4b e5 ff ff       	call   c0104dcd <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106882:	8b 45 08             	mov    0x8(%ebp),%eax
c0106885:	8b 40 0c             	mov    0xc(%eax),%eax
c0106888:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010688b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010688f:	89 04 24             	mov    %eax,(%esp)
c0106892:	e8 28 ef ff ff       	call   c01057bf <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0106897:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010689b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010689e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01068a1:	0f 85 9a fe ff ff    	jne    c0106741 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c01068a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01068aa:	c9                   	leave  
c01068ab:	c3                   	ret    

c01068ac <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01068ac:	55                   	push   %ebp
c01068ad:	89 e5                	mov    %esp,%ebp
c01068af:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c01068b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01068b9:	e8 a4 e4 ff ff       	call   c0104d62 <alloc_pages>
c01068be:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c01068c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01068c5:	75 24                	jne    c01068eb <swap_in+0x3f>
c01068c7:	c7 44 24 0c 50 b1 10 	movl   $0xc010b150,0xc(%esp)
c01068ce:	c0 
c01068cf:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c01068d6:	c0 
c01068d7:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c01068de:	00 
c01068df:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01068e6:	e8 f2 a3 ff ff       	call   c0100cdd <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c01068eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01068ee:	8b 40 0c             	mov    0xc(%eax),%eax
c01068f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01068f8:	00 
c01068f9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01068fc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106900:	89 04 24             	mov    %eax,(%esp)
c0106903:	e8 c1 eb ff ff       	call   c01054c9 <get_pte>
c0106908:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c010690b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010690e:	8b 00                	mov    (%eax),%eax
c0106910:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106913:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106917:	89 04 24             	mov    %eax,(%esp)
c010691a:	e8 a1 1a 00 00       	call   c01083c0 <swapfs_read>
c010691f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106922:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106926:	74 2a                	je     c0106952 <swap_in+0xa6>
     {
        assert(r!=0);
c0106928:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010692c:	75 24                	jne    c0106952 <swap_in+0xa6>
c010692e:	c7 44 24 0c 5d b1 10 	movl   $0xc010b15d,0xc(%esp)
c0106935:	c0 
c0106936:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c010693d:	c0 
c010693e:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c0106945:	00 
c0106946:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c010694d:	e8 8b a3 ff ff       	call   c0100cdd <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106952:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106955:	8b 00                	mov    (%eax),%eax
c0106957:	c1 e8 08             	shr    $0x8,%eax
c010695a:	89 c2                	mov    %eax,%edx
c010695c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010695f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106963:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106967:	c7 04 24 64 b1 10 c0 	movl   $0xc010b164,(%esp)
c010696e:	e8 e0 99 ff ff       	call   c0100353 <cprintf>
     *ptr_result=result;
c0106973:	8b 45 10             	mov    0x10(%ebp),%eax
c0106976:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106979:	89 10                	mov    %edx,(%eax)
     return 0;
c010697b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106980:	c9                   	leave  
c0106981:	c3                   	ret    

c0106982 <check_content_set>:



static inline void
check_content_set(void)
{
c0106982:	55                   	push   %ebp
c0106983:	89 e5                	mov    %esp,%ebp
c0106985:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0106988:	b8 00 10 00 00       	mov    $0x1000,%eax
c010698d:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106990:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106995:	83 f8 01             	cmp    $0x1,%eax
c0106998:	74 24                	je     c01069be <check_content_set+0x3c>
c010699a:	c7 44 24 0c a2 b1 10 	movl   $0xc010b1a2,0xc(%esp)
c01069a1:	c0 
c01069a2:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c01069a9:	c0 
c01069aa:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c01069b1:	00 
c01069b2:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01069b9:	e8 1f a3 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01069be:	b8 10 10 00 00       	mov    $0x1010,%eax
c01069c3:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01069c6:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01069cb:	83 f8 01             	cmp    $0x1,%eax
c01069ce:	74 24                	je     c01069f4 <check_content_set+0x72>
c01069d0:	c7 44 24 0c a2 b1 10 	movl   $0xc010b1a2,0xc(%esp)
c01069d7:	c0 
c01069d8:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c01069df:	c0 
c01069e0:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c01069e7:	00 
c01069e8:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01069ef:	e8 e9 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c01069f4:	b8 00 20 00 00       	mov    $0x2000,%eax
c01069f9:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01069fc:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a01:	83 f8 02             	cmp    $0x2,%eax
c0106a04:	74 24                	je     c0106a2a <check_content_set+0xa8>
c0106a06:	c7 44 24 0c b1 b1 10 	movl   $0xc010b1b1,0xc(%esp)
c0106a0d:	c0 
c0106a0e:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106a15:	c0 
c0106a16:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106a1d:	00 
c0106a1e:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106a25:	e8 b3 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106a2a:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106a2f:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106a32:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a37:	83 f8 02             	cmp    $0x2,%eax
c0106a3a:	74 24                	je     c0106a60 <check_content_set+0xde>
c0106a3c:	c7 44 24 0c b1 b1 10 	movl   $0xc010b1b1,0xc(%esp)
c0106a43:	c0 
c0106a44:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106a4b:	c0 
c0106a4c:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106a53:	00 
c0106a54:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106a5b:	e8 7d a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106a60:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106a65:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106a68:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a6d:	83 f8 03             	cmp    $0x3,%eax
c0106a70:	74 24                	je     c0106a96 <check_content_set+0x114>
c0106a72:	c7 44 24 0c c0 b1 10 	movl   $0xc010b1c0,0xc(%esp)
c0106a79:	c0 
c0106a7a:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106a81:	c0 
c0106a82:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106a89:	00 
c0106a8a:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106a91:	e8 47 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0106a96:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106a9b:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106a9e:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106aa3:	83 f8 03             	cmp    $0x3,%eax
c0106aa6:	74 24                	je     c0106acc <check_content_set+0x14a>
c0106aa8:	c7 44 24 0c c0 b1 10 	movl   $0xc010b1c0,0xc(%esp)
c0106aaf:	c0 
c0106ab0:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106ab7:	c0 
c0106ab8:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106abf:	00 
c0106ac0:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106ac7:	e8 11 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106acc:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106ad1:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106ad4:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106ad9:	83 f8 04             	cmp    $0x4,%eax
c0106adc:	74 24                	je     c0106b02 <check_content_set+0x180>
c0106ade:	c7 44 24 0c cf b1 10 	movl   $0xc010b1cf,0xc(%esp)
c0106ae5:	c0 
c0106ae6:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106aed:	c0 
c0106aee:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106af5:	00 
c0106af6:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106afd:	e8 db a1 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106b02:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106b07:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106b0a:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106b0f:	83 f8 04             	cmp    $0x4,%eax
c0106b12:	74 24                	je     c0106b38 <check_content_set+0x1b6>
c0106b14:	c7 44 24 0c cf b1 10 	movl   $0xc010b1cf,0xc(%esp)
c0106b1b:	c0 
c0106b1c:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106b23:	c0 
c0106b24:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106b2b:	00 
c0106b2c:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106b33:	e8 a5 a1 ff ff       	call   c0100cdd <__panic>
}
c0106b38:	c9                   	leave  
c0106b39:	c3                   	ret    

c0106b3a <check_content_access>:

static inline int
check_content_access(void)
{
c0106b3a:	55                   	push   %ebp
c0106b3b:	89 e5                	mov    %esp,%ebp
c0106b3d:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106b40:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106b45:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106b48:	ff d0                	call   *%eax
c0106b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106b50:	c9                   	leave  
c0106b51:	c3                   	ret    

c0106b52 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106b52:	55                   	push   %ebp
c0106b53:	89 e5                	mov    %esp,%ebp
c0106b55:	53                   	push   %ebx
c0106b56:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0106b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106b60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0106b67:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106b6e:	eb 6b                	jmp    c0106bdb <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0106b70:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106b73:	83 e8 0c             	sub    $0xc,%eax
c0106b76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106b79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b7c:	83 c0 04             	add    $0x4,%eax
c0106b7f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0106b86:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106b89:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106b8c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106b8f:	0f a3 10             	bt     %edx,(%eax)
c0106b92:	19 c0                	sbb    %eax,%eax
c0106b94:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0106b97:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106b9b:	0f 95 c0             	setne  %al
c0106b9e:	0f b6 c0             	movzbl %al,%eax
c0106ba1:	85 c0                	test   %eax,%eax
c0106ba3:	75 24                	jne    c0106bc9 <check_swap+0x77>
c0106ba5:	c7 44 24 0c de b1 10 	movl   $0xc010b1de,0xc(%esp)
c0106bac:	c0 
c0106bad:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106bb4:	c0 
c0106bb5:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106bbc:	00 
c0106bbd:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106bc4:	e8 14 a1 ff ff       	call   c0100cdd <__panic>
        count ++, total += p->property;
c0106bc9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106bcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106bd0:	8b 50 08             	mov    0x8(%eax),%edx
c0106bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106bd6:	01 d0                	add    %edx,%eax
c0106bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106bdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106bde:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106be1:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106be4:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106be7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106bea:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c0106bf1:	0f 85 79 ff ff ff    	jne    c0106b70 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0106bf7:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106bfa:	e8 00 e2 ff ff       	call   c0104dff <nr_free_pages>
c0106bff:	39 c3                	cmp    %eax,%ebx
c0106c01:	74 24                	je     c0106c27 <check_swap+0xd5>
c0106c03:	c7 44 24 0c ee b1 10 	movl   $0xc010b1ee,0xc(%esp)
c0106c0a:	c0 
c0106c0b:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106c12:	c0 
c0106c13:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106c1a:	00 
c0106c1b:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106c22:	e8 b6 a0 ff ff       	call   c0100cdd <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0106c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c2a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c35:	c7 04 24 08 b2 10 c0 	movl   $0xc010b208,(%esp)
c0106c3c:	e8 12 97 ff ff       	call   c0100353 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106c41:	e8 f1 09 00 00       	call   c0107637 <mm_create>
c0106c46:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0106c49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106c4d:	75 24                	jne    c0106c73 <check_swap+0x121>
c0106c4f:	c7 44 24 0c 2e b2 10 	movl   $0xc010b22e,0xc(%esp)
c0106c56:	c0 
c0106c57:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106c5e:	c0 
c0106c5f:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0106c66:	00 
c0106c67:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106c6e:	e8 6a a0 ff ff       	call   c0100cdd <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106c73:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0106c78:	85 c0                	test   %eax,%eax
c0106c7a:	74 24                	je     c0106ca0 <check_swap+0x14e>
c0106c7c:	c7 44 24 0c 39 b2 10 	movl   $0xc010b239,0xc(%esp)
c0106c83:	c0 
c0106c84:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106c8b:	c0 
c0106c8c:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106c93:	00 
c0106c94:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106c9b:	e8 3d a0 ff ff       	call   c0100cdd <__panic>

     check_mm_struct = mm;
c0106ca0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ca3:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0106ca8:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0106cae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106cb1:	89 50 0c             	mov    %edx,0xc(%eax)
c0106cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106cb7:	8b 40 0c             	mov    0xc(%eax),%eax
c0106cba:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106cbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106cc0:	8b 00                	mov    (%eax),%eax
c0106cc2:	85 c0                	test   %eax,%eax
c0106cc4:	74 24                	je     c0106cea <check_swap+0x198>
c0106cc6:	c7 44 24 0c 51 b2 10 	movl   $0xc010b251,0xc(%esp)
c0106ccd:	c0 
c0106cce:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106cd5:	c0 
c0106cd6:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106cdd:	00 
c0106cde:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106ce5:	e8 f3 9f ff ff       	call   c0100cdd <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106cea:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106cf1:	00 
c0106cf2:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0106cf9:	00 
c0106cfa:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106d01:	e8 a9 09 00 00       	call   c01076af <vma_create>
c0106d06:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0106d09:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106d0d:	75 24                	jne    c0106d33 <check_swap+0x1e1>
c0106d0f:	c7 44 24 0c 5f b2 10 	movl   $0xc010b25f,0xc(%esp)
c0106d16:	c0 
c0106d17:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106d1e:	c0 
c0106d1f:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0106d26:	00 
c0106d27:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106d2e:	e8 aa 9f ff ff       	call   c0100cdd <__panic>

     insert_vma_struct(mm, vma);
c0106d33:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106d36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d3d:	89 04 24             	mov    %eax,(%esp)
c0106d40:	e8 fa 0a 00 00       	call   c010783f <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106d45:	c7 04 24 6c b2 10 c0 	movl   $0xc010b26c,(%esp)
c0106d4c:	e8 02 96 ff ff       	call   c0100353 <cprintf>
     pte_t *temp_ptep=NULL;
c0106d51:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106d58:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d5b:	8b 40 0c             	mov    0xc(%eax),%eax
c0106d5e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106d65:	00 
c0106d66:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106d6d:	00 
c0106d6e:	89 04 24             	mov    %eax,(%esp)
c0106d71:	e8 53 e7 ff ff       	call   c01054c9 <get_pte>
c0106d76:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0106d79:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106d7d:	75 24                	jne    c0106da3 <check_swap+0x251>
c0106d7f:	c7 44 24 0c a0 b2 10 	movl   $0xc010b2a0,0xc(%esp)
c0106d86:	c0 
c0106d87:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106d8e:	c0 
c0106d8f:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0106d96:	00 
c0106d97:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106d9e:	e8 3a 9f ff ff       	call   c0100cdd <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106da3:	c7 04 24 b4 b2 10 c0 	movl   $0xc010b2b4,(%esp)
c0106daa:	e8 a4 95 ff ff       	call   c0100353 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106daf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106db6:	e9 a3 00 00 00       	jmp    c0106e5e <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0106dbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106dc2:	e8 9b df ff ff       	call   c0104d62 <alloc_pages>
c0106dc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106dca:	89 04 95 40 7b 12 c0 	mov    %eax,-0x3fed84c0(,%edx,4)
          assert(check_rp[i] != NULL );
c0106dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106dd4:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106ddb:	85 c0                	test   %eax,%eax
c0106ddd:	75 24                	jne    c0106e03 <check_swap+0x2b1>
c0106ddf:	c7 44 24 0c d8 b2 10 	movl   $0xc010b2d8,0xc(%esp)
c0106de6:	c0 
c0106de7:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106dee:	c0 
c0106def:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0106df6:	00 
c0106df7:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106dfe:	e8 da 9e ff ff       	call   c0100cdd <__panic>
          assert(!PageProperty(check_rp[i]));
c0106e03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106e06:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106e0d:	83 c0 04             	add    $0x4,%eax
c0106e10:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0106e17:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106e1a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106e1d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106e20:	0f a3 10             	bt     %edx,(%eax)
c0106e23:	19 c0                	sbb    %eax,%eax
c0106e25:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0106e28:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106e2c:	0f 95 c0             	setne  %al
c0106e2f:	0f b6 c0             	movzbl %al,%eax
c0106e32:	85 c0                	test   %eax,%eax
c0106e34:	74 24                	je     c0106e5a <check_swap+0x308>
c0106e36:	c7 44 24 0c ec b2 10 	movl   $0xc010b2ec,0xc(%esp)
c0106e3d:	c0 
c0106e3e:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106e45:	c0 
c0106e46:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0106e4d:	00 
c0106e4e:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106e55:	e8 83 9e ff ff       	call   c0100cdd <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106e5a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106e5e:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106e62:	0f 8e 53 ff ff ff    	jle    c0106dbb <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0106e68:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0106e6d:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0106e73:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106e76:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106e79:	c7 45 a8 18 7b 12 c0 	movl   $0xc0127b18,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106e80:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106e83:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106e86:	89 50 04             	mov    %edx,0x4(%eax)
c0106e89:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106e8c:	8b 50 04             	mov    0x4(%eax),%edx
c0106e8f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106e92:	89 10                	mov    %edx,(%eax)
c0106e94:	c7 45 a4 18 7b 12 c0 	movl   $0xc0127b18,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106e9b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106e9e:	8b 40 04             	mov    0x4(%eax),%eax
c0106ea1:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0106ea4:	0f 94 c0             	sete   %al
c0106ea7:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0106eaa:	85 c0                	test   %eax,%eax
c0106eac:	75 24                	jne    c0106ed2 <check_swap+0x380>
c0106eae:	c7 44 24 0c 07 b3 10 	movl   $0xc010b307,0xc(%esp)
c0106eb5:	c0 
c0106eb6:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106ebd:	c0 
c0106ebe:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0106ec5:	00 
c0106ec6:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106ecd:	e8 0b 9e ff ff       	call   c0100cdd <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106ed2:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106ed7:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0106eda:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0106ee1:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106ee4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106eeb:	eb 1e                	jmp    c0106f0b <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ef0:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106ef7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106efe:	00 
c0106eff:	89 04 24             	mov    %eax,(%esp)
c0106f02:	e8 c6 de ff ff       	call   c0104dcd <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106f07:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106f0b:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106f0f:	7e dc                	jle    c0106eed <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106f11:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106f16:	83 f8 04             	cmp    $0x4,%eax
c0106f19:	74 24                	je     c0106f3f <check_swap+0x3ed>
c0106f1b:	c7 44 24 0c 20 b3 10 	movl   $0xc010b320,0xc(%esp)
c0106f22:	c0 
c0106f23:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106f2a:	c0 
c0106f2b:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106f32:	00 
c0106f33:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106f3a:	e8 9e 9d ff ff       	call   c0100cdd <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106f3f:	c7 04 24 44 b3 10 c0 	movl   $0xc010b344,(%esp)
c0106f46:	e8 08 94 ff ff       	call   c0100353 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106f4b:	c7 05 d8 5a 12 c0 00 	movl   $0x0,0xc0125ad8
c0106f52:	00 00 00 
     
     check_content_set();
c0106f55:	e8 28 fa ff ff       	call   c0106982 <check_content_set>
     assert( nr_free == 0);         
c0106f5a:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106f5f:	85 c0                	test   %eax,%eax
c0106f61:	74 24                	je     c0106f87 <check_swap+0x435>
c0106f63:	c7 44 24 0c 6b b3 10 	movl   $0xc010b36b,0xc(%esp)
c0106f6a:	c0 
c0106f6b:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106f72:	c0 
c0106f73:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0106f7a:	00 
c0106f7b:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106f82:	e8 56 9d ff ff       	call   c0100cdd <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106f87:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106f8e:	eb 26                	jmp    c0106fb6 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0106f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f93:	c7 04 85 60 7b 12 c0 	movl   $0xffffffff,-0x3fed84a0(,%eax,4)
c0106f9a:	ff ff ff ff 
c0106f9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106fa1:	8b 14 85 60 7b 12 c0 	mov    -0x3fed84a0(,%eax,4),%edx
c0106fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106fab:	89 14 85 a0 7b 12 c0 	mov    %edx,-0x3fed8460(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106fb2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106fb6:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106fba:	7e d4                	jle    c0106f90 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106fbc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106fc3:	e9 eb 00 00 00       	jmp    c01070b3 <check_swap+0x561>
         check_ptep[i]=0;
c0106fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106fcb:	c7 04 85 f4 7b 12 c0 	movl   $0x0,-0x3fed840c(,%eax,4)
c0106fd2:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106fd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106fd9:	83 c0 01             	add    $0x1,%eax
c0106fdc:	c1 e0 0c             	shl    $0xc,%eax
c0106fdf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106fe6:	00 
c0106fe7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106feb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106fee:	89 04 24             	mov    %eax,(%esp)
c0106ff1:	e8 d3 e4 ff ff       	call   c01054c9 <get_pte>
c0106ff6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106ff9:	89 04 95 f4 7b 12 c0 	mov    %eax,-0x3fed840c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0107000:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107003:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c010700a:	85 c0                	test   %eax,%eax
c010700c:	75 24                	jne    c0107032 <check_swap+0x4e0>
c010700e:	c7 44 24 0c 78 b3 10 	movl   $0xc010b378,0xc(%esp)
c0107015:	c0 
c0107016:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c010701d:	c0 
c010701e:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107025:	00 
c0107026:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c010702d:	e8 ab 9c ff ff       	call   c0100cdd <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0107032:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107035:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c010703c:	8b 00                	mov    (%eax),%eax
c010703e:	89 04 24             	mov    %eax,(%esp)
c0107041:	e8 9f f5 ff ff       	call   c01065e5 <pte2page>
c0107046:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107049:	8b 14 95 40 7b 12 c0 	mov    -0x3fed84c0(,%edx,4),%edx
c0107050:	39 d0                	cmp    %edx,%eax
c0107052:	74 24                	je     c0107078 <check_swap+0x526>
c0107054:	c7 44 24 0c 90 b3 10 	movl   $0xc010b390,0xc(%esp)
c010705b:	c0 
c010705c:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0107063:	c0 
c0107064:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c010706b:	00 
c010706c:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0107073:	e8 65 9c ff ff       	call   c0100cdd <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0107078:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010707b:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0107082:	8b 00                	mov    (%eax),%eax
c0107084:	83 e0 01             	and    $0x1,%eax
c0107087:	85 c0                	test   %eax,%eax
c0107089:	75 24                	jne    c01070af <check_swap+0x55d>
c010708b:	c7 44 24 0c b8 b3 10 	movl   $0xc010b3b8,0xc(%esp)
c0107092:	c0 
c0107093:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c010709a:	c0 
c010709b:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01070a2:	00 
c01070a3:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01070aa:	e8 2e 9c ff ff       	call   c0100cdd <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01070af:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01070b3:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01070b7:	0f 8e 0b ff ff ff    	jle    c0106fc8 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c01070bd:	c7 04 24 d4 b3 10 c0 	movl   $0xc010b3d4,(%esp)
c01070c4:	e8 8a 92 ff ff       	call   c0100353 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c01070c9:	e8 6c fa ff ff       	call   c0106b3a <check_content_access>
c01070ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c01070d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01070d5:	74 24                	je     c01070fb <check_swap+0x5a9>
c01070d7:	c7 44 24 0c fa b3 10 	movl   $0xc010b3fa,0xc(%esp)
c01070de:	c0 
c01070df:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c01070e6:	c0 
c01070e7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c01070ee:	00 
c01070ef:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01070f6:	e8 e2 9b ff ff       	call   c0100cdd <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01070fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107102:	eb 1e                	jmp    c0107122 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0107104:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107107:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c010710e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107115:	00 
c0107116:	89 04 24             	mov    %eax,(%esp)
c0107119:	e8 af dc ff ff       	call   c0104dcd <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010711e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107122:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107126:	7e dc                	jle    c0107104 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0107128:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010712b:	89 04 24             	mov    %eax,(%esp)
c010712e:	e8 3c 08 00 00       	call   c010796f <mm_destroy>
         
     nr_free = nr_free_store;
c0107133:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107136:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
     free_list = free_list_store;
c010713b:	8b 45 98             	mov    -0x68(%ebp),%eax
c010713e:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0107141:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0107146:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c

     
     le = &free_list;
c010714c:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0107153:	eb 1d                	jmp    c0107172 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0107155:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107158:	83 e8 0c             	sub    $0xc,%eax
c010715b:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c010715e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107162:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107165:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107168:	8b 40 08             	mov    0x8(%eax),%eax
c010716b:	29 c2                	sub    %eax,%edx
c010716d:	89 d0                	mov    %edx,%eax
c010716f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107172:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107175:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107178:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010717b:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c010717e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107181:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c0107188:	75 cb                	jne    c0107155 <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c010718a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010718d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107191:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107194:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107198:	c7 04 24 01 b4 10 c0 	movl   $0xc010b401,(%esp)
c010719f:	e8 af 91 ff ff       	call   c0100353 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c01071a4:	c7 04 24 1b b4 10 c0 	movl   $0xc010b41b,(%esp)
c01071ab:	e8 a3 91 ff ff       	call   c0100353 <cprintf>
}
c01071b0:	83 c4 74             	add    $0x74,%esp
c01071b3:	5b                   	pop    %ebx
c01071b4:	5d                   	pop    %ebp
c01071b5:	c3                   	ret    

c01071b6 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c01071b6:	55                   	push   %ebp
c01071b7:	89 e5                	mov    %esp,%ebp
c01071b9:	83 ec 10             	sub    $0x10,%esp
c01071bc:	c7 45 fc 04 7c 12 c0 	movl   $0xc0127c04,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01071c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01071c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01071c9:	89 50 04             	mov    %edx,0x4(%eax)
c01071cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01071cf:	8b 50 04             	mov    0x4(%eax),%edx
c01071d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01071d5:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c01071d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01071da:	c7 40 14 04 7c 12 c0 	movl   $0xc0127c04,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c01071e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01071e6:	c9                   	leave  
c01071e7:	c3                   	ret    

c01071e8 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01071e8:	55                   	push   %ebp
c01071e9:	89 e5                	mov    %esp,%ebp
c01071eb:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01071ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01071f1:	8b 40 14             	mov    0x14(%eax),%eax
c01071f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c01071f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01071fa:	83 c0 14             	add    $0x14,%eax
c01071fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0107200:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107204:	74 06                	je     c010720c <_fifo_map_swappable+0x24>
c0107206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010720a:	75 24                	jne    c0107230 <_fifo_map_swappable+0x48>
c010720c:	c7 44 24 0c 34 b4 10 	movl   $0xc010b434,0xc(%esp)
c0107213:	c0 
c0107214:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c010721b:	c0 
c010721c:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0107223:	00 
c0107224:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c010722b:	e8 ad 9a ff ff       	call   c0100cdd <__panic>
c0107230:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107233:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107236:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107239:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010723c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010723f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107242:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107245:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010724b:	8b 40 04             	mov    0x4(%eax),%eax
c010724e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107251:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0107254:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107257:	89 55 d8             	mov    %edx,-0x28(%ebp)
c010725a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010725d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107260:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107263:	89 10                	mov    %edx,(%eax)
c0107265:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107268:	8b 10                	mov    (%eax),%edx
c010726a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010726d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107270:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107273:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107276:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107279:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010727c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010727f:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    // 在头部插入
    list_add(head, entry);				// 用list_add()和list_add_after()都行，查看下这个双向链表的操作函数（在list.h）就知道了。
    return 0;
c0107281:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107286:	c9                   	leave  
c0107287:	c3                   	ret    

c0107288 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0107288:	55                   	push   %ebp
c0107289:	89 e5                	mov    %esp,%ebp
c010728b:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c010728e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107291:	8b 40 14             	mov    0x14(%eax),%eax
c0107294:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0107297:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010729b:	75 24                	jne    c01072c1 <_fifo_swap_out_victim+0x39>
c010729d:	c7 44 24 0c 7b b4 10 	movl   $0xc010b47b,0xc(%esp)
c01072a4:	c0 
c01072a5:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c01072ac:	c0 
c01072ad:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c01072b4:	00 
c01072b5:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01072bc:	e8 1c 9a ff ff       	call   c0100cdd <__panic>
     assert(in_tick==0);
c01072c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01072c5:	74 24                	je     c01072eb <_fifo_swap_out_victim+0x63>
c01072c7:	c7 44 24 0c 88 b4 10 	movl   $0xc010b488,0xc(%esp)
c01072ce:	c0 
c01072cf:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c01072d6:	c0 
c01072d7:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
c01072de:	00 
c01072df:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01072e6:	e8 f2 99 ff ff       	call   c0100cdd <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     // 尾部删除，因为是双向链表，所以很方便找到尾部
     // tail指向尾部
     list_entry_t *tail = head->prev;
c01072eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072ee:	8b 00                	mov    (%eax),%eax
c01072f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page *page = le2page(tail, pra_page_link);
c01072f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072f6:	83 e8 14             	sub    $0x14,%eax
c01072f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01072fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107302:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107305:	8b 40 04             	mov    0x4(%eax),%eax
c0107308:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010730b:	8b 12                	mov    (%edx),%edx
c010730d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107310:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107313:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107316:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107319:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010731c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010731f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107322:	89 10                	mov    %edx,(%eax)
     list_del(tail);
     //(2)  set the addr of addr of this page to ptr_page
     *ptr_page = page;
c0107324:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107327:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010732a:	89 10                	mov    %edx,(%eax)
     return 0;
c010732c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107331:	c9                   	leave  
c0107332:	c3                   	ret    

c0107333 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0107333:	55                   	push   %ebp
c0107334:	89 e5                	mov    %esp,%ebp
c0107336:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107339:	c7 04 24 94 b4 10 c0 	movl   $0xc010b494,(%esp)
c0107340:	e8 0e 90 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107345:	b8 00 30 00 00       	mov    $0x3000,%eax
c010734a:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c010734d:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107352:	83 f8 04             	cmp    $0x4,%eax
c0107355:	74 24                	je     c010737b <_fifo_check_swap+0x48>
c0107357:	c7 44 24 0c ba b4 10 	movl   $0xc010b4ba,0xc(%esp)
c010735e:	c0 
c010735f:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c0107366:	c0 
c0107367:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c010736e:	00 
c010736f:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c0107376:	e8 62 99 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010737b:	c7 04 24 cc b4 10 c0 	movl   $0xc010b4cc,(%esp)
c0107382:	e8 cc 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107387:	b8 00 10 00 00       	mov    $0x1000,%eax
c010738c:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c010738f:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107394:	83 f8 04             	cmp    $0x4,%eax
c0107397:	74 24                	je     c01073bd <_fifo_check_swap+0x8a>
c0107399:	c7 44 24 0c ba b4 10 	movl   $0xc010b4ba,0xc(%esp)
c01073a0:	c0 
c01073a1:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c01073a8:	c0 
c01073a9:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c01073b0:	00 
c01073b1:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01073b8:	e8 20 99 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01073bd:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c01073c4:	e8 8a 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c01073c9:	b8 00 40 00 00       	mov    $0x4000,%eax
c01073ce:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c01073d1:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01073d6:	83 f8 04             	cmp    $0x4,%eax
c01073d9:	74 24                	je     c01073ff <_fifo_check_swap+0xcc>
c01073db:	c7 44 24 0c ba b4 10 	movl   $0xc010b4ba,0xc(%esp)
c01073e2:	c0 
c01073e3:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c01073ea:	c0 
c01073eb:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01073f2:	00 
c01073f3:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01073fa:	e8 de 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01073ff:	c7 04 24 1c b5 10 c0 	movl   $0xc010b51c,(%esp)
c0107406:	e8 48 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010740b:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107410:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0107413:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107418:	83 f8 04             	cmp    $0x4,%eax
c010741b:	74 24                	je     c0107441 <_fifo_check_swap+0x10e>
c010741d:	c7 44 24 0c ba b4 10 	movl   $0xc010b4ba,0xc(%esp)
c0107424:	c0 
c0107425:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c010742c:	c0 
c010742d:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107434:	00 
c0107435:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c010743c:	e8 9c 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107441:	c7 04 24 44 b5 10 c0 	movl   $0xc010b544,(%esp)
c0107448:	e8 06 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c010744d:	b8 00 50 00 00       	mov    $0x5000,%eax
c0107452:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0107455:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010745a:	83 f8 05             	cmp    $0x5,%eax
c010745d:	74 24                	je     c0107483 <_fifo_check_swap+0x150>
c010745f:	c7 44 24 0c 6a b5 10 	movl   $0xc010b56a,0xc(%esp)
c0107466:	c0 
c0107467:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c010746e:	c0 
c010746f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0107476:	00 
c0107477:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c010747e:	e8 5a 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107483:	c7 04 24 1c b5 10 c0 	movl   $0xc010b51c,(%esp)
c010748a:	e8 c4 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010748f:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107494:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107497:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010749c:	83 f8 05             	cmp    $0x5,%eax
c010749f:	74 24                	je     c01074c5 <_fifo_check_swap+0x192>
c01074a1:	c7 44 24 0c 6a b5 10 	movl   $0xc010b56a,0xc(%esp)
c01074a8:	c0 
c01074a9:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c01074b0:	c0 
c01074b1:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01074b8:	00 
c01074b9:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01074c0:	e8 18 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01074c5:	c7 04 24 cc b4 10 c0 	movl   $0xc010b4cc,(%esp)
c01074cc:	e8 82 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01074d1:	b8 00 10 00 00       	mov    $0x1000,%eax
c01074d6:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c01074d9:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01074de:	83 f8 06             	cmp    $0x6,%eax
c01074e1:	74 24                	je     c0107507 <_fifo_check_swap+0x1d4>
c01074e3:	c7 44 24 0c 79 b5 10 	movl   $0xc010b579,0xc(%esp)
c01074ea:	c0 
c01074eb:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c01074f2:	c0 
c01074f3:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01074fa:	00 
c01074fb:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c0107502:	e8 d6 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107507:	c7 04 24 1c b5 10 c0 	movl   $0xc010b51c,(%esp)
c010750e:	e8 40 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107513:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107518:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c010751b:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107520:	83 f8 07             	cmp    $0x7,%eax
c0107523:	74 24                	je     c0107549 <_fifo_check_swap+0x216>
c0107525:	c7 44 24 0c 88 b5 10 	movl   $0xc010b588,0xc(%esp)
c010752c:	c0 
c010752d:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c0107534:	c0 
c0107535:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010753c:	00 
c010753d:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c0107544:	e8 94 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107549:	c7 04 24 94 b4 10 c0 	movl   $0xc010b494,(%esp)
c0107550:	e8 fe 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107555:	b8 00 30 00 00       	mov    $0x3000,%eax
c010755a:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c010755d:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107562:	83 f8 08             	cmp    $0x8,%eax
c0107565:	74 24                	je     c010758b <_fifo_check_swap+0x258>
c0107567:	c7 44 24 0c 97 b5 10 	movl   $0xc010b597,0xc(%esp)
c010756e:	c0 
c010756f:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c0107576:	c0 
c0107577:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010757e:	00 
c010757f:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c0107586:	e8 52 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c010758b:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0107592:	e8 bc 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107597:	b8 00 40 00 00       	mov    $0x4000,%eax
c010759c:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c010759f:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01075a4:	83 f8 09             	cmp    $0x9,%eax
c01075a7:	74 24                	je     c01075cd <_fifo_check_swap+0x29a>
c01075a9:	c7 44 24 0c a6 b5 10 	movl   $0xc010b5a6,0xc(%esp)
c01075b0:	c0 
c01075b1:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c01075b8:	c0 
c01075b9:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01075c0:	00 
c01075c1:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01075c8:	e8 10 97 ff ff       	call   c0100cdd <__panic>
    return 0;
c01075cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01075d2:	c9                   	leave  
c01075d3:	c3                   	ret    

c01075d4 <_fifo_init>:


static int
_fifo_init(void)
{
c01075d4:	55                   	push   %ebp
c01075d5:	89 e5                	mov    %esp,%ebp
    return 0;
c01075d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01075dc:	5d                   	pop    %ebp
c01075dd:	c3                   	ret    

c01075de <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01075de:	55                   	push   %ebp
c01075df:	89 e5                	mov    %esp,%ebp
    return 0;
c01075e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01075e6:	5d                   	pop    %ebp
c01075e7:	c3                   	ret    

c01075e8 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c01075e8:	55                   	push   %ebp
c01075e9:	89 e5                	mov    %esp,%ebp
c01075eb:	b8 00 00 00 00       	mov    $0x0,%eax
c01075f0:	5d                   	pop    %ebp
c01075f1:	c3                   	ret    

c01075f2 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01075f2:	55                   	push   %ebp
c01075f3:	89 e5                	mov    %esp,%ebp
c01075f5:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01075f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01075fb:	c1 e8 0c             	shr    $0xc,%eax
c01075fe:	89 c2                	mov    %eax,%edx
c0107600:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0107605:	39 c2                	cmp    %eax,%edx
c0107607:	72 1c                	jb     c0107625 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107609:	c7 44 24 08 c8 b5 10 	movl   $0xc010b5c8,0x8(%esp)
c0107610:	c0 
c0107611:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0107618:	00 
c0107619:	c7 04 24 e7 b5 10 c0 	movl   $0xc010b5e7,(%esp)
c0107620:	e8 b8 96 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c0107625:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c010762a:	8b 55 08             	mov    0x8(%ebp),%edx
c010762d:	c1 ea 0c             	shr    $0xc,%edx
c0107630:	c1 e2 05             	shl    $0x5,%edx
c0107633:	01 d0                	add    %edx,%eax
}
c0107635:	c9                   	leave  
c0107636:	c3                   	ret    

c0107637 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107637:	55                   	push   %ebp
c0107638:	89 e5                	mov    %esp,%ebp
c010763a:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c010763d:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107644:	e8 bc d2 ff ff       	call   c0104905 <kmalloc>
c0107649:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c010764c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107650:	74 58                	je     c01076aa <mm_create+0x73>
        list_init(&(mm->mmap_list));
c0107652:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107655:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107658:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010765b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010765e:	89 50 04             	mov    %edx,0x4(%eax)
c0107661:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107664:	8b 50 04             	mov    0x4(%eax),%edx
c0107667:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010766a:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c010766c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010766f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107676:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107679:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107680:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107683:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c010768a:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c010768f:	85 c0                	test   %eax,%eax
c0107691:	74 0d                	je     c01076a0 <mm_create+0x69>
c0107693:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107696:	89 04 24             	mov    %eax,(%esp)
c0107699:	e8 15 f0 ff ff       	call   c01066b3 <swap_init_mm>
c010769e:	eb 0a                	jmp    c01076aa <mm_create+0x73>
        else mm->sm_priv = NULL;
c01076a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076a3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c01076aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01076ad:	c9                   	leave  
c01076ae:	c3                   	ret    

c01076af <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c01076af:	55                   	push   %ebp
c01076b0:	89 e5                	mov    %esp,%ebp
c01076b2:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c01076b5:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01076bc:	e8 44 d2 ff ff       	call   c0104905 <kmalloc>
c01076c1:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c01076c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01076c8:	74 1b                	je     c01076e5 <vma_create+0x36>
        vma->vm_start = vm_start;
c01076ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076cd:	8b 55 08             	mov    0x8(%ebp),%edx
c01076d0:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01076d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076d6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01076d9:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01076dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076df:	8b 55 10             	mov    0x10(%ebp),%edx
c01076e2:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c01076e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01076e8:	c9                   	leave  
c01076e9:	c3                   	ret    

c01076ea <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01076ea:	55                   	push   %ebp
c01076eb:	89 e5                	mov    %esp,%ebp
c01076ed:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c01076f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c01076f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01076fb:	0f 84 95 00 00 00    	je     c0107796 <find_vma+0xac>
        vma = mm->mmap_cache;
c0107701:	8b 45 08             	mov    0x8(%ebp),%eax
c0107704:	8b 40 08             	mov    0x8(%eax),%eax
c0107707:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c010770a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010770e:	74 16                	je     c0107726 <find_vma+0x3c>
c0107710:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107713:	8b 40 04             	mov    0x4(%eax),%eax
c0107716:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107719:	77 0b                	ja     c0107726 <find_vma+0x3c>
c010771b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010771e:	8b 40 08             	mov    0x8(%eax),%eax
c0107721:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107724:	77 61                	ja     c0107787 <find_vma+0x9d>
                bool found = 0;
c0107726:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c010772d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107730:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107733:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107736:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107739:	eb 28                	jmp    c0107763 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c010773b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010773e:	83 e8 10             	sub    $0x10,%eax
c0107741:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0107744:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107747:	8b 40 04             	mov    0x4(%eax),%eax
c010774a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010774d:	77 14                	ja     c0107763 <find_vma+0x79>
c010774f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107752:	8b 40 08             	mov    0x8(%eax),%eax
c0107755:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107758:	76 09                	jbe    c0107763 <find_vma+0x79>
                        found = 1;
c010775a:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0107761:	eb 17                	jmp    c010777a <find_vma+0x90>
c0107763:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107766:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107769:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010776c:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c010776f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107772:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107775:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107778:	75 c1                	jne    c010773b <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c010777a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010777e:	75 07                	jne    c0107787 <find_vma+0x9d>
                    vma = NULL;
c0107780:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107787:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010778b:	74 09                	je     c0107796 <find_vma+0xac>
            mm->mmap_cache = vma;
c010778d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107790:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107793:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107796:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107799:	c9                   	leave  
c010779a:	c3                   	ret    

c010779b <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c010779b:	55                   	push   %ebp
c010779c:	89 e5                	mov    %esp,%ebp
c010779e:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c01077a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01077a4:	8b 50 04             	mov    0x4(%eax),%edx
c01077a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01077aa:	8b 40 08             	mov    0x8(%eax),%eax
c01077ad:	39 c2                	cmp    %eax,%edx
c01077af:	72 24                	jb     c01077d5 <check_vma_overlap+0x3a>
c01077b1:	c7 44 24 0c f5 b5 10 	movl   $0xc010b5f5,0xc(%esp)
c01077b8:	c0 
c01077b9:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c01077c0:	c0 
c01077c1:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c01077c8:	00 
c01077c9:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c01077d0:	e8 08 95 ff ff       	call   c0100cdd <__panic>
    assert(prev->vm_end <= next->vm_start);
c01077d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01077d8:	8b 50 08             	mov    0x8(%eax),%edx
c01077db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077de:	8b 40 04             	mov    0x4(%eax),%eax
c01077e1:	39 c2                	cmp    %eax,%edx
c01077e3:	76 24                	jbe    c0107809 <check_vma_overlap+0x6e>
c01077e5:	c7 44 24 0c 38 b6 10 	movl   $0xc010b638,0xc(%esp)
c01077ec:	c0 
c01077ed:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c01077f4:	c0 
c01077f5:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01077fc:	00 
c01077fd:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107804:	e8 d4 94 ff ff       	call   c0100cdd <__panic>
    assert(next->vm_start < next->vm_end);
c0107809:	8b 45 0c             	mov    0xc(%ebp),%eax
c010780c:	8b 50 04             	mov    0x4(%eax),%edx
c010780f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107812:	8b 40 08             	mov    0x8(%eax),%eax
c0107815:	39 c2                	cmp    %eax,%edx
c0107817:	72 24                	jb     c010783d <check_vma_overlap+0xa2>
c0107819:	c7 44 24 0c 57 b6 10 	movl   $0xc010b657,0xc(%esp)
c0107820:	c0 
c0107821:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107828:	c0 
c0107829:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0107830:	00 
c0107831:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107838:	e8 a0 94 ff ff       	call   c0100cdd <__panic>
}
c010783d:	c9                   	leave  
c010783e:	c3                   	ret    

c010783f <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c010783f:	55                   	push   %ebp
c0107840:	89 e5                	mov    %esp,%ebp
c0107842:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107845:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107848:	8b 50 04             	mov    0x4(%eax),%edx
c010784b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010784e:	8b 40 08             	mov    0x8(%eax),%eax
c0107851:	39 c2                	cmp    %eax,%edx
c0107853:	72 24                	jb     c0107879 <insert_vma_struct+0x3a>
c0107855:	c7 44 24 0c 75 b6 10 	movl   $0xc010b675,0xc(%esp)
c010785c:	c0 
c010785d:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107864:	c0 
c0107865:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c010786c:	00 
c010786d:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107874:	e8 64 94 ff ff       	call   c0100cdd <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107879:	8b 45 08             	mov    0x8(%ebp),%eax
c010787c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c010787f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107882:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107885:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107888:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c010788b:	eb 21                	jmp    c01078ae <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c010788d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107890:	83 e8 10             	sub    $0x10,%eax
c0107893:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0107896:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107899:	8b 50 04             	mov    0x4(%eax),%edx
c010789c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010789f:	8b 40 04             	mov    0x4(%eax),%eax
c01078a2:	39 c2                	cmp    %eax,%edx
c01078a4:	76 02                	jbe    c01078a8 <insert_vma_struct+0x69>
                break;
c01078a6:	eb 1d                	jmp    c01078c5 <insert_vma_struct+0x86>
            }
            le_prev = le;
c01078a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01078ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01078b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01078b7:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c01078ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01078bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078c3:	75 c8                	jne    c010788d <insert_vma_struct+0x4e>
c01078c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01078cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01078ce:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c01078d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c01078d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078da:	74 15                	je     c01078f1 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01078dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078df:	8d 50 f0             	lea    -0x10(%eax),%edx
c01078e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078e9:	89 14 24             	mov    %edx,(%esp)
c01078ec:	e8 aa fe ff ff       	call   c010779b <check_vma_overlap>
    }
    if (le_next != list) {
c01078f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01078f4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078f7:	74 15                	je     c010790e <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c01078f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01078fc:	83 e8 10             	sub    $0x10,%eax
c01078ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107903:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107906:	89 04 24             	mov    %eax,(%esp)
c0107909:	e8 8d fe ff ff       	call   c010779b <check_vma_overlap>
    }

    vma->vm_mm = mm;
c010790e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107911:	8b 55 08             	mov    0x8(%ebp),%edx
c0107914:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107916:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107919:	8d 50 10             	lea    0x10(%eax),%edx
c010791c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010791f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107922:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107925:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107928:	8b 40 04             	mov    0x4(%eax),%eax
c010792b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010792e:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0107931:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107934:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107937:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010793a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010793d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107940:	89 10                	mov    %edx,(%eax)
c0107942:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107945:	8b 10                	mov    (%eax),%edx
c0107947:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010794a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010794d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107950:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107953:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107956:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107959:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010795c:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c010795e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107961:	8b 40 10             	mov    0x10(%eax),%eax
c0107964:	8d 50 01             	lea    0x1(%eax),%edx
c0107967:	8b 45 08             	mov    0x8(%ebp),%eax
c010796a:	89 50 10             	mov    %edx,0x10(%eax)
}
c010796d:	c9                   	leave  
c010796e:	c3                   	ret    

c010796f <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c010796f:	55                   	push   %ebp
c0107970:	89 e5                	mov    %esp,%ebp
c0107972:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107975:	8b 45 08             	mov    0x8(%ebp),%eax
c0107978:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c010797b:	eb 36                	jmp    c01079b3 <mm_destroy+0x44>
c010797d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107980:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107983:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107986:	8b 40 04             	mov    0x4(%eax),%eax
c0107989:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010798c:	8b 12                	mov    (%edx),%edx
c010798e:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107991:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107994:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107997:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010799a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010799d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01079a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01079a3:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c01079a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01079a8:	83 e8 10             	sub    $0x10,%eax
c01079ab:	89 04 24             	mov    %eax,(%esp)
c01079ae:	e8 6d cf ff ff       	call   c0104920 <kfree>
c01079b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01079b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01079bc:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c01079bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01079c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01079c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01079c8:	75 b3                	jne    c010797d <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c01079ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01079cd:	89 04 24             	mov    %eax,(%esp)
c01079d0:	e8 4b cf ff ff       	call   c0104920 <kfree>
    mm=NULL;
c01079d5:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01079dc:	c9                   	leave  
c01079dd:	c3                   	ret    

c01079de <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c01079de:	55                   	push   %ebp
c01079df:	89 e5                	mov    %esp,%ebp
c01079e1:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c01079e4:	e8 02 00 00 00       	call   c01079eb <check_vmm>
}
c01079e9:	c9                   	leave  
c01079ea:	c3                   	ret    

c01079eb <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c01079eb:	55                   	push   %ebp
c01079ec:	89 e5                	mov    %esp,%ebp
c01079ee:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01079f1:	e8 09 d4 ff ff       	call   c0104dff <nr_free_pages>
c01079f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01079f9:	e8 13 00 00 00       	call   c0107a11 <check_vma_struct>
    check_pgfault();
c01079fe:	e8 a7 04 00 00       	call   c0107eaa <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c0107a03:	c7 04 24 91 b6 10 c0 	movl   $0xc010b691,(%esp)
c0107a0a:	e8 44 89 ff ff       	call   c0100353 <cprintf>
}
c0107a0f:	c9                   	leave  
c0107a10:	c3                   	ret    

c0107a11 <check_vma_struct>:

static void
check_vma_struct(void) {
c0107a11:	55                   	push   %ebp
c0107a12:	89 e5                	mov    %esp,%ebp
c0107a14:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107a17:	e8 e3 d3 ff ff       	call   c0104dff <nr_free_pages>
c0107a1c:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0107a1f:	e8 13 fc ff ff       	call   c0107637 <mm_create>
c0107a24:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107a27:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107a2b:	75 24                	jne    c0107a51 <check_vma_struct+0x40>
c0107a2d:	c7 44 24 0c a9 b6 10 	movl   $0xc010b6a9,0xc(%esp)
c0107a34:	c0 
c0107a35:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107a3c:	c0 
c0107a3d:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0107a44:	00 
c0107a45:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107a4c:	e8 8c 92 ff ff       	call   c0100cdd <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107a51:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0107a58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107a5b:	89 d0                	mov    %edx,%eax
c0107a5d:	c1 e0 02             	shl    $0x2,%eax
c0107a60:	01 d0                	add    %edx,%eax
c0107a62:	01 c0                	add    %eax,%eax
c0107a64:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107a6d:	eb 70                	jmp    c0107adf <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107a6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a72:	89 d0                	mov    %edx,%eax
c0107a74:	c1 e0 02             	shl    $0x2,%eax
c0107a77:	01 d0                	add    %edx,%eax
c0107a79:	83 c0 02             	add    $0x2,%eax
c0107a7c:	89 c1                	mov    %eax,%ecx
c0107a7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a81:	89 d0                	mov    %edx,%eax
c0107a83:	c1 e0 02             	shl    $0x2,%eax
c0107a86:	01 d0                	add    %edx,%eax
c0107a88:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107a8f:	00 
c0107a90:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107a94:	89 04 24             	mov    %eax,(%esp)
c0107a97:	e8 13 fc ff ff       	call   c01076af <vma_create>
c0107a9c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107a9f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107aa3:	75 24                	jne    c0107ac9 <check_vma_struct+0xb8>
c0107aa5:	c7 44 24 0c b4 b6 10 	movl   $0xc010b6b4,0xc(%esp)
c0107aac:	c0 
c0107aad:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107ab4:	c0 
c0107ab5:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0107abc:	00 
c0107abd:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107ac4:	e8 14 92 ff ff       	call   c0100cdd <__panic>
        insert_vma_struct(mm, vma);
c0107ac9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107acc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ad3:	89 04 24             	mov    %eax,(%esp)
c0107ad6:	e8 64 fd ff ff       	call   c010783f <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0107adb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107adf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107ae3:	7f 8a                	jg     c0107a6f <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107ae8:	83 c0 01             	add    $0x1,%eax
c0107aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107aee:	eb 70                	jmp    c0107b60 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107af3:	89 d0                	mov    %edx,%eax
c0107af5:	c1 e0 02             	shl    $0x2,%eax
c0107af8:	01 d0                	add    %edx,%eax
c0107afa:	83 c0 02             	add    $0x2,%eax
c0107afd:	89 c1                	mov    %eax,%ecx
c0107aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b02:	89 d0                	mov    %edx,%eax
c0107b04:	c1 e0 02             	shl    $0x2,%eax
c0107b07:	01 d0                	add    %edx,%eax
c0107b09:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107b10:	00 
c0107b11:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107b15:	89 04 24             	mov    %eax,(%esp)
c0107b18:	e8 92 fb ff ff       	call   c01076af <vma_create>
c0107b1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107b20:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107b24:	75 24                	jne    c0107b4a <check_vma_struct+0x139>
c0107b26:	c7 44 24 0c b4 b6 10 	movl   $0xc010b6b4,0xc(%esp)
c0107b2d:	c0 
c0107b2e:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107b35:	c0 
c0107b36:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0107b3d:	00 
c0107b3e:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107b45:	e8 93 91 ff ff       	call   c0100cdd <__panic>
        insert_vma_struct(mm, vma);
c0107b4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b51:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b54:	89 04 24             	mov    %eax,(%esp)
c0107b57:	e8 e3 fc ff ff       	call   c010783f <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107b5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b63:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107b66:	7e 88                	jle    c0107af0 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0107b68:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b6b:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107b6e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107b71:	8b 40 04             	mov    0x4(%eax),%eax
c0107b74:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107b77:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107b7e:	e9 97 00 00 00       	jmp    c0107c1a <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b86:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107b89:	75 24                	jne    c0107baf <check_vma_struct+0x19e>
c0107b8b:	c7 44 24 0c c0 b6 10 	movl   $0xc010b6c0,0xc(%esp)
c0107b92:	c0 
c0107b93:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107b9a:	c0 
c0107b9b:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0107ba2:	00 
c0107ba3:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107baa:	e8 2e 91 ff ff       	call   c0100cdd <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107bb2:	83 e8 10             	sub    $0x10,%eax
c0107bb5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107bb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107bbb:	8b 48 04             	mov    0x4(%eax),%ecx
c0107bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107bc1:	89 d0                	mov    %edx,%eax
c0107bc3:	c1 e0 02             	shl    $0x2,%eax
c0107bc6:	01 d0                	add    %edx,%eax
c0107bc8:	39 c1                	cmp    %eax,%ecx
c0107bca:	75 17                	jne    c0107be3 <check_vma_struct+0x1d2>
c0107bcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107bcf:	8b 48 08             	mov    0x8(%eax),%ecx
c0107bd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107bd5:	89 d0                	mov    %edx,%eax
c0107bd7:	c1 e0 02             	shl    $0x2,%eax
c0107bda:	01 d0                	add    %edx,%eax
c0107bdc:	83 c0 02             	add    $0x2,%eax
c0107bdf:	39 c1                	cmp    %eax,%ecx
c0107be1:	74 24                	je     c0107c07 <check_vma_struct+0x1f6>
c0107be3:	c7 44 24 0c d8 b6 10 	movl   $0xc010b6d8,0xc(%esp)
c0107bea:	c0 
c0107beb:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107bf2:	c0 
c0107bf3:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0107bfa:	00 
c0107bfb:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107c02:	e8 d6 90 ff ff       	call   c0100cdd <__panic>
c0107c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c0a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0107c0d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107c10:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0107c13:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0107c16:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c1d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107c20:	0f 8e 5d ff ff ff    	jle    c0107b83 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107c26:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107c2d:	e9 cd 01 00 00       	jmp    c0107dff <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c39:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c3c:	89 04 24             	mov    %eax,(%esp)
c0107c3f:	e8 a6 fa ff ff       	call   c01076ea <find_vma>
c0107c44:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107c47:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107c4b:	75 24                	jne    c0107c71 <check_vma_struct+0x260>
c0107c4d:	c7 44 24 0c 0d b7 10 	movl   $0xc010b70d,0xc(%esp)
c0107c54:	c0 
c0107c55:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107c5c:	c0 
c0107c5d:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0107c64:	00 
c0107c65:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107c6c:	e8 6c 90 ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c74:	83 c0 01             	add    $0x1,%eax
c0107c77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c7e:	89 04 24             	mov    %eax,(%esp)
c0107c81:	e8 64 fa ff ff       	call   c01076ea <find_vma>
c0107c86:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0107c89:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107c8d:	75 24                	jne    c0107cb3 <check_vma_struct+0x2a2>
c0107c8f:	c7 44 24 0c 1a b7 10 	movl   $0xc010b71a,0xc(%esp)
c0107c96:	c0 
c0107c97:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107c9e:	c0 
c0107c9f:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0107ca6:	00 
c0107ca7:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107cae:	e8 2a 90 ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cb6:	83 c0 02             	add    $0x2,%eax
c0107cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107cc0:	89 04 24             	mov    %eax,(%esp)
c0107cc3:	e8 22 fa ff ff       	call   c01076ea <find_vma>
c0107cc8:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107ccb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107ccf:	74 24                	je     c0107cf5 <check_vma_struct+0x2e4>
c0107cd1:	c7 44 24 0c 27 b7 10 	movl   $0xc010b727,0xc(%esp)
c0107cd8:	c0 
c0107cd9:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107ce0:	c0 
c0107ce1:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0107ce8:	00 
c0107ce9:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107cf0:	e8 e8 8f ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cf8:	83 c0 03             	add    $0x3,%eax
c0107cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d02:	89 04 24             	mov    %eax,(%esp)
c0107d05:	e8 e0 f9 ff ff       	call   c01076ea <find_vma>
c0107d0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0107d0d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107d11:	74 24                	je     c0107d37 <check_vma_struct+0x326>
c0107d13:	c7 44 24 0c 34 b7 10 	movl   $0xc010b734,0xc(%esp)
c0107d1a:	c0 
c0107d1b:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107d22:	c0 
c0107d23:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0107d2a:	00 
c0107d2b:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107d32:	e8 a6 8f ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d3a:	83 c0 04             	add    $0x4,%eax
c0107d3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d41:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d44:	89 04 24             	mov    %eax,(%esp)
c0107d47:	e8 9e f9 ff ff       	call   c01076ea <find_vma>
c0107d4c:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107d4f:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107d53:	74 24                	je     c0107d79 <check_vma_struct+0x368>
c0107d55:	c7 44 24 0c 41 b7 10 	movl   $0xc010b741,0xc(%esp)
c0107d5c:	c0 
c0107d5d:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107d64:	c0 
c0107d65:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0107d6c:	00 
c0107d6d:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107d74:	e8 64 8f ff ff       	call   c0100cdd <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107d79:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d7c:	8b 50 04             	mov    0x4(%eax),%edx
c0107d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d82:	39 c2                	cmp    %eax,%edx
c0107d84:	75 10                	jne    c0107d96 <check_vma_struct+0x385>
c0107d86:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d89:	8b 50 08             	mov    0x8(%eax),%edx
c0107d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d8f:	83 c0 02             	add    $0x2,%eax
c0107d92:	39 c2                	cmp    %eax,%edx
c0107d94:	74 24                	je     c0107dba <check_vma_struct+0x3a9>
c0107d96:	c7 44 24 0c 50 b7 10 	movl   $0xc010b750,0xc(%esp)
c0107d9d:	c0 
c0107d9e:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107da5:	c0 
c0107da6:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0107dad:	00 
c0107dae:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107db5:	e8 23 8f ff ff       	call   c0100cdd <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0107dba:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107dbd:	8b 50 04             	mov    0x4(%eax),%edx
c0107dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dc3:	39 c2                	cmp    %eax,%edx
c0107dc5:	75 10                	jne    c0107dd7 <check_vma_struct+0x3c6>
c0107dc7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107dca:	8b 50 08             	mov    0x8(%eax),%edx
c0107dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dd0:	83 c0 02             	add    $0x2,%eax
c0107dd3:	39 c2                	cmp    %eax,%edx
c0107dd5:	74 24                	je     c0107dfb <check_vma_struct+0x3ea>
c0107dd7:	c7 44 24 0c 80 b7 10 	movl   $0xc010b780,0xc(%esp)
c0107dde:	c0 
c0107ddf:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107de6:	c0 
c0107de7:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107dee:	00 
c0107def:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107df6:	e8 e2 8e ff ff       	call   c0100cdd <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107dfb:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107dff:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107e02:	89 d0                	mov    %edx,%eax
c0107e04:	c1 e0 02             	shl    $0x2,%eax
c0107e07:	01 d0                	add    %edx,%eax
c0107e09:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107e0c:	0f 8d 20 fe ff ff    	jge    c0107c32 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107e12:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107e19:	eb 70                	jmp    c0107e8b <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e25:	89 04 24             	mov    %eax,(%esp)
c0107e28:	e8 bd f8 ff ff       	call   c01076ea <find_vma>
c0107e2d:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107e30:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107e34:	74 27                	je     c0107e5d <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107e36:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107e39:	8b 50 08             	mov    0x8(%eax),%edx
c0107e3c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107e3f:	8b 40 04             	mov    0x4(%eax),%eax
c0107e42:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107e46:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e51:	c7 04 24 b0 b7 10 c0 	movl   $0xc010b7b0,(%esp)
c0107e58:	e8 f6 84 ff ff       	call   c0100353 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107e5d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107e61:	74 24                	je     c0107e87 <check_vma_struct+0x476>
c0107e63:	c7 44 24 0c d5 b7 10 	movl   $0xc010b7d5,0xc(%esp)
c0107e6a:	c0 
c0107e6b:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107e72:	c0 
c0107e73:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0107e7a:	00 
c0107e7b:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107e82:	e8 56 8e ff ff       	call   c0100cdd <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107e87:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107e8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107e8f:	79 8a                	jns    c0107e1b <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0107e91:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e94:	89 04 24             	mov    %eax,(%esp)
c0107e97:	e8 d3 fa ff ff       	call   c010796f <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0107e9c:	c7 04 24 ec b7 10 c0 	movl   $0xc010b7ec,(%esp)
c0107ea3:	e8 ab 84 ff ff       	call   c0100353 <cprintf>
}
c0107ea8:	c9                   	leave  
c0107ea9:	c3                   	ret    

c0107eaa <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107eaa:	55                   	push   %ebp
c0107eab:	89 e5                	mov    %esp,%ebp
c0107ead:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107eb0:	e8 4a cf ff ff       	call   c0104dff <nr_free_pages>
c0107eb5:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107eb8:	e8 7a f7 ff ff       	call   c0107637 <mm_create>
c0107ebd:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c
    assert(check_mm_struct != NULL);
c0107ec2:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0107ec7:	85 c0                	test   %eax,%eax
c0107ec9:	75 24                	jne    c0107eef <check_pgfault+0x45>
c0107ecb:	c7 44 24 0c 0b b8 10 	movl   $0xc010b80b,0xc(%esp)
c0107ed2:	c0 
c0107ed3:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107eda:	c0 
c0107edb:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0107ee2:	00 
c0107ee3:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107eea:	e8 ee 8d ff ff       	call   c0100cdd <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107eef:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0107ef4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107ef7:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0107efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f00:	89 50 0c             	mov    %edx,0xc(%eax)
c0107f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f06:	8b 40 0c             	mov    0xc(%eax),%eax
c0107f09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107f0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f0f:	8b 00                	mov    (%eax),%eax
c0107f11:	85 c0                	test   %eax,%eax
c0107f13:	74 24                	je     c0107f39 <check_pgfault+0x8f>
c0107f15:	c7 44 24 0c 23 b8 10 	movl   $0xc010b823,0xc(%esp)
c0107f1c:	c0 
c0107f1d:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107f24:	c0 
c0107f25:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0107f2c:	00 
c0107f2d:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107f34:	e8 a4 8d ff ff       	call   c0100cdd <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107f39:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107f40:	00 
c0107f41:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107f48:	00 
c0107f49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107f50:	e8 5a f7 ff ff       	call   c01076af <vma_create>
c0107f55:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107f58:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107f5c:	75 24                	jne    c0107f82 <check_pgfault+0xd8>
c0107f5e:	c7 44 24 0c b4 b6 10 	movl   $0xc010b6b4,0xc(%esp)
c0107f65:	c0 
c0107f66:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107f6d:	c0 
c0107f6e:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107f75:	00 
c0107f76:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107f7d:	e8 5b 8d ff ff       	call   c0100cdd <__panic>

    insert_vma_struct(mm, vma);
c0107f82:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f89:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f8c:	89 04 24             	mov    %eax,(%esp)
c0107f8f:	e8 ab f8 ff ff       	call   c010783f <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107f94:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107f9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107f9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107fa2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107fa5:	89 04 24             	mov    %eax,(%esp)
c0107fa8:	e8 3d f7 ff ff       	call   c01076ea <find_vma>
c0107fad:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107fb0:	74 24                	je     c0107fd6 <check_pgfault+0x12c>
c0107fb2:	c7 44 24 0c 31 b8 10 	movl   $0xc010b831,0xc(%esp)
c0107fb9:	c0 
c0107fba:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107fc1:	c0 
c0107fc2:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0107fc9:	00 
c0107fca:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107fd1:	e8 07 8d ff ff       	call   c0100cdd <__panic>

    int i, sum = 0;
c0107fd6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107fdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107fe4:	eb 17                	jmp    c0107ffd <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0107fe6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107fe9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107fec:	01 d0                	add    %edx,%eax
c0107fee:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107ff1:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ff6:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107ff9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107ffd:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108001:	7e e3                	jle    c0107fe6 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108003:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010800a:	eb 15                	jmp    c0108021 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c010800c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010800f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108012:	01 d0                	add    %edx,%eax
c0108014:	0f b6 00             	movzbl (%eax),%eax
c0108017:	0f be c0             	movsbl %al,%eax
c010801a:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c010801d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108021:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108025:	7e e5                	jle    c010800c <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0108027:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010802b:	74 24                	je     c0108051 <check_pgfault+0x1a7>
c010802d:	c7 44 24 0c 4b b8 10 	movl   $0xc010b84b,0xc(%esp)
c0108034:	c0 
c0108035:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c010803c:	c0 
c010803d:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0108044:	00 
c0108045:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c010804c:	e8 8c 8c ff ff       	call   c0100cdd <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0108051:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108054:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108057:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010805a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010805f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108063:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108066:	89 04 24             	mov    %eax,(%esp)
c0108069:	e8 54 d6 ff ff       	call   c01056c2 <page_remove>
    free_page(pa2page(pgdir[0]));
c010806e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108071:	8b 00                	mov    (%eax),%eax
c0108073:	89 04 24             	mov    %eax,(%esp)
c0108076:	e8 77 f5 ff ff       	call   c01075f2 <pa2page>
c010807b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108082:	00 
c0108083:	89 04 24             	mov    %eax,(%esp)
c0108086:	e8 42 cd ff ff       	call   c0104dcd <free_pages>
    pgdir[0] = 0;
c010808b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010808e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0108094:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108097:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c010809e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01080a1:	89 04 24             	mov    %eax,(%esp)
c01080a4:	e8 c6 f8 ff ff       	call   c010796f <mm_destroy>
    check_mm_struct = NULL;
c01080a9:	c7 05 0c 7c 12 c0 00 	movl   $0x0,0xc0127c0c
c01080b0:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c01080b3:	e8 47 cd ff ff       	call   c0104dff <nr_free_pages>
c01080b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01080bb:	74 24                	je     c01080e1 <check_pgfault+0x237>
c01080bd:	c7 44 24 0c 54 b8 10 	movl   $0xc010b854,0xc(%esp)
c01080c4:	c0 
c01080c5:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c01080cc:	c0 
c01080cd:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c01080d4:	00 
c01080d5:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c01080dc:	e8 fc 8b ff ff       	call   c0100cdd <__panic>

    cprintf("check_pgfault() succeeded!\n");
c01080e1:	c7 04 24 7b b8 10 c0 	movl   $0xc010b87b,(%esp)
c01080e8:	e8 66 82 ff ff       	call   c0100353 <cprintf>
}
c01080ed:	c9                   	leave  
c01080ee:	c3                   	ret    

c01080ef <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c01080ef:	55                   	push   %ebp
c01080f0:	89 e5                	mov    %esp,%ebp
c01080f2:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c01080f5:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c01080fc:	8b 45 10             	mov    0x10(%ebp),%eax
c01080ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108103:	8b 45 08             	mov    0x8(%ebp),%eax
c0108106:	89 04 24             	mov    %eax,(%esp)
c0108109:	e8 dc f5 ff ff       	call   c01076ea <find_vma>
c010810e:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0108111:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0108116:	83 c0 01             	add    $0x1,%eax
c0108119:	a3 d8 5a 12 c0       	mov    %eax,0xc0125ad8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c010811e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108122:	74 0b                	je     c010812f <do_pgfault+0x40>
c0108124:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108127:	8b 40 04             	mov    0x4(%eax),%eax
c010812a:	3b 45 10             	cmp    0x10(%ebp),%eax
c010812d:	76 18                	jbe    c0108147 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c010812f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108132:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108136:	c7 04 24 98 b8 10 c0 	movl   $0xc010b898,(%esp)
c010813d:	e8 11 82 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108142:	e9 ae 01 00 00       	jmp    c01082f5 <do_pgfault+0x206>
    }
    //check the error_code
    switch (error_code & 3) {
c0108147:	8b 45 0c             	mov    0xc(%ebp),%eax
c010814a:	83 e0 03             	and    $0x3,%eax
c010814d:	85 c0                	test   %eax,%eax
c010814f:	74 36                	je     c0108187 <do_pgfault+0x98>
c0108151:	83 f8 01             	cmp    $0x1,%eax
c0108154:	74 20                	je     c0108176 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0108156:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108159:	8b 40 0c             	mov    0xc(%eax),%eax
c010815c:	83 e0 02             	and    $0x2,%eax
c010815f:	85 c0                	test   %eax,%eax
c0108161:	75 11                	jne    c0108174 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0108163:	c7 04 24 c8 b8 10 c0 	movl   $0xc010b8c8,(%esp)
c010816a:	e8 e4 81 ff ff       	call   c0100353 <cprintf>
            goto failed;
c010816f:	e9 81 01 00 00       	jmp    c01082f5 <do_pgfault+0x206>
        }
        break;
c0108174:	eb 2f                	jmp    c01081a5 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108176:	c7 04 24 28 b9 10 c0 	movl   $0xc010b928,(%esp)
c010817d:	e8 d1 81 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108182:	e9 6e 01 00 00       	jmp    c01082f5 <do_pgfault+0x206>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0108187:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010818a:	8b 40 0c             	mov    0xc(%eax),%eax
c010818d:	83 e0 05             	and    $0x5,%eax
c0108190:	85 c0                	test   %eax,%eax
c0108192:	75 11                	jne    c01081a5 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108194:	c7 04 24 60 b9 10 c0 	movl   $0xc010b960,(%esp)
c010819b:	e8 b3 81 ff ff       	call   c0100353 <cprintf>
            goto failed;
c01081a0:	e9 50 01 00 00       	jmp    c01082f5 <do_pgfault+0x206>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c01081a5:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c01081ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081af:	8b 40 0c             	mov    0xc(%eax),%eax
c01081b2:	83 e0 02             	and    $0x2,%eax
c01081b5:	85 c0                	test   %eax,%eax
c01081b7:	74 04                	je     c01081bd <do_pgfault+0xce>
        perm |= PTE_W;
c01081b9:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c01081bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01081c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01081c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01081cb:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c01081ce:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c01081d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    *
    */

    /*LAB3 EXERCISE 1: YOUR CODE*/
    // 通过addr这个线性地址返回对应的虚拟页pte 如果没有get_pte会创建一个虚拟页 同时ptep等于0
    ptep = get_pte(mm->pgdir, addr, 1);             //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
c01081dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01081df:	8b 40 0c             	mov    0xc(%eax),%eax
c01081e2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01081e9:	00 
c01081ea:	8b 55 10             	mov    0x10(%ebp),%edx
c01081ed:	89 54 24 04          	mov    %edx,0x4(%esp)
c01081f1:	89 04 24             	mov    %eax,(%esp)
c01081f4:	e8 d0 d2 ff ff       	call   c01054c9 <get_pte>
c01081f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // ptep等于NULL代表alloc_page创建虚拟页失败
    if (ptep == NULL) {
c01081fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108200:	75 11                	jne    c0108213 <do_pgfault+0x124>
    	cprintf("ptep == NULL");		// 方便调试
c0108202:	c7 04 24 c3 b9 10 c0 	movl   $0xc010b9c3,(%esp)
c0108209:	e8 45 81 ff ff       	call   c0100353 <cprintf>
    	goto failed;
c010820e:	e9 e2 00 00 00       	jmp    c01082f5 <do_pgfault+0x206>
    }
    // 等于0是创建好虚拟页后还没有物理页与之对应
    if (*ptep == 0) {
c0108213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108216:	8b 00                	mov    (%eax),%eax
c0108218:	85 c0                	test   %eax,%eax
c010821a:	75 35                	jne    c0108251 <do_pgfault+0x162>
    	// 尝试分配物理页
    	if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {     //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
c010821c:	8b 45 08             	mov    0x8(%ebp),%eax
c010821f:	8b 40 0c             	mov    0xc(%eax),%eax
c0108222:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108225:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108229:	8b 55 10             	mov    0x10(%ebp),%edx
c010822c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108230:	89 04 24             	mov    %eax,(%esp)
c0108233:	e8 e4 d5 ff ff       	call   c010581c <pgdir_alloc_page>
c0108238:	85 c0                	test   %eax,%eax
c010823a:	0f 85 ae 00 00 00    	jne    c01082ee <do_pgfault+0x1ff>
    		cprintf("pgdir_alloc_page(mm->pgdir, addr, perm) == NULL");
c0108240:	c7 04 24 d0 b9 10 c0 	movl   $0xc010b9d0,(%esp)
c0108247:	e8 07 81 ff ff       	call   c0100353 <cprintf>
    		goto failed;
c010824c:	e9 a4 00 00 00       	jmp    c01082f5 <do_pgfault+0x206>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {
c0108251:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0108256:	85 c0                	test   %eax,%eax
c0108258:	74 7d                	je     c01082d7 <do_pgfault+0x1e8>
        	// 将磁盘中的页换入到内存
            struct Page *page=NULL;
c010825a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            ret = swap_in(mm, addr, &page);                        //(1）According to the mm AND addr, try to load the content of right disk page
c0108261:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0108264:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108268:	8b 45 10             	mov    0x10(%ebp),%eax
c010826b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010826f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108272:	89 04 24             	mov    %eax,(%esp)
c0108275:	e8 32 e6 ff ff       	call   c01068ac <swap_in>
c010827a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c010827d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108281:	74 0e                	je     c0108291 <do_pgfault+0x1a2>
            	cprintf("swap_in in do_pgfault failed\n");
c0108283:	c7 04 24 00 ba 10 c0 	movl   $0xc010ba00,(%esp)
c010828a:	e8 c4 80 ff ff       	call   c0100353 <cprintf>
c010828f:	eb 64                	jmp    c01082f5 <do_pgfault+0x206>
            	goto failed;
            }
            // 建立虚拟地址和物理地址之间的对应关系                         						 //    into the memory which page managed.
            page_insert(mm->pgdir, page, addr, perm);              //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
c0108291:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108294:	8b 45 08             	mov    0x8(%ebp),%eax
c0108297:	8b 40 0c             	mov    0xc(%eax),%eax
c010829a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010829d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01082a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
c01082a4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01082a8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01082ac:	89 04 24             	mov    %eax,(%esp)
c01082af:	e8 52 d4 ff ff       	call   c0105706 <page_insert>
            // 最后的swap_in等于1使页面可替换
            swap_map_swappable(mm, addr, page, 1);     //(3) make the page swappable.
c01082b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082b7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c01082be:	00 
c01082bf:	89 44 24 08          	mov    %eax,0x8(%esp)
c01082c3:	8b 45 10             	mov    0x10(%ebp),%eax
c01082c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01082cd:	89 04 24             	mov    %eax,(%esp)
c01082d0:	e8 0e e4 ff ff       	call   c01066e3 <swap_map_swappable>
c01082d5:	eb 17                	jmp    c01082ee <do_pgfault+0x1ff>
            //page->pra_vaddr = addr;
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c01082d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082da:	8b 00                	mov    (%eax),%eax
c01082dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082e0:	c7 04 24 20 ba 10 c0 	movl   $0xc010ba20,(%esp)
c01082e7:	e8 67 80 ff ff       	call   c0100353 <cprintf>
            goto failed;
c01082ec:	eb 07                	jmp    c01082f5 <do_pgfault+0x206>
        }
   }

   ret = 0;
c01082ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c01082f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01082f8:	c9                   	leave  
c01082f9:	c3                   	ret    

c01082fa <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01082fa:	55                   	push   %ebp
c01082fb:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01082fd:	8b 55 08             	mov    0x8(%ebp),%edx
c0108300:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0108305:	29 c2                	sub    %eax,%edx
c0108307:	89 d0                	mov    %edx,%eax
c0108309:	c1 f8 05             	sar    $0x5,%eax
}
c010830c:	5d                   	pop    %ebp
c010830d:	c3                   	ret    

c010830e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010830e:	55                   	push   %ebp
c010830f:	89 e5                	mov    %esp,%ebp
c0108311:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108314:	8b 45 08             	mov    0x8(%ebp),%eax
c0108317:	89 04 24             	mov    %eax,(%esp)
c010831a:	e8 db ff ff ff       	call   c01082fa <page2ppn>
c010831f:	c1 e0 0c             	shl    $0xc,%eax
}
c0108322:	c9                   	leave  
c0108323:	c3                   	ret    

c0108324 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0108324:	55                   	push   %ebp
c0108325:	89 e5                	mov    %esp,%ebp
c0108327:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010832a:	8b 45 08             	mov    0x8(%ebp),%eax
c010832d:	89 04 24             	mov    %eax,(%esp)
c0108330:	e8 d9 ff ff ff       	call   c010830e <page2pa>
c0108335:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108338:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010833b:	c1 e8 0c             	shr    $0xc,%eax
c010833e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108341:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0108346:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108349:	72 23                	jb     c010836e <page2kva+0x4a>
c010834b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010834e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108352:	c7 44 24 08 48 ba 10 	movl   $0xc010ba48,0x8(%esp)
c0108359:	c0 
c010835a:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0108361:	00 
c0108362:	c7 04 24 6b ba 10 c0 	movl   $0xc010ba6b,(%esp)
c0108369:	e8 6f 89 ff ff       	call   c0100cdd <__panic>
c010836e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108371:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108376:	c9                   	leave  
c0108377:	c3                   	ret    

c0108378 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108378:	55                   	push   %ebp
c0108379:	89 e5                	mov    %esp,%ebp
c010837b:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c010837e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108385:	e8 a3 96 ff ff       	call   c0101a2d <ide_device_valid>
c010838a:	85 c0                	test   %eax,%eax
c010838c:	75 1c                	jne    c01083aa <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c010838e:	c7 44 24 08 79 ba 10 	movl   $0xc010ba79,0x8(%esp)
c0108395:	c0 
c0108396:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c010839d:	00 
c010839e:	c7 04 24 93 ba 10 c0 	movl   $0xc010ba93,(%esp)
c01083a5:	e8 33 89 ff ff       	call   c0100cdd <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c01083aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01083b1:	e8 b6 96 ff ff       	call   c0101a6c <ide_device_size>
c01083b6:	c1 e8 03             	shr    $0x3,%eax
c01083b9:	a3 dc 7b 12 c0       	mov    %eax,0xc0127bdc
}
c01083be:	c9                   	leave  
c01083bf:	c3                   	ret    

c01083c0 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c01083c0:	55                   	push   %ebp
c01083c1:	89 e5                	mov    %esp,%ebp
c01083c3:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01083c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083c9:	89 04 24             	mov    %eax,(%esp)
c01083cc:	e8 53 ff ff ff       	call   c0108324 <page2kva>
c01083d1:	8b 55 08             	mov    0x8(%ebp),%edx
c01083d4:	c1 ea 08             	shr    $0x8,%edx
c01083d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01083da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01083de:	74 0b                	je     c01083eb <swapfs_read+0x2b>
c01083e0:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c01083e6:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01083e9:	72 23                	jb     c010840e <swapfs_read+0x4e>
c01083eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01083ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01083f2:	c7 44 24 08 a4 ba 10 	movl   $0xc010baa4,0x8(%esp)
c01083f9:	c0 
c01083fa:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108401:	00 
c0108402:	c7 04 24 93 ba 10 c0 	movl   $0xc010ba93,(%esp)
c0108409:	e8 cf 88 ff ff       	call   c0100cdd <__panic>
c010840e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108411:	c1 e2 03             	shl    $0x3,%edx
c0108414:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010841b:	00 
c010841c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108420:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108424:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010842b:	e8 7b 96 ff ff       	call   c0101aab <ide_read_secs>
}
c0108430:	c9                   	leave  
c0108431:	c3                   	ret    

c0108432 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0108432:	55                   	push   %ebp
c0108433:	89 e5                	mov    %esp,%ebp
c0108435:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108438:	8b 45 0c             	mov    0xc(%ebp),%eax
c010843b:	89 04 24             	mov    %eax,(%esp)
c010843e:	e8 e1 fe ff ff       	call   c0108324 <page2kva>
c0108443:	8b 55 08             	mov    0x8(%ebp),%edx
c0108446:	c1 ea 08             	shr    $0x8,%edx
c0108449:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010844c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108450:	74 0b                	je     c010845d <swapfs_write+0x2b>
c0108452:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c0108458:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010845b:	72 23                	jb     c0108480 <swapfs_write+0x4e>
c010845d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108460:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108464:	c7 44 24 08 a4 ba 10 	movl   $0xc010baa4,0x8(%esp)
c010846b:	c0 
c010846c:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0108473:	00 
c0108474:	c7 04 24 93 ba 10 c0 	movl   $0xc010ba93,(%esp)
c010847b:	e8 5d 88 ff ff       	call   c0100cdd <__panic>
c0108480:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108483:	c1 e2 03             	shl    $0x3,%edx
c0108486:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010848d:	00 
c010848e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108492:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108496:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010849d:	e8 4b 98 ff ff       	call   c0101ced <ide_write_secs>
}
c01084a2:	c9                   	leave  
c01084a3:	c3                   	ret    

c01084a4 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c01084a4:	52                   	push   %edx
    call *%ebx              # call fn
c01084a5:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c01084a7:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c01084a8:	e8 02 08 00 00       	call   c0108caf <do_exit>

c01084ad <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01084ad:	55                   	push   %ebp
c01084ae:	89 e5                	mov    %esp,%ebp
c01084b0:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01084b3:	9c                   	pushf  
c01084b4:	58                   	pop    %eax
c01084b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01084b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01084bb:	25 00 02 00 00       	and    $0x200,%eax
c01084c0:	85 c0                	test   %eax,%eax
c01084c2:	74 0c                	je     c01084d0 <__intr_save+0x23>
        intr_disable();
c01084c4:	e8 6c 9a ff ff       	call   c0101f35 <intr_disable>
        return 1;
c01084c9:	b8 01 00 00 00       	mov    $0x1,%eax
c01084ce:	eb 05                	jmp    c01084d5 <__intr_save+0x28>
    }
    return 0;
c01084d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01084d5:	c9                   	leave  
c01084d6:	c3                   	ret    

c01084d7 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01084d7:	55                   	push   %ebp
c01084d8:	89 e5                	mov    %esp,%ebp
c01084da:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01084dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01084e1:	74 05                	je     c01084e8 <__intr_restore+0x11>
        intr_enable();
c01084e3:	e8 47 9a ff ff       	call   c0101f2f <intr_enable>
    }
}
c01084e8:	c9                   	leave  
c01084e9:	c3                   	ret    

c01084ea <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01084ea:	55                   	push   %ebp
c01084eb:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01084ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01084f0:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01084f5:	29 c2                	sub    %eax,%edx
c01084f7:	89 d0                	mov    %edx,%eax
c01084f9:	c1 f8 05             	sar    $0x5,%eax
}
c01084fc:	5d                   	pop    %ebp
c01084fd:	c3                   	ret    

c01084fe <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01084fe:	55                   	push   %ebp
c01084ff:	89 e5                	mov    %esp,%ebp
c0108501:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108504:	8b 45 08             	mov    0x8(%ebp),%eax
c0108507:	89 04 24             	mov    %eax,(%esp)
c010850a:	e8 db ff ff ff       	call   c01084ea <page2ppn>
c010850f:	c1 e0 0c             	shl    $0xc,%eax
}
c0108512:	c9                   	leave  
c0108513:	c3                   	ret    

c0108514 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0108514:	55                   	push   %ebp
c0108515:	89 e5                	mov    %esp,%ebp
c0108517:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010851a:	8b 45 08             	mov    0x8(%ebp),%eax
c010851d:	c1 e8 0c             	shr    $0xc,%eax
c0108520:	89 c2                	mov    %eax,%edx
c0108522:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0108527:	39 c2                	cmp    %eax,%edx
c0108529:	72 1c                	jb     c0108547 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010852b:	c7 44 24 08 c4 ba 10 	movl   $0xc010bac4,0x8(%esp)
c0108532:	c0 
c0108533:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c010853a:	00 
c010853b:	c7 04 24 e3 ba 10 c0 	movl   $0xc010bae3,(%esp)
c0108542:	e8 96 87 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c0108547:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c010854c:	8b 55 08             	mov    0x8(%ebp),%edx
c010854f:	c1 ea 0c             	shr    $0xc,%edx
c0108552:	c1 e2 05             	shl    $0x5,%edx
c0108555:	01 d0                	add    %edx,%eax
}
c0108557:	c9                   	leave  
c0108558:	c3                   	ret    

c0108559 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0108559:	55                   	push   %ebp
c010855a:	89 e5                	mov    %esp,%ebp
c010855c:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010855f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108562:	89 04 24             	mov    %eax,(%esp)
c0108565:	e8 94 ff ff ff       	call   c01084fe <page2pa>
c010856a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010856d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108570:	c1 e8 0c             	shr    $0xc,%eax
c0108573:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108576:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010857b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010857e:	72 23                	jb     c01085a3 <page2kva+0x4a>
c0108580:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108583:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108587:	c7 44 24 08 f4 ba 10 	movl   $0xc010baf4,0x8(%esp)
c010858e:	c0 
c010858f:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0108596:	00 
c0108597:	c7 04 24 e3 ba 10 c0 	movl   $0xc010bae3,(%esp)
c010859e:	e8 3a 87 ff ff       	call   c0100cdd <__panic>
c01085a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085a6:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01085ab:	c9                   	leave  
c01085ac:	c3                   	ret    

c01085ad <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01085ad:	55                   	push   %ebp
c01085ae:	89 e5                	mov    %esp,%ebp
c01085b0:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01085b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01085b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085b9:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01085c0:	77 23                	ja     c01085e5 <kva2page+0x38>
c01085c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01085c9:	c7 44 24 08 18 bb 10 	movl   $0xc010bb18,0x8(%esp)
c01085d0:	c0 
c01085d1:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c01085d8:	00 
c01085d9:	c7 04 24 e3 ba 10 c0 	movl   $0xc010bae3,(%esp)
c01085e0:	e8 f8 86 ff ff       	call   c0100cdd <__panic>
c01085e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085e8:	05 00 00 00 40       	add    $0x40000000,%eax
c01085ed:	89 04 24             	mov    %eax,(%esp)
c01085f0:	e8 1f ff ff ff       	call   c0108514 <pa2page>
}
c01085f5:	c9                   	leave  
c01085f6:	c3                   	ret    

c01085f7 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c01085f7:	55                   	push   %ebp
c01085f8:	89 e5                	mov    %esp,%ebp
c01085fa:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c01085fd:	c7 04 24 68 00 00 00 	movl   $0x68,(%esp)
c0108604:	e8 fc c2 ff ff       	call   c0104905 <kmalloc>
c0108609:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c010860c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108610:	0f 84 a1 00 00 00    	je     c01086b7 <alloc_proc+0xc0>

    	/*
    	 * 执行的是第一步初始化工作
    	 */

    	proc->state = PROC_UNINIT;							// 设置了进程的状态为“初始”态，这表示进程已经 “出生”了，正在获取资源茁壮成长中；
c0108616:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108619:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    	proc->pid = -1;										// 未分配的进程pid是-1 先设置pid为无效值-1，用户调完alloc_proc函数后再根据实际情况设置pid。
c010861f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108622:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
															// 设置了进程的pid为-1，这表示进程的“身份证号”还没有办好；

    	proc->cr3 = boot_cr3;								// boot_cr3指向了uCore启动时建立好的内核虚拟空间的页目录表首地址
c0108629:	8b 15 28 7b 12 c0    	mov    0xc0127b28,%edx
c010862f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108632:	89 50 40             	mov    %edx,0x40(%eax)
															// 表明由于该内核线程在内核中运行，故采用为uCore内核已经建立的页表，即设置为在uCore内核页表的起始地址boot_cr3。

    	proc->runs = 0;
c0108635:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108638:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		proc->kstack = 0;									// 记录了分配给该进程/线程的内核栈的位置
c010863f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108642:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		proc->need_resched = 0;								// 是否需要调度
c0108649:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010864c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
		proc->parent = NULL;								// 父进程
c0108653:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108656:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
		proc->mm = 0;									// 虚拟内存结构体（lab4实验可忽略）
c010865d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108660:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
		 * 该函数用于清空一个结构体中所有的成员变量，下面解释三个参数：
		 * 第一个参数：位置指针，例如数组名、结构体首地址
		 * 第二个参数：替换为什么
		 * memset 函数的第三个参数 n 的值一般用 sizeof() 获取
		 */
		memset(&(proc->context), 0, sizeof(struct context)); 	// 上下文结构体
c0108667:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010866a:	83 c0 1c             	add    $0x1c,%eax
c010866d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c0108674:	00 
c0108675:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010867c:	00 
c010867d:	89 04 24             	mov    %eax,(%esp)
c0108680:	e8 ac 14 00 00       	call   c0109b31 <memset>
		proc->tf = NULL;
c0108685:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108688:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)

		proc->flags = 0;
c010868f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108692:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
		// 清空数组就不用sizeof了，第三个参数直接写数组的大小-1即可
		memset(proc->name, 0, PROC_NAME_LEN);
c0108699:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010869c:	83 c0 48             	add    $0x48,%eax
c010869f:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01086a6:	00 
c01086a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01086ae:	00 
c01086af:	89 04 24             	mov    %eax,(%esp)
c01086b2:	e8 7a 14 00 00       	call   c0109b31 <memset>


    }
    return proc;
c01086b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01086ba:	c9                   	leave  
c01086bb:	c3                   	ret    

c01086bc <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c01086bc:	55                   	push   %ebp
c01086bd:	89 e5                	mov    %esp,%ebp
c01086bf:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c01086c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01086c5:	83 c0 48             	add    $0x48,%eax
c01086c8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01086cf:	00 
c01086d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01086d7:	00 
c01086d8:	89 04 24             	mov    %eax,(%esp)
c01086db:	e8 51 14 00 00       	call   c0109b31 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c01086e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01086e3:	8d 50 48             	lea    0x48(%eax),%edx
c01086e6:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01086ed:	00 
c01086ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086f5:	89 14 24             	mov    %edx,(%esp)
c01086f8:	e8 16 15 00 00       	call   c0109c13 <memcpy>
}
c01086fd:	c9                   	leave  
c01086fe:	c3                   	ret    

c01086ff <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c01086ff:	55                   	push   %ebp
c0108700:	89 e5                	mov    %esp,%ebp
c0108702:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c0108705:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c010870c:	00 
c010870d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108714:	00 
c0108715:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c010871c:	e8 10 14 00 00       	call   c0109b31 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c0108721:	8b 45 08             	mov    0x8(%ebp),%eax
c0108724:	83 c0 48             	add    $0x48,%eax
c0108727:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c010872e:	00 
c010872f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108733:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c010873a:	e8 d4 14 00 00       	call   c0109c13 <memcpy>
}
c010873f:	c9                   	leave  
c0108740:	c3                   	ret    

c0108741 <get_pid>:

// get_pid - alloc a unique pid for process
// get_pid函数确保了新进程说分配的pid是唯一的 LAB4实验中的问题需要解答该函数是如何实现的唯一分配
static int
get_pid(void) {
c0108741:	55                   	push   %ebp
c0108742:	89 e5                	mov    %esp,%ebp
c0108744:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c0108747:	c7 45 f8 10 7c 12 c0 	movl   $0xc0127c10,-0x8(%ebp)

    // 两个静态变量 next_safe = MAX_PID, last_pid = MAX_PID; 指向最大可以分配的pid号码
    static int next_safe = MAX_PID, last_pid = MAX_PID;

    if (++ last_pid >= MAX_PID) {
c010874e:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108753:	83 c0 01             	add    $0x1,%eax
c0108756:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c010875b:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108760:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108765:	7e 0c                	jle    c0108773 <get_pid+0x32>
        last_pid = 1;
c0108767:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c010876e:	00 00 00 
        goto inside;
c0108771:	eb 13                	jmp    c0108786 <get_pid+0x45>
    }

    if (last_pid >= next_safe) {
c0108773:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c0108779:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c010877e:	39 c2                	cmp    %eax,%edx
c0108780:	0f 8c ac 00 00 00    	jl     c0108832 <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c0108786:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c010878d:	20 00 00 
    repeat:
        le = list;
c0108790:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108793:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c0108796:	eb 7f                	jmp    c0108817 <get_pid+0xd6>
            proc = le2proc(le, list_link);
c0108798:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010879b:	83 e8 58             	sub    $0x58,%eax
c010879e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c01087a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087a4:	8b 50 04             	mov    0x4(%eax),%edx
c01087a7:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01087ac:	39 c2                	cmp    %eax,%edx
c01087ae:	75 3e                	jne    c01087ee <get_pid+0xad>
            	// 如果last_pid+1 后等于MAX_PID，意味着pid已经分配完了
                if (++ last_pid >= next_safe) {
c01087b0:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01087b5:	83 c0 01             	add    $0x1,%eax
c01087b8:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c01087bd:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c01087c3:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c01087c8:	39 c2                	cmp    %eax,%edx
c01087ca:	7c 4b                	jl     c0108817 <get_pid+0xd6>
                    // 如果last_pid超出最大pid范围，则last_pid重新从1开始编号
                	if (last_pid >= MAX_PID) {
c01087cc:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01087d1:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c01087d6:	7e 0a                	jle    c01087e2 <get_pid+0xa1>
                        last_pid = 1;
c01087d8:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c01087df:	00 00 00 
                    }
                    next_safe = MAX_PID;
c01087e2:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c01087e9:	20 00 00 
                    // 重新编号去 现在 last_pid == 1; next_safe == MAX_PID;
                    goto repeat;
c01087ec:	eb a2                	jmp    c0108790 <get_pid+0x4f>
                }
            }
            // 上面的是需要重新编号的情况，下面是不需要的情况
            // 满足 last_pid < proc->pid < next_safe
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c01087ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087f1:	8b 50 04             	mov    0x4(%eax),%edx
c01087f4:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01087f9:	39 c2                	cmp    %eax,%edx
c01087fb:	7e 1a                	jle    c0108817 <get_pid+0xd6>
c01087fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108800:	8b 50 04             	mov    0x4(%eax),%edx
c0108803:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c0108808:	39 c2                	cmp    %eax,%edx
c010880a:	7d 0b                	jge    c0108817 <get_pid+0xd6>
                // last_pid < proc->pid < next_safe
            	// last_pid < proc->pid
            	//			< next_safe
            	next_safe = proc->pid;
c010880c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010880f:	8b 40 04             	mov    0x4(%eax),%eax
c0108812:	a3 84 4a 12 c0       	mov    %eax,0xc0124a84
c0108817:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010881a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010881d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108820:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c0108823:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0108826:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108829:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010882c:	0f 85 66 ff ff ff    	jne    c0108798 <get_pid+0x57>
            	next_safe = proc->pid;
            }
        }
    }
    // last_pid作为新颁发的编号
    return last_pid;
c0108832:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
}
c0108837:	c9                   	leave  
c0108838:	c3                   	ret    

c0108839 <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c0108839:	55                   	push   %ebp
c010883a:	89 e5                	mov    %esp,%ebp
c010883c:	83 ec 28             	sub    $0x28,%esp
	// current是当前正在运行的线程
	// proc是将要运行的线程
	/* 先判断下将要运行的线程是不是已经在运行中了 */
    if (proc != current) {
c010883f:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108844:	39 45 08             	cmp    %eax,0x8(%ebp)
c0108847:	74 63                	je     c01088ac <proc_run+0x73>
        bool intr_flag;
        // prev是当前正在执行的线程
        // next是准备要执行的线程
        struct proc_struct *prev = current, *next = proc;
c0108849:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c010884e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108851:	8b 45 08             	mov    0x8(%ebp),%eax
c0108854:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // 禁止中断 目的是事务的隔离性 不让其冲突
        local_intr_save(intr_flag);
c0108857:	e8 51 fc ff ff       	call   c01084ad <__intr_save>
c010885c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c010885f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108862:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8
            load_esp0(next->kstack + KSTACKSIZE);
c0108867:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010886a:	8b 40 0c             	mov    0xc(%eax),%eax
c010886d:	05 00 20 00 00       	add    $0x2000,%eax
c0108872:	89 04 24             	mov    %eax,(%esp)
c0108875:	e8 9a c3 ff ff       	call   c0104c14 <load_esp0>
            // 将当前的cr3寄存器修改为需要运行的线程（线程）的页目录表
            lcr3(next->cr3);
c010887a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010887d:	8b 40 40             	mov    0x40(%eax),%eax
c0108880:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0108883:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108886:	0f 22 d8             	mov    %eax,%cr3
            // 开始执行（切换线程函数）
            switch_to(&(prev->context), &(next->context));
c0108889:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010888c:	8d 50 1c             	lea    0x1c(%eax),%edx
c010888f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108892:	83 c0 1c             	add    $0x1c,%eax
c0108895:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108899:	89 04 24             	mov    %eax,(%esp)
c010889c:	e8 60 06 00 00       	call   c0108f01 <switch_to>
        }
        local_intr_restore(intr_flag);
c01088a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01088a4:	89 04 24             	mov    %eax,(%esp)
c01088a7:	e8 2b fc ff ff       	call   c01084d7 <__intr_restore>
    }
}
c01088ac:	c9                   	leave  
c01088ad:	c3                   	ret    

c01088ae <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c01088ae:	55                   	push   %ebp
c01088af:	89 e5                	mov    %esp,%ebp
c01088b1:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c01088b4:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c01088b9:	8b 40 3c             	mov    0x3c(%eax),%eax
c01088bc:	89 04 24             	mov    %eax,(%esp)
c01088bf:	e8 e0 9e ff ff       	call   c01027a4 <forkrets>
}
c01088c4:	c9                   	leave  
c01088c5:	c3                   	ret    

c01088c6 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c01088c6:	55                   	push   %ebp
c01088c7:	89 e5                	mov    %esp,%ebp
c01088c9:	53                   	push   %ebx
c01088ca:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c01088cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01088d0:	8d 58 60             	lea    0x60(%eax),%ebx
c01088d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01088d6:	8b 40 04             	mov    0x4(%eax),%eax
c01088d9:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c01088e0:	00 
c01088e1:	89 04 24             	mov    %eax,(%esp)
c01088e4:	e8 9b 07 00 00       	call   c0109084 <hash32>
c01088e9:	c1 e0 03             	shl    $0x3,%eax
c01088ec:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c01088f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01088f4:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c01088f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01088fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108900:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108903:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108906:	8b 40 04             	mov    0x4(%eax),%eax
c0108909:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010890c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010890f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108912:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0108915:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108918:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010891b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010891e:	89 10                	mov    %edx,(%eax)
c0108920:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108923:	8b 10                	mov    (%eax),%edx
c0108925:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108928:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010892b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010892e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108931:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108937:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010893a:	89 10                	mov    %edx,(%eax)
}
c010893c:	83 c4 34             	add    $0x34,%esp
c010893f:	5b                   	pop    %ebx
c0108940:	5d                   	pop    %ebp
c0108941:	c3                   	ret    

c0108942 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0108942:	55                   	push   %ebp
c0108943:	89 e5                	mov    %esp,%ebp
c0108945:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c0108948:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010894c:	7e 5f                	jle    c01089ad <find_proc+0x6b>
c010894e:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0108955:	7f 56                	jg     c01089ad <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0108957:	8b 45 08             	mov    0x8(%ebp),%eax
c010895a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0108961:	00 
c0108962:	89 04 24             	mov    %eax,(%esp)
c0108965:	e8 1a 07 00 00       	call   c0109084 <hash32>
c010896a:	c1 e0 03             	shl    $0x3,%eax
c010896d:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c0108972:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108975:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108978:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c010897b:	eb 19                	jmp    c0108996 <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c010897d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108980:	83 e8 60             	sub    $0x60,%eax
c0108983:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0108986:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108989:	8b 40 04             	mov    0x4(%eax),%eax
c010898c:	3b 45 08             	cmp    0x8(%ebp),%eax
c010898f:	75 05                	jne    c0108996 <find_proc+0x54>
                return proc;
c0108991:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108994:	eb 1c                	jmp    c01089b2 <find_proc+0x70>
c0108996:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108999:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010899c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010899f:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c01089a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01089a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01089ab:	75 d0                	jne    c010897d <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c01089ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01089b2:	c9                   	leave  
c01089b3:	c3                   	ret    

c01089b4 <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c01089b4:	55                   	push   %ebp
c01089b5:	89 e5                	mov    %esp,%ebp
c01089b7:	83 ec 68             	sub    $0x68,%esp
    /*
     * 我们来分析一下创建内核线程的函数kernel_thread：
     */
	/* 采用了局部变量tf来放置保存内核线程的临时中断帧 */
	struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c01089ba:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c01089c1:	00 
c01089c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01089c9:	00 
c01089ca:	8d 45 ac             	lea    -0x54(%ebp),%eax
c01089cd:	89 04 24             	mov    %eax,(%esp)
c01089d0:	e8 5c 11 00 00       	call   c0109b31 <memset>
    tf.tf_cs = KERNEL_CS;
c01089d5:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c01089db:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c01089e1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01089e5:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c01089e9:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c01089ed:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c01089f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01089f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c01089f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089fa:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c01089fd:	b8 a4 84 10 c0       	mov    $0xc01084a4,%eax
c0108a02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    /* 把中断帧的指针传递给do_fork函数，do_fork函数会调用copy_thread函数在新创建的进程内核栈上专门给进程的中断帧分配一块空间。 */
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0108a05:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a08:	80 cc 01             	or     $0x1,%ah
c0108a0b:	89 c2                	mov    %eax,%edx
c0108a0d:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108a10:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108a14:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108a1b:	00 
c0108a1c:	89 14 24             	mov    %edx,(%esp)
c0108a1f:	e8 79 01 00 00       	call   c0108b9d <do_fork>
}
c0108a24:	c9                   	leave  
c0108a25:	c3                   	ret    

c0108a26 <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0108a26:	55                   	push   %ebp
c0108a27:	89 e5                	mov    %esp,%ebp
c0108a29:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0108a2c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0108a33:	e8 2a c3 ff ff       	call   c0104d62 <alloc_pages>
c0108a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0108a3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108a3f:	74 1a                	je     c0108a5b <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c0108a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a44:	89 04 24             	mov    %eax,(%esp)
c0108a47:	e8 0d fb ff ff       	call   c0108559 <page2kva>
c0108a4c:	89 c2                	mov    %eax,%edx
c0108a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a51:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0108a54:	b8 00 00 00 00       	mov    $0x0,%eax
c0108a59:	eb 05                	jmp    c0108a60 <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0108a5b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0108a60:	c9                   	leave  
c0108a61:	c3                   	ret    

c0108a62 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0108a62:	55                   	push   %ebp
c0108a63:	89 e5                	mov    %esp,%ebp
c0108a65:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108a68:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a6b:	8b 40 0c             	mov    0xc(%eax),%eax
c0108a6e:	89 04 24             	mov    %eax,(%esp)
c0108a71:	e8 37 fb ff ff       	call   c01085ad <kva2page>
c0108a76:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0108a7d:	00 
c0108a7e:	89 04 24             	mov    %eax,(%esp)
c0108a81:	e8 47 c3 ff ff       	call   c0104dcd <free_pages>
}
c0108a86:	c9                   	leave  
c0108a87:	c3                   	ret    

c0108a88 <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108a88:	55                   	push   %ebp
c0108a89:	89 e5                	mov    %esp,%ebp
c0108a8b:	83 ec 18             	sub    $0x18,%esp
    assert(current->mm == NULL);
c0108a8e:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108a93:	8b 40 18             	mov    0x18(%eax),%eax
c0108a96:	85 c0                	test   %eax,%eax
c0108a98:	74 24                	je     c0108abe <copy_mm+0x36>
c0108a9a:	c7 44 24 0c 3c bb 10 	movl   $0xc010bb3c,0xc(%esp)
c0108aa1:	c0 
c0108aa2:	c7 44 24 08 50 bb 10 	movl   $0xc010bb50,0x8(%esp)
c0108aa9:	c0 
c0108aaa:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0108ab1:	00 
c0108ab2:	c7 04 24 65 bb 10 c0 	movl   $0xc010bb65,(%esp)
c0108ab9:	e8 1f 82 ff ff       	call   c0100cdd <__panic>
    /* do nothing in this project */
    return 0;
c0108abe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108ac3:	c9                   	leave  
c0108ac4:	c3                   	ret    

c0108ac5 <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108ac5:	55                   	push   %ebp
c0108ac6:	89 e5                	mov    %esp,%ebp
c0108ac8:	57                   	push   %edi
c0108ac9:	56                   	push   %esi
c0108aca:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0108acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ace:	8b 40 0c             	mov    0xc(%eax),%eax
c0108ad1:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108ad6:	89 c2                	mov    %eax,%edx
c0108ad8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108adb:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108ade:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ae1:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108ae4:	8b 55 10             	mov    0x10(%ebp),%edx
c0108ae7:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0108aec:	89 c1                	mov    %eax,%ecx
c0108aee:	83 e1 01             	and    $0x1,%ecx
c0108af1:	85 c9                	test   %ecx,%ecx
c0108af3:	74 0e                	je     c0108b03 <copy_thread+0x3e>
c0108af5:	0f b6 0a             	movzbl (%edx),%ecx
c0108af8:	88 08                	mov    %cl,(%eax)
c0108afa:	83 c0 01             	add    $0x1,%eax
c0108afd:	83 c2 01             	add    $0x1,%edx
c0108b00:	83 eb 01             	sub    $0x1,%ebx
c0108b03:	89 c1                	mov    %eax,%ecx
c0108b05:	83 e1 02             	and    $0x2,%ecx
c0108b08:	85 c9                	test   %ecx,%ecx
c0108b0a:	74 0f                	je     c0108b1b <copy_thread+0x56>
c0108b0c:	0f b7 0a             	movzwl (%edx),%ecx
c0108b0f:	66 89 08             	mov    %cx,(%eax)
c0108b12:	83 c0 02             	add    $0x2,%eax
c0108b15:	83 c2 02             	add    $0x2,%edx
c0108b18:	83 eb 02             	sub    $0x2,%ebx
c0108b1b:	89 d9                	mov    %ebx,%ecx
c0108b1d:	c1 e9 02             	shr    $0x2,%ecx
c0108b20:	89 c7                	mov    %eax,%edi
c0108b22:	89 d6                	mov    %edx,%esi
c0108b24:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108b26:	89 f2                	mov    %esi,%edx
c0108b28:	89 f8                	mov    %edi,%eax
c0108b2a:	b9 00 00 00 00       	mov    $0x0,%ecx
c0108b2f:	89 de                	mov    %ebx,%esi
c0108b31:	83 e6 02             	and    $0x2,%esi
c0108b34:	85 f6                	test   %esi,%esi
c0108b36:	74 0b                	je     c0108b43 <copy_thread+0x7e>
c0108b38:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0108b3c:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0108b40:	83 c1 02             	add    $0x2,%ecx
c0108b43:	83 e3 01             	and    $0x1,%ebx
c0108b46:	85 db                	test   %ebx,%ebx
c0108b48:	74 07                	je     c0108b51 <copy_thread+0x8c>
c0108b4a:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0108b4e:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0108b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b54:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b57:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b61:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b64:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108b67:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b6d:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b70:	8b 55 08             	mov    0x8(%ebp),%edx
c0108b73:	8b 52 3c             	mov    0x3c(%edx),%edx
c0108b76:	8b 52 40             	mov    0x40(%edx),%edx
c0108b79:	80 ce 02             	or     $0x2,%dh
c0108b7c:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0108b7f:	ba ae 88 10 c0       	mov    $0xc01088ae,%edx
c0108b84:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b87:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0108b8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b8d:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b90:	89 c2                	mov    %eax,%edx
c0108b92:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b95:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108b98:	5b                   	pop    %ebx
c0108b99:	5e                   	pop    %esi
c0108b9a:	5f                   	pop    %edi
c0108b9b:	5d                   	pop    %ebp
c0108b9c:	c3                   	ret    

c0108b9d <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108b9d:	55                   	push   %ebp
c0108b9e:	89 e5                	mov    %esp,%ebp
c0108ba0:	83 ec 48             	sub    $0x48,%esp
    int ret = -E_NO_FREE_PROC;
c0108ba3:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108baa:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108baf:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108bb4:	7e 05                	jle    c0108bbb <do_fork+0x1e>
        goto fork_out;
c0108bb6:	e9 ef 00 00 00       	jmp    c0108caa <do_fork+0x10d>
    }
    ret = -E_NO_MEM;
c0108bbb:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    /*
	 * 想干的事：创建当前内核线程的一个副本，它们的执行上下文、代码、数据都一样，但是存储位置不同，PID不同。
	 */
	// 调用alloc_proc() 为要创建的线程分配空间
	// 如果第一步 alloc 都失败的话，应该来说是比较严重的错误。直接退出。
	if ((proc = alloc_proc()) == NULL) {
c0108bc2:	e8 30 fa ff ff       	call   c01085f7 <alloc_proc>
c0108bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108bce:	75 05                	jne    c0108bd5 <do_fork+0x38>
		goto fork_out;
c0108bd0:	e9 d5 00 00 00       	jmp    c0108caa <do_fork+0x10d>
	}
	// 获取被拷贝的进程的pid号 即父进程的pid
	//proc->parent = current;
	// 分配大小为 KSTACKPAGE 的页面作为进程内核堆栈
	setup_kstack(proc);
c0108bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bd8:	89 04 24             	mov    %eax,(%esp)
c0108bdb:	e8 46 fe ff ff       	call   c0108a26 <setup_kstack>
	// 拷贝原进程的内存管理信息到新进程
	copy_mm(clone_flags, proc);
c0108be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108be3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108be7:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bea:	89 04 24             	mov    %eax,(%esp)
c0108bed:	e8 96 fe ff ff       	call   c0108a88 <copy_mm>
	// 拷贝原进程上下文到新进程
	copy_thread(proc, stack, tf);
c0108bf2:	8b 45 10             	mov    0x10(%ebp),%eax
c0108bf5:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c03:	89 04 24             	mov    %eax,(%esp)
c0108c06:	e8 ba fe ff ff       	call   c0108ac5 <copy_thread>


	bool intr_flag;
	// 停止中断
	local_intr_save(intr_flag);
c0108c0b:	e8 9d f8 ff ff       	call   c01084ad <__intr_save>
c0108c10:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// {} 用来限定花括号中变量的作用域，使其不影响外面。
	{
		proc->pid = get_pid();
c0108c13:	e8 29 fb ff ff       	call   c0108741 <get_pid>
c0108c18:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108c1b:	89 42 04             	mov    %eax,0x4(%edx)
		// 新进程添加到 hash方式组织的的进程链表，以便于以后对某个指定的线程的查找（速度更快）
		hash_proc(proc);
c0108c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c21:	89 04 24             	mov    %eax,(%esp)
c0108c24:	e8 9d fc ff ff       	call   c01088c6 <hash_proc>
		// 将线程加入到所有线程的链表中，以便于调度
		list_add(&proc_list, &(proc->list_link));
c0108c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c2c:	83 c0 58             	add    $0x58,%eax
c0108c2f:	c7 45 e8 10 7c 12 c0 	movl   $0xc0127c10,-0x18(%ebp)
c0108c36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108c39:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c42:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108c45:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108c48:	8b 40 04             	mov    0x4(%eax),%eax
c0108c4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c4e:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0108c51:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108c54:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108c57:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108c5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108c5d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108c60:	89 10                	mov    %edx,(%eax)
c0108c62:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108c65:	8b 10                	mov    (%eax),%edx
c0108c67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108c6a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108c6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108c70:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108c73:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108c76:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108c79:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108c7c:	89 10                	mov    %edx,(%eax)
		// 将全局线程的数目加1
		nr_process ++;
c0108c7e:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108c83:	83 c0 01             	add    $0x1,%eax
c0108c86:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00
	}
	// 允许中断
	local_intr_restore(intr_flag);
c0108c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c8e:	89 04 24             	mov    %eax,(%esp)
c0108c91:	e8 41 f8 ff ff       	call   c01084d7 <__intr_restore>


	// 唤醒新进程
	wakeup_proc(proc);
c0108c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c99:	89 04 24             	mov    %eax,(%esp)
c0108c9c:	e8 d4 02 00 00       	call   c0108f75 <wakeup_proc>
	// 新进程号
	ret = proc->pid;
c0108ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ca4:	8b 40 04             	mov    0x4(%eax),%eax
c0108ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)

fork_out:
    return ret;
c0108caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
c0108cad:	c9                   	leave  
c0108cae:	c3                   	ret    

c0108caf <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0108caf:	55                   	push   %ebp
c0108cb0:	89 e5                	mov    %esp,%ebp
c0108cb2:	83 ec 18             	sub    $0x18,%esp
    panic("process exit!!.\n");
c0108cb5:	c7 44 24 08 79 bb 10 	movl   $0xc010bb79,0x8(%esp)
c0108cbc:	c0 
c0108cbd:	c7 44 24 04 a2 01 00 	movl   $0x1a2,0x4(%esp)
c0108cc4:	00 
c0108cc5:	c7 04 24 65 bb 10 c0 	movl   $0xc010bb65,(%esp)
c0108ccc:	e8 0c 80 ff ff       	call   c0100cdd <__panic>

c0108cd1 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c0108cd1:	55                   	push   %ebp
c0108cd2:	89 e5                	mov    %esp,%ebp
c0108cd4:	83 ec 18             	sub    $0x18,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0108cd7:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108cdc:	89 04 24             	mov    %eax,(%esp)
c0108cdf:	e8 1b fa ff ff       	call   c01086ff <get_proc_name>
c0108ce4:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108cea:	8b 52 04             	mov    0x4(%edx),%edx
c0108ced:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108cf1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108cf5:	c7 04 24 8c bb 10 c0 	movl   $0xc010bb8c,(%esp)
c0108cfc:	e8 52 76 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
c0108d01:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d08:	c7 04 24 b2 bb 10 c0 	movl   $0xc010bbb2,(%esp)
c0108d0f:	e8 3f 76 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c0108d14:	c7 04 24 bf bb 10 c0 	movl   $0xc010bbbf,(%esp)
c0108d1b:	e8 33 76 ff ff       	call   c0100353 <cprintf>
    return 0;
c0108d20:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108d25:	c9                   	leave  
c0108d26:	c3                   	ret    

c0108d27 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c0108d27:	55                   	push   %ebp
c0108d28:	89 e5                	mov    %esp,%ebp
c0108d2a:	83 ec 28             	sub    $0x28,%esp
c0108d2d:	c7 45 ec 10 7c 12 c0 	movl   $0xc0127c10,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0108d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d37:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108d3a:	89 50 04             	mov    %edx,0x4(%eax)
c0108d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d40:	8b 50 04             	mov    0x4(%eax),%edx
c0108d43:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d46:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108d48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108d4f:	eb 26                	jmp    c0108d77 <proc_init+0x50>
        list_init(hash_list + i);
c0108d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d54:	c1 e0 03             	shl    $0x3,%eax
c0108d57:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c0108d5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108d5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d62:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108d65:	89 50 04             	mov    %edx,0x4(%eax)
c0108d68:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d6b:	8b 50 04             	mov    0x4(%eax),%edx
c0108d6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d71:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108d73:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108d77:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0108d7e:	7e d1                	jle    c0108d51 <proc_init+0x2a>
    /*
     * 第0个内核线程 -- idleproc
     * 把proc进行初步初始化（即把proc_struct中的各个成员变量清零）。但有些成员变量设置了特殊的值（这里是第一步初始化，后面还需要进一步初始化）
     * 第一步初始化可参考alloc_proc函数
     */
    if ((idleproc = alloc_proc()) == NULL) {
c0108d80:	e8 72 f8 ff ff       	call   c01085f7 <alloc_proc>
c0108d85:	a3 e0 5a 12 c0       	mov    %eax,0xc0125ae0
c0108d8a:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108d8f:	85 c0                	test   %eax,%eax
c0108d91:	75 1c                	jne    c0108daf <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c0108d93:	c7 44 24 08 db bb 10 	movl   $0xc010bbdb,0x8(%esp)
c0108d9a:	c0 
c0108d9b:	c7 44 24 04 bf 01 00 	movl   $0x1bf,0x4(%esp)
c0108da2:	00 
c0108da3:	c7 04 24 65 bb 10 c0 	movl   $0xc010bb65,(%esp)
c0108daa:	e8 2e 7f ff ff       	call   c0100cdd <__panic>
    }

    // 进行进一步初始化
    idleproc->pid = 0;								// 给了idleproc合法的身份证号--0
c0108daf:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108db4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;				// 第二条语句改变了idleproc的状态，使得它从“出生”转到了“准备工作”，就差uCore调度它执行了。
c0108dbb:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108dc0:	c7 00 02 00 00 00    	movl   $0x2,(%eax)

    idleproc->kstack = (uintptr_t)bootstack;		// 第三条语句设置了idleproc所使用的内核栈的起始地址。
c0108dc6:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108dcb:	ba 00 20 12 c0       	mov    $0xc0122000,%edx
c0108dd0:	89 50 0c             	mov    %edx,0xc(%eax)
    												// 需要注意以后的其他线程的内核栈都需要通过分配获得，因为uCore启动时设置的内核栈直接分配给idleproc使用了。
    idleproc->need_resched = 1;						// 设置为1表示允许CPU对其调度（调走），执行完这个进程后，该干嘛干嘛。Ucore不希望它一直霸占CPU
c0108dd3:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108dd8:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c0108ddf:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108de4:	c7 44 24 04 f3 bb 10 	movl   $0xc010bbf3,0x4(%esp)
c0108deb:	c0 
c0108dec:	89 04 24             	mov    %eax,(%esp)
c0108def:	e8 c8 f8 ff ff       	call   c01086bc <set_proc_name>
    nr_process ++;
c0108df4:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108df9:	83 c0 01             	add    $0x1,%eax
c0108dfc:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00

    current = idleproc;
c0108e01:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e06:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8
    /*
     * kernel_thread函数创建了第1个内核线程init_main
     * 在实验四中，这个子内核线程的工作就是输出一些字符串，然后就返回了（参看init_main函数）。
     * 但在后续的实验中，init_main的工作就是创建特定的其他内核线程或用户进程（实验五涉及）。
     */
    int pid = kernel_thread(init_main, "Hello world!!", 0);
c0108e0b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0108e12:	00 
c0108e13:	c7 44 24 04 f8 bb 10 	movl   $0xc010bbf8,0x4(%esp)
c0108e1a:	c0 
c0108e1b:	c7 04 24 d1 8c 10 c0 	movl   $0xc0108cd1,(%esp)
c0108e22:	e8 8d fb ff ff       	call   c01089b4 <kernel_thread>
c0108e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c0108e2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108e2e:	7f 1c                	jg     c0108e4c <proc_init+0x125>
        panic("create init_main failed.\n");
c0108e30:	c7 44 24 08 06 bc 10 	movl   $0xc010bc06,0x8(%esp)
c0108e37:	c0 
c0108e38:	c7 44 24 04 d5 01 00 	movl   $0x1d5,0x4(%esp)
c0108e3f:	00 
c0108e40:	c7 04 24 65 bb 10 c0 	movl   $0xc010bb65,(%esp)
c0108e47:	e8 91 7e ff ff       	call   c0100cdd <__panic>
    }

    initproc = find_proc(pid);
c0108e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108e4f:	89 04 24             	mov    %eax,(%esp)
c0108e52:	e8 eb fa ff ff       	call   c0108942 <find_proc>
c0108e57:	a3 e4 5a 12 c0       	mov    %eax,0xc0125ae4
    set_proc_name(initproc, "init");
c0108e5c:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108e61:	c7 44 24 04 20 bc 10 	movl   $0xc010bc20,0x4(%esp)
c0108e68:	c0 
c0108e69:	89 04 24             	mov    %eax,(%esp)
c0108e6c:	e8 4b f8 ff ff       	call   c01086bc <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c0108e71:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e76:	85 c0                	test   %eax,%eax
c0108e78:	74 0c                	je     c0108e86 <proc_init+0x15f>
c0108e7a:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e7f:	8b 40 04             	mov    0x4(%eax),%eax
c0108e82:	85 c0                	test   %eax,%eax
c0108e84:	74 24                	je     c0108eaa <proc_init+0x183>
c0108e86:	c7 44 24 0c 28 bc 10 	movl   $0xc010bc28,0xc(%esp)
c0108e8d:	c0 
c0108e8e:	c7 44 24 08 50 bb 10 	movl   $0xc010bb50,0x8(%esp)
c0108e95:	c0 
c0108e96:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c0108e9d:	00 
c0108e9e:	c7 04 24 65 bb 10 c0 	movl   $0xc010bb65,(%esp)
c0108ea5:	e8 33 7e ff ff       	call   c0100cdd <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c0108eaa:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108eaf:	85 c0                	test   %eax,%eax
c0108eb1:	74 0d                	je     c0108ec0 <proc_init+0x199>
c0108eb3:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108eb8:	8b 40 04             	mov    0x4(%eax),%eax
c0108ebb:	83 f8 01             	cmp    $0x1,%eax
c0108ebe:	74 24                	je     c0108ee4 <proc_init+0x1bd>
c0108ec0:	c7 44 24 0c 50 bc 10 	movl   $0xc010bc50,0xc(%esp)
c0108ec7:	c0 
c0108ec8:	c7 44 24 08 50 bb 10 	movl   $0xc010bb50,0x8(%esp)
c0108ecf:	c0 
c0108ed0:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
c0108ed7:	00 
c0108ed8:	c7 04 24 65 bb 10 c0 	movl   $0xc010bb65,(%esp)
c0108edf:	e8 f9 7d ff ff       	call   c0100cdd <__panic>
}
c0108ee4:	c9                   	leave  
c0108ee5:	c3                   	ret    

c0108ee6 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c0108ee6:	55                   	push   %ebp
c0108ee7:	89 e5                	mov    %esp,%ebp
c0108ee9:	83 ec 08             	sub    $0x8,%esp
    while (1) {
    	// 只要current标志为need_resched（即：1），马上就调用schedule函数要求调度器切换其他进程执行。
        if (current->need_resched) {
c0108eec:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108ef1:	8b 40 10             	mov    0x10(%eax),%eax
c0108ef4:	85 c0                	test   %eax,%eax
c0108ef6:	74 07                	je     c0108eff <cpu_idle+0x19>
            schedule();
c0108ef8:	e8 c1 00 00 00       	call   c0108fbe <schedule>
            // 第0个内核线程主要工作是完成内核中各个子系统的初始化，然后就通过执行cpu_idle函数开始过退休生活了。所以uCore接下来还需创建其他进程来完成各种工作
        }
    }
c0108efd:	eb ed                	jmp    c0108eec <cpu_idle+0x6>
c0108eff:	eb eb                	jmp    c0108eec <cpu_idle+0x6>

c0108f01 <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c0108f01:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c0108f05:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c0108f07:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c0108f0a:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c0108f0d:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c0108f10:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c0108f13:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c0108f16:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c0108f19:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c0108f1c:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c0108f20:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c0108f23:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c0108f26:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c0108f29:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c0108f2c:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c0108f2f:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c0108f32:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c0108f35:	ff 30                	pushl  (%eax)

    ret
c0108f37:	c3                   	ret    

c0108f38 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0108f38:	55                   	push   %ebp
c0108f39:	89 e5                	mov    %esp,%ebp
c0108f3b:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0108f3e:	9c                   	pushf  
c0108f3f:	58                   	pop    %eax
c0108f40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0108f46:	25 00 02 00 00       	and    $0x200,%eax
c0108f4b:	85 c0                	test   %eax,%eax
c0108f4d:	74 0c                	je     c0108f5b <__intr_save+0x23>
        intr_disable();
c0108f4f:	e8 e1 8f ff ff       	call   c0101f35 <intr_disable>
        return 1;
c0108f54:	b8 01 00 00 00       	mov    $0x1,%eax
c0108f59:	eb 05                	jmp    c0108f60 <__intr_save+0x28>
    }
    return 0;
c0108f5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108f60:	c9                   	leave  
c0108f61:	c3                   	ret    

c0108f62 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0108f62:	55                   	push   %ebp
c0108f63:	89 e5                	mov    %esp,%ebp
c0108f65:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0108f68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108f6c:	74 05                	je     c0108f73 <__intr_restore+0x11>
        intr_enable();
c0108f6e:	e8 bc 8f ff ff       	call   c0101f2f <intr_enable>
    }
}
c0108f73:	c9                   	leave  
c0108f74:	c3                   	ret    

c0108f75 <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c0108f75:	55                   	push   %ebp
c0108f76:	89 e5                	mov    %esp,%ebp
c0108f78:	83 ec 18             	sub    $0x18,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c0108f7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f7e:	8b 00                	mov    (%eax),%eax
c0108f80:	83 f8 03             	cmp    $0x3,%eax
c0108f83:	74 0a                	je     c0108f8f <wakeup_proc+0x1a>
c0108f85:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f88:	8b 00                	mov    (%eax),%eax
c0108f8a:	83 f8 02             	cmp    $0x2,%eax
c0108f8d:	75 24                	jne    c0108fb3 <wakeup_proc+0x3e>
c0108f8f:	c7 44 24 0c 78 bc 10 	movl   $0xc010bc78,0xc(%esp)
c0108f96:	c0 
c0108f97:	c7 44 24 08 b3 bc 10 	movl   $0xc010bcb3,0x8(%esp)
c0108f9e:	c0 
c0108f9f:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c0108fa6:	00 
c0108fa7:	c7 04 24 c8 bc 10 c0 	movl   $0xc010bcc8,(%esp)
c0108fae:	e8 2a 7d ff ff       	call   c0100cdd <__panic>
    proc->state = PROC_RUNNABLE;
c0108fb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fb6:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c0108fbc:	c9                   	leave  
c0108fbd:	c3                   	ret    

c0108fbe <schedule>:
/*
 * schedule函数要求调度器切换其他进程执行。
 * 本函数是调度算法实现代码
 */
void
schedule(void) {
c0108fbe:	55                   	push   %ebp
c0108fbf:	89 e5                	mov    %esp,%ebp
c0108fc1:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c0108fc4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c0108fcb:	e8 68 ff ff ff       	call   c0108f38 <__intr_save>
c0108fd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c0108fd3:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108fd8:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c0108fdf:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108fe5:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108fea:	39 c2                	cmp    %eax,%edx
c0108fec:	74 0a                	je     c0108ff8 <schedule+0x3a>
c0108fee:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108ff3:	83 c0 58             	add    $0x58,%eax
c0108ff6:	eb 05                	jmp    c0108ffd <schedule+0x3f>
c0108ff8:	b8 10 7c 12 c0       	mov    $0xc0127c10,%eax
c0108ffd:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c0109000:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109003:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109006:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010900c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010900f:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c0109012:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109015:	81 7d f4 10 7c 12 c0 	cmpl   $0xc0127c10,-0xc(%ebp)
c010901c:	74 15                	je     c0109033 <schedule+0x75>
                next = le2proc(le, list_link);
c010901e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109021:	83 e8 58             	sub    $0x58,%eax
c0109024:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c0109027:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010902a:	8b 00                	mov    (%eax),%eax
c010902c:	83 f8 02             	cmp    $0x2,%eax
c010902f:	75 02                	jne    c0109033 <schedule+0x75>
                    break;
c0109031:	eb 08                	jmp    c010903b <schedule+0x7d>
                }
            }
        } while (le != last);
c0109033:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109036:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0109039:	75 cb                	jne    c0109006 <schedule+0x48>
        if (next == NULL || next->state != PROC_RUNNABLE) {
c010903b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010903f:	74 0a                	je     c010904b <schedule+0x8d>
c0109041:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109044:	8b 00                	mov    (%eax),%eax
c0109046:	83 f8 02             	cmp    $0x2,%eax
c0109049:	74 08                	je     c0109053 <schedule+0x95>
            next = idleproc;
c010904b:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0109050:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c0109053:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109056:	8b 40 08             	mov    0x8(%eax),%eax
c0109059:	8d 50 01             	lea    0x1(%eax),%edx
c010905c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010905f:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c0109062:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0109067:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010906a:	74 0b                	je     c0109077 <schedule+0xb9>
        	// 交给CPU去执行
            proc_run(next);
c010906c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010906f:	89 04 24             	mov    %eax,(%esp)
c0109072:	e8 c2 f7 ff ff       	call   c0108839 <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c0109077:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010907a:	89 04 24             	mov    %eax,(%esp)
c010907d:	e8 e0 fe ff ff       	call   c0108f62 <__intr_restore>
}
c0109082:	c9                   	leave  
c0109083:	c3                   	ret    

c0109084 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c0109084:	55                   	push   %ebp
c0109085:	89 e5                	mov    %esp,%ebp
c0109087:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c010908a:	8b 45 08             	mov    0x8(%ebp),%eax
c010908d:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c0109093:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c0109096:	b8 20 00 00 00       	mov    $0x20,%eax
c010909b:	2b 45 0c             	sub    0xc(%ebp),%eax
c010909e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01090a1:	89 c1                	mov    %eax,%ecx
c01090a3:	d3 ea                	shr    %cl,%edx
c01090a5:	89 d0                	mov    %edx,%eax
}
c01090a7:	c9                   	leave  
c01090a8:	c3                   	ret    

c01090a9 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01090a9:	55                   	push   %ebp
c01090aa:	89 e5                	mov    %esp,%ebp
c01090ac:	83 ec 58             	sub    $0x58,%esp
c01090af:	8b 45 10             	mov    0x10(%ebp),%eax
c01090b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01090b5:	8b 45 14             	mov    0x14(%ebp),%eax
c01090b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01090bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01090be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01090c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01090c4:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01090c7:	8b 45 18             	mov    0x18(%ebp),%eax
c01090ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01090cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01090d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01090d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01090d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01090d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01090df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01090e3:	74 1c                	je     c0109101 <printnum+0x58>
c01090e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090e8:	ba 00 00 00 00       	mov    $0x0,%edx
c01090ed:	f7 75 e4             	divl   -0x1c(%ebp)
c01090f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01090f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090f6:	ba 00 00 00 00       	mov    $0x0,%edx
c01090fb:	f7 75 e4             	divl   -0x1c(%ebp)
c01090fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109101:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109104:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109107:	f7 75 e4             	divl   -0x1c(%ebp)
c010910a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010910d:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0109110:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109113:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109116:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109119:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010911c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010911f:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0109122:	8b 45 18             	mov    0x18(%ebp),%eax
c0109125:	ba 00 00 00 00       	mov    $0x0,%edx
c010912a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010912d:	77 56                	ja     c0109185 <printnum+0xdc>
c010912f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0109132:	72 05                	jb     c0109139 <printnum+0x90>
c0109134:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0109137:	77 4c                	ja     c0109185 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0109139:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010913c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010913f:	8b 45 20             	mov    0x20(%ebp),%eax
c0109142:	89 44 24 18          	mov    %eax,0x18(%esp)
c0109146:	89 54 24 14          	mov    %edx,0x14(%esp)
c010914a:	8b 45 18             	mov    0x18(%ebp),%eax
c010914d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109151:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109154:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109157:	89 44 24 08          	mov    %eax,0x8(%esp)
c010915b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010915f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109162:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109166:	8b 45 08             	mov    0x8(%ebp),%eax
c0109169:	89 04 24             	mov    %eax,(%esp)
c010916c:	e8 38 ff ff ff       	call   c01090a9 <printnum>
c0109171:	eb 1c                	jmp    c010918f <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0109173:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109176:	89 44 24 04          	mov    %eax,0x4(%esp)
c010917a:	8b 45 20             	mov    0x20(%ebp),%eax
c010917d:	89 04 24             	mov    %eax,(%esp)
c0109180:	8b 45 08             	mov    0x8(%ebp),%eax
c0109183:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0109185:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0109189:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010918d:	7f e4                	jg     c0109173 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010918f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109192:	05 60 bd 10 c0       	add    $0xc010bd60,%eax
c0109197:	0f b6 00             	movzbl (%eax),%eax
c010919a:	0f be c0             	movsbl %al,%eax
c010919d:	8b 55 0c             	mov    0xc(%ebp),%edx
c01091a0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01091a4:	89 04 24             	mov    %eax,(%esp)
c01091a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01091aa:	ff d0                	call   *%eax
}
c01091ac:	c9                   	leave  
c01091ad:	c3                   	ret    

c01091ae <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01091ae:	55                   	push   %ebp
c01091af:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01091b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01091b5:	7e 14                	jle    c01091cb <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01091b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01091ba:	8b 00                	mov    (%eax),%eax
c01091bc:	8d 48 08             	lea    0x8(%eax),%ecx
c01091bf:	8b 55 08             	mov    0x8(%ebp),%edx
c01091c2:	89 0a                	mov    %ecx,(%edx)
c01091c4:	8b 50 04             	mov    0x4(%eax),%edx
c01091c7:	8b 00                	mov    (%eax),%eax
c01091c9:	eb 30                	jmp    c01091fb <getuint+0x4d>
    }
    else if (lflag) {
c01091cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01091cf:	74 16                	je     c01091e7 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01091d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01091d4:	8b 00                	mov    (%eax),%eax
c01091d6:	8d 48 04             	lea    0x4(%eax),%ecx
c01091d9:	8b 55 08             	mov    0x8(%ebp),%edx
c01091dc:	89 0a                	mov    %ecx,(%edx)
c01091de:	8b 00                	mov    (%eax),%eax
c01091e0:	ba 00 00 00 00       	mov    $0x0,%edx
c01091e5:	eb 14                	jmp    c01091fb <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01091e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01091ea:	8b 00                	mov    (%eax),%eax
c01091ec:	8d 48 04             	lea    0x4(%eax),%ecx
c01091ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01091f2:	89 0a                	mov    %ecx,(%edx)
c01091f4:	8b 00                	mov    (%eax),%eax
c01091f6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01091fb:	5d                   	pop    %ebp
c01091fc:	c3                   	ret    

c01091fd <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01091fd:	55                   	push   %ebp
c01091fe:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109200:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109204:	7e 14                	jle    c010921a <getint+0x1d>
        return va_arg(*ap, long long);
c0109206:	8b 45 08             	mov    0x8(%ebp),%eax
c0109209:	8b 00                	mov    (%eax),%eax
c010920b:	8d 48 08             	lea    0x8(%eax),%ecx
c010920e:	8b 55 08             	mov    0x8(%ebp),%edx
c0109211:	89 0a                	mov    %ecx,(%edx)
c0109213:	8b 50 04             	mov    0x4(%eax),%edx
c0109216:	8b 00                	mov    (%eax),%eax
c0109218:	eb 28                	jmp    c0109242 <getint+0x45>
    }
    else if (lflag) {
c010921a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010921e:	74 12                	je     c0109232 <getint+0x35>
        return va_arg(*ap, long);
c0109220:	8b 45 08             	mov    0x8(%ebp),%eax
c0109223:	8b 00                	mov    (%eax),%eax
c0109225:	8d 48 04             	lea    0x4(%eax),%ecx
c0109228:	8b 55 08             	mov    0x8(%ebp),%edx
c010922b:	89 0a                	mov    %ecx,(%edx)
c010922d:	8b 00                	mov    (%eax),%eax
c010922f:	99                   	cltd   
c0109230:	eb 10                	jmp    c0109242 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0109232:	8b 45 08             	mov    0x8(%ebp),%eax
c0109235:	8b 00                	mov    (%eax),%eax
c0109237:	8d 48 04             	lea    0x4(%eax),%ecx
c010923a:	8b 55 08             	mov    0x8(%ebp),%edx
c010923d:	89 0a                	mov    %ecx,(%edx)
c010923f:	8b 00                	mov    (%eax),%eax
c0109241:	99                   	cltd   
    }
}
c0109242:	5d                   	pop    %ebp
c0109243:	c3                   	ret    

c0109244 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0109244:	55                   	push   %ebp
c0109245:	89 e5                	mov    %esp,%ebp
c0109247:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010924a:	8d 45 14             	lea    0x14(%ebp),%eax
c010924d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0109250:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109253:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109257:	8b 45 10             	mov    0x10(%ebp),%eax
c010925a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010925e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109261:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109265:	8b 45 08             	mov    0x8(%ebp),%eax
c0109268:	89 04 24             	mov    %eax,(%esp)
c010926b:	e8 02 00 00 00       	call   c0109272 <vprintfmt>
    va_end(ap);
}
c0109270:	c9                   	leave  
c0109271:	c3                   	ret    

c0109272 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0109272:	55                   	push   %ebp
c0109273:	89 e5                	mov    %esp,%ebp
c0109275:	56                   	push   %esi
c0109276:	53                   	push   %ebx
c0109277:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010927a:	eb 18                	jmp    c0109294 <vprintfmt+0x22>
            if (ch == '\0') {
c010927c:	85 db                	test   %ebx,%ebx
c010927e:	75 05                	jne    c0109285 <vprintfmt+0x13>
                return;
c0109280:	e9 d1 03 00 00       	jmp    c0109656 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0109285:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109288:	89 44 24 04          	mov    %eax,0x4(%esp)
c010928c:	89 1c 24             	mov    %ebx,(%esp)
c010928f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109292:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109294:	8b 45 10             	mov    0x10(%ebp),%eax
c0109297:	8d 50 01             	lea    0x1(%eax),%edx
c010929a:	89 55 10             	mov    %edx,0x10(%ebp)
c010929d:	0f b6 00             	movzbl (%eax),%eax
c01092a0:	0f b6 d8             	movzbl %al,%ebx
c01092a3:	83 fb 25             	cmp    $0x25,%ebx
c01092a6:	75 d4                	jne    c010927c <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01092a8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01092ac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01092b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01092b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01092b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01092c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01092c3:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01092c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01092c9:	8d 50 01             	lea    0x1(%eax),%edx
c01092cc:	89 55 10             	mov    %edx,0x10(%ebp)
c01092cf:	0f b6 00             	movzbl (%eax),%eax
c01092d2:	0f b6 d8             	movzbl %al,%ebx
c01092d5:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01092d8:	83 f8 55             	cmp    $0x55,%eax
c01092db:	0f 87 44 03 00 00    	ja     c0109625 <vprintfmt+0x3b3>
c01092e1:	8b 04 85 84 bd 10 c0 	mov    -0x3fef427c(,%eax,4),%eax
c01092e8:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01092ea:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01092ee:	eb d6                	jmp    c01092c6 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01092f0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01092f4:	eb d0                	jmp    c01092c6 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01092f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01092fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109300:	89 d0                	mov    %edx,%eax
c0109302:	c1 e0 02             	shl    $0x2,%eax
c0109305:	01 d0                	add    %edx,%eax
c0109307:	01 c0                	add    %eax,%eax
c0109309:	01 d8                	add    %ebx,%eax
c010930b:	83 e8 30             	sub    $0x30,%eax
c010930e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0109311:	8b 45 10             	mov    0x10(%ebp),%eax
c0109314:	0f b6 00             	movzbl (%eax),%eax
c0109317:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010931a:	83 fb 2f             	cmp    $0x2f,%ebx
c010931d:	7e 0b                	jle    c010932a <vprintfmt+0xb8>
c010931f:	83 fb 39             	cmp    $0x39,%ebx
c0109322:	7f 06                	jg     c010932a <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0109324:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0109328:	eb d3                	jmp    c01092fd <vprintfmt+0x8b>
            goto process_precision;
c010932a:	eb 33                	jmp    c010935f <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010932c:	8b 45 14             	mov    0x14(%ebp),%eax
c010932f:	8d 50 04             	lea    0x4(%eax),%edx
c0109332:	89 55 14             	mov    %edx,0x14(%ebp)
c0109335:	8b 00                	mov    (%eax),%eax
c0109337:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010933a:	eb 23                	jmp    c010935f <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010933c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109340:	79 0c                	jns    c010934e <vprintfmt+0xdc>
                width = 0;
c0109342:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0109349:	e9 78 ff ff ff       	jmp    c01092c6 <vprintfmt+0x54>
c010934e:	e9 73 ff ff ff       	jmp    c01092c6 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0109353:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010935a:	e9 67 ff ff ff       	jmp    c01092c6 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010935f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109363:	79 12                	jns    c0109377 <vprintfmt+0x105>
                width = precision, precision = -1;
c0109365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109368:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010936b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0109372:	e9 4f ff ff ff       	jmp    c01092c6 <vprintfmt+0x54>
c0109377:	e9 4a ff ff ff       	jmp    c01092c6 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010937c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0109380:	e9 41 ff ff ff       	jmp    c01092c6 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0109385:	8b 45 14             	mov    0x14(%ebp),%eax
c0109388:	8d 50 04             	lea    0x4(%eax),%edx
c010938b:	89 55 14             	mov    %edx,0x14(%ebp)
c010938e:	8b 00                	mov    (%eax),%eax
c0109390:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109393:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109397:	89 04 24             	mov    %eax,(%esp)
c010939a:	8b 45 08             	mov    0x8(%ebp),%eax
c010939d:	ff d0                	call   *%eax
            break;
c010939f:	e9 ac 02 00 00       	jmp    c0109650 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01093a4:	8b 45 14             	mov    0x14(%ebp),%eax
c01093a7:	8d 50 04             	lea    0x4(%eax),%edx
c01093aa:	89 55 14             	mov    %edx,0x14(%ebp)
c01093ad:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01093af:	85 db                	test   %ebx,%ebx
c01093b1:	79 02                	jns    c01093b5 <vprintfmt+0x143>
                err = -err;
c01093b3:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01093b5:	83 fb 06             	cmp    $0x6,%ebx
c01093b8:	7f 0b                	jg     c01093c5 <vprintfmt+0x153>
c01093ba:	8b 34 9d 44 bd 10 c0 	mov    -0x3fef42bc(,%ebx,4),%esi
c01093c1:	85 f6                	test   %esi,%esi
c01093c3:	75 23                	jne    c01093e8 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01093c5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01093c9:	c7 44 24 08 71 bd 10 	movl   $0xc010bd71,0x8(%esp)
c01093d0:	c0 
c01093d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01093d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01093d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01093db:	89 04 24             	mov    %eax,(%esp)
c01093de:	e8 61 fe ff ff       	call   c0109244 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01093e3:	e9 68 02 00 00       	jmp    c0109650 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01093e8:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01093ec:	c7 44 24 08 7a bd 10 	movl   $0xc010bd7a,0x8(%esp)
c01093f3:	c0 
c01093f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01093f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01093fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01093fe:	89 04 24             	mov    %eax,(%esp)
c0109401:	e8 3e fe ff ff       	call   c0109244 <printfmt>
            }
            break;
c0109406:	e9 45 02 00 00       	jmp    c0109650 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010940b:	8b 45 14             	mov    0x14(%ebp),%eax
c010940e:	8d 50 04             	lea    0x4(%eax),%edx
c0109411:	89 55 14             	mov    %edx,0x14(%ebp)
c0109414:	8b 30                	mov    (%eax),%esi
c0109416:	85 f6                	test   %esi,%esi
c0109418:	75 05                	jne    c010941f <vprintfmt+0x1ad>
                p = "(null)";
c010941a:	be 7d bd 10 c0       	mov    $0xc010bd7d,%esi
            }
            if (width > 0 && padc != '-') {
c010941f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109423:	7e 3e                	jle    c0109463 <vprintfmt+0x1f1>
c0109425:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0109429:	74 38                	je     c0109463 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010942b:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010942e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109431:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109435:	89 34 24             	mov    %esi,(%esp)
c0109438:	e8 ed 03 00 00       	call   c010982a <strnlen>
c010943d:	29 c3                	sub    %eax,%ebx
c010943f:	89 d8                	mov    %ebx,%eax
c0109441:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109444:	eb 17                	jmp    c010945d <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0109446:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010944a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010944d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109451:	89 04 24             	mov    %eax,(%esp)
c0109454:	8b 45 08             	mov    0x8(%ebp),%eax
c0109457:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109459:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010945d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109461:	7f e3                	jg     c0109446 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109463:	eb 38                	jmp    c010949d <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0109465:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0109469:	74 1f                	je     c010948a <vprintfmt+0x218>
c010946b:	83 fb 1f             	cmp    $0x1f,%ebx
c010946e:	7e 05                	jle    c0109475 <vprintfmt+0x203>
c0109470:	83 fb 7e             	cmp    $0x7e,%ebx
c0109473:	7e 15                	jle    c010948a <vprintfmt+0x218>
                    putch('?', putdat);
c0109475:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109478:	89 44 24 04          	mov    %eax,0x4(%esp)
c010947c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0109483:	8b 45 08             	mov    0x8(%ebp),%eax
c0109486:	ff d0                	call   *%eax
c0109488:	eb 0f                	jmp    c0109499 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010948a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010948d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109491:	89 1c 24             	mov    %ebx,(%esp)
c0109494:	8b 45 08             	mov    0x8(%ebp),%eax
c0109497:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109499:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010949d:	89 f0                	mov    %esi,%eax
c010949f:	8d 70 01             	lea    0x1(%eax),%esi
c01094a2:	0f b6 00             	movzbl (%eax),%eax
c01094a5:	0f be d8             	movsbl %al,%ebx
c01094a8:	85 db                	test   %ebx,%ebx
c01094aa:	74 10                	je     c01094bc <vprintfmt+0x24a>
c01094ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01094b0:	78 b3                	js     c0109465 <vprintfmt+0x1f3>
c01094b2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01094b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01094ba:	79 a9                	jns    c0109465 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01094bc:	eb 17                	jmp    c01094d5 <vprintfmt+0x263>
                putch(' ', putdat);
c01094be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094c5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01094cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01094cf:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01094d1:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01094d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01094d9:	7f e3                	jg     c01094be <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01094db:	e9 70 01 00 00       	jmp    c0109650 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01094e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01094e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094e7:	8d 45 14             	lea    0x14(%ebp),%eax
c01094ea:	89 04 24             	mov    %eax,(%esp)
c01094ed:	e8 0b fd ff ff       	call   c01091fd <getint>
c01094f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01094f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01094f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01094fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01094fe:	85 d2                	test   %edx,%edx
c0109500:	79 26                	jns    c0109528 <vprintfmt+0x2b6>
                putch('-', putdat);
c0109502:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109505:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109509:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0109510:	8b 45 08             	mov    0x8(%ebp),%eax
c0109513:	ff d0                	call   *%eax
                num = -(long long)num;
c0109515:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109518:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010951b:	f7 d8                	neg    %eax
c010951d:	83 d2 00             	adc    $0x0,%edx
c0109520:	f7 da                	neg    %edx
c0109522:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109525:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0109528:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010952f:	e9 a8 00 00 00       	jmp    c01095dc <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109534:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109537:	89 44 24 04          	mov    %eax,0x4(%esp)
c010953b:	8d 45 14             	lea    0x14(%ebp),%eax
c010953e:	89 04 24             	mov    %eax,(%esp)
c0109541:	e8 68 fc ff ff       	call   c01091ae <getuint>
c0109546:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109549:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010954c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109553:	e9 84 00 00 00       	jmp    c01095dc <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109558:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010955b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010955f:	8d 45 14             	lea    0x14(%ebp),%eax
c0109562:	89 04 24             	mov    %eax,(%esp)
c0109565:	e8 44 fc ff ff       	call   c01091ae <getuint>
c010956a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010956d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0109570:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0109577:	eb 63                	jmp    c01095dc <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0109579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010957c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109580:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0109587:	8b 45 08             	mov    0x8(%ebp),%eax
c010958a:	ff d0                	call   *%eax
            putch('x', putdat);
c010958c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010958f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109593:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010959a:	8b 45 08             	mov    0x8(%ebp),%eax
c010959d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010959f:	8b 45 14             	mov    0x14(%ebp),%eax
c01095a2:	8d 50 04             	lea    0x4(%eax),%edx
c01095a5:	89 55 14             	mov    %edx,0x14(%ebp)
c01095a8:	8b 00                	mov    (%eax),%eax
c01095aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01095ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01095b4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01095bb:	eb 1f                	jmp    c01095dc <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01095bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01095c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095c4:	8d 45 14             	lea    0x14(%ebp),%eax
c01095c7:	89 04 24             	mov    %eax,(%esp)
c01095ca:	e8 df fb ff ff       	call   c01091ae <getuint>
c01095cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01095d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01095d5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01095dc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01095e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01095e3:	89 54 24 18          	mov    %edx,0x18(%esp)
c01095e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01095ea:	89 54 24 14          	mov    %edx,0x14(%esp)
c01095ee:	89 44 24 10          	mov    %eax,0x10(%esp)
c01095f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01095f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01095f8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01095fc:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109600:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109603:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109607:	8b 45 08             	mov    0x8(%ebp),%eax
c010960a:	89 04 24             	mov    %eax,(%esp)
c010960d:	e8 97 fa ff ff       	call   c01090a9 <printnum>
            break;
c0109612:	eb 3c                	jmp    c0109650 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0109614:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109617:	89 44 24 04          	mov    %eax,0x4(%esp)
c010961b:	89 1c 24             	mov    %ebx,(%esp)
c010961e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109621:	ff d0                	call   *%eax
            break;
c0109623:	eb 2b                	jmp    c0109650 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0109625:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109628:	89 44 24 04          	mov    %eax,0x4(%esp)
c010962c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0109633:	8b 45 08             	mov    0x8(%ebp),%eax
c0109636:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0109638:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010963c:	eb 04                	jmp    c0109642 <vprintfmt+0x3d0>
c010963e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109642:	8b 45 10             	mov    0x10(%ebp),%eax
c0109645:	83 e8 01             	sub    $0x1,%eax
c0109648:	0f b6 00             	movzbl (%eax),%eax
c010964b:	3c 25                	cmp    $0x25,%al
c010964d:	75 ef                	jne    c010963e <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010964f:	90                   	nop
        }
    }
c0109650:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109651:	e9 3e fc ff ff       	jmp    c0109294 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0109656:	83 c4 40             	add    $0x40,%esp
c0109659:	5b                   	pop    %ebx
c010965a:	5e                   	pop    %esi
c010965b:	5d                   	pop    %ebp
c010965c:	c3                   	ret    

c010965d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010965d:	55                   	push   %ebp
c010965e:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109660:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109663:	8b 40 08             	mov    0x8(%eax),%eax
c0109666:	8d 50 01             	lea    0x1(%eax),%edx
c0109669:	8b 45 0c             	mov    0xc(%ebp),%eax
c010966c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010966f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109672:	8b 10                	mov    (%eax),%edx
c0109674:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109677:	8b 40 04             	mov    0x4(%eax),%eax
c010967a:	39 c2                	cmp    %eax,%edx
c010967c:	73 12                	jae    c0109690 <sprintputch+0x33>
        *b->buf ++ = ch;
c010967e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109681:	8b 00                	mov    (%eax),%eax
c0109683:	8d 48 01             	lea    0x1(%eax),%ecx
c0109686:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109689:	89 0a                	mov    %ecx,(%edx)
c010968b:	8b 55 08             	mov    0x8(%ebp),%edx
c010968e:	88 10                	mov    %dl,(%eax)
    }
}
c0109690:	5d                   	pop    %ebp
c0109691:	c3                   	ret    

c0109692 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109692:	55                   	push   %ebp
c0109693:	89 e5                	mov    %esp,%ebp
c0109695:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109698:	8d 45 14             	lea    0x14(%ebp),%eax
c010969b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010969e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01096a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01096a5:	8b 45 10             	mov    0x10(%ebp),%eax
c01096a8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01096ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01096b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01096b6:	89 04 24             	mov    %eax,(%esp)
c01096b9:	e8 08 00 00 00       	call   c01096c6 <vsnprintf>
c01096be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01096c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01096c4:	c9                   	leave  
c01096c5:	c3                   	ret    

c01096c6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01096c6:	55                   	push   %ebp
c01096c7:	89 e5                	mov    %esp,%ebp
c01096c9:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01096cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01096cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01096d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096d5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01096d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01096db:	01 d0                	add    %edx,%eax
c01096dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01096e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01096e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01096eb:	74 0a                	je     c01096f7 <vsnprintf+0x31>
c01096ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01096f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01096f3:	39 c2                	cmp    %eax,%edx
c01096f5:	76 07                	jbe    c01096fe <vsnprintf+0x38>
        return -E_INVAL;
c01096f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01096fc:	eb 2a                	jmp    c0109728 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01096fe:	8b 45 14             	mov    0x14(%ebp),%eax
c0109701:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109705:	8b 45 10             	mov    0x10(%ebp),%eax
c0109708:	89 44 24 08          	mov    %eax,0x8(%esp)
c010970c:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010970f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109713:	c7 04 24 5d 96 10 c0 	movl   $0xc010965d,(%esp)
c010971a:	e8 53 fb ff ff       	call   c0109272 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010971f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109722:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0109725:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109728:	c9                   	leave  
c0109729:	c3                   	ret    

c010972a <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c010972a:	55                   	push   %ebp
c010972b:	89 e5                	mov    %esp,%ebp
c010972d:	57                   	push   %edi
c010972e:	56                   	push   %esi
c010972f:	53                   	push   %ebx
c0109730:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0109733:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c0109738:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c010973e:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109744:	6b f0 05             	imul   $0x5,%eax,%esi
c0109747:	01 f7                	add    %esi,%edi
c0109749:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010974e:	f7 e6                	mul    %esi
c0109750:	8d 34 17             	lea    (%edi,%edx,1),%esi
c0109753:	89 f2                	mov    %esi,%edx
c0109755:	83 c0 0b             	add    $0xb,%eax
c0109758:	83 d2 00             	adc    $0x0,%edx
c010975b:	89 c7                	mov    %eax,%edi
c010975d:	83 e7 ff             	and    $0xffffffff,%edi
c0109760:	89 f9                	mov    %edi,%ecx
c0109762:	0f b7 da             	movzwl %dx,%ebx
c0109765:	89 0d 88 4a 12 c0    	mov    %ecx,0xc0124a88
c010976b:	89 1d 8c 4a 12 c0    	mov    %ebx,0xc0124a8c
    unsigned long long result = (next >> 12);
c0109771:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c0109776:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c010977c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109780:	c1 ea 0c             	shr    $0xc,%edx
c0109783:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109786:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0109789:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0109790:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109796:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109799:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010979c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010979f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01097a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01097a6:	74 1c                	je     c01097c4 <rand+0x9a>
c01097a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01097ab:	ba 00 00 00 00       	mov    $0x0,%edx
c01097b0:	f7 75 dc             	divl   -0x24(%ebp)
c01097b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01097b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01097b9:	ba 00 00 00 00       	mov    $0x0,%edx
c01097be:	f7 75 dc             	divl   -0x24(%ebp)
c01097c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01097c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01097c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01097ca:	f7 75 dc             	divl   -0x24(%ebp)
c01097cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01097d0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01097d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01097d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01097d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01097dc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01097df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c01097e2:	83 c4 24             	add    $0x24,%esp
c01097e5:	5b                   	pop    %ebx
c01097e6:	5e                   	pop    %esi
c01097e7:	5f                   	pop    %edi
c01097e8:	5d                   	pop    %ebp
c01097e9:	c3                   	ret    

c01097ea <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c01097ea:	55                   	push   %ebp
c01097eb:	89 e5                	mov    %esp,%ebp
    next = seed;
c01097ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01097f0:	ba 00 00 00 00       	mov    $0x0,%edx
c01097f5:	a3 88 4a 12 c0       	mov    %eax,0xc0124a88
c01097fa:	89 15 8c 4a 12 c0    	mov    %edx,0xc0124a8c
}
c0109800:	5d                   	pop    %ebp
c0109801:	c3                   	ret    

c0109802 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0109802:	55                   	push   %ebp
c0109803:	89 e5                	mov    %esp,%ebp
c0109805:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109808:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010980f:	eb 04                	jmp    c0109815 <strlen+0x13>
        cnt ++;
c0109811:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0109815:	8b 45 08             	mov    0x8(%ebp),%eax
c0109818:	8d 50 01             	lea    0x1(%eax),%edx
c010981b:	89 55 08             	mov    %edx,0x8(%ebp)
c010981e:	0f b6 00             	movzbl (%eax),%eax
c0109821:	84 c0                	test   %al,%al
c0109823:	75 ec                	jne    c0109811 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0109825:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109828:	c9                   	leave  
c0109829:	c3                   	ret    

c010982a <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010982a:	55                   	push   %ebp
c010982b:	89 e5                	mov    %esp,%ebp
c010982d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109830:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0109837:	eb 04                	jmp    c010983d <strnlen+0x13>
        cnt ++;
c0109839:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010983d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109840:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0109843:	73 10                	jae    c0109855 <strnlen+0x2b>
c0109845:	8b 45 08             	mov    0x8(%ebp),%eax
c0109848:	8d 50 01             	lea    0x1(%eax),%edx
c010984b:	89 55 08             	mov    %edx,0x8(%ebp)
c010984e:	0f b6 00             	movzbl (%eax),%eax
c0109851:	84 c0                	test   %al,%al
c0109853:	75 e4                	jne    c0109839 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0109855:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109858:	c9                   	leave  
c0109859:	c3                   	ret    

c010985a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010985a:	55                   	push   %ebp
c010985b:	89 e5                	mov    %esp,%ebp
c010985d:	57                   	push   %edi
c010985e:	56                   	push   %esi
c010985f:	83 ec 20             	sub    $0x20,%esp
c0109862:	8b 45 08             	mov    0x8(%ebp),%eax
c0109865:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109868:	8b 45 0c             	mov    0xc(%ebp),%eax
c010986b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010986e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109871:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109874:	89 d1                	mov    %edx,%ecx
c0109876:	89 c2                	mov    %eax,%edx
c0109878:	89 ce                	mov    %ecx,%esi
c010987a:	89 d7                	mov    %edx,%edi
c010987c:	ac                   	lods   %ds:(%esi),%al
c010987d:	aa                   	stos   %al,%es:(%edi)
c010987e:	84 c0                	test   %al,%al
c0109880:	75 fa                	jne    c010987c <strcpy+0x22>
c0109882:	89 fa                	mov    %edi,%edx
c0109884:	89 f1                	mov    %esi,%ecx
c0109886:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109889:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010988c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010988f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0109892:	83 c4 20             	add    $0x20,%esp
c0109895:	5e                   	pop    %esi
c0109896:	5f                   	pop    %edi
c0109897:	5d                   	pop    %ebp
c0109898:	c3                   	ret    

c0109899 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0109899:	55                   	push   %ebp
c010989a:	89 e5                	mov    %esp,%ebp
c010989c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010989f:	8b 45 08             	mov    0x8(%ebp),%eax
c01098a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01098a5:	eb 21                	jmp    c01098c8 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01098a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098aa:	0f b6 10             	movzbl (%eax),%edx
c01098ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01098b0:	88 10                	mov    %dl,(%eax)
c01098b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01098b5:	0f b6 00             	movzbl (%eax),%eax
c01098b8:	84 c0                	test   %al,%al
c01098ba:	74 04                	je     c01098c0 <strncpy+0x27>
            src ++;
c01098bc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01098c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01098c4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01098c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01098cc:	75 d9                	jne    c01098a7 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01098ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01098d1:	c9                   	leave  
c01098d2:	c3                   	ret    

c01098d3 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01098d3:	55                   	push   %ebp
c01098d4:	89 e5                	mov    %esp,%ebp
c01098d6:	57                   	push   %edi
c01098d7:	56                   	push   %esi
c01098d8:	83 ec 20             	sub    $0x20,%esp
c01098db:	8b 45 08             	mov    0x8(%ebp),%eax
c01098de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01098e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01098e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01098ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01098ed:	89 d1                	mov    %edx,%ecx
c01098ef:	89 c2                	mov    %eax,%edx
c01098f1:	89 ce                	mov    %ecx,%esi
c01098f3:	89 d7                	mov    %edx,%edi
c01098f5:	ac                   	lods   %ds:(%esi),%al
c01098f6:	ae                   	scas   %es:(%edi),%al
c01098f7:	75 08                	jne    c0109901 <strcmp+0x2e>
c01098f9:	84 c0                	test   %al,%al
c01098fb:	75 f8                	jne    c01098f5 <strcmp+0x22>
c01098fd:	31 c0                	xor    %eax,%eax
c01098ff:	eb 04                	jmp    c0109905 <strcmp+0x32>
c0109901:	19 c0                	sbb    %eax,%eax
c0109903:	0c 01                	or     $0x1,%al
c0109905:	89 fa                	mov    %edi,%edx
c0109907:	89 f1                	mov    %esi,%ecx
c0109909:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010990c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010990f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0109912:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0109915:	83 c4 20             	add    $0x20,%esp
c0109918:	5e                   	pop    %esi
c0109919:	5f                   	pop    %edi
c010991a:	5d                   	pop    %ebp
c010991b:	c3                   	ret    

c010991c <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010991c:	55                   	push   %ebp
c010991d:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010991f:	eb 0c                	jmp    c010992d <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0109921:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109925:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109929:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010992d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109931:	74 1a                	je     c010994d <strncmp+0x31>
c0109933:	8b 45 08             	mov    0x8(%ebp),%eax
c0109936:	0f b6 00             	movzbl (%eax),%eax
c0109939:	84 c0                	test   %al,%al
c010993b:	74 10                	je     c010994d <strncmp+0x31>
c010993d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109940:	0f b6 10             	movzbl (%eax),%edx
c0109943:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109946:	0f b6 00             	movzbl (%eax),%eax
c0109949:	38 c2                	cmp    %al,%dl
c010994b:	74 d4                	je     c0109921 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010994d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109951:	74 18                	je     c010996b <strncmp+0x4f>
c0109953:	8b 45 08             	mov    0x8(%ebp),%eax
c0109956:	0f b6 00             	movzbl (%eax),%eax
c0109959:	0f b6 d0             	movzbl %al,%edx
c010995c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010995f:	0f b6 00             	movzbl (%eax),%eax
c0109962:	0f b6 c0             	movzbl %al,%eax
c0109965:	29 c2                	sub    %eax,%edx
c0109967:	89 d0                	mov    %edx,%eax
c0109969:	eb 05                	jmp    c0109970 <strncmp+0x54>
c010996b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109970:	5d                   	pop    %ebp
c0109971:	c3                   	ret    

c0109972 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0109972:	55                   	push   %ebp
c0109973:	89 e5                	mov    %esp,%ebp
c0109975:	83 ec 04             	sub    $0x4,%esp
c0109978:	8b 45 0c             	mov    0xc(%ebp),%eax
c010997b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010997e:	eb 14                	jmp    c0109994 <strchr+0x22>
        if (*s == c) {
c0109980:	8b 45 08             	mov    0x8(%ebp),%eax
c0109983:	0f b6 00             	movzbl (%eax),%eax
c0109986:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0109989:	75 05                	jne    c0109990 <strchr+0x1e>
            return (char *)s;
c010998b:	8b 45 08             	mov    0x8(%ebp),%eax
c010998e:	eb 13                	jmp    c01099a3 <strchr+0x31>
        }
        s ++;
c0109990:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0109994:	8b 45 08             	mov    0x8(%ebp),%eax
c0109997:	0f b6 00             	movzbl (%eax),%eax
c010999a:	84 c0                	test   %al,%al
c010999c:	75 e2                	jne    c0109980 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010999e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01099a3:	c9                   	leave  
c01099a4:	c3                   	ret    

c01099a5 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01099a5:	55                   	push   %ebp
c01099a6:	89 e5                	mov    %esp,%ebp
c01099a8:	83 ec 04             	sub    $0x4,%esp
c01099ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099ae:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01099b1:	eb 11                	jmp    c01099c4 <strfind+0x1f>
        if (*s == c) {
c01099b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01099b6:	0f b6 00             	movzbl (%eax),%eax
c01099b9:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01099bc:	75 02                	jne    c01099c0 <strfind+0x1b>
            break;
c01099be:	eb 0e                	jmp    c01099ce <strfind+0x29>
        }
        s ++;
c01099c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01099c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01099c7:	0f b6 00             	movzbl (%eax),%eax
c01099ca:	84 c0                	test   %al,%al
c01099cc:	75 e5                	jne    c01099b3 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c01099ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01099d1:	c9                   	leave  
c01099d2:	c3                   	ret    

c01099d3 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01099d3:	55                   	push   %ebp
c01099d4:	89 e5                	mov    %esp,%ebp
c01099d6:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01099d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01099e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01099e7:	eb 04                	jmp    c01099ed <strtol+0x1a>
        s ++;
c01099e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01099ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01099f0:	0f b6 00             	movzbl (%eax),%eax
c01099f3:	3c 20                	cmp    $0x20,%al
c01099f5:	74 f2                	je     c01099e9 <strtol+0x16>
c01099f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01099fa:	0f b6 00             	movzbl (%eax),%eax
c01099fd:	3c 09                	cmp    $0x9,%al
c01099ff:	74 e8                	je     c01099e9 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0109a01:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a04:	0f b6 00             	movzbl (%eax),%eax
c0109a07:	3c 2b                	cmp    $0x2b,%al
c0109a09:	75 06                	jne    c0109a11 <strtol+0x3e>
        s ++;
c0109a0b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109a0f:	eb 15                	jmp    c0109a26 <strtol+0x53>
    }
    else if (*s == '-') {
c0109a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a14:	0f b6 00             	movzbl (%eax),%eax
c0109a17:	3c 2d                	cmp    $0x2d,%al
c0109a19:	75 0b                	jne    c0109a26 <strtol+0x53>
        s ++, neg = 1;
c0109a1b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109a1f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0109a26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109a2a:	74 06                	je     c0109a32 <strtol+0x5f>
c0109a2c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0109a30:	75 24                	jne    c0109a56 <strtol+0x83>
c0109a32:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a35:	0f b6 00             	movzbl (%eax),%eax
c0109a38:	3c 30                	cmp    $0x30,%al
c0109a3a:	75 1a                	jne    c0109a56 <strtol+0x83>
c0109a3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a3f:	83 c0 01             	add    $0x1,%eax
c0109a42:	0f b6 00             	movzbl (%eax),%eax
c0109a45:	3c 78                	cmp    $0x78,%al
c0109a47:	75 0d                	jne    c0109a56 <strtol+0x83>
        s += 2, base = 16;
c0109a49:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0109a4d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0109a54:	eb 2a                	jmp    c0109a80 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0109a56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109a5a:	75 17                	jne    c0109a73 <strtol+0xa0>
c0109a5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a5f:	0f b6 00             	movzbl (%eax),%eax
c0109a62:	3c 30                	cmp    $0x30,%al
c0109a64:	75 0d                	jne    c0109a73 <strtol+0xa0>
        s ++, base = 8;
c0109a66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109a6a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0109a71:	eb 0d                	jmp    c0109a80 <strtol+0xad>
    }
    else if (base == 0) {
c0109a73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109a77:	75 07                	jne    c0109a80 <strtol+0xad>
        base = 10;
c0109a79:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0109a80:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a83:	0f b6 00             	movzbl (%eax),%eax
c0109a86:	3c 2f                	cmp    $0x2f,%al
c0109a88:	7e 1b                	jle    c0109aa5 <strtol+0xd2>
c0109a8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a8d:	0f b6 00             	movzbl (%eax),%eax
c0109a90:	3c 39                	cmp    $0x39,%al
c0109a92:	7f 11                	jg     c0109aa5 <strtol+0xd2>
            dig = *s - '0';
c0109a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a97:	0f b6 00             	movzbl (%eax),%eax
c0109a9a:	0f be c0             	movsbl %al,%eax
c0109a9d:	83 e8 30             	sub    $0x30,%eax
c0109aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109aa3:	eb 48                	jmp    c0109aed <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0109aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0109aa8:	0f b6 00             	movzbl (%eax),%eax
c0109aab:	3c 60                	cmp    $0x60,%al
c0109aad:	7e 1b                	jle    c0109aca <strtol+0xf7>
c0109aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ab2:	0f b6 00             	movzbl (%eax),%eax
c0109ab5:	3c 7a                	cmp    $0x7a,%al
c0109ab7:	7f 11                	jg     c0109aca <strtol+0xf7>
            dig = *s - 'a' + 10;
c0109ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0109abc:	0f b6 00             	movzbl (%eax),%eax
c0109abf:	0f be c0             	movsbl %al,%eax
c0109ac2:	83 e8 57             	sub    $0x57,%eax
c0109ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109ac8:	eb 23                	jmp    c0109aed <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0109aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0109acd:	0f b6 00             	movzbl (%eax),%eax
c0109ad0:	3c 40                	cmp    $0x40,%al
c0109ad2:	7e 3d                	jle    c0109b11 <strtol+0x13e>
c0109ad4:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ad7:	0f b6 00             	movzbl (%eax),%eax
c0109ada:	3c 5a                	cmp    $0x5a,%al
c0109adc:	7f 33                	jg     c0109b11 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0109ade:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ae1:	0f b6 00             	movzbl (%eax),%eax
c0109ae4:	0f be c0             	movsbl %al,%eax
c0109ae7:	83 e8 37             	sub    $0x37,%eax
c0109aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0109aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109af0:	3b 45 10             	cmp    0x10(%ebp),%eax
c0109af3:	7c 02                	jl     c0109af7 <strtol+0x124>
            break;
c0109af5:	eb 1a                	jmp    c0109b11 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0109af7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109afb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109afe:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109b02:	89 c2                	mov    %eax,%edx
c0109b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b07:	01 d0                	add    %edx,%eax
c0109b09:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0109b0c:	e9 6f ff ff ff       	jmp    c0109a80 <strtol+0xad>

    if (endptr) {
c0109b11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109b15:	74 08                	je     c0109b1f <strtol+0x14c>
        *endptr = (char *) s;
c0109b17:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b1a:	8b 55 08             	mov    0x8(%ebp),%edx
c0109b1d:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109b1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109b23:	74 07                	je     c0109b2c <strtol+0x159>
c0109b25:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109b28:	f7 d8                	neg    %eax
c0109b2a:	eb 03                	jmp    c0109b2f <strtol+0x15c>
c0109b2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109b2f:	c9                   	leave  
c0109b30:	c3                   	ret    

c0109b31 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109b31:	55                   	push   %ebp
c0109b32:	89 e5                	mov    %esp,%ebp
c0109b34:	57                   	push   %edi
c0109b35:	83 ec 24             	sub    $0x24,%esp
c0109b38:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b3b:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0109b3e:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0109b42:	8b 55 08             	mov    0x8(%ebp),%edx
c0109b45:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109b48:	88 45 f7             	mov    %al,-0x9(%ebp)
c0109b4b:	8b 45 10             	mov    0x10(%ebp),%eax
c0109b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109b51:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0109b54:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0109b58:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109b5b:	89 d7                	mov    %edx,%edi
c0109b5d:	f3 aa                	rep stos %al,%es:(%edi)
c0109b5f:	89 fa                	mov    %edi,%edx
c0109b61:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109b64:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0109b67:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0109b6a:	83 c4 24             	add    $0x24,%esp
c0109b6d:	5f                   	pop    %edi
c0109b6e:	5d                   	pop    %ebp
c0109b6f:	c3                   	ret    

c0109b70 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0109b70:	55                   	push   %ebp
c0109b71:	89 e5                	mov    %esp,%ebp
c0109b73:	57                   	push   %edi
c0109b74:	56                   	push   %esi
c0109b75:	53                   	push   %ebx
c0109b76:	83 ec 30             	sub    $0x30,%esp
c0109b79:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b82:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109b85:	8b 45 10             	mov    0x10(%ebp),%eax
c0109b88:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0109b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b8e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0109b91:	73 42                	jae    c0109bd5 <memmove+0x65>
c0109b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109b99:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109b9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109ba2:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109ba5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109ba8:	c1 e8 02             	shr    $0x2,%eax
c0109bab:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109bad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109bb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109bb3:	89 d7                	mov    %edx,%edi
c0109bb5:	89 c6                	mov    %eax,%esi
c0109bb7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109bb9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0109bbc:	83 e1 03             	and    $0x3,%ecx
c0109bbf:	74 02                	je     c0109bc3 <memmove+0x53>
c0109bc1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109bc3:	89 f0                	mov    %esi,%eax
c0109bc5:	89 fa                	mov    %edi,%edx
c0109bc7:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0109bca:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109bcd:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109bd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109bd3:	eb 36                	jmp    c0109c0b <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0109bd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109bd8:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109bde:	01 c2                	add    %eax,%edx
c0109be0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109be3:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0109be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109be9:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0109bec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109bef:	89 c1                	mov    %eax,%ecx
c0109bf1:	89 d8                	mov    %ebx,%eax
c0109bf3:	89 d6                	mov    %edx,%esi
c0109bf5:	89 c7                	mov    %eax,%edi
c0109bf7:	fd                   	std    
c0109bf8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109bfa:	fc                   	cld    
c0109bfb:	89 f8                	mov    %edi,%eax
c0109bfd:	89 f2                	mov    %esi,%edx
c0109bff:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0109c02:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0109c05:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0109c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109c0b:	83 c4 30             	add    $0x30,%esp
c0109c0e:	5b                   	pop    %ebx
c0109c0f:	5e                   	pop    %esi
c0109c10:	5f                   	pop    %edi
c0109c11:	5d                   	pop    %ebp
c0109c12:	c3                   	ret    

c0109c13 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109c13:	55                   	push   %ebp
c0109c14:	89 e5                	mov    %esp,%ebp
c0109c16:	57                   	push   %edi
c0109c17:	56                   	push   %esi
c0109c18:	83 ec 20             	sub    $0x20,%esp
c0109c1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109c21:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c27:	8b 45 10             	mov    0x10(%ebp),%eax
c0109c2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c30:	c1 e8 02             	shr    $0x2,%eax
c0109c33:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c3b:	89 d7                	mov    %edx,%edi
c0109c3d:	89 c6                	mov    %eax,%esi
c0109c3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109c41:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109c44:	83 e1 03             	and    $0x3,%ecx
c0109c47:	74 02                	je     c0109c4b <memcpy+0x38>
c0109c49:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109c4b:	89 f0                	mov    %esi,%eax
c0109c4d:	89 fa                	mov    %edi,%edx
c0109c4f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109c52:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109c55:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0109c5b:	83 c4 20             	add    $0x20,%esp
c0109c5e:	5e                   	pop    %esi
c0109c5f:	5f                   	pop    %edi
c0109c60:	5d                   	pop    %ebp
c0109c61:	c3                   	ret    

c0109c62 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109c62:	55                   	push   %ebp
c0109c63:	89 e5                	mov    %esp,%ebp
c0109c65:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0109c68:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0109c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c71:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0109c74:	eb 30                	jmp    c0109ca6 <memcmp+0x44>
        if (*s1 != *s2) {
c0109c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109c79:	0f b6 10             	movzbl (%eax),%edx
c0109c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109c7f:	0f b6 00             	movzbl (%eax),%eax
c0109c82:	38 c2                	cmp    %al,%dl
c0109c84:	74 18                	je     c0109c9e <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109c86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109c89:	0f b6 00             	movzbl (%eax),%eax
c0109c8c:	0f b6 d0             	movzbl %al,%edx
c0109c8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109c92:	0f b6 00             	movzbl (%eax),%eax
c0109c95:	0f b6 c0             	movzbl %al,%eax
c0109c98:	29 c2                	sub    %eax,%edx
c0109c9a:	89 d0                	mov    %edx,%eax
c0109c9c:	eb 1a                	jmp    c0109cb8 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0109c9e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109ca2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0109ca6:	8b 45 10             	mov    0x10(%ebp),%eax
c0109ca9:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109cac:	89 55 10             	mov    %edx,0x10(%ebp)
c0109caf:	85 c0                	test   %eax,%eax
c0109cb1:	75 c3                	jne    c0109c76 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0109cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109cb8:	c9                   	leave  
c0109cb9:	c3                   	ret    
