#include <petsc.h>
#include <petscvec.h>
#include <petscviewer.h>
#include <petsctime.h>

/* Fortran wrapper for PetscTime */
void petsctime_(PetscLogDouble *time, PetscErrorCode *ierr) {
    *ierr = PetscTime(time);
}

/* Fortran wrapper for PetscViewerSetFormat */  
void petscviewersetformat_(PetscViewer *viewer, PetscViewerFormat *format, PetscErrorCode *ierr) {
    *ierr = PetscViewerPushFormat(*viewer, *format);
}