/*
 *
 * tinythreads.h
 *
 */

struct thread_block;
typedef struct thread_block *thread;
void spawn(void (*code)(int), int arg);
void yield(void);

struct mutex_block {
    int locked;
    thread waitQ;
};
typedef struct mutex_block mutex;

#define MUTEX_INIT {0,0}
void lock(mutex *m);
void unlock(mutex *m);
