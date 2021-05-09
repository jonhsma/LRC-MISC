# This module contains funtionalities, partially built upon ase capabilities, for analyzing interfaces

from math import atan2,pi

# It first aligns the a bond with the z axis and then 
# aligns the x-y projection of another bond with the x axis

def zero_angles(Molecule,iz0,iz1,ix0,ix1):
    
    # rotate the 1st bond to the z-axis
    z_vector = Molecule.positions[iz1,:]-Molecule.positions[iz0,:]
    Molecule.rotate(z_vector,"z")
    
    # rotate the x axis to the projection of the 2nd bond
    a_vector = Molecule.positions[ix1,:] - Molecule.positions[ix0,:]
    phi = atan2(a_vector[1],a_vector[0])
    Molecule.euler_rotate(phi=phi/pi*180)
    
