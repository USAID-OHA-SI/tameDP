#' Clean up indicators and disaggs for ease of use
#'
#' @param df data frame to adjust
#'
#' @export
#' @importFrom magrittr %>%

clean_indicators <- function(df){

  suppressWarnings(
    df <- df %>%
      tidyr::separate(indicator_code,
                      c("indicator", "numeratordenom", "disaggregate", NA, "otherdisaggregate"),
                      sep = "\\.", fill = "right"))

  #result status
  df <- df %>%
    dplyr::mutate(statushiv = dplyr::case_when(
                    otherdisaggregate %in% c("NewPos", "KnownPos", "Positive") ~ "Positive",
                    otherdisaggregate %in% c("NewNeg", "Negative")             ~ "Negative",
                    otherdisaggregate == "Unknown"                             ~ "Unknown"),
                  otherdisaggregate = ifelse(!stringr::str_detect(indicator, "STAT") &
                                               otherdisaggregate %in% c("NewPos", "Positive",
                                                                        "NewNeg", "Negative",
                                                                        "Unknown"),
                                             as.character(NA), otherdisaggregate))
  #fix disaggregates
  df <- dplyr::mutate(df, disaggregate = stringr::str_replace_all(disaggregate, "_", "/"))

  #convert external modalities
  df <- convert_mods(df)

  #add HTS_TST_POS
  df

  #move targets to end
  df <- df %>%
    dplyr::mutate(fiscal_year = 2021) %>%
    dplyr::select(fiscal_year, dplyr::everything()) %>%
    dplyr::select(-targets, dplyr::everything())

  return(df)
}
