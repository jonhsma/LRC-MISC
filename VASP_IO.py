# This module contains general utilities for interfacing with vasp
import MD_VASP_IO
from numpy import sum,array,fromiter
from math   import ceil
from itertools import chain

def read_LOCPOT(path):
	f = open(path)

	jj=0
	cell = []
	n_atoms = 0;
	positions = [];
	locpot_grid = [];
	locpot_str = [];


	for line in f:
		if jj==0:
			# comment
			comment = line
		elif jj == 1:
			# scaling factor of the lattice cell
			scale = float(line)
		elif jj<=4:
			# The unit cell
			cell.append([float(s) for s in line.split()])
		elif jj==5:
			atoms = line.split()
		elif jj==6:
			atomNumbers=[int(n) for n in line.split()]
			n_atoms = sum(array(atomNumbers))
		elif jj<=7: 
			# The position coordinate mode
			mode = line
		elif jj<=7+n_atoms:
			positions.append([float(s) for s in line.split()])
		elif jj == 7+n_atoms + 1:
			a=0
		elif jj == 7 + n_atoms + 2:
			locpot_grid = [int(n) for n in line.split()]
			break
		jj+=1


	locpot_t = (f.readline().split() for i in range(int(ceil(locpot_grid[0]*locpot_grid[1]*locpot_grid[2]/5))))
	locpot = fromiter(chain.from_iterable(locpot_t), float)
	
	#reshape the local potential in to a 3 d array
	locpot = array(locpot)
	locpot = locpot.reshape(locpot_grid[2],locpot_grid[1],locpot_grid[0]).swapaxes(0,2).tolist()
	
	f.close()
	return locpot, locpot_grid, cell, atoms, n_atoms, positions