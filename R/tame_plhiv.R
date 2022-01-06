#' Tidy PLHIV data from Data Pack
#'
#' tame_plhiv is a sister function to tame_dp, which readings in the PLHIV data
#' from the Data Pack and munging in into a tidy data frame to make it more usable to
#' interact with the data than the way it is stored in the Data Pack. **Given
#' the changes to the Data Pack each year, the function only works for the
#' current COP year, COP21.**
#'
#' @param filepath file path to the Data Pack importing, must be .xlsx
#'
#' @export
#' @family primary
#'
#' @examplesIf FALSE
#' #DP file path
#'   path <- "../Downloads/DataPack_Jupiter_20200218.xlsx"
#' #read in data pack
#'   df_plhiv <- tame_plhiv(path)

tame_plhiv <- function(filepath){

  #import Data Pack and convert to lower
  df_plhiv <- import_dp(filepath, tab = "Cascade")

  #refine columns and reshape
  df_plhiv <- reshape_plhiv(df_plhiv)

  #identify country and FY
  cntry <- grab_info(filepath, "country")
  fy <- grab_info(filepath, "year")

  #add country name and fiscal year and reorder
  df_plhiv <- df_plhiv %>%
    dplyr::mutate(countryname = cntry,
                  fiscal_year = fy) %>%
    dplyr::relocate(countryname, .before = 1) %>%
    dplyr::relocate(fiscal_year, indicator, .before = "age")

  return(df_plhiv)
}
