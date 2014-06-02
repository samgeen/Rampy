f2py -m rampy ../patch/rampy/ramses.f90 -h rampy.pyf --overwrite-signature
#f2py -m rampy -h rampy.pyf ../amr/ramses.f90 
f2py -lgfortran -c *.o rampy.pyf