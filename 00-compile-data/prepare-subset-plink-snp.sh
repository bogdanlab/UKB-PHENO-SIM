#!/bin/bash -l
#$ -cwd
#$ -l h_data=32G,h_rt=10:00:00
#$ -j y
#$ -o ./job_out
#$ -t 1-22

SRC_BFILE_PREFIX=/u/project/sgss/UKBB/data/imp/hard_calls.ukbb-showcase/nodup/
chrom=${SGE_TASK_ID}

out_dir=out/PLINK/all
mkdir -p ${out_dir}

plink \
    --bfile ${SRC_BFILE_PREFIX}/${chrom} \
    --extract out/SNPLIST/ukb-hm3.snplist \
    --keep-allele-order \
    --make-bed \
    --out ${out_dir}/chr${chrom}
