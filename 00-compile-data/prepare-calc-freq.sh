#!/bin/bash -l
#$ -cwd
#$ -l h_data=16G,h_rt=0:10:00
#$ -j y
#$ -o ./job_out
#$ -t 1-22

chrom=${SGE_TASK_ID}

out_dir=out/PLINK/all
mkdir -p ${out_dir}

plink2 \
    --bfile ${out_dir}/chr${chrom} \
    --freq \
    --out ${out_dir}/chr${chrom}.freq
    
mv ${out_dir}/chr${chrom}.freq.afreq ${out_dir}/chr${chrom}.freq