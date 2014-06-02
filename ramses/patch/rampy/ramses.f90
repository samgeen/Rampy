! HACKED TO ALLOW JUMPING OUT WITHOUT HARD STOPPING PROGRAM

module data
  use pm_commons
  implicit none
!f2py   real(dp),allocatable,dimension(:,:)::xp       ! Positionsr
!f2py   real(dp),allocatable,dimension(:,:)::vp       ! Velocities
!f2py   real(dp),allocatable,dimension(:)  ::mp       ! Masses
!f2py   real(dp),allocatable,dimension(:)  ::tp       ! Birth epoch

end module data

subroutine init
  !f2py threadsafe
  call set_jump_init
end subroutine init

subroutine step
  !f2py threadsafe
  call set_jump_step
end subroutine step
