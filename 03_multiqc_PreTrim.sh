#!/bin/bash
#
#$ -M bmishra2@nd.edu
#$ -m abe
#$ -q debug
#$ -N read_multiqc

# load the bio/2.0 module from CRC or intall fastqc

module load bio/2.0


# --- Configuration ---
# Set default input and results directories.
# You can override these by passing them as arguments when running the script:
# e.g., ./read_multiqc.sh /path/to/my/analysis_data /path/to/my/results_output
# --------------------
# For MultiQC, the input_dir is the directory it will search for QC output files.
# This should be the base directory where your tools (like FastQC, Trimmomatic, etc.)
# have placed their output logs and reports.
input_dir="~/ND_ICG_FA2025/results/fastqc" # MultiQC often searches results directories
results_base_dir="-~/ND_ICG_FA2025/results" # Output base for MultiQC report

# MultiQC specific configurations
multiqc_output_subdir="multiqc_report_PreTrim"       # Subdirectory for MultiQC report
multiqc_report_name="multiqc_report_PreTrim.html"    # Name of the generated HTML report

# --- Script Start ---
echo "--- MultiQC Report Generation Script ---"
echo "MultiQC Search Directory: '$input_dir'"
echo "MultiQC Report Output Base Directory: '$results_base_dir'"

# Define full path for MultiQC specific results directory
multiqc_results_dir="${results_base_dir}/${multiqc_output_subdir}"

# --- MultiQC Section ---
echo -e "\n--- Running MultiQC ---"

# 1. Prepare MultiQC output directory
echo "Preparing MultiQC results directory: '$multiqc_results_dir'"
mkdir -p "$multiqc_results_dir" || { echo "Error: Could not create MultiQC results directory '$multiqc_results_dir'. Exiting."; exit 1; }

# 2. Check if the input directory for MultiQC exists
if [ ! -d "$input_dir" ]; then
    echo "Error: MultiQC search directory '$input_dir' not found. Please ensure it exists and contains QC output."
    exit 1
fi

# 3. Run MultiQC
echo "Running MultiQC on data in '$input_dir' and its subdirectories..."
# MultiQC will search the provided directories for compatible log files
multiqc "$input_dir" -o "$multiqc_results_dir" -n "$multiqc_report_name" --force

if [ $? -ne 0 ]; then
    echo "Error: MultiQC failed to generate report."
    echo "Ensure MultiQC is installed and accessible in your PATH."
    echo "Also check if there are any compatible log files in '$input_dir'."
    exit 1
fi

echo -e "\n--- Script Execution Complete! ---"
echo "MultiQC report is located in: '$multiqc_results_dir/$multiqc_report_name'"
echo "You can open the report in your web browser: file://${multiqc_results_dir}/${multiqc_report_name}"
