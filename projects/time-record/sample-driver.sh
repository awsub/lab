#!/bin/sh

awsub \
    --script ./workflow.sh \
    --tasks ./bwa-mem.2.csv \
    --image otiai10/bwa \
    --aws-ec2-instance-type m4.2xlarge \
    --aws-iam-instance-profile testtest \
    --shared REFERENCE=s3://awsub/resources/reference/GRCh37 \
    --env REFFILE=GRCh37.fa \
    --env CASE=m4.2xlarge \
    --verbose