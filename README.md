# Simulated phenotype based on UK Biobank individuals

Simulated phenotypes based on various genetic architecture on 487,409 individuals (including individual from diverse ancestral groups) and 1,054,151 hapmap3 SNPs.

PRS uncertainty will be trained on a subset of 270,000 European individuals using LDpred2 on simulation data.


## Data
- Genotype PLINK data: `00-compile-data/out/PLINK/all/chr{chrom}`
- Individual partition: `00-compile-data/out/INDIVLIST/{group}.indiv`
- Simulated phenotype / genetic value / effect sizes: `01-simulate-pheno/out/PHENO/{setup}/sim.[pheno | pheno_g | beta].tsv.gz`
- GWAS: `01-simulate-pheno/out/LDPRED2/{setup}/sim_{sim_i}.assoc.gz`

## Details

### 00-compile-data/ 

1. Subset a set of SNPs (overlap between hapmap3 and UK Biobank)
2. Use PLINK to subset SNPs by chromosomes.
3. Phenotype compilation (not used in simulation studies, but may be used in accompanied real data analyses)

### 01-simulate-pheno/
1. Simulate the phenotype with various genetic architecture.
2. Perform GWAS for each simulated trait.

### 02-kangcheng-run-prs/
Run LDpred2 on simulated data.
1. prepare-ld.sh precompute the LD matrices.
2. prepare-plink.sh merge the PLINK
3. run-prs-weights.sh run the PRS weights.

### 03-run-real-prs/
TODO
1. Run LDpred2 on real data.