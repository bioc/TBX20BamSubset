## This script retrieves the sequencing raw data of the TBX20 study
## and compiles a pheno data. The authors of the original study
## performed a Chip Seq experiment as well as an RNA-Seq experiment.
## Since we are interested in transcriptome analysis we only use the
## RNA-Seq part of the data.


###########################
## Compile the phenodata ##
###########################

library("GEOquery")

if(! file.exists("GEO")) system("mkdir GEO")

gse.name <- "GSE30943"
gse <- getGEO(gse.name, destdir = "GEO")
gse <- getGEO(filename="GEO/GSE30943_series_matrix.txt.gz")

pd <- pData(gse)[, c("geo_accession", "source_name_ch1", "title",
                     "relation",
                     "library_strategy")]

## subset only to RNA-Seq data
pd <- pd[pd$library_strategy == "RNA-Seq", ]

## format the phenodata
pd$relation <- sapply(pd$relation, function(SRX) {
  unlist(strsplit(as.character(SRX), split="="))[2]
})
pd$title <- sub("^replicate ", "", sapply(pd$title, function(SRX) {
  unlist(strsplit(as.character(SRX), split=", "))[2]
}))
pd$source_name_ch1 <- sub(" adult heart$", "", as.character(pd$source_name_ch1))

## renames the columns of the phenodata
colnames(pd) <- c("GSM", "condition", "replicate", "SRX", "expType")


###############################
## Downloading the SRA files ##
###############################

fetch.idx <- ! file.exists(paste("", pd$SRX, sep=""))

## dowload the SRA files from GEO if not present
if(any(fetch.idx)) {
  cmds <- paste("wget -r -nH --cut-dirs=7 --no-parent ",
                "--reject='index.html*' ftp://ftp-trace.ncbi.nih.gov/",
                "sra/sra-instant/reads/ByExp/sra/SRX/SRX085/",
                pd$SRX[fetch.idx], sep="")
  sapply(cmds, system)

  ## move downloaded file into the data folder
  cmds <- paste( "mv", pd$SRX[fetch.idx], "")
  sapply(cmds, system)
}


#########################################
## Map the SRA files to the pheno data ##
#########################################

rownames(pd) <- pd$SRX

## list the sra files to get the relationship between
## the pheno data and the SRX files provided by GEO
system("ls SRX*/SRR*/*.sra > sra-idx.txt")
sraToSrx <-
  data.frame(t(simplify2array(strsplit(readLines("sra-idx.txt"),
                                       "/")))[, seq(2,3)])
system("rm sra-idx.txt")

colnames(sraToSrx) <- c("SRX", "SRR")
rownames(sraToSrx) <- sraToSrx$SRR



pd <- data.frame(sraToSrx, pd[as.character(sraToSrx$SRX),])
pd <- pd[, ! colnames(pd) %in% c("expType", "SRX.1")]


#############################
## Extract the FASTQ files ##
#############################

if(!file.exists("FASTQ")) {
  system("mkdir FASTQ")
  system("cd FASTQ/ ; fastq-dump ../SRX085*/*/*.sra")
}

##############################
## Save the phenodata table ##
##############################

write.table(pd, file="phenoData.txt", row.names=FALSE)





