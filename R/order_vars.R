#' Order variables
#'
#' @param df dataframe output to reorder
#' @export

order_vars <- function(df){

  #order variables
  if("mech_code" %in% names(df)){
    df <- dplyr::select(df,
                        operatingunit, psnu, psnuuid,
                        fundingagency, mech_code, primepartner, mech_name,
                        dplyr::everything())
  } else {
    df <- dplyr::select(df,
                        operatingunit, psnu, psnuuid,
                        dplyr::everything())
  }

  return(df)
}
