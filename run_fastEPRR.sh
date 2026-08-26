awk '{OFS="\t"}{print $1}' /data/home/elicia/populations/Hannuus_population.txt > populationfile.txt

/data/programs/bcftools-1.9/bcftools view -S populationfile.txt /data/home/elicia/regular_vcfs_all_individuals/todesco_hann.vcf.gz -Oz -o subset.recode.vcf.gz

tabix -p vcf subset.recode.vcf.gz

while read p; do
/data/programs/bcftools-1.9/bcftools view subset.recode.vcf.gz --regions $p -Oz -o chr.vcf.gz

#filter and thin to analyse structure
/data/programs/vcftools_0.1.13/bin/vcftools --gzvcf chr.vcf.gz --max-missing 0.7 --minQ 30 --minGQ 20 --minDP 5 --max-alleles 2 --thin 2500 --recode --recode-INFO-all



java -Xmx128g -jar /lu213/elicia.pauls1/beagle.06Aug24.a91.jar gt=out.recode.vcf out=phased

/data/programs/R-3.6.2/bin/Rscript fasteprr.R

rm phased.vcf.gz
rm chr.vcf.gz
rm out.recode.vcf
rm ./rec_test/step1/*
rm ./rec_test/step2/*
done < chromosomes_list.txt
