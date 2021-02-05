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
#' import_monthly("arches", 2000, 2020, month = "all", table_type = "straight",
#'                norm_per = 'null')
#' import_montly_wx('arches', 2000, 2010)
#' import_monthly_depart('arches', 2000, 2010)
#' @export import_monthly
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

#' @export
#' @rdname import_monthly
#' @param station The character string of the station name.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param month The month number (i.e., 1 for January through 12 for December)
#'     or 'all' for all months.
import_montly_wx <- function(station, start_year, end_year, month = 'all'){
  dat = import_monthly(station, start_year, end_year, month,
                          table_type = "straight", norm_per = 'null')
  return(tibble::as_tibble(dat))
}

#' @export
#' @rdname import_monthly
#' @param station The character string of the station name.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param month The month number (i.e., 1 for January through 12 for December)
#'     or 'all' for all months.
#' @param norm_per A character string for the 30-year normalization period.
import_monthly_depart <- function(station, start_year, end_year,
                                     month = 'all', norm_per = '1981-2010'){
  dat = import_monthly(station, start_year, end_year, month = month,
                 table_type = "30dep", norm_per = norm_per)
  return(tibble::as_tibble(dat))
}
