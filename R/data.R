#' Table of indicators and their disaggs
#'
#' A dataset containing the mapping between MER/SUBNAT/IMPATT indicators from
#' the data pack and their official disaggregates in DATIM for FY22 Targets.
#'
#' @format A data frame with 60 rows and 4 variables:
#' \describe{
#'   \item{indicator}{MER indicator name}
#'   \item{numeratordenom}{designates whether the indicator type}
#'   \item{standardizeddisaggregate}{indicator disaggregation, eg Age/Sex/HIVStatus}
#'   \item{kp_disagg}{whether the disaggregation is for Key Populations}
#'   ...
#' }
#' @source \url{https://datim.zendesk.com/hc/en-us/articles/360001143166-DATIM-Data-Entry-Form-Screen-Shot-Repository}
"mer_disagg_mapping"
