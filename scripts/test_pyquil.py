from pyquil import get_qc, Program
from pyquil.gates import CNOT, Z, MEASURE
from pyquil.api import local_forest_runtime
from pyquil.quilbase import Declare

class SP:
    def __init__(self,com):
        import subprocess
        import time
        self.p = subprocess.Popen(com)
        time.sleep(5)
    def __del__(self):
        self.p.terminate()

quilc_process = SP(["quilc","-R"])
qvm_process=SP(["qvm","-S"])

prog = Program(
    Declare("ro", "BIT", 2),
    Z(0),
    CNOT(0, 1),
    MEASURE(0, ("ro", 0)),
    MEASURE(1, ("ro", 1)),
).wrap_in_numshots_loop(10)

with local_forest_runtime():
    #qvm = get_qc('9q-square-qvm')
    qvm = get_qc('2q-qvm')
    bitstrings = qvm.run(qvm.compile(prog)).readout_data.get("ro")
    print(bitstrings)
    
