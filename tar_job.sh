#!/bin/bash

#SBATCH --job-name=tar_job
#SBATCH --partition=normal_q
#SBATCH --time=16:00:00
#SBATCH -A openondemand2
#SBATCH --nodes=1
#SBATCH -n 4
module reset
module load pigz

rm -rf r_dest
export PROJECT=Project_TEST
export PI=rsettlag_lab
export ARCHIVE=YES

mkdir -p $HOME/.dashboard_status/$PROJECT
STATUS_LOC=$HOME/.dashboard_status/$PROJECT

echo start: ${date} | tee >> $STATUS_LOC/status
echo jobid is $SLURM_JOB_ID | tee >> $STATUS_LOC/status


echo STEP 1: tar data
cd /work/maxam_source_data
 
echo working on r_src
if [ -d "r_src" ]; then
  tar -czf r_src.tar.gz r_src
  # TODO: add code to make sure tar was successful and tar contains all the data
else
  echo "Error: r_src not found" | tee >> $STATUS_LOC/status
  exit 1
fi
echo "tar complete" | tee >> $STATUS_LOC/status

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
