% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tame_dp.R
\name{tame_dp}
\alias{tame_dp}
\title{Import SNUxIM data from Data Pack and Clean}
\usage{
tame_dp(filepath, map_names = TRUE, psnu_lvl = FALSE)
}
\arguments{
\item{filepath}{file path to the Data Pack importing, must be .xlsx}

\item{map_names}{import names from DATIM (OU, mechanism, partner) associated with mech_code}

\item{psnu_lvl}{aggregate to the PSNU level instead of IM}
}
\description{
Import SNUxIM data from Data Pack and Clean
}
\examples{
\dontrun{
#DP file path
  path <- "../Downloads/DataPack_Jupiter_20200218.xlsx"
#read in data pack
  df_dp <- tame_dp(path) }
}
