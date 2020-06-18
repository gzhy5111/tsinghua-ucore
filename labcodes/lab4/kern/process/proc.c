#include <proc.h>
#include <kmalloc.h>
#include <string.h>
#include <sync.h>
#include <pmm.h>
#include <error.h>
#include <sched.h>
#include <elf.h>
#include <vmm.h>
#include <trap.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

/* ------------- process/thread mechanism design&implementation -------------
(an simplified Linux process/thread mechanism )
introduction:
  ucore implements a simple process/thread mechanism. process contains the independent memory sapce, at least one threads
for execution, the kernel data(for management), processor state (for context switch), files(in lab6), etc. ucore needs to
manage all these details efficiently. In ucore, a thread is just a special kind of process(share process's memory).
------------------------------
process state       :     meaning               -- reason
    PROC_UNINIT     :   uninitialized           -- alloc_proc
    PROC_SLEEPING   :   sleeping                -- try_free_pages, do_wait, do_sleep
    PROC_RUNNABLE   :   runnable(maybe running) -- proc_init, wakeup_proc, 
    PROC_ZOMBIE     :   almost dead             -- do_exit

-----------------------------
process state changing:
                                            
  alloc_proc                                 RUNNING
      +                                   +--<----<--+
      +                                   + proc_run +
      V                                   +-->---->--+ 
PROC_UNINIT -- proc_init/wakeup_proc --> PROC_RUNNABLE -- try_free_pages/do_wait/do_sleep --> PROC_SLEEPING --
                                           A      +                                                           +
                                           |      +--- do_exit --> PROC_ZOMBIE                                +
                                           +                                                                  + 
                                           -----------------------wakeup_proc----------------------------------
-----------------------------
process relations
parent:           proc->parent  (proc is children)
children:         proc->cptr    (proc is parent)
older sibling:    proc->optr    (proc is younger sibling)
younger sibling:  proc->yptr    (proc is older sibling)
-----------------------------
related syscall for process:
SYS_exit        : process exit,                           -->do_exit
SYS_fork        : create child process, dup mm            -->do_fork-->wakeup_proc
SYS_wait        : wait process                            -->do_wait
SYS_exec        : after fork, process execute a program   -->load a program and refresh the mm
SYS_clone       : create child thread                     -->do_fork-->wakeup_proc
SYS_yield       : process flag itself need resecheduling, -- proc->need_sched=1, then scheduler will rescheule this process
SYS_sleep       : process sleep                           -->do_sleep 
SYS_kill        : kill process                            -->do_kill-->proc->flags |= PF_EXITING
                                                                 -->wakeup_proc-->do_wait-->do_exit   
SYS_getpid      : get the process's pid

*/

// the process set's list
list_entry_t proc_list;

#define HASH_SHIFT          10
#define HASH_LIST_SIZE      (1 << HASH_SHIFT)
#define pid_hashfn(x)       (hash32(x, HASH_SHIFT))

// has list for process set based on pid
static list_entry_t hash_list[HASH_LIST_SIZE];

// idle proc
struct proc_struct *idleproc = NULL;
// init proc
struct proc_struct *initproc = NULL;
// current proc
struct proc_struct *current = NULL;

static int nr_process = 0;

void kernel_thread_entry(void);
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL) {
    //LAB4:EXERCISE1 YOUR CODE
    /*
     * below fields in proc_struct need to be initialized
     *       enum proc_state state;                      // Process state
     *       int pid;                                    // Process ID
     *       int runs;                                   // the running times of Proces
     *       uintptr_t kstack;                           // Process kernel stack
     *       volatile bool need_resched;                 // bool value: need to be rescheduled to release CPU?
     *       struct proc_struct *parent;                 // the parent process
     *       struct mm_struct *mm;                       // Process's memory management field
     *       struct context context;                     // Switch here to run process
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */

    	/*
    	 * 执行的是第一步初始化工作
    	 */

    	proc->state = PROC_UNINIT;							// 设置了进程的状态为“初始”态，这表示进程已经 “出生”了，正在获取资源茁壮成长中；

    	proc->pid = -1;										// 未分配的进程pid是-1 先设置pid为无效值-1，用户调完alloc_proc函数后再根据实际情况设置pid。
															// 设置了进程的pid为-1，这表示进程的“身份证号”还没有办好；

    	proc->cr3 = boot_cr3;								// boot_cr3指向了uCore启动时建立好的内核虚拟空间的页目录表首地址
															// 表明由于该内核线程在内核中运行，故采用为uCore内核已经建立的页表，即设置为在uCore内核页表的起始地址boot_cr3。

    	proc->runs = 0;
		proc->kstack = 0;									// 记录了分配给该进程/线程的内核栈的位置
		proc->need_resched = 0;								// 是否需要调度
		proc->parent = NULL;								// 父进程
		proc->mm = 0;									// 虚拟内存结构体（lab4实验可忽略）
		/*
		 * void *memset(void *s, int c, unsigned long n)
		 * 函数解释：将s中当前位置后面的n个字节 （typedef unsigned int size_t ）用 ch 替换并返回 s
		 * 该函数用于清空一个结构体中所有的成员变量，下面解释三个参数：
		 * 第一个参数：位置指针，例如数组名、结构体首地址
		 * 第二个参数：替换为什么
		 * memset 函数的第三个参数 n 的值一般用 sizeof() 获取
		 */
		memset(&(proc->context), 0, sizeof(struct context)); 	// 上下文结构体
		proc->tf = NULL;

		proc->flags = 0;
		// 清空数组就不用sizeof了，第三个参数直接写数组的大小-1即可
		memset(proc->name, 0, PROC_NAME_LEN);


    }
    return proc;
}

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
    memset(proc->name, 0, sizeof(proc->name));
    return memcpy(proc->name, name, PROC_NAME_LEN);
}

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
    return memcpy(name, proc->name, PROC_NAME_LEN);
}

