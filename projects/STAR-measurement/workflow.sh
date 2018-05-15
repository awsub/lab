#!/bin/bash

set -u -e

OUTPUT_PREF=/tmp/${INDEX}
STAR_OPTION="--runThreadN 6 --outSAMstrandField intronMotif --outSAMunmapped Within --outSAMtype BAM Unsorted"
SAMTOOLS_SORT_OPTION="-@ 6 -m 3G"

mkdir -p ${OUTDIR}/${CASE}

STAR --version
STAR \
  --genomeDir ${REFERENCE} \
  --readFilesIn ${INPUT1} ${INPUT2} \
  --outFileNamePrefix ${OUTPUT_PREF}. \
  ${STAR_OPTION} \
  1>${OUTDIR}/${CASE}/${INDEX}.stdout.log \
  2>${OUTDIR}/${CASE}/${INDEX}.stderr.log