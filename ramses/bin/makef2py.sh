f2py -m ramses -h ramses.pyf ../amr/ramses.f90 
f2py -lgfortran -c ramses.pyf *.o