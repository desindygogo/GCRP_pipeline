##Phaeing by beagle5 and construct reference panel
java -Xmx150g  -jar beagle.28Sep18.793.jar  gt=<input.vcf> out=<phased.vcf> gp=true impute=true  nthreads=80 iterations=20 ne=40

##Impute genotypes by beagle5
java -Xmx150g -jarbeagle.28Sep18.793.jar gt=<target.vcf> ref=<reference.vcf> out=<output> impute=true nthreads=10 iterations=20 ne=40

##Impute genotypes by Minimac3
Minimac3 --refHaps <reference.vcf> --processReference --prefix refPanel
Minimac3 --refHaps refPanel.m3vcf.gz  --haps <target.vcf.gz>  --prefix <output_impute>  --cpus 20

##Impute genotypes by Impute5
imp5Chunker_1.1.5_static --h <reference.vcf> --g <target.vcf.gz> --o coordinates.txt --r <chr>
imp5Converter_1.1.5_static --h <reference.vcf> --r <chr> --o <output.imp5>
impute5_1.1.5_static --h <reference.vcf> --g <target.vcf.gz> --r <chr> --o <output_impute>

##Impute genotypes by GLIMPSE
GLIMPSE_chunk --input <reference.vcf> --region <chr> --window-size 2000000 --buffer-size 200000 --output chunks.<chr>.txt
VCF=merged.<chr>.vcf.gz
REF=<reference.vcf>
while IFS="" read -r LINE || [ -n "$LINE" ];
do
printf -v ID "%02d" $(echo $LINE | cut -d" " -f1)
IRG=$(echo $LINE | cut -d" " -f3)
ORG=$(echo $LINE | cut -d" " -f4)
OUT=merge.<chr>.1x.${ID}.bcf
GLIMPSE_phase --input ${VCF} --reference ${REF} --input-region ${IRG} --output-region ${ORG} --output ${OUT}
bcftools index -f ${OUT}
done < chunks.<chr>.txt

GLIMPSE_ligate --input bcf_list.txt --output merge.bcf
bcftools index -f merge.bcf
bcftools view merge.bcf -O v -o merge.vcf.gz

##Impute genotypes by QUILT(R code)
bcftools convert reference.vcf.gz --haplegendsample reference
zcat  reference.vcf.gz  | grep -v "^#" | awk '{print $1 "\t" $2 "\t" $4 "\t" $5}' > ref_pos.txt
QUILT(outputdir="quilt_output",chr="chr",bamlist="bam_list.txt",posfile="ref_pos.txt",reference_haplotype_file="ref.ha
p.gz",reference_legend_file="ref.legend.gz",nGen=100,save_prepared_reference=TRUE,,nCores = 40)
