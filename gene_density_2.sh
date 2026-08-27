##add scaffold lengths to gene density output file 1
#!/bin/bash

# Input files
file1="Zmaysgenespaces.txt"
file2="../Zmays/fasta_scaffolds_with_lengths.txt"
output_file="Zmayscombined.txt"

# Use awk to process the files
awk '
  # Read File2.txt and store the second column in an array indexed by the first column
  FNR==NR { map[$1]=$2; next }

  # For each line in File1.txt, append the corresponding value from the array
  { print $0, map[$1] }
' "$file2" "$file1" > "$output_file"

echo "Files have been combined and saved to $output_file."
