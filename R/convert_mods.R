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
    dplyr::mutate(modality = dplyr::case_when(stringr::str_detect(indicator_code, "HTS_(TST|RECENT)") ~ indicator_code),
                  modality = stringr::str_extract(modality, "(?<=\\.)([:alpha:]|\\_|[:digit:])*(?=\\.)"),
                  modality = stringr::str_replace(modality, "Com", "Mod"),
                  modality = dplyr::recode(modality, "PMTCT_STAT" = "PMTCT ANC",
                                           "PostANC1" = "Post ANC1",
                                           "Other" = "OtherPITC"),
                  modality = dplyr::na_if(modality, "KP"))

  #create index modalities & rename HTS
  df_index <- df_mods %>%
    dplyr::filter(indicator %in% c("HTS_INDEX_COM", "HTS_INDEX_FAC")) %>%
    dplyr::mutate(modality = dplyr::case_when(
                              indicator == "HTS_INDEX_COM" ~ "IndexMod",
                              indicator == "HTS_INDEX_FAC" ~ "Index"),
                  otherdisaggregate = NA_character_,
                  indicator = "HTS_TST")

  #filter to indicators which feed into HTS_TST
  df_exmod <- df_mods %>%
    dplyr::filter(indicator %in% c("PMTCT_STAT", "TB_STAT", "VMMC_CIRC"),
                  numeratordenom == "N",
                  statushiv %in% c("Negative", "Positive"),
                  otherdisaggregate %in% c("NewNeg", "NewPos", NA))

  #convert -> map modality & change rest to match HTS_TST
  df_exmod <- df_exmod %>%
    dplyr::mutate(modality = dplyr::case_when(indicator == "VMMC_CIRC"  ~ "VMMC",
                                              indicator == "TB_STAT"    ~ "TBClinic",
                                              indicator == "PMTCT_STAT" ~ "PMTCT ANC"),
                  indicator = "HTS_TST",
                  otherdisaggregate = as.character(NA))

  #binding onto main data frame
  df_adj <- dplyr::bind_rows(df_mods, df_index, df_exmod)

  return(df_adj)
}

