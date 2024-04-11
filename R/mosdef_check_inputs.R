#' A function checking if your res_de contains everything you need
#'
#' @param res_de A DESeqResults object created using \code{DESeq2}
#' @param verbose  Logical, whether to add messages telling the user which steps
#' were taken
#'
#' @return An invisible `NULL` after performing the checks
#' @export
#'
#' @examples
#' data(res_de_macrophage, package = "mosdef")
#'
#' mosdef_res_check(res_macrophage_IFNg_vs_naive)
mosdef_res_check <- function(res_de,
                             verbose = FALSE) {
  if ("symbol" %in% colnames(res_de)) {
    if (verbose) message("Found a 'symbol' column!")
  } else {
    warning("Could not find a 'symbol' column. This can be created for you in the other functions")
  }

  if ("padj" %in% colnames(res_de)) {
    if (verbose) message("Found a 'padj' column!")
  } else {
    warning("Could not find a 'padj' column. Please ensure you have these values
          and rename the column: 'padj'")
  }

  if ("log2FoldChange" %in% colnames(res_de)) {
    if (verbose) message("Found a 'log2FoldChange' column!")
  } else {
    warning("Could not find a 'log2FoldChange' column. Please ensure you have these values
          and rename the column: 'log2FoldChange'")
  }

  if ("pvalue" %in% colnames(res_de)) {
    if (verbose) message("Found a 'pvalue' column!")
  } else {
    warning("Could not find a 'pvalue' column. Please ensure you have these values
          and rename the column: 'pvalue'")
  }

  if ("pvalue" %in% colnames(res_de)) {
    if (verbose) message("Found a 'baseMean' column!")
  } else {
    warning("Could not find a 'baseMean' column. If you want to use the gene_plot function:
          Please ensure you have these values and rename the column: 'baseMean'")
  }

  if (all(grep(pattern = "^ENS", rownames(res_de)))) {
    if (verbose) message("Rownames are ENSEMBL IDs.")
  } else {
    warning("Rownames are not ENSEMBL IDs. Please change them to ENSEMBL IDs by using
            AnnotationDbis 'mapIDs'")
  }

  return(invisible(NULL))
}

#' A function checking if your `de_container` contains everything you need
#'
#' @param de_container An object containing the data for a Differential
#' Expression workflow (e.g. `DESeq2`, `edgeR` or `limma`).
#' Currently, this can be a `DESeqDataSet` object, normally obtained after
#' running your data through the `DESeq2` framework.
#' @param verbose Logical, whether to add messages telling the user which steps
#' were taken.
#'
#' @return An invisible `NULL` after performing the checks
#' @export
#'
#' @examples
#' library("macrophage")
#' library("DESeq2")
#' data(gse, package = "macrophage")
#'
#' dds_macrophage <- DESeqDataSet(gse, design = ~ line + condition)
#' rownames(dds_macrophage) <- substr(rownames(dds_macrophage), 1, 15)
#' keep <- rowSums(counts(dds_macrophage) >= 10) >= 6
#' dds_macrophage <- dds_macrophage[keep, ]
#' dds_macrophage <- DESeq(dds_macrophage)
#'
#' mosdef_de_container_check(dds_macrophage)
mosdef_de_container_check <- function(de_container,
                                      verbose = FALSE) {
  if (all(grep(pattern = "^ENS", rownames(de_container)))) {
    if (verbose) message("Rownames are ENSEMBL IDs.")
  } else {
    warning("Rownames are not ENSEMBL IDs. Please change them to ENSEMBL IDs by using
            AnnotationDbis 'mapIDs'")
  }
  if ("counts" %in% names(assays(de_container))) {

    if (verbose) message("Found a 'counts' assay!")
  } else {
    warning("Could not find a 'counts' assay Please ensure you have these values
          and rename the column/assay: 'counts'")
  }
  return(invisible(NULL))
}
