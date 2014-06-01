!#########################################################
!#########################################################
!#########################################################
!#########################################################
subroutine rho_ana(x,d,dx,ncell)
  use amr_parameters
  use hydro_parameters
  use poisson_parameters
  implicit none
  integer ::ncell                         ! Number of cells
  real(dp)::dx                            ! Cell size
  real(dp),dimension(1:nvector)       ::d ! Density
  real(dp),dimension(1:nvector,1:ndim)::x ! Cell center position.
  !================================================================
  ! This routine generates analytical Poisson source term.
  ! Positions are in user units:
  ! x(i,1:3) are in [0,boxlen]**ndim.
  ! d(i) is the density field in user units.
  !================================================================
  integer::i
  real(dp)::emass,xmass,ymass,zmass,rr,rx,ry,rz
  real(dp)::v200,c,spin,fgas,dnfw,dmax

  emass=2.*boxlen*0.5d0**nlevelmax
  xmass=boxlen/2.0
  ymass=boxlen/2.0
  zmass=boxlen/2.0

  v200=gravity_params(1)
  c   =gravity_params(2)
  fgas=gravity_params(3)
  dmax=1.0/emass/(1.0+emass)**2

  do i=1,ncell
     rx=x(i,1)-xmass
     ry=x(i,2)-ymass
     rz=x(i,3)-zmass
     rr=sqrt(rx**2+ry**2+rz**2)
     dnfw=1d0/rr/(1d0+rr)**2
     dnfw=MIN(dmax,dnfw)
     dnfw=MAX(dnfw,1d-15)
     d(i)=(1d0-fgas)*dnfw
  end do

end subroutine rho_ana
