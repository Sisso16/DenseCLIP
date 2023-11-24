#!/bin/bash

#SBATCH --mail-type=ALL                           # mail configuration: NONE, BEGIN, END, FAIL, REQUEUE, ALL
#SBATCH --output=/srv/beegfs02/scratch/adapt_anything/data/DenseCLIP/slurm/output/%j.out     # where to store the output (%j is the JOBID), subdirectory "log" must exist
#SBATCH --error=/srv/beegfs02/scratch/adapt_anything/data/DenseCLIP/slurm/output/%j.err  # where to store error messages

# Exit on errors
set -o errexit

# Set a directory for temporary files unique to the job with automatic removal at job termination
TMPDIR=$(mktemp -d)
if [[ ! -d ${TMPDIR} ]]; then
    echo 'Failed to create temp directory' >&2
    exit 1
fi
trap "exit 1" HUP INT TERM
trap 'rm -rf "${TMPDIR}"' EXIT
export TMPDIR

# Change the current directory to the location where you want to store temporary files, exit if changing didn't succeed.
# Adapt this to your personal preference
cd "${TMPDIR}" || exit 1

# Send some noteworthy information to the output log
echo "Running on node: $(hostname)"
echo "In directory:    $(pwd)"
echo "Starting on:     $(date)"
echo "SLURM_JOB_ID:    ${SLURM_JOB_ID}"

# Binary or script to execute
python /srv/beegfs02/scratch/adapt_anything/data/DenseCLIP/test.py /srv/beegfs02/scratch/adapt_anything/data/DenseCLIP/configs/denseclip_fpn_vit-b_640x640_80k.py /srv/beegfs02/scratch/adapt_anything/data/DenseCLIP/ckpts/denseclip_fpn_vit-b.pth --eval mIoU

# Send more noteworthy information to the output log
echo "Finished at:     $(date)"

# End the script with exit code 0
exit 0