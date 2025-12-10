#!/bin/bash

#$ -M bmishra2@nd.edu
#$ -m abe
#$ -q long
#$ -N file_transfer

# ==============================================================================
# SCRIPT CONFIGURATION
# Update these variables with your information
# ==============================================================================
your_username="bmishra2"
client_username="jlarson7"
sequence_folder="Rohr_JL-3629_18S_250821_VH01485_55"
storage_location="May2025"
renamed_folder="Rohr_JL-3629_18S_250821_VH01485_55"
fastq_dir="/Analysis/1/Data/fastq/"


# ==============================================================================
# STEP 1: LOGIN TO PRIMARY AND SECONDARY CLUSTERS
# ==============================================================================
# echo "Logging into the primary cluster: crcfe01.crc.nd.edu"
# ssh "$your_username@crcfe01.crc.nd.edu" << EOF

# Tunnel into the secondary cluster (lightsheetfs)

echo "Creating a secure tunnel to the secondary cluster: lightsheetfs"
ssh lightsheetfs << EOF2

# Navigate to the source directory

cd /data/BIO/illumina01/genomics

# ==============================================================================
# STEP 2: TRANSFER FILES
# The '&' runs the copy command in the background.
# ==============================================================================
echo "Transferring files to cold storage: /afs/crc/group/genomics/"
cp -R "$sequence_folder/" "/afs/crc/group/genomics/$storage_location/"

#echo "Transferring files to client pickup location: /afs/crc/group/Bioinformatics/Illumina_out/"
#cp -R "$sequence_folder/" "/afs/crc/group/Bioinformatics/Illumina_out/"

# Wait for background jobs to finish
wait

# ==============================================================================
# STEP 3: RENAME FOLDERS
# ==============================================================================
echo "Renaming folder in both pickup and storage locations"
# Rename in client pickup location
#cd "/afs/crc/group/Bioinformatics/Illumina_out/"
#mv "$sequence_folder" "$renamed_folder"

# Rename in cold storage location
cd "/afs/crc/group/genomics/$storage_location/"
mv "$sequence_folder" "$renamed_folder"

# ==============================================================================
# STEP 4: PERFORM MD5SUM CHECK AND CREATE OUTPUT FILE
# This step is performed after the folder has been renamed.
# ==============================================================================
echo "Performing MD5 checksum on .fastq files in the renamed folder"
cd "/afs/crc/group/Bioinformatics/Illumina_out/$renamed_folder"

# Navigate to the fastq directory and run md5sum
if [[ -d "$fastq_dir" ]]; then
    cd "$fastq_dir"
    md5sum *.fastq.gz > "$fastq_dir/$renamed_folder_md5sum.txt"
    echo "MD5 checksums saved to $renamed_folder_md5sum.txt"
else
    echo "Fastq directory not found: $fastq_dir"
fi

# Exit the lightsheetfs shell
EOF2

# Exit the crcfe01 shell
#EOF
