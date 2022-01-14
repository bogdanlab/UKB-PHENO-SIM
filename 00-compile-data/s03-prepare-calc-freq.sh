#!/bin/bash -l
#$ -cwd
#$ -l h_data=16G,h_rt=0:30:00,highp
#$ -j y
#$ -o ./job_out
#$ -t 1-22

chrom=${SGE_TASK_ID}

out_dir=out/PLINK/all
mkdir -p ${out_dir}

# frequency calculated with all the individuals
plink2 \
    --bfile ${out_dir}/chr${chrom} \
    --freq \
    --out ${out_dir}/chr${chrom}.all

# frequency calculated using only the european training individuals

plink2 \
    --bfile ${out_dir}/chr${chrom} \
    --keep out/INDIVLIST/eur_train.indiv \
    --freq \
    --out ${out_dir}/chr${chrom}.eur_train
