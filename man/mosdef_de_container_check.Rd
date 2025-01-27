% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mosdef_check_inputs.R
\name{mosdef_de_container_check}
\alias{mosdef_de_container_check}
\title{A function checking if your \code{de_container} contains everything you need}
\usage{
mosdef_de_container_check(de_container, verbose = FALSE)
}
\arguments{
\item{de_container}{An object containing the data for a Differential
Expression workflow (e.g. \code{DESeq2}, \code{edgeR} or \code{limma}).
Currently, this can be a \code{DESeqDataSet} object, normally obtained after
running your data through the \code{DESeq2} framework.}

\item{verbose}{Logical, whether to add messages telling the user which steps
were taken.}
}
\value{
An invisible \code{NULL} after performing the checks
}
\description{
A function checking if your \code{de_container} contains everything you need
}
\examples{
library("macrophage")
library("DESeq2")
data(gse, package = "macrophage")

dds_macrophage <- DESeqDataSet(gse, design = ~ line + condition)
rownames(dds_macrophage) <- substr(rownames(dds_macrophage), 1, 15)
keep <- rowSums(counts(dds_macrophage) >= 10) >= 6
dds_macrophage <- dds_macrophage[keep, ]
# dds_macrophage <- DESeq(dds_macrophage)

mosdef_de_container_check(dds_macrophage)
}
