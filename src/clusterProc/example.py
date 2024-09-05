import pyximport; pyximport.install()
import pebble
import time
import hashlib
import itertools
import os

# These lines import the Numpy and Datascience modules.
import numpy as np
from matplotlib.ticker import PercentFormatter
# These lines do some fancy plotting magic.
import matplotlib
import matplotlib.pyplot as plt
plt.style.use('fivethirtyeight')
import warnings
warnings.simplefilter('ignore', FutureWarning)

from matplotlib import patches



def read_bonds_from_file(file_path):
    bonds = []
    # Check if the file path is absolute, if not, make it absolute
    if not os.path.isabs(file_path):
        file_path = os.path.abspath(file_path)
    
    try:
        with open(file_path, 'r') as file:
            for line in file:
                print(line) 
                node1, node2 = map(int, line.strip().split())
                bonds.append((node1, node2))
    except FileNotFoundError:
        print(f"File not found: {file_path}")
    except Exception as e:
        print(f"An error occurred: {e}")
    
    return bonds


if __name__ == '__main__':
    

    #times = []






# Define the directory path of the trial folder
    directory = f"/mnt/c/Users/aidan/Desktop/Rigidity_Percolation/fireants/src/clusterProc/temp"

    
    countFrame = 1
while os.path.exists(f"{directory}/frame{countFrame}"):
    countN = 1
    while os.path.exists(f"{directory}/frame{countFrame}/network{countN}"):
        
        G = pebble.lattice() # initialize a lattice
        bond = read_bonds_from_file(f"{directory}/frame{countFrame}/network{countN}/pairlist.in")
        for i in bond:
            # add bond
            G.add_bond(i[0],i[1]) # if the bond is independent, add_bond returns True, otherwise False

        # check simple statistics:
        G.stat()
        G.decompose_into_cluster()
        G.decompose_stress()
    


        sorted_cluster_indices = sorted(G.cluster['index'], key=lambda cluster_index: len(G.cluster['index'][cluster_index]), reverse=True)
        sorted_clusters = {index: G.cluster['index'][index] for index in sorted_cluster_indices}
        largest_two_entries = {index: sorted_clusters[index] for index in sorted_cluster_indices[:2]}
        first_entry_key = next(iter(largest_two_entries))
        first_entry_value = len(largest_two_entries[first_entry_key])
        second_entry_key = next(itertools.islice(iter(largest_two_entries), 1, 2))
        second_entry_value = len(largest_two_entries[second_entry_key])  
        cluster_sizes = [len(G.cluster['index'][cluster_index]) for cluster_index in G.cluster['index']]
        folder_path = f"{directory}/frame{countFrame}/network{countN}"
        file_path = os.path.join(folder_path, "BONDS.dump")
        with open(file_path, "w+") as file1:
            file1.write(f"ITEM: TIMESTEP\n0\nITEM: NUMBER OF ENTRIES\n{len(G.bond)}\nITEM: BOX BOUNDS ff ff ff\nxmin xmax\nymin ymax\nzmin zmax\nITEM: ENTRIES c_1[1] c_1[2]  c_1[3]    c_2[1]")
            for bondIndex, (node1, node2) in enumerate(G.bond):
                    # Determine the cluster index for the bond
                    cluster_index = G.cluster['bond'].get((node1, node2))
                    cluster_size = len(G.cluster['index'][cluster_index])
                    
                    if cluster_index is None:
                        rigidType = 0
                    elif cluster_size == first_entry_value:
                        rigidType = 2
                    elif cluster_size == second_entry_value:
                        rigidType = 3
                    else:
                        # Get the cluster size
                        # Determine rigidity type based on cluster size
                        rigidType = 1 if cluster_size >= 3 else 0
                    # Write the bond information to the file
                    file1.write(f"\n{bondIndex+1}\t{node1}\t{node2}\t{rigidType}")
        file_path = os.path.join(folder_path, "pairlist.out")
        with open(file_path, "w+") as file1:
            for bondIndex, (node1, node2) in enumerate(G.bond):
                    # Determine the cluster index for the bond
                    cluster_index = G.cluster['bond'].get((node1, node2))
                    cluster_size = len(G.cluster['index'][cluster_index])
                    
                    if cluster_index is None:
                        rigidType = 0
                    else:
                        # Get the cluster size
                        # Determine rigidity type based on cluster size
                        rigidType = 1 if cluster_size >= 3 else 0
                    # Write the bond information to the file
                    file1.write(f"\n{node1}\t{node2}\t{rigidType}")


        cluster_bonds = {index: [] for index in G.cluster['index']}
        # Populate the dictionary with bond indexes
        for bondIndex, (node1, node2) in enumerate(G.bond):
            cluster_index = G.cluster['bond'].get((node1, node2))
            cluster_size = len(G.cluster['index'][cluster_index])
            if cluster_index is not None and cluster_size >= 3 :
                cluster_bonds[cluster_index].append(bondIndex + 1)
        with open(f"{folder_path}/clusters.out", 'w') as file:
            for cluster_index, bonds in cluster_bonds.items():
                file.write(f"{' '.join(map(str, bonds))}\n")
        file1.close()
        countN = countN + 1
    countFrame = countFrame + 1











