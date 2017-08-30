#!/bin/bash


# function that will generate the gvcf file for a given cultivar

function call_variants() {
#TODO Add an argument for number of available processors
	cultivar=$1
	nct=$2
	$gatk -T HaplotypeCaller \
		-R ${reference}/IRGSP-1.0_genome.fasta \
		-I $bamfiles/${cultivar}.realigned.bam \
		-ERC GVCF \
		-o $gvcffiles/${cultivar}.g.vcf \
		-nct $2
}

function full_genotype() {
#TODO Add an argument for number of available processors
	cultivar=$1
	nt=$2
	$gatk -T GenotypeGVCFs \
		-R ${reference}/IRGSP-1.0_genome.fasta \
		-V $gvcffiles/${cultivar}.g.vcf \
		-allSites \
		-o $vcffiles/${cultivar}.full.vcf \
		-nt $2
}

function clean_vcf() {
	vcf=$1
	bgzip ${vcf} && tabix ${vcf}.gz
	bcftools view --exclude-uncalled --exclude-types 'indels' --genotype ^het -O v ${vcf}.gz | awk ' /^#/ {print} length($4) == 1 {print} ' > ${vcf%.vcf}.noindels_nohets_nomnps.vcf
}

function clean_and_split_vcf() {
	cultivar=$1
	bgzip ${cultivar}.full.vcf && tabix -f ${cultivar}.full.vcf.gz
#TODO Make this more sensible about parallelizing. As is, it will be really inefficient on a machine with fewer than 12 processors
	for chromosome in chr{01,02,03,04,05,06,07,08,09,10,11,12}; do (
		bcftools view --exclude-uncalled --exclude-types 'indels' --genotype ^het -r ${chromosome} -O v ${cultivar}.full.vcf.gz | awk ' /^#/ {print} length($4) == 1 && ( 
($5 != "<NON_REF>") || ($0 !~ /1\/1/) ) && ( ($5 !~ /^[ACGT],<NON_REF>/) || ($0 !~ /2\/2/) ) && ( ($5 !~ /^[ATCG],[ATCG],<NON_REF>/) || ($0 !~ /3\/3/) ) && ( ($5 !~ 
/^[ACGT],[ATCG],[ATCG],<NON_REF>/) || ($0 !~ /4\/4/) ) {print} ' | bgzip -c > ../chromosomefiles/${cultivar}.${chromosome}.noindels_nohets_nomnps.vcf.gz; tabix 
../chromosomefiles/${cultivar}.${chromosome}.noindels_nohets_nomnps.vcf.gz) &
	done
	wait
}

function merge_chromosome() {
#TODO Add an argument that determines which cultivars are merged. Right now it's indiscriminate.
	chromosome=$1
	vcf-merge *${chromosome}*.vcf.gz > ../mergedfiles/${chromosome}.merge.vcf
	# The awk command filters any Multiple Nucleotide Polymorphisms, and any sites that for some reason  are called as '<NON_REF>'
	< ../mergedfiles/${chromosome}.merge.vcf bcftools view --exclude-uncalled --exclude-types 'indels' --min-ac 2 --max-af 0.99 --genotype ^miss -O v | awk ' /^#/ {print} 
length($4) 
== 1 && ( ($5 != "<NON_REF>") || ($0 !~ /1\/1/) ) && ( ($5 !~ /^[ACGT],<NON_REF>/) || ($0 !~ /2\/2/) ) && ( ($5 !~ /^[ATCG],[ATCG],<NON_REF>/) || ($0 !~ /3\/3/) ) && ( ($5 !~ 
/^[ACGT],[ATCG],[ATCG],<NON_REF>/) || ($0 !~ /4\/4/) ) {print} ' > ../mergedfiles/${chromosome}.merge.cleaned.vcf
	bgzip ../mergedfiles/${chromosome}.merge.cleaned.vcf
	tabix ../mergedfiles/${chromosome}.merge.cleaned.vcf.gz
}

function only_SNPs() {
	cultivar=$1
	bgzip ${cultivar}.full.vcf && tabix -f ${cultivar}.full.vcf.gz
	< ${cultivar}.full.vcf.gz bcftools view --exclude-uncalled --types 'snps' --genotype ^het -O v > ../SNPsonly/${cultivar}.onlySNPs.vcf
}

function annotate_VCF() {
	# Input file must be VCF, not VCF.gz
	file=$1
#	< $file vcf-annotate -a ${reference}/ricegenepromoterVCFannotations.gz -c CHROM,FROM,TO,FE,GN -d ${reference}/descriptions.txt > ${file%.vcf}.annotated.vcf
	< $file vcf-annotate -a ${reference}/riceexonVCFannotations.gz -c CHROM,FROM,TO,EX -d ${reference}/descriptions.txt > ${file%.vcf}.annotated.vcf
}

function randomsubsetvcf() {
	# Takes a vcf file and an integer, outputs to stdout a VCF with $2 random sites from the original
	file=$1
	lines=$2

	header_line_number=$(grep --line-number "^#CHROM" ${file} | cut -d":" -f1)
	let vcf_line_number=$header_line_number+1

	# The header region of the VCF file needs to be preserved
	head -n "${header_line_number}" ${file}
	# The 1000 random lines should only come from legitimate sites
	shuf -n $lines <(tail --lines=+${vcf_line_number} ${file})
}

# This function checks for the requirements for code4Rice3K
function check_prereq() {
	echo "Checking for required software"
	error=""
	samtools --help >/dev/null 2>&1 || (echo "could not find samtools, please install" >&2 && error="true")
	bcftools --help >/dev/null 2>&1 || (echo "could not find bcftools, please install" >&2 && error="true")
	vcftools --help >/dev/null 2>&1 || (echo "could not find vcftools, please install" >&2 && error="true")
	java -version >/dev/null 2>&1 || (echo "could not find Java, please install" >&2 && error="true")
	python --version >/dev/null 2>&1 || (echo "could not find Python 2.7, please install" >&2 && error="true")
	raxmlHPC-PTHREADS -h >/dev/null 2>&1 || (echo "could not find raxml, please install" >&2 && error="true")
	# Tabix exits with error even if installed, so it needs a fancier test
	set +e #Temporarily disable strict error mode
	tabix --help >/dev/null 2>&1
	if [[ "$?" != "1" ]]; then #If tabix is not installed the error status should be 127
        	echo "could not find tabix, please install" >&2
        	error="true"
	fi
	echo "Softwares are installed"
	set -e

	# Check for biopython and pyvcf:
	for module in vcf Bio; do
		echo -n "Python module $module ... "
		python -c "import $module" > /dev/null 2>&1
		returnstatus=$?
		if [ $returnstatus == "0" ]; then
			echo OK
		else
			echo "Please install biopython and pyvcf"
		fi
	done

	if [[ -n "$error" ]]; then
        	echo "Please install required software" >&2
        	exit 1
	fi

	# check reference genome
	if [[ ! -e ${reference}/IRGSP-1.0_genome.dict ]]; then
        	echo "Reference genome not found. You need to run setup.sh script" >&2
		exit 1
	fi

	echo "System requirements are met"
}
