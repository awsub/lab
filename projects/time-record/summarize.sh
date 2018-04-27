#!/bin/bash

# This script gathers and compiles created data by `driver.sh`.
#   First, it downloads log files from S3 buckets.
#   Second, it generates data table from those log files.
#   Third, it compiles that data to figure.

# Current File Directory
CFD=$(cd $(dirname $0) && pwd)

SHARED_INSTANCE_SPECS=(m4.2xlarge m4.4xlarge m4.10xlarge m4.16xlarge)
SAMPLE_COUNT=(1 2 4 8 16 32 64 128)
BUCKET_PATH="s3://awsub/verification/time-record/bwa"

function compile_logs_for_each_case() {
  SPEC=${1}
  SAMPLE=${2}
  CASE="${SPEC}-x`printf %03d ${SAMPLE}`"

  echo ${CASE}
  fetch
  gather
  compile
}

function fetch() {
  S3_PATH="${BUCKET_PATH}/${CASE}/"
  aws s3 cp --recursive --quiet ${S3_PATH} results/${CASE}/
}

function gather() {
  cat ${CFD}/results/${CASE}/*.log | grep Real | awk '{print $4}' > ${CFD}/results/${CASE}/dataset
}

function compile() {
  R --vanilla --args ${SPEC} ${SAMPLE} < ${CFD}/compile.R 1>/dev/null
}

function figure_all() {
  R --vanilla < ${CFD}/figure.R 1>/dev/null
}

function main() {

  # clean up existing datasets
  rm -rf ${CFD}/results
  mkdir -p ${CFD}/results

  # Create all.tsv with specific headers
  echo -e "instance_type\tconcurrency\taverage\tmin\tmax\tstd" > results/all.tsv

  for SPEC in "${SHARED_INSTANCE_SPECS[@]}"; do
    for SAMPLE in "${SAMPLE_COUNT[@]}"; do
      compile_logs_for_each_case ${SPEC} ${SAMPLE}
    done
  done

  figure_all
}

main $@