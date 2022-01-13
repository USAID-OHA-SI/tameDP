#' Map Standardized Disaggregate
#'
#' To align with DATIM datasets, the standardized disaggregates
#' for each indicators will be aligned to the Data Pack for FY22 Targets.
#'
#' @param df dataframe from clean_indicators
#'
#' @export

map_disaggs <- function(df){

  #identify if the indicator_code contains KP
  df <- df %>%
    dplyr::mutate(kp_disagg = dplyr::case_when(indicator %in% c("KP_MAT", "KP_MAT_SUBNAT") ~ FALSE,
                                               stringr::str_detect(indicator_code, "KP") ~ TRUE,
                                               TRUE ~ FALSE))
  #map the MER disaggregates onto the dataset
  df <- df %>%
    dplyr::left_join(mer_disagg_mapping,
                     by = c("indicator", "numeratordenom", "kp_disagg"))

  return(df)
}
