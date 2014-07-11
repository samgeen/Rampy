# 1D
make clean
make -f Makefile.1d
f2py -m ramses1d ../patch/rampy/ramses.f90 -h ramses1d.pyf --overwrite-signature
f2py -lgfortran -c *.o ramses1d.pyf
# 2D
make clean
make -f Makefile.2d
f2py -m ramses2d ../patch/rampy/ramses.f90 -h ramses2d.pyf --overwrite-signature
f2py -lgfortran -c *.o ramses2d.pyf
# 3D
make clean
make -f Makefile
f2py -m ramses3d ../patch/rampy/ramses.f90 -h ramses3d.pyf --overwrite-signature
f2py -lgfortran -c *.o ramses3d.pyf