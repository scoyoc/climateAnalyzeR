#' Read daily weather data from ClimateAnalyzer.org into R
#'
#' @param station The character string of the station name.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#'
#' @return A \code{\link[tibble:tibble]{tibble}}.
#'
#' @export
#'
#' @examples
#' import_daily("arches", 2010, 2020)
#'
import_daily <- function(station, start_year, end_year){
  my_url = paste0("http://climateanalyzer.science/python/u_thresh.py?station=",
                  station, "&year1=", start_year, "&year2=", end_year, "&title=",
                  station, "&lowerthresh=daily&upperthresh=70&station_type=GHCN&csv=true&param=temperature&time_mode=year&first_month=01&last_month=12&ann_sum=False&screen_blanks=False")
  dat = pull_csv(my_url, skip = 2)
  return(tibble::as_tibble(dat))
}
