#' Pivot Results
#'
#' If there are any historic results in the dataset (found in some of the non-
#' PSNUxIM tabs), we want to separate these from the target values to ensure the
#' dataset is tidy and results/targets will not be indavertently aggregated. The
#' reshape will create a cumulative column if results exist in the provided
#' dataframe.
#'
#' @param df data frame after it's been aggregated
#'
#' @return data frame with a cumulative column (when/where results exist)
#' @export

pivot_results <- function(df){
  if(any(grepl("R$", unique(df$indicator_code)))){
    df <- df %>%
      dplyr::mutate(value_type = ifelse(stringr::str_detect(indicator_code, "R$"), "cumulative", "targets")) %>%
      tidyr::pivot_wider(names_from = value_type,
                         values_from = targets)
  }
  return(df)
}


