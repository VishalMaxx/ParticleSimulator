# Particle Simulator - HPSC 2026 Assignment 1

[cite_start]This repository contains my implementation of a 3D Discrete Element Method (DEM) solver for spherical particles[cite: 14]. [cite_start]The project covers the full workflow from mathematical formulation and serial implementation to profiling, OpenMP parallelization, and scientific investigation [cite: 17-25].

## Project Overview
[cite_start]The solver computes the translational motion of N particles inside a cuboidal box[cite: 15, 28]. [cite_start]It uses a linear spring-dashpot model for contact forces [cite: 43] [cite_start]and a semi-implicit Euler scheme for time integration[cite: 83].

### Repository Structure
* [cite_start]**src/**: Contains all Fortran source files (params.f90, types.f90, physics.f90, etc.) [cite: 121-130].
* **results/**: Data files generated from simulations (.dat format).
* [cite_start]**plots/**: Publication-quality PNGs generated for the final report[cite: 208].
* [cite_start]**Makefile**: Build instructions for compiling the project[cite: 207].
* [cite_start]**generate_plots.py**: Python script used to process the data and create the figures[cite: 130].

## Branching Strategy
I followed a feature-based branching strategy to keep the different parts of the assignment organized and to demonstrate the development process:
* **main**: The stable parallel version of the code using OpenMP[cite: 172].
* [cite_start]**feature/neighbor-search**: Implementation of the O(N) Linked-Cell grid optimization (+1 mark bonus) [cite: 217-218].
* [cite_start]**feature/scientific-investigation**: Code and results for the damping, timestep, and cloud settling studies (+1 mark bonus) [cite: 233-235].
* **feature/final-diagnostics**: Production version with extra tracking for max velocity and contact counts[cite: 113].

## Verification Results
I performed three main tests to verify the physics of the solver [cite: 132-133]:
1. **Free Fall**: Compared numerical results with the analytical solution [cite: 134-141].
2. **Constant Velocity**: Confirmed zero-gravity linear motion [cite: 142-143].
3. **Particle Bounce**: Observed energy dissipation and damping during wall collisions [cite: 144-148].

### Key Verification Plots
| Free Fall (Analytical vs Numerical) | Error vs Timestep |
| :--- | :--- |
| ![Free Fall](plots/trajectory_comparison.png) | ![Error](plots/error_vs_dt.png) |

## Performance & Scaling
The code was parallelized using OpenMP[cite: 172]. Profiling showed that the O(N^2) particle contact loop was the primary bottleneck[cite: 168, 221].
* [cite_start]**Strong Scaling**: Tested for N=5000 particles across 1 to 8 threads [cite: 179-181].
* [cite_start]**Neighbor Search**: The Linked-Cell implementation significantly improved performance for large systems[cite: 218, 231].

| Speedup Plot | Efficiency Plot |
| :--- | :--- |
| ![Speedup](plots/strong_scaling_speedup.png) | ![Efficiency](plots/strong_scaling_efficiency.png) |

## Scientific Investigations
[cite_start]I conducted three studies to explore the system behavior [cite: 233-235]:
1. [cite_start]**Effect of Damping**: Analyzed rebound heights across different damping values [cite: 236-240].
2. [cite_start]**Timestep Sensitivity**: Evaluated simulation stability across different timesteps [cite: 243-248].
3. [cite_start]**Particle Cloud Settling**: Tracked Center of Mass and Kinetic Energy as 100 particles settled [cite: 251-256].

## How to Build and Run
To compile the code, you need a Fortran compiler (gfortran) and OpenMP installed.
1. **Compile**: `make`
2. **Run**: `./simulator`
3. **Clean**: `make clean`
4. **Generate Plots**: `python3 generate_plots.py`

## LLM Usage Report
[cite_start]I used LLMs to help with structuring the Fortran modules and debugging OpenMP race conditions[cite: 5]. [cite_start]All physics logic and parallel strategies were manually verified for correctness against the assignment requirements[cite: 8].
