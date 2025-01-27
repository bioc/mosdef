#' Plot expression values for a gene
#'
#' Plot expression values (e.g. normalized counts) for a gene of interest, grouped
#' by experimental group(s) of interest
#'
#' @details The result of this function can be fed directly to [plotly::ggplotly()]
#' for interactive visualization, instead of the static `ggplot` viz.
#'
#' @param de_container An object containing the data for a Differential
#' Expression workflow (e.g. `DESeq2`, `edgeR` or `limma`).
#' Currently, this can be a `DESeqDataSet` object, normally obtained after
#' running your data through the `DESeq2` framework.
#' @param gene Character, specifies the identifier of the feature (gene) to be
#' plotted
#' @param intgroup A character vector of names in `colData(de_container)` to use for
#' grouping. Note: the vector components should be categorical variables. Defaults
#' to NULL, which which would then select the first column of the `colData` slot.
#' @param assay Character, specifies with assay of the `de_container` object to use for
#' reading out the expression values. Defaults to "counts".
#' @param annotation_obj A `data.frame` object with the feature annotation
#' information, with at least two columns, `gene_id` and `gene_name`.
#' @param normalized Logical value, whether the expression values should be
#' normalized by their size factor. Defaults to TRUE, applies when `assay` is
#' "counts"
#' @param transform Logical value, corresponding whether to have log scale y-axis
#' or not. Defaults to TRUE.
#' @param labels_display Logical value. Whether to display the labels of samples,
#' defaults to TRUE.
#' @param labels_repel Logical value. Whether to use `ggrepel`'s functions to
#' place labels; defaults to TRUE
#' @param plot_type Character, one of "auto", "jitteronly", "boxplot", "violin",
#' or "sina". Defines the type of `geom_` to be used for plotting. Defaults to
#' `auto`, which in turn chooses one of the layers according to the number of
#' samples in the smallest group defined via `intgroup`
#' @param return_data Logical, whether the function should just return the
#' data.frame of expression values and covariates for custom plotting. Defaults
#' to FALSE.
#'
#' @return A `ggplot` object
#' @export
#'
#' @importFrom stats median
#' @importFrom ggplot2 ggplot aes geom_point geom_boxplot geom_violin
#' geom_text position_jitter scale_color_discrete scale_x_discrete scale_y_log10
#' scale_y_continuous stat_summary theme_bw labs
#' @importFrom ggrepel geom_text_repel
#' @importFrom ggforce geom_sina
#' @importFrom rlang .data
#'
#'
#' @examples
#' library("macrophage")
#' library("DESeq2")
#' library("org.Hs.eg.db")
#'
#' # dds object
#' data(gse, package = "macrophage")
#' dds_macrophage <- DESeqDataSet(gse, design = ~ line + condition)
#' rownames(dds_macrophage) <- substr(rownames(dds_macrophage), 1, 15)
#' keep <- rowSums(counts(dds_macrophage) >= 10) >= 6
#' dds_macrophage <- dds_macrophage[keep, ]
#' # dds_macrophage <- DESeq(dds_macrophage)
#'
#' # annotation object
#' anno_df <- data.frame(
#'   gene_id = rownames(dds_macrophage),
#'   gene_name = mapIds(org.Hs.eg.db,
#'     keys = rownames(dds_macrophage),
#'     column = "SYMBOL",
#'     keytype = "ENSEMBL"
#'   ),
#'   stringsAsFactors = FALSE,
#'   row.names = rownames(dds_macrophage)
#' )
#'
#' gene_plot(
#'   de_container = dds_macrophage,
#'   gene = "ENSG00000125347",
#'   intgroup = "condition",
#'   annotation_obj = anno_df
#' )
gene_plot <- function(de_container,
                      gene,
                      intgroup = NULL,
                      assay = "counts",
                      annotation_obj = NULL,
                      normalized = TRUE,
                      transform = TRUE,
                      labels_display = TRUE,
                      labels_repel = TRUE,
                      plot_type = "auto",
                      return_data = FALSE) {
  if (!is(de_container, "DESeqDataSet")) {
    stop("The provided `de_container` is not a DESeqDataSet object, please check your input parameters.")
  }

  if (is.null(intgroup)) {
    # gently fall back to the first colData element if it is there
    if (length(names(colData(de_container))) > 0) {
      intgroup <- names(colData(de_container))[1]
      message("Defaulting to '", intgroup, "' as the `intgroup` parameter...")
    } else {
      stop("No colData has been provided, therefore `intgroup` cannot be selected properly")
    }
  }

  plot_type <- match.arg(
    plot_type,
    c("auto", "jitteronly", "boxplot", "violin", "sina")
  )

  if (!(all(intgroup %in% colnames(colData(de_container))))) {
    stop(
      "`intgroup` not found in the colData slot of the de_container object",
      "\nPlease specify one of the following: \n",
      paste0(colnames(colData(de_container)), collapse = ", ")
    )
  }

  df <- get_expr_values(
    de_container = de_container,
    gene = gene,
    intgroup = intgroup,
    assay = assay,
    normalized = normalized
  )

  df$sample_id <- rownames(df)
  if (!is.null(annotation_obj)) {
    genesymbol <- annotation_obj$gene_name[match(gene, annotation_obj$gene_id)]
  } else {
    genesymbol <- ""
  }

  onlyfactors <- df[, match(intgroup, colnames(df))]
  df$plotby <- interaction(onlyfactors)

  min_by_groups <- min(table(df$plotby))
  # depending on this, use boxplots/nothing/violins/sina

  if (return_data) {
    return(df)
  }

  p <- ggplot(df, aes(x = .data$plotby, y = .data$exp_value, col = .data$plotby)) +
    scale_x_discrete(name = "") +
    scale_color_discrete(name = "Experimental\ngroup") +
    theme_bw()

  # for connected handling of jittered points AND labels
  jit_pos <- position_jitter(width = 0.2, height = 0, seed = 42)

  # somewhat following the recommendations here
  # https://www.embopress.org/doi/full/10.15252/embj.201694659
  if (plot_type == "jitteronly" || (plot_type == "auto" & min_by_groups <= 3)) {
    p <- p +
      geom_point(aes(x = .data$plotby, y = .data$exp_value),
        position = jit_pos
      )
    # do nothing - or add a line for the median?
  } else if (plot_type == "boxplot" || (plot_type == "auto" & (min_by_groups > 3 & min_by_groups < 10))) {
    p <- p +
      geom_boxplot(outlier.shape = NA) +
      geom_point(aes(x = .data$plotby, y = .data$exp_value), position = jit_pos)
  } else if (plot_type == "violin" || (plot_type == "auto" & (min_by_groups >= 11 & min_by_groups < 40))) {
    p <- p +
      geom_violin() +
      geom_point(aes(x = .data$plotby, y = .data$exp_value), position = jit_pos) +
      stat_summary(
        fun = median, fun.min = median, fun.max = median,
        geom = "crossbar", width = 0.3
      )
  } else if (plot_type == "sina" || (plot_type == "auto" & (min_by_groups >= 40))) {
    p <- p +
      ggforce::geom_sina() +
      stat_summary(
        fun = median, fun.min = median, fun.max = median,
        geom = "crossbar", width = 0.3
      )
  }

  # handling the labels
  if (labels_display) {
    if (labels_repel) {
      p <- p + ggrepel::geom_text_repel(aes(label = .data$sample_id),
        min.segment.length = 0,
        position = jit_pos
      )
    } else {
      p <- p + geom_text(aes(label = .data$sample_id),
        hjust = -0.1, vjust = 0.1,
        position = jit_pos
      )
    }
  }

  y_label <- if (assay == "counts" & normalized) {
    "Normalized counts"
  } else if (assay == "counts" & !normalized) {
    "Counts"
  } else if (assay == "abundance") {
    "TPM - Transcripts Per Million"
  } else {
    assay
  }

  # handling y axis transformation
  if (transform) {
    p <- p + scale_y_log10(name = paste0(y_label, " (log10 scale)"))
  } else {
    p <- p + scale_y_continuous(name = y_label)
  }

  # handling the displayed names and ids
  if (!is.null(annotation_obj)) {
    p <- p + labs(title = paste0(genesymbol, " - ", gene))
  } else {
    p <- p + labs(title = paste0(gene))
  }

  return(p)
}


