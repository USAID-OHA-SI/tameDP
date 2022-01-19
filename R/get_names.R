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
#'   df_all <- get_names(df_all)

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

    #create a temp file location to download to and download the mech file
    temp <- tempfile(fileext = ".csv")
    httr::GET("https://www.datim.org/api/sqlViews/fgUtV6e9YIX/data.csv",
                httr::authenticate(datim_user, datim_password),
                httr::write_disk(temp, overwrite = TRUE) #, httr::timeout(60)
              )

    #access current mechanism list
    mech_official <- readr::read_csv(temp, col_types = readr::cols(.default = "c"))

    #rename variables to match MSD and remove mechid from mech name
    mech_official <- mech_official %>%
      dplyr::select(mech_code = code,
                    primepartner = partner,
                    mech_name = mechanism,
                    operatingunit = ou,
                    fundingagency = agency) %>%
      dplyr::mutate(mech_name = stringr::str_remove(mech_name, "0000[0|1] |[:digit:]+ - "))

    #remove award information from mech_name
    mech_official <- mech_official %>%
      dplyr::mutate(mech_name = stringr::str_remove(mech_name,
                                                      "^(720|AID|GH(AG|0)|U[:digit:]|NUGGH|UGH|U91|CK0|HT0|N[:digit:]|SGY||NU2|[:digit:]NU2|1U2).* - "))

    #change country to NA if no provided
    if(missing(cntry))
      cntry <- NA_character_

    #add country if its not in the df or its provided
    if(!"countryname" %in% names(df) || !is.na(cntry))
      df <- dplyr::mutate(df, countryname = cntry)

    #remove vars if they exist before merging on from DATIM pull
    rm_vars <- intersect(c("primepartner", "mech_name", "operatingunit", "fundingagency"), names(df))
    df <- dplyr::select(df, -dplyr::all_of(rm_vars))

    #map primepartner and mechanism names onto dataframe
    df <- dplyr::left_join(df, mech_official, by="mech_code")

    #fill operatingunitname where missing
    df <- tidyr::fill(df, operatingunit)

  } else {
    df <- df %>%
      dplyr::mutate(countryname = {{cntry}},
                    fundingagency = NA_character_,
                    primepartner = NA_character_,
                    mech_name = NA_character_) %>%
      dplyr::left_join(ou_ctry_mapping, by = "countryname") %>%
      dplyr::select(operatingunit, dplyr::everything())
  }

  return(df)
}
