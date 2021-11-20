#!/bin/bash -l
#$ -cwd
#$ -l h_data=8G,h_rt=5:00:00,highp
#$ -j y
#$ -o ./job_out
#$ -t 1-22
#$ -pe shared 6

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1

CHROM=${SGE_TASK_ID}

Rscript=/u/project/pasaniuc/kangchen/software/miniconda3/envs/r/bin/Rscript

SRC_DIR=/u/project/pasaniuc/kangchen/software/prs-uncertainty
DATA_DIR=../00-compile-data/out/
OUT_DIR=out/LD
mkdir -p ${OUT_DIR}

# subset eur_train individuals
plink --bfile ${DATA_DIR}/PLINK/all/chr${CHROM} \
    --keep ${DATA_DIR}/INDIVLIST/eur_train.indiv \
    --keep-allele-order \
    --make-bed \
    --out ${OUT_DIR}/eur_train.chr${CHROM}


${Rscript} ${SRC_DIR}/ld.R \
    --train_bfile ${OUT_DIR}/eur_train.chr${CHROM} \
    --chrom ${CHROM} \
    --n_core 6 \
    --ld_dir ${OUT_DIR}/
