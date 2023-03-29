#' Duplicate and convert modalities to HTS_TST
#'
#' This function matches the testing modalities from the MSD and
#' create new HTS_TST and HTS_TST_POS indicator from indicator that feed into
#' them (eg HTS_INDEX, TB_STAT, PMTCT_STAT, VMMC_CIRC).
#'
#' @param df data frame
#'
#' @export

convert_mods <- function(df){

  #create modalities
  df_mods <- df %>%
    dplyr::mutate(modality =  dplyr::case_when(stringr::str_detect(indicator_code, "HTS_(TST|RECENT)") ~ indicator_code) %>%
                    stringr::str_extract("(?<=\\.)([:alpha:]|\\_|[:digit:])*(?=\\.)") %>%
                    stringr::str_replace("Com", "Mod") %>%
                    dplyr::na_if("KP"))

  #align modality naming
  df_mods <- df_mods %>%
    dplyr::mutate(modality = dplyr::recode(modality,
                                           "ActiveOther" = "ActiveOtherMod",
                                           "PostANC1" = "Post ANC1",
                                           "STI" = "STI Clinic"),
                  otherdisaggregate = ifelse(standardizeddisaggregate == "Modality/Age/Sex/Result", NA, otherdisaggregate))

  #create index modalities & rename HTS
  df_index <- df_mods %>%
    dplyr::filter(indicator == "HTS_INDEX") %>%
    dplyr::mutate(modality = "Index",
                  standardizeddisaggregate = "Modality/Age/Sex/Result",
                  otherdisaggregate = NA_character_,
                  indicator = "HTS_TST")

  #filter to indicators which feed into HTS_TST
  df_exmod <- df_mods %>%
    dplyr::filter(indicator %in% c("PMTCT_STAT", "TB_STAT", "VMMC_CIRC", "PrEP_CT"),
                  numeratordenom == "N",
                  statushiv %in% c("Negative", "Positive"),
                  otherdisaggregate %in% c("New", NA))

  #convert -> map modality & change rest to match HTS_TST
  df_exmod <- df_exmod %>%
    dplyr::mutate(modality = dplyr::case_when(indicator == "VMMC_CIRC"  ~ "VMMC",
                                              indicator == "TB_STAT"    ~ "TBClinic",
                                              indicator == "PMTCT_STAT" ~ "PMTCT ANC",
                                              indicator == "PrEP_CT" ~ "PrEP_CT"),
                  indicator = "HTS_TST",
                  standardizeddisaggregate = "Modality/Age/Sex/Result",
                  otherdisaggregate = as.character(NA))

  #binding onto main data frame
  df_adj <- dplyr::bind_rows(df_mods, df_index, df_exmod)

  #remove partial historic HTS data appearing for TB
  df_adj <- df_adj %>%
    dplyr::filter(!c(fiscal_year != max(fiscal_year) &
                      standardizeddisaggregate == "Modality/Age/Sex/Result"))

  return(df_adj)
}

