## Code4Rice3K - HOWTO

Before using this workflow, you should go through the `INSTALL.md` document and run the `setup.sh` script after making sure all of the required software is installed. 

This workflow has two main scripts. 
The first, `generatevcf`, is given a cultivar accession as its first argument and automates the following steps:
- A BAM alignment file of reads for the specified cultivar is downloaded to the `maps` directory and indexed by samtools
- The GATK tool HaplotypeCaller generates a GVCF file containing the variant sites in the specified caller
- The GATK tool GenotypeGVCFs generates a VCF file containing every successfully called site for that cultivar
- The VCF file is split by chromosome, and all indels, heterozygous sites, and Multiple Nucleotide Polymorphisms are removed

Use: `./generatevcf $cultivar`, where `$cultivar` is any Rice3K cultivar accession, e.g. IRIS_313-10603. 

The second script `generatetree`, takes as its first argument a text file containing three or more rice accessions and automates the following steps:
- The VCF files generated for each chromosome by `generatevcf` are merged in parallel, excluding any sites that lack at least one SNP or are not called in all of the input cultivars
- The merged chromosome VCFs are concatenated into one VCF
- A subset of sites are chosen at random from the concatenated VCF and converted into a FASTA-format alignment of the cultivars
- RAxML generates a maximum-likelihood tree based on the alignment

Use: `./generatetree $cultivarlist`, where `$cultivarlist` is text file containing three or more rice accessions separated by newlines.

The `demo` directory contains a text file, testcultivar.txt, that contains four accessions for testing.
The following commands can be used to test the functionality of these scripts:
```
while read cultivar; do ./generatevcf $cultivar; done < demo/testcultivars.txt  
./generatetree demo/testcultivars.txt
```

This can be time-consuming; the `generatevcf` step for a single cultivar might take up to 48 hours when run on an 8-cpu computer with 30GB of RAM.
In order to improve on this, the workflow can be submitted as a batch job to a high-performance computing cluster.
In this case, both `generatevcf` and `generatetree` require the string "hpc" as their second argument: `./generatevcf $cultivar hpc` and `./generatevcf $cultivarlist hpc`
For example, on the Karst HPC cluster at Indiana University:

`while read cultivar; do qsub -N "${cultivar}.generatevcf" -k o -j oe -l nodes=1:ppn=12,walltime=24:00:00,vmem=20gb generatevcf -F "$cultivar hpc"; done < demo/testcultivars.txt`

After these jobs finish running:

`qsub  -k o -j oe -l nodes=1:ppn=12,walltime=24:00:00,vmem=20gb generatetree -F '${PBS_O_WORKDIR}/demo/testcultivars.txt hpc'`

After running `generatetree`, the `alignments` directory will contain RAxML output files, including a file labeled "bestTree".
This can be visualized with tree viewing software such as [FigTree](http://tree.bio.ed.ac.uk/software/figtree/).

