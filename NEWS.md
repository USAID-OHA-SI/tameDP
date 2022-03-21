# tameDP 4.0.3
* Add regional operatingunit as country names (`ou_ctry_mapping`) to resolve issue with Jamaica (2022-03-21)
* Replaces old code for `get_names` to utilize `gophr::rename_official` given size complexities introduced in the past few quarters. (2022-03-15)
* Adds [`gophr`](https://usaid-oha-si.github.io/gophr/) and [`glamr`](https://usaid-oha-si.github.io/glamr/) to the package dependencies (2022-03-15) for use of `gophr::rename_official`. (2022-03-15)
* Pulls SNU1 column from Prioritization tab to apply to data frame if using PSNUxIM, which does not have a SNU1 column included in the tab. (2022-03-15)

# tameDP 4.0.2
* Resolve incorrect disaggregation for TX_PREV, HTS_TST, and HTS_TST_POS (2022-03-10)
* Include historic MER results and targets in the output dataset (2022-02-23)
* Merge prioritizations onto target dataframe (2022-02-23)

# tameDP 4.0.1
* Ensure data types are correct prior to disaggregate binding in `map_disaggs`.
* Add vignette on combining with the MSD
* Allow `tame_dp` to read in specific tabs instead of the preset "types".

# tameDP 4.0.0
* Add vignettes to the package.
* Add `ou_ctry_mapping` to align countries to their Operating Units.
* Update `tame_dp` to work with COP22 Data Packs.
* Allow `tame_dp` to read in targets from all sheets or PSNUxIM tab.
* Consolidate SUBNAT/PLHIV extract into `tame_dp` instead of separate function.
* Applied new logic for `split_psnu` introduced by errors with OPU generation
* Aligned exact DATIM target disaggregation with Data Pack data through `map_disaggs`.
* Build site and improve documentation.
