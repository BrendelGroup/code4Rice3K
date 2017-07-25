## Code4Rice3K - HOWTO
--------------------------------------------------------------
Before start using this workflow, you should have went through the INSTALL.md document by now and was able to run the `setup.sh` script 
successfully after making sure all of the prerequisites are installed. 

The workflow has two main steps. In the first step, the specified cultivar alignment file will be downloaded to the `maps` directory, 
then both the HaplotypeCaller and GenotypeGVCFs tools will be called to generate a `.vcf` file from the downloaded `.bam` files. This simply 
done by running the `generatevcf` script provided with a cultivar name.

<dd>`bash generatevcf cultivar`</dd>

where `cultivar` is any cultivar name, e.g. IRIS_313-10603. We have included 4 rice cultivar names in the provided text file 
(testcultivars) for you test. This step can be time-consuming; for each cultivar it might take up to 48 hours when run on an 8-cpu 
computer with a 30GB of ram.

In the second step, the script will take all the files generated using the `generatevcf` script as input files, and merge the
chromosomes in parallel. It will also strip any site that doesn't have SNPs, and concatenate them into a new VCF file containing
only the sites with SNPs. A subset of these SNPs are chosen at random and used as an alignment from which a maximum-likelihood tree
is generated.

For this step you need to make a list containing the names of all cultivars that need to be processed (similar to what we have done in 
our `testcultivars` list), then call the script `generatetree` on that list, as follows:

<dd>`bash generatetree testcultivars`</dd>

**Note**: Here it took about 10 hours to process 20 cultivars. If more cultivars being processed, then more time might be needed.

At this step you should end up with a single file ready to be viewed by a tree viewer program. For instance, we used the **FigTree
v1.4.3** to visualize our tree.

