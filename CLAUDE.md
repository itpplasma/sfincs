# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About SFINCS

SFINCS (Stellarator Fokker-Planck Iterative Neoclassical Conservative Solver) is a scientific computing code that solves drift-kinetic equations for plasma physics in stellarators and tokamaks. It computes neoclassical transport effects including fluxes, flows, and bootstrap current.

## Repository Structure

This repository contains multiple versions of SFINCS, with **fortran/version3** being the recommended stable version for most users:

- `fortran/version3/` - Main stable version (parallel Fortran implementation)
- `fortran/Fourier/` - Fourier-based discretization version
- `fortran/algebraicMultigrid/` - Algebraic multigrid version
- `fortran/geometricMultigrid/` - Geometric multigrid version
- `matlab/version3/` - Serial MATLAB implementation
- `doc/` - Technical documentation and papers
- `equilibria/` - Example equilibrium files

## Build System and Common Commands

### Prerequisites
- **SFINCS_SYSTEM** environment variable must be set to select the appropriate makefile (e.g., `export SFINCS_SYSTEM=laptop`)
- PETSc library (required for Fortran versions)
- HDF5 library (for output)
- NetCDF library (optional, for reading VMEC files)

### Building SFINCS
```bash
cd fortran/version3/
export SFINCS_SYSTEM=laptop  # or your system type
make                          # builds the sfincs executable
```

Available system makefiles in `fortran/version3/makefiles/`:
- `makefile.laptop` - Local development
- `makefile.docker` - Docker builds  
- `makefile.cori`, `makefile.edison`, etc. - HPC systems

### Testing
```bash
make test     # Run all functional tests
make retest   # Test existing output without re-running
```

### Cleaning
```bash
make clean    # Remove object files and executables
```

## Input Configuration

Input parameters are specified in namelist format in `input.namelist` files. Key sections include:

- `&general` - Output options and general settings
- `&geometryParameters` - Magnetic geometry configuration
- `&speciesParameters` - Plasma species (charge, mass, density, temperature)
- `&physicsParameters` - Physics model parameters (collisions, electric field)
- `&resolutionParameters` - Numerical grid resolution
- `&preconditionerOptions` - Linear solver settings

## Running SFINCS

SFINCS runs are typically executed using system-specific job scripts (`job.SYSTEM_NAME`) in example directories. The main executable reads `input.namelist` and produces `sfincsOutput.h5`.

## Key Code Architecture

### Main Program Flow
1. `sfincs.F90` - Main program entry point using MPI
2. `sfincs_main.F90` - Contains `sfincs_init()`, `sfincs_prepare()`, `sfincs_run()`, `sfincs_finalize()`
3. `readInput.F90` - Parses input namelist files
4. `geometry.F90` - Sets up magnetic geometry
5. `createGrids.F90` - Builds computational grids
6. `populateMatrix.F90` - Assembles the linear system matrix
7. `solver.F90` - Solves the linear system using PETSc
8. `writeHDF5Output.F90` - Writes results to HDF5 format

### Global Variables
`globalVariables.F90` contains all shared parameters and arrays, organized by categories:
- General options and file I/O settings
- Geometry input parameters  
- Species quantities (charge, mass, density profiles)
- Physics parameters (collision operators, electric fields)
- Numerical resolution parameters
- Grid and matrix variables

### Utility Scripts
The `utils/` directory contains analysis tools:
- `sfincsScan*` - Parameter scanning utilities
- `sfincsPlot*` - Plotting and visualization tools
- `radialScans` - Radial profile analysis

## Development Notes

- Use appropriate system makefile from `makefiles/` directory
- Tests require h5dump utility (from HDF5 package)
- For development, use NETCDF linking to read VMEC equilibrium files
- The code supports both single and multi-species plasma simulations
- Convergence studies can be performed by varying resolution parameters (Ntheta, Nzeta, Nxi, Nx)