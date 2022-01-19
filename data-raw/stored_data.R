## table of OUs to
ou_ctry_mapping <- glamr::pepfar_country_list %>%
  dplyr::select(operatingunit, countryname)

usethis::use_data(ou_ctry_mapping, overwrite = TRUE)



## table of indicators and their disaggs
mer_disagg_mapping <- tibble::tribble(
                 ~indicator, ~numeratordenom,                   ~standardizeddisaggregate,
                "AGYW_PREV",             "D",                       "Age/Sex/DREAMSBegun",
                "AGYW_PREV",             "N",             "Age/Sex/DREAMSPrimaryComplete",
                "CXCA_SCRN",             "N",                         "Age/Sex/HIVStatus",
         "DIAGNOSED_SUBNAT",             "N",                         "Age/Sex/HIVStatus",
                 "GEND_GBV",             "N",                       "ViolenceServiceType",
                 "HIV_PREV",             "N",                                   "Age/Sex",
            "HTS_INDEX_COM",             "N",                            "Age/Sex/Result",
            "HTS_INDEX_FAC",             "N",                            "Age/Sex/Result",
               "HTS_RECENT",             "N",                          "KeyPop/HIVStatus",
               "HTS_RECENT",             "N",                "Modality/Age/Sex/HIVStatus",
                 "HTS_SELF",             "N",                                   "Age/Sex",
                 "HTS_SELF",             "N",                                    "KeyPop",
                  "HTS_TST",             "N",                             "KeyPop/Result",
                  "HTS_TST",             "N",                   "Modality/Age/Sex/Result",
              "HTS_TST_POS",             "N",                             "KeyPop/Result",
              "HTS_TST_POS",             "N",                   "Modality/Age/Sex/Result",
                   "KP_MAT",             "N",                                       "Sex",
            "KP_MAT_SUBNAT",             "N",                                       "Sex",
                  "KP_PREV",             "N",                                    "KeyPop",
              "OVC_HIVSTAT",             "N",                           "Total Numerator",
                 "OVC_SERV",             "N",                            "Age/Sex/DREAMS",
                 "OVC_SERV",             "N",                        "Age/Sex/Preventive",
                 "OVC_SERV",             "N",                     "Age/Sex/ProgramStatus",
                    "PLHIV",             "N",                         "Age/Sex/HIVStatus",
                "PMTCT_ART",             "N",          "Age/NewExistingArt/Sex/HIVStatus",
         "PMTCT_ART_SUBNAT",             "D",                         "Age/Sex/HIVStatus",
         "PMTCT_ART_SUBNAT",             "N",          "Age/Sex/HIVStatus/NewExistingArt",
                "PMTCT_EID",             "N",                                       "Age",
               "PMTCT_STAT",             "D",                                   "Age/Sex",
               "PMTCT_STAT",             "N",                    "Age/Sex/KnownNewResult",
        "PMTCT_STAT_SUBNAT",             "D",                                   "Age/Sex",
        "PMTCT_STAT_SUBNAT",             "N",                 "Age/Sex/KnownNewPosNewNeg",
                  "POP_EST",             "N",                                   "Age/Sex",
                  "PP_PREV",             "N",                                   "Age/Sex",
                  "PREP_CT",             "N",                                   "Age/Sex",
                  "PREP_CT",             "N",                                    "KeyPop",
                "PREP_CURR",             "N",                                   "Age/Sex",
                "PREP_CURR",             "N",                                    "KeyPop",
                 "PREP_NEW",             "N",                                   "Age/Sex",
                 "PREP_NEW",             "N",                                    "KeyPop",
                   "TB_ART",             "N",          "Age/NewExistingArt/Sex/HIVStatus",
                  "TB_PREV",             "D",                                   "TB_PREV",
                  "TB_PREV",             "N",                                   "TB_PREV",
                  "TB_STAT",             "D",                    "Age/Sex/KnownNewPosNeg",
                  "TB_STAT",             "N",                    "Age/Sex/KnownNewPosNeg",
                  "TX_CURR",             "N",                         "Age/Sex/HIVStatus",
                  "TX_CURR",             "N",                          "KeyPop/HIVStatus",
           "TX_CURR_SUBNAT",             "N",                         "Age/Sex/HIVStatus",
                   "TX_NEW",             "N",                         "Age/Sex/HIVStatus",
                   "TX_NEW",             "N",                          "KeyPop/HIVStatus",
                  "TX_PVLS",             "D",              "Age/Sex/Indication/HIVStatus",
                  "TX_PVLS",             "D",                          "KeyPop/HIVStatus",
                  "TX_PVLS",             "N",              "Age/Sex/Indication/HIVStatus",
                  "TX_PVLS",             "N",                          "KeyPop/HIVStatus",
                    "TX_TB",             "D", "Age/Sex/TBScreen/NewExistingART/HIVStatus",
    "VL_SUPPRESSION_SUBNAT",             "N",                         "Age/Sex/HIVStatus",
        "VL_TESTING_SUBNAT",             "N",                         "Age/Sex/HIVStatus",
                "VMMC_CIRC",             "N",                         "Age/Sex/HIVStatus",
         "VMMC_CIRC_SUBNAT",             "N",                                   "Age/Sex",
    "VMMC_TOTALCIRC_SUBNAT",             "N",                                   "Age/Sex"
    )


mer_disagg_mapping <- mer_disagg_mapping %>%
  dplyr::mutate(kp_disagg = stringr::str_detect(standardizeddisaggregate, "KeyPop"))


usethis::use_data(mer_disagg_mapping, overwrite = TRUE)
