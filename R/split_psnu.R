#' Clean & Separate PSNU and PSNU UIDS
#'
#' This function removes the contacanated data contained in the same cell. The
#' psnu column in the Data Pack contains both the psnu, psnuuid, and meta data
#' on type - Country/SNU/DREAMS/Military. `split_psnu` breaks out psnu and
#' psnuuid into two columns and removes any other extraneous information.
#'
#' @param df Data Pack data frame from tameDP
#'
#' @return
#' @export

split_psnu <- function(df){

  df <- df %>%
    dplyr::mutate(psnu = psnu %>%
                    stringr::str_remove("^.*(?<=\\>)") %>%
                    stringr::str_remove_all(" \\[#(Country|SNU|DREAMS|Military)]") %>%
                    stringr::str_remove("(?<=\\]).*")) %>%
    tidyr::separate(psnu, c("psnu", "psnuuid", NA), sep = " \\[|]", fill = "right")

  return(df)
}
