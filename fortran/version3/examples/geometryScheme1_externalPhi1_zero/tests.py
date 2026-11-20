#!/usr/bin/env python

# A zero potential read with readExternalPhi1 must reproduce the run without
# Phi1 (FSABFlow -0.0172042, solved to a relative residual of 1e-11). With the
# former MUMPS pivoting threshold CNTL(1) = 1e-6 the direct solve gave -0.00683.

exec(open('../testsCommon.py').read())

desiredTolerance = 0.0001

numFailures = 0

numFailures += shouldBe("FSABFlow[0,0;;;]", -0.01720417234, desiredTolerance)
numFailures += shouldBe("particleFlux_vm_psiHat[0,0;;;]", -1.07778e-05, desiredTolerance)
numFailures += shouldBe("heatFlux_vm_psiHat[0,0;;;]", -2.20140e-05, desiredTolerance)

exit(numFailures > 0)
