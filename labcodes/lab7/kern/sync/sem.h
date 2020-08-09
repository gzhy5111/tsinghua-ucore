#ifndef __KERN_SYNC_SEM_H__
#define __KERN_SYNC_SEM_H__

#include <defs.h>
#include <atomic.h>
#include <wait.h>

// 信号量结构体
typedef struct {
    int value;					// 信号量的值，类比抢票这个事务中的火车票余票数量
    wait_queue_t wait_queue;	// 等待队列
} semaphore_t;

void sem_init(semaphore_t *sem, int value);
// 信号量中的v操作
void up(semaphore_t *sem);
// 相当于信号量中的P操作，类比抢票
void down(semaphore_t *sem);
bool try_down(semaphore_t *sem);

#endif /* !__KERN_SYNC_SEM_H__ */

