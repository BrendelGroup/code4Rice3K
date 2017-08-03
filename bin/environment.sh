#!/bin/bash

export project_root=$(pwd)
export reference=${project_root}/reference
export maps=${project_root}/maps
export calls=${project_root}/calls
export src=$project_root/src
export split=${project_root}/split
export merges=${project_root}/merges
export alignments=${project_root}/alignments
export bin=${project_root}/bin

mkdir -p $src $reference $maps $calls $merges $split $alignments

export picard="java -jar $src/picard.jar"
export gatk="java -jar $src/GenomeAnalysisTK.jar"

source $bin/functions.sh
