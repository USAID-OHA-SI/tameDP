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

  df_plhiv <- tame_dp(filepath, type = "PLHIV")

  return(df_plhiv)
}
