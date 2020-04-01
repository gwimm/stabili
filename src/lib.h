# ifndef   __LIB_H__
# define   __LIB_H__

# include "intdef.h"
# include "misc.h"

usize str_len(i8*);
void *mem_mov(void *dst, const void *src, u64 len);

usize k_fmt(const i8*, ...);
noreturn void halt(void);

# endif // __LIB_H__