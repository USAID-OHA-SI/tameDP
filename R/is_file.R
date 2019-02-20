#' Is the filepath correct for the Data Pack
#'
#' @param filepath filepath of COP 19 Data Pack
#'
#' @export

is_file <- function(filepath){

  file.exists(filepath)

}

