#caculate GC by vcftools
vcftools --gzvcf *impute.dose.vcf.gz --recode --out impute_target
vcftools --gzvcf *real.recode.vcf.gz --diff impute_target.recode.vcf --diff-indv-discordance --out compare_out
cat compare_out.diff.indv | awk 'NR>1{print $1 "\t" 1-$4}' > GC_out_per_indv.out
