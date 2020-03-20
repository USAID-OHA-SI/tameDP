#' Order variables
#'
#' @param df dataframe output to reorder
#' @export

order_vars <- function(df){

  #order variables
  if(!"fundingagency" %in% names(df)){
    df <- df %>%
      dplyr::mutate(fundingagency = NA_character_,
                    primepartner = NA_character_,
                    mech_name = NA_character_)
  }
  setdiff(names(df), c("operatingunit", "psnu", "psnuuid",
                       "fundingagency", "mech_code", "primepartner", "mech_name"))

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
