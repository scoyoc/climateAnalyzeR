#-- Global Variables
utils::globalVariables(c("x", "y", "label", "year", "month", "g", "value",
                         "Jan", "Annual", "element", "name"))

#-- Number Contraction
# Prints the appropriate number contraction for a given number.
number_contraction <- function(x) {
  if (is.na(x)){
    y = FALSE
  } else if (x == 11 | x == 12 | x == 13) {
    y = paste0(x, "th")
  } else if  (x - round(x, -1) == 1) {
    y = paste0(x, "st")
  } else if (x - round(x, -1) == 2) {
    y = paste0(x, "nd")
  } else if (x - round(x, -1) == 3) {
    y = paste0(x, "rd")
  } else {
    y = paste0(x, "th")
  }
  return(y)
}

#-- Glue Months
# Returns a string of months with comma's between each month.
glue_mths <- function(mths) {
  if (length(mths) == 2){
    glue::glue("{mths[1]} and {mths[2]}")
  } else {
    glue::glue("{paste(mths[1:length(mths) - 1], collapse = ', ')}, and {mths[length(mths)]}")
  }
}

#-- ggplot Theme settings
climateAnalyzeR_theme <- ggplot2::theme_bw() +
  ggplot2::theme(strip.background = ggplot2::element_rect(fill = "white"),
                 strip.text = ggplot2::element_text(hjust = 0.1),
                 axis.title.x = ggplot2::element_blank())

#-- Convert from imperial to metric
# PRCP
convert_prcp <- function(dat){
  dat = dat |>
    dplyr::mutate(dplyr::across(dplyr::contains("prcp"), ~(.x * 25.4),
                                .names = "{.col}_mm"),
                  dplyr::across(dplyr::contains("inches"), ~(.x * 25.4),
                                .names = "{.col}_mm"))
  return(dat)
}
# TEMP
convert_temp <- function(dat){
  dat = dat |>
    dplyr::mutate(dplyr::across(dplyr::contains(c("tmax", "tmin")),
                                ~((.x - 32) * (5/9)), .names = "{.col}_c"))
  return(dat)
}

#-- Rename variables
rename_vars <- function(dat){
  new_names = janitor::make_clean_names(names(dat))
  new_names = gsub("accum_snowpack", "snowpack", new_names)
  new_names = gsub("actual_evapotranspiration_mm", "aet_mm", new_names)
  new_names = gsub("accum_growing_degree_days_c", "accum_growing_deg_days_c", new_names)
  new_names = gsub("accumgrowingdegreedays", "accum_growing_deg_days_c", new_names)
  new_names = gsub("accumulated_growing_degree_days_c", "accum_growing_deg_days_c", new_names)
  new_names = gsub("d_mm", "deficit_mm", new_names)
  new_names = gsub("days_snow_mm", "daily_snow_mm", new_names)
  new_names = gsub("p_mm", "prcp_mm", new_names)
  new_names = gsub("precipitation_in", "prcp_in", new_names)
  new_names = gsub("precipitation_mm", "prcp_mm", new_names)
  new_names = gsub("precip", "prcp_mm", new_names)
  new_names = gsub("potential_evapotranspiration_mm", "pet_mm", new_names)
  new_names = gsub("snow_depth_on_ground_inches", "snow_depth_in", new_names)
  new_names = gsub("snowmelt_mm", "snow_melt_mm", new_names)
  colnames(dat) = new_names
  return(dat)
}

#-- Create error messages
missing_arg <- function(my_arg, my_mess) {
  if(missing(my_arg)){
    message(my_mess)
    stop()
  }
}

#-- Functions to pull data from http://www.climateanalyzer.org/
# comma delimited data
pull_csv <- function(my_url, skip){
  dat = suppressMessages(
    suppressWarnings(
      readr::read_csv(my_url, col_names = TRUE, na = "nan", skip = skip,
                      skip_empty_rows = TRUE)
    )
  )
  dat = dat[, !sapply(dat, function(x) sum(is.na(x))) == nrow(dat)]
  names(dat) = janitor::make_clean_names(names(dat))
  return(dat)
}

#' Child function to scrape HTML tables
#'
#' @param my_url URL
#' @param skip   rows to skip
pull_xml <- function(my_url, skip){
  dat = XML::readHTMLTable(my_url, header = FALSE, skip.rows = skip,
                           as.data.frame = TRUE, which = 1)
  my.names = as.vector(XML::readHTMLTable(my_url, which = 1)[2, ])
  colnames(dat) = my.names[my.names != ""]
  names(dat) = janitor::make_clean_names(names(dat))
  return(tibble::as_tibble(dat))
}

#' Child function to import monthly data
#'
#' @param station_id weather station id
#' @param start_year start year, YYYY
#' @param end_year   end year, YYYY
#' @param month      month number
#' @param table_type type of table, designated in parent function
#' @param norm_per   normal period (e.g., "1991-2010")
pull_monthly <- function(station_id, start_year, end_year, month, table_type,
                           norm_per){
  my_url = paste0("http://climateanalyzer.science/python/make_tables.py?station=",
                  station_id, "&year1=", start_year, "&year2=", end_year,
                  "&month=", month, "&title=", station_id,
                  "&table_type=", table_type, "&norm_per=",
                  norm_per, "&csv=true")
  dat = pull_csv(my_url, skip = 2)
  names(dat) = janitor::make_clean_names(names(dat))
  return(tibble::as_tibble(dat))
}

