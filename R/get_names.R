#' Import mechanism specific info from DATIM
#'
#' @param df data frame to add mechanism info to
#'
#' @export
#' @importFrom magrittr %>%

get_names <- function(df){

  #access current mechanism list posted publically to DATIM
  mech_official <- readr::read_csv("https://www.datim.org/api/sqlViews/fgUtV6e9YIX/data.csv",
                                   col_types = readr::cols(.default = "c"))

  #rename variables to match MSD and remove mechid from mech name
  mech_official <- mech_official %>%
    dplyr::select(mechanismid = code,
                  primepartner = partner,
                  implementingmechanismname = mechanism,
                  fundingagency = agency) %>%
    dplyr::mutate(implementingmechanismname = stringr::str_remove(implementingmechanismname, "0000[0|1] |[:digit:]+ - "))

  #map primepartner and mechanism names onto dataframe
  df <- dplyr::left_join(df, mech_official, by="mechanismid")

  #order variables
  df <- dplyr::select(df, fundingagency, mechanismid, primepartner, implementingmechanismname, dplyr::everything())

  return(df)
}
