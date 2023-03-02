#' Export Tidy PLHIV data from Target Setting Tool
#'
#' tame_plhiv is a sister function to tame_dp, which readings in the PLHIV data
#' from the Target Setting Tool and munging in into a tidy data frame to make it more usable to
#' interact with the data than the way it is stored in the Target Setting Tool. **Given
#' the changes to the Target Setting Tool each year, the function only works for the
#' current COP year, COP21.**
#'
#' @param filepath file path to the Target Setting Tool importing, must be .xlsx
#'
#' @export
#' @family primary
#'
#' @examplesIf FALSE
#' #DP file path
#'   path <- "../Downloads/DataPack_Jupiter_20200218.xlsx"
#' #read in Target Setting Tool
#'   df_plhiv <- tame_plhiv(path)

tame_plhiv <- function(filepath){

  df_plhiv <- tame_dp(filepath, type = "PLHIV")

  return(df_plhiv)
}
