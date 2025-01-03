#!/bin/bash

# Directory paths
CSV_DIR="../../data/csv"
OUTPUT_FILE="CreateTables.txt"
AWK_SCRIPT="../awk/flds.awk"

# Ensure the output file does not exist before starting
rm -f "$OUTPUT_FILE"

# Process each CSV file and append to a single file
for csv_file in "$CSV_DIR"/*.csv; do
    if [ -f "$csv_file" ]; then
        base_name=$(basename "$csv_file" .csv)
        
        # Generate SQL for this CSV and append to the output file
        awk -F',' -f "$AWK_SCRIPT" "$csv_file"
    fi
done > "$OUTPUT_FILE"

echo "The CREATE TABLE statements have been saved to: $OUTPUT_FILE"
