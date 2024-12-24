for K in {3..10}; do
    admixture --cv ld_pruned_data.bed $K > admixture_k${K}.out
done

grep -h CV admixture_k*.out > cv_errors.txt

# Load necessary libraries
library(ggplot2)

# Read CV errors
cv_errors <- read.table("cv_errors.txt", header=FALSE)
colnames(cv_errors) <- c("K", "CV_Error")

# Plot CV errors
ggplot(cv_errors, aes(x=K, y=CV_Error)) +
    geom_line() +
    geom_point() +
    labs(x="Number of Clusters (K)", y="Cross-Validation Error") +
    theme_minimal()
