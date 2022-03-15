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

  #tab type
  tab_type <- ifelse(tab %in% c("PSNUxIM", "Prioritization"), tab, "standard")

  #clean/subset columns based on tab
  switch(tab_type,
         PSNUxIM = subset_psnuxim(df),
         Prioritization = subset_prioritization(df),
         standard = subset_standard(df, filepath, tab))

}


#' Match Column Type
#'
#' This function utilizes the meta data stored in row 6 of each tab of the Data
#' Pack to determine what column type is - "assumption", "calculation", "past",
#'  "result", "reference", "row_header", "target". The primary columns we want
#'  are meta data (row_header), targets, and past (prior year result/targets for
#'  reference).
#'
#' @param filepath file path to the Data Pack importing, must be .xlsx
#' @param tab which sheet to read in
#' @param pattern type of column, "assumption", "calculation", "past",
#'  "result", "reference", "row_header", "target"; default = "(row_header|target|past)"
#'
#' @return Boolean list of matches
#' @export
#'
match_col_type <- function(filepath, tab, pattern = "(row_header|target|past)"){
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



#' Subset PSNUxIM Tab
#'
#' Subsets the columns of the massive Data Pack tab down to only those that are
#' needed. This depends on the type of tab that is being imported. PSNUxIM keep
#' all meta data and taget share/value columns.
#'
#' @param df data frame after import
#'
#' @family subset
#' @return limits to correct columns in data frame from DP tab
#' @export

subset_psnuxim <- function(df){
  df <- df %>%
    dplyr::select(-dplyr::starts_with("...")) %>%
    dplyr::rename_with(~stringr::str_replace(., "...[:digit:]{3}$", "_value")) %>%
    dplyr::rename_with(~stringr::str_replace(., "...[:digit:]{1,2}$", "_share"))

  return(df)
}


#' Subset Prioritization Tab
#'
#' Subsets the columns of the massive Data Pack tab down to only those that are
#' needed. This depends on the type of tab that is being imported. The
#' Prioritization tab keeps the PSNU and prioritization column.
#'
#' @param df data frame after import
#'
#' @family subset
#' @return limits to correct columns in data frame from DP tab
#' @export
#'
subset_prioritization <- function(df){
  df <- df %>%
    dplyr::select(snu1 = SNU1, psnu = PSNU, IMPATT.PRIORITY_SNU.T, PRIORITY_SNU.translation) %>%
    tidyr::unite(snuprioritization,
                 IMPATT.PRIORITY_SNU.T, PRIORITY_SNU.translation,
                 sep = " - ") %>%
    dplyr::mutate(snuprioritization = ifelse(snuprioritization == "M - Military", "97 - Above PSNU level", snuprioritization))

  return(df)
}

#' Subset Standard Tabs
#'
#' Subsets the columns of the massive Data Pack tab down to only those that are
#' needed. This depends on the type of tab that is being imported. Standard,
#' non-PSNUxIM/Prioritization) keep column types specified in the Data Pack as
#' row_header, target, or past.
#'
#' @param df data frame after import
#'
#' @family subset
#' @return limits to correct columns in data frame from DP tab
#' @export
#'
subset_standard <- function(df, filepath, tab){
  #identify columns to keep
  cols_keep <- match_col_type(filepath, tab)

  #limit columns if there are extra columns tacked on
  df <- df[1:length(cols_keep)]

  #subset target columns (non PSNUxIM tab)
  df <- df[cols_keep]

  #remove id column
  df <- dplyr::select(df, -dplyr::matches("^id$"))

  return(df)
}
