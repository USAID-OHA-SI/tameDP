test_that("correct tabs are returned based on output type", {

  expect_error(return_tab("Home"))

  expect_equal(return_tab("PSNUxIM"), "PSNUxIM")
  expect_equal(return_tab("PLHIV"), "Cascade")
  expect_equal(return_tab("ALL"),
               c("Cascade",
                 "PMTCT",
                 "EID",
                 "TB",
                 "VMMC",
                 "KP",
                 "HTS",
                 "CXCA",
                 "HTS_RECENT",
                 "TX_TB_PREV",
                 "PP",
                 "OVC",
                 "GEND",
                 "AGYW",
                 "PrEP",
                 "KP_MAT"))

})
