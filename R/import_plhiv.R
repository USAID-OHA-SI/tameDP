#' Import PLHIV and current on ART from COP19 Datapacks
#'
#' @param filepath cop19 datapack in *.xlsx format
#'
#' @export
#'
#' @importFrom magrittr %>%
import_plhiv <- function(filepath){

  ou <- grab_ou(filepath)

  df <- readxl::read_excel(filepath,
                           sheet = "Epi Cascade I",
                           skip = 4)

  df <- df %>%
    dplyr::select(psnu = PSNU,
                  age = Age,
                  agecoarse = AgeCoarse,
                  sex = Sex,
                  population = `POP_EST.NA.Age/Sex.20T`,
                  PLHIV = `PLHIV.NA.Age/Sex/HIVStatus.20T`,
                  prevalence = `HIV_PREV.NA.Age/Sex/HIVStatus.20T`,
                  current_ART = `TX_CURR_SUBNAT.N.Age/Sex/HIVStatus.20T`) %>%
    dplyr::mutate(prevalence = round(prevalence, 2)) %>%
    dplyr::mutate_at(dplyr::vars(population, PLHIV, current_ART), round, 0) %>%
    tidyr::gather(indicator, val, population:current_ART) %>%
    dplyr::filter(val != 0) %>%
    tidyr::separate(psnu, c("psnu", "psnuuid"), sep = " \\(") %>%
    dplyr::mutate(psnuuid = stringr::str_remove(psnuuid, "\\)"))


  df <- df %>%
    dplyr::mutate(operatingunit = ou)

}
