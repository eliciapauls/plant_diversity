##To calculate the average pi for a gene from the vcftools sites pi output
#!/bin/bash

#Input files
gene_file="/data/home/elicia/bedfiles/AthalianaProm.bed"     #contains gene information
pi_file="out.sites.pi"            #contains chromosome, position, and pi
output_file="average_pi_results.txt"

#Ensure output file is empty before appending
> "$output_file"

#Loop through each gene in the gene file
while IFS=$'\t' read -r chrom start stop gene_id
do
    #Use awk to calculate sum of pi and average pi for the current gene
    awk -v chrom="$chrom" -v start="$start" -v stop="$stop" -v gene_id="$gene_id" '
    BEGIN {sum_pi = 0; site_count = 0; OFS = "\t"}
    $1 == chrom && $2 >= start && $2 <= stop {
        sum_pi += $3;    # Add pi value to sum
        site_count++;    # Increment site count
    }
    END {
        gene_length = stop - start + 1;   #length of the gene
        if (site_count > 0) {
            average_pi = sum_pi / gene_length;  #average pi based on gene length
        } else {
            average_pi = 0;   #no sites, average is 0
        }
        #Print results
        print chrom, start, stop, gene_id, gene_length, sum_pi, average_pi;
    }' "$pi_file" >> "$output_file"    #append results to the output file

done < "$gene_file"

echo "Average pi values calculated and saved to $output_file."
