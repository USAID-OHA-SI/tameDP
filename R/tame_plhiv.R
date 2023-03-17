#' Export Tidy PLHIV data from Target Setting Tool
#'
#' Deprecated. Use `tame_subnat` instead.
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
#'   df_subnat <- tame_subnat(path)

tame_plhiv <- function(filepath){

  #depricate
  lifecycle::deprecate_warn("3.2.0", "tame_plhiv()", "tame_subnat()")

  df_subnat <- tame_dp(filepath, type = "SUBNAT")

  return(df_subnat)
}


#' Export Tidy SUBNAT data from Target Setting Tool
#'
#' tame_subnat is a sister function to tame_dp, which readings in the SUBNAT and
#'  PLHIV data from the Target Setting Tool and munging in into a tidy data
#'  frame to make it more usable to interact with the data than the way it is
#'  stored in the Target Setting Tool. **Given the changes to the Target
#'  Setting Tool each year, the function only works going back to COP21.**
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
#'   df_subnat <- tame_subnat(path)

tame_subnat <- function(filepath){

  df_subnat <- tame_dp(filepath, type = "SUBNAT")

  return(df_subnat)
}
