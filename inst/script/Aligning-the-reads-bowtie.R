## This scripts deals with aligning the reads from the TBX20 data set
## to the reference genome (mm9 from UCSC)

nr.cpu <- 3L

fn <- system.file("script", "Creating-a-bowtie-index.sh", 
                  package="SgTbx20")

## Creating the bowtie indices folder
if(! file.exists("bowtie-indices")) {
  system("mkdir bowtie-indices")
  system(paste("cd bowtie-indices/ ;", fn))
}

if(! file.exists("FASTQ-chr19")) system("mkdir FASTQ-chr19")

## Each sample consist of only one sequencing run
pd <- read.table("phenoData.txt", header=TRUE, stringsAsFactors=FALSE)

## Creating a directory structure for storing alignment
## results
if(!file.exists("SAM")) system("mkdir SAM")
if(file.exists("bowtie.log")) system("rm bowtie.log")

## Aligning the reads using the bowtie index created above
cmds <- paste("bowtie ",
              "-v 2 bowtie-indices/mm9 ",
              "-q FASTQ/", pd$SRR, ".fastq -m 1 --best -y",
              " --phred33-quals -p ", nr.cpu, " ",
              "-S SAM/", pd$SRR, ".sam --al FASTQ-chr19/",
              pd$SRR, ".fastq", sep="")
sapply(cmds, system)

## Select only reads aligning perfect to chromosme 19
if(!file.exists("SAM-chr19")) system("mkdir SAM-chr19")
cmds <- paste("bowtie ",
              "-v 2 bowtie-indices/mm9 ",
              "-q FASTQ-chr19/", pd$SRR, ".fastq -m 1 --best -y",
              " --phred33-quals -p ", nr.cpu, " ",
              "-S SAM-chr19/", pd$SRR, ".sam", sep="")
sapply(cmds, system)


## Finally convert bowtie output (SAM) to BAM using samtools
if(!file.exists("BAM")) system("mkdir BAM")
sam <- list.files(path="SAM")
srr <- sub(".sam$", "", sam)

## Creating indices for samtools
if(! file.exists("bowtie-indices/mm9.fa.fai"))
   system("samtools faidx bowtie-indices/mm9.fa")

## Convert SAM to BAM
library(parallel)
cmds <- paste("samtools import ",
              "bowtie-indices/mm9.fa.fai ",
              "SAM-chr19/", srr, ".sam BAM/", srr,".bam", sep="")
mclapply(cmds, system, mc.cores=nr.cpu)

## Sort BAM files
cmds <- paste("samtools sort BAM/", srr, ".bam BAM/", srr,
              "_sorted", sep="")
mclapply(cmds, system, mc.cores=nr.cpu)

cmds <- paste("samtools index BAM/", srr, "_sorted.bam", sep="")
mclapply(cmds, system, mc.cores=nr.cpu)

cmds <- paste("rm BAM/", srr, ".bam", sep="")
mclapply(cmds, system, mc.cores=nr.cpu)

