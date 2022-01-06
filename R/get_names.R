#' Import mechanism specific info from DATIM
#'
#' @param df data frame to add mechanism info to
#' @param map_names import names from DATIM (OU, mechanism, partner) associated with mech_code
#' @param psnu_lvl aggregate to the PSNU level instead of IM
#' @param cntry country, from grab_cntry() if not connecting to DATIM
#'
#' @export
#' @importFrom magrittr %>%

get_names <- function(df, map_names = TRUE, psnu_lvl = FALSE, cntry = NULL){

  if(map_names == TRUE && psnu_lvl == FALSE){

    #check internet connection
      no_connection()

    #access current mechanism list posted publically to DATIM
    mech_official <- readr::read_csv("https://www.datim.org/api/sqlViews/fgUtV6e9YIX/data.csv",
                                     col_types = readr::cols(.default = "c"))

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
    if(is.null(cntry))
      cntry <- NA_character_

    #add country if its not in the df or its provided
    if(!"countryname" %in% names(df) || !is.na(cntry))
      df <- dplyr::mutate(df, countryname = cntry)

    #remove vars if they exist before merging on from DATIM pull
    rm_vars <- intersect(c("primepartner", "mech_name", "operatingunit", "fundingagency"), names(df))
    df <- dplyr::select(df, -all_of(rm_vars))

    #map primepartner and mechanism names onto dataframe
    df <- dplyr::left_join(df, mech_official, by="mech_code")

    #fill operatingunitname where missing
    df <- tidyr::fill(df, operatingunit)

  } else {
    df <- df %>%
      dplyr::mutate(operatingunit = NA_character_,
                    countryname = {{cntry}},
                    fundingagency = NA_character_,
                    primepartner = NA_character_,
                    mech_name = NA_character_) %>%
      dplyr::select(operatingunit, dplyr::everything())
  }

  return(df)
}
