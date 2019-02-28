#' Clean up indicators and disaggs for ease of use
#'
#' @param df data frame to adjust
#'
#' @export
#' @importFrom magrittr %>%

clean_indicators <- function(df){

  suppressWarnings(
    df <- df %>%
      tidyr::separate(indicatorcode,
                      c("indicator", "numeratordenom", "disaggregate", NA, "otherdisaggregate"),
                      sep = "\\."))

  #create modalities & rename HTS
  df <- df %>%
    dplyr::mutate(modality = dplyr::case_when(
      indicator == "HTS_INDEX_COM" ~ "IndexMod",
      indicator == "HTS_INDEX_FAC" ~ "Index",
      stringr::str_detect(indicator, "HTS_TST.") ~
        stringr::str_remove(indicator, "HTS_TST_")),
      indicator = ifelse(stringr::str_detect(indicator, "HTS_(TST|INDEX)."), "HTS_TST", indicator))

  #result status
  df <- df %>%
    dplyr::mutate(resultstatus = dplyr::case_when(
                    otherdisaggregate %in% c("NewPos", "KnownPos", "Positive") ~ "Positive",
                    otherdisaggregate %in% c("NewNeg", "Negative")             ~ "Negative",
                    otherdisaggregate == "Unknown"                             ~ "Unknown"),
                  otherdisaggregate = ifelse(!stringr::str_detect(indicator, "STAT") &
                                               otherdisaggregate %in% c("NewPos", "Positive",
                                                                        "NewNeg", "Negative"),
                                             as.character(NA), otherdisaggregate))
  #move targets to end
  df <- df %>%
    dplyr::select(-fy2020_targets, dplyr::everything())

  return(df)
}
