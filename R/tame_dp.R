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

  #aggregate output to IM or PSNU level
  df_dp <- agg_dp(df_dp, psnu_lvl)

  #break out indicatorcode variable
  df_dp <- clean_indicators(df_dp)

  #add names from DATIM
  if(map_names == TRUE && psnu_lvl == FALSE){
    df_dp <- get_names(df_dp)
  } else {
    ou <- grab_ou(filepath)
    df_dp <- df_dp %>%
      dplyr::mutate(operatingunit = ou) %>%
      dplyr::select(operatingunit, dplyr::everything())
  }

  #order variables for output
  df_dp <- order_vars(df_dp)

  return(df_dp)
}
