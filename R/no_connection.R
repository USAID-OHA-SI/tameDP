#' Check if computer has internet connection
#'
#' @export

no_connection <- function(){

  if(!curl::has_internet())
    stop("No internet connection. Cannot access offical names & rename.")
}

