#' Import SNUxIM data from Data Pack and Clean
#'
#' @param filepath file path to the Data Pack importing, must be .xls
#' @param map_names import names from DATIM (OU, mechanism, partner) associated with mechid
#'
#' @export
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' #DP file path
#'   path <- "C:/Users/achafetz/Downloads/DataPack_Malawi_02062019.xls"
#' #read in data pack
#'   df_dp <- tame_dp(path) }


tame_dp <- function(filepath, map_names = TRUE){

  #import Data Pack and convert to lower
  df_dp <- import_dp(filepath)

  #refine columns and reshape
  df_dp <- reshape_dp(df_dp)

  #break out indicatorcode variable
  df_dp <- clean_indicators(df_dp)

  #add names from DATIM
  if(map_names == TRUE)
    df_dp <- get_names(df_dp)

  return(df_dp)
}
