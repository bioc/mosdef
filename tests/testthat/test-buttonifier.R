test_that("Output is a list for DT", {
  test <- buttonifier(macrophage_df)
  expect_type(test, "list")
})

test_that("Output is a list", {
  test <- buttonifier(macrophage_df, output_format = "DF")
  expect_s3_class(test, "data.frame")
})

test_that("All columns are created", {
  test <- buttonifier(macrophage_df, create_buttons_to = c("GC", "NCBI", "GTEX", "UNIPROT", "dbPTM", "HPA"))
  expect_type(test, "list")
})

test_that("All columns are created", {
  test <- buttonifier(macrophage_df,
                      create_buttons_to = c("GC", "NCBI", "GTEX", "UNIPROT", "dbPTM", "HPA"),
    output_format = "DF"
  )
  expect_s3_class(test, "data.frame")
})

test_that("Errors are triggered correctly", {
  expect_error(buttonifier(macrophage_df, col_to_use = "yaddayadda"))
  expect_error(buttonifier(macrophage_df, create_buttons_to = "Genes"))
})

test_that("Painting tables", {
  out <- de_table_painter(res_macrophage_IFNg_vs_naive,
                          rounding_digits = 3,
                          signif_digits = 5)
  expect_true(is(out, "htmlwidget"))
})
