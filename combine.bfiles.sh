#!/bin/bash

# List of chromosome files (assuming they are named chr1.all.100kga.bim, chr2.all.100kga.bim, etc.)
chromosomes=(chr{1..22}.all.100kga)

# Directory containing the chromosome files
input_dir="bfile"
output_dir="all.bfile"

# Create a temporary directory for intermediate files
mkdir -p $output_dir/temp

# Loop through each chromosome file
for chr in "${chromosomes[@]}"; do
    # Filter out SNPs with rsID "."
    plink --bfile $input_dir/${chr} --exclude <(awk '$2 == "." {print $2}' $input_dir/${chr}.bim) --make-bed --out $output_dir/temp/${chr}_filtered
done

# Create a merge list file
merge_list=$output_dir/temp/merge_list.txt
for chr in "${chromosomes[@]}"; do
    echo "$output_dir/temp/${chr}_filtered" >> $merge_list
done

# Merge all filtered chromosome files
plink --merge-list $merge_list --make-bed --out $output_dir/merged_data

# Clean up temporary files
rm -r $output_dir/temp

echo "Merging complete. Output saved to $output_dir/merged_data"
