#!/bin/bash
#SBATCH --partition=week
#SBATCH --time=7-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=200000


input_file="/vast/palmer/pi/reilly/jfa38/100kGA_samples/GAsP_1163Samples.SNVs.Feb2020.vcf.gz"

# Extract header lines
zgrep '^#' "$input_file" > header.vcf

for chr in {1..2}; do
    output_file="chr${chr}.100KGA.1163sample.vcf"
    
    # Extract lines for the current chromosome and save to the output file
    zgrep -E "^#|^${chr}[[:space:]]" "$input_file" > "$output_file"
    
    # Prepend the header to the output file
    cat header.vcf "$output_file" > temp.vcf && mv temp.vcf "$output_file"
    
    # Compress the output file
    bgzip "$output_file"
done

# Clean up
rm header.vcf
