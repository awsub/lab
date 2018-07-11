#!/bin/bash

# Let it fail if undefined variable is referenced.
set -u

if [ "$#" -lt 2 ]; then
    echo "Too few arguments for this script: expected 2, but $#"
    printf "Example:\n\n\t./benchmark.sh  m4.16xlarge  16\n\n"
    exit 1
fi

# Current File Directory
CFD=$(cd $(dirname $0) && pwd)

SHARED_SPEC=$1
SAMPLE_COUNT=$2

# Please remain log files EVEN IF hotsub command failed!!
set +e

set -v ### Show what command is really issued ###
hotsub \
    --script ${CFD}/workflow.sh \
    --tasks ${CFD}/tasks/STAR.${SAMPLE_COUNT}.csv \
    --image friend1ws/star-alignment \
    --shared REFERENCE=s3://hotsub/resources/reference/GRCh37.STAR-2.5.2a \
    --env CASE=${SHARED_SPEC}-x`printf %02d ${SAMPLE_COUNT}` \
    --aws-ec2-instance-type m4.2xlarge \
    --aws-shared-instance-type ${SHARED_SPEC} \
    --disk-size 128 \
    --verbose
    # 1>${CFD}/stdout.log 2>${CFD}/stderr.log ; echo $? >${CFD}/exitcode.log

echo "DONE: `date`"