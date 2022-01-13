#' Order variables
#'
#' Ensure variables in the exported data frame are correctly ordered.
#'
#' @param df dataframe output to reorder
#' @export

order_vars <- function(df){

  #add snu1 as blank col if using PSNUxIM
  if(!"snu1" %in% names(df))
    df <- dplyr::mutate(df, snu1 = NA_character_)

  #order variables
  if("mech_code" %in% names(df)){
    df <- dplyr::select(df,
                        operatingunit, countryname, snu1, psnu, psnuuid,
                        fundingagency, mech_code, primepartner, mech_name,
                        fiscal_year,
                        dplyr::starts_with("indicator"), standardizeddisaggregate,
                        numeratordenom, ageasentered, sex, modality, statushiv, otherdisaggregate,
                        targets)
  } else {
    df <- dplyr::select(df,
                        operatingunit, countryname, snu1, psnu, psnuuid,
                        fiscal_year,
                        dplyr::starts_with("indicator"), standardizeddisaggregate,
                        numeratordenom, ageasentered, sex, modality, statushiv, otherdisaggregate,
                        targets)
  }

  return(df)
}
