#include <defs.h>
#include <list.h>
#include <proc.h>
#include <assert.h>
#include <default_sched.h>

#define USE_SKEW_HEAP 1			// 用于条件编译，为1代表使用斜堆，为0代表使用双向链表。

/* You should define the BigStride constant here*/
/* LAB6: YOUR CODE */
// 这里设置BigStride即最大步。
#define BIG_STRIDE 0x7fffffff    /* you should give a value, and is ??? */

/* The compare function for two skew_heap_node_t's and the
 * corresponding procs*/
static int
proc_stride_comp_f(void *a, void *b)
{
     struct proc_struct *p = le2proc(a, lab6_run_pool);
     struct proc_struct *q = le2proc(b, lab6_run_pool);
     int32_t c = p->lab6_stride - q->lab6_stride;
     if (c > 0) return 1;
     else if (c == 0) return 0;
     else return -1;
}

// 1. 初始化
/*
 * stride_init initializes the run-queue rq with correct assignment for
 * member variables, including:
 *
 *   - run_list: should be a empty list after initialization.
 *   - lab6_run_pool: NULL
 *   - proc_num: 0
 *   - max_time_slice: no need here, the variable would be assigned by the caller.
 *
 * hint: see libs/list.h for routines of the list structures.
 */
static void
stride_init(struct run_queue *rq) {
     /* LAB6: YOUR CODE
      * (1) init the ready process list: rq->run_list
      * (2) init the run pool: rq->lab6_run_pool
      * (3) set number of process: rq->proc_num to 0
      */
	list_init(&(rq->run_list));			// 初始化队列
	rq->lab6_run_pool = NULL;
	rq->proc_num = 0;					// 当前进程个数
}

// 2. 进队
/*
 * stride_enqueue inserts the process ``proc'' into the run-queue
 * ``rq''. The procedure should verify/initialize the relevant members
 * of ``proc'', and then put the ``lab6_run_pool'' node into the
 * queue(since we use priority queue here). The procedure should also
 * update the meta date in ``rq'' structure.
 *
 * proc->time_slice denotes the time slices allocation for the
 * process, which should set to rq->max_time_slice.
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static void
stride_enqueue(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: YOUR CODE
      * (1) insert the proc into rq correctly
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_insert: insert a entry into skew_heap
      *         list_add_before: insert  a entry into the last of list
      * (2) recalculate proc->time_slice
      * (3) set proc->rq pointer to rq
      * (4) increase rq->proc_num
      */

	//list_add_before(&(rq->run_list), &(proc->run_link));				// 将进程插入到队列
	// 这里我们用斜堆，不用双向链表。
#if USE_SKEW_HEAP
	rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
#else
#endif
    // 对该进程（proc）的其他参数做调整
	if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
		proc->time_slice = rq->max_time_slice;							// 初始化步长设置为最大时间片
	}

	proc->rq = rq;
	rq->proc_num ++;
}

// 3. 出队
/*
 * stride_dequeue removes the process ``proc'' from the run-queue
 * ``rq'', the operation would be finished by the skew_heap_remove
 * operations. Remember to update the ``rq'' structure.
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static void
stride_dequeue(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: YOUR CODE
      * (1) remove the proc from rq correctly
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_remove: remove a entry from skew_heap
      *         list_del_init: remove a entry from the  list
      */
	// skew_heap是一种新的数据结构——斜堆，当然你也可以用双向链表。这里我们尝试下斜堆这个数据结构。
#if USE_SKEW_HEAP
	// 通过比较，可以找到当前最合适的进程。即stride最小的进程。
	rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);				// 供后面的 le2proc 函数使用，作为一个参数。
#else
#endif
	rq->proc_num --;
}

// 4. 选择
/*
 * stride_pick_next pick the element from the ``run-queue'', with the
 * minimum value of stride, and returns the corresponding process
 * pointer. The process pointer would be calculated by macro le2proc,
 * see kern/process/proc.h for definition. Return NULL if
 * there is no process in the queue.
 *
 * When one proc structure is selected, remember to update the stride
 * property of the proc. (stride += BIG_STRIDE / priority)
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static struct proc_struct *
stride_pick_next(struct run_queue *rq) {
     /* LAB6: YOUR CODE
      * (1) get a  proc_struct pointer p  with the minimum value of stride
             (1.1) If using skew_heap, we can use le2proc get the p from rq->lab6_run_poll
             (1.2) If using list, we have to search list to find the p with minimum stride value
      * (2) update p;s stride value: p->lab6_stride
      * (3) return p
      */
	// 算法核心：先扫描整个运行队列，返回其中stride值最小的对应进程p。然后更新对应进程的stride值，将步长设置为优先级的倒数，如果为0则设置为最大的步长。

#if USE_SKEW_HEAP
	// 1)先建立一个游标指针p，指向已经被上一个函数 skew_heap_remove 已经被选择好的进程 lab6_run_pool。
	struct proc_struct *p = le2proc(rq->lab6_run_pool, lab6_run_pool);
	// 现在，p指向的进程是 stride 值最小的进程。
#else
#endif
	// 如果优先级为0，则步长设置为最大。
	if (p->lab6_priority == 0) {
		// 更新对应进程的步长值，将步长设置为优先级的倒数，如果为0则设置为最大的步长。
		p->lab6_stride += BIG_STRIDE;
	}
	else {
		// pass与优先级之间的关系
		uint32_t pass = BIG_STRIDE / p->lab6_priority;
		// 执行长度是当前步长+pass
		p->lab6_stride += pass;
	}
	return p;
}

// 5. 处理时钟，改变 need_resched
/*
 * stride_proc_tick works with the tick event of current process. You
 * should check whether the time slices for current process is
 * exhausted and update the proc struct ``proc''. proc->time_slice
 * denotes the time slices left for current
 * process. proc->need_resched is the flag variable for process
 * switching.
 */
static void
stride_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: YOUR CODE */
	// 经历一次时钟中断后还未完成进程
	if (proc->time_slice > 0) {
		proc->time_slice --;
	}
	// 如果用完了时间片，它就可以被调走了。
	if (proc->time_slice == 0)
	proc->need_resched = 1;
}

struct sched_class default_sched_class = {
     .name = "stride_scheduler",
     .init = stride_init,
     .enqueue = stride_enqueue,
     .dequeue = stride_dequeue,
     .pick_next = stride_pick_next,
     .proc_tick = stride_proc_tick,
};
