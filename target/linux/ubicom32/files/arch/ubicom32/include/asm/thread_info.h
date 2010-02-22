/*
 * arch/ubicom32/include/asm/thread_info.h
 *   Ubicom32 architecture low-level thread information.
 *
 * (C) Copyright 2009, Ubicom, Inc.
 * Adapted from the i386 and PPC versions by Greg Ungerer (gerg@snapgear.com)
 * Copyright (C) 2002  David Howells (dhowells@redhat.com)
 * - Incorporating suggestions made by Linus Torvalds and Dave Miller
 *
 * This file is part of the Ubicom32 Linux Kernel Port.
 *
 * The Ubicom32 Linux Kernel Port is free software: you can redistribute
 * it and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 2 of the
 * License, or (at your option) any later version.
 *
 * The Ubicom32 Linux Kernel Port is distributed in the hope that it
 * will be useful, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
 * the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with the Ubicom32 Linux Kernel Port.  If not,
 * see <http://www.gnu.org/licenses/>.
 *
 * Ubicom32 implementation derived from (with many thanks):
 *   arch/m68knommu
 *   arch/blackfin
 *   arch/parisc
 */

#ifndef _ASM_UBICOM32_THREAD_INFO_H
#define _ASM_UBICOM32_THREAD_INFO_H

#include <asm/page.h>

/*
 * Size of kernel stack for each process. This must be a power of 2...
 */
#ifdef CONFIG_4KSTACKS
#define THREAD_SIZE_ORDER (0)
#else
#define THREAD_SIZE_ORDER (1)
#endif

/*
 * for asm files, THREAD_SIZE is now generated by asm-offsets.c
 */
#define THREAD_SIZE (PAGE_SIZE<<THREAD_SIZE_ORDER)

#ifdef __KERNEL__

#ifndef __ASSEMBLY__

/*
 * low level task data.
 */
struct thread_info {
	struct task_struct *task;		/* main task structure */
	struct exec_domain *exec_domain;	/* execution domain */
	unsigned long	   flags;		/* low level flags */
	int		   cpu;			/* cpu we're on */
	int		   preempt_count;	/* 0 => preemptable, <0 => BUG */
	int		   interrupt_nesting; 	/* Interrupt nesting level. */
	struct restart_block restart_block;
};

/*
 * macros/functions for gaining access to the thread information structure
 */
#define INIT_THREAD_INFO(tsk)			\
{						\
	.task		= &tsk,			\
	.exec_domain	= &default_exec_domain,	\
	.flags		= 0,			\
	.cpu		= 0,			\
	.interrupt_nesting	= 0,		\
	.restart_block	= {			\
		.fn = do_no_restart_syscall,	\
	},					\
}

#define init_thread_info	(init_thread_union.thread_info)
#define init_stack		(init_thread_union.stack)


/* how to get the thread information struct from C */
static inline struct thread_info *current_thread_info(void)
{
	struct thread_info *ti;

	asm (
		"and.4	%0, sp, %1\n\t"
		: "=&r" (ti)
		: "d" (~(THREAD_SIZE-1))
		: "cc"
	);

	return ti;
}

#define STACK_WARN (THREAD_SIZE / 8)

#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR 1

/* thread information allocation */
#define alloc_thread_info(tsk) ((struct thread_info *) \
				__get_free_pages(GFP_KERNEL, THREAD_SIZE_ORDER))
#define free_thread_info(ti)	free_pages((unsigned long) (ti), THREAD_SIZE_ORDER)
#endif /* __ASSEMBLY__ */

#define	PREEMPT_ACTIVE	0x4000000

/*
 * thread information flag bit numbers
 */
#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
#define TIF_SIGPENDING		1	/* signal pending */
#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
#define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
					   TIF_NEED_RESCHED */
#define TIF_MEMDIE		4

/* as above, but as bit values */
#define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
#define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
#define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
#define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)

#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */

#endif /* __KERNEL__ */

#endif /* _ASM_UBICOM32_THREAD_INFO_H */
