# Purpose

This project is for creating figures which can indicate that

- The more concurrent computing instances mount shared instance, the more time it would take.
- The stronger shared instance is used, the faster the computing times should be.

# Method

- cross measurement for
    1. several concurrency with specific Shared-Instance type
    2. several Shared-Instance type with specific concurrency

# Expected

```
time
|              .
|             .
|          .
|      . 
|. .  
|________________________ concurrency
```

# Assets

- `Dockerfile`: a recipe for [`otiai10/bwa`](https://hub.docker.com/r/otiai10/bwa/) on which BWA works
- `gen_tasks.py`: only to generate messy CSV files, which I don't wanna include git repository
- `driver.sh`: the main driver for this test, hit `./driver.sh` to show help message