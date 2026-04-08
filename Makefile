FC = gfortran
FFLAGS = -O3 -fopenmp
SRC_DIR = src
OBJ = params.o types.o grid_search.o physics.o io_utils.o main.o

%.o: $(SRC_DIR)/%.f90
	$(FC) $(FFLAGS) -c $< -o $@

simulator: $(OBJ)
	$(FC) $(FFLAGS) $(OBJ) -o simulator

clean:
	rm -f *.o *.mod simulator
