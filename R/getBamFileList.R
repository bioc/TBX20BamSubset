## This function returns a list of paths to the BAM
## files

getBamFileList <- function(...)
{
  srr <- paste("SRR", 316184:316189, sep="")
  sapply(srr, function(srr) {
    system.file("extdata", paste(srr, ".bam", sep=""),
                package="TBX20BamSubset")
  })
}

