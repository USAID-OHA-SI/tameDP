#' Join TST output with MSD output
#'
#' Deprecated! See `tame_join`.
#'
#' @param dp_filepath file path to the Target Setting Tool importing, must be .xlsx
#' @param msd_filepath filepath to the latest PSNUxIM MSD for corresponding OU
#' @param fy_as_str should FY be converted to a string (2025 > FY25) for
#'   Tableau? (default = TRUE)
#' @param map_names import names from DATIM (OU, mechanism, partner) associated
#'   with mech_code when working with PSNUxIM (default = FALSE)
#'
#' @return dataframe that combines targets from the TST with corresponding
#'   historic results/targets from MSD
#' @export
#'
#' @examplesIf FALSE
#' #DP file path
#'   tst_path <- "../Downloads/DataPack_Jupiter_20500101.xlsx"
#' # MSD filepath
#'  msd_path <- "../Data/MER_Structured_TRAINING_Datasets_PSNU_IM_FY59-61_20240215_v1_1.zip"
#'
#' #run join function (depricated)
#'   df_join <- join_dp_msd(tst_path, msd_path)

join_dp_msd <- function(dp_filepath, msd_filepath,
                        fy_as_str = TRUE, map_names = FALSE) {

  #deprecate
  lifecycle::deprecate_warn("6.2.4", "join_dp_msd()", "tame_join()")

  tame_join(dp_filepath, msd_filepath,fy_as_str, map_names)

}


#' Join TST output with MSD output
#'
#' @param tst_filepath file path to the Target Setting Tool importing, must be .xlsx
#' @param msd_filepath filepath to the latest PSNUxIM MSD for corresponding OU
#' @param fy_as_str should FY be converted to a string (2025 > FY25) for
#'   Tableau? (default = TRUE)
#' @param map_names import names from DATIM (OU, mechanism, partner) associated
#'   with mech_code when working with PSNUxIM (default = FALSE)
#'
#' @return dataframe that combines targets from the TST with corresponding
#'   historic results/targets from MSD
#' @export
#'
#' @examplesIf FALSE
#' #TST file path
#'   tst_path <- "../Downloads/DataPack_Jupiter_20500101.xlsx"
#' # MSD filepath
#'   msd_path <- "../Data/MER_Structured_TRAINING_Datasets_PSNU_IM_FY59-61_20240215_v1_1.zip"
#'
#' #run join function
#'   df_join <- tame_join(tst_path, msd_path)
#'
#' #run join function without converting the fiscal year to a string (used in Tableau)
#'   df_join <- tame_join(tst_path, msd_path, fy_as_str = FALSE)
#'
#' #run join function with PSNUxIM & map on mechanism info to TST dataframe
#'   df_join <- tame_join(tst_path, msd_path, map_names = TRUE)
#'
tame_join <- function(tst_filepath, msd_filepath,
                        fy_as_str = TRUE, map_names = FALSE) {

  #grab year of TST
  fy <- grab_info(dp_filepath, "year")

  #import TST
  dp <- suppressWarnings(
    tame_dp(dp_filepath, map_names = map_names) %>%
      dplyr::filter(fiscal_year == fy)
  )

  #join SUNBAT data if not a PSNUxIM dataset
  if(!"PSNUxIM" %in% readxl::excel_sheets(dp_filepath)){
    dp_plhiv <- tame_dp(dp_filepath, type = 'PLHIV') %>%
      dplyr::mutate(standardizeddisaggregate = ifelse(indicator == "PLHIV_Residents", "Age/Sex/HIVStatus", standardizeddisaggregate)) %>%
      dplyr::mutate(indicator = ifelse(indicator == "PLHIV_Residents", "PLHIV", indicator))

    dp <- dplyr::bind_rows(dp, dp_plhiv)
  }

  #munge TST
  dp_final <- dp %>%
    dplyr::mutate(snuprioritization = stringr::str_replace(snuprioritization, "up", "Up")) %>%
    gophr::clean_indicator()

  #munge MSD and align to TST names and disaggs
  msd_final <- align_msd_disagg(msd_filepath) %>%
    dplyr::select(tidyr::any_of(names(dp)))

  # BIND together
  df_final <- dplyr::bind_rows(dp_final, msd_final)

  #covert fy to string if desired
  if(fy_as_str == TRUE){
    df_final <- dp_final %>%
      dplyr::mutate(fiscal_year = stringr::str_replace(fiscal_year, "20", "FY"))
  }

  return(df_final)

}
