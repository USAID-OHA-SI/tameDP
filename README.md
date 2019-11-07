# tameDP

Import IMxSNU targets from COP19 Data Pack & make tidy/usable

[![Travis build status](https://travis-ci.org/USAID-OHA-SI/tameDP.svg?branch=master)](https://travis-ci.org/USAID-OHA-SI/tameDP)

## Installation

You can install the released version of tameDP from GitHub with:

``` r
install.packages("devtools")

devtools::install_github("USAID-OHA-SI/tameDP")
```

## Use

The main function of `tameDP` is to bring import a COP19 Data Pack into R and make it tidy. The function aggregates the FY20 targets up to the mechanism level, imports the mechanism information from DATIM, and breaks out the data elements to make the dataset more usable. 


- Imports Data Pack as tidy data frame
- Breaks up data elements stored in the indicatorCode column into distinct columns
- Cleans up the HTS variables, separating modalities out of the indicator name
- Creates a resultstatus column
- Cleans and separates PSNU and PSNU UID into distinct columns
- Adds in mechanism information from DATIM, including operatingunit, funding agency, partner and mechanism name
- Removes any rows with no targets

**NOTE: The user MUST convert the format from .xlsb to .xlsx or .xls for the function to be able to import the data pack** 

``` r
#load package
  library(tameDP)
  
#Data Pack file path (.xls) [COP19]
  path <- "../Downloads/DataPack_Malawi_02062019.xls"
  
#read in Data Pack
 df_dp <- tame_dp(path)
```

You can use one of the `map()` functions from `purrr` package to read in multiple Data Packs and combine.

``` r
#load package
  library(purrr)

#identify all the Data Pack files
  files <- list.files("../Downloads/DataPacks", full.names = TRUE)

#read in all DPs and combine into one data frame
  df_all <- map_dfr(.x = files,
                    .f = ~ tame_dp(.x))
```

---

*Disclaimer: The findings, interpretation, and conclusions expressed herein are those of the authors and do not necessarily reflect the views of United States Agency for International Development. All errors remain our own.*
