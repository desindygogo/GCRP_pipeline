
#SNP calling by BaseVar
python BaseVar.py basetype \
-R /ref/gga6/Gallus6.fa \
--regions $x \
--nCPU 30 \
--align-file-list all_bamlist.txt \
--output-vcf all_combine_chr$x.vcf.gz \
--output-cvg all_combine_chr$x.cvg.gz --filename-has-samplename --smart-rerun

#genotyping for low-coverage sequencing data
stitch --chr $x \
--bamlist all_bamlist.txt\
--reference /ref/gga6/Gallus6.fa \
--K 20 \
--nGen 16 \
--nCores 140 \
--niterations 30 \
--outputdir chr$x \
--tempdir tmp \
--posfile chr$x\_pos_qc.txt \
--outputSNPBlockSize 128000
