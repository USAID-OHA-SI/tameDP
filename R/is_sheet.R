
#' Check if sheet exits in Data pack
#'
#' @param filepath filepath of COP 19 Data Pack
#'
#' @export

is_sheet <- function(filepath){

  #does PSNUxIM tab exist?
  "PSNUxIM" %in% readxl::excel_sheets(filepath)

}

