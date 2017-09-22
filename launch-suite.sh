#!/bin/bash

# Example: 
# ./launch-suite.sh 06:00.0,07:00.0,85:00.0,86:00.0 1m 0,0,1,1

# Arguments
time=$1 # e.g. 1m
ids=$2 # e.g. 05:00.0,06:00.0,55:0.0,56:00.0
numa_nodes=$3 # e.g. 0,0,1,1

superpage_sizes=(32Ki 64Ki 128Ki 256Ki 512Ki 1Mi 2Mi 4Mi 8Mi 16Mi 32Mi 64Mi 128Mi 256Mi 512Mi 1Gi)

for superpage_size in "${superpage_sizes[@]}"; do
  echo "Benchmarking with superpage size ${superpage_size}"
  ./launch-multi-bench.sh ${superpage_size} ${time} ${ids} ${numa_nodes}
done
