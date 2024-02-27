#' Clean Up Indicators and Disaggregates
#'
#' The indicator and disaggregates used in the Target Setting Tool skew towards machine readable
#' and do not necessary match the MER indicators in the MSD/DATIM. This function
#' makes adjustments to indicators and disaggregates to make them easier to work
#' with and more closely align to the MSD. This function also uses
#' `convert_mods()`, which creates the testing modalities that match the MSD and
#' create new HTS_TST and HTS_TST_POS indicator from indicator that feed into
#' them (eg HTS_INDEX, TB_STAT, PMTCT_STAT, VMMC_CIRC).
#'
#' @param df data frame to adjust
#' @param fy fiscal year for targeting
#'
#' @export

clean_indicators <- function(df, fy){

  #extract disagg info from indicator_code
  df <- df %>%
    dplyr::mutate(
      indicator_code = indicator_code %>%
        stringr::str_remove("\\.(T_1|T|T2|R)$") %>%
        stringr::str_replace("HTS.Index", "HTS_INDEX"),
      indicator = indicator_code %>%
        stringr::str_extract("[^\\.]+") %>%
        dplyr::recode("VL_SUPPRESSED" = "VL_SUPPRESSION_SUBNAT"),
      indicator = ifelse(indicator_code == "PrEP_CT.TestResult", indicator_code, indicator),
      numeratordenom = ifelse(stringr::str_detect(indicator_code, "\\.D\\.|\\.D$"), "D", "N"),
      statushiv = stringr::str_extract(indicator_code, "(Neg|Pos|Unk)$"),
      statushiv = ifelse(indicator == "PrEP_CT.TestResult", "Neg", statushiv),
      ageasentered = stringr::str_extract(indicator_code, "(?<=\\.)[:digit:]+"),
      ind_exclude = paste(indicator, "\\.(N|D)\\.|\\.(N|D)$", paste0(statushiv, "$"), ageasentered, "\\.", sep = "|") %>% stringr::str_remove_all("\\|NA"),
      otherdisaggregate = indicator_code %>%
        stringr::str_remove_all(glue::glue("{ind_exclude}")) %>%
        dplyr::na_if(""),
      otherdisaggregate = ifelse(!is.na(statushiv) & statushiv == otherdisaggregate, NA, otherdisaggregate),
      ageasentered = dplyr::case_when(ageasentered == "12" ~ "02 - 12 Months",
                                      ageasentered == "2" ~ "<=02 Months",
                                      TRUE ~ age),
      target_age_2024 = ifelse(ageasentered %in% c("<=02 Months", "02 - 12 Months"),
                               "<01", ageasentered),
      statushiv = dplyr::recode(statushiv, "Neg" = "Negative" , "Pos" = "Positive", "Unk" = "Unknown")
    ) %>%
    dplyr::select(-ind_exclude)

  #map on standardizeddisaggregate
  df <- map_disaggs(df)

  #convert external modalities
  df <- convert_mods(df)

  #add calculated indicators (HTS_TST_POS, OVC_HIVSTAT_D, PMTCT_STAT_POS, PMTCT_ART)
  df <- calculate_inds(df)

  #add trendscoarse
  df <- align_agecoarse(df)

  #move keypop to otherdisagg
  df <- df %>%
    dplyr::mutate(otherdisaggregate = ifelse(kp_disagg == TRUE, keypop,
                                             otherdisaggregate)) %>%
    dplyr::select(-dplyr::matches("keypop|kp_disagg"))

  #drop indicator code
  df <- dplyr::select(df, -indicator_code)

  #drop prior year OVC_SERV (aggregates disaggs) & TB_STAT (N only included POS)
  df <- df %>%
    dplyr::filter(!(indicator %in% c("OVC_SERV", "TB_STAT") &
                      numeratordenom == "N" &
                      fiscal_year != fy))

  #move targets (and cumulative) to end
  df <- dplyr::relocate(df, dplyr::matches("cumulative|targets"),
                        .after = dplyr::last_col())

  return(df)
}
