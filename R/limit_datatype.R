#' Limit Dataset Type
#'
#' This function limits the output of the Data Pack data to either MER or
#' SUBNAT (e.g. PLHIV, TX_CURR_SUBNAT) data. It will not be run if processing
#' the PSNUxIM tab since that does not include any SUBNAT data.
#'
#' @param df data frame read in and reshaped by import_dp and reshape_dp
#' @param type dataset type, either "MER" or "PLHIV"
#'
#' @return data frame limited to either MER or SUBNAT data
#' @export

limit_datatype <- function(df, type){

  if("data_type" %in% names(df)){
    #identify what to keep
    keep <- ifelse(type == "PLHIV", "SUBNAT", "MER")

    #limit data to SUBNAT or MER
    df <- dplyr::filter(df, data_type == keep)
  }

  return(df)
}
