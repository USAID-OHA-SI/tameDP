#' Reshape Data Pack Long
#'
#' @param df data frame to adjust
#'
#' @export
#' @importFrom magrittr %>%


reshape_dp <- function(df){

  #identify all mechanism columns for reshaping
  mechs <- df %>%
    dplyr::select(dplyr::matches("^(1|2|3|4|5|6|7|8|9).")) %>%
    names()

  #identify all key meta data columns to keep
  key_cols <- c("indicatorcode", "coarseage", "sex", "keypop")

  #check if all columns exist
  if(!all(key_cols %in% colnames(df)))
    stop("SNUxIM tab is missing one or more columns - indicatorcode, coarseage, sex, keypop")

  #reshape
  df <- df %>%
    #keep only relevant columns
    dplyr::select(key_cols, mechs) %>%
    #reshape long, dropping NA cols
    tidyr::gather(mechanismid, fy2020_targets, mechs, na.rm = TRUE) %>%
    #change values to double
    dplyr::mutate(fy2020_targets = as.double(fy2020_targets)) %>%
    #aggregate up to mechanism/ind/age/sex/keypop level
    dplyr::group_by_at(dplyr::vars(mechanismid, key_cols)) %>%
    dplyr::summarise_at(dplyr::vars(fy2020_targets), sum, na.rm = TRUE) %>%
    dplyr::ungroup() %>%
    dplyr::filter(fy2020_targets != 0)

  return(df)
}
