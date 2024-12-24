##prepare inputs
#zcat chr2.100KGA.1163.clean.vcf.gz | awk '{print}' | bgzip > chr2.100KGA.1163.clean.fixed.vcf.gz
#tabix -p vcf chr2.100KGA.1163.clean.fixed.vcf.gz

# Input and output file names
input_vcf <- "chr2.100KGA.1163.clean.fixed.vcf.gz"
output_vcf <- "chr2.100KGA.1163.clean.cleaned.vcf"
compressed_vcf <- "chr2.100KGA.1163.clean.cleaned.vcf.gz"

# Open input and output files
cat("Processing VCF file line by line...\n")
input_conn <- gzfile(input_vcf, open = "r")
output_conn <- file(output_vcf, open = "w")

# Read the file line by line
line_number <- 0
expected_columns <- NULL
problematic_rows <- list()

while (TRUE) {
  line <- readLines(input_conn, n = 1, warn = FALSE)
  if (length(line) == 0) break  # End of file
  
  line_number <- line_number + 1
  
  if (startsWith(line, "#")) {
    # Write header lines directly to output
    writeLines(line, output_conn)
  } else {
    # Split line into fields
    fields <- strsplit(line, "\t")[[1]]
    if (is.null(expected_columns)) {
      expected_columns <- length(fields)
    }
    
    # Check for column count mismatch
    if (length(fields) != expected_columns) {
      problematic_rows <- append(problematic_rows, list(line_number))
    } else {
      writeLines(line, output_conn)
    }
  }
}

# Close connections
close(input_conn)
close(output_conn)

# Print problematic rows
if (length(problematic_rows) > 0) {
  cat("Problematic rows detected (line numbers):\n")
  print(problematic_rows)
} else {
  cat("No problematic rows found.\n")
}

# Compress the fixed VCF file using bgzip
cat("Compressing the fixed VCF file...\n")
system(paste("bgzip -c", output_vcf, ">", compressed_vcf))

# Index the compressed VCF file using tabix
cat("Indexing the fixed VCF file...\n")
system(paste("tabix -p vcf", compressed_vcf))

# Completion message
cat("Fixed VCF file saved and indexed as:", compressed_vcf, "\n")
