# Installion Instructions

## Getting the Code4Rice3K Workflow

You can simply obtain this entire workflow by cloning the Code4Rice3K into your local machine as follows:

```bash
git clone https://github.com/BrendelGroup/Code4Rice3K  
cd Code4Rice3K
```

## Software Requirements

This workflow has been developed and tested on Linux machines only. 
Specifically, Ubuntu and Red Hat Enterprise linux systems. 
That being said, there are other softwares and tools that need to be installed on your machine (if they are not installed already) as they are intrinsic to this workflow.
If you are running this workflow on a high performance computing (HPC) cluster, then the required softwares are part of modules environment management system.
By loading different software packages, you can set and modify the programming environment as needed. 
Now to check for the required packages, copy and paste the following command into your terminal and hit enter:
```bash
module load java python samtools bcftools vcftools tabix raxml
```
If everything is ok, then you should get a few lines informing you that these packages are installed along with its version.
If you want to check for the availibility of a different version of a certain software, you can do this using the "module avail $package", e.g. `module avail java`.
If your system missing some key softwares (you can tell when you load the modules), or if you want to install softwares on your linux machine, then please follow 
the short guide below. 
The versions listed are the ones that have been successfully tested.

### Java (version 8)
See https://www.java.com/en/download/ for details. Last update: August 1, 2017.

You can check the availability and version of java on your machine by running:

`java -version`

If you need to install it, please download the appropriate version [here](http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html) and follow the 
instructions. 

### Samtools (version 1.5)
See http://www.htslib.org/download/ for details. Last update: August 1, 2017.

First, check the availability and version of samtools on your machine. 
You can do this by running:

`samtools --help`

If you want to install it, use:
```bash
cd $YOUR_PREFERRED_DIRECTORY/local/`  
wget https://github.com/samtools/samtools/releases/download/1.5/samtools-1.5.tar.bz2  
tar -xjf  
cd samtools-1.5/  
make  
make install
```

### Tabix (version 0.2.6)
See http://www.htslib.org/doc/tabix.html for details. Last update: August 1, 2017.

First, check the availability and version of tabix on your machine.
You can do this by:

`tabix -help`

If you want to install it, use:
```bash
cd $YOUR_PREFERRED_DIRECTORY/local/  
wget https://sourceforge.net/projects/samtools/files/tabix/tabix-0.2.6.tar.bz2/download  
tar -xjf  
cd tabix-0.2.6  
make  
make install 
```

### Bcftools (version 1.5)
See http://www.htslib.org/download/ for details. Last update: August 1, 2017.

First, check the availability and version of bcftools on your machine. 
You can do this by running:

`bcftools --help`

If you want to install it, use:
```bash
cd $YOUR_PREFERRED_DIRECTORY/local/  
wget https://github.com/samtools/bcftools/releases/download/1.5/bcftools-1.5.tar.bz2  
tar -xjf  
cd bcftools-1.5/  
make  
make install
```

### Vcftools (version 0.1.13)
See http://vcftools.sourceforge.net for details. Last update: August 1, 2017.

First, check the availability and version of vcftools on your machine. 
You can do this by running:

`vcftools --help`

If you want to install it, use:
```bash
cd YOUR_PREFERRED_DIRECTORY/local  
wget https://sourceforge.net/projects/vcftools/files/vcftools_0.1.13.tar.gz/download  
tar -zxf  
./configure  
make  
make install
```

### Python 2.7
See https://www.python.org for details. Last update: August 1, 2017.

You can check the availability and version of bcftools on your machine by running:

`python --version`

Python usually come pre-installed on most machines. 
If that is not the case and you want to install it, then there is more than one way to do so. Check the Python.org website for installation instructions. 

### Biopython (version 1.70)
See http://biopython.org for details. Last update: August 1, 2017.

If you have administrative privilage access on your machine, use the [package manager](http://biopython.org/wiki/Download#Packages) for best results. 
Otherwise, we recommend using pip.
```bash
pip install biopython --user
```
### PyVCF (version 0.6.8)
See https://pypi.python.org/pypi/PyVCF for details. Last upadate: August 1, 2017.

Same as installing biopython, you can use:
```bash
pip install pyvcf --user
```
### RAxML (version 8.2.11)
See [RAxML](https://sco.h-its.org/exelixis/web/software/raxml/index.html) for details. Last update: August 1, 2017.

First, check the availability and version of RAxML on your machine. 
You can do this by running:

`raxml -help`

For installations, you will have to clone the RAxML repository from github:
```bash
git clone https://github.com/stamatak/standard-RAxML.git
```
Then follow the instructions [here](https://github.com/stamatak/standard-RAxML) for compiling it. 

## Setup Instructions

Once you have all the required software packages installed, run `bash setup.sh` from the code4Rice3K directory.
If you are running this script on a high-performance computing machine, please add the argument "hpc" to your command, it will 
automatically load the necessary modules: `bash setup.sh hpc`

This script will:
- Create some necessary subdirectories for this workflow
- Download some software binaries used by the workflow
- Download and index the reference genome used by the Rice3K Genomes project
