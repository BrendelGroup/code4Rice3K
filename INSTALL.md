# Installion Instruction

## Getting the Code4Rice3K Workflow

You can simply obtain this entire workflow by cloning the Code4Rice3K into your local machine as follows:

`git clone https://github.com/BrendelGroup/Code4Rice3K`
`cd Code4Rice3K`

## Prerequisites

This workflow has been developed and tested on Linux machines only. That being said, there are other tools and libraries that need to be 
installed on your machine as they are intrinsic to this workflow. These tools are listed below with the versions that have been tested 
successfully.
* samtools version 1.3.x
* Oracle Java version 1.8.0_131 OR OpenJDK Java version 1.8.0_40
* Tabix version 0.2.6
* bcftools version 1.3.*
* vcftools version 0.1.13 (version 0.1.14 does not work)
* Python version 2.7.x
* Biopython version 1.70
* PyVCF version 0.6.8
* RAxML version 8.2.10

## Setup Instructions

Running the `setup.sh` bash script is all you need to get you going and use the Code4Rice3K workflow. 

`bash setup.sh`

This script will take care of few things for you. It will install some files necessary to this workflow; like the GATK tools themselves, 
the reference genome used in the 3k rice genome project, and it will create some necessary directories.
