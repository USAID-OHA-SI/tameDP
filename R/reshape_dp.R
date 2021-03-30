#' Reshape Data Pack Long
#'
#' @param df data frame to adjust
#'
#' @export
#' @importFrom magrittr %>%


reshape_dp <- function(df){

  #identify all key meta data columns to keep
  key_cols <- c("psnu","indicator_code", "age", "sex", "keypop", "datapacktarget")

  #check if all columns exist
  if(length(setdiff(key_cols, names(df))) > 0)
    stop(paste("PSNUxIM tab is missing one or more columns:", paste(length(setdiff(key_cols, names(df_dp))), collapse = ", ")))

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


  #change values to double
  suppressWarnings(
    df <- dplyr::mutate(df, dplyr::across(c(datapacktarget, value, share), as.numeric))
  )

  #extract PSNU UID from PSNU column
  df <- df %>%
    dplyr::mutate(psnu = stringr::str_remove_all(psnu, " \\[(#SNU|#DREAMS)]")) %>%
    tidyr::separate(psnu, c("psnu", "psnuuid", NA), sep = " \\[|]")

  return(df)
}
