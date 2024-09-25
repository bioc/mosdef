test_that("Annotation data frame retrieval", {
  anno_df <- get_annotation_orgdb(
    de_container = dds_macrophage,
    orgdb_package = "org.Hs.eg.db",
    id_type = "ENSEMBL"
  )

  expect_s3_class(anno_df, "data.frame")
  expect_true(all(dim(anno_df) == c(17806, 2)))
})
