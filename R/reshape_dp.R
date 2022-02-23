#' Reshape Data Pack Long
#'
#' This reshapes the relevant columns from a given tab to long, making it tidy
#' and more usable. It relies on either `reshape_tab()` or `reshape_psnuim()`
#' depending on the tab being processed.
#'
#' @param df data frame from import_dp()
#' @family reshape
#' @export

reshape_dp <- function(df){
  #identify tab/data frame type
  type <- ifelse("indicator_code" %in% names(df), "psnu_im", "other")

  #run specific reshape based on tab
  switch(type,
         "psnu_im" = reshape_psnuim(df),
         "other" = reshape_tab(df))
}



#' Reshape Data Pack Tab Long
#'
#' This function limits the columns from a target tab (non PSNUxIM) to extract
#' data and reshapes it long, so that it is tidy and more usable. This function
#' also splits out the PSNU uid from the PSNU column.
#'
#' @param df data frame from import_dp()
#' @family reshape
#' @export

reshape_tab <- function(df){

  #reshape long and remove blank rows
  df <- df %>%
    tidyr::pivot_longer(dplyr::matches("(T|T_1|R)$"),
                        names_to = "indicator_code",
                        values_drop_na = TRUE) %>%
    dplyr::rename_all(tolower) %>%
    dplyr::filter(value != 0)

  #change values to double
  suppressWarnings(
    df <- dplyr::mutate(df, value = as.numeric(value))
  )

  #identify type and clean indicator_code
  df <- df %>%
    dplyr::mutate(data_type = dplyr::case_when(stringr::str_detect(indicator_code, "(SUBNAT|VL_SUPPRESSED.T)") ~ "SUBNAT",
                                               stringr::str_detect(indicator_code, "(POP_EST|PLHIV|HIV_PREV|KP_ESTIMATES)") ~ "IMPATT",
                                               TRUE ~ "MER"),
                  data_type = as.character(data_type))

  #extract PSNU UID from PSNU column
  df <- split_psnu(df)

  return(df)

}



#' Reshape Data Pack Long
#'
#' This function limits the columns from the PSNUxIM tab and reshapes it long,
#' so that it is more usable. Three values columns are created in the output -
#' datapacktarget, value, share. This function also splits out the PSNU uid
#' from the PSNU column.
#'
#' @param df data frame from import_dp()
#' @family reshape
#' @export

reshape_psnuim <- function(df){

  #rename lower
  df <- dplyr::rename_all(df, tolower)

  #identify all key meta data columns to keep
  key_cols <- c("psnu","indicator_code", "age", "sex", "keypop", "datapacktarget")

  #check if all columns exist
  if(length(setdiff(key_cols, names(df))) > 0)
    stop(paste("PSNUxIM tab is missing one or more columns:", paste(length(setdiff(key_cols, names(df))), collapse = ", ")))

    #rename dedup columns
    df <- df %>%
      dplyr::rename_with(~stringr::str_replace(., "deduplicated (dsd|ta) rollup.*", "dedup_\\1_value"))

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
  df <- split_psnu(df)

  return(df)
}
