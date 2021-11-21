#!/bin/bash -l
#$ -cwd
#$ -l h_data=2G,h_rt=5:00:00,highp
#$ -j y
#$ -o ./job_out

SRC_DIR=/u/project/pasaniuc/kangchen/software/prs-uncertainty
DATA_DIR=../00-compile-data/out/
OUT_DIR=out/PLINK

group=eur_val

for chrom in $(seq 1 22); do
    plink --bfile ${DATA_DIR}/PLINK/all/chr${chrom} \
        --keep ${DATA_DIR}/INDIVLIST/${group}.indiv \
        --keep-allele-order \
        --make-bed \
        --out ${OUT_DIR}/${group}.chr${chrom}
done
    
rm -f ${OUT_DIR}/${group}.merge_list

for i in $(seq 2 22); do
    echo -e "${OUT_DIR}/${group}.chr${i}" >> ${OUT_DIR}/${group}.merge_list
done

plink \
    --bfile ${OUT_DIR}/${group}.chr1 \
    --keep-allele-order \
    --make-bed \
    --merge-list ${OUT_DIR}/${group}.merge_list \
    --out ${OUT_DIR}/${group}.all
