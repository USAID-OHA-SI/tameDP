.onLoad <- function (libname, pkgname)
{

  if(requireNamespace("gagglr", quietly = TRUE))
    gagglr::oha_check("tameDP", suppress_success = TRUE)

  # make data set names global to avoid CHECK notes

  utils::globalVariables(
    c(".",
      "ageasentered",
      "agency",
      "code",
      "country",
      "countryname",
      "cumulative",
      "data_type",
      "datapacktarget",
      "dedup_unk_share",
      "dedup_unk_value",
      "deduplicated dsd rollup (fy22)",
      "deduplicated ta rollup (fy22)",
      "fiscal_year",
      "funding_agency",
      "fy",
      "fy2020_targets",
      "IMPATT.PRIORITY_SNU.T",
      "implementingmechanismname",
      "ind_exclude",
      "indicator",
      "indicator_code",
      "indicatorcode",
      "indicatortype",
      "keypop",
      "kp_disagg",
      "mech_code",
      "mech_name",
      "mechanism",
      "mechanismid",
      "mer_disagg_mapping",
      "modality",
      "numeratordenom",
      "otherdisaggregate",
      "operatingunit",
      "ou",
      "ou_ctry_mapping",
      "partner",
      "prime_partner_name",
      "PRIORITY_SNU.translation",
      "psnu",
      "PSNU",
      "psnuuid",
      "rollup",
      "sex",
      "share",
      "snu1",
      "SNU1",
      "snu1uid",
      "snuprioritization",
      "standardizeddisaggregate",
      "statushiv",
      "targets",
      "value",
      "value_type",
      "msd_historic_disagg_mapping")
  )

  invisible ()
}
