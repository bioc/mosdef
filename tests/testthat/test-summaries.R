test_that("Correlation scatter plot matrix works", {
  pair_corr(counts(dds_macrophage)[1:100, 1:8])
  expect_error(pair_corr(dds_macrophage))
})
