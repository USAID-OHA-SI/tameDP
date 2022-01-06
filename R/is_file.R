#' Is the filepath correct for the Data Pack
#'
#' @param filepath filepath of Data Pack
#' @family validation
#' @export

is_file <- function(filepath){

  file.exists(filepath)

}

