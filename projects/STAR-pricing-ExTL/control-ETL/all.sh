#!/bin/bash

# Create log files
hotsub \
    --script ../../STAR-measurement/workflow.sh \
    --tasks ./star-alignment.16.csv \
    --image friend1ws/star-alignment \
    --aws-ec2-instance-type m4.2xlarge \
    --disk-size 128 \
    --env CASE=16 \
    --verbose

# Fetch log files
aws s3 cp --recursive s3://hotsub/verification/STAR-on-ETL ./results

# Create real time data set
LANG=C R --quiet --vanilla < dataset.R

# Reference file size
aws s3 ls s3://hotsub/resources/reference/GRCh37.STAR-2.5.2a/ | awk '{s += $3} END {print s}' > referencesize
