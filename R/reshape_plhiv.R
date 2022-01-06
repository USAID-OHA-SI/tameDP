#' Reshape PLHIV Data in Data Pack Long
#'
#' This function limits the columns from the Cascade tab to extract PLHIV data
#' and reshapes it long, so that it is more usable.
#'
#' @param df data frame from import_dp()
#' @family reshape
#' @export

reshape_plhiv <- function(df){

  #identify all key meta data columns to keep
  key_cols <- c("snu1",
                "psnu",
                "age",
                "sex",
                "pop_est.t_1",
                "plhiv.t_1",
                "hiv_prev.t_1",
                "tx_curr_subnat.t_1",
                "vl_suppressed.t_1")

  #check if all columns exist
  if(length(setdiff(key_cols, names(df))) > 0)
    stop(paste("Cascade tab is missing one or more columns:",
               paste(length(setdiff(key_cols, names(df))), collapse = ", ")))


  #limit columns to only those needed
  df <- dplyr::select(df, key_cols)

  #reshape long and remove blank rows
  df <- df %>%
    tidyr::pivot_longer(dplyr::ends_with("t_1"),
                        names_to = "indicator",
                        values_to = "targets",
                        values_transform = list(targets = as.numeric)) %>%
    dplyr::filter(targets != 0)

  #clean indicator and add FY
  df <- df %>%
    dplyr::mutate(fiscal_year = 2022,
                  indicator = indicator %>%
                    stringr::str_remove(".t_1") %>%
                    toupper %>%
                    dplyr::recode("VL_SUPPRESSED" = "VL_SUPPRESSION_SUBNAT"))

  #extract PSNU UID from PSNU column
  df <- split_psnu(df)

  return(df)

}
