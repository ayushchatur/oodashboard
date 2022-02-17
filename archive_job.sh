#!/bin/bash

#SBATCH --job-name=tartask
#SBATCH --partition=intel_q
#SBATCH --time=16:00:00
#SBATCH -A openondemand2
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1

tar -xvf r_dest

echo "copied"
a=0
while [$a -lt 1000000]
do
    sleep 10
    echo "$a s"
    $a = $a+10

# sleep 10 
# echo "20s"
# sleep 10
# echo "10s"
