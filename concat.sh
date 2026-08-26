#to concatenate the output files that end up in the step3 directory
#!/bin/bash

#output file
OUTPUT_FILE="concatenated_output.txt"

#initialize output file
echo -n > "$OUTPUT_FILE"

#loop through each file in the current directory that starts with "chr"
for FILE in chr*; do
#extract the value from the file name (after "chr")
  VALUE=$(basename "$FILE" | sed 's/^chr//')

#read the file, skipping the first line and adding the value as the first column
  tail -n +2 "$FILE" | awk -v val="$VALUE" '{print val"\t"$0}' >> "$OUTPUT_FILE"
done

echo "Concatenation complete. Output written to $OUTPUT_FILE."
