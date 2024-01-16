# tameDP <img src='man/figures/logo.png' align="right" height="120" />

Imports and tidies data from the PEPFAR, Excel-based Target Setting Tool (formerly known as the Data Pack) Historic versions available back to COP19.

<!-- badges: start -->
[![R-CMD-check](https://github.com/USAID-OHA-SI/tameDP/workflows/R-CMD-check/badge.svg)](https://github.com/USAID-OHA-SI/tameDP/actions)
[![tameDP status badge](https://usaid-oha-si.r-universe.dev/badges/tameDP)](https://usaid-oha-si.r-universe.dev/tameDP)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![:name status badge](https://usaid-oha-si.r-universe.dev/badges/:name)](https://usaid-oha-si.r-universe.dev/)
<!-- badges: end -->
  

## Installation

`tameDP` is not on CRAN, so you will have to install it directly from [rOpenSci](https://usaid-oha-si.r-universe.dev/packages) or [GitHub](https://github.com/USAID-OHA-SI/) using the code found below.

``` r
## SETUP

  #install from rOpenSci
    install.packages('tameDP', repos = c('https://usaid-oha-si.r-universe.dev', 'https://cloud.r-project.org'))
    
  #alt: install from GitHub using pak
    #install.packages("pak")
    #pak::pak("USAID-OHA-SI/tameDP")
    
  #load the package
    library(tameDP)

## LIST TYPES OF STYLES INCLUDED WITH PACKAGE
  ls("package:tameDP")
```

## Use

The main function of `tameDP` is to bring import a COP Target Setting Tool into R and make it tidy. The function aggregates the fiscal year targets up to the mechanism level, imports the mechanism information from DATIM, and breaks out the data elements to make the dataset more usable. 


- Imports Target Setting Tool as tidy data frame
- Breaks up data elements stored in the indicatorCode column into distinct columns
- Cleans up the HTS variables, separating modalities out of the indicator name
- Creates a statushiv column
- Cleans and separates PSNU and PSNU UID into distinct columns
- Adds in mechanism information from DATIM, including operatingunit, funding agency, partner and mechanism name
- Removes any rows with no targets
- Allows for aggregate to the PSNU level


``` r
#load package
  library(tameDP)
  
#Target Setting Tool file path
  path <- "../Downloads/TargetSettingTool_Jupiter_20500101.xlsx"
  
#read in Target Setting Tool & tidy
 df_dp <- tame_dp(path)
 
#read in PLHIV and SUB_NAT data from the Target Setting Tool
 df_subnat <- tame_dp(path, type = "SUBNAT")
```

You can use one of the `map()` functions from `purrr` package to read in multiple Target Setting Tools and combine.

``` r
#load package
  library(purrr)

#identify all the Target Setting Tool files
  files <- list.files("../Downloads/DataPacks", full.names = TRUE)

#read in all Target Setting Toolss and combine into one data frame
  df_all <- map_dfr(.x = files,
                    .f = ~ tame_dp(.x, map_names = FALSE))
                    
#apply mech_name and primepartner names from DATIM
#you will need to provide your DATIM credentials 
  datim_user_nm <- "spower" #replace with your username
  datim_pwd <- getPass::getPass() #pop up prompting for your password
  df_all <- get_names(df_all, datim_user = datim_user_nm, datim_password = datim_pwd)
```

---

*Disclaimer: The findings, interpretation, and conclusions expressed herein are those of the authors and do not necessarily reflect the views of United States Agency for International Development. All errors remain our own.*
