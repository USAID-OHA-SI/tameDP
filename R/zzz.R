.onLoad <- function (libname, pkgname)
{
  # make data set names global to avoid CHECK notes

  utils::globalVariables(
    c(".",
      "age",
      "agency",
      "code",
      "countryname",
      "data_type",
      "datapacktarget",
      "deduplicated dsd rollup (fy22)",
      "deduplicated ta rollup (fy22)",
      "disagg",
      "fiscal_year",
      "fundingagency",
      "fy",
      "fy2020_targets",
      "implementingmechanismname",
      "indicator",
      "indicator_code",
      "indicatorcode",
      "indicatortype",
      "keypop",
      "mech_code",
      "mech_name",
      "mechanism",
      "mechanismid",
      "modality",
      "numeratordenom",
      "otherdisaggregate",
      "operatingunit",
      "ou",
      "partner",
      "primepartner",
      "psnu",
      "psnuuid",
      "sex",
      "share",
      "snu1",
      "statushiv",
      "targets",
      "value")
  )

  invisible ()
}