#' Get expression values
#'
#' Extract expression values, with the possibility to select other assay slots
#'
#' @param de_container An object containing the data for a Differential
#' Expression workflow (e.g. `DESeq2`, `edgeR` or `limma`).
#' Currently, this can be a `DESeqDataSet` object, normally obtained after
#' running your data through the `DESeq2` framework.
#' @param gene Character, specifies the identifier of the feature (gene) to be
#' extracted
#' @param intgroup A character vector of names in `colData(de_container)` to use for
#' grouping.
#' @param assay Character, specifies with assay of the `de_container` object to use for
#' reading out the expression values. Defaults to "counts".
#' @param normalized Logical value, whether the expression values should be
#' normalized by their size factor. Defaults to TRUE, applies when `assay` is
#' "counts"
#'
#' @return A tidy data.frame with the expression values and covariates for
#' further processing
#'
#' @export
#'
#' @importFrom DESeq2 counts estimateSizeFactors sizeFactors normalizationFactors
#' @importFrom SummarizedExperiment colData assays
#'
#' @examples
#' library("macrophage")
#' library("DESeq2")
#' library("org.Hs.eg.db")
#' library("AnnotationDbi")
#'
#' # dds object
#' data(gse, package = "macrophage")
#' dds_macrophage <- DESeqDataSet(gse, design = ~ line + condition)
#' rownames(dds_macrophage) <- substr(rownames(dds_macrophage), 1, 15)
#' keep <- rowSums(counts(dds_macrophage) >= 10) >= 6
#' dds_macrophage <- dds_macrophage[keep, ]
#' # dds_macrophage <- DESeq(dds_macrophage)
#'
#' df_exp <- get_expr_values(
#'   de_container = dds_macrophage,
#'   gene = "ENSG00000125347",
#'   intgroup = "condition"
#' )
#' head(df_exp)
get_expr_values <- function(de_container,
                            gene,
                            intgroup,
                            assay = "counts",
                            normalized = TRUE) {
  if (!(assay %in% names(assays(de_container)))) {
    stop(
      "Please specify a name of one of the existing assays: \n",
      paste(names(assays(de_container)), collapse = ", ")
    )
  }

  # checking the normalization factors are in
  if (is.null(sizeFactors(de_container)) & is.null(normalizationFactors(de_container))) {
    de_container <- estimateSizeFactors(de_container)
  }

  if (assay == "counts") {
    exp_vec <- counts(de_container, normalized = normalized)[gene, ]
  } else {
    exp_vec <- assays(de_container)[[assay]][gene, ]
  }

  exp_df <- data.frame(
    exp_value = exp_vec,
    colData(de_container)[intgroup]
  )

  return(exp_df)
}
