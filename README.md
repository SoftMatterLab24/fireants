# Contraction Workflow
This repository contains the necessary workflow to analyze the rigidity of arbitrarily generated networks, and includes extra scripts used to visuallize results in [Ovitio](https://www.ovito.org/) . 

## To Do
- [ ] Aidan: document your cython scripts ... see [Formatting Syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) to see how to write text in the README
- [ ] Aidan: work on writing script that will divide frame into subdomains and identifies nodes within that subdomain (pre-proc scripts are now updated)
- [ ] Aidan:
- [ ] Zach: add ovitio instructions

## Directory Structure
The following directory structure with included matlab and python scripts, and file descriptions is adopted to faciliate the workflow.

```
fireants
|    README.md
|    LICENSE
|
|--- src - contains the necessary scripts to process data
|    |
|    |--- preproc
|    |    |    func1_video_to_frame.m - takes video of interest and extracts individual frames at specified sampling rate, then segments frames to logical image 
|    |    |    func2_frame_to_nodes.m - take frame and creates N arbitrarily generated networks, writes data to ATOM.dump, BONDS.dump, and pairlist.in files.
|    |    |    getBW.m - segments image to logical
|    |    |    BWtoNodes.m - randomly packs the logical image with "ants" based on cutoff distance
|    |    |    buildPairlist.m - create bonds between the ants if within cutoff distance
|    |    |    writeATOMS.m - saves ant coordinates to ATOMS.dump for Ovitio visualization
|    |    |    writeBONDS.m - saves bond information to BONDS.dump for Ovitio visualization
|    |    |    writePAIRLIST.m - saves bond pairlist information for Cluster Analysis
|    |
|    |--- clusterproc
|    |    |    func3_network_to_rigidity.py - takes pairlist from network and runs pebble game algorithm determines rigidity of network, then outputs data to BONDS.dump, clusterDist.out
|    |
|    |--- postproc
|    |    |
|    
|--- video

```
## Executing the Workflow
To execute the workflow, users first create a $${\color{orange}\bf{folder}}$$ and place the desired video to be analyzed.

## Running Matlab .m Scripts


## Running Python
   To run the Python/Cython section one must have some Python version 3.xx.xx installed as well as Cython

   To install compilers for Python type `sudo apt install python3` in linux terminal

   To install compilers for Cython type `sudo apt install cython` in linux terminal
   
   To compile and run the code navigate to the directory of the clusterProc folder and copy the previously created $${\color{orange}\bf{folder}}$$ into the clusterProc folder 
   
   Then just input `python3 example.py build_ext pebble.pyx` into the linux terminal

## Visualization in Ovitio
  *lets work on adding a description on how to visualize the clusters*

