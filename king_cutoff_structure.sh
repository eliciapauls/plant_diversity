#script for prepping data and running faststructure

exec &> batch_structure_output.txt

FILE="/data/home/elicia/regular_vcfs_all_individuals/kubota_ahalleri.vcf.gz"

# quality filter, no maf filter
/data/programs/vcftools_0.1.13/bin/vcftools --gzvcf $FILE --max-missing 0.7 --minQ 30 --minGQ 20 --minDP 5 --max-alleles 2 --recode --recode-INFO-all

# Need to set SNPs IDs
/data/programs/bcftools-1.9/bcftools annotate --set-id +'%CHROM\_%POS\_%REF\_%FIRST_ALT' out.recode.vcf --threads 4 -Ov -o ID.vcf

# LD pruning as highly linked SNPs can bias the structure analysis
/data/programs/plink --vcf ID.vcf --allow-extra-chr --indep-pairphase 50 5 0.4 --double-id --out ./pruned

# make a VCF only with unlinked SNPs (LD r2 max 0.4)
/data/programs/plink --vcf ID.vcf --allow-extra-chr --extract pruned.prune.in --double-id --recode vcf --out pruned

# VCF to plink format (bed, bim, fam) and remove related using king cutoff
/data/programs/plink2 --vcf pruned.vcf --allow-extra-chr --make-bed --double-id --king-cutoff 0.1 --out plink_king_filtered

# faststructure K from 1 to 10
for K in {1..10}
do
python2.7 /lu213/elicia.pauls1/fastStructure-master/structure.py -K $K --input=plink_king_filtered --output=fast_output --full --seed=100
done

rm *.vcf
