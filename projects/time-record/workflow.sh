#!/bin/sh
set -u -e
mkdir -p ${OUTDIR}/${CASE}
bwa mem ${REFERENCE}/GRCh37.fa ${FASTQ_1} ${FASTQ_2} 1>/dev/null 2> ${OUTDIR}/${CASE}/${INDEX}.stderr.log