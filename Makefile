#############################################################################
# If you have problems with this makefile, contact Romain.Teyssier@cea.fr
#############################################################################
# Compilation time parameters
NVECTOR = 64
NDIM = 3
NPRE = 8
NVAR = 6
SOLVER = hydro
PATCH =
EXEC = ramses
ATON_FLAGS = #-DATON  # Uncomment to enable ATON.
DEFINES = -DNVECTOR=$(NVECTOR) -DNDIM=$(NDIM) -DNPRE=$(NPRE) -DNVAR=$(NVAR) -DSOLVER$(SOLVER) $(ATON_FLAGS)
#############################################################################
# Fortran compiler options and directives

# --- No MPI, gfortran -------------------------------
F90 = gfortran -O3 -frecord-marker=4 -ffree-line-length-none -fPIC
FFLAGS = -x f95-cpp-input $(DEFINES) -DWITHOUTMPI

# --- No MPI, tau ----------------------------------
#F90 = tau_f90.sh -optKeepFiles -optPreProcess -optCPPOpts=$(DEFINES) -DWITHOUTMPI

# --- No MPI, pgf90 ----------------------------------
#F90 = pgf90
#FFLAGS = -Mpreprocess $(DEFINES) -DWITHOUTMPI

# --- No MPI, xlf ------------------------------------
#F90 = xlf
#FFLAGS = -WF,-DNDIM=$(NDIM),-DNPRE=$(NPRE),-DNVAR=$(NVAR),-DSOLVER$(SOLVER),-DWITHOUTMPI -qfree=f90 -qsuffix=f=f90 -qsuffix=cpp=f90

# --- No MPI, f90 ------------------------------------
#F90 = f90
#FFLAGS = -cpp $(DEFINES) -DWITHOUTMPI

# --- No MPI, ifort ----------------------------------
#F90 = ifort
#FFLAGS = -cpp $(DEFINES) -DWITHOUTMPI

# --- MPI, gfortran syntax ------------------------------
#F90 = mpif90 -frecord-marker=4 -O3 -ffree-line-length-none -g -fbacktrace 
#FFLAGS = -x f95-cpp-input $(DEFINES)

# --- MPI, pgf90 syntax ------------------------------
#F90 = mpif90 -O3
#FFLAGS = -Mpreprocess $(DEFINES)

# --- MPI, ifort syntax ------------------------------
#F90 = mpif90
#FFLAGS = -cpp $(DEFINES) -DNOSYSTEM

# --- MPI, ifort syntax, additional checks -----------
#F90 = mpif90
#FFLAGS = -O3 -g -cpp -fbacktrace -fcheck=bounds -ffree-line-length-none $(DEFINES) #-DRT #-DNOSYSTEM

# --- MPI, ifort syntax ------------------------------
#F90 = ftn
#FFLAGS = -fpp -fast $(DEFINES) -DNOSYSTEM #-DRT 

# --- MPI, ifort syntax, additional checks -----------
#F90 = ftn
#FFLAGS = -O3 -g -traceback -fpe0 -ftrapuv -cpp $(DEFINES) -DNOSYSTEM #-DRT

#############################################################################
MOD = mod
#############################################################################
# MPI librairies
LIBMPI = 
#LIBMPI = -lfmpi -lmpi -lelan

# --- CUDA libraries, for Titane ---
LIBCUDA = -L/opt/cuda/lib  -lm -lcuda -lcudart

LIBS = $(LIBMPI)
#############################################################################
# Sources directories are searched in this exact order
VPATH = $(PATCH):../../$(SOLVER):../../aton:../../hydro:../../pm:../../poisson:../../amr
#############################################################################
# All objects
MODOBJ = amr_parameters.o amr_commons.o random.o pm_parameters.o pm_commons.o poisson_parameters.o poisson_commons.o hydro_parameters.o hydro_commons.o cooling_module.o bisection.o clfind_commons.o gadgetreadfile.o
AMROBJ = read_params.o init_amr.o init_time.o init_refine.o adaptive_loop.o amr_step.o update_time.o output_amr.o flag_utils.o physical_boundaries.o virtual_boundaries.o refine_utils.o nbors_utils.o hilbert.o load_balance.o title.o sort.o cooling_fine.o units.o light_cone.o movie.o
# Particle-Mesh objects
PMOBJ = init_part.o output_part.o rho_fine.o synchro_fine.o move_fine.o newdt_fine.o particle_tree.o add_list.o remove_list.o star_formation.o sink_particle.o feedback.o clump_finder.o clump_merger.o heapsort_index.o
# Poisson solver objects
POISSONOBJ = init_poisson.o phi_fine_cg.o interpol_phi.o force_fine.o multigrid_coarse.o multigrid_fine_commons.o multigrid_fine_fine.o multigrid_fine_coarse.o gravana.o boundary_potential.o rho_ana.o output_poisson.o
# Hydro objects
HYDROOBJ = init_hydro.o init_flow_fine.o write_screen.o output_hydro.o courant_fine.o godunov_fine.o uplmde.o umuscl.o interpol_hydro.o godunov_utils.o condinit.o hydro_flag.o hydro_boundary.o boundana.o read_hydro_params.o synchro_hydro_fine.o gas_analytics.o
# All objects
AMRLIB = $(AMROBJ) $(HYDROOBJ) $(PMOBJ) $(POISSONOBJ)
# ATON objects
ATON_MODOBJ = timing.o radiation_commons.o rad_step.o
ATON_OBJ = observe.o init_radiation.o rad_init.o rad_boundary.o rad_stars.o rad_backup.o ../../aton/atonlib/libaton.a
#############################################################################
ramses:	$(MODOBJ) $(AMRLIB) rampy.o
	$(F90) $(MODOBJ) $(AMRLIB) rampy.o -o $(EXEC)$(NDIM)d $(LIBS)
ramses_aton: $(MODOBJ) $(ATON_MODOBJ) $(AMRLIB) $(ATON_OBJ) ramses.o
	$(F90) $(MODOBJ) $(ATON_MODOBJ) $(AMRLIB) $(ATON_OBJ) ramses.o -o $(EXEC)$(NDIM)d $(LIBS) $(LIBCUDA)
#############################################################################
%.o:%.f90
	$(F90) $(FFLAGS) -c $^ -o $@
#############################################################################
clean :
	rm *.o *.$(MOD)
#############################################################################
