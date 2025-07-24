#!/bin/bash
# Script to build SFINCS without MUMPS support using Homebrew PETSc

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Building SFINCS without MUMPS support...${NC}"

# Check if we're in the right directory
if [ ! -f "sfincs.F90" ]; then
    echo -e "${RED}Error: This script must be run from the fortran/version3 directory${NC}"
    exit 1
fi

# Set environment variables
export SFINCS_SYSTEM=brew
export PETSC_DIR=/opt/homebrew/Cellar/petsc/3.23.4

# Apply the patch to disable MUMPS (if not already applied)
if ! grep -q "PETSC_HAVE_MUMPS" solver.F90; then
    echo -e "${YELLOW}Applying patch to make MUMPS optional...${NC}"
    patch -p1 < disable_mumps.patch
else
    echo -e "${YELLOW}MUMPS patch already applied...${NC}"
fi

# Clean previous build
echo -e "${YELLOW}Cleaning previous build...${NC}"
make clean

# Build SFINCS
echo -e "${YELLOW}Building SFINCS...${NC}"
make

# Check if the executable was created
if [ -f "sfincs" ]; then
    echo -e "${GREEN}Success! SFINCS executable created.${NC}"
    echo -e "${GREEN}You can now run SFINCS with: ./sfincs${NC}"
else
    echo -e "${RED}Build failed - checking for linking issues...${NC}"
    # Try manual linking without MUMPS symbols
    echo -e "${YELLOW}Attempting manual linking...${NC}"
    mpif90 -o sfincs sfincs.o libsfincs.a mini_libstell/mini_libstell.a \
        -L/opt/homebrew/lib -lnetcdff -lnetcdf \
        -L${PETSC_DIR}/lib -lpetsc \
        -lhdf5_fortran -lhdf5_hl_fortran -lhdf5 -lhdf5_hl \
        -llapack -lblas
fi

echo -e "${YELLOW}Note: This build has MUMPS support disabled.${NC}"
echo -e "${YELLOW}Use whichParallelSolverToFactorPreconditioner=2 (SuperLU_DIST) instead of 1 (MUMPS)${NC}"