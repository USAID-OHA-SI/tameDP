
#' Check if sheet exits in Data pack
#'
#' @param filepath filepath of COP 19 Data Pack
#'
#' @export

is_sheet <- function(filepath){

  #does SNU x IM tab exist?
  "SNU x IM" %in% readxl::excel_sheets(filepath)

}

