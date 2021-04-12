#' Pull OU name from datapack "home" tab
#'
#' Function to pull the country name from cell B20 in 'Home' and store as an df
#' For use later when running `import_plhiv`
#'
#' @param filepath file path to the Data Pack importing, must be .xls
#'
#' @importFrom magrittr %>%
#'
#' @export

grab_cntry <- function(filepath){
  cntry <- readxl::read_excel(filepath,
                           sheet = "Home",
                           range = "B20",
                           col_types = "text") %>%
    names()

return(cntry)

}
