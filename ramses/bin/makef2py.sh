f2py -m rampy -h rampy.pyf ../amr/ramses.f90 
f2py -lgfortran -c *.o rampy.pyf