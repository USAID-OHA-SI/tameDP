#' Import PLHIV and current on ART from COP20 Datapacks
#'
#' @param filepath cop19 datapack in xlsx format
#'
#' @export
#'
#' @importFrom magrittr %>%
import_plhiv <- function(filepath){

  ou <- grab_ou(filepath)

  df <- readxl::read_excel(filepath,
                           sheet = "Epi Cascade I",
                           skip = 13,
                           col_types = "text") %>%
    dplyr::rename_all(tolower)

  df <- df %>%
    dplyr::select(psnu,
                  age,
                  sex,
                  population = `pop_est.na.age/sex.t`,
                  PLHIV = `plhiv.na.age/sex/hivstatus.t`,
                  prevalence = `hiv_prev.na.age/sex/hivstatus.t`,
                  current_ART = `tx_curr_subnat.n.age/sex/hivstatus.t`,
                  vl_suppressed = `tx_curr_subnat.n.age/sex/hivstatus.t`) %>%
    tidyr::gather(indicator, val, population:vl_suppressed) %>%
    dplyr::mutate(val = as.numeric(val)) %>%
    dplyr::filter(val != 0) %>%
    tidyr::separate(psnu, c("psnu", "psnuuid"), sep = " \\[#SNU]") %>%
    mutate(psnuuid = stringr::str_remove_all(psnuuid, "\\[|\\]"))

  df <- df %>%
    dplyr::mutate(operatingunit = ou)

  return(df)
}
