#include <stdio.h>
#include <setjmp.h>

static jmp_buf buf;

void run_ramses_setjump_();

void long_jump_()
{
  longjmp(buf,1);
}

int set_jump_()
{
  if(!setjmp(buf))
  {
    run_ramses_setjump_();
  }
}
