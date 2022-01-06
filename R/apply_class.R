#' Apply variable class
#'
#' Ensure that fiscal year and targets are numeric and all other variables are
#' stored as characters.
#'
#' @param df dataframe output to reorder
#' @export

apply_class <- function(df){
  #ensure variables are same class (problem when missing all targets)
  df <- df %>%
    dplyr::mutate(dplyr::across(dplyr::everything(), as.character),
                  dplyr::across(c(fiscal_year, targets), as.double))
  return(df)
}
