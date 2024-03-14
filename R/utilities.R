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
    cli::cli_abort("No internet connection. Cannot access offical names & rename.")
}


#' Return Tab
#'
#' Identify which tab to import based on what you want to use - PSNUxIM,
#' SUBNAT, or ALL (non mechanism tabs). You can also provide a specific tab
#' name that matches the Target Setting Tool
#'
#' @param type dataset to extract "PSNUxIM", "SUBNAT" (formerly "PLHIV"),
#' "ALL", or a specific tab
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
  } else if(type %in% c("PLHIV", "SUBNAT")){
    t <- "Cascade"
  } else if(type == "ALL"){
    t <- dp_tabs
  } else if(type %in% dp_tabs){
    t <- type
  } else {
    cli::cli_abort("Not a valid type/tab provided")
  }

  return(t)

}

#' Lazy PSNUxIM Tool handling
#'
#' The default import option is "ALL" for `tame_dp` which does not include
#' PSNUxIM due to the inclusion of this tab with the full TST in previous years.
#' The user will receive an error if they do not switch from the default. This
#' function switches the type argument in tame_dp from "ALL" to "PSNUxIM" to
#' avoid this problem and provides the user with both a warning and information
#' on how to fix the problem running it in the future.
#'
#' @inheritParams tame_dp
#' @param import_tabs tabs imported as a result of the intersection of
#'   return_tab() and the tabs in the TST
#'
#' @keywords internal
#' @return vector of tabs to read in
#'
lazy_psnuxim_handling <- function(filepath, type, import_tabs){
  if(length(import_tabs) == 0 && type != "ALL" && "PSNUxIM" %in% readxl::excel_sheets(filepath)){
    cli::cli_abort(c(
      'This TST appears to be a PSNUxIM file and does not include a "{type}" tab [{.arg type = {type}}]',      "i" = 'Change the {.arg filepath} to a normal TST file or set {.arg type = "PSNUxIM"}'
    ))
  }
  if(length(import_tabs) == 0 && "PSNUxIM" %in% readxl::excel_sheets(filepath)){
    import_tabs <- "PSNUxIM"
    cli::cli_warn(c(
      'This TST appears to be a PSNUxIM file and proceeding with the assumption that {.arg type = "PSNUxIM"} should have been specified instead of the default',      "i" = 'You can set {.arg type = "PSNUxIM"} to avoid this warning'
    ))
  }
  return(import_tabs)
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
#' @param df Target Setting Tool data frame
#' @param df_prioritization dataframe from `grab_prioritization()`
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
#' @param df Target Setting Tool data frame
#' @param df_snu1 dataframe from `grab_snu1()`
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



