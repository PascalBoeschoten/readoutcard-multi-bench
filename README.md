# readoutcard-multi-bench
A collection of scripts to help benchmark readout cards using the ReadoutCard 
(https://github.com/AliceO2Group/ReadoutCard) library's roc-bench-dma tool.


## launch-multi-bench
Script for launching simultaneous ReadoutCard[1] benchmarks, to measure throughput 
using multiple cards/endpoints together.

Arguments:
* Superpage size
* Sleep time
* Comma-separated card IDs
* Comma-separated NUMA node IDs

Example:
~~~
./launch-multi-bench.sh 2Mi 1m 06:00.0,07:00.0,85:00.0,86:00.0 0,0,1,1
~~~


## launch-suite
Script for launching a sequence of multi-benches with different superpage sizes. 
Sizes are currently hard-coded.

Arguments:
* Sleep time
* Comma-separated card IDs
* Comma-separated NUMA node IDs

Example:
~~~
./launch-suite.sh 1m 06:00.0,07:00.0,85:00.0,86:00.0 0,0,1,1
~~~
