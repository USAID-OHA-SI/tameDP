
#' Join TST output with MSD output
#'
#' @param dp_filepath file path to the Target Setting Tool importing, must be .xlsx
#' @param msd_filepath filepath to the latest PSNUxIM MSD for corresponding OU
#'
#' @return dataframe that combines targets from the TST with corresponding historic results/targets from MSD
#' @export
#'
#' @examplesIf FALSE
#' #DP file path
#'   tst_path <- "../Downloads/DataPack_Jupiter_20500101.xlsx"
#' # MSD filepath
#'  msd_path <- "../Data/MER_Structured_TRAINING_Datasets_PSNU_IM_FY59-61_20240215_v1_1.zip"
#'
#' #run join function
#'   df_join <- join_dp_msd(tst_path, msd_path)

join_dp_msd <- function(dp_filepath, msd_filepath) {

  #grab year of TST
  fy <- grab_info(dp_filepath, "year")

  #import TST
  dp <- tame_dp(dp_filepath) %>% dplyr::filter(fiscal_year == fy)
  dp_plhiv <- tame_dp(dp_filepath, type = 'PLHIV')

  #munge TST
  dp_final <- dp %>%
    dplyr::bind_rows(dp_plhiv) %>%
    dplyr::mutate(standardizeddisaggregate = ifelse(indicator == "PLHIV_Residents", "Age/Sex/HIVStatus", standardizeddisaggregate)) %>%
    dplyr::mutate(indicator = ifelse(indicator == "PLHIV_Residents", "PLHIV", indicator)) %>%
    dplyr::mutate(snuprioritization = dplyr::recode(snuprioritization,
                                                    "2 - Scale-up: Aggressive" = "2 - Scale-Up: Aggressive",
                                                    "1 - Scale-up: Saturation" = "1 - Scale-Up: Saturation")) %>%
    gophr::clean_indicator()

  #munge MSD and align to TST names and disaggs
  msd_final <- align_msd_disagg(msd_filepath, dp_filepath, FALSE)

  # BIND together
  df_final <- dplyr::bind_rows(dp_final %>% dplyr::select(-c(source_processed)), msd_final) %>%
    dplyr::mutate(fiscal_year = as.character(fiscal_year)) %>%
    dplyr::mutate(fiscal_year = stringr::str_replace(fiscal_year, "20", "FY"))

  return(df_final)

}
