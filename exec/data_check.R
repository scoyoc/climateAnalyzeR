library(climateAnalyzeR)

station_id <- c("canyonlands_theneck", "arches")

#-- Retreive station metadata
my_station <- stations(my_stations = station_id) %>%
  dplyr::distinct()

#-- 30-year Normals
normals_30yr <- normals(my_stations = station_id) %>%
  tidyr::spread("element", "value")
annual_30yr <- normals_30yr %>%
  dplyr::filter(month == "Annual") %>%
  dplyr::mutate("TEMP_midpt" = ((TMAX - TMIN) / 2) + TMIN)
month_30yr <- normals_30yr %>%
  dplyr::filter(month %in% month.abb) %>%
  dplyr::mutate("month" = month_df$month_name) %>%
  dplyr::rename("month_name" = month,
                "prcp_30yr" = PRCP,
                "tmax_30yr" = TMAX,
                "tmin_30yr" = TMIN) %>%
  dplyr::arrange(month_name) %>%
  dplyr::mutate("prcp_accum_30yr" = cumsum(prcp_30yr),
                "temp_midpt_30yr" =((tmax_30yr - tmin_30yr) / 2) + tmin_30yr)

#-- Annual Data
annual_dat  <- import_annual(station_id = station_id,
                             start_year = min(yrs_avail, na.rm = T),
                             end_year = lubridate::year(lubridate::today()),
                             screen_blanks = 'true',
                             remove_missing = TRUE) %>%
  dplyr::select(year | contains("wy")) %>%
  dplyr::mutate("temp_midpt" = ifelse(is.na(tmax_wy) | is.na(tmin_wy), NA,
                                      ((tmax_wy - tmin_wy) / 2) + tmin_wy),
                "prcp_driest" = dplyr::min_rank(prcp_wy),
                "temp_warmest" = dplyr::min_rank(-temp_midpt),
                "tmax_warmest" = dplyr::min_rank(-tmax_wy),
                "tmin_warmest" = dplyr::min_rank(-tmin_wy),
                "prcp_depart" = prcp_wy - annual_30yr$PRCP,
                "temp_depart" = temp_midpt - annual_30yr$TEMP_midpt,
                "tmax_depart" = tmax_wy - annual_30yr$TMAX,
                "tmin_depart" = tmin_wy - annual_30yr$TMIN)

#-- Monthly Data
# Monthly weather data
mth_dat <- import_monthly(station_id = station_id,
                          start_year = min(yrs_avail, na.rm = T),
                          end_year = lubridate::year(lubridate::today())) %>%
  dplyr::left_join(month_df) %>%
  dplyr::mutate("water_yr" = ifelse(month >= 10, year +1, year)) %>%
  dplyr::arrange(water_yr, water_month) %>%
  dplyr::group_by(water_yr) %>%
  dplyr::mutate("prcp_accum" = cumsum(prcp)) %>%
  dplyr::mutate("temp_midpt" = ifelse(is.na(tmax) | is.na(tmin), NA,
                                      ((tmax - tmin) / 2) + tmin)) %>%
  dplyr::group_by(water_month) %>%
  dplyr::mutate("prcp_driest" = dplyr::min_rank(prcp),
                "temp_warmest" = dplyr::min_rank(-temp_midpt),
                "tmax_warmest" = dplyr::min_rank(-tmax),
                "tmin_warmest" = dplyr::min_rank(-tmin))

# Monthly departure
mth_depart <- import_departure(station_id = station_id,
                               min(yrs_avail, na.rm = T),
                               end_year = lubridate::year(lubridate::today())) %>%
  dplyr::left_join(month_df) %>%
  dplyr::mutate(water_yr = ifelse(month >= 10, year + 1, year)) %>%
  # filter(water_yr <= my_year) %>%
  dplyr::left_join(dplyr::left_join(mth_dat, month_30yr) %>%
                     dplyr::mutate("prcp_accum_depart" = prcp_accum -
                                     prcp_accum_30yr) %>%
                     dplyr::ungroup() %>%
                     dplyr::select(water_yr, month_name, prcp_accum_depart))


# Consolidate text references
text_refs <- my_station %>%
  dplyr::bind_cols(dplyr::filter(annual_dat, year == my_year)) %>%
  dplyr::mutate("timespan" = max(yrs_avail, na.rm = T) - min(yrs_avail, na.rm = T))

#-- Model annual trends
prcp_lm <- summary(lm(prcp_wy ~ year, data = annual_dat))$coefficients[2, 1]
temp_lm <- summary(lm(temp_midpt ~ year, data = annual_dat))$coefficients[2, 1]

#-- Small subsets for text
tmax_exceed <- dplyr::filter(mth_depart, water_yr == my_year &
                               tmax_depart > 0)$month_name
tmin_exceed <- dplyr::filter(mth_depart, water_yr == my_year &
                               tmin_depart > 0)$month_name
prcp_above <- dplyr::filter(mth_depart, water_yr == my_year &
                              prcp_pctavg > 100)$month_name
prcp_below <- dplyr::filter(mth_depart, water_yr == my_year &
                              prcp_pctavg < 100)$month_name

# Evaluate data for conditional text
# Calculate percentiles
temp_25 <- quantile(annual_dat$temp_warmest, 0.25, na.rm = TRUE)
temp_75 <- quantile(annual_dat$temp_warmest, 0.75, na.rm = TRUE)
prcp_25 <- quantile(annual_dat$prcp_depart, 0.25, na.rm = TRUE)
prcp_75 <- quantile(annual_dat$prcp_depart, 0.75, na.rm = TRUE)
# Assign condition
temp_text <- if (is.na(text_refs$temp_warmest)) {
  TRUE
} else if (text_refs$temp_warmest <= temp_25) {
  "cool"
} else if (text_refs$temp_warmest > temp_25 & text_refs$temp_warmest < temp_75){
  "avg"
} else if (text_refs$temp_warmest >= temp_75){
  "warm"
} else (FALSE)
prcp_text <- if (is.na(text_refs$prcp_depart)) {
  TRUE
} else if (text_refs$prcp_depart <= prcp_25) {
  "dry"
} else if (text_refs$prcp_depart > prcp_25 & text_refs$prcp_depart < prcp_75){
  "avg"
} else if (text_refs$prcp_depart >= prcp_75){
  "wet"
} else (FALSE)

# Error evaluation
if (temp_text == TRUE | prcp_text == TRUE) {
  error_eval <- tibble::tibble(annual_dat[, c("year", "prcp_wy",
                                              "tmax_wy", "tmin_wy")]) %>%
    dplyr::left_join(mth_dat %>%
                       dplyr::filter(is.na(prcp)) %>%
                       dplyr::group_by(year) %>%
                       dplyr::count()) %>%
    dplyr::rename("prcp_mth_na" = "n") %>%
    dplyr::left_join(mth_dat %>%
                       dplyr::filter(is.na(tmax)) %>%
                       dplyr::group_by(year) %>%
                       dplyr::count()) %>%
    dplyr::rename("tmax_mth_na" = "n") %>%
    dplyr::left_join(mth_dat %>%
                       dplyr::filter(is.na(tmin)) %>%
                       dplyr::group_by(year) %>%
                       dplyr::count()) %>%
    dplyr::rename("tmin_mth_na" = "n")
