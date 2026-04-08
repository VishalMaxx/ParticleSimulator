FC = gfortran
FFLAGS = -O3 -fopenmp
SRC_DIR = src


OBJ = params.o types.o grid_search.o io_utils.o physics.o main.o


%.o: $(SRC_DIR)/%.f90
	$(FC) $(FFLAGS) -c $< -o $@


simulator: $(OBJ)
	$(FC) $(FFLAGS) $(OBJ) -o simulator


grid_search.o: $(SRC_DIR)/grid_search.f90 types.o params.o
physics.o: $(SRC_DIR)/physics.f90 types.o params.o grid_search.o
main.o: $(SRC_DIR)/main.f90 physics.o io_utils.o

clean:
	rm -f *.o *.mod simulator
