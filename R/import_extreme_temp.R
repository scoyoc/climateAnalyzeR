#' Import count of days with extreme temperatures
#'
#'
#' This function imports number of days annually with minimum temperatures below
#' the 5th percentile temperature and number of days above the 95th percentile,
#' mean consecutive days and max consecutive days of each. The 5th and 95th
#' percentile temps are relative to the time period chosen and are found in the
#' column names.
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param station_id The character string of the \emph{station_id} field from
#'     \code{\link{stations}}.
#' @param start_year The four digit number of the last year of interest.
#' @param end_year The four digit number of the last year of interest.
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
#' import_extreme_temp (station_id = "tumacacori", start_year = 1991, end_year =
#'2020, station_type = "GHCN", year = "year")
#'

import_extreme_temp <- function(station_id, start_year, end_year, station_type,
                                year = NULL){

  if(is.null(year)){year = year}
  my_url = paste0("http://climateanalyzer.science/python/u_thresh.py?station=",
                  station_id, "&year1=", start_year, "&year2=", end_year, "&title=",
                  station_id, "&lowerthresh=percentile&upperthresh=90&station_type=",
                  station_type, "&csv=true&param=temperature&time_modeyear=",
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

# import_data("extreme_temp", "tumacacori", 1980, 2022,"GHCN", "year")
# import_data("monthly_wx", "tumacacori", 1980, 2022)
# import_data("daily_wx", "hans_flat_rs", 2010, 2020,"GHCN")
# import_data("annual_wx", "canyonlands_theneck", 1980, 2020)

# import_extreme_temp <- function(station_id, start_year, end_year, station_type,
#                                 convert = FALSE){
#   my_url = paste0("http://climateanalyzer.science/python/u_thresh.py?station=",
#                   station_id, "&year1=", start_year, "&year2=", end_year, "&title=",
#                   station_id, "&lowerthresh=percentile&upperthresh=90&station_type=",
#                   station_type, "&csv=true&param=temperature&time_mode=year&first_month=01&last_month=12&ann_sum=False&screen_blanks=False")
#   dat = read_csv(my_url, skip = 2)
#   dat = rename_vars(dat)
# }

# import_data("below_above_temp", "tumacacori", 1979, 1980,32, 100, "GHCN","water_year")
