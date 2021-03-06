! HACKED TO ALLOW JUMPING OUT WITHOUT HARD STOPPING PROGRAM

module data
  use pm_commons
  use amr_commons,only:units_density,units_time,units_length,xg,ngrid_current
  use hydro_commons,only:uold
  implicit none
! PARTICLE DATA
!f2py   real(kind=8),allocatable,dimension(:,:)::xp       ! Positions
!f2py   real(kind=8),allocatable,dimension(:,:)::vp       ! Velocities
!f2py   real(kind=8),allocatable,dimension(:)  ::mp       ! Masses
!f2py   real(kind=8),allocatable,dimension(:)  ::tp       ! Birth epoch
! UNITS DATA (RAW VALUES ONLY)
!f2py   real(kind=8)::units_density
!f2py   real(kind=8)::units_time
!f2py   real(kind=8)::units_length
! AMR DATA
!f2py   integer::ngrid_current
!f2py   real(kind=8),allocatable,dimension(:,:)::xg       ! Positions
! HYDRO DATA
!f2py   real(kind=8),allocatable,dimension(:,:)::uold     ! Hydro vars

contains
  subroutine init
    !f2py threadsafe
    call set_jump_init
  end subroutine init
    
  subroutine step
    !f2py threadsafe
    call set_jump_step
  end subroutine step

end module data
