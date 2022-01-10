#' Import PSNUxIM/Cascade tab from the Data Pack
#'
#' Initial reading in of the PSNUxIM or Cascade (for PLHIV) tab of the Data
#' Pack, which contains all the data from all the other tabs, broken down by
#' mechanism and PSNU. This function reads in the tab, removes unused columns
#' and cleans up the column names so there are no duplicates and identified as
#' a share or value.
#'
#' @param filepath file path to the Data Pack importing, must be .xlsx
#' @param tab which sheet to read in, "PSNUxIM" (default) or "Cascade" (for PLHIV)
#'
#' @export
#' @examplesIf FALSE
#' path <- "../Downloads/DataPack_Jupiter_20200218.xlsx"
#' df_dp <- import_dp(path)

import_dp <- function(filepath, tab = "PSNUxIM"){

  #check if file is found
  if(!is_file(filepath))
    stop("Cannot find file! Check file path.")

  #check if extension is okay
  if(!is_xls(filepath))
    stop("Cannot read a xlsb file format. Resave as xlsx.")

  #check that sheet exists
  if(!is_sheet(filepath, tab))
    stop(paste("No sheet called", tab, "found."))

  #import Data Pack
  suppressMessages(
  df <-
    readxl::read_excel(filepath,
                       sheet = tab,
                       skip = 13,
                       col_types = "text",
                       .name_repair = "unique")
  )

  #fix names - lower
  df <- dplyr::rename_with(df, tolower)

  #fix names - change dup col names to value and pct
  if(tab == "PSNUxIM"){
    df <- df %>%
      dplyr::select(-dplyr::starts_with("...")) %>%
      dplyr::rename_with(~stringr::str_replace(., "...[:digit:]{3}$", "_value")) %>%
      dplyr::rename_with(~stringr::str_replace(., "...[:digit:]{1,2}$", "_share"))
  }

  return(df)
}
