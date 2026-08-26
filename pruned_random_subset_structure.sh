#!/bin/bash

##to randomly select snps from a vcf and parse into a new vcf
#input is the pruned vcf from the king_cutoff_structure script

/data/programs/bcftools-1.9/bcftools query -l pruned.vcf > samples.txt
/data/programs/bcftools-1.9/bcftools view --header-only --samples-file samples.txt  pruned.vcf > pruned_header_only.vcf
/data/programs/bcftools-1.9/bcftools view --no-header --samples-file samples.txt  pruned.vcf | awk '{printf("%f\t%s\n",rand(),$0);}' | sort -t $'\t'  -T . -k1,1g | head -n 10000 | cut -f 2- >> pruned_10000_random_snps.vcf
sort pruned_10000_random_snps.vcf > pruned_10000_random_snps_sorted.vcf
cat pruned_header_only.vcf pruned_10000_random_snps_sorted.vcf > pruned_subset_10k.vcf
