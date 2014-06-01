program icdegrade
  implicit none

  integer::i1,i2,i3,i,j,k,narg,iargc,i_file
  integer(kind=4)::np1,np2,np3
  integer(kind=4)::np1o2,np2o2,np3o2
  real::dx,dx2,x1o,x2o,x3o,astart,omegam,omegav,h0
  real,dimension(:,:,:),allocatable::f,f2
  character*80::input,output
  character*80,dimension(2)::filename
  logical::ok

  narg = iargc()
  IF(narg .NE. 2)THEN
     write(*,*)'You should type: a.out input output'
     write(*,*)'where directory input should contain GRAFIC files'
     write(*,*)'and directory output should be empty'
     !HACK - REPLACED STOP WITH NON-LETHAL ALTERNATIVE
     !AUTOHACKED BY stopskimmer.py
     call clean_stop     !HACK ENDS
  END IF

  CALL getarg(1,input)
  CALL getarg(2,output)

  !  SAFETY CONDITION
  if (input == output) then 
     write(*,*)'If input and output directories are the same'
     write(*,*)'input files will be erased by output ones'
     write(*,*)'so type DIFFERENT directories !!!!'
     !HACK - REPLACED STOP WITH NON-LETHAL ALTERNATIVE
     !AUTOHACKED BY stopskimmer.py
     call clean_stop     !HACK ENDS
  endif

  ! READING INPUT FILES
  filename(1) =TRIM(input)//'/ic_refmap'
  filename(2) =TRIM(output)//'/ic_refmap'
  INQUIRE(file=filename(1),exist=ok)
  if(ok)then

     open(10,file=filename(1),form='unformatted')
     read (10)np1,np2,np3,dx,x1o,x2o,x3o,astart,omegam,omegav,h0
     close(10)
     write(*,*)'Input array size is:',np1,np2,np3
     allocate(f(np1,np2,1:2))
     allocate(f2(np1/2,np2/2,1:1))
     
     np1o2=np1/2
     np2o2=np2/2
     np3o2=np3/2
     dx2=2.*dx
     
     write(*,*)'Reading input file '//TRIM(filename(1))
     open(10,file=filename(1),form='unformatted')
     rewind(10)
     read (10)np1,np2,np3,dx,x1o,x2o,x3o,astart,omegam,omegav,h0
     
     write(*,*)'Writing ouput file '//TRIM(filename(2))
     open(11,file=filename(2),form='unformatted')
     rewind 11
     write (11)np1o2,np2o2,np3o2,dx2,x1o,x2o,x3o,astart,omegam,omegav,h0
     
     write(*,*)'Degrading initial conditions...'
     
     ! Loop over planes
     do i3=1,np3,2
        
        ! READING INPUT DATA
        read(10) ((f(i1,i2,1),i1=1,np1),i2=1,np2)
        read(10) ((f(i1,i2,2),i1=1,np1),i2=1,np2)
        
        !  DEGRADING INITIAL CONDITIONS
        do i1=1,np1o2
           do i2=1,np2o2
              i=i1-1
              j=i2-1
              f2(i1,i2,1)=max(f(2*i+1,2*j+1,1),f(2*i+2,2*j+1,1),f(2*i+1,2*j+2,1),f(2*i+1,2*j+1,2), &
                   &          f(2*i+2,2*j+2,1),f(2*i+1,2*j+2,2),f(2*i+2,2*j+1,2),f(2*i+2,2*j+2,2))
           end do
        end do
        
        !   WRITING OUTPUT FILES     
        write(11) ((f2(i1,i2,1),i1=1,np1o2),i2=1,np2o2)
        
     enddo
     
     close(10)
     close(11)
     write(*,*)'done'
     
     deallocate(f)
     deallocate(f2)
  endif

  filename(1) =TRIM(input)//'/ic_pvar_00001'
  filename(2) =TRIM(output)//'/ic_pvar_00001'
  INQUIRE(file=filename(1),exist=ok)
  if(ok)then

     open(10,file=filename(1),form='unformatted')
     read (10)np1,np2,np3,dx,x1o,x2o,x3o,astart,omegam,omegav,h0
     close(10)
     write(*,*)'Input array size is:',np1,np2,np3
     allocate(f(np1,np2,1:2))
     allocate(f2(np1/2,np2/2,1:1))
     
     np1o2=np1/2
     np2o2=np2/2
     np3o2=np3/2
     dx2=2.*dx
     
     write(*,*)'Reading input file '//TRIM(filename(1))
     open(10,file=filename(1),form='unformatted')
     rewind(10)
     read (10)np1,np2,np3,dx,x1o,x2o,x3o,astart,omegam,omegav,h0
     
     write(*,*)'Writing ouput file '//TRIM(filename(2))
     open(11,file=filename(2),form='unformatted')
     rewind 11
     write (11)np1o2,np2o2,np3o2,dx2,x1o,x2o,x3o,astart,omegam,omegav,h0
     
     write(*,*)'Degrading initial conditions...'
     
     ! Loop over planes
     do i3=1,np3,2
        
        ! READING INPUT DATA
        read(10) ((f(i1,i2,1),i1=1,np1),i2=1,np2)
        read(10) ((f(i1,i2,2),i1=1,np1),i2=1,np2)
        
        !  DEGRADING INITIAL CONDITIONS
        do i1=1,np1o2
           do i2=1,np2o2
              i=i1-1
              j=i2-1
              f2(i1,i2,1)=max(f(2*i+1,2*j+1,1),f(2*i+2,2*j+1,1),f(2*i+1,2*j+2,1),f(2*i+1,2*j+1,2), &
                   &          f(2*i+2,2*j+2,1),f(2*i+1,2*j+2,2),f(2*i+2,2*j+1,2),f(2*i+2,2*j+2,2))
           end do
        end do
        
        !   WRITING OUTPUT FILES     
        write(11) ((f2(i1,i2,1),i1=1,np1o2),i2=1,np2o2)
        
     enddo
     
     close(10)
     close(11)
     write(*,*)'done'
     
     deallocate(f)
     deallocate(f2)

  endif

  
end program icdegrade
   

       

