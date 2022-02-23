#' Export Tidy data from Data Pack
#'
#' tame_dp is the primary function of the tameDP package, reading in the Data
#' Pack and munging in into a tidy data frame to make it more usable to
#' interact with the data than the way it is stored in the Data Pack. **Given
#' the changes to the Data Pack each year, the function only works for the
#' current COP year, COP22.**
#'
#' The main function of `tameDP` is to bring import a COP Data Pack into R
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
#' @param type dataset to extract "PSNUxIM", "PLHIV", or "ALL" (default) or a specific tab
#' @param map_names import names from DATIM (OU, mechanism, partner) associated with mech_code
#' @param psnu_lvl aggregate to the PSNU level instead of IM
#'
#' @export
#' @family primary
#'
#' @examplesIf FALSE
#' #DP file path
#'   path <- "../Downloads/DataPack_Jupiter_20500101.xlsx"
#' #read in data pack (straight from sheets, not PSNUxIM tab)
#'   df_dp <- tame_dp(path)
#' #read in PLHIV/SUBNAT data
#'   df_dp <- tame_dp(path, type = "PLHIV")
#' #read in PSNUxIM data
#'   df_dp <- tame_dp(path, type = "PSNUxIM")
#' #apply mechanism names
#'   df_dp_named <- tame_dp(path, type = "PSNUxIM", map_names = TRUE)
#' #aggregate to the PSNU level
#'   df_dp_psnu <- tame_dp(path, type = "PSNUxIM", psnu_lvl = TRUE)
#' #reading in multiple files and then applying mechanism names (for PSNUxIM)
#'   df_all <- map_dfr(.x = list.files("../Downloads/DataPacks", full.names = TRUE),
#'                     .f = ~ tame_dp(.x, map_names = FALSE))
#'   df_all <- get_names(df_all)


tame_dp <- function(filepath, type = "ALL",
                    map_names = FALSE, psnu_lvl = FALSE){

  #identify tabs to import based on output type
  import_tabs <- return_tab(type) %>%
    intersect(readxl::excel_sheets(filepath))

  #import Data Pack, refine columns and reshape
  df_dp <- purrr::map_dfr(import_tabs,
                          ~import_dp(filepath, .x) %>%
                            reshape_dp())

  #grab and apply FY
  fy <- grab_info(filepath, "year")
  df_dp <- apply_fy(df_dp, fy)

  #include/exclude PLHIV/SUBNAT as desired
  df_dp <- limit_datatype(df_dp, type)

  #convert dedup to negative values
  df_dp <- convert_dedups(df_dp)

  #aggregate output to IM or PSNU level
  df_dp <- agg_dp(df_dp, psnu_lvl)

  #split out cumulative from targets
  df_dp <- pivot_results(df_dp)

  #break out indicatorcode variable
  df_dp <- clean_indicators(df_dp)

  #identify country (if not pulling from DATIM)
  cntry <- grab_info(filepath, "country")

  #add names from DATIM
  df_dp <- get_names(df_dp, map_names, psnu_lvl, cntry)

  #order variables for output
  df_dp <- order_vars(df_dp)

  #apply variable class
  df_dp <- apply_class(df_dp)

  return(df_dp)
}
