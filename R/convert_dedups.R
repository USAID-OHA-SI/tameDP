#' Adjust Dedup values to negative values
#'
#' @param df dataframe output to reorder
#' @export

convert_dedups <- function(df){

  #change dedup value to negative
  df <- df %>%
    dplyr::mutate(value = ifelse(mech_code == "dedup", -abs(value), value))

  return(df)
}
