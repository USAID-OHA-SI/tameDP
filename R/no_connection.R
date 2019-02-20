#' Check if computer has internet connection
#'
#' @export

no_connection <- function(){

  #check internet connection
  status <- tryCatch(
    httr::GET("https://www.datim.org/api/sqlViews/fgUtV6e9YIX/data.csv", httr::timeout(60)),
    error = function(e) e)

  inherits(status,  "error")
}

