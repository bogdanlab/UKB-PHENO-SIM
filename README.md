# Simulated phenotype based on UK Biobank individuals

Simulated phenotypes based on various genetic architecture on 487,409 individuals (including individual from diverse ancestral groups) and 1,054,151 hapmap3 SNPs.

PRS uncertainty will be trained on a subset of 270,000 European individuals using LDpred2 on simulation data.


## Details

### 00-compile-data/ 

1. Subset a set of SNPs (overlap between hapmap3 and UK Biobank)
2. Use PLINK to subset SNPs by chromosomes.
3. Phenotype compilation (not used in simulation studies, but may be used in accompanied real data analyses)

### 01-simulate-pheno/
1. Simulate the phenotype with various genetic architecture.

### 02-run-prs/
1. Run LDpred2 on simulated data.