#!/usr/bin/env python

from __future__ import print_function
import vcf
from Bio.Seq import Seq
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

def vcf_to_fasta(input_file_name):
    """Converts a multi-sample VCF file into a FASTA alignment

    Args:
        input_file_name: a string that is the name of input VCF file
    Returns:
        Writes out a FASTA file containing sequences for each sample in the input
        VCF file. These function as an alignment for the purposes of treeing.
    """

    with open(input_file_name) as input_file:
        vcf_file=vcf.Reader(input_file)
        sequences_dict={}

        for sample in vcf_file.samples:
            sequences_dict[sample]=[] #Empty list instead of string because consecutive string appends are apparently slow.

        for record in vcf_file:
            for sample in record.samples:
                sequences_dict[sample.sample].append(sample.gt_bases[0]) # This is taking the first base only. Adjust this if the input isn't heterozygous.
        #print("sequences_dict:")
        #print(sequences_dict)
        bunch = [ SeqRecord(Seq("".join(sequences_dict[cultivar])), cultivar) for cultivar in sequences_dict]
        #print("bunch: ")
        #print(bunch)
        SeqIO.write(bunch, input_file_name + ".fasta", "fasta")



def main(arguments):
    input_file_name=arguments[1]
    vcf_to_fasta(input_file_name)

if __name__ == "__main__":
    import sys
    sys.exit(main(sys.argv))
