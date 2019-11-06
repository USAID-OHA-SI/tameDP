#' Pull OU name from datapack "home" tab
#'
#' Function to pull the OU name from cell B20 in 'Home' and store as an df
#' For use later when running `import_plhiv`
#'
#' @param filepath
#'
#' @export
grab_ou <- function(filepath){
ou <- readxl::read_excel(filepath,
                         sheet = "Home",
                         range = "B20",
                         col_types = "text") %>%
  names()

return(ou)

}
