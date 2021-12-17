#!/bin/sh
#$ -cwd
#$ -j y
#$ -l h_data=6G,h_rt=15:00:00,highp -pe shared 6
#$ -o ./job_out

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1

trait=$1

Rscript=/u/project/pasaniuc/kangchen/software/miniconda3/envs/r/bin/Rscript
PLINK_DIR=../01-simulate-pheno/out/PLINK/
LD_DIR=../01-simulate-pheno/out/LD/
OUT_DIR=out/PRS-WEIGHTS/${trait}
GWAS_DIR=out/LDPRED2/${trait}
mkdir -p ${OUT_DIR}

echo "val_pheno:"
zcat ${DATA_DIR}/eur_val.pheno.tsv.gz | head

${Rscript} ~/project-pasaniuc/software/prs-uncertainty/weight.R \
    --train_bfile=${PLINK_DIR}/eur_train.all \
    --train_sumstats=${GWAS_DIR}/assoc.ldpred2.tsv.gz \
    --val_bfile=${PLINK_DIR}/eur_val.all \
    --val_pheno=${GWAS_DIR}/eur_val.pheno.tsv.gz \
    --test_bfile=${PLINK_DIR}/eur_test.all \
    --out_prefix=${OUT_DIR}/${trait} \
    --ld_dir=${LD_DIR}/ \
    --n_core=10 \
    --n_burn_in=100 \
    --n_iter=500