#' Order variables
#'
#' Ensure variables in the exported data frame are correctly ordered.
#'
#' @param df dataframe output to reorder
#' @export

order_vars <- function(df){

  #order variables
  if("mech_code" %in% names(df)){
    df <- dplyr::select(df,
                        operatingunit, countryname, psnu, psnuuid,
                        fundingagency, mech_code, primepartner, mech_name,
                        fiscal_year,
                        indicator, indicatortype, disagg,
                        numeratordenom, age, sex, modality, statushiv, otherdisaggregate,
                        targets)
  } else {
    df <- dplyr::select(df,
                        operatingunit, countryname, psnu, psnuuid,
                        fiscal_year,
                        indicator, indicatortype, disagg,
                        numeratordenom, age, sex, modality, statushiv, otherdisaggregate,
                        targets)
  }

  return(df)
}
