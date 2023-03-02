#' Export Tidy data from Target Setting Tool
#'
#' tame_dp is the primary function of the tameDP package, reading in the Data
#' Pack and munging in into a tidy data frame to make it more usable to
#' interact with the data than the way it is stored in the Target Setting Tool. **Given
#' the changes to the Target Setting Tool each year, the function only works for the
#' current COP year, COP22.**
#'
#' The main function of `tameDP` is to bring import a COP Target Setting Tool into R
#' and make it tidy. The function aggregates the COP targets up to the
#' mechanism level, imports the mechanism information from DATIM, and breaks
#' out the data elements to make the dataset more usable.
#'
#'   - Imports Target Setting Tool as tidy data frame
#'   - Breaks up data elements stored in the indicatorCode column into distinct columns
#'   - Cleans up the HTS variables, separating modalities out of the indicator name
#'   - Creates a statushiv column
#'   - Cleans and separates PSNU and PSNU UID into distinct columns
#'   - Adds in mechanism information from DATIM, including operatingunit, funding agency, partner and mechanism name
#'   - Removes any rows with no targets
#'   - Allows for aggregate to the PSNU level
#'
#' @param filepath file path to the Target Setting Tool importing, must be .xlsx
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
#' #read in Target Setting Tool (straight from sheets, not PSNUxIM tab)
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

  #import Target Setting Tool, refine columns and reshape
  df_dp <- purrr::map_dfr(import_tabs,
                          ~import_dp(filepath, .x) %>%
                            reshape_dp())

  #grab and apply FY
  fy <- grab_info(filepath, "year")
  df_dp <- apply_fy(df_dp, fy)

  #include/exclude PLHIV/SUBNAT as desired
  df_dp <- limit_datatype(df_dp, type)

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

  if(is_sheet(filepath, "Prioritization")){
    #identify and apply prioritization
    df_prioritizations <- grab_prioritization(filepath)
    df_dp <- apply_prioritization(df_dp, df_prioritizations)

    #identify and apply snu1 (if using PSNUxIM tab)
    # df_snu1 <- grab_snu1(filepath) #SNU1 no longer in DP
    # df_dp <- apply_snu1(df_dp, df_snu1) #SNU1 no longer in DP
  }

  #add file name and date stamp to dataset
  df_dp <- apply_stamps(df_dp, filepath)

  #order variables for output
  df_dp <- order_vars(df_dp)

  #apply variable class
  df_dp <- apply_class(df_dp)

  return(df_dp)
}
