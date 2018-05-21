aws s3 cp --recursive s3://awsub/verification/BWA-on-ETL ./results
cat results/32/*.log | grep "Real time" | awk '{print $4}' > results/dataset
