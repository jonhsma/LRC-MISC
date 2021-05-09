from ase.io import read
import numpy as np
import os

def mol2qchd(Molecule,charge,degen = -1):
    
    if degen == -1:
        degen = (charge + np.sum(Molecule.get_atomic_numbers())) % 2 + 1


    n_elements = len(Molecule.symbols)

    hdrStr = "$molecule\n"

    hdrStr += str(charge) + " " + str(degen) + "\n"

    for ii in range(n_elements):
        hdrStr = hdrStr + Molecule.symbols[ii] + \
                "\t" + "{:8.6f}".format(Molecule.positions[ii,0]) + \
                "\t" + "{:8.6f}".format(Molecule.positions[ii,1]) + \
                "\t" + "{:8.6f}".format(Molecule.positions[ii,2]) + "\n"
    hdrStr += "$end\n"

    return hdrStr


def qcrlx2ase(qcPath):
    
    stream = os.popen('get_Relaxed.sh ' + qcPath + ' > temp.xyz')
    output = stream.read()
    return read('temp.xyz',format = 'xyz') 
        
