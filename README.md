# Code4Rice3K

This workflow is designed for the study of relationships among rice cultivars from the [3k Rice Genome project (3kRGP)](http://gigadb.org/dataset/200001).
It utilizes the GATK tools developed by the Broad Institute, along with other third-party tools, to generate VCF files containing all of the called sites in a given cultivar. 
It also generate VCF files for each chromosome in the cultivar with indels, Multiple Nucleotide Polymorphisms, and any uncalled or heterozygous sites removed. 
The output of this workflow is a tree file showing the relationship among all processed cultivars.

## Getting Started

First, please see the `INSTALL.md` file. 
There you will find instructions for how to obtain this workflow and install prerequisite software, and how to set up the reference genome. 
Next, read the `HOWTO` file found in `demo` directory for instructions and examples of using this workflow.  

## Reference

* 3K R.G.P. The 3,000 rice genomes project. GigaScience 2014, 3:7 
[Article](https://gigascience.biomedcentral.com/articles/10.1186/2047-217X-3-7)
