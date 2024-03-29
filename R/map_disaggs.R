#' Map Standardized Disaggregate
#'
#' To align with DATIM datasets, the standardized disaggregates
#' for each indicators will be aligned to the Target Setting Tool for FY22 Targets.
#'
#' @param df dataframe from clean_indicators
#'
#' @export

map_disaggs <- function(df){

  #identify if the indicator_code contains KP
  df <- df %>%
    dplyr::mutate(kp_disagg = dplyr::case_when(indicator %in% c("KP_MAT", "KP_MAT_SUBNAT") ~ FALSE,
                                               stringr::str_detect(indicator_code, "KP") ~ TRUE,
                                               TRUE ~ FALSE))

  #ensure datatypes are correct
  df <- df %>%
    dplyr::mutate(dplyr::across(c(indicator, numeratordenom), as.character))

  #map the MER disaggregates onto the dataset
  df <- df %>%
    dplyr::left_join(tameDP::mer_disagg_mapping,
                     by = c("indicator", "numeratordenom", "kp_disagg"))

  #adjust PrEP_CT
  df <- df %>%
    dplyr::mutate(indicator = ifelse(indicator == "PrEP_CT.TestResult", "PrEP_CT", indicator))

  #adjust OVC disagg (since multiple) and clean up otherdisagg
  df <- df %>%
    dplyr::mutate(standardizeddisaggregate =
                    dplyr::case_when(indicator == "OVC_SERV" & otherdisaggregate == "DREAMS" ~ "Age/Sex/DREAMS",
                                     indicator == "OVC_SERV" & otherdisaggregate == "Prev" ~ "Age/Sex/Preventive",
                                     indicator == "OVC_SERV" & ageasentered == "18+" ~ "Age/Sex/ProgramStatusCaregiver",
                                     indicator == "OVC_SERV" ~ "Age/Sex/ProgramStatus",
                                     TRUE ~ standardizeddisaggregate),
                  otherdisaggregate =
                    dplyr::case_when(indicator == "OVC_SERV" & otherdisaggregate == "Active" ~ "Active",
                                     indicator == "OVC_SERV" & otherdisaggregate == "Grad" ~ "Graduated",
                                     indicator == "OVC_SERV" ~ NA_character_,
                                     TRUE ~ otherdisaggregate))

  return(df)
}
