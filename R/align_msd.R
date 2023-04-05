#' Align MSD extract to disaggregates in Target Setting Tool
#'
#' This function pulls in a PSNUxIM MSD and datapack filepath to align the MSD extract
#' to the indicators and disaggregates in the datapack, as well as historic results and targets.
#' This function also addresses when OUs set targets at a higher level than PSNU for alignment.
#'
#' @param msd_path path to PSNUxIM extract
#' @param dp_path path to TST
#' @param raised_prioritization logical that is TRUE if OU is setting targets at a raised prioritization level (i.e. SNU1 instead of PSNU)
#'
#' @export
#'
#' @examples
#'  \dontrun{
#'    df_msd <- align_msd_disagg(msd_path = msd_path, dp_path = dp_path, raised_prioritization = FALSE)
#' }
#'

align_msd_disagg <- function(msd_path, dp_path, raised_prioritization = FALSE) {

  #import MSD
  df_msd <- gophr::read_psd(msd_path) %>%
  gophr::resolve_knownissues()

  #run tameDP
  dp_cols <- tameDP::tame_dp(dp_path) %>%
    names()

  #if targets set at SNU1 level, grab the SNu1 and SNU1uid from MSD
  if (raised_prioritization == TRUE) {
    dp_cols <- replace(dp_cols, c(3,4), c("snu1", "snu1uid"))
  }

  #semi join with MSD mapping to limit to MSD disaggs
  df_align <- df_msd %>%
    dplyr::select(tidyr::any_of(dp_cols),funding_agency, mech_code) %>%
    dplyr::semi_join(msd_historic_disagg_mapping, by = c("indicator", "numeratordenom", "standardizeddisaggregate")) %>%
    gophr::clean_indicator()

  #if targets set at SNU1 level, rename SNU columsn back to psnu for join with dp
  if (raised_prioritization == TRUE) {
    df_align <- df_align %>%
      dplyr::rename(psnu = snu1,
                    psnuuid = snu1uid)
  }

  return(df_align)

}


#' Align MSD age bands to collapsed age bands in Target Setting Tool
#'
#' @param df dataframe from `align_msd_disagg` to pass through
#' @param collapse logical - if TRUE, summarizes across entire dataframe to collapse age bands.
#' If false, multiple observations with same age bands will occur. Note: if `collapse = TRUE`, processing speed will be long.
#'
#' @export
#'
#' @examples
#'  \dontrun{
#'    df_final <- align_ageband(df_align, collapse = FALSE)
#' }
#'
align_ageband <- function(df, collapse = FALSE) {


  #add collapsed age band crosswalk - collapsing takes a LONG time to run
  #VMMC 10-14 is NA
  #GEND_GBV is all NA
  #HTS, HTS_POS, HTS_INDEX, TB_ART,& TB_STAT are NA for <1
  #OVC_SERV, AGYW_PREV, PMTCT_EID, TB_PREV use ageasentered instead of collapsed age bands

  df_final <- df %>%
    dplyr::left_join(tameDP::age_band_crosswalk, by = c("ageasentered" = "age_msd")) %>%
    dplyr::mutate(age_dp = ifelse(indicator == "VMMC_CIRC" & ageasentered == "10-14", NA, age_dp)) %>%
    dplyr::mutate(age_dp = ifelse(indicator == "GEND_GBV", NA, age_dp)) %>%
    dplyr::mutate(age_dp = ifelse(indicator %in% c("HTS_TST", "HTS_TST_POS", "HTS_INDEX",
                                                   "TB_ART", "TB_STAT", "TB_STAT_D") & ageasentered == "<01", NA, age_dp)) %>%
    dplyr::mutate(age_dp = ifelse(indicator %in% c("OVC_SERV", "AGYW_PREV", "PMTCT_EID", "TB_PREV", "TB_PREV_D", "TX_TB_D"), ageasentered, age_dp)) %>%
    dplyr::select(-ageasentered) %>%
    dplyr::select(-c(funding_agency, mech_code)) %>%
    dplyr::relocate(age_dp, .after = 8) %>%
    dplyr::relocate(dplyr::any_of(c("cumulative", "targets")), .after = 13) %>%
    #relocate(funding_agency, .after = 15) %>%
    dplyr::rename(ageasentered = age_dp)

  if(collapse == TRUE) {

    df_final <- df_final %>%
      dplyr::group_by(dplyr::across(-c(cumulative, targets))) %>%
      # group_by_all() %>%
      # group_by(indicator, fiscal_year, standardizeddisaggregate, age_dp) %>%
      dplyr::summarise(dplyr::across(c(cumulative, targets), sum, na.rm = TRUE), .groups = "drop")

  }

  return(df_final)

}


