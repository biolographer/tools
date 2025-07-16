#!/usr/bin/env bash

set -euo pipefail

# Default values
seed=""
input_dir=""
output_file=""

# Print help
usage() {
    echo "Usage: $0 -s SEED_MSA -i INPUT_DIR -o OUTPUT_FILE"
    echo
    echo "  -s, --seed      Path to seed MSA FASTA file"
    echo "  -i, --input     Directory with single FASTA files to add"
    echo "  -o, --output    Name for final output MSA file"
    echo
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--seed)
            seed="$2"
            shift 2
            ;;
        -i|--input)
            input_dir="$2"
            shift 2
            ;;
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Check required arguments
if [[ -z "$seed" || -z "$input_dir" || -z "$output_file" ]]; then
    echo "Error: --seed, --input, and --output are all required."
    usage
fi

# Check files exist
if [[ ! -f "$seed" ]]; then
    echo "Error: seed file '$seed' not found."
    exit 1
fi

if [[ ! -d "$input_dir" ]]; then
    echo "Error: input directory '$input_dir' not found."
    exit 1
fi

# Initialize current MSA
cp "$seed" current_msa.fasta

echo "Starting iterative addition using MAFFT..."
for s in "$input_dir"/*.fasta; do
    echo "Adding: $s"
    mafft --add "$s" current_msa.fasta > tmp.fasta
    mv tmp.fasta current_msa.fasta
done

# Move final result to desired output filename
mv current_msa.fasta "$output_file"

echo "Done! Final MSA written to '$output_file'"

