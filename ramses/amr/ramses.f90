! HACKED TO ALLOW JUMPING OUT WITHOUT HARD STOPPING PROGRAM

program ramses
  !f2py threadsafe
  ! HACK - ALLOWS REPLACEMENT OF STOP STATEMENT
  ! set_jump in clean_stop.c calls run_ramses (below)
  ! If long_jump is called, the program will pull the stack back up to
  !   set_jump, which will return without re-calling run_ramses
  call set_jump
end program ramses

subroutine run
  !f2py threadsafe
  call set_jump
end subroutine run

subroutine run_ramses_SETJUMP
  !f2py threadsafe
  ! Read run parameters
  call read_params
  
  ! Start time integration
  call init_sim
  return
end subroutine run_ramses_SETJUMP


