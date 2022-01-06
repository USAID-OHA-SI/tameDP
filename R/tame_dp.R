#' Import PSNUxIM data from Data Pack and Clean
#'
#' tame_dp is the primary function of the tameDP package, reading in the Data
#' Pack and munging in into a tidy data frame to make it more usable to
#' interact with the data than the way it is stored in the Data Pack. **Given
#' the changes to the Data Pack each year, the function only works for the
#' current COP year, COP21.**
#'
#' The main function of `tameDP` is to bring import a COP20 Data Pack into R
#' and make it tidy. The function aggregates the COP targets up to the
#' mechanism level, imports the mechanism information from DATIM, and breaks
#' out the data elements to make the dataset more usable.
#'
#'   - Imports Data Pack as tidy data frame
#'   - Breaks up data elements stored in the indicatorCode column into distinct columns
#'   - Cleans up the HTS variables, separating modalities out of the indicator name
#'   - Creates a statushiv column
#'   - Cleans and separates PSNU and PSNU UID into distinct columns
#'   - Adds in mechanism information from DATIM, including operatingunit, funding agency, partner and mechanism name
#'   - Removes any rows with no targets
#'   - Allows for aggregate to the PSNU level
#'
#' @param filepath file path to the Data Pack importing, must be .xlsx
#' @param map_names import names from DATIM (OU, mechanism, partner) associated with mech_code
#' @param psnu_lvl aggregate to the PSNU level instead of IM
#'
#' @export
#' @family primary
#'
#' @examplesIf FALSE
#' #DP file path
#'   path <- "../Downloads/DataPack_Jupiter_20200218.xlsx"
#' #read in data pack
#'   df_dp <- tame_dp(path)


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

  #identify country (if not pulling from DATIM)
  cntry <- grab_cntry(filepath)

  #add names from DATIM
  df_dp <- get_names(df_dp, map_names, psnu_lvl, cntry)

  #order variables for output
  df_dp <- order_vars(df_dp)

  #apply variable class
  df_dp <- apply_class(df_dp)

  return(df_dp)
}
