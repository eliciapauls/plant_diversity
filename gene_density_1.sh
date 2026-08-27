##script for calculating gene density, range size is adjusted to be half the desired window size, and values are adjusted for scaffold ends in the following script
#!/bin/bash

bed_file="/data/home/elicia/bedfiles/Zmaysgenes.bed"
range_size=50000
output_file="Zmaysgenespaces.txt"

while IFS=$'\t' read -r gene start stop ID
do
    midpoint=$(expr '(' "$start" + "$stop" ')' / 2)
    gene_start=$(expr "$midpoint" - "$range_size")
    gene_stop=$(expr "$midpoint" + "$range_size")

    if [ "$gene_start" -lt 0 ]; then
        gene_start=0
    fi

    echo -e "$gene\t$gene_start\t$gene_stop" > /data/home/elicia/bedfiles/gene_range.bed

    intersect_output=$(/data/programs/bedtools2/bin/bedtools intersect -a /data/home/elicia/bedfiles/gene_range.bed -b "$bed_file")

    overlap=$(echo "$intersect_output" | awk -v range_size="$range_size" '{sum += $3 - $2} END {print sum / (2 * range_size)}')


    echo -e "$gene\t$start\t$midpoint\t$stop\t$ID\t$overlap" >> "$output_file"

    rm /data/home/elicia/bedfiles/gene_range.bed

done < "$bed_file"
