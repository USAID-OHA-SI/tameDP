#' Is the filepath correct for the Data Pack
#'
#' @param filepath filepath of Data Pack
#' @family validation
#' @export

is_file <- function(filepath){

  file.exists(filepath)

}



#' Check if a sheet exits in Data Pack
#'
#' @param filepath filepath of Data Pack
#' @param tab sheet to check in Data Pack, "PSNUxIM" (default)
#' @family validation
#' @export

is_sheet <- function(filepath, tab = "PSNUxIM"){

  #does PSNUxIM/Cascade tab exist?
  tab %in% readxl::excel_sheets(filepath)

}



#' Check if the filepath is .xls or .xlsx
#'
#' @param filepath filepath of COP Data Pack
#' @family validation
#' @export

is_xls <- function(filepath){

  #extension of the DP file
  ext <- tools::file_ext(filepath)

  #acceptable formats
  okay_formats <- c("xls", "xlsx")

  #check if filepath is oka
  ext %in% okay_formats

}



#' Check if computer has internet connection
#' @family validation
#' @export

no_connection <- function(){

  if(!curl::has_internet())
    stop("No internet connection. Cannot access offical names & rename.")
}


#' Return Tab
#'
#' Identify which tab to import based on what you want to use - PSNUxIM, PLHIV,
#' or ALL. You can also provide a specific tab name that matches the Data Pack
#'
#' @param type dataset to extract "PSNUxIM", "PLHIV", "ALL", or a specific tab
#'
#' @return tabs to import
#' @export

return_tab <- function(type){

  dp_tabs <- c("Cascade",
               "PMTCT",
               "EID",
               "TB",
               "VMMC",
               "KP",
               "HTS",
               "CXCA",
               "HTS_RECENT",
               "TX_TB_PREV",
               "PP",
               "OVC",
               "GEND",
               "AGYW",
               "PrEP",
               "KP_MAT")

  if(type == "PSNUxIM"){
    t <- "PSNUxIM"
  } else if(type == "PLHIV"){
    t <- "Cascade"
  } else if(type == "ALL"){
    t <- dp_tabs
  } else if(type %in% dp_tabs){
    t <- type
  } else {
    stop("Not a valid type/tab provided")
  }

  return(t)

}


#' Apply Fiscal Year
#'
#' Apply fiscal year to each row, using the T or T_1 in `indicator_code` to
#' determine whether it's the current or prior fiscal year. The fiscal year
#' can be identified dynamically through `grab_info()`.
#'
#' @param df DP dataframe to apply fiscal year to
#' @param year fiscal year, derived from `grab_info(filepath, "year")`
#'
#' @return data frame with fiscal year
#' @export

apply_fy <- function(df, year){

  df <- df %>%
    dplyr::mutate(fiscal_year =
                    ifelse(stringr::str_detect(indicator_code, "\\.(T_1)$"),
                           year-1,
                           year)
    )

  return(df)
}
