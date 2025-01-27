% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mosdef-data.R
\docType{data}
\name{res_macrophage_IFNg_vs_naive}
\alias{res_macrophage_IFNg_vs_naive}
\title{A sample \code{DESeqResults} object}
\format{
A \code{DESeqResults} object
}
\source{
Details on how this object has been created are included in the
\code{create_mosdef_data.R} script, included in the (installed) \code{inst/scripts}
folder of the \code{mosdef} package. This is also available at
\url{https://github.com/imbeimainz/mosdef/blob/devel/inst/scripts/create_mosdef_data.R}
}
\description{
A sample \code{DESeqResults} object, generated in the \code{DESeq2} framework
}
\details{
This \code{DESeqResults} object is on the data from the \code{macrophage}
package. This result set has been created by setting the design to
\code{~line + condition} to detect the effect of the \code{condition} while accounting
for the different cell \code{line}s included.

Specifically, this object contains the differences between the \code{IFNg} vs
\code{naive} samples, testing against a logFC threshold of 1 for robustness.
}
\references{
Alasoo, et al. "Shared genetic effects on chromatin and gene
expression indicate a role for enhancer priming in immune response",
Nature Genetics, January 2018 doi: 10.1038/s41588-018-0046-7.
}
