from ase.io import read,write
from ase    import Atoms, visualize
import QCASE as bridge
import json
import os
from shutil import rmtree


def LoadDatabase(db_path):
    with open(db_path,"r") as ff:
        data = json.load(ff)
    return data

def ListMolecules2Compute(Database, echo = False):
    Reactions   =   Database["Reactions"]
    Species     =   Database["Species"]

    MoleculeConfigs = {}

    for reaction in Reactions:
        for group in ["reactants","products"]:
            for item in Reactions[reaction][group]:
                if item[0] in Species:
                    if item[0] in MoleculeConfigs:
                        if not item[1:3] in MoleculeConfigs[item[0]]:
                            MoleculeConfigs[item[0]].append(item[1:3])
                    else:
                        MoleculeConfigs[item[0]] = [item[1:3]]
                else:
                    print(item)
                    print('Specie/fragment not found in database')

    return(MoleculeConfigs)



def batchGenFragments(molecule, Database, basePath = "Fragments", comments = "", echo = False, xyz = False):

    if not basePath == ".":
        if os.path.exists(basePath):
            rmtree(basePath)
        os.mkdir(basePath)

    if not comments =="":
        comments = "$comment\n" + comments + "\n$end\n"

    # Get the Species
    Fragments = Database["Species"]

    # Get the configurations
    ConfigList = ListMolecules2Compute(Database)

    for fragment in ConfigList:
        # Get the molecule
        indices = Fragments[fragment]
        fragMol = Atoms(symbols = molecule.symbols[indices],\
                positions = molecule.positions[indices,:])

        if echo:
            visualize.view(fragMol)

        
        for chgDeg in ConfigList[fragment]:
            fragPath = basePath + '/' + fragment + '_' + str(chgDeg[0]) + '_' + str(chgDeg[1])
            os.mkdir(fragPath)
            if xyz:
                write(fragPath + '/molecule.xyz', fragMol, format = "xyz")
            with open(fragPath + '/molecule.qchem',"w+") as ff:
                ff.write(comments)
                ff.write(bridge.mol2qchd(fragMol,chgDeg[0],degen = chgDeg[1]))


