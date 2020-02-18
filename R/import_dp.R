#' Import SNUxIM tab from the Data Pack
#'
#' @param filepath file path to the Data Pack importing, must be .xls
#'
#' @export
#' @importFrom magrittr %>%


import_dp <- function(filepath){

  #check if file is found
  if(!is_file(filepath))
    stop("Cannot find file! Check file path.")

  #check if extension is okay
  if(!is_xls(filepath))
    stop("Cannot read a xlsb file format. Resave as xlsx.")

  #check that sheet exists
  if(!is_sheet(filepath))
    stop("No sheet called 'PSNU x IM' found.")

  #import Data Pack and convert to lower
  suppressWarnings(
  df <-
    readxl::read_excel(filepath,
                       sheet = "PSNU x IM",
                       skip = 4,
                       col_types = "text") %>%
    dplyr::rename_all(~tolower(.))
  )

  return(df)
}
