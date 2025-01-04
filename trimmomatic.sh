java -jar trimmomatic-0.38.jar PE \
-summary sum.file\
INPUT_R1.fq.gz INPUT_R2.fq.gz\
OUTPUT_R1.clean.fq.gz OUTPUT_R1.un.fq.gz \
OUTPUT_R2.clean.fq.gz OUTPUT_R2.un.fq.gz \
SLIDINGWINDOW:4:10 MINLEN:100
