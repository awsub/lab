"""
This is just a script to generate CSV file for "time-record" project.
"""

import os
import csv

def main():
    for n in range(0, 5):
        create(row_count=(2**n))

def create(row_count):
    proj_dir = os.path.dirname(os.path.realpath(__file__))

    task_dir = os.path.join(proj_dir, "tasks")
    if not os.path.exists(task_dir):
        os.mkdir(task_dir)

    template = "%(dir)s/tasks/STAR.%(rows)d.csv"
    file_name = template % {'dir': proj_dir, 'rows': row_count}
    if os.path.exists(file_name):
        return
    with open(file_name, 'w') as f:
        write(f, _header, _row, row_count)
    print(file_name)

def write(f, headerer, rower, count):
    rows = [headerer()]
    for index in range(count):
        rows.append(rower(index))
    csv.writer(f).writerows(rows)

def _header():
    return [
        '--env INDEX',
        '--input INPUT1',
        '--input INPUT2',
        '--output-recursive OUTDIR'
    ]

def _row(index):
    return [
        str(index),
        's3://awsub/examples/STAR/samples/MCF-7/sequence1.txt',
        's3://awsub/examples/STAR/samples/MCF-7/sequence2.txt',
        's3://awsub/verification/STAR-measurement'
    ]

if __name__ == '__main__':
    main()