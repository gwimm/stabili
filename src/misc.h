# ifndef   __MISC_H__
# define   __MISC_H__

# define align(x) __attribute__((aligned(x)))
# define section(x) __attribute__((section(x)))
# define packed __attribute__((packed))
# define noreturn __attribute__((noreturn))
# define function_alias(old, new) \
    typeof(old) new = old;

# define true 1
# define false 0

# endif // __MISC_H__