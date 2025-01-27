#' A sample `DESeqResults` object
#'
#' A sample `DESeqResults` object, generated in the `DESeq2` framework
#'
#' @details This `DESeqResults` object is on the data from the `macrophage`
#' package. This result set has been created by setting the design to
#' `~line + condition` to detect the effect of the `condition` while accounting
#' for the different cell `line`s included.
#'
#' Specifically, this object contains the differences between the `IFNg` vs
#' `naive` samples, testing against a logFC threshold of 1 for robustness.
#'
#' @format A `DESeqResults` object
#'
#' @source Details on how this object has been created are included in the
#' `create_mosdef_data.R` script, included in the (installed) `inst/scripts`
#' folder of the `mosdef` package. This is also available at
#' \url{https://github.com/imbeimainz/mosdef/blob/devel/inst/scripts/create_mosdef_data.R}
#'
#' @references Alasoo, et al. "Shared genetic effects on chromatin and gene
#' expression indicate a role for enhancer priming in immune response",
#' Nature Genetics, January 2018 doi: 10.1038/s41588-018-0046-7.
#'
#' @name res_macrophage_IFNg_vs_naive
#' @docType data
#'
NULL


#' A sample enrichment object
#'
#' A sample enrichment object, generated in the `mosdef` and `topGO` framework
#'
#' @details This enrichment object is on the data from the `macrophage` package.
#'
#' Specifically, this set of enrichment results was created using the
#' Biological Process ontology, mapping the gene symbol identifiers through the
#' `org.Hs.eg.db` package.
#'
#' @format A `data.frame` object
#'
#' @source Details on how this object has been created are included in the
#' `create_mosdef_data.R` script, included in the (installed) `inst/scripts`
#' folder of the `mosdef` package. This is also available at
#' \url{https://github.com/imbeimainz/mosdef/blob/devel/inst/scripts/create_mosdef_data.R}
#'
#' @references Alasoo, et al. "Shared genetic effects on chromatin and gene
#' expression indicate a role for enhancer priming in immune response",
#' Nature Genetics, January 2018 doi: 10.1038/s41588-018-0046-7.
#'
#' @seealso [res_macrophage_IFNg_vs_naive]
#'
#' @name res_enrich_macrophage_topGO
#' @docType data
#'
NULL

#' A sample enrichment object
#'
#' A sample enrichment object, generated in the `mosdef` and `goseq` framework
#'
#' @details This enrichment object is on the data from the `macrophage` package
#'
#' Specifically, this set of enrichment results was created using the
#' Biological Process ontology, mapping the gene symbol identifiers through the
#' `org.Hs.eg.db` package - the gene length information is retrieved by the
#' internal routines of `goseq`.
#'
#' @format A `data.frame` object
#'
#' @source Details on how this object has been created are included in the
#' `create_mosdef_data.R` script, included in the (installed) `inst/scripts`
#' folder of the `mosdef` package. This is also available at
#' \url{https://github.com/imbeimainz/mosdef/blob/devel/inst/scripts/create_mosdef_data.R}
#'
#' @references Alasoo, et al. "Shared genetic effects on chromatin and gene
#' expression indicate a role for enhancer priming in immune response",
#' Nature Genetics, January 2018 doi: 10.1038/s41588-018-0046-7.
#'
#' @name res_enrich_macrophage_goseq
#'
#' @seealso [res_macrophage_IFNg_vs_naive]
#'
#' @docType data
#'
NULL

#' A sample enrichment object
#'
#' A sample enrichment object, generated in the `mosdef` and `clusterProfiler`
#' framework
#'
#' @details This enrichment object is on the data from the `macrophage` package
#'
#' Specifically, this set of enrichment results was created using the
#' Biological Process ontology, mapping the gene identifiers through the
#' `org.Hs.eg.db` package.
#'
#' @format An `enrichResult` object
#'
#' @source Details on how this object has been created are included in the
#' `create_mosdef_data.R` script, included in the (installed) `inst/scripts`
#' folder of the `mosdef` package. This is also available at
#' \url{https://github.com/imbeimainz/mosdef/blob/devel/inst/scripts/create_mosdef_data.R}
#'
#' @references Alasoo, et al. "Shared genetic effects on chromatin and gene
#' expression indicate a role for enhancer priming in immune response",
#' Nature Genetics, January 2018 doi: 10.1038/s41588-018-0046-7.
#'
#' @name res_enrich_macrophage_cluPro
#'
#' @seealso [res_macrophage_IFNg_vs_naive]
#'
#' @docType data
#'
NULL
