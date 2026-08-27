##script to adjust gene density values that fall near scaffold ends, upstream and downstream bases are adjusted to be half the desired window size
#!/bin/bash

#input file
input_file="Zmayscombined.txt"
output_file="Zmays_density_adjusted.txt"

awk '
{
  chromosome = $1;
  gene_start = $2;
  gene_midpoint = $3;
  gene_stop = $4;
  ID = $5;
  gene_density = $6;
  chromosome_length = $7;

  #default upstream and downstream bases
  upstream_bases = 10000;
  downstream_bases = 10000;

  #adjust downstream bases if the window exceeds chromosome boundaries
  if (gene_midpoint + 10000 > chromosome_length) {
    downstream_bases = chromosome_length - gene_midpoint;
  }

  #adjust upstream bases if the window exceeds chromosome boundaries
  if (gene_midpoint < 10001) {
    upstream_bases = gene_midpoint;
  }

  #ensure both upstream and downstream bases are non-negative, if there are zeroes in the output there was an issue
  if (upstream_bases < 0) {
    upstream_bases = 0;
  }
  if (downstream_bases < 0) {
    downstream_bases = 0;
  }

  actual_bases = upstream_bases + downstream_bases;

  #avoid division by zero
  if (actual_bases > 0) {
    # Adjust the gene density
    adjusted_gene_density = gene_density * 20000 / actual_bases;
  } else {
    adjusted_gene_density = 0;  # or handle this case as needed
  }

  print chromosome, gene_start, gene_midpoint, gene_stop, ID, adjusted_gene_density, chromosome_length, actual_bases
}' "$input_file" > "$output_file"

echo "Adjusted file has been saved to $output_file."
