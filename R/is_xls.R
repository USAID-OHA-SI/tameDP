#' Check if the filepath is .xls or .xlsx
#'
#' @param filepath filepath of COP 19 Data Pack
#'
#' @export


is_xls <- function(filepath){

  #extension of the DP file
  ext <- tools::file_ext(filepath)

  #acceptable formats
  okay_formats <- c("xls", "xlsx")

  #check if filepath is oka
  ext %in% okay_formats

}
