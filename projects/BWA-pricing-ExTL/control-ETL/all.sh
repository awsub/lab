#!/bin/bash

# Create log files
awsub \
    --script ../../BWA-measurement/bwa-mem.sh \
    --tasks ./bwa-mem.32.csv \
    --image otiai10/bwa \
    --concurrency 64 \
    --env REFFILE=GRCh37.fa \
    --env CASE=32 \
    --aws-ec2-instance-type m4.large \
    --aws-iam-instance-profile awsubtest \
    --verbose

# Fetch log files
aws s3 cp --recursive s3://awsub/verification/BWA-on-ETL ./results

# Create real time data set
cat results/32/*.log | grep "Real time" | awk '{print $4}' > results/dataset
