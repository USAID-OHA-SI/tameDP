
#' Prepare TST tameDP output for join with MSD
#'
#' @param dp_filepath TST filepath
#'
#' @return
#' @export
#'
#' @examples
#'
prep_dp <- function(dp_filepath) {

  dp <- tame_dp(dp_filepath)
  dp_plhiv <- tame_dp(dp_filepath, type = 'PLHIV')

  # filter DP, join PSNU map and mutate FY; filter to only 2024 targets
  dp_filtered <- dp %>%
    gophr::clean_indicator() %>%
    dplyr::filter(fiscal_year == 2025) %>%
    #dplyr::select(-c(country)) %>%
    dplyr::mutate(fiscal_year = as.character(fiscal_year)) %>%
    dplyr::mutate(fiscal_year = stringr::str_replace(fiscal_year, "20", "FY"))

  # filter PLHIV tab of dp and do the same munging
  dp_plhiv_filtered <- dp_plhiv %>%
    gophr::clean_indicator() %>%
    #dplyr::select(-c(country)) %>%
    dplyr::mutate(fiscal_year = as.character(fiscal_year)) %>%
    dplyr::mutate(fiscal_year = stringr::str_replace(fiscal_year, "20", "FY")) %>%
    dplyr::mutate(standardizeddisaggregate = ifelse(indicator == "PLHIV_Residents", "Age/Sex/HIVStatus", standardizeddisaggregate)) %>%
    dplyr::mutate(indicator = ifelse(indicator == "PLHIV_Residents", "PLHIV", indicator))

  #bind plhiv and all tabs for import into Tableau
  dp_final <- dplyr::bind_rows(dp_filtered, dp_plhiv_filtered)

  #recode snuprioritization
  dp_final <- dp_final %>%
    dplyr::mutate(snuprioritization = dplyr::recode(snuprioritization,
                                      "2 - Scale-up: Aggressive" = "2 - Scale-Up: Aggressive",
                                      "1 - Scale-up: Saturation" = "1 - Scale-Up: Saturation"))

  return(dp_final)

}

#' Join TST output with MSD output
#'
#' @param dp_filepath
#' @param msd_filepath
#'
#' @return
#' @export
#'
#' @examples
join_dp_msd <- function(dp_filepath, msd_filepath) {

  df_test <- prep_dp(dp_filepath = dp_filepath)

  msd_final <- align_msd_disagg(msd_filepath, dp_filepath, FALSE) %>%
    dplyr::mutate(fiscal_year = as.character(fiscal_year)) %>%
    dplyr::mutate(fiscal_year = stringr::str_replace(fiscal_year, "20", "FY")) %>%
    dplyr::select(-c(funding_agency, mech_code))

  # BIND together
  df_final <- dplyr::bind_rows(df_test %>% dplyr::select(-c(source_processed)), msd_final)

  return(df_final)

}
