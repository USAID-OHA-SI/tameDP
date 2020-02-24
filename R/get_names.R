#' Import mechanism specific info from DATIM
#'
#' @param df data frame to add mechanism info to
#'
#' @export
#' @importFrom magrittr %>%

get_names <- function(df){

  if(no_connection()) {

    print("No internet connection. Cannot access offical names & rename.")

  } else {

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
  #map primepartner and mechanism names onto dataframe
  df <- dplyr::left_join(df, mech_official, by="mech_code")

  #fill operatingunitname where missing
  df <- tidyr::fill(df, operatingunit)

}
  return(df)
}
