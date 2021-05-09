import re
import numpy

def readfile(name):
	qc_i_fp = open(name,"r")
	contents = qc_i_fp.read()
	qc_i_fp.close()
	return contents


def getCoordTable(text):
	result = re.search('$molecule', text)
	return result
	
def getCoordTablefromFile(name):
	file = open(name,"r")
	data = []
	scanning=False
	for line in file:
		#print(line)
		if not scanning:
			if line.startswith('$molecule'):
				scanning = True
		elif line.startswith('$end'):
			scanning = False
		else:
			data.append(line)
	return data
	
	
def getDataFromList(atomList):
	ii=0
	#coordList=numpy.zeros(shape=(len(atomList),3));
	coordList = [];
	nameList = [];
	result = [];
	
	for atom in atomList:
		items = atom.split()
		name = items[0];
		coords = numpy.asarray(list(map(float,items[1:])))
		result.append((name,coords))
		ii+=1	
	#result = (nameList,coordList)
	return result
	
def moleculeDataToText(data,outName,firstLine='1 1'):	
	moleculeText="$molecule\n"+firstLine;
	for atom in data:
		currLine = '{}\t{:13.10f}\t{:13.10f}\t{:13.10f}\n'.format(atom[0],atom[1][0],atom[1][1],atom[1][2])
		moleculeText += currLine
	moleculeText += "$end\n"
	if isinstance(outName,str):
		qc_o_fp = open(outName,"w+")
		qc_o_fp.write(moleculeText)
		qc_o_fp.close()
	return moleculeText
	
def bondVector(atom1_xyz,atom2_xyz):
	return atom2_xyz-atom1_xyz
	
def bondDir(atom1, atom2):
	v = bondVector(atom1, atom2)
	return v/mumpy.linalg.norm(v)
	
def moveCluster(dataIn,selection,displacement):
	dataOut = dataIn[:]
	for atom in selection:
		dataOut[atom] = (dataIn[atom][0],dataIn[atom][1]+displacement)
	return dataOut	
	
def writeSingleFile(atomPosList,footerStr,selectedAtoms,displacement,outName,firstLine):
	config = moleculeDataToText(\
            moveCluster(atomPosList,selectedAtoms,displacement),\
            'temp.dat',firstLine)
	qc_o_fp = open(outName,"w+")
	qc_o_fp.write(config)
	qc_o_fp.write(footerStr)
	qc_o_fp.close()
	
def genBatch(inputFile,footerFile,outFileBaseName,bondAtoms,atomsToMove,stepList,mode='relative'):
	#Read the footer
	f_ft=open(footerFile,"r")
	footerStr=f_ft.read()
	f_ft.close()
	
	#Read the molecule
	table=getCoordTablefromFile(inputFile)
	atomData=getDataFromList(table[1:])
	line1=table[0];
	
	#Get the bond direction
	bV = bondVector(atomData[bondAtoms[0]][1],atomData[bondAtoms[1]][1])	
	if mode == 'absolute':
		mul = 1/mumpy.linalg.norm(bondDir)
	else:
		mul = 1	
		
	
	ii=1;
	for step in stepList:
		writeSingleFile(atomData,footerStr,atomsToMove,mul*step*bV,\
		(outFileBaseName + '_{:04d}.in').format(ii),line1)
		ii+=1