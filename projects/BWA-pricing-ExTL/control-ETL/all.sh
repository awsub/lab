#!/bin/bash

# Create log files
hotsub \
    --script ../../BWA-measurement/bwa-mem.sh \
    --tasks ./bwa-mem.32.csv \
    --image otiai10/bwa \
    --concurrency 64 \
    --env REFFILE=GRCh37.fa \
    --env CASE=32 \
    --aws-ec2-instance-type m4.large \
    --verbose

# Fetch log files
aws s3 cp --recursive s3://hotsub/verification/BWA-on-ETL ./results

# Create real time data set
cat results/32/*.log | grep "Real time" | awk '{print $4}' > results/dataset

# Reference file size
aws s3 ls s3://hotsub/resources/reference/GRCh37/ | awk '{s += $3} END {print s}' > referencesize