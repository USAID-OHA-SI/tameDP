##

install.packages("RODBC")
library(RODBC)
library(tidyverse)


#---------------------------------------------------------

#' Import SNU x IM tabs for .xlsb workbooks
#'
#' @param filepath
#'
#'
#' @export
#'
#' @importFrom magrittr %>%
get_xlsb <- function(filepath) {

con <-  RODBC::odbcConnectExcel2007(filepath)

df <- RODBC::sqlFetch(con, "SNU x IM") %>%
  dplyr::slice(4:n()) %>%
  dplyr::select(-F8, -F10) %>%
  dplyr::mutate_all(~as.character(.))


colnames(df) <- df[1, ]
df <- df[-1 ,]

RODBC::odbcCloseAll()



}




