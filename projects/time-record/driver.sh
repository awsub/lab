#!/bin/sh

# Let it fail if anything fail.
set -e

# Let it fail if undefined variable is referenced.
set -u

if [ "$#" -lt 2 ]; then
    echo "Too few arguments for this script: expected 2, but $#"
    printf "Example:\n\n\t./driver.sh  m4.16xlarge  256\n\n"
    exit 1
fi

# Current File Directory
CFD=$(cd $(dirname $0) && pwd)

SHARED_SPEC=$1
SAMPLE_COUNT=$2

set -v ### Show what command is really issued ###
awsub \
    --script ${CFD}/bwa-mem.sh \
    --tasks ${CFD}/tasks/bwa-mem.${SAMPLE_COUNT}.csv \
    --image otiai10/bwa \
    --concurrency 64 \
    --shared REFERENCE=s3://awsub/resources/reference/GRCh37 \
    --env REFFILE=GRCh37.fa \
    --env CASE=m4.2xlarge-x`printf %03d ${SAMPLE_COUNT}` \
    --aws-ec2-instance-type m4.2xlarge \
    --aws-iam-instance-profile awsubtest \
    --aws-shared-instance-type ${SHARED_SPEC} \
    --verbose