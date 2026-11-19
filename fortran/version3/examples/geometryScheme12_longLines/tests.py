#!/usr/bin/env python

# A one-period helical-core .bc file whose mode lines are 202 characters long.
# A 200-character line buffer cut the last number of each mode line and the
# run stopped with "Bad real number in item 10 of list input". The expected
# values are those of the same file written with 19-character fields.

exec(open('../testsCommon.py').read())

desiredTolerance = 0.0001

numFailures = 0

numFailures += shouldBe("FSABFlow[0,0;;;]", -0.0557901523565, desiredTolerance)
numFailures += shouldBe("particleFlux_vm_psiN[0,0;;;]", 6.53905355944e-05, desiredTolerance)
numFailures += shouldBe("heatFlux_vm_psiN[0,0;;;]", 1.29393559450e-04, desiredTolerance)

exit(numFailures > 0)
