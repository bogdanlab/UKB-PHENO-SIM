# Compile data

1. prepare-filter-snp.ipynb: overlap between UK Biobank and Hapmap3 SNPs
2. prepare-filter-indiv.ipynb: determine a set of individuals to work with.
2. prepare-subset-plink-snp.sh: Subset the SNPs to obtain the PLINK files
3. prepare-subset-plink-indiv.sh: Subset the SNPs to obtain the PLINK files


```bash
for prefix in eur_train eur_val eur_test admix; do
    qsub subset_indiv.sh ${prefix}
done
```