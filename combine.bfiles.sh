#!/bin/bash

# Create a merge list file for PLINK
merge_list="merge_list.txt"
> $merge_list

# Write the paths to the bfiles for chromosomes 2 to 22
for i in {2..22}; do
  echo "chr${i}.all.100kga.bed chr${i}.all.100kga.bim chr${i}.all.100kga.fam" >> $merge_list
done

# Run PLINK to merge the bfiles
plink --bfile chr1.all.100kga --merge-list $merge_list --make-bed --out merged_data

# Check for errors and handle them if necessary
if [ -f merged_data-merge.missnp ]; then
  echo "There were issues with some SNPs. Check merged_data-merge.missnp for details."
fi

echo "Merging complete. Output files are named merged_data.*"
