#' Limit Dataset Type
#'
#' This function limits the output of the Target Setting Tool data to either MER or
#' SUBNAT (e.g. PLHIV, TX_CURR_SUBNAT) data. It will not be run if processing
#' the PSNUxIM tab since that does not include any SUBNAT data.
#'
#' @param df data frame read in and reshaped by import_dp and reshape_dp
#' @param type dataset type, either "MER" or "PLHIV"
#'
#' @return data frame limited to either MER or SUBNAT data
#' @export

limit_datatype <- function(df, type){

  if("data_type" %in% names(df) && type %in% c("PLHIV", "SUBNAT")){
    #limit data to SUBNAT or IMPATT
    df <- dplyr::filter(df, data_type %in% c("SUBNAT", "IMPATT"))
  }

  if("data_type" %in% names(df) && !type %in% c("PLHIV", "SUBNAT")){
    #limit data to MER
    df <- dplyr::filter(df, data_type == "MER")
  }

  return(df)
}
