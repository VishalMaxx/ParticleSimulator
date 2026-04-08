# Particle Simulator - HPSC 2026 Assignment 1

This repository contains my implementation of a 3D Discrete Element Method (DEM) solver for spherical particles. The project covers the full workflow from mathematical formulation and serial implementation to profiling, OpenMP parallelization, and scientific investigation.

## Project Overview
The solver computes the translational motion of N particles inside a cuboidal box. It uses a linear spring-dashpot model for contact forces and a semi-implicit Euler scheme for time integration.

### Repository Structure
* **src/**: Contains all Fortran source files (params.f90, types.f90, physics.f90, etc.).
* **results/**: Data files generated from simulations (.dat format).
* **plots/**: Publication-quality PNGs generated for the final report.
* **Makefile**: Build instructions for compiling the project.
* **generate_plots.py**: Python script used to process the data and create the figures.

## Branching Strategy
I followed a feature-based branching strategy to keep the different parts of the assignment organized and to demonstrate the development process:
* **main**: The stable parallel version of the code using OpenMP.
* **feature/neighbor-search**: Implementation of the O(N) Linked-Cell grid optimization (+1 mark bonus).
* **feature/scientific-investigation**: Code and results for the damping, timestep, and cloud settling studies (+1 mark bonus).
* **feature/final-diagnostics**: Production version with extra tracking for max velocity and contact counts.

## Verification Results
I performed three main tests to verify the physics of the solver:
1. **Free Fall**: Compared numerical results with the analytical solution.
2. **Constant Velocity**: Confirmed zero-gravity linear motion.
3. **Particle Bounce**: Observed energy dissipation and damping during wall collisions.

### Key Verification Plots
| Free Fall (Analytical vs Numerical) | Error vs Timestep |
| :--- | :--- |
| ![Free Fall](plots/trajectory_comparison.png) | ![Error](plots/error_vs_dt.png) |

## Performance & Scaling
The code was parallelized using OpenMP. Profiling showed that the O(N^2) particle contact loop was the primary bottleneck.
* **Strong Scaling**: Tested for N=5000 particles across 1 to 8 threads.
* **Neighbor Search**: The Linked-Cell implementation significantly improved performance for large systems.

| Speedup Plot | Efficiency Plot |
| :--- | :--- |
| ![Speedup](plots/strong_scaling_speedup.png) | ![Efficiency](plots/strong_scaling_efficiency.png) |

## Scientific Investigations
I conducted three studies to explore the system behavior:
1. **Effect of Damping**: Analyzed rebound heights across different damping values.
2. **Timestep Sensitivity**: Evaluated simulation stability across different timesteps.
3. **Particle Cloud Settling**: Tracked Center of Mass and Kinetic Energy as 100 particles settled.

## How to Build and Run
To compile the code, you need a Fortran compiler (gfortran) and OpenMP installed.
1. **Compile**: `make`
2. **Run**: `./simulator`
3. **Clean**: `make clean`
4. **Generate Plots**: `python3 generate_plots.py`

## LLM Usage Report
LLM assistance was utilized for the architectural design of the Fortran modules, correcting errors in the physics logic, and debugging OpenMP race conditions. It was further used to fill in missing conceptual ideas and restructure the code for better modularity and readability. I have personally checked all logic, equations, and simulation results for scientific accuracy and verified them against the assignment requirements.
