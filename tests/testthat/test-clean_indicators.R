test_that("clean target indicator codes", {

  # Base test
  expect_equal(tolower("TameDP"), "tamedp")

  # Indicator Code - Strip Targets Flags
  ind_code1_input <- c("PMTCT_HEI_POS.Linked.T",
                       "HTS_TST.KP.Pos.T_1",
                       "PLHIV_Residents.T2")

  ind_code1_expect <- c("PMTCT_HEI_POS.Linked",
                        "HTS_TST.KP.Pos",
                        "PLHIV_Residents")

  expect_equal(
    stringr::str_remove("HH_TameDP.T", "\\.(T_1|T|T2|R)$"),
    "HH_TameDP"
  )

  expect_true(
    all(stringr::str_remove(ind_code1_input, "\\.(T_1|T|T2|R)$") %in% ind_code1_expect)
  )

  # Indicator Code - Reformat HTS.Index
  ind_code2_input <- c("HTS.Index.Pos.T", "HTS.Index.Neg.T")
  ind_code2_expect <- c("HTS_INDEX.Pos.T", "HTS_INDEX.Neg.T")

  expect_equal(
    paste0(stringr::str_replace(ind_code2_input, "HTS.Index", "HTS_INDEX"), collapse = "-"),
    paste0(ind_code2_expect, collapse = "-")
  )

  # Indicator Code - Extract indicator name
  ind_code3_input <- c("PMTCT_HEI_POS.Linked",
                       "HTS_TST.KP.Pos",
                       "PLHIV_Residents",
                       "HH_TameDP",
                       "HTS_INDEX.Pos",
                       "HTS_INDEX.Neg")

  ind_code3_expect <- c("PMTCT_HEI_POS",
                       "HTS_TST",
                       "PLHIV_Residents",
                       "HH_TameDP",
                       "HTS_INDEX",
                       "HTS_INDEX")

  expect_equal(
    stringr::str_extract(ind_code3_input, "[^\\.]+"),
    ind_code3_expect
  )

  # Numerator / Denominator
  ind_code4_input <- c("TX_PVLS.N.Rt.T",
                       "TX_PVLS.N.Routine.T_1",
                       "TX_PVLS.D.Routine.T_1",
                       "TX_PVLS.D",
                       "PLHIV_Residents")

  expect_equal(
    ifelse(stringr::str_detect(ind_code4_input, "\\.D\\.|\\.D$"), "D", "N"),
    c("N", "N", "D", "D", "N")
  )

  # HIV Status
  ind_code5_input <- c("HTS.Index.Pos",
                       "HTS_TST.Other.Neg")

  expect_equal(
    stringr::str_extract(ind_code5_input, "(Neg|Pos|Unk)$"),
    c("Pos", "Neg")
  )
})
