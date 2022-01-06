#' Is the filepath correct for the Data Pack
#'
#' @param filepath filepath of Data Pack
#' @family validation
#' @export

is_file <- function(filepath){

  file.exists(filepath)

}



#' Check if sheet exits in Data Pack
#'
#' @param filepath filepath of Data Pack
#' @family validation
#' @export

is_sheet <- function(filepath){

  #does PSNUxIM tab exist?
  "PSNUxIM" %in% readxl::excel_sheets(filepath)

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

