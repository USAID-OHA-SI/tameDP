.onLoad <- function (libname, pkgname)
{
  # make data set names global to avoid CHECK notes
  utils::globalVariables ("indicatorcode")
  utils::globalVariables ("indicator")
  utils::globalVariables ("otherdisaggregate")
  utils::globalVariables ("fy2020_targets")
  utils::globalVariables ("code")
  utils::globalVariables ("partner")
  utils::globalVariables ("mechanism")
  utils::globalVariables ("ou")
  utils::globalVariables ("agency")
  utils::globalVariables ("implementingmechanismname")
  utils::globalVariables ("operatingunit")
  utils::globalVariables ("fundingagency")
  utils::globalVariables ("mechanismid")
  utils::globalVariables ("primepartner")

  invisible ()
}
