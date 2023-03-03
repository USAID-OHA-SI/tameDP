#' Is the filepath correct for the Target Setting Tool
#'
#' @param filepath filepath of Target Setting Tool
#' @family validation
#' @export

is_file <- function(filepath){

  file.exists(filepath)

}



#' Check if a sheet exits in Target Setting Tool
#'
#' @param filepath filepath of Target Setting Tool
#' @param tab sheet to check in Target Setting Tool, "PSNUxIM" (default)
#' @family validation
#' @export

is_sheet <- function(filepath, tab = "PSNUxIM"){

  #does PSNUxIM/Cascade tab exist?
  tab %in% readxl::excel_sheets(filepath)

}



#' Check if the filepath is .xls or .xlsx
#'
#' @param filepath filepath of COP Target Setting Tool
#' @family validation
#' @export

is_xls <- function(filepath){

  #extension of the DP file
  ext <- tools::file_ext(filepath)

  #acceptable formats
  okay_formats <- c("xls", "xlsx")

  #check if filepath is oka
  ext %in% okay_formats

}



#' Check if computer has internet connection
#' @family validation
#' @export

no_connection <- function(){

  if(!curl::has_internet())
    stop("No internet connection. Cannot access offical names & rename.")
}


#' Return Tab
#'
#' Identify which tab to import based on what you want to use - PSNUxIM, PLHIV,
#' or ALL. You can also provide a specific tab name that matches the Target Setting Tool
#'
#' @param type dataset to extract "PSNUxIM", "PLHIV", "ALL", or a specific tab
#'
#' @return tabs to import
#' @export

return_tab <- function(type){

  dp_tabs <- c("Cascade",
               "PMTCT",
               "EID",
               "TB",
               "VMMC",
               "KP",
               "HTS",
               "CXCA",
               "HTS_RECENT",
               "TX_TB_PREV",
               "PP",
               "OVC",
               "GEND",
               "AGYW",
               "PrEP",
               "KP_MAT")

  if(type == "PSNUxIM"){
    t <- "PSNUxIM"
  } else if(type == "PLHIV"){
    t <- "Cascade"
  } else if(type == "ALL"){
    t <- dp_tabs
  } else if(type %in% dp_tabs){
    t <- type
  } else {
    stop("Not a valid type/tab provided")
  }

  return(t)

}


#' Apply Fiscal Year
#'
#' Apply fiscal year to each row, using the T or T_1 or R in `indicator_code` to
#' determine whether it's the current or  a prior fiscal year. The fiscal year
#' can be identified dynamically through `grab_info()`.
#'
#' @param df DP dataframe to apply fiscal year to
#' @param year fiscal year, derived from `grab_info(filepath, "year")`
#'
#' @return data frame with fiscal year
#' @export

apply_fy <- function(df, year){

  df <- df %>%
    dplyr::mutate(fiscal_year =
                    dplyr::case_when(stringr::str_detect(indicator_code, "\\.(T_1)$") ~ year-1,
                                     stringr::str_detect(indicator_code, "\\.(T2)$") ~ year+1,
                                     stringr::str_detect(indicator_code, "\\.R$") ~ year-2,
                                     TRUE ~ year)
    )

  return(df)
}


#' Identify Prioritization
#'
#' Pull from the prioritization tab to have a table of PSNU prioritization for the
#' current COP.
#'
#' @param filepath file path to the Target Setting Tool importing, must be .xlsx
#'
#' @return dataframe from the Prioritization tab
#' @export
#' @family prioritization

grab_prioritization <- function(filepath){
  import_dp(filepath, "Prioritization") %>%
    split_psnu() %>%
    dplyr::select(psnuuid, snuprioritization)
}

#' Apply Prioritization
#'
#' Join the new COP prioritization onto the target data frame.
#'
#' @param filepath file path to the Target Setting Tool importing, must be .xlsx
#'
#' @return df Target Setting Tool data frame
#' @return df_prioritization dataframe from `grab_prioritization()`
#' @export
#' @family prioritization

apply_prioritization <- function(df, df_prioritization){
  df %>%
    dplyr::left_join(df_prioritization, by = c("psnuuid")) %>%
    dplyr::relocate(snuprioritization, .after = "psnuuid")
}



