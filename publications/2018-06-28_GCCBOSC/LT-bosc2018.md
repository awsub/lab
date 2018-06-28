<!-- $size: 16:9 -->

An Alternative Way for Genome Analysis on Cloud
===

## ETL, ExTL, and introduction of its engine: `awsub`

Hiromu OCHIAI - National Cancer Center Japan

---

# Genome analysis on Cloud Resources

![](./images/aws.png) ![20%](./images/gcp.png) ![20%](./images/azure.png)

![20%](./images/do.png) ![40%](./images/ibmsl.jpg) ![30%](./images/openstack.png) 

and more

---

#  How to use "Cloud"?

![](./images/thinking-face.png)

---

# "Building a Cluster on Cloud"

- Galaxy
![4%](https://www.melbournebioinformatics.org.au/tutorials/tutorials/assembly/media/GalaxyLogoHighRes.png)
- cfn-cluster
  ![40%](http://d0.awsstatic.com/Solutions/HPC/cfncluster_logo.png) 
- ElastiCluster
- Butler
- etc...

---

# Pros and Cons of "Cluster on Cloud"

- <span style="font-size:1.8em">Pros:</span>
  - We are **VERY** used to cluster on HPC
    - _Grid Engine, HTCondor, SLURM, etc..._
    - e.g. `qsub ./my-workflow.sh`

---

# Pros and Cons of "Cluster on Cloud"

- <span style="font-size:1.8em">Pros:</span>
  - We are **VERY** used to cluster on HPC
    - _Grid Engine, HTCondor, SLURM, etc..._
    - e.g. `qsub ./my-workflow.sh`
- <span style="font-size:1.8em">Cons:</span>
  - Persistent static resources
    - Scheduler Node, Queue Database, Filesystem

---

# Suggestion: "On-Demand ETL"

---

# ETL is

- Extract, Transform, Load
- Data processing model for general purpose

![190%](./images/etl-general.png)

---

# Do it on Cloud

![190%](./images/etl-on-cloud.png)

---

# Do it on Cloud

![70%](./images/etl-adv.png)

---

# Do it with `awsub`!

---

# If you have 4 Fastq samples


![40%](./images/toon/09.png)

---

# Specify workflow script and samples

![40%](./images/toon/08.png)

---

# Security Group

![40%](./images/toon/07.png)

---

# Inscances for each sample

![40%](./images/toon/06.png)

---

# Fetch specific sample data according to the location

![40%](./images/toon/05.png)

---

# Fetch reference data from common data source

![40%](./images/toon/04.png)

---

# Execute your workflow for each

![40%](./images/toon/03.png)

---

# Push the result data back to the storage

![40%](./images/toon/02.png)

---

# Dispose all the computing resources no longer used

![40%](./images/toon/01.png)


---

# All you got is the result data!

![40%](./images/toon/00.png)

---

# Overall

![40%](./images/toon/all.png)

---

# by using `awsub`

<div style="display:flex;align-items:center;">
  <div style="flex:2;">


```sh
$ awsub \
  --tasks  ./my-samples.csv \
  --script ./my-workflow.sh \
  --image  otiai10/STAR-alignment # any Docker image
```

  </div>
  <div style="flex:1">

![36%](./images/toon/all.png)

  </div>
</div>

---

# Problems of ETL on Bioinformatics

---

# Problems of ETL on Bioinformatics

<div style="display:flex">
  <div style="flex:1">

![40%](./images/toon/10.png)

  </div>
  <div style="flex:1">

- Common Reference Data is so huge
  - Copying huge reference data uses
    - inefficient **traffic**
    - inefficient **instance time**
    - inefficient **storage area**
  - e.g. Human Reference for STAR alignemt: **30GB**
  </div>
</div>

---

# Suggestion: _Extended_ ETL (ExTL)

---

# Suggestion: _Extended_ ETL (ExTL)

<div style="display:flex">
  <div style="flex:1">

![40%](./images/toon/11.png)

  </div>
  <div style="flex:1">

- Create a `Shared Data Instance`
- Fetch external common data **once**
- Let computing instances **mount**

  </div>
</div>

---

# Suggestion: _Extended_ ETL (ExTL)

<div style="display:flex">
  <div style="flex:1">

![40%](./images/toon/11.png)

  </div>
  <div style="flex:1">

- Create a `Shared Data Instance`
- Fetch external common data **once**
- Let computing instances **mount**

## Cost Saving!

- Network traffic, instance time, ...

![8%](../../projects/STAR-pricing-ExTL/figure-an.png)

  </div>
</div>

---

# ExTL by using `awsub`

<div style="display:flex;align-items:center;">
  <div style="flex:2;">


```diff
$ awsub \
  --tasks  ./my-samples.csv \
  --script ./my-workflow.sh \
  --image  otiai10/STAR-alignment \
+ --shared REFERENCE=s3://bucket/huge/reference
```

  </div>
  <div style="flex:1">

![36%](./images/toon/11.png)

  </div>
</div>

---

# Summary

- Another approach than "Cluster on Cloud"
  - **"On-demand ETL on Cloud"**
- Huge common data can be a problem of "ETL on Cloud"
- **"Extended ETL"** (ExTL)
- Working Example Implementation of ExTL: <span style="font-size:1.4em;font-weight:bold">`awsub`</span>

---

# More on the poster

about

- How to **Get started**
- **Google Cloud**, Microsoft Azure, OpenStack and more
- Common Workflow Language (**CWL**)
- Execution **Protocol** and Security Groups / IAM Instance Profile
- _**Go**_ implementation
- etc...

<img src="./images/gopher.png" style="position:absolute;right:-100px;bottom:-230px;">

Come to poster <span style="font-size:1.8em">**B29**</span>, and any feedback is welcome!

https://github.com/otiai10/awsub