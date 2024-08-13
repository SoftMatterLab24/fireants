# Contraction Workflow
This repository contains the necessary workflow to analyze the rigidity of arbitrarily generated networks, and includes extra scripts used to visuallize results in [Ovitio](https://www.ovito.org/) . 

## To Do
- [ ] Aidan: document cython ... see [Formatting Syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) to see how to write text in the README
- [ ] Aidan: upload python clusterproc scripts
- [ ] Aidan: download preproc scripts and do a test of the workflow with your clusterproc scripts [number of frames: 30; number of networks: 2]
- [ ] Zach: add ovitio instructions

## Directory Content 

- src - contains the necessary scripts to process data
  - preproc - blank
    - func1_video_to_frame.m - takes video of interest and extracts individual frames at specified sampling rate, then segments frames to logical image 
    - func2_frame_to_nodes.m - take frame and creates N arbitrarily generated networks, writes data to ATOM.dump, BONDS.dump, and pairlist.in files.
    - getBW.m - segments image to logical
    - BWtoNodes.m - radomly packs the logical image with "ants" based on cutoff distance
    - buildPairlist.m - create bonds between the ants if within cutoff distance
    - writeATOMS.m - saves ant coordinates to ATOMS.dump for Ovitio visualization
    - writeBONDS.m - saves bond information to BONDS.dump for Ovitio visualization
    - writePAIRLIST.m - saves bond pairlist information for Cluster Analysis
  - clusterproc - blank
  - postproc - blank

video - contains a sample trial video

## Running Matlab .m Scripts


## Running Python
   *Aidan document your code here and provide descriptions on how to operate the scripts*

## Visualization in Ovitio
  *lets work on adding a description on how to visualize the clusters*

