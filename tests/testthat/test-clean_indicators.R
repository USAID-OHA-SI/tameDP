test_that("clean target setting indicators", {
  expect_equal(2 * 2, 4)

  expect_equal(
    stringr::str_remove("HH_TameDP.T", "\\.(T_1|T|T2|R)$"),
    "HH_TamDP"
  )
})
