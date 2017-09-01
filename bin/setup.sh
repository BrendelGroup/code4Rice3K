#!/bin/bash
## This is the install file for code4Rice3K
set -euo pipefail

# Create work environment
root="$(pwd)"
outputdir="$(pwd)"
cd $root
source $root/bin/code4Rice3K.conf
# Check if the user specified that this is a High Performance Computing environment
system_type=${1:-}
if [[ "$system_type" == "hpc" ]]; then
	. /etc/profile.d/modules.sh >/dev/null 2>&1
	module load samtools 2>&1
	echo "samtools module loaded"
fi

# Download Picard tool
cd $root/src
echo "Downloading Picard"
wget -qN "https://github.com/broadinstitute/picard/releases/download/2.10.3/picard.jar"

# Install GATK
cd $root/src
echo "Downloading GATK"
wget -qO- 'https://software.broadinstitute.org/gatk/download/auth?package=GATK-archive&version=3.6-0-g89b7209' | tar xfj -
rm -r resources/

# Download reference sequence
cd $root/reference
echo "Downloading reference fasta"
wget -qO- "http://rapdb.dna.affrc.go.jp/download/archive/irgsp1/IRGSP-1.0_genome.fasta.gz" | gunzip - > IRGSP-1.0_genome.fasta

# Prepare faidx index and dict of reference genome
echo "Indexing reference"
samtools faidx IRGSP-1.0_genome.fasta
rm -f IRGSP-1.0_genome.dict
java -jar ${src}/picard.jar CreateSequenceDictionary R=IRGSP-1.0_genome.fasta O=IRGSP-1.0_genome.dict

cd $root
echo "Removing Picard because it is no longer needed"
rm ${src}/picard.jar

cd $root
echo ""
echo "Installation Complete"
echo ""
exit
