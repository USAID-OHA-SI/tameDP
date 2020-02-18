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

  #identify all mechanism columns for reshaping
  mechs <- df %>%
    dplyr::select(dplyr::matches("^(1|2|3|4|5|6|7|8|9).")) %>%
    names()

  #reshape
  df <- df %>%
    #keep only relevant columns
    dplyr::select(key_cols, mechs) %>%
    #reshape long, dropping NA cols
    tidyr::gather(mechanismid, fy2020_targets, mechs, na.rm = TRUE)

  #account for dup issue with mechid (if dup cols, mechid..col -> strip extra)
  df <- dplyr::mutate(df, mechanismid = stringr::str_sub(mechanismid, end = 5))

  #change values to double
  suppressWarnings(
    df <- dplyr::mutate(df, fy2020_targets = as.double(fy2020_targets))
  )

  #aggregate up to mechanism/ind/age/sex/keypop level
  df <- df %>%
    dplyr::group_by_at(dplyr::vars(mechanismid, key_cols)) %>%
    dplyr::summarise_at(dplyr::vars(fy2020_targets), sum, na.rm = TRUE) %>%
    dplyr::ungroup() %>%
    dplyr::filter(fy2020_targets != 0)

  #extract PSNU UID from PSNU column
  df <- df %>%
    tidyr::separate(psnu, c("psnu", "psnuuid"), sep = " \\(") %>%
    dplyr::mutate(psnuuid = stringr::str_remove(psnuuid, "\\)"))

  return(df)
}
