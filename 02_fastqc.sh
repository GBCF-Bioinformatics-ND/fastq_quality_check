!/bin/bash

#$ -M bmishra2@nd.edu
#$ -m abe
#$ -q debug
#$ -N read_qc

# load the bio/2.0 module from CRC or intall fastqc

module load bio/2.0

# --- Configuration ---
# Set default input and results directories.
# You can override these by passing them as arguments when running the script:
# e.g., ./read_fastqc.sh /path/to/my/fastq_files /path/to/my/analysis_results
# --------------------
input_dir="~/ND_ICG_FA2025/input"
results_base_dir="~/ND_ICG_FA2025/results"
fastqc_output_subdir="fastqc_untrimmed_reads" # Specific subdirectory for FastQC results
fastqc_summary_file="fastqc_summaries.txt"    # Name of the combined summary file
docs_dir="~/ND_ICG_FA_2025/notes"           # Directory for documentation/summaries

# --- Script Start ---
echo "--- FastQC Analysis Script ---"
echo "Input Directory: '$input_dir'"
echo "Results Base Directory: '$results_base_dir'"

# Define the full path for FastQC specific results
fastqc_results_dir="${results_base_dir}/${fastqc_output_subdir}"

# 1. Prepare output directory
echo -e "\nPreparing results directory..."
mkdir -p "$fastqc_results_dir" || { echo "Error: Could not create results directory '$fastqc_results_dir'. Exiting."; exit 1; }


# 2. Run FastQC directly from the input directory, outputting to the designated results folder
echo -e "\nNavigating to input directory..."
if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory '$input_dir' not found. Please ensure it exists."
    exit 1
fi
cd "$input_dir" || { echo "Error: Could not change to input directory '$input_dir'. Exiting."; exit 1; }

echo "Running FastQC on *.fastq* files and directing output to '$fastqc_results_dir'..."
# FastQC will place its .zip and .html files directly into fastqc_results_dir
fastqc -o "$fastqc_results_dir" *.fastq*


# 3. Unzip FastQC reports and consolidate summaries
echo -e "\nNavigating to FastQC results directory to unzip reports..."
cd "$fastqc_results_dir" || { echo "Error: Could not change to FastQC results directory '$fastqc_results_dir'. Exiting."; exit 1; }

echo "Unzipping FastQC zip files..."
# Check if there are any zip files before looping
shopt -s nullglob # Allows loop to not run if no files match
for filename in *.zip; do
    echo "  - Unzipping '$filename'"
    unzip -q "$filename" # -q for quiet output
done
shopt -u nullglob # Turn off nullglob


# Consolidate summary files
echo "Consolidating FastQC summary reports into '$docs_dir/$fastqc_summary_file'..."
mkdir -p "$docs_dir" # Ensure the documentation directory exists
# Find all summary.txt files within the unzipped FastQC report directories
find . -type f -name "summary.txt" -exec cat {} + > "$docs_dir/$fastqc_summary_file"

echo -e "\n--- FastQC Analysis Complete! ---"
echo "FastQC reports are located in: '$fastqc_results_dir'"
echo "Combined summary available at: '$docs_dir/$fastqc_summary_file'"
