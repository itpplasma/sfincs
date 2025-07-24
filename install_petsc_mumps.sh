#!/bin/bash
# Script to install PETSc with MUMPS support for SFINCS
# This installs PETSc to a local directory: ./thirdparty/petsc

set -e  # Exit on error

# Configuration
INSTALL_DIR="$(pwd)/thirdparty"
PETSC_VERSION="3.22.6"  # Stable version known to work well with MUMPS
PETSC_DIR="${INSTALL_DIR}/petsc-${PETSC_VERSION}"
PETSC_ARCH="arch-macos-opt"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing PETSc ${PETSC_VERSION} with MUMPS support...${NC}"

# Create thirdparty directory
mkdir -p ${INSTALL_DIR}
cd ${INSTALL_DIR}

# Download PETSc if not already present
if [ ! -d "petsc-${PETSC_VERSION}" ]; then
    echo -e "${YELLOW}Downloading PETSc ${PETSC_VERSION}...${NC}"
    curl -L -O https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-${PETSC_VERSION}.tar.gz
    tar -xzf petsc-${PETSC_VERSION}.tar.gz
    rm petsc-${PETSC_VERSION}.tar.gz
else
    echo -e "${YELLOW}PETSc source already exists, skipping download...${NC}"
fi

cd petsc-${PETSC_VERSION}

# Configure PETSc with MUMPS and other necessary packages
echo -e "${YELLOW}Configuring PETSc...${NC}"
echo -e "${YELLOW}This will download and build MUMPS, ScaLAPACK, and other dependencies${NC}"

./configure \
  --prefix=${PETSC_DIR}/${PETSC_ARCH} \
  --with-debugging=0 \
  --with-shared-libraries=1 \
  --with-scalar-type=real \
  --with-precision=double \
  --with-fc=mpif90 \
  --with-cc=mpicc \
  --with-cxx=mpicxx \
  --download-mumps=1 \
  --download-scalapack=1 \
  --download-parmetis=1 \
  --download-metis=1 \
  --download-ptscotch=1 \
  --download-fblaslapack=1 \
  --with-hdf5-dir=/opt/homebrew/opt/hdf5-mpi \
  --with-netcdf-dir=/opt/homebrew \
  PETSC_ARCH=${PETSC_ARCH}

# Build PETSc
echo -e "${YELLOW}Building PETSc (this may take a while)...${NC}"
make PETSC_DIR=${PETSC_DIR} PETSC_ARCH=${PETSC_ARCH} all

# Test PETSc installation
echo -e "${YELLOW}Testing PETSc installation...${NC}"
make PETSC_DIR=${PETSC_DIR} PETSC_ARCH=${PETSC_ARCH} check

# Install PETSc
echo -e "${YELLOW}Installing PETSc...${NC}"
make PETSC_DIR=${PETSC_DIR} PETSC_ARCH=${PETSC_ARCH} install

echo -e "${GREEN}PETSc installation complete!${NC}"
echo -e "${GREEN}Installation directory: ${PETSC_DIR}/${PETSC_ARCH}${NC}"
echo ""
echo -e "${YELLOW}To use this PETSc installation with SFINCS:${NC}"
echo "export PETSC_DIR=${PETSC_DIR}/${PETSC_ARCH}"
echo "export SFINCS_SYSTEM=local_petsc"
echo "cd fortran/version3"
echo "make clean && make"
echo ""
echo -e "${YELLOW}The makefile.local_petsc has been updated to work with this installation.${NC}"
