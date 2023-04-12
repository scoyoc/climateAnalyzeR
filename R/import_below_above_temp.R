#' Import count of days with temperatures below and above user set temps
#'
#'
#' This function imports number of days annually with minimum and maximum daily
#' temperatures below and above user set temperatures.
#' column names.
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param station_id The character string of the \emph{station_id} field from
#'     \code{\link{stations}}.
#' @param start_year The four digit number of the last year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param tmin_temp One to three digit number, including - for temperatures
#'     below zero, for the minimum temperature threshold in Fahrenheit
#' @param tmax_temp One to three digit number for the maximum temperature
#'     threshold in Fahrenheit
#' @param station_type A character string for the type of weather station the
#'     data are being pulled from. Options include "GHCN", "SNOTEL", and "RAWS".
#' @param year A character string for the year period. Options include "year"
#'     for calendar year and "water_year". Default is "year". If using
#'     "water_year"ensure that the start_year is the year prior to the period of
#'     interest.
#'
#' @return A \code{\link[tibble]{tibble}}.
#' @seealso The \code{\link{import_data}} wrapper function.
#' @export
#'
#' @examples
#' library(climateAnalyzeR)
#'
#' import_below_above_temp(station_id = "tumacacori", start_year = 1991, end_year =
#'2020, tmin_temp = 20, tmax_temp = 100, station_type = "GHCN", year = "year")
#'

import_below_above_temp <- function(station_id, start_year, end_year, tmin_temp,
                                    tmax_temp, station_type, year = NULL){

  if(is.null(year)){year = year}
  my_url = paste0("http://climateanalyzer.science/python/u_thresh.py?station=",
                  station_id, "&year1=",
                  start_year, "&year2=",
                  end_year, "&title=",
                  station_id, "&lowerthresh=",
                  tmin_temp, "&upperthresh=",
                  tmax_temp, "&station_type=",
                  station_type, "&csv=true&param=temperature&time_mode=",
                  year,"&first_month=01&last_month=12&ann_sum=False&screen_blanks=False")
  dat = utils::read.csv(my_url, skip = 3)

  # Makes character columns numeric
  sapply(dat, class)
  char <- sapply(dat, is.character)
  dat[ , char] <- as.data.frame(apply(dat[ , char], 2, as.numeric))

  #Remove extra column without data
  dat[8] <- NULL


  names(dat) = janitor::make_clean_names(names(dat))
  return(tibble::as_tibble(dat))

}

