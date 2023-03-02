#' Pull Information from Target Setting Tool "Home" Tab
#'
#' This function extract information stored in the Target Setting Tool Home tab to
#' identify either the country or what the fiscal year is.
#'
#' @param filepath file path to the Target Setting Tool importing, must be .xlsx
#' @param type either "country" or "year"
#'
#' @export
#' @examplesIf FALSE
#' path <- "../Downloads/DataPack_Jupiter_20200218.xlsx"
#' cntry <- grab_info(path, "country")
#' fy <- grab_info(path, "year")

grab_info <- function(filepath, type){

  #identify which cell range to pull from
  cell <- ifelse(type == "year", "B10", "B20")

  #read in cell information
  info <- readxl::read_excel(filepath,
                           sheet = "Home",
                           range = cell,
                           col_types = "text") %>%
    names()

  #convert to FY from COP year in cell
  if(type == "year"){
    info <- info %>%
      stringr::str_extract("(?<=COP)[:alnum:]{2}") %>%
      paste0("20", .) %>%
      as.numeric() + 1
  }

return(info)

}
