 
from bisect import bisect_left, bisect_right
import numpy as np
import scipy as sp
 
import copy
 
import sys
 
class MD:
    def __init__(self):
        self.vel = np.zeros((3,3))
        self.coor = np.zeros((3,3))
        self.step = 0
        self.time = 0      

def read_file( filename, step):
    data = np.loadtxt(filename)
    return data[step,:]

def read_atom_list (num_atom):
    f=open('View.xyz', 'r')
    line = f.readline()
    if int(float(line)) != num_atom:
        print('Number of atom mismatch!')
        print(num_atom)
        sys.exit()
    f.readline()
    atom_list=[]
    for i in range(int(num_atom))  :
        line = f.readline()
        atom_list.append(line.split()[0])
    return atom_list

def output(step ,MD_step):
    print('Function \"output\" is evoked')
    filename = "NucVeloc"    
    vel= read_file (filename, step)
    num_atom = (len(vel) - 1) /3
    print('Nuclear velocities successfully read')
    
    MD_step.step = step
    MD_step.vel = vel[1: ].reshape((int(num_atom), 3))
     
    filename = "NucCarts"    
    coor =  read_file (filename, step) 
    MD_step.coor = coor[1: ].reshape((int(num_atom), 3))
    print('Nuclear positions successfully read')
    
     
    atom_list= read_atom_list(int(num_atom))
    print('Atom list successfully parsed')
    
    if (vel[0]!=coor[0]):
        print("Error, wrong step time! " ,vel[0], coor[0])
    MD_step.time  =  vel[0]
    print(MD_step.step ,  MD_step.time , atom_list)
    
    ####################### revise
    charge =1
    multiplicity = 1
    #######################
    
    fcoor=open('coor.xyz', 'w')
    print('Now coor.xyz is opened')
    
    fcoor.write("$molecule \n")
    fcoor.write(str(charge)+' '+str(multiplicity) + '\n')
    for i in range(int(num_atom)) : 
        fcoor.write( atom_list[i] +'\t'+ '  '.join('%0.10f' %x for x in MD_step.coor[i,:])  +'\n'  )
    fcoor.write("$end")  
    fcoor.close()
    
    fvel=open('vel.xyz', 'w')
    fvel.write("$velocity \n")

    for i in range(int(num_atom)) : 
        fvel.write(  '  '.join('%0.10f' %x for x in MD_step.vel[i,:])  +'\n'  )
    fvel.write("$end")  
    fvel.close()
    
if len(sys.argv) <2 :
    print("Please input time step!")
    sys.exit(0)
step = int( float(sys.argv[1] ))
MD_step = MD()
output (step, MD_step) 



 
