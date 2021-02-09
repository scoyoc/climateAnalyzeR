# Convert from imperial to metric
convert_prcp <- function(dat){
  dat = dat %>%
    dplyr::mutate(dplyr::across(dplyr::contains("PRCP"), ~(. * 25.4),
                                .names = "{.col}_mm"),
                  dplyr::across(dplyr::contains("Inches"), ~(. * 25.4),
                                .names = "{.col}_mm"))
  return(dat)
}

# Convert from imperial to metric
convert_temp <- function(dat){
  dat = dat %>%
    dplyr::mutate(dplyr::across(dplyr::contains(c("TMAX", "TMIN")),
                                ~(. - 32 * (5/9)), .names = "{.col}_C"))
  return(dat)
}

# Rename variables
rename_vars <- function(dat){
  new_names = tolower(colnames(dat))
  new_names = tools::toTitleCase(new_names)
  new_names = gsub(" ", "", new_names, fixed = TRUE)
  new_names = gsub("(", "_", new_names, fixed = TRUE)
  new_names = sub("_$", "", new_names)
  new_names = sub(")$", "", new_names)
  new_names = gsub("Precipitation", "PRCP", new_names)
  new_names = gsub("Tmax", "TMAX", new_names)
  new_names = gsub("Tmin", "TMIN", new_names)
  new_names = gsub("tmax", "TMAX", new_names)
  new_names = gsub("tmin", "TMIN", new_names)
  new_names = gsub("Tmean", "TMEAN", new_names)
  new_names = gsub("precip", "PRCP", new_names)
  new_names = gsub("p_Mm", "PRCP_mm", new_names)
  new_names = gsub("PotentialEvapotranspiration", "PET", new_names)
  new_names = gsub("Pet", "PET", new_names)
  new_names = gsub("ActualEvapotranspiration", "AET", new_names)
  new_names = gsub("Aet", "AET", new_names)
  new_names = gsub("Days_snow", "DailySnow", new_names)
  new_names = gsub("Accum_snowpack", "Snowpack", new_names)
  new_names = gsub("Water_input_to_soil", "WaterInputtoSoil", new_names)
  new_names = gsub("Soil_water", "SoilWater", new_names)
  new_names = gsub("d_Mm", "Deficit_mm", new_names)
  new_names = gsub("AccumGrowingDegreeDays", "AccumulatedGrowingDegreeDays", new_names)
  new_names = gsub("Mm", "mm", new_names)
  new_names = gsub("_c", "_C", new_names, fixed = T)
  colnames(dat) = new_names
  return(dat)
}

# Create error messages
missing_arg <- function(my_arg, my_mess) {
  if(missing(my_arg)){
    message(my_mess)
    stop()
  }
}

#-- Functions to pull data from ClymateAnalyser.org
# comma delimited data
pull_csv <- function(my_url, skip){
  dat = suppressMessages(
    suppressWarnings(
      readr::read_csv(my_url, col_names = TRUE, na = "nan", skip = skip,
                      skip_empty_rows = TRUE)
    )
  )
  dat = dat[, !sapply(dat, function(x) sum(is.na(x))) == nrow(dat)]
  return(dat)
}

# scrape HTML tables
pull_xml <- function(my_url, skip){
  dat = XML::readHTMLTable(my_url, header = FALSE, skip.rows = skip,
                           as.data.frame = TRUE, which = 1)
  my.names = as.vector(XML::readHTMLTable(my_url, which = 1)[2, ])
  colnames(dat) = my.names[my.names != ""]
  return(tibble::as_tibble(dat))
}
