#' Clean & Separate PSNU and PSNU UIDS
#'
#' @param df Data Pack data frame from tameDP
#'
#' @return
#' @export
#'

split_psnu <- function(df){
  df <- df %>%
    dplyr::mutate(psnu = stringr::str_remove_all(psnu, " \\[#(Country|SNU|DREAMS|Military)]")) %>%
    tidyr::separate(psnu, c("psnu", "psnuuid", NA), sep = " \\[|]")

  return(df)
}
