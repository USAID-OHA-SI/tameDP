#' Aggregate Targets to IM or PSNU level
#'
#' @param df data frame to aggregate
#' @param psnu_lvl default aggregate is to IM level; if TRUE, aggregates to PSNU level
#'
#' @export

agg_dp <- function(df, psnu_lvl = FALSE){

  key_cols <- c("psnu", "psnuuid","indicator_code", "indicatortype", "age", "sex", "keypop")

  if(psnu_lvl == FALSE){
    #create IM level targets
    df <- dplyr::mutate(df, targets = round(datapacktarget * share, 0))
    key_cols <- c("mech_code", key_cols)
  } else {
    #create PSNU level targets
    df <- dplyr::mutate(df, targets = round(datapacktarget, 0))
  }

    #aggregate up to psnu/[mechanism/]ind/age/sex/keypop level
    df <- df %>%
      dplyr::group_by(dplyr::across(dplyr::all_of(key_cols))) %>%
      dplyr::summarise(dplyr::across(c(targets, value), sum, na.rm = TRUE)) %>%
      dplyr::ungroup() %>%
      dplyr::filter(targets != 0)

  return(df)
}



