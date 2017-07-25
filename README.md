# Code4Rice3K
-------------------------------------------------------------------------------------------------
This workflow is designed to study the relationship among cultivars obtained from the [3k Rice Genome 
project (3kRGP)](http://gigadb.org/dataset/200001). It utilizes the GATK tools developed by the Broad Institute, along other third-party 
tools, to generate VCF files containing all of the called sites in a given cultivar. It also generate VCF files for each chromosome in 
the cultivar with indels, Multiple Nucleotide Polymorphisms, and any uncalled or heterozygous sites removed. The output of this 
workflow is a tree file showing the relationship among all processed cultivars.

## Getting Started
------------------------------------------------------------------------------------------------------
First, please see the `INSTALL.md` file. There you will find instructions for how to obtain this work flow, 
prerequisites installation, and then run the setup script. Once this has been taken care of, proceed to the `HOWTO` file to start 
analyzing the genome of rice cultivars. We provided a list of 4 cultivars that you can use to test this workflow and generate a tree. 
You can find this list in text file `testcultivars`  

## Overview of Directories
-----------------------------------------------------------------------------------------------------------
After running this workflow you will end up having a number of files in directories created by the `setup.sh` script.
* `maps/`: Conatins all the downloaded alignment files of the rice cultivars.
* `calls/`: Contains all the gVCF and VCF files that resulted from running the HaplotypeCaller and genotypeGVCFs, respectively.
* `split/`: Conatins VCF files for each chromosome per cultivar.
* `merges/`: Contains VCF files for combined cultivars for each one of the 12 rice chromosomes.
* `alignments/`: Holds the final RAxML file ready for tree viewing.   

## Reference
----------------------------------------------------------------------------------------
* 3K R.G.P. The 3,000 rice genomes project. GigaScience 2014, 3:7 
[Article](https://gigascience.biomedcentral.com/articles/10.1186/2047-217X-3-7)
