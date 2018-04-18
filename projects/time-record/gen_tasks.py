"""
This is just a script to generate CSV file for "time-record" project.
"""

import os
import csv

def main():
    for n in range(0, 9):
        create(row_count=(2**n))

def create(row_count):
    proj_dir = os.path.dirname(os.path.realpath(__file__))
    template = "%(dir)s/tasks/bwa-mem.%(rows)d.csv"
    file_name = template % {'dir': proj_dir, 'rows': row_count}
    if os.path.exists(file_name):
        return
    with open(file_name, 'w') as f:
        write(f, _header, _row, row_count)
    print file_name

def write(f, headerer, rower, count):
    rows = [headerer()]
    for index in range(count):
        rows.append(rower(index))
    csv.writer(f).writerows(rows)

def _header():
    return [
        '--env INDEX',
        '--input FASTQ_1',
        '--input FASTQ_2',
        '--output-recursive OUTDIR'
    ]

def _row(index):
    return [
        str(index),
        's3://awsub/resources/samples/5929/control/sequence1000_1.fastq',
        's3://awsub/resources/samples/5929/control/sequence1000_2.fastq',
        's3://awsub/verification/time-record/bwa'
    ]

if __name__ == '__main__':
    main()