# Building SFINCS on macOS

This guide provides instructions for building SFINCS on macOS with Homebrew dependencies.

## Prerequisites

Ensure you have Homebrew installed with the following packages:
```bash
brew install gcc open-mpi hdf5-mpi netcdf netcdf-fortran
```

## Build Options

### Option 1: Quick Build Without MUMPS (Recommended for Testing)

The simplest way to build SFINCS is without MUMPS support:

```bash
./build_without_mumps.sh
```

This will:
- Use the Homebrew-installed PETSc (without MUMPS)
- Apply a patch to make MUMPS optional in the code
- Build SFINCS with SuperLU_DIST as the parallel solver

**Note**: When running SFINCS built this way, use `whichParallelSolverToFactorPreconditioner=2` (SuperLU_DIST) in your input files.

### Option 2: Build with Full MUMPS Support

For full functionality including MUMPS solver support:

```bash
# Install PETSc with MUMPS to a local directory
./install_petsc_mumps.sh

# Set environment variable
export PETSC_DIR=$(pwd)/thirdparty/petsc-3.20.6/arch-macos-opt

# Build SFINCS
export SFINCS_SYSTEM=local_petsc
make clean
make
```

This process will:
- Download and build PETSc 3.20.6 with MUMPS, ScaLAPACK, and other dependencies
- Install everything to `./thirdparty/`
- Take approximately 30-60 minutes depending on your system

### Option 3: Use Homebrew PETSc (Manual Build)

If you want to use the Homebrew PETSc and handle the linking manually:

```bash
export SFINCS_SYSTEM=brew
export PETSC_DIR=/opt/homebrew/Cellar/petsc/3.23.4
make clean
make
```

**Note**: This may fail at the linking stage due to missing MUMPS symbols. You'll need to either:
- Apply the MUMPS patch from Option 1
- Install MUMPS separately and update the makefile

## Troubleshooting

### PETSc API Compatibility
The code has been updated to work with modern PETSc APIs (3.20+). Key changes include:
- Enum handling for convergence reasons
- Updated MatInfo structure usage
- Replaced deprecated constants

### Missing Symbols During Linking
If you see undefined symbols for:
- `_matmumps*`: MUMPS is not available - use Option 1 or 2
- `_petsctime_`, `_vecgetarrayf90_`: PETSc Fortran interface issues - ensure you're using the correct PETSc installation

### NetCDF Errors
If you encounter NetCDF-related compilation errors, ensure:
```bash
brew link netcdf netcdf-fortran
```

## Running SFINCS

After successful compilation:
```bash
./sfincs
```

For parallel runs:
```bash
mpirun -np 4 ./sfincs
```

## Input File Modifications

If built without MUMPS (Option 1), modify your input.namelist:
```
&numericParameters
  whichParallelSolverToFactorPreconditioner = 2  ! Use SuperLU_DIST instead of MUMPS
/
```