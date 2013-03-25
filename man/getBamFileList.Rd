\name{getBamFileList}

\alias{getBamFileList}

\title{
  Retrieving file paths pointing to the BAM files.
}

\description{
  Retrieves the file paths for accessing the data of the
  \code{TBX20BamSubset} package.
}

\usage{
getBamFileList(...)
}

\arguments{  
  \item{...}{
    Arguments to be passed to or from methods.
  }
}

\details{
  Accessory function to the BAM files of the \code{TBX20BamSubset}
  package.
}

\value{ 
  Returns a named character vector pointing to the BAM files included in
  \code{TBX20BamSubset} package.
}

\author{
  D. Bindreither
}


\seealso{
  \link{TBX20BamSubset}
}

\examples{
  bfl <- getBamFileList()
  bfl
}
