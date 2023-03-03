test_that("correct tabs are returned for import", {

  # readxl::excel_sheets(filepath) %>% clipr::write_clip()
  # datapasta::vector_paste()

  dp_tabs <- c("Home", "Summary", "Spectrum", "Prioritization", "Cascade",
               "PMTCT", "EID", "TB", "VMMC", "KP", "HTS", "CXCA", "HTS_RECENT",
               "TX_TB_PREV", "PP", "OVC", "GEND", "AGYW", "PrEP", "KP_MAT",
               "KP Validation", "PSNUxIM")

  expect_error(return_tab("wrong") %>%
                  intersect(dp_tabs))

  expect_equal(intersect(return_tab("PSNUxIM"), dp_tabs),
               "PSNUxIM")
  expect_equal(intersect(return_tab("PLHIV"), dp_tabs),
               "Cascade")
  expect_equal(intersect(return_tab("ALL"), dp_tabs),
               c(#"Home",
                 #"Summary",
                 #"Spectrum",
                 #"Prioritization",
                 "Cascade",
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
                 "KP_MAT"
                 #"KP Validation",
                 #"PSNUxIM"
                 )
               )

})


