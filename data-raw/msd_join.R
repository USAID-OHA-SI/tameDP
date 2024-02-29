tst_path <-glamr::si_path() %>%
  glamr::return_latest("Target Setting Tool_Mozambique_022224_Final_v.03_0350pm")

prep_dp(tst_path)

#READ IN MSD
msd_filepath <- glamr::si_path() %>%
  glamr::return_latest("PSNU_IM.*Mozambique.zip$")

df_final2 <- join_dp_msd(tst_path, msd_filepath)

today <- lubridate::today()
write_csv(df_final, glue::glue("data-raw/COP24_v2_moz-cop-validation-joined_{today}.csv"))




### look at Disagg maps

mer_2_7_disagg <- tibble::tribble(
  ~indicator, ~numeratordenom, ~standardizeddisaggregate, ~fiscal_year, ~kp_disagg,
  "TX_NEW",     "N",           "Age/Sex/CD4/HIVStatus",   2024,        FALSE)

#add mer 2.7 disagg changes
mer_historic_disagg_mapping_2024 <- mer_disagg_mapping %>%
  mutate(fiscal_year = 2024) %>%
  relocate(kp_disagg, .after = fiscal_year) %>%
  rbind(msd_historic_disagg_mapping) %>%
  rbind(mer_2_7_disagg)



### MSD -----------------------------------------------------------------

#READ IN MSD
  msd_filepath <- glamr::si_path() %>%
  glamr::return_latest("PSNU_IM.*Mozambique.zip$")

msd_final <- align_msd_disagg(msd_filepath, path, FALSE) %>%
  mutate(fiscal_year = as.character(fiscal_year)) %>%
  mutate(fiscal_year = str_replace(fiscal_year, "20", "FY")) %>%
  select(-c(funding_agency, mech_code))

# BIND together
df_final <- bind_rows(df_test %>% select(-c(source_processed)), msd_final)

write_csv(msd_final, glue::glue("data-raw/COP24_moz-cop-validation-msd_{today}.csv"))
write_csv(df_test, glue::glue("data-raw/COP24_moz-cop-validation-dp_{today}.csv"))





## test

df_final %>%
  filter(indicator == "TX_CURR") %>%
  group_by(fiscal_year, indicator, standardizeddisaggregate) %>%
  summarise(across(c(targets), sum, na.rm = TRUE), .groups = "drop") %>% View()




# OLD _----------------------------------------------


df_msd <- read_psd(msd_filepath) %>%
  resolve_knownissues()

#pull in DP columns (will filter to snu1 if you changed this above)
dp_cols <- df_test %>%
  names()

df_filtered <- df_msd %>%
  # filter(fiscal_year %in% c(2022, 2023)) %>% #filter to 2022 and 2023
  select(any_of(dp_cols),funding_agency, mech_code)


#join agency lookmap and mutate FY
df_filtered1 <- df_filtered %>%
  semi_join(new_mer_disagg_mapping, by = c("indicator", "numeratordenom", "standardizeddisaggregate")) %>%
  clean_indicator() %>%
  mutate(fiscal_year = as.character(fiscal_year)) %>%
  mutate(fiscal_year = str_replace(fiscal_year, "20", "FY"))

#join agency lookmap and mutate FY
# df_filtered2 <- df_filtered %>%
#   semi_join(msd_disagg_map2, by = c("indicator", "numeratordenom", "standardizeddisaggregate", "fiscal_year")) %>%
#   clean_indicator() %>%
#   mutate(fiscal_year = as.character(fiscal_year)) %>%
#   mutate(fiscal_year = str_replace(fiscal_year, "20", "FY"))

# Collapse age bands (note: this step may take a long time)
df_age_adj <- df_filtered %>%
  left_join(age_map, by = c("indicator", "ageasentered" = "age_msd")) %>%
  mutate(age_dp = ifelse(is.na(age_dp), ageasentered, age_dp)) %>%
  select(-ageasentered) %>%
  # mutate(cumulative = ifelse(is.na(cumulative), 0, cumulative)) %>%
  # mutate(targets = ifelse(is.na(cumulative), 0, cumulative)) %>%
  group_by(across(-c(cumulative, targets))) %>%
  # group_by_all() %>%
  # group_by(indicator, fiscal_year, standardizeddisaggregate, age_dp) %>%
  summarise(across(c(cumulative, targets), sum, na.rm = TRUE), .groups = "drop")

df_msd_final <- df_age_adj %>%
  select(-c(funding_agency, mech_code)) %>%
  relocate(age_dp, .after = 8) %>%
  relocate(any_of(c("cumulative", "targets")), .after = 13) %>%
  #relocate(funding_agency, .after = 15) %>%
  rename(ageasentered = age_dp)





