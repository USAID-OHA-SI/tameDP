#' Import SNU x IM tabs for .xlsb workbooks
#'
#' @param filepath file path to the Data Pack importing
#'
#'
#' @export
#'
#' @importFrom magrittr %>%

import_xlsb <- function(filepath) {

con <-  RODBC::odbcConnectExcel2007(filepath)

df <- RODBC::sqlFetch(con, "SNU x IM") %>%
  tibble::as_tibble() %>%
  dplyr::slice(4:dplyr::n()) %>%
  janitor::clean_names() %>%
  dplyr::select(-dplyr::starts_with("na")) %>%
  dplyr::rename_at(dplyr::vars(dplyr::starts_with("x")), ~ stringr::str_remove(.,"x")) %>%
  dplyr::mutate_all(~as.character(.))


colnames(df) <- df[1, ]
df <- df[-1 ,]

RODBC::odbcCloseAll()
return(df)


}




