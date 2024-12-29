#!/usr/bin/awk -f

BEGIN {
    FS = ","; OFS = "\t"
}

# Process header line to get column names
NR == 1 {
    # Get only the filename, not the whole path
    table_name = FILENAME
    n = split(table_name, parts, "/")
    table_name = parts[n]
    sub(/\.csv$/, "", table_name)
    printf("CREATE TABLE dbo.%s (\n", table_name)
    for (i = 1; i <= NF; i++) {
        # Remove any trailing newlines or spaces from column names
        gsub(/[ \t\r\n]+$/, "", $i)
        column_names[i] = $i
        column_lengths[i] = 0
    }
    # Check if last field is empty to adjust NF
    if (column_names[NF] == "") {
        NF--
    }
    next
}

# For each subsequent line, update column lengths
{
    for (i = 1; i <= NF; i++) {
        len = length($i)
        if (len > column_lengths[i]) {
            column_lengths[i] = len
        }
    }
}

END {
    for (i = 1; i <= NF; i++) {
        printf("    %s VARCHAR(%d)", column_names[i], column_lengths[i])
        if (i < NF) {
            printf(",\n")
        } else {
            printf("\n);\n\n")  # Add an extra newline for separation between table definitions
        }
    }
}
