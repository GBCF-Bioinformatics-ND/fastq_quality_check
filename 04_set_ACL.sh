#!/bin/bash

#$ -M bmishra2@nd.edu
#$ -m abe
#$ -q long
#$ -N set_acl

# ==============================================================================
# SCRIPT CONFIGURATION
# Update these variables with your information
# ==============================================================================
your_username="bmishra2"
client_username="jlarson7"
sequence_folder="Rohr_JL_16S"


# ==============================================================================
# STEP 1: MANAGE USER PERMISSIONS
# The group 'your_username:genomic_data_users' must already exist.
# ==============================================================================
echo "Adding $client_username to the group: $your_username:genomic_data_users"
pts adduser "$client_username" "$your_username:genomic_data_users"

echo "Changing permissions on the sequence_folder for owner-only access"
# Remove group access from the folder
find "/afs/crc/group/Bioinformatics/Illumina_out/$sequence_folder" -type d -exec fs setacl {} "$your_username:genomic_data_users" none \;
#find "/afs/crc/group/Bioinformatics/Community_Resources/Illumina_out/$sequence_folder" -type d -exec fs setacl {} "$your_username:genomic_data_users" none \;
#find "/afs/crc/group/genomics/May2025/$sequence_folder" -type d -exec fs setacl {} "$your_username:genomic_data_users" none \;

# Set owner-only access for the entire folder tree
find "/afs/crc/group/Bioinformatics/Illumina_out" -type d -exec fs setacl {} "$client_username" rl \;
find "/afs/crc/group/Bioinformatics/Illumina_out/$sequence_folder" -type d -exec fs setacl {} "$client_username" rl \;

fs listacl /afs/crc/group/Bioinformatics/Illumina_out/$sequence_folder
#find "/afs/crc/group/genomics/May2025/$sequence_folder" -type d -exec fs setacl {} "$client_username" rl \;

# ==============================================================================
# STEP 2: Check data integrity
# Navigate to the fastq directory and run md5sum
# ==============================================================================

#cd /afs/crc/group/Bioinformatics/Illumina_out/$renamed_folder

#if [[ -d "$fastq_dir" ]]; then
#    cd "$fastq_dir"
#    md5sum *.fastq.gz > "$fastq_dir/fastq_md5sum.txt"
#    echo "MD5 checksums saved to fastq_md5sum.txt"
#else
#    echo "Fastq directory not found: $fastq_dir"
#fi
