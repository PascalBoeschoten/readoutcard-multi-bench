#!/bin/bash

# Example:
# ./launch-multi-bench.sh 2Mi 1m 06:00.0,07:00.0,85:00.0,86:00.0 0,0,1,1

# Arguments
superpage_size=$1
sleep_time=$2
ids_comma_separated=$3
numanodes_comma_separated=$4
fixed_opts="--buffer-size=2Gi --no-err --no-display --links=0-31"

ids=(${ids_comma_separated//,/ })
numanodes=(${numanodes_comma_separated//,/ })

# Temporary output for benchmarks
tmp_out="/tmp/multibench-"

# Launch benchmarks and store PIDs
pids=()
for((i=0; i<${#ids[@]} ;i++)); do
  id="${ids[$i]}"

  # If NUMA nodes were specified, use them
  if [ -z "$numanodes_comma_separated" ]; then
    roc-bench-dma $fixed_opts --superpage-size=$1 --id=$id > "$tmp_out$id" &
  else
    node="${numanodes[$i]}"
    numactl --physcpubind=${node} --membind=${node} roc-bench-dma $fixed_opts --superpage-size=$1 --id=$id > "$tmp_out$id" &
  fi

  pids+=($!)
done

if [ -z "$sleep_time" ]; then
  read -n 1 -p "Press key to stop benchmark" devnull
else
  echo "Benchmarking for $sleep_time"
  sleep $sleep_time
fi

# Stop benches
for pid in "${pids[@]}"; do
  kill -s SIGINT $pid
done

# Wait for benches to shutdown and output stats
for pid in "${pids[@]}"; do
  wait $pid
done

# Output the output
for id in "${ids[@]}"; do
  gbps=$(grep "GB/s" "$tmp_out$id" | awk '{print $2}')
  echo "$id $gbps GB/s"
done

