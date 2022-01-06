#' Import SNUxIM tab from the Data Pack
#'
#' Initial reading in of the PSNUxIM tab of the Data Pack, which contains all
#' the data from all the other tabs, broken down by mechanism and PSNU. This
#' function reads in the PSNUxIM tab, removes unused columns and cleans up the
#' column names so there are no duplicates and identified as a share or value.
#'
#' @param filepath file path to the Data Pack importing, must be .xlsx
#'
#' @export
#' @examplesIf FALSE {
#' path <- "../Downloads/COP51_DataPack_PEPFARLandia.xlsx"
#' df_dp <- import_dp(path)
#' }

import_dp <- function(filepath){

  #check if file is found
  if(!is_file(filepath))
    stop("Cannot find file! Check file path.")

  #check if extension is okay
  if(!is_xls(filepath))
    stop("Cannot read a xlsb file format. Resave as xlsx.")

  #check that sheet exists
  if(!is_sheet(filepath))
    stop("No sheet called 'PSNUxIM' found.")

  #import Data Pack
  suppressMessages(
  df <-
    readxl::read_excel(filepath,
                       sheet = "PSNUxIM",
                       skip = 13,
                       col_types = "text",
                       .name_repair = "unique")
  )

  #fix names - lower and change dup col names to value and pct
  df <- df %>%
    dplyr::rename_with(tolower) %>%
    dplyr::select(-dplyr::starts_with("...")) %>%
    dplyr::rename_with(~stringr::str_replace(., "...[:digit:]{3}$", "_value")) %>%
    dplyr::rename_with(~stringr::str_replace(., "...[:digit:]{1,2}$", "_share"))


  return(df)
}
