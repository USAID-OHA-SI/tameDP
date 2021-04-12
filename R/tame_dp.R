#' Import SNUxIM data from Data Pack and Clean
#'
#' @param filepath file path to the Data Pack importing, must be .xlsx
#' @param map_names import names from DATIM (OU, mechanism, partner) associated with mech_code
#' @param psnu_lvl aggregate to the PSNU level instead of IM
#'
#' @export
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' #DP file path
#'   path <- "../Downloads/DataPack_Jupiter_20200218.xlsx"
#' #read in data pack
#'   df_dp <- tame_dp(path) }


tame_dp <- function(filepath, map_names = TRUE, psnu_lvl = FALSE){

  #import Data Pack and convert to lower
  df_dp <- import_dp(filepath)

  #refine columns and reshape
  df_dp <- reshape_dp(df_dp)

  #convert dedup to negative values
  df_dp <- convert_dedups(df_dp)

  #aggregate output to IM or PSNU level
  df_dp <- agg_dp(df_dp, psnu_lvl)

  #break out indicatorcode variable
  df_dp <- clean_indicators(df_dp)

  #identify OU (if not pulling from DATIM)
  ou <- grab_ou(filepath)

  #add names from DATIM
  df_dp <- get_names(df_dp, map_names, psnu_lvl, ou)

  #order variables for output
  df_dp <- order_vars(df_dp)

  #apply variable class
  df_dp <- apply_class(df_dp)

  return(df_dp)
}
