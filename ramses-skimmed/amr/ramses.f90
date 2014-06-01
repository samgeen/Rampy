! HACKED TO ALLOW JUMPING OUT WITHOUT HARD STOPPING PROGRAM

program ramses
  ! HACK - ALLOWS REPLACEMENT OF STOP STATEMENT
  ! set_jump in clean_stop.c calls run_ramses (below)
  ! If long_jump is called, the program will pull the stack back up to
  !   set_jump, which will return without re-calling run_ramses
  call set_jump
end program ramses

subroutine run
  call set_jump
end subroutine run

subroutine run_ramses_SETJUMP
  ! Read run parameters
  call read_params
  
  ! Start time integration
  call adaptive_loop
  return
end subroutine run_ramses_SETJUMP


