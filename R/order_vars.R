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

  if(!"snuprioritization" %in% names(df))
    df <- dplyr::mutate(df, snuprioritization = NA_character_)

  #variable order
  v_order <- c("operatingunit", "country", "psnu", "psnuuid", "snuprioritization",
               "fiscal_year",
               "funding_agency","mech_code", "prime_partner_name", "mech_name",
               "indicator", "standardizeddisaggregate", "numeratordenom",
               "ageasentered", "target_age_2024", "trendscoarse",
               "sex", "modality", "target_modality_2024", "statushiv",
               "otherdisaggregate",
               "cumulative", "targets",
               "source_name", "source_processed")

  #if not IM dataset, exclude mech cols
  if(!"mech_code" %in% names(df))
    v_order <- v_order[!v_order %in% c("funding_agency","mech_code", "prime_partner_name", "mech_name")]

  #order variables
    df <- dplyr::select(df, dplyr::all_of(v_order))

  return(df)
}
