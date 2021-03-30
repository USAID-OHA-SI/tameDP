#' Clean up indicators and disaggs for ease of use
#'
#' @param df data frame to adjust
#'
#' @export
#' @importFrom magrittr %>%

clean_indicators <- function(df){

  #extract disagg info from indicator_code
  df <- df %>%
    dplyr::mutate(
    indicator = stringr::str_extract(indicator_code, "[^\\.]+"),
    numeratordenom = ifelse(stringr::str_detect(indicator_code, "\\.D\\."), "D", "N"),
    statushiv = stringr::str_extract(indicator_code, "(Neg|Pos|Unk)"),
    statushiv = dplyr::recode(statushiv,  "Neg" = "Negative" , "Pos" = "Positive", "Unk" = "Unknown"),
    age = dplyr::case_when(stringr::str_detect(indicator_code, "12") ~ "02 - 12 Months",
                           stringr::str_detect(indicator_code, "\\.2") ~ "<=02 Months",
                           TRUE ~ age),
    otherdisaggregate =
      stringr::str_extract(indicator_code,
                           "(Act|Grad|Prev|DREAMS|Already|New\\.Neg|New\\.Pos|New|KnownNeg|Routine|\\.S|PE)") %>%
      stringr::str_remove("\\."))

  #create rough disaggregate
  df <- df %>%
    dplyr::mutate(disagg = dplyr::case_when(indicator == "GEND_GBV" ~ "ViolenceServiceType",
                                            indicator == "OVC_HIVSTAT" ~ "Total",
                                            stringr::str_detect(indicator, "KP") ~ "KeyPop",
                                            TRUE ~ "Age/Sex"))

  #convert external modalities
  df <- convert_mods(df)

  #add HTS_TST_POS as an indicator
  df <- df %>%
    dplyr::filter(indicator == "HTS_TST" & statushiv == "Positive") %>%
    dplyr::mutate(indicator = "HTS_TST_POS") %>%
    dplyr::bind_rows(df, .)

  #rename keypop
  df <- dplyr::rename(df, otherdisaggregate_sub = keypop)

  #drop indicator code
  df <- dplyr::select(df, -indicator_code)

  #move targets to end
  df <- df %>%
    dplyr::mutate(fiscal_year = 2022) %>%
    dplyr::select(fiscal_year, dplyr::everything()) %>%
    dplyr::select(-targets, dplyr::everything())

  return(df)
}
