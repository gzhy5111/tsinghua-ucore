#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_extended_clock.h>
#include <list.h>

list_entry_t pra_list_head;

static int
_extended_clock_init_mm(struct mm_struct *mm)
{
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}

static int
_extended_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);
    assert(entry != NULL && head != NULL);

    list_add(head, entry);
    // 初始访问位和修改位均置0
    struct Page *ptr = le2page(entry, pra_page_link);
    pte_t *pte = get_pte(mm -> pgdir, ptr -> pra_vaddr, 0);
    // 将PTE_A（访问位）和PTE_D（读写位）置0
    *pte &= ~PTE_D;
    *pte &= ~PTE_A;
    return 0;
}


static int
_extended_clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
	// 两个指针，一个指向头，一个指向尾
    list_entry_t *head = (list_entry_t*)mm->sm_priv;
    assert(head != NULL);
    assert(in_tick == 0);
    list_entry_t *tail = head->prev;
    assert(head != tail);

    // 怎么实现指针旋转的？答案是通过tail指针不断向前移动，直到tail == head时终止
    // 实现extended clock算法（参考：《现代操作系统P115页》）
    int i;
    for (i = 0; i < 3; i ++) {
        while (tail != head) {
            struct Page *page = le2page(tail, pra_page_link);
            pte_t *ptep = get_pte(mm->pgdir, page->pra_vaddr, 0);

            // 第一类情况 访问位和修改位都是0 意味着没有访问也没有被修改 应最先被置换出去，该置换函数也只将第一类情况置换出去
            if (!(*ptep & PTE_A) && !(*ptep & PTE_D)) {
                list_del(tail);
                *ptr_page = page;
                return 0;
            }
            // (PTE_D, PTE_A) = 1, 0或者是0, 1
            if ((*ptep & PTE_A) ^ (*ptep & PTE_D)) {
                // 访问位和修改位都置0,可参考word笔记
            	*ptep &= ~PTE_D;
                *ptep &= ~PTE_A;
            }
            // (PTE_D, PTE_A) = (1,1)
            if ((*ptep & PTE_A) && (*ptep & PTE_D)) {
            	// 访问了 所以访问位要置0
                *ptep &= ~PTE_A;
            }
            tail = tail->prev;
        }
        tail = tail->prev;
    }
}

static int
_extended_clock_check_swap(void) {
    cprintf("write Virt Page c in extended_clock_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==4);
    cprintf("write Virt Page a in extended_clock_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==4);
    cprintf("write Virt Page d in extended_clock_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==4);
    cprintf("write Virt Page b in extended_clock_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==4);
    cprintf("write Virt Page e in extended_clock_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==5);
    cprintf("write Virt Page b in extended_clock_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==5);
    cprintf("write Virt Page a in extended_clock_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==6);
    cprintf("write Virt Page b in extended_clock_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==6);
    cprintf("write Virt Page c in extended_clock_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==7);
    cprintf("write Virt Page d in extended_clock_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==8);
    return 0;
}

static int
_extended_clock_init(void)
{
    return 0;
}

static int
_extended_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_extended_clock_tick_event(struct mm_struct *mm)
{ return 0; }


struct swap_manager swap_manager_extended_clock =
{
     .name            = "extended clock swap manager",
     .init            = &_extended_clock_init,
     .init_mm         = &_extended_clock_init_mm,
     .tick_event      = &_extended_clock_tick_event,
     .map_swappable   = &_extended_clock_map_swappable,
     .set_unswappable = &_extended_clock_set_unswappable,
     .swap_out_victim = &_extended_clock_swap_out_victim,
     .check_swap      = &_extended_clock_check_swap,
};
