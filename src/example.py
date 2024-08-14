import pyximport; pyximport.install()
import pebble
import time
import hashlib
import itertools

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
    with open(file_path, 'r') as file:
        for line in file:
            node1, node2 = map(int, line.strip().split())
            bonds.append((node1, node2))
    return bonds

if __name__ == '__main__':
    

    #times = []
    
#for j in range(100,5000,100):
    G = pebble.lattice() # initialize a lattice
    #start = time.time()
    # add a few bonds:

    # 1---2---3
    # : .':'.':
    # 4---5---6
    # :   :   :
    # 7---8---9
    # : .': .':
    #10--11--12
    ##range_limit = round(j*0.5)
    ##num_pairs = j
    ##pairs = []
    ##while len(pairs) < num_pairs:
        ##x, y = np.random.choice(range_limit, 2, replace=False)
        ##pairs.append((x, y))
    ##bond = pairs
    #bond = [(1,2),(2,3),(3,4),(4,1)]
    #bond = [(1,2),(2,3),(3,4),(1,3),(4,6),(6,7),(8,9),(5,4),(5,6),(6,15),(5,15),(15,13),(16,13),(16,15),(7,8),
    #(13,7),(13,14),(14,10),(9,10),(10,11),(11,12),(2,18),(18,17),(17,16),(17,19),(19,20),(5,18),(5,17),(11,22),
    #(19,16),(16,21),(21,14),(14,22),(21,22),(22,23),(23,12),(21,30),(22,30),(23,30),(29,30),(26,55),(16,20),(20,21),
    #(29,20),(29,56),(56,27),(56,20),(27,17),(25,27),(25,18),(25,24),(26,25),(26,24),(2,24),(26,28),(24,18),
    #(28,48),(28,49),(28,27),(48,34),(48,44),(48,35),(48,47),(35,44),(35,34),(35,36),(34,31),(36,31),
    #(36,37),(31,33),(33,38),(31,37),(37,38),(38,39),(39,40),(40,41),(41,38),(41,42),(42,43),(42,37),
    #(44,45),(45,46),(44,46),(46,47),(47,49),(47,28),(49,50),(49,51),(50,51),(51,53),(51,52),(53,54),
    #(54,52),(52,55),(54,55),(27,48),(30,31),(23,32),(32,33)]
    bond = read_bonds_from_file('pairwise.dump')
    #assert len(bond) == 6 # check bond number counting
    print ('---------adding bond-----------')
    for i in bond:
        # add bond
        if G.add_bond(i[0],i[1]): # if the bond is independent, add_bond returns True, otherwise False
            print ('added bond %d --- %d, independent bond'%i)
        else:
            print ('added bond %d --- %d, redundant bond'%i)
    print ('-------------------------------\n\n')

    # check simple statistics:
    G.stat()
    print ('---------statistics-----------')
    print ('site number: %d'%G.statistics['site'])
    print ('bond number: %d'%G.statistics['bond'])
    print ('floppy mode count: %d'%G.statistics['floppy_mode'])
    print ('state of self-stress counting: %d'%G.statistics['self_stress'])
    print ('------------------------------\n\n')

    # decompose into rigid components:
    G.decompose_into_cluster()
    print ('---------rigid cluster-----------')
    print ('cluster number: %d'%G.cluster['count'])
    for key,value in G.cluster['index'].items():
        print ('cluster %d has %d bonds'%(key,len(value)))
        print ('the bonds are:')
        for i in value:
            print ('%d ------ %d'%i)
    print ('---------------------------------\n\n')


    # decompose stressed bond:
    G.decompose_stress()
    print ('---------stressed bond-----------')
    print ('there are %d stressed bond,they are:'%len(G.stress))
    for i in G.stress:
        print ('%d ------ %d'%i)
    print ('---------------------------------\n\n')

    # utilities:
    print ('-----------utilities------------')
    print ('test if 2 sites are relatively rigid:')
    if G.collect_four_pebble(1,5):  # if 4 pebble can be collected, return True: the two sites are not rigid.
        print ('site 1 and 5 are relatively floppy')
    else:
        print ('site 1 and 5 are relatively rigid')
    #print ('raw graph:')
    #print (G.graph)
    #print ('raw directed graph with pebble number, format: {site number:[list of connected sites, pebble number]}')
    #print (G.digraph)
    print ('--------------------------------\n\n')


    sorted_cluster_indices = sorted(G.cluster['index'], key=lambda cluster_index: len(G.cluster['index'][cluster_index]), reverse=True)
    sorted_clusters = {index: G.cluster['index'][index] for index in sorted_cluster_indices}
    largest_two_entries = {index: sorted_clusters[index] for index in sorted_cluster_indices[:2]}
    first_entry_key = next(iter(largest_two_entries))
    first_entry_value = len(largest_two_entries[first_entry_key])
    second_entry_key = next(itertools.islice(iter(largest_two_entries), 1, 2))
    second_entry_value = len(largest_two_entries[second_entry_key])  
    cluster_sizes = [len(G.cluster['index'][cluster_index]) for cluster_index in G.cluster['index']]
    print(cluster_sizes)
    file1 = open("bonds.dump","w+")
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




    cluster_bonds = {index: [] for index in G.cluster['index']}
    # Populate the dictionary with bond indexes
    for bondIndex, (node1, node2) in enumerate(G.bond):
        cluster_index = G.cluster['bond'].get((node1, node2))
        cluster_size = len(G.cluster['index'][cluster_index])
        if cluster_index is not None and cluster_size >= 3 :
            cluster_bonds[cluster_index].append(bondIndex + 1)
    with open('clusters.txt', 'w') as file:
        for cluster_index, bonds in cluster_bonds.items():
            file.write(f"{' '.join(map(str, bonds))}\n")
    with open('clusters.txt', 'r+') as file:
        file.seek(0, 2)  # Move the cursor to the end of the file
        file.seek(file.tell() - 1, 0)  # Move the cursor back one character
        file.truncate()  # Truncate the file at the current cursor position
    file1.close()
    #end = time.time()
    #times.append(end-start)
    #del G
#plt.plot(times)
#plt.xlabel('Nodes in Network')
#plt.ylabel('Time to run Pebble Algo')
#plt.title('Runtime vs Network Size')
#plt.savefig('plot.png')
#plt.show(block=True)










