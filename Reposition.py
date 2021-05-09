from numpy import array,transpose,linalg
import ase


# Introduction:
# VASP wraps things around without unrapping them. What a bummer. Now I need to write a library to fix that.



# rVec_2_aVec returns a the same vector expressed in terms of the lattice vectors
# Note that the lattice vectors instead of their unit vectors are used as the final basis

def rVec_2_aVec(rVec,cell):
    # To ensure numpy compatability
    cell = array(cell)
    mat = linalg.inv(transpose(cell))
    return mat @ rVec

# This function translates one atom by lattice vectors so that it's distance to another is minimized
# For the ease of use, and to avoid confusion, it will take in an atom object and reposition the target atom
# It's not the fastest thing to do but for this sort of analysis such transformations are never the bottle neck
def Unwrap_atom(Molecule,ref,target):
    ref_pos = Molecule.positions[ref,:];
    tar_pos = Molecule.positions[target,:]

    diff = tar_pos - ref_pos
    diff_in_a = rVec_2_aVec(diff,Molecule.cell)

    for ii in range(0,3):
        while diff_in_a[ii] > 0.5:
            tar_pos  = tar_pos - Molecule.cell[ii,:]
            diff = tar_pos - ref_pos
            diff_in_a = rVec_2_aVec(diff,Molecule.cell)
        while diff_in_a[ii] < -0.5:
            tar_pos = tar_pos + Molecule.cell[ii,:]
            diff = tar_pos - ref_pos
            diff_in_a = rVec_2_aVec(diff,Molecule.cell)

        Molecule.positions[target,:] = tar_pos
    return Molecule

# Now I think it would be fairly useful if I can us the molecule and the chain configuration as input and automate the unwrappnig
def Unwrap_molecule(Molecule,chain_config):
    chain = chain_config;
    last_idx = -1;
    for node in chain:
        idx = node[0]
        # Move the node
        if not last_idx == -1:
            Molecule = Unwrap_atom(Molecule,last_idx,idx)
        # Now move the satellites
        for jj in node[1]:
            Molecule = Unwrap_atom(Molecule,idx,jj)
        last_idx = idx;
    return Molecule

