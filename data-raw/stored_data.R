## table of OUs to
ou_ctry_mapping <- glamr::pepfar_country_list %>%
  dplyr::select(operatingunit, country)

ou_ctry_mapping <- ou_ctry_mapping %>%
  dplyr::bind_rows(ou_ctry_mapping %>%
                     dplyr::filter(stringr::str_detect(operatingunit, "Region")) %>%
                     dplyr::distinct(operatingunit) %>%
                     dplyr::mutate(country = operatingunit)) %>%
  dplyr::bind_rows(tibble::tibble(operatingunit = "Western Hemisphere Region", country = "Caribbean Region")) %>%
  dplyr::bind_rows(tibble::tibble(operatingunit = "Jupiter", country = "Jupiter"))

usethis::use_data(ou_ctry_mapping, overwrite = TRUE)



##review indicator/disagg mapping for table creation below

# library(datapackr)
# library(datimutils)
# library(glamr)
# library(gophr)
#
# cop24_data_pack_schema %>%
#   tibble::as_tibble() %>%
#   dplyr::filter(dataset == "mer")
#
# df_msd <- si_path() %>%
#   return_latest("OU_IM") %>%
#   read_psd()
#
#
# tfile <- tempfile(fileext = '.csv')
#
# df_disaggs <- df_msd %>%
#   dplyr::filter(fiscal_year > 2022) %>%
#   dplyr::group_by(fiscal_year, indicator, numeratordenom, standardizeddisaggregate) %>%
#   dplyr::summarise(dplyr::across(c(cumulative, targets), sum, na.rm = TRUE),
#                    .groups = 'drop') %>%
#   tidyr::pivot_wider(names_from = fiscal_year,
#                      values_from = c(cumulative, targets)) %>%
#   dplyr::select(-cumulative_2024) %>%
#   dplyr::mutate(total_row =stringr::str_detect(standardizeddisaggregate, "Total"),
#                 kp_disagg = dplyr::case_when(indicator %in% c("KP_MAT", "KP_MAT_SUBNAT") ~ FALSE,
#                                              stringr::str_detect(standardizeddisaggregate, "KeyPop") ~ TRUE,
#                                              TRUE ~ FALSE)) %>%
#   dplyr::relocate(kp_disagg, .after = standardizeddisaggregate) %>%
#   dplyr::arrange(indicator, numeratordenom, dplyr::desc(total_row), standardizeddisaggregate)
#
# df_comp <- mer_disagg_mapping %>%
#   dplyr::mutate(used = TRUE) %>%
#   tidylog::full_join(df_disaggs, .)
#
#
# readr::write_csv(df_comp, tfile, na = "")
# shell.exec(tfile)
#
# #indicators in MSD not found in TST
# setdiff(df_disaggs %>%
#           clean_indicator() %>%
#           dplyr::distinct(indicator) %>%
#           dplyr::pull(),
#         mer_disagg_mapping %>%
#           clean_indicator() %>%
#           dplyr::distinct(indicator) %>%
#           dplyr::pull())
#
# #indicators in TST not found in MSD
# setdiff(mer_disagg_mapping %>%
#           clean_indicator() %>%
#           dplyr::distinct(indicator) %>%
#           dplyr::pull(),
#         df_disaggs %>%
#           clean_indicator() %>%
#           dplyr::distinct(indicator) %>%
#           dplyr::pull())

