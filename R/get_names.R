#' Import mechanism specific info from DATIM
#'
#' The Data Pack does not contain information on the mechanism (names or
#' partners). By running this function, you are connecting to DATIM's
#' SQLView file that contains the list of all current mechanisms. This requires
#' providing your DATIM credentials. If left blank in the function, you will
#' have two dialogue boxes popping up asking for your DATIM username and
#' password. If running `tame_dp()` across multiple Data Packs, it's
#' advisable to run `get_names()` on the file dataset produced by `tame_dp`.
#'
#' @param df data frame to add mechanism info to
#' @param map_names import names from DATIM (OU, mechanism, partner) associated with mech_code
#' @param psnu_lvl aggregate to the PSNU level instead of IM
#' @param cntry country, from grab_info() if not connecting to DATIM
#' @param datim_user DATIM user name (if not provided, you will be prompted with a pop up)
#' @param datim_password DATIM password (if not provided, you will be prompted with a pop up)
#'
#' @export
#'
#' @examplesIf FALSE
#' #load package
#'   library(purrr)
#' #identify all the Data Pack files
#'   files <- list.files("../Downloads/DataPacks", full.names = TRUE)
#' #read in all DPs and combine into one data frame
#'   df_all <- map_dfr(.x = files,
#'                     .f = ~ tame_dp(.x, map_names = FALSE))
#' #apply mech_name and primepartner names from DATIM
#' #you will need to provide your DATIM credentials
#'   datim_user_nm <- "spower" #replace with your username
#'   datim_pwd <- getPass::getPass() #pop up prompting for your password
#'   df_all <- get_names(df_all, datim_user = datim_user_nm, datim_password = datim_pwd)

get_names <- function(df, map_names = TRUE, psnu_lvl = FALSE, cntry,
                      datim_user, datim_password){

  if(map_names == TRUE && psnu_lvl == FALSE){

    #check internet connection
      no_connection()

    #ask for credentials if missing
    if(missing(datim_user))
      datim_user <- getPass::getPass("DATIM username")
    if(missing(datim_password))
      datim_password <- getPass::getPass("DATIM password", forcemask = TRUE)

    #change country to NA if not provided
    if(missing(cntry))
      cntry <- NA_character_

    if("countryname" %in% names(df))
      df <- dplyr::rename(df, country = countryname)

    #add country if its not in the df or its provided
    if(!"country" %in% names(df) || !is.na(cntry))
      df <- dplyr::mutate(df, country = cntry)

    #map operating unit onto data frame
    if(!"operatingunit" %in% names(df)){
      df <- df %>%
        dplyr::left_join(ou_ctry_mapping, by = "country") %>%
        dplyr::relocate(operatingunit, .before = 1)
    }

    #rename
    df <- gophr::rename_official(df, datim_user, datim_password)

    #fill operatingunitname where missing
    df <- df %>%
      dplyr::group_by(country) %>%
      tidyr::fill(operatingunit) %>%
      dplyr::ungroup()

  } else {
    df <- df %>%
      dplyr::mutate(country = {{cntry}},
                    funding_agency = NA_character_,
                    prime_partner_name = NA_character_,
                    mech_name = NA_character_) %>%
      dplyr::left_join(ou_ctry_mapping, by = "country") %>%
      dplyr::relocate(operatingunit, country, .before = 1) %>%
      dplyr::relocate(funding_agency, prime_partner_name, mech_name, .before = fiscal_year)
  }

  return(df)
}
