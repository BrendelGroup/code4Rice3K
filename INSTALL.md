# Installation Instructions

## Getting the Code4Rice3K Workflow

You can simply obtain this entire workflow by cloning the Code4Rice3K repository into your local machine as follows:

```bash
git clone https://github.com/BrendelGroup/Code4Rice3K  
cd Code4Rice3K
```

## Software Requirements

This workflow has been developed and tested on Linux machines only. 
Specifically, Ubuntu and Red Hat Enterprise linux systems. 
That being said, there are other softwares and tools that need to be installed on your machine (if they are not already installed) as they are intrinsic to this workflow.
For convenience, a script is provided under the `bin/` directory to check for any required software.
You can simply run it with `./xinstallcheckprerequisites`, and it should tell you if if finds an error. 

There is more than one way to install softwares on your linux machine; 
You can run the `xinstallCode4Rice3K` script provided under the `bin/` directory, it will install all the necessary softwares.
Or, if you prefer, you can manually install these softwares using the short guide below.
For either methods, please make sure to keep track of paths of any installed binaries (see below for details).

The versions listed are the ones that have been successfully tested.

### Java (version 8)
See https://www.java.com/en/download/ for details. Last update: August 1, 2017.

You can check the availability and version of java on your machine by running:

`java -version`

If you need to install it, please follow the instructions below:
```bash
mkdir $YOUR_PREFERRED_DIRECTORY/Java
cd Java
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
tar zxvf jdk-8u131-linux-x64.tar.gz
# Now use an editor like "vim" or "nano" to add the following lines into your "~/.profile", save it, and run "source ~/.profile" in the command line:
export JAVA_HOME=path_to_jdk1.8.0_131_directory
export PATH=$JAVA_HOME/bin:$PATH
```

### Samtools (version 1.5)
See http://www.htslib.org/download/ for details. Last update: August 1, 2017.

First, check the availability and version of samtools on your machine. 
You can do this by running:

`samtools --help`

If you want to install it, use:
```bash
mkdir $YOUR_PREFERRED_DIRECTORY/Samtools
cd Samtools  
wget https://github.com/samtools/samtools/releases/download/1.5/samtools-1.5.tar.bz2  
tar xvjf samtools-1.5.tar.bz2  
cd samtools-1.5/
./configure --without-curses --disable-lzma  
make  
make install		# You may need to use "sudo make install"
```

### Tabix (version 0.2.6)
See http://www.htslib.org/doc/tabix.html for details. Last update: August 1, 2017.

First, check the availability and version of tabix on your machine.
You can do this by:

`tabix --help`

If you want to install it, use:
```bash
mkdir $YOUR_PREFERRED_DIRECTORY/Tabix
cd Tabix  
wget https://sourceforge.net/projects/samtools/files/tabix/tabix-0.2.6.tar.bz2  
tar xvjf tabix-0.2.6.tar.bz2
cd tabix-0.2.6
make
# add the following line to your "~/.profile" file found in your home directory, save the file, and then run "source ~/.profile" in the command line.
export PATH=$PATH:/path_to_tabix_dir/tabix-0.2.6
```

### Bcftools (version 1.5)
See http://www.htslib.org/download/ for details. Last update: August 1, 2017.

First, check the availability and version of bcftools on your machine. 
You can do this by running:

`bcftools --help`

If you want to install it, use:
```bash
mkdir $YOUR_PREFERRED_DIRECTORY/Bcftools
cd Bcftools  
wget https://github.com/samtools/bcftools/releases/download/1.5/bcftools-1.5.tar.bz2  
tar xvjf bcftools-1.5.tar.bz2 
cd bcftools-1.5/
./configure --without-curses --disable-lzma    
make  
make install		# You may need to use "sudo make install"
```

### VCFtools (version 0.1.13)
See http://vcftools.sourceforge.net for details. Last update: August 1, 2017.

First, check the availability and version of vcftools on your machine. 
You can do this by running:

`vcftools --help`

If you want to install it, first you have to install **Tabix** (see above) then:
```bash
mkdir YOUR_PREFERRED_DIRECTORY/VCFtools
cd VCFtools  
wget https://sourceforge.net/projects/vcftools/files/vcftools_0.1.13.tar.gz  
tar zvxf vcftools_0.1.13.tar.gz
cd vcftools_0.1.13 
make
# add the following line to your "~/.profile" file found in your home directory, save the file, and then run "source ~/.profile" in the command line.
export PERL5LIB=/path_to_vcftools/vcftools_0.1.13/perl
export PATH=$PATH:/path_to_vcftools/vcftools_0.1.13/bin/
```

### Python (version 2.7)
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
See https://pypi.python.org/pypi/PyVCF for details. Last update: August 1, 2017.

Same as installing biopython, you can use:
```bash
pip install pyvcf --user
```

### Picard (version 2.10.0)
See https://broadinstitute.github.io/picard/ for details. Last update: September 15, 2017. 

```bash
mkdir $YOUR_PREFERRED_DIRECTORY/Picard
cd Picard/
wget https://github.com/broadinstitute/picard/releases/download/2.10.9/picard.jar
```
You will need to set the path for Picard in the `xsetupReference` script under the `bin/` directory.
Open the script using an editor, and change the path in the following line to where Picard is installed:
```bash
PICARD=/usr/local/src/NGS_DIR/Picard/picard.jar
```

### GATK (version 3.6)
See https://software.broadinstitute.org/gatk/ for details. Last update: September 15, 2017.

```bash
mkdir $YOUR_PREFERRED_DIRECTORY/GATK
cd GATK
wget -qO- 'https://software.broadinstitute.org/gatk/download/auth?package=GATK-archive&version=3.6-0-g89b7209' | tar xfj -
```
You will need to set the path for GATK in the `code4Rice3K.conf` configuration file under the `bin/` directory.
Open the file using an editor, and change the path in the following line to where GATK is installed:
```bash
gatk=java -jar /usr/local/src/code4Rice3K/GATK/GenomeAnalysisTK.jar
```

### RAxML (version 8.2.11)
See [RAxML](https://sco.h-its.org/exelixis/web/software/raxml/index.html) for details. Last update: August 1, 2017.

First, check the availability and version of RAxML on your machine. 
You can do this by running:

`raxmlHPC-PTHREADS -help`

For installations, you will have to clone the RAxML repository from github:
```bash
mkdir $YOUR_PREFERRED_DIRECTORY/RAxML
cd RAxML
git clone https://github.com/stamatak/standard-RAxML.git
cd standard-RAxML/
make -f Makefile.gcc
rm *.o
# add the following line to your "~/.profile" file found in your home directory, save the file, and then run "source ~/.profile" in the command line.
export PATH=$PATH:/path_to_raxml_directory/raxmlHPC-PTHREADS
```

## Setup Instructions

The only step left to be done is to prepare the reference genome for the variant calling.
You can do this by executing the `xsetupReference` in the `bin/` directory, which will install the `reference/` directory in your _code4Rice3K_ install directory.
