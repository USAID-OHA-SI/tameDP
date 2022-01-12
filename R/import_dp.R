#' Import Tabs from the Data Pack
#'
#' Initial reading in of tabs of the Data Pack. This function reads in the
#' necessary tab or tabs, removes unused columns and cleans up the column names
#' so there are no duplicates. For the PSNUxIM, it identified columns as as a
#' share or value.
#'
#' @param filepath file path to the Data Pack importing, must be .xlsx
#' @param tab which sheet to read in
#'
#' @export
#' @examplesIf FALSE
#' path <- "../Downloads/DataPack_Jupiter_20200218.xlsx"
#' df_dp <- import_dp(path, tab = "PSNUxIM")

import_dp <- function(filepath, tab){

  #check if file is found
  if(!is_file(filepath))
    stop("Cannot find file! Check file path.")

  #check if extension is okay
  if(!is_xls(filepath))
    stop("Cannot read a xlsb file format. Resave as xlsx.")

  #check that sheet exists
  if(!is_sheet(filepath, tab))
    stop(paste("No sheet called", tab, "found."))

  #import Data Pack tab
  suppressMessages(
  df <-
    readxl::read_excel(filepath,
                       sheet = tab,
                       skip = 13,
                       col_types = "text",
                       .name_repair = "unique")
  )

  #clean/subset columns
  if(tab != "PSNUxIM"){
    #identify columns to keep
    cols_keep <- match_col_type(filepath, tab)

    #limit columns if there are extra columns tacked on
    df <- df[1:length(cols_keep)]

    #subset target columns (non PSNUxIM tab)
    df <- df[cols_keep]

    #remove id column
    df <- dplyr::select(df, -dplyr::matches("^id$"))
  }

  #fix names - change dup col names to value and pct
  if(tab == "PSNUxIM"){
    df <- df %>%
      dplyr::select(-dplyr::starts_with("...")) %>%
      dplyr::rename_with(~stringr::str_replace(., "...[:digit:]{3}$", "_value")) %>%
      dplyr::rename_with(~stringr::str_replace(., "...[:digit:]{1,2}$", "_share"))
  }

  return(df)
}


#' Match Column Type
#'
#' This function utlizes the meta data stored in row 6 of each tab of the Data
#' Pack to determine what column type is - "assumption", "calculation", "past",
#'  "result", "reference", "row_header", "target". The primary columns we want
#'  are meta data (row_header) and targets.
#'
#' @param filepath file path to the Data Pack importing, must be .xlsx
#' @param tab which sheet to read in
#' @param pattern type of column, "assumption", "calculation", "past",
#'  "result", "reference", "row_header", "target"; default = "(row_header|target)"
#'
#' @return Boolean list of matches
#' @export
#'
match_col_type <- function(filepath, tab, pattern = "(row_header|target)"){
  #Identify column type from meta info
   col_types <- readxl::read_excel(
    path = filepath,
    sheet = tab,
    skip = 5,
    n_max = 0,
    col_types = "text",
    .name_repair = "minimal") %>%
    names() %>%
    tolower()

  #does type match the specific column type identified?
  grepl(pattern, col_types)

}
