#' Order variables
#'
#' Ensure variables in the exported data frame are correctly ordered.
#'
#' @param df dataframe output to reorder
#' @export

order_vars <- function(df){

  #add variables if they doesn't exist
  if(!"cumulative" %in% names(df))
    df <- dplyr::mutate(df, cumulative = NA_real_)

  # if(!"snu1" %in% names(df))
  #   df <- dplyr::mutate(df, snu1 = NA_character_)

  if(!"snuprioritization" %in% names(df))
    df <- dplyr::mutate(df, snuprioritization = NA_character_)


  #order variables
  if("mech_code" %in% names(df)){
    df <- dplyr::select(df,
                        operatingunit, country, psnu, psnuuid, snuprioritization,
                        funding_agency, mech_code, prime_partner_name, mech_name,
                        fiscal_year,
                        dplyr::starts_with("indicator"), standardizeddisaggregate,
                        numeratordenom, ageasentered, target_age_2024, trendscoarse, sex, modality, statushiv, otherdisaggregate,
                        cumulative, targets,
                        dplyr::starts_with("source"))
  } else {
    df <- dplyr::select(df,
                        operatingunit, country, psnu, psnuuid, snuprioritization,
                        fiscal_year,
                        dplyr::starts_with("indicator"), standardizeddisaggregate,
                        numeratordenom, ageasentered, target_age_2024, trendscoarse, sex, modality, statushiv, otherdisaggregate,
                        cumulative, targets,
                        dplyr::starts_with("source"))
  }

  return(df)
}
