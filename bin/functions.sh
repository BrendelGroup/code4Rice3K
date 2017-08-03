#!/bin/bash


# function that will generate the gvcf file for a given cultivar

function call_variants() {
#TODO Add an argument for number of available processors
	cultivar=$1

	$gatk -T HaplotypeCaller \
		-R ${reference}/IRGSP-1.0_genome.fasta \
		-I $maps/${cultivar}.realigned.bam \
		-ERC GVCF \
		-o $calls/${cultivar}.g.vcf \
		-nct 4
}

function genotype() {
	cultivar=$1

	$gatk -T GenotypeGVCFs \
		-R ${reference}/IRGSP-1.0_genome.fasta \
		-V $calls/${cultivar}.g.vcf \
		-o $calls/${cultivar}.vcf \
		-nt 24
}

function full_genotype() {
#TODO Add an argument for number of available processors
	cultivar=$1

	$gatk -T GenotypeGVCFs \
		-R ${reference}/IRGSP-1.0_genome.fasta \
		-V $calls/${cultivar}.g.vcf \
		-allSites \
		-o $calls/${cultivar}.full.vcf \
		-nt 12
}


# same as above, but only for a given loci rather than a full chromosome
# loci can be in the gatk format chrname:begin-end
# or it can be a file with a list of such formatted loci

function call_variants_range() {
	which java
	echo $gatk

	CULT=$1
	LOCI=$2

	$gatk -T HaplotypeCaller \
		-L $LOCI \
		-R ${reference}/IRGSP-1.0_genome.fasta \
		-I $maps/${CULT}.realigned.bam \
		-ERC GVCF \
		-o $calls/${CULT}-${LOCI}.g.vcf
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
		bcftools view --exclude-uncalled --exclude-types 'indels' --genotype ^het -r ${chromosome} -O v ${cultivar}.full.vcf.gz | awk ' /^#/ {print} length($4) == 1 && ( ($5 != "<NON_REF>") || ($0 !~ /1\/1/) ) && ( ($5 !~ /^[ACGT],<NON_REF>/) || ($0 !~ /2\/2/) ) && ( ($5 !~ /^[ATCG],[ATCG],<NON_REF>/) || ($0 !~ /3\/3/) ) && ( ($5 !~ /^[ACGT],[ATCG],[ATCG],<NON_REF>/) || ($0 !~ /4\/4/) ) {print} ' | bgzip -c > ../split/${cultivar}.${chromosome}.noindels_nohets_nomnps.vcf.gz; tabix ../split/${cultivar}.${chromosome}.noindels_nohets_nomnps.vcf.gz) &
	done
	wait
}

function merge_chromosome() {
#TODO Add an argument that determines which cultivars are merged. Right now it's indiscriminate.
	chromosome=$1
	vcf-merge *${chromosome}*.vcf.gz > ../merges/${chromosome}.merge.vcf
	# The awk command filters any Multiple Nucleotide Polymorphisms, and any sites that for some reason  are called as '<NON_REF>'
	< ../merges/${chromosome}.merge.vcf bcftools view --exclude-uncalled --exclude-types 'indels' --min-ac 2 --max-af 0.99 --genotype ^miss -O v | awk ' /^#/ {print} length($4) == 1 && ( ($5 != "<NON_REF>") || ($0 !~ /1\/1/) ) && ( ($5 !~ /^[ACGT],<NON_REF>/) || ($0 !~ /2\/2/) ) && ( ($5 !~ /^[ATCG],[ATCG],<NON_REF>/) || ($0 !~ /3\/3/) ) && ( ($5 !~ /^[ACGT],[ATCG],[ATCG],<NON_REF>/) || ($0 !~ /4\/4/) ) {print} ' > ../merges/${chromosome}.merge.cleaned.vcf
	bgzip ../merges/${chromosome}.merge.cleaned.vcf
	tabix ../merges/${chromosome}.merge.cleaned.vcf.gz
}

function refilter_merged() {
	file=$1
	#< $file bcftools view --min-ac 2 -O v > ${file%.vcf}.min2.vcf
	< $file bcftools view --min-ac 3 -O v > ${file%.vcf}.min3.vcf
	< $file bcftools view --min-ac 4 -O v > ${file%.vcf}.min4.vcf
	< $file bcftools view --min-ac 5 -O v > ${file%.vcf}.min5.vcf
	< $file bcftools view --min-ac 8 -O v > ${file%.vcf}.min8.vcf
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
