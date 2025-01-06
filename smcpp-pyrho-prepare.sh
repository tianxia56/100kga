#!/bin/bash
#smc++ runs in Python 3.8
# Create a file with the individuals to keep (FID and IID)
awk '$2 == "KHL" {print $1, $1}' ../100kga/ind.info.txt > keep_individuals.txt

# Extract these individuals using PLINK and convert to VCF
module load PLINK/1.9b_6.21-x86_64 
plink --bfile ../100kga/bfile/chr22.all.100kga --keep keep_individuals.txt --make-bed --out chr22.KHL
plink --bfile chr22.KHL --recode vcf --out chr22.KHL

# Index the VCF file using BCFtools
module load BCFtools/1.11-GCC-10.2.0
bcftools view chr22.KHL.vcf -Oz -o chr22.KHL.vcf.gz
bcftools index chr22.KHL.vcf.gz
#########################################################################
#prepare smc++ csv file
#########################################################################
#first VCF2SMC
#smc++ vcf2smc -d HG00096 HG00097 ~/1KGP/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz test.smc 22 CEU:HG00096,HG00097

#second estimate
#smc++ estimate 1e-8 test.smc -o test

#third convert smc to csv
#smc++ plot plot.png --csv model.final.json

#####test on KHL:GA001523,GA001524
smc++ vcf2smc -d GA001523_GA001523 GA001524_GA001524 chr22.KHL.vcf.gz khl.smc 22 KHL:GA001523_GA001523,GA001524_GA001524
smc++ estimate 1e-8 khl.smc -o KHL
cd KHL
smc++ plot khl1.png --csv model.final.json

#######################################################################
#run pyrho
#######################################################################

