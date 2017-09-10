# Installation Instructions

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
If everything is ok, then you should get a few lines informing you that these packages are installed along with their versions.
You should see something like this:
```bash
Sun/Oracle Java SE Development Kit version 1.8.0_131 loaded.
Python programming language version 2.7.13 loaded.
samtools version 1.5 loaded.
bcftools version 1.5 loaded.
vcftools version 0.1.13 loaded.
tabix version 0.2.6 loaded.
raxml version 8.2.11 loaded.
```
If you want to check for the availability of a different version of a certain software, you can do this using the "module avail $package", e.g. `module avail java`.
If your system missing some key softwares (you can tell when you load the modules), or if you want to install softwares on your linux machine, then please follow 
the short guide below. 
The versions listed are the ones that have been successfully tested.

### Java (version 8)
See https://www.java.com/en/download/ for details. Last update: August 1, 2017.

You can check the availability and version of java on your machine by running:

`java -version`

If you need to install it, please follow the instructions below:
```bash
cd $YOUR_PREFERRED_DIRECTORY/local/
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
tar zxvf jdk-8u131-linux-x64.tar.gz
# Now use "vim" or "nano" to add the following lines into your "/etc/profile":
# If you can't write to "/etc/profile", then make a custom script in "/etc/profile.d/" and add:
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
cd $YOUR_PREFERRED_DIRECTORY/local/  
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
cd $YOUR_PREFERRED_DIRECTORY/local/  
wget https://sourceforge.net/projects/samtools/files/tabix/tabix-0.2.6.tar.bz2  
tar xvjf tabix-0.2.6.tar.bz2
cd tabix-0.2.6
make
# add the following line to your ".bashrc" file found in your home directory, save your ".bashrc" file, and run "source .bashrc" in the command line.
export PATH=$PATH:/path_to_tabix_dir/tabix-0.2.6
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
tar xvjf bcftools-1.5.tar.bz2 
cd bcftools-1.5/
./configure --without-curses --disable-lzma    
make  
make install		# You may need to use "sudo make install"
```

### Vcftools (version 0.1.13)
See http://vcftools.sourceforge.net for details. Last update: August 1, 2017.

First, check the availability and version of vcftools on your machine. 
You can do this by running:

`vcftools --help`

If you want to install it, first you have to install **Tabix** (see above) then:
```bash
cd YOUR_PREFERRED_DIRECTORY/local  
wget https://sourceforge.net/projects/vcftools/files/vcftools_0.1.13.tar.gz  
tar zvxf vcftools_0.1.13.tar.gz
cd vcftools_0.1.13 
make
# add the following line to your ".bashrc" file found in your home directory, save your ".bashrc" file, and run "source .bashrc" in the command line.
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
See https://pypi.python.org/pypi/PyVCF for details. Last upadate: August 1, 2017.

Same as installing biopython, you can use:
```bash
pip install pyvcf --user
```

### RAxML (version 8.2.11)
See [RAxML](https://sco.h-its.org/exelixis/web/software/raxml/index.html) for details. Last update: August 1, 2017.

First, check the availability and version of RAxML on your machine. 
You can do this by running:

`raxmlHPC-PTHREADS -help`

For installations, you will have to clone the RAxML repository from github:
```bash
git clone https://github.com/stamatak/standard-RAxML.git
cd standard-RAxML/
make -f Makefile.gcc
rm *.o
# add the following line to your ".bashrc" file found in your home directory, save your ".bashrc" file, and run "source .bashrc" in the command line.
export PATH=$PATH:/path_to_raxml_directory/raxmlHPC-PTHREADS
```

## Setup Instructions

The only step left to be done is to prepare the reference genome for the variant calling.
You can do this by executing the _xsetupReference_ in the _bin_ directory, which will install the _reference_ directory in your _code4Rice3K_ install directory.
