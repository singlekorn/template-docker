# Ad-Hoc Containers
Collection of docker container templates and ad-hoc images for testing.

## Tools

use `..\launch.sh -b <tag>` in a container directory to quickly build, run, and remove a docker container.

## Tools

Benchmark GPU Performance: `docker run --rm -it --gpus=all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -gpu -benchmark`