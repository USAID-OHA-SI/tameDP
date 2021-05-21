#' Import PLHIV and current on ART from COP20 Datapacks
#'
#' @param filepath cop20 datapack in xlsx format
#'
#' @export

import_plhiv <- function(filepath){

  ou <- grab_cntry(filepath)

  df <- readxl::read_excel(filepath,
                           sheet = "Cascade",
                           skip = 13,
                           col_types = "text") %>%
    dplyr::rename_all(tolower)

  df <- df %>%
    dplyr::select(snu1,
                  psnu,
                  age,
                  sex,
                  pop_est.t_1,
                  plhiv.t_1,
                  hiv_prev.t_1,
                  tx_curr_subnat.t_1,
                  vl_suppressed.t_1) %>%
    tidyr::gather(indicator, targets, pop_est.t_1:vl_suppressed.t_1) %>%
    dplyr::mutate(targets = as.numeric(targets),
                  fiscal_year = 2022,
                  indicator = indicator %>%
                    stringr::str_remove(".t_1") %>%
                    toupper %>%
                    dplyr::recode("VL_SUPPRESSED" = "VL_SUPPRESSION_SUBNAT")) %>%
    dplyr::filter(targets != 0) %>%
    split_psnu()

  df <- df %>%
    dplyr::mutate(countryname = ou)

  return(df)
}
