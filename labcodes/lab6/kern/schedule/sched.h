#ifndef __KERN_SCHEDULE_SCHED_H__
#define __KERN_SCHEDULE_SCHED_H__

#include <defs.h>
#include <list.h>
#include <skew_heap.h>

#define MAX_TIME_SLICE 20

struct proc_struct;

typedef struct {
    unsigned int expires;       //the expire time
    struct proc_struct *proc;   //the proc wait in this timer. If the expire time is end, then this proc will be scheduled
    list_entry_t timer_link;    //the timer list
} timer_t;

#define le2timer(le, member)            \
to_struct((le), timer_t, member)

// init a timer
static inline timer_t *
timer_init(timer_t *timer, struct proc_struct *proc, int expires) {
    timer->expires = expires;
    timer->proc = proc;
    list_init(&(timer->timer_link));
    return timer;
}

struct run_queue;

// The introduction of scheduling classes is borrrowed from Linux, and makes the 
// core scheduler quite extensible. These classes (the scheduler modules) encapsulate 
// the scheduling policies（策略）.
// 调度类
struct sched_class {
    // 调度器名字
    const char *name;
    // 初始化就绪队列
    void (*init)(struct run_queue *rq);
    // 入队：将进程放入就绪队列中, and this function must be called with rq_lock（lock与lab7有关）
    void (*enqueue)(struct run_queue *rq, struct proc_struct *proc);
    // 出队：and this function must be called with rq_lock
    void (*dequeue)(struct run_queue *rq, struct proc_struct *proc);
    // 切换：选择下一个可运行的任务
    struct proc_struct *(*pick_next)(struct run_queue *rq);
    // dealer of the time-tick
    // 产生一次时钟中断就会调用该函数
    void (*proc_tick)(struct run_queue *rq, struct proc_struct *proc);
    /* for SMP support in the future
     *  load_balance
     *     void (*load_balance)(struct rq* rq);
     *  get some proc from this rq, used in load_balance,
     *  return value is the num of gotten proc
     *  int (*get_proc)(struct rq* rq, struct proc* procs_moved[]);
     */
};

// 就绪队列
struct run_queue {
    list_entry_t run_list;
    unsigned int proc_num;
    int max_time_slice;
    // For LAB6 ONLY
    skew_heap_entry_t *lab6_run_pool;
};

void sched_init(void);
void wakeup_proc(struct proc_struct *proc);
void schedule(void);
void add_timer(timer_t *timer);     // add timer to timer_list
void del_timer(timer_t *timer);     // del timer from timer_list
void run_timer_list(void);          // call scheduler to update tick related info, and check the timer is expired? If expired, then wakup proc

#endif /* !__KERN_SCHEDULE_SCHED_H__ */

