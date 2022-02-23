raw/ data is moved from /u/project/sriram/ukbiobank/33127

prepare-pheno-fields.R download from https://raw.githubusercontent.com/privefl/UKBB-PGS/61bdc936f1295549a4fd83f9c4975835b46ac417/code/prepare-pheno-fields.R

modified-prepare-pheno-fields.R

library(bigsnpr)
library(bigreadr)
library(dplyr)
library(ggplot2)

csv <- "/u/project/pasaniuc/ziqixu09/phenotype/pheno.csv"