#' Identify SNU1 associated with PSNU
#'
#' Pull SNU1 from the prioritization tab to have a table to align/apply with the
#' PSNUxIM tab
#'
#' @param filepath file path to the Target Setting Tool importing, must be .xlsx
#'
#' @return dataframe from the Prioritization tab
#' @export
#' @family snu1

grab_snu1 <- function(filepath){
  import_dp(filepath, "Prioritization") %>%
    split_psnu() %>%
    dplyr::select(snu1, psnuuid)
}

#' Apply SNU1 to dataframe
#'
#' Join the SNU1 onto the PSNUxIM data frame.
#'
#' @param filepath file path to the Target Setting Tool importing, must be .xlsx
#'
#' @return df Target Setting Tool data frame
#' @return df_snu1 dataframe from `grab_snu1()`
#' @export
#' @family snu1

apply_snu1 <- function(df, df_snu1){
  if(!"snu1" %in% names(df)){
    df <- df %>%
      dplyr::left_join(df_snu1, by = c("psnuuid")) %>%
      dplyr::relocate(snu1, .before = "psnu")
  }
  return(df)
}


#' Apply Source File Name and Date Stamp
#'
#' This function applies metadata from the source file to the tidied dataset
#' including the file name, last modified date, and
#'
#' @param df data frame read in and reshaped by import_dp and reshape_dp
#' @param filepath file path to the Target Setting Tool importing, must be .xlsx
#'
#' @return new columns in df with source information
#' @export

apply_stamps <- function(df, filepath){

  src_name <- basename(filepath)
  src_processed <- Sys.time()
  # src_modified <- file.info(filepath)$mtime #this resets with download

  df %>%
    dplyr::mutate(source_name = src_name,
                  # source_lastmodified = src_modified,
                  source_processed = src_processed)

}


#' @title Generate Testing data set for indicator codes
#'
#' @param filepath Excel based Target Setting Tool
#' @param dtype    Data set type, default is set fo indicator codes
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#'
#' file_tast <- "<cntry-file-path>.xlsx"
#'
#' file_tast %>%
#'  create_datasets(type = "indicators") %>%
#'  clean_indicators()
#'
#' file_tast %>%
#'  create_datasets(type = "orgunits") %>%
#'  split_psnu()
#' }
#'
create_datasets <- function(filepath, dtype = c("indicators", "orgunits")) {

  t <- match.arg(type)

  src_shts <- c("Cascade",
                "PMTCT",
                "EID",
                "TB",
                "VMMC",
                "KP",
                "HTS",
                "CXCA",
                "HTS_RECENT",
                "TX_TB_PREV",
                "PP",
                "OVC",
                "GEND",
                "AGYW",
                "PrEP",
                "KP_MAT")

  # TaST Data
  df_ref <- readxl::excel_sheets(filepath) %>%
    intersect(src_shts) %>%
    purrr::map_dfr(function(.sht) {

      ctypes <- match_col_type(filepath = filepath,
                               tab = .sht,
                               pattern = "(row_header|target|past)")

      cnames <- readxl::read_excel(
        path = filepath,
        sheet = .sht,
        skip = 13,
        col_types = "text",
        .name_repair = "minimal")

      cnames <- cnames[, which(ctypes == TRUE)]

      cnames <- cnames %>%
        tidyr::pivot_longer(dplyr::matches("(T|T_1|T2|R)$"),
                            names_to = "indicator_code",
                            values_drop_na = TRUE) %>%
        dplyr::rename_all(tolower) %>%
        dplyr::mutate(source = .sht) %>%
        dplyr::relocate(source, .before = 1)
    })

  # Refrence datasets
  if (t == "indicators") {

    df_ref %>%
      select(source, indicator_code, age, sex, keypop) %>%
      mutate(indicator_code_ref = indicator_code,
             keypop_ref = keypop) %>%
      relocate(indicator_code_ref, .after = source) %>%
      relocate(keypop_ref, .after = indicator_code_ref) %>%
      distinct_all()

  } else if (t == "orgunits") {

    df_ref %>%
      dplyr::select(psnu_ref = psnu) %>%
      dplyr::mutate(psnu = psnu_ref) %>%
      dplyr::distinct_all()

  } else {
    usethis::ui_stop("ERROR - Invalid value for parameter type")
  }
}