## table of indicators and their disaggs
mer_disagg_mapping <-
  tibble::tribble(
                  ~indicator, ~numeratordenom,                   ~standardizeddisaggregate, ~kp_disagg,
                 "AGYW_PREV",             "D",                       "Age/Sex/DREAMSBegun",      FALSE,
                 "AGYW_PREV",             "N",             "Age/Sex/DREAMSPrimaryComplete",      FALSE,
                 "CXCA_SCRN",             "N",                         "Age/Sex/HIVStatus",      FALSE,
          "DIAGNOSED_SUBNAT",             "N",                         "Age/Sex/HIVStatus",      FALSE,
                  "GEND_GBV",             "N",                       "ViolenceServiceType",      FALSE,
                  "HIV_PREV",             "N",                                   "Age/Sex",      FALSE,
                 "HTS_INDEX",             "N",                          "4:Age/Sex/Result",      FALSE,
                "HTS_RECENT",             "N",                          "KeyPop/HIVStatus",       TRUE,
                "HTS_RECENT",             "N",                         "Age/Sex/HIVStatus",      FALSE,
                  "HTS_SELF",             "N",                                   "Age/Sex",      FALSE,
                  "HTS_SELF",             "N",                                    "KeyPop",       TRUE,
                   "HTS_TST",             "N",                             "KeyPop/Result",       TRUE,
                   "HTS_TST",             "N",                   "Modality/Age/Sex/Result",      FALSE,
               "HTS_TST_POS",             "N",                             "KeyPop/Result",       TRUE,
               "HTS_TST_POS",             "N",                   "Modality/Age/Sex/Result",      FALSE,
                    "KP_MAT",             "N",                                       "Sex",      FALSE,
             "KP_MAT_SUBNAT",             "N",                                       "Sex",      FALSE,
                   "KP_PREV",             "N",                                    "KeyPop",       TRUE,
     "NEW_INFECTIONS_SUBNAT",             "N",                         "Age/Sex/HIVStatus",      FALSE,
               "OVC_HIVSTAT",             "N",                           "Total Numerator",      FALSE,
                  "OVC_SERV",             "N",                               "Placeholder",      FALSE,
                     "PLHIV",             "N",                         "Age/Sex/HIVStatus",      FALSE,
                 "PMTCT_ART",             "N",          "Age/Sex/NewExistingArt/HIVStatus",      FALSE,
          "PMTCT_ART_SUBNAT",             "D",                         "Age/Sex/HIVStatus",      FALSE,
          "PMTCT_ART_SUBNAT",             "N",          "Age/Sex/HIVStatus/NewExistingArt",      FALSE,
                 "PMTCT_EID",             "N",                                       "Age",      FALSE,
                "PMTCT_STAT",             "D",                                   "Age/Sex",      FALSE,
                "PMTCT_STAT",             "N",                    "Age/Sex/KnownNewResult",      FALSE,
         "PMTCT_STAT_SUBNAT",             "D",                                   "Age/Sex",      FALSE,
         "PMTCT_STAT_SUBNAT",             "N",                 "Age/Sex/KnownNewPosNewNeg",      FALSE,
                   "POP_EST",             "N",                                   "Age/Sex",      FALSE,
                   "PP_PREV",             "N",                                   "Age/Sex",      FALSE,
                   "PrEP_CT",             "N",                                   "Age/Sex",      FALSE,
        "PrEP_CT.TestResult",             "N",                         "Age/Sex/HIVStatus",      FALSE,
                   "PrEP_CT",             "N",                                    "KeyPop",       TRUE,
                 "PrEP_CURR",             "N",                                   "Age/Sex",      FALSE,
                 "PrEP_CURR",             "N",                                    "KeyPop",       TRUE,
                  "PrEP_NEW",             "N",                                   "Age/Sex",      FALSE,
                  "PrEP_NEW",             "N",                                 "KeyPopAbr",       TRUE,
                    "TB_ART",             "N",          "Age/Sex/NewExistingArt/HIVStatus",      FALSE,
                   "TB_PREV",             "D",          "Age/Sex/NewExistingArt/HIVStatus",      FALSE,
                   "TB_PREV",             "N",          "Age/Sex/NewExistingArt/HIVStatus",      FALSE,
                   "TB_STAT",             "D",                                   "Age/Sex",      FALSE,
                   "TB_STAT",             "N",                    "Age/Sex/KnownNewPosNeg",      FALSE,
                   "TX_CURR",             "N",                         "Age/Sex/HIVStatus",      FALSE,
                   "TX_CURR",             "N",                          "KeyPop/HIVStatus",       TRUE,
            "TX_CURR_SUBNAT",             "N",                         "Age/Sex/HIVStatus",      FALSE,
                    "TX_NEW",             "N",                         "Age/Sex/HIVStatus",      FALSE,
                    "TX_NEW",             "N",                          "KeyPop/HIVStatus",       TRUE,
                   "TX_PVLS",             "D",              "Age/Sex/Indication/HIVStatus",      FALSE,
                   "TX_PVLS",             "D",                          "KeyPop/HIVStatus",       TRUE,
                   "TX_PVLS",             "N",              "Age/Sex/Indication/HIVStatus",      FALSE,
                   "TX_PVLS",             "N",                          "KeyPop/HIVStatus",       TRUE,
                     "TX_TB",             "D", "Age/Sex/TBScreen/NewExistingART/HIVStatus",      FALSE,
     "VL_SUPPRESSION_SUBNAT",             "N",                         "Age/Sex/HIVStatus",      FALSE,
         "VL_TESTING_SUBNAT",             "N",                         "Age/Sex/HIVStatus",      FALSE,
                 "VMMC_CIRC",             "N",                         "Age/Sex/HIVStatus",      FALSE,
          "VMMC_CIRC_SUBNAT",             "N",                                   "Age/Sex",      FALSE,
     "VMMC_TOTALCIRC_SUBNAT",             "N",                                   "Age/Sex",      FALSE
     )


mer_disagg_mapping <- mer_disagg_mapping %>%
  dplyr::mutate(kp_disagg = stringr::str_detect(standardizeddisaggregate, "KeyPop"))


usethis::use_data(mer_disagg_mapping, overwrite = TRUE)

# create new historic mapping for FY24 onward


#add mer 2.7 disagg changes
mer_2_7_disagg <- tibble::tribble(
  ~indicator, ~numeratordenom, ~standardizeddisaggregate, ~fiscal_year, ~kp_disagg,
  "TX_NEW",     "N",           "Age/Sex/CD4/HIVStatus",   2024,        FALSE,
  "TX_PVLS", "N", "Age/Sex/HIVStatus", 2024, FALSE,
  "TX_PVLS", "D", "Age/Sex/HIVStatus", 2024, FALSE)

#bind old historic, new mapping, and mer 27 changes
mer_historic_disagg_mapping_2024 <- mer_disagg_mapping %>%
  mutate(fiscal_year = 2024) %>%
  relocate(kp_disagg, .after = fiscal_year) %>%
  rbind(msd_historic_disagg_mapping) %>%
  rbind(mer_2_7_disagg)

usethis::use_data(mer_historic_disagg_mapping_2024, overwrite = TRUE)

