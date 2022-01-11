#' Aggregate Targets to IM or PSNU level
#'
#' To ensure there are no duplicate rows on the reshape, this function first
#' aggregates the data by the key columns to minimize any issues. If desiring
#' to work at the PSNU level, the parameter `psnu_lvl` allows you to aggregate
#' to the PSNU level instead of the PSNUxIM level.
#'
#' @param df data frame to aggregate
#' @param psnu_lvl default aggregate is to IM level; if TRUE, aggregates to PSNU level
#'
#' @export

agg_dp <- function(df, psnu_lvl = FALSE){

  #identify key columns desired to group by
  key_cols <- c("snu1","psnu", "psnuuid", "indicator","indicator_code",
                "indicatortype", "age", "sex", "keypop")

  #keep only key columns that match data frame
  key_cols <- intersect(key_cols, names(df))

  #include to mech_code to key_cols if desired and available
  if(psnu_lvl == FALSE && "mech_code" %in% names(df))
    key_cols <- c("mech_code", key_cols)

  #create targets
  df <- dplyr::mutate(df, targets = round(value, 0))

  #remove zero rows
  df <- dplyr::filter(df, targets != 0)

  #aggregate up to psnu/[mechanism/]ind/age/sex/keypop level
  df <- df %>%
    dplyr::group_by(dplyr::across(dplyr::all_of(key_cols))) %>%
    dplyr::summarise(targets = sum(targets, na.rm = TRUE)) %>%
    dplyr::ungroup()

  return(df)
}



