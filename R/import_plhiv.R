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
                           sheet = "Spectrum",
                           col_types = "text") %>%
    dplyr::rename_all(tolower)

  df <- df %>%
    dplyr::select(psnu,
                  psnu_uid,
                  area_id,
                  age,
                  sex,
                  calendar_quarter,
                  value,
                  age_sex_rse,
                  district_rse) %>%
    dplyr::mutate(value = as.numeric(value))


  df <- df %>%
    dplyr::mutate(operatingunit = ou) %>%
    dplyr::relocate(operatingunit, .before = psnu)

  return(df)
}
