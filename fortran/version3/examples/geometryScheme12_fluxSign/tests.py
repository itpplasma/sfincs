#!/usr/bin/env python

# Axisymmetric .bc file in the usual left-handed (s,theta,phi) chart with
# G = -3.4 T m and flux +0.785 T m^2. The switch to the right-handed chart
# reverses G and iota but not the toroidal flux. The radial drift needs
# sign(psiAHat) = sign(GHat + iota IHat), so psiAHat = +0.12494. The expected
# values are those of geometryScheme=1 with G = 3.4 T m, iota = -1.2 and
# psiAHat = +0.12494. Reversing psiAHat with the toroidal angle reversed FSABFlow.

exec(open('../testsCommon.py').read())

desiredTolerance = 0.0001

numFailures = 0

numFailures += shouldBe("psiAHat", 0.124936630327, desiredTolerance)
numFailures += shouldBe("FSABFlow[0,0;;;]", -0.0368033527475, desiredTolerance)
numFailures += shouldBe("particleFlux_vm_psiN[0,0;;;]", 4.40981638383e-06, desiredTolerance)

exit(numFailures > 0)
