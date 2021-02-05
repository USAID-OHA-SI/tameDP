#' Reshape Data Pack Long
#'
#' @param df data frame to adjust
#' @param psnu_lvl aggregate to the PSNU level instead of IM
#'
#' @export
#' @importFrom magrittr %>%


reshape_dp <- function(df, psnu_lvl = FALSE){

  #identify all key meta data columns to keep
  key_cols <- c("psnu","indicator_code", "age", "sex", "keypop", "datapacktarget")

  #check if all columns exist
  if(length(setdiff(key_cols, names(df))) > 0)
    stop(paste("PSNUxIM tab is missing one or more columns:", paste(length(setdiff(key_cols, names(df_dp))), collapse = ", ")))

  if(psnu_lvl == FALSE){

    #rename dedup columns
    df <- df %>%
      dplyr::rename(dedup_dsd_value = `deduplicated dsd rollup (fy22)`,
                    dedup_ta_value = `deduplicated ta rollup (fy22)`)

    #identify all mechanism columns for reshaping
    mechs <- df %>%
      dplyr::select(dplyr::starts_with("dedup"),
                    dplyr::matches("^(1|2|3|4|5|6|7|8|9).")) %>%
      names()

    #reshape
    df <- df %>%
      #keep only relevant columns
      dplyr::select(key_cols, mechs) %>%
      #reshape long, dropping NA cols
      tidyr::pivot_longer(-key_cols,
                          names_to = c("mech_code", "indicatortype", ".value"),
                          names_sep = "_") %>%
      #make dsd and ta upper case
      dplyr::mutate(indicatortype = toupper(indicatortype)) %>%
      #remove rows with no share or value
      dplyr::filter_at(dplyr::vars(value, share), dplyr::any_vars(!is.na(.)))

  } else {
    #if at PSNU level, only keep key cols
    df <- df %>%
      dplyr::select(key_cols) %>%
      dplyr::mutate(indicatortype = as.character(NA))

  }

  #change values to double
  suppressWarnings(
    df <- dplyr::mutate_at(df, dplyr::vars(dplyr::one_of("datapacktarget", "imtargetshare")), as.numeric)
  )

  #extract PSNU UID from PSNU column
  df <- df %>%
    tidyr::separate(psnu, c("psnu", NA,"psnuuid"), sep = " \\[") %>%
    dplyr::mutate(psnuuid = stringr::str_remove(psnuuid, "\\]"))



  return(df)
}
