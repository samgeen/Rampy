#include <stdio.h>
#include <setjmp.h>

static jmp_buf buf;

void run_ramses_setjump_();
void read_params_();
void init_sim_();
void sim_step_();

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

int set_jump_init_()
{
  if(!setjmp(buf))
  {
    read_params_();
    init_sim_();
  }
}

int set_jump_step_()
{
  if(!setjmp(buf))
  {
    sim_step_();
  }
}
