#' Reshape Data Pack Tab Long
#'
#' This function limits the columns from a target tab (non PSNUxIM) to extract
#' data and reshapes it long, so that it is tidy and more usable. This function
#' also splits out the PSNU uid from the PSNU column.
#'
#' @param df data frame from import_dp()
#' @family reshape
#' @export

reshape_tab <- function(df){

  #reshape long and remove blank rows
  df <- df %>%
    tidyr::pivot_longer(dplyr::matches("(t|t_1)$"),
                        names_to = "indicator",
                        values_to = "targets",
                        values_drop_na = TRUE,
                        values_transform = list(targets = as.numeric)) %>%
    dplyr::filter(targets != 0)

  #clean indicator
  df <- df %>%
    dplyr::mutate(indicator = indicator %>%
                    stringr::str_remove(".t_1") %>%
                    toupper %>%
                    dplyr::recode("VL_SUPPRESSED" = "VL_SUPPRESSION_SUBNAT"))

  #extract PSNU UID from PSNU column
  df <- split_psnu(df)

  return(df)

}
