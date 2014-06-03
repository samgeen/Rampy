f2py -m ramses ../patch/rampy/ramses.f90 -h ramses.pyf --overwrite-signature
#f2py -m rampy -h rampy.pyf ../amr/ramses.f90 
f2py -lgfortran -c *.o ramses.pyf