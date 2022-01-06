#' Adjust Dedup values to negative values
#'
#' The dedup values in the PSNUxIM tab are stored as positive values. This
#' function converts the dedup mechanism values to negative.
#'
#' @param df dataframe output to reorder
#' @export

convert_dedups <- function(df){

  #change dedup value to negative
  df <- df %>%
    dplyr::mutate(value = ifelse(mech_code == "dedup", -abs(value), value))

  return(df)
}
