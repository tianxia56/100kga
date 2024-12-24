import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Load the eigenvec file
def load_eigenvec(file_path):
    try:
        eigenvec = pd.read_csv(file_path, delim_whitespace=True, header=None)
        eigenvec.columns = ['FID', 'IID'] + [f'PC{i}' for i in range(1, eigenvec.shape[1] - 1)]
        print("Eigenvec file loaded successfully:")
        print(eigenvec.head())
        return eigenvec
    except FileNotFoundError:
        raise FileNotFoundError(f"The file '{file_path}' was not found. Please check the file path.")
    except Exception as e:
        raise Exception(f"An error occurred while loading the eigenvec file: {e}")

# Load the panel file (only extract IID, POP, and SUPOP)
def load_panel(file_path):
    try:
        panel = pd.read_csv(file_path, sep='\t', usecols=[0, 3, 5], names=['IID', 'POP', 'SUPOP'], header=0)
        print("Panel file loaded successfully:")
        print(panel.head())
        return panel
    except FileNotFoundError:
        raise FileNotFoundError(f"The file '{file_path}' was not found. Please check the file path.")
    except ValueError as e:
        raise ValueError(f"Missing required columns in the panel file: {e}")
    except Exception as e:
        raise Exception(f"An error occurred while loading the panel file: {e}")

# Merge eigenvec and panel files
def merge_data(eigenvec, panel):
    try:
        merged_df = pd.merge(eigenvec, panel, on='IID')
        print("Data merged successfully:")
        print(merged_df.head())
        return merged_df
    except KeyError as e:
        raise KeyError(f"Merge failed due to missing columns: {e}")

# Calculate variance explained by each principal component
def calculate_variance_explained(eigenvec):
    pc_data = eigenvec.iloc[:, 2:]  # Only PC columns
    variance_explained = pc_data.var(axis=0)
    total_variance = variance_explained.sum()

    if total_variance == 0:
        print("Warning: Total variance is zero. Ensure your input data is correct.")
        return np.zeros_like(variance_explained)
    else:
        return (variance_explained / total_variance) * 100

# Plot PCA results excluding specific SUPOPs
def plot_pca_excluding_specific_supops(merged_df, variance_explained_percentage):
    excluded_supops = ['AFR', 'SAS', 'WER']  # Specify the SUPOPs to exclude
    filtered_df = merged_df[~merged_df['SUPOP'].isin(excluded_supops)]  # Exclude these SUPOPs
    unique_supop = filtered_df['SUPOP'].unique()
    unique_pop = filtered_df['POP'].unique()

    # Create consistent color and marker dictionaries
    color_map = {pop: plt.cm.tab20(i % 20) for i, pop in enumerate(unique_pop)}  # Use tab20 for more color variety
    marker_dict = {supop: ['o', 's', 'D', '^', 'v', 'P', '*'][i % 7] for i, supop in enumerate(unique_supop)}

    plt.figure(figsize=(16, 10))  # Extended width for better legend visibility
    for pop in unique_pop:
        subset = filtered_df[filtered_df['POP'] == pop]
        for supop in subset['SUPOP'].unique():
            subsubset = subset[subset['SUPOP'] == supop]
            plt.scatter(
                subsubset['PC1'], subsubset['PC2'], 
                label=f'{pop}-{supop}', 
                c=[color_map[pop]], marker=marker_dict[supop]
            )

    plt.xlabel(f'PC1 ({variance_explained_percentage.iloc[0]:.2f}%)')
    plt.ylabel(f'PC2 ({variance_explained_percentage.iloc[1]:.2f}%)')
    plt.title('PCA of 100kGA samples excluding AFR, SAS, and WER')

    # Add legend for markers and colors below the plot
    marker_legend = [plt.Line2D([0], [0], color='gray', marker=marker_dict[supop], linestyle='', label=supop) for supop in unique_supop]
    color_legend = [plt.Line2D([0], [0], color=color_map[pop], marker='o', linestyle='', label=pop) for pop in unique_pop]

    combined_legend = marker_legend + color_legend

    # Adjust columns dynamicall.100kgay to limit rows to 6
    max_rows = 6
    total_legend_items = len(combined_legend)
    ncol = int(np.ceil(total_legend_items / max_rows))

    plt.legend(
        handles=combined_legend, 
        loc='lower center', 
        bbox_to_anchor=(0.5, -0.25), 
        ncol=ncol,  # Dynamicall.100kgay adjusted number of columns
        frameon=False  # Optional: remove the legend box
    )

    plt.tight_layout()
    plt.savefig('all.100kga_pca_excluding_afr_sas_wer_plot.png')
    print("PCA plot excluding AFR, SAS, and WER saved as 'all.100kga_pca_excluding_afr_sas_wer_plot.png'.")

# Main function
def main():
    eigenvec_file = 'all.100kga.eigenvec'
    panel_file = '../full.iid.panel.txt'

    eigenvec = load_eigenvec(eigenvec_file)
    panel = load_panel(panel_file)
    merged_df = merge_data(eigenvec, panel)

    variance_explained_percentage = calculate_variance_explained(eigenvec)
    print("Variance explained (%):")
    print(variance_explained_percentage)

    plot_pca_excluding_specific_supops(merged_df, variance_explained_percentage)

if __name__ == '__main__':
    main()
