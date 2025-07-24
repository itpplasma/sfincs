#include <petsc.h>
#include <petscvec.h>
#include <petscviewer.h>
#include <petsctime.h>

/* Fortran wrapper for PetscTime */
void petsctime_(PetscLogDouble *time, PetscErrorCode *ierr) {
    *ierr = PetscTime(time);
}

/* Fortran wrapper for VecGetArrayF90 */
void vecgetarrayf90_(Vec *vec, PetscScalar **array, PetscErrorCode *ierr) {
    *ierr = VecGetArray(*vec, array);
}

/* Fortran wrapper for VecRestoreArrayF90 */
void vecrestorearrayf90_(Vec *vec, PetscScalar **array, PetscErrorCode *ierr) {
    *ierr = VecRestoreArray(*vec, array);
}

/* Fortran wrapper for PetscViewerSetFormat */  
void petscviewersetformat_(PetscViewer *viewer, PetscViewerFormat *format, PetscErrorCode *ierr) {
    *ierr = PetscViewerPushFormat(*viewer, *format);
}