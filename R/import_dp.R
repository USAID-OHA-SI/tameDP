#' Import SNUxIM tab from the Data Pack
#'
#' @param filepath file path to the Data Pack importing, must be .xls
#'
#' @export
#' @importFrom magrittr %>%


import_dp <- function(filepath){
  #import Data Pack and convert to lower
  df <-
    readxl::read_excel(filepath,
                       sheet = "SNU x IM",
                       skip = 4,
                       col_types = "text") %>%
    dplyr::rename_all(~tolower(.))

  return(df)
}
