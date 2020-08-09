#include <defs.h>
#include <wait.h>
#include <atomic.h>
#include <kmalloc.h>
#include <sem.h>
#include <proc.h>
#include <sync.h>
#include <assert.h>

void
sem_init(semaphore_t *sem, int value) {
    sem->value = value;
    wait_queue_init(&(sem->wait_queue));
}

// 信号年量的V操作， Thread B干的事情
static __noinline void __up(semaphore_t *sem, uint32_t wait_state) {
    // 临界区
	bool intr_flag;
    local_intr_save(intr_flag);
    {
    	// 如果等待队列为空，就说明没有等待唤醒的进程。所以直接让信号量的值+1
        wait_t *wait;
        if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {
            sem->value ++;
        }
        // 反之，有等待激活的进程，就要去告知它。
        else {
            assert(wait->proc->wait_state == wait_state);
            wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);	// 唤醒等待队列 即Thread A
        }
    }
    local_intr_restore(intr_flag);
    // 临界区
}

static __noinline uint32_t __down(semaphore_t *sem, uint32_t wait_state) {
    // 临界区 start
	bool intr_flag;
    local_intr_save(intr_flag);
    // 如果信号量还有（>0），就表示可以正常使用资源，不需要等待。
    if (sem->value > 0) {
        sem->value --;
        local_intr_restore(intr_flag);
        return 0;
    }
    // 如果信号量没有了，就需要将自身进程休眠，等待Thread B唤醒
    wait_t __wait, *wait = &__wait;							// 将进程休眠
    wait_current_set(&(sem->wait_queue), wait, wait_state);	// 将当前进程 Thread A 放入等待队列。
    local_intr_restore(intr_flag);
    // 临界区 over

    schedule();	// 休眠后，执行调度，允许调度器唤醒任意一个处在sleep状态的进程。

    local_intr_save(intr_flag);
    wait_current_del(&(sem->wait_queue), wait);		// 函数的作用是不断的扫描等待队列，发现合适机会（在信号量中是指信号量 >0）就唤醒Thread A进程（就是刚才让其休眠的进程）
    local_intr_restore(intr_flag);

    // 如果被唤醒的进程的唤醒原因和休眠原因不同，就交给上层应用去判断。看究竟是合理的还是存错误，这不是我们在同步机制中研究的问题。
    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
}

void
up(semaphore_t *sem) {
    __up(sem, WT_KSEM);
}

void
down(semaphore_t *sem) {
    uint32_t flags = __down(sem, WT_KSEM);
    assert(flags == 0);
}

bool
try_down(semaphore_t *sem) {
    bool intr_flag, ret = 0;
    local_intr_save(intr_flag);
    if (sem->value > 0) {
        sem->value --, ret = 1;
    }
    local_intr_restore(intr_flag);
    return ret;
}

