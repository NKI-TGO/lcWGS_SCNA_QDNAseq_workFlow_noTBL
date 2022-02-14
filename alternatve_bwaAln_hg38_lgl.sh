#BWA ALN

#Ref
#/DATA/share/pipelines/lgleon/References/Ensembl/NGSfacility/Homo_sapiens.GRCh38.dna.primary_assembly.fa

#data
#prj=/DATA/share/pipelines/lgleon/organoids_rawdata/DNA/fastq
prj=/DATA/share/pipelines/lgleon/cergentis_C5/Raw_data/fastq

for file in ${prj}/*.f*q.gz
do

   inputfqgz=$file
   #outputbam=${file/%.fastq.gz/.bam}  #  % means that suffixes are matched, # would mean prefixes"
   filenamestem=${file/%.f*q.gz/}
   
   echo "!!!!!!!!!!!!!! Expected final output {$filenamestem.markdup.bam}"

   bwa aln -t 32 -n 2 /DATA/share/pipelines/lgleon/References/Ensembl/NGSfacility/Homo_sapiens.GRCh38.dna.primary_assembly.fa  $inputfqgz | bwa samse -r '@RG\tID:inputfqgz\tSM:inputfqgz' /DATA/share/pipelines/lgleon/References/Ensembl/NGSfacility/Homo_sapiens.GRCh38.dna.primary_assembly.fa - $inputfqgz | samtools view -Su - | samtools sort - -o $filenamestem.sorted.bam > $filenamestem.sorted.bam

   picard MarkDuplicates I=$filenamestem.sorted.bam O=$filenamestem.markdup.bam M=$filenamestem.markdup_metrics.txt ASSUME_SORTED=true CREATE_INDEX=false VALIDATION_STRINGENCY=LENIENT

done



mkdir fastQC
#mv *fastq.gz fastQC

mkdir sorted_bam
mv *.sorted.bam sorted_bam
#rm *sorted.bam

mkdir markdup_bam
mv *markdup.bam markdup_bam

#Now it change again back to the old way to put it
#OldWay
#picard MarkDuplicates I=$filenamestem.sorted.bam O=$filenamestem.markdup.bam M=$filenamestem.markdup_metrics.txt ASSUME_SORTED=true CREATE_INDEX=false VALIDATION_STRINGENCY=LENIENT
#newWay
#MarkDuplicates -I /DATA/share/pipelines/lgleon/organoids_rawdata/DNA/fastq/4396_26_B15PON_C044-T_p2_GTACGCAA_S36_L002_R1_001.sorted.bam -O /DATA/share/pipelines/lgleon/organoids_rawdata/DNA/fastq/4396_26_B15PON_C044-T_p2_GTACGCAA_S36_L002_R1_001.markdup.bam -M /DATA/share/pipelines/lgleon/organoids_rawdata/DNA/fastq/4396_26_B15PON_C044-T_p2_GTACGCAA_S36_L002_R1_001.markdup_metrics.txt -ASSUME_SORTED true -CREATE_INDEX false -VALIDATION_STRINGENCY LENIENT