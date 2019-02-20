# tameDP

Import IMxSNU targets from COP19 Data Pack & make tidy/usable

## Installation

You can install the released version of tameDP from GitHub with:

``` r
install.packages("devtools")

devtools::install_github("USAID-OHA-SI/tameDP")
```

## Use

The main function of `tameDP` is to bring import a COP19 Data Pack into R and make it tidy. The function aggregates the FY20 targets up to the mechanism level, imports the mechanism information from DATIM, and breaks out the data elements to make the dataset more usable. 

**NOTE: The user MUST convert the format from .xlsb to .xls for the function to be able to import the data pack** 

``` r
#DP file path
  path <- "C:/Users/achafetz/Downloads/DataPack_Malawi_02062019.xls"
  
#read in data pack
 r <- tame_dp(path)
```

