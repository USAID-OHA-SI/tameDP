% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/limit_datatype.R
\name{limit_datatype}
\alias{limit_datatype}
\title{Limit Dataset Type}
\usage{
limit_datatype(df, type)
}
\arguments{
\item{df}{data frame read in and reshaped by import_dp and reshape_dp}

\item{type}{dataset type, either "MER" or "PLHIV"}
}
\value{
data frame limited to either MER or SUBNAT data
}
\description{
This function limits the output of the Target Setting Tool data to either MER or
SUBNAT (e.g. PLHIV, TX_CURR_SUBNAT) data. It will not be run if processing
the PSNUxIM tab since that does not include any SUBNAT data.
}
