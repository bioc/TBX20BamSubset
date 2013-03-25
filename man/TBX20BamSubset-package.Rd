\name{TBX20BamSubset-package}

\alias{TBX20BamSubset-package}
\alias{TBX20BamSubset}

\title{Utilities returning the paths to BAM files of the data package}

\description{
  The package contains 6 subset of BAM files from the TBX20 RNA-Seq
  experiment.
}

\details{
  The TBX20 data set basically provides ChIP-Seq and RNA-Seq
  data. In here only the RNA-Seq part of the data is utilized. TBX20
  (T-box 20) is a transcriptional regulator essential for cardiac
  development and maintenance of mouse heart tissue. In this study TXB20
  was knocked out by using a Tamoxifen mediated conditional knock-out
  system. Transcriptional changes caused by the ablation of the second
  exon of TBX20 result in rapid onset of heart failures and the
  subsequent death of the mice. TBX20 knock-out adult heart tissue was
  compared to wild type adult heart tissue. The associated RNA-Seq raw
  data can be retrieved by the following code chunk.
}

\examples{
  bfs <- getBamFileList()
}

\references{
  Noboru J. Sakabe, Ivy Aneas, Tao Shen, Leila Shokri, Soo-Young Park,
  Martha L. Bulyk, Sylvia M. Evans and Marcelo A. Nobrega
  Human Molecular Genetics
  Date: Feb 2012
  \emph{Dual transcriptional activator and repressor roles of TBX20
    regulateadult cardiac structure and function}
}

\keyword{utilities}
