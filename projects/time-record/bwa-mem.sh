#!/bin/bash

set -u -e
mkdir -p ${OUTDIR}/${CASE}
bwa mem ${REFERENCE}/${REFFILE} ${FASTQ_1} ${FASTQ_2} \
  3>&1 1>/dev/null 2>&3 | tee ${OUTDIR}/${CASE}/${INDEX}.stderr.log