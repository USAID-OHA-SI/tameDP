#' Table of indicators and their disaggs
#'
#' A dataset containing the mapping between MER/SUBNAT/IMPATT indicators from
#' the Target Setting Tool and their official disaggregates in DATIM from FY23/
#' COP22 targets.
#'
#' @format A data frame with 57 rows and 4 variables:
#' \describe{
#'   \item{indicator}{MER indicator name}
#'   \item{numeratordenom}{designates whether the indicator type}
#'   \item{standardizeddisaggregate}{indicator disaggregation, eg Age/Sex/HIVStatus}
#'   \item{kp_disagg}{whether the disaggregation is for Key Populations}
#' }
#' @source \url{https://datim.zendesk.com/hc/en-us/articles/360001143166-DATIM-Data-Entry-Form-Screen-Shot-Repository}
"mer_disagg_mapping"


#' Current Table of PEPFAR Operating Units and Counties
#'
#' A dataset containing the mapping countries and operating units. Most
#' countries are also Operating Units, expect for those in regional programs.
#'
#' @format A data frame with 51 rows and 2 variables:
#' \describe{
#'   \item{operatingunit}{PEPFAR Operating Unit (countries + 3 regional programs)}
#'   \item{country}{PEPFAR Country Name}
#' }
#' @source \url{https://final.datim.org/api/organisationUnits}
"ou_ctry_mapping"