// get_pid - alloc a unique pid for process
// get_pid函数确保了新进程说分配的pid是唯一的 LAB4实验中的问题需要解答该函数是如何实现的唯一分配
static int
get_pid(void) {
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;

    // 两个静态变量 next_safe = MAX_PID, last_pid = MAX_PID; 指向最大可以分配的pid号码
    static int next_safe = MAX_PID, last_pid = MAX_PID;

    if (++ last_pid >= MAX_PID) {
        last_pid = 1;
        goto inside;
    }

    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
            proc = le2proc(le, list_link);
            if (proc->pid == last_pid) {
            	// 如果last_pid+1 后等于MAX_PID，意味着pid已经分配完了
                if (++ last_pid >= next_safe) {
                    // 如果last_pid超出最大pid范围，则last_pid重新从1开始编号
                	if (last_pid >= MAX_PID) {
                        last_pid = 1;
                    }
                    next_safe = MAX_PID;
                    // 重新编号去 现在 last_pid == 1; next_safe == MAX_PID;
                    goto repeat;
                }
            }
            // 上面的是需要重新编号的情况，下面是不需要的情况
            // 满足 last_pid < proc->pid < next_safe
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                // last_pid < proc->pid < next_safe
            	// last_pid < proc->pid
            	//			< next_safe
            	next_safe = proc->pid;
            }
        }
    }
    // last_pid作为新颁发的编号
    return last_pid;
}

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
	// current是当前正在运行的线程
	// proc是将要运行的线程
	/* 先判断下将要运行的线程是不是已经在运行中了 */
    if (proc != current) {
        bool intr_flag;
        // prev是当前正在执行的线程
        // next是准备要执行的线程
        struct proc_struct *prev = current, *next = proc;

        // 禁止中断 目的是事务的隔离性 不让其冲突
        local_intr_save(intr_flag);
        {
            current = proc;
            load_esp0(next->kstack + KSTACKSIZE);
            // 将当前的cr3寄存器修改为需要运行的线程（线程）的页目录表
            lcr3(next->cr3);
            // 开始执行（切换线程函数）
            switch_to(&(prev->context), &(next->context));
        }
        local_intr_restore(intr_flag);
    }
}

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
    forkrets(current->tf);
}

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
}

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
            struct proc_struct *proc = le2proc(le, hash_link);
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
}

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
    /*
     * 我们来分析一下创建内核线程的函数kernel_thread：
     */
	/* 采用了局部变量tf来放置保存内核线程的临时中断帧 */
	struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
    tf.tf_cs = KERNEL_CS;
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
    tf.tf_regs.reg_ebx = (uint32_t)fn;
    tf.tf_regs.reg_edx = (uint32_t)arg;
    tf.tf_eip = (uint32_t)kernel_thread_entry;
    /* 把中断帧的指针传递给do_fork函数，do_fork函数会调用copy_thread函数在新创建的进程内核栈上专门给进程的中断帧分配一块空间。 */
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
}

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
    struct Page *page = alloc_pages(KSTACKPAGE);
    if (page != NULL) {
        proc->kstack = (uintptr_t)page2kva(page);
        return 0;
    }
    return -E_NO_MEM;
}

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
}

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
    assert(current->mm == NULL);
    /* do nothing in this project */
    return 0;
}

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
    *(proc->tf) = *tf;
    proc->tf->tf_regs.reg_eax = 0;
    proc->tf->tf_esp = esp;
    proc->tf->tf_eflags |= FL_IF;

    proc->context.eip = (uintptr_t)forkret;
    proc->context.esp = (uintptr_t)(proc->tf);
}

