library("DESeq2")
library("topGO")
library("AnnotationDbi")
library("org.Hs.eg.db")
library("macrophage")
library("scales")
# library("TxDb.Hsapiens.UCSC.hg38.knownGene")

# dds --------------------------------------------------------------------------
data(gse, package = "macrophage")
dds_macrophage <- DESeqDataSet(gse, design = ~ line + condition)
rownames(dds_macrophage) <- substr(rownames(dds_macrophage), 1, 15)

# annotation -------------------------------------------------------------------
anno_df <- data.frame(
  gene_id = rownames(dds_macrophage),
  gene_name = mapIds(org.Hs.eg.db,
    keys = rownames(dds_macrophage),
    column = "SYMBOL",
    keytype = "ENSEMBL"
  ),
  stringsAsFactors = FALSE,
  row.names = rownames(dds_macrophage)
)
# alternatively, one could use the wrapper in ...
# anno_df <- pcaExplorer::get_annotation_orgdb(dds_macrophage, "org.Hs.eg.db", "ENSEMBL")

# res_de -----------------------------------------------------------------------
## using counts and average transcript lengths from tximeta
keep <- rowSums(counts(dds_macrophage) >= 10) >= 6
dds_macrophage <- dds_macrophage[keep, ]
dds_unnormalized <- dds_macrophage

dds_macrophage <- DESeq(dds_macrophage)
# res_de
data(res_de_macrophage, package = "mosdef")

res_macrophage_IFNg_vs_naive$SYMBOL <- AnnotationDbi::mapIds(org.Hs.eg.db,
  keys = row.names(res_macrophage_IFNg_vs_naive),
  column = "SYMBOL",
  keytype = "ENSEMBL",
  multiVals = "first"
)
res_macrophage_IFNg_vs_naive$symbol <- res_macrophage_IFNg_vs_naive$SYMBOL
macrophage_df <- deresult_to_df(res_macrophage_IFNg_vs_naive)

# get a vector of de and bg genes
res_subset <- deresult_to_df(res_macrophage_IFNg_vs_naive)[1:500, ]
myde <- res_subset$id
myassayed <- rownames(res_macrophage_IFNg_vs_naive)
annotationobject <- deresult_to_df(res_macrophage_IFNg_vs_naive)
annotationobject <- annotationobject["SYMBOL"]


# Get a mock dds object and a res object
set.seed(42)
dds_mock <- DESeq2::makeExampleDESeqDataSet(n = 100, m = 8, betaSD = 2)
dds_mock <- DESeq(dds_mock)
res_mock <- results(dds_mock)
# force the rownames to be ENSG *but* make them non-overlapping
rownames(dds_mock) <- rownames(dds_macrophage)[1:100]
rownames(res_mock) <- rownames(dds_macrophage)[51:150]

# res_enrich
data(res_enrich_macrophage_topGO, package = "mosdef")
