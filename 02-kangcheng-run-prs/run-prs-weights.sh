#!/bin/sh
#$ -cwd
#$ -j y
#$ -l h_data=6G,h_rt=15:00:00,highp -pe shared 6
#$ -o ./job_out

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1

Rscript=/u/project/pasaniuc/kangchen/software/miniconda3/envs/r/bin/Rscript
PLINK_DIR=out/PLINK

# prefix=$1
prefix=hsq-0.25-pcausal-0.01-hermodel-gcta
sim_i=${SGE_TASK_ID}
sim_i=$((sim_i - 1))

OUT_DIR=out/PRS-WEIGHTS/${prefix}
DATA_DIR=../01-simulate-pheno/out/LDPRED2/${prefix}
LD_DIR=out/LD/
mkdir -p ${OUT_DIR}

echo "val_pheno:"
zcat ${DATA_DIR}/sim_${sim_i}.eur_val.pheno.tsv.gz | head

${Rscript} ~/project-pasaniuc/software/prs-uncertainty/weight.R \
    --train_bfile=${PLINK_DIR}/eur_train.all \
    --train_sumstats=${DATA_DIR}/sim_${sim_i}.assoc.ldpred2.tsv.gz \
    --val_bfile=${PLINK_DIR}/eur_val.all \
    --val_pheno=${DATA_DIR}/sim_${sim_i}.eur_val.pheno.tsv.gz \
    --test_bfile=${PLINK_DIR}/eur_test.all \
    --out_prefix=${OUT_DIR}/sim_${sim_i} \
    --ld_dir=${LD_DIR}/ \
    --n_core=8 \
    --n_burn_in=100 \
    --n_iter=500