/* do_fork -     parent process for a new child process
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
    }
    ret = -E_NO_MEM;
    //LAB4:EXERCISE2 YOUR CODE
    /*
     * Some Useful MACROs, Functions and DEFINEs, you can use them in below implementation.
     * MACROs or Functions:
     *   alloc_proc:   create a proc struct and init fields (lab4:exercise1)
     *   setup_kstack: alloc pages with size KSTACKPAGE as process kernel stack
     *   copy_mm:      process "proc" duplicate OR share process "current"'s mm according clone_flags
     *                 if clone_flags & CLONE_VM, then "share" ; else "duplicate"
     *   copy_thread:  setup the trapframe on the  process's kernel stack top and
     *                 setup the kernel entry point and stack of process
     *   hash_proc:    add proc into proc hash_list
     *   get_pid:      alloc a unique pid for process
     *   wakup_proc:   set proc->state = PROC_RUNNABLE
     * VARIABLES:
     *   proc_list:    the process set's list
     *   nr_process:   the number of process set
     */

    //    1. call alloc_proc to allocate a proc_struct
    //    2. call setup_kstack to allocate a kernel stack for child process
    //    3. call copy_mm to dup OR share mm according clone_flag
    //    4. call copy_thread to setup tf & context in proc_struct
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid

    /*
	 * 想干的事：创建当前内核线程的一个副本，它们的执行上下文、代码、数据都一样，但是存储位置不同，PID不同。
	 */
	// 调用alloc_proc() 为要创建的线程分配空间
	// 如果第一步 alloc 都失败的话，应该来说是比较严重的错误。直接退出。
	if ((proc = alloc_proc()) == NULL) {
		goto fork_out;
	}
	// 获取被拷贝的进程的pid号 即父进程的pid
	//proc->parent = current;
	// 分配大小为 KSTACKPAGE 的页面作为进程内核堆栈
	setup_kstack(proc);
	// 拷贝原进程的内存管理信息到新进程
	copy_mm(clone_flags, proc);
	// 拷贝原进程上下文到新进程
	copy_thread(proc, stack, tf);


	bool intr_flag;
	// 停止中断
	local_intr_save(intr_flag);
	// {} 用来限定花括号中变量的作用域，使其不影响外面。
	{
		proc->pid = get_pid();
		// 新进程添加到 hash方式组织的的进程链表，以便于以后对某个指定的线程的查找（速度更快）
		hash_proc(proc);
		// 将线程加入到所有线程的链表中，以便于调度
		list_add(&proc_list, &(proc->list_link));
		// 将全局线程的数目加1
		nr_process ++;
	}
	// 允许中断
	local_intr_restore(intr_flag);


	// 唤醒新进程
	wakeup_proc(proc);
	// 新进程号
	ret = proc->pid;

fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}

// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
    panic("process exit!!.\n");
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
    cprintf("To U: \"%s\".\n", (const char *)arg);
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
    return 0;
}

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
        list_init(hash_list + i);
    }

    /*
     * 第0个内核线程 -- idleproc
     * 把proc进行初步初始化（即把proc_struct中的各个成员变量清零）。但有些成员变量设置了特殊的值（这里是第一步初始化，后面还需要进一步初始化）
     * 第一步初始化可参考alloc_proc函数
     */
    if ((idleproc = alloc_proc()) == NULL) {
        panic("cannot alloc idleproc.\n");
    }

    // 进行进一步初始化
    idleproc->pid = 0;								// 给了idleproc合法的身份证号--0
    idleproc->state = PROC_RUNNABLE;				// 第二条语句改变了idleproc的状态，使得它从“出生”转到了“准备工作”，就差uCore调度它执行了。

    idleproc->kstack = (uintptr_t)bootstack;		// 第三条语句设置了idleproc所使用的内核栈的起始地址。
    												// 需要注意以后的其他线程的内核栈都需要通过分配获得，因为uCore启动时设置的内核栈直接分配给idleproc使用了。
    idleproc->need_resched = 1;						// 设置为1表示允许CPU对其调度（调走），执行完这个进程后，该干嘛干嘛。Ucore不希望它一直霸占CPU
    set_proc_name(idleproc, "idle");
    nr_process ++;

    current = idleproc;

    /*
     * kernel_thread函数创建了第1个内核线程init_main
     * 在实验四中，这个子内核线程的工作就是输出一些字符串，然后就返回了（参看init_main函数）。
     * 但在后续的实验中，init_main的工作就是创建特定的其他内核线程或用户进程（实验五涉及）。
     */
    int pid = kernel_thread(init_main, "Hello world!!", 0);
    if (pid <= 0) {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
    assert(initproc != NULL && initproc->pid == 1);
}

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
    while (1) {
    	// 只要current标志为need_resched（即：1），马上就调用schedule函数要求调度器切换其他进程执行。
        if (current->need_resched) {
            schedule();
            // 第0个内核线程主要工作是完成内核中各个子系统的初始化，然后就通过执行cpu_idle函数开始过退休生活了。所以uCore接下来还需创建其他进程来完成各种工作
        }
    }
}
