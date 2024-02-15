#' Align Age with Age Coarse
#'
#' Creates a mapping from age to coarse age
#'
#' @param df dataframe from clean_indicators
#'
#' @keywords internal
#'
align_agecoarse <- function(df){

  peds_range <- c("<01",  "01-04", "01-09", "05-09", "10-14", "<15",
                  "<=02 Months", "02 - 12 Months")

  df %>%
    dplyr::mutate(trendscoarse =
                    dplyr::case_when(
                      ageasentered %in% c("18-20", "18+") ~ "18+",
                      stringr::str_detect(indicator, "OVC") ~ "<18",
                      ageasentered %in% peds_range ~ "<15",
                      is.na(ageasentered) ~ NA_character_,
                      TRUE ~ "15+"
                      ),
                  .after = ageasentered
                  )
}
