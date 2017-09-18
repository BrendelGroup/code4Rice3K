## Code4Rice3K HOWTO - an overview about how to use this workflow

Before using this workflow, you should go through the `INSTALL.md` document and run the `xsetupReference` script after making sure all of the required software is installed. 

This workflow has two main scripts. 
The first, `generatevcf`, takes a cultivar accession name, and automates the following steps:
- Step 1: A BAM alignment file of reads for the specified cultivar is downloaded to the `bamfiledir` directory and indexed by samtools. A list of all available BAM files is provided (see _allcultivars.txt_ under the 
`demo/` directory).
- Step 2: The GATK tool HaplotypeCaller generates a GVCF file containing the variant sites in the specified caller.
- Step 3: The GATK tool GenotypeGVCFs generates a VCF file containing every successfully called site for that cultivar.
- Step 4: The VCF file is split by chromosome, and all indels, heterozygous sites, and Multiple Nucleotide Polymorphisms are removed.

This script takes the following arguments when used:

```bash
	./generatevcf -c <configfile> -i <cultivar> -o <path> --nt <data_threads> --nct <cpu_threads_per_data_thread>
	
	1) Mandatory options:
	-i|--infile <string>		:	The name of the chosen rice cultivar (for names, see above)
	
	2) Optional setings:
	-c|--configfile <path>		:	This is the config file for code4Rice3K workflow
	-b|--bamfiledir <path>		:	location of bam files
	-r|--reference <path>		:	location of reference genome
	-o|--outputdir <path>		:	Directory path for the output files
	--nt <int>			:	The number of data threads used by GATK (6-24 is recommended)
	--nct <int>			:	The number of CPU threads used by GATK (4-12 is recommended)
	--startfromstep <string>	:	Indicate the starting step, must be between step1-step4 (see below) 
	--stopatstep <string>		:	Indicate the last step, must be between step1-step4 (see below)
	--runonlystep <string>		:	Indicate a single step to run, e.g. step1 or step3 (see below)
	-h|--help			:	Disply a help message
```


An example of usage, assuming you are at the code4Rice3K main directory, run:

```bash
bash ./bin/generatevcf -c bin/code4Rice3K.conf -i IRIS_313-10603 -b bamfiledir -r reference --nt 12 --nct 4
```  

You can use any cultivar name, however, for the sake of demonstration, use the provided "sample-1, sample-2,sample-3, or sample-4" as a cultivar name. 
These are truncated files found under the `demo/` directory. 

The second script `generatetree`, takes a text file containing at least four or more rice accessions, and automates the following steps:
- Step 1: The VCF files generated for each chromosome by `generatevcf` are merged in parallel, excluding any sites that lack at least one SNP or are not called in all of the input cultivars
- Step 2: The merged chromosome VCFs are concatenated into one VCF
- Step 3: A subset of sites are chosen at random from the concatenated VCF and converted into a FASTA-format alignment of the cultivars
- Step 4: RAxML generates a maximum-likelihood tree based on the alignment

This script takes the following arguments when used:

```bash 
	./generatetree -c <configfile> -i <listofcultivars> -o <path>
                
        1) Mandatory options:
        -i|--inputlist <textfile>	 :       List containing the names of all cultivars to be inferred. Names must be separated by newlines.
                
	2) Optional setings:
	-c|--configfile <path>		 :	 Configuration file for the code4Rice3K workflow
	-o|--outputdir <string>	         :	 Directory path for the output files
	-n|--nthreads			 :       number of threads to use for raxml
        --startfromstep <string>   	 :       Indicate the starting step, must be between step1-step4 (see below) 
        --stopatstep <string>      	 :       Indicate the last step, must be between step1-step4 (see below)
        --runonlystep <string>     	 :       Indicate a single step to run, e.g. step1 or step3 (see below)
        -h|--help                     	 :       Disply this help message
```

An example of usage, assuming you are at the code4Rice3K main directory, run:

```bash
bash ./bin/generatetree -c bin/code4Rice3K.conf -i yourlist.txt -n 12
```

Where _yourlist.txt_ is a list containing the accessions of all the cultivars you have processed using the first script separated by newlines.
For convenience, the `demo/` directory contains a text file, testcultivar.txt, that contains four accessions (sample-1 to sample-4) for testing.

After running `generatetree`, the output directory will contain RAxML output files, including a file labeled "bestTree".
This can be visualized with tree viewing software such as [FigTree](http://tree.bio.ed.ac.uk/software/figtree/).

### Large-scale work:
The rice genome data is huge and this process can be time-consuming; the `generatevcf` step for a single cultivar might take up to 48 hours when run on an 8-cpu computer with 30GB of RAM.
So it is best, if possible, to use this workflow with a high-performance computing cluster (HPC). 
These HPCs differ in their operating systems, softwares installed, and the way you interact with depending on which cluster you are using. 

For example, we have used this workflow with [Karst](https://kb.iu.edu/d/bezu), one of the HPC machines available at Indiana University, where we can submit this workflow as a batch job using 
[TORQUE](https://kb.iu.edu/d/avmy) resorce manager. An example of a job submission script is provided under the `demo/` directory. 
