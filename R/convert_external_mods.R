#' Duplicate and convert external modalities to HTS_TST
#'
#' @param df data frame
#'
#' @export
#' @importFrom magrittr %>%

convert_external_mods <- function(df){

  #create modalities & rename HTS
  df_index <- df %>%
    dplyr::filter(indicator %in% c("HTS_INDEX_COM", "HTS_INDEX_FAC")) %>%
    dplyr::mutate(modality = dplyr::case_when(
      indicator == "HTS_INDEX_COM" ~ "IndexMod",
      indicator == "HTS_INDEX_FAC" ~ "Index",
      stringr::str_detect(indicator, "HTS_TST.") ~
        stringr::str_remove(indicator, "HTS_TST_")),
      indicator = ifelse(stringr::str_detect(indicator, "HTS_(TST|INDEX)."), "HTS_TST", indicator))

  #filter to indicators which feed into HTS_TST
  df_exmod <- df %>%
    dplyr::filter(indicator %in% c("PMTCT_STAT", "TB_STAT", "VMMC_CIRC"),
                  resultstatus %in% c("Negative", "Positive"),
                  otherdisaggregate %in% c("NewNeg", "NewPos", NA))

  #convert -> map modality & change rest to match HTS_TST
  df_exmod <- df_exmod %>%
    dplyr::mutate(modality = case_when(indicator == "VMMC_CIRC"  ~ "VMMC",
                                       indicator == "TB_STAT"    ~ "TBClinic",
                                       indicator == "PMTCT_STAT" ~ "PMTCT ANC"),
                  indicator = "HTS_TST",
                  disaggregate = "Age/Sex/Result",
                  otherdisaggregate = as.character(NA))

  #binding onto main data frame
  df <- dplyr::bind_rows(df, df_index, df_exmod)

  return(df)
}

