#' Align MSD extract to disaggregates in Target Setting Tool
#'
#' This function pulls in a PSNUxIM MSD and datapack filepath to align the MSD extract
#' to the indicators and disaggregates in the datapack, as well as historic results and targets.
#' This function also addresses when OUs set targets at a higher level than PSNU for alignment.
#'
#' @param msd_path path to PSNUxIM extract
#' @param dp_path path to TST
#' @param raised_prioritization logical that is TRUE if OU is setting targets at a raised prioritization level (i.e. SNU1 instead of PSNU)
#'
#' @export
#'
#' @examples
#'  \dontrun{
#'    df_msd <- align_msd_disagg(msd_path = msd_path, dp_path = dp_path, raised_prioritization = FALSE)
#' }
#'

align_msd_disagg <- function(msd_path, dp_path, raised_prioritization = FALSE) {

  #import MSD
  df_msd <- gophr::read_psd(msd_path) %>%
  gophr::resolve_knownissues()

  #run tameDP
  dp_cols <- tameDP::tame_dp(dp_path) %>%
    names()

  #if targets set at SNU1 level, grab the SNu1 and SNU1uid from MSD
  if (raised_prioritization == TRUE) {
    dp_cols <- replace(dp_cols, c(3,4), c("snu1", "snu1uid"))
  }

  #semi join with MSD mapping to limit to MSD disaggs
  df_align <- df_msd %>%
    dplyr::select(tidyr::any_of(dp_cols),funding_agency, mech_code) %>%
    dplyr::semi_join(msd_historic_disagg_mapping, by = c("indicator", "numeratordenom", "standardizeddisaggregate")) %>%
    gophr::clean_indicator()

  #if targets set at SNU1 level, rename SNU columsn back to psnu for join with dp
  if (raised_prioritization == TRUE) {
    df_align <- df_align %>%
      dplyr::rename(psnu = snu1,
                    psnuuid = snu1uid)
  }

  return(df_align)

}


