#' Import monthly data weather from ClimateAnalyzer.org into R
#'
#' @param station The character string of the station name.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param month The month number (i.e., 1 for January through 12 for December)
#'     or 'all' for all months.
#' @param table_type A character sting for the type of table to produce.
#' @param norm_per A character string for the 30-year normalization period.
#'
#' @return A \code{\link[tibble]{tibble}}.
#'
#' @examples
#' # Import monthly departures
#' import_monthly("natural_bridges_nm", 2000, 2020, month = "all",
#'                table_type = "straight", norm_per = '1981-2010')
#' # Import monthly precipitation and temperature data
#' import_monthly("canyonlands_theneedle", 2000, 2020, month = "all",
#'                table_type = "30dep", norm_per = 'null')
#'
#' # Import monthly departures using the import_monthly_depart() wrapper.
#' import_monthly_depart('natural_bridges_nm', 2000, 2010)
#' import_monthly_depart('natural_bridges_nm', 2000, 2010, convert = TRUE)
#'
#' # Import monthly precipitation and temperature data using the
#' # import_montly_wx() wrapper.
#' import_montly_wx('canyonlands_theneedle', 2000, 2010, convert = TRUE)
#' # Import weather data for June
#' import_montly_wx('hovenweep_utah', 2000, 2010, month = 6)
#' @export
#' @rdname import_monthly
#' @param station The character string of the station name.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param month The month number (i.e., 1 for January through 12 for December)
#'     or 'all' for all months.
#' @param norm_per A character string for the 30-year normalization period.
#' @param convert Logical. If TRUE, data are precipitation and temperature
#'     values are converted to metric. These converted values are included as
#'     additional columns in the data frame denoted by "_mm" or "_C". Default is
#'     FALSE.
import_monthly_depart <- function(station, start_year, end_year,
                                  month = 'all', norm_per = '1981-2010',
                                  convert = FALSE){
  dat = import_monthly(station, start_year, end_year, month = month,
                 table_type = "30dep", norm_per = norm_per) %>%
    stats::na.omit()
  colnames(dat) = c("Year", "Month", "PRCP_pctavg", "TMAX_depart", "TMIN_depart")
  dat = dat  %>%
    dplyr::mutate("Year" = as.numeric(Year),
                  "Month" = as.numeric(Month)) %>%
    tidyr::gather("Var", "Value", 3:ncol(.)) %>%
    tidyr::spread("Month", "Value", fill = NA) %>%
    tidyr::gather("Month", "Value", 3:ncol(.), convert = TRUE) %>%
    tidyr::spread("Var", "Value", fill = NA) %>%
    dplyr::arrange("Year", "Month")

  # Convert to metric
  if (convert == TRUE){
    dat = convert_temp(dat)
  }

  return(tibble::as_tibble(dat))
}

#' @export
#' @rdname import_monthly
#' @param station The character string of the station name.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param month The month number (i.e., 1 for January through 12 for December)
#'     or 'all' for all months.
#' @param convert Logical. If TRUE, data are precipitation and temperature
#'     values are converted to metric. These converted values are included as
#'     additional columns in the data frame denoted by "_mm" or "_C". Default is
#'     FALSE.
import_montly_wx <- function(station, start_year, end_year, month = 'all',
                             convert = FALSE){
  dat = import_monthly(station, start_year, end_year, month,
                       table_type = "straight", norm_per = 'null') %>%
    stats::na.omit()
  colnames(dat) = c("Year", "Month", "PRCP", "TMAX", "TMIN")
  dat = dat  %>%
    dplyr::mutate("Year" = as.numeric(Year),
                  "Month" = as.numeric(Month)) %>%
    tidyr::gather("Var", "Value", 3:ncol(.)) %>%
    tidyr::spread("Month", "Value", fill = NA) %>%
    tidyr::gather("Month", "Value", 3:ncol(.), convert = TRUE) %>%
    tidyr::spread("Var", "Value", fill = NA) %>%
    dplyr::arrange("Year", "Month")

  # Convert to metric
  if (convert == TRUE){
    dat = convert_prcp(dat)
    dat = convert_temp(dat)
  }

  return(tibble::as_tibble(dat))
}

#' Function to import montly data
import_monthly <- function(station, start_year, end_year, month, table_type,
                           norm_per){
  my_url = paste0("http://climateanalyzer.science/python/make_tables.py?station=",
                  station, "&year1=", start_year, "&year2=", end_year,
                  "&month=", month, "&title=", station,
                  "&table_type=", table_type, "&norm_per=",
                  norm_per, "&csv=true")
  dat = pull_csv(my_url, skip = 2)
  return(tibble::as_tibble(dat))
}


