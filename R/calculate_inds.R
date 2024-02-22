#' Add Calculated Indicators
#'
#' A series of indicators are created from other indicators. This function adds
#' the following calculated indicators - HTS_TST_POS, OVC_HIVSTAT_D,
#' PMTCT_STAT_POS, PMTCT_ART.
#'
#' @param df dataframe from clean_indicators
#'
#' @keywords internal

calculate_inds <- function(df){

  #calculate HTS_TST_POS
  df <- df %>%
    dplyr::bind_rows(df %>%
                       dplyr::filter(indicator == "HTS_TST" & statushiv == "Positive") %>%
                       dplyr::mutate(indicator = "HTS_TST_POS"))

  #add OVC_HIVSTAT_D as an indicator
  df <- df %>%
    dplyr::bind_rows(df %>%
                       dplyr::filter(otherdisaggregate %in% c("Active", "Graduated"),
                                     !ageasentered %in% c("18-20","18+")) %>%
                       dplyr::mutate(indicator == "OVC_HIVSTAT",
                                     numeratordenom = "D",
                                     standardizeddisaggregate = "Total Denominator",
                                     otherdisaggregate = NA_character_))

  #add PMTCT_POS as an indicator
  df <- df %>%
    dplyr::bind_rows(df %>%
                       dplyr::filter(indicator == "PMTCT_STAT" & statushiv == "Positive") %>%
                       dplyr::mutate(indicator = "PMTCT_STAT_POS"))

  #add PMTCT_ART_D as an indicator
  df <- df %>%
    dplyr::bind_rows(df %>%
                       dplyr::filter(indicator == "PMTCT_STAT_POS") %>%
                       dplyr::mutate(indicator = "PMTCT_ART",
                                     numeratordenom = "D"))
  return(df)
}
