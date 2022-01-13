#' Clean Up Indicators and Disaggregates
#'
#' The indicator and disaggregates used in the Data Pack skew towards machine readable
#' and do not necessary match the MER indicators in the MSD/DATIM. This function
#' makes adjustments to indicators and disaggregates to make them easier to work
#' with and more closely align to the MSD. This function also uses
#' `convert_mods()`, which creates the testing modalities that match the MSD and
#' create new HTS_TST and HTS_TST_POS indicator from indicator that feed into
#' them (eg HTS_INDEX, TB_STAT, PMTCT_STAT, VMMC_CIRC).
#'
#' @param df data frame to adjust
#'
#' @export

clean_indicators <- function(df){

  #extract disagg info from indicator_code
  df <- df %>%
    dplyr::mutate(
      indicator_code = stringr::str_remove(indicator_code, "\\.(T_1|T)$"),
      indicator = stringr::str_extract(indicator_code, "[^\\.]+") %>% toupper,
      indicator = dplyr::recode(indicator, "VL_SUPPRESSED" = "VL_SUPPRESSION_SUBNAT"),
      numeratordenom = ifelse(stringr::str_detect(indicator_code, "\\.D\\.|\\.D$"), "D", "N"),
      statushiv = stringr::str_extract(indicator_code, "(Neg|Pos|Unk)$"),
      statushiv = dplyr::recode(statushiv, "Neg" = "Negative" , "Pos" = "Positive", "Unk" = "Unknown"),
      ageasentered = dplyr::case_when(stringr::str_detect(indicator_code, "12") ~ "02 - 12 Months",
                                      stringr::str_detect(indicator_code, "\\.2") ~ "<=02 Months",
                                      TRUE ~ age),
      otherdisaggregate =
        stringr::str_extract(indicator_code,
                             "(Act|Grad|Prev|DREAMS|Already|New\\.Neg|New\\.Pos|New|KnownNeg|KnownPos|Known.Pos|Routine|\\.S(?=\\.)|\\.S$|PE)") %>%
        stringr::str_remove("\\.")
      )

  #map on standardizeddisaggregate
  df <- map_disaggs(df)

  #convert external modalities
  df <- convert_mods(df)

  #add HTS_TST_POS as an indicator
  df <- df %>%
    dplyr::bind_rows(df %>%
                       dplyr::filter(indicator == "HTS_TST" & statushiv == "Positive") %>%
                       dplyr::mutate(indicator = "HTS_TST_POS"))

  #move keypop to otherdisagg
  df <- df %>%
    dplyr::mutate(otherdisaggregate = ifelse(kp_disagg == TRUE, keypop, otherdisaggregate)) %>%
    dplyr::select(-dplyr::matches("keypop|kp_disagg"))

  #rename HTS_INDEX
  df <- df %>%
    dplyr::mutate(indicator = ifelse(stringr::str_detect(indicator, "HTS_INDEX"), "HTS_INDEX", indicator))

  #drop indicator code
  df <- dplyr::select(df, -indicator_code)

  #move targets to end
  df <- dplyr::select(df, -targets, dplyr::everything())

  return(df)
}
