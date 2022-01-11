#' Adjust Dedup values to negative values
#'
#' The dedup values in the PSNUxIM tab are stored as positive values. This
#' function converts the dedup mechanism values to negative.
#'
#' @param df dataframe output to reorder
#' @export

convert_dedups <- function(df){

  if("mech_code" %in% names(df)){
    #change dedup value to negative
    df <- df %>%
      dplyr::mutate(value = ifelse(mech_code == "dedup", -abs(value), value))

    #covert dedup to mech code (assuming all are 00000 and none are 00001)
    df <- dplyr::mutate(df, mech_code = ifelse(mech_code == "dedup", "00000", mech_code))
  }

  return(df)
}
